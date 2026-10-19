import json
with open('orders_batch_01.json','r') as file:
    data_file = json.load(file)
    print('full_data:',data_file)

print(type(data_file))
print(len(data_file))
print('\n')

valid_orders = []

rejected_orders = []

seen_orders = set()

for item in data_file:
    order_id = item['order_id']
    amount = item['amount_usd']
    if order_id not in seen_orders and item['amount_usd'] > 0:
        seen_orders.add(order_id)
        total_amount_inr = item['amount_usd'] * 95
        cleaned_data = {
            'order_id' : order_id,
            'customer_id': item['customer']['id'],
            'customer_name': item['customer']['name'],
            'customer_email': item['customer']['email'],
            'city': item['customer']['city'],
            'order_timestamp': item['timestamp'],
            'total_amount_inr': amount * 95, 
            'order_status': item['status'],
        }
        valid_orders.append(cleaned_data)
    else:
        rejected_orders.append(item)

print('valid_data:', (seen_orders))
print(len(seen_orders))
print(type(seen_orders))
print("\n")
print('rejected_data:',rejected_orders)
print(len(rejected_orders))
print(type(rejected_orders))

print('valid_data:',valid_orders)
print(len(valid_orders))
print(type(valid_orders))


# order_id,customer_id, order_timestamp,total_amount_inr,order_status,ingested_at, customer_id,customer_name,customer_email,city,created_at


with open('rejected_records.log', 'w') as rejected:
    json.dump(rejected_orders, rejected, indent=4)



customer_items_data = []
orders_items_data = []

for item in valid_orders:
    cust_items = (
    item['customer_id'],
    item['customer_name'],
    item['customer_email'],
    item['city'],
)
    customer_items_data.append(cust_items)

for item in valid_orders:
    order_item = (
        item['order_id'],
        item['customer_id'],
        item['order_timestamp'],
        item['total_amount_inr'], 
        item['order_status'].lower(),
)
    orders_items_data.append(order_item)

import os
import oracledb
from dotenv import load_dotenv

load_dotenv()

try:
    connection = oracledb.connect(
    user=os.getenv('DB_USER'),
    password=os.getenv('DB_PASSWORD'),
    dsn=os.getenv('DB_DSN')
    )
    cursor = connection.cursor()

    customer_sql = """
                    insert into dim_customers(customer_id,customer_name,customer_email,city)
                    values (:1,:2,:3,:4)
    """
    order_sql = """
                    insert into fact_orders(order_id,customer_id,order_timestamp,total_amount_inr,order_status)
                    values (:1,:2,TO_TIMESTAMP_TZ(:3, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),:4,:5)
"""
    cursor.executemany(customer_sql,customer_items_data)
    cursor.executemany(order_sql,orders_items_data)

    connection.commit()
    print("Pipeline executed successfully! Data loaded into Oracle SQL.")
except Exception as e:
    print("Error while connecting the database:", e)
    connection.rollback()
finally:
    cursor.close()
    connection.close()




