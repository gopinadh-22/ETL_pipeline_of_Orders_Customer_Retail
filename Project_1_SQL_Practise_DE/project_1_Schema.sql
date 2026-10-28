-- we are creating schema for fact_orders & dim_customers

create table dim_customers(
    customer_id varchar2(30) primary key,
    customer_name varchar2(100) not null,
    customer_email varchar2(50),
    city varchar2(50),
    created_at timestamp default current_timestamp not null
);

create table fact_orders(
    order_id varchar2(30) primary key,
    customer_id varchar2(30) not null,
    order_timestamp timestamp not null,
    total_amount_inr number(10,2) not null,
    order_status varchar2(20) not null,
    ingested_at timestamp default current_timestamp not null,
    constraint fk_cust_id foreign key (customer_id) references dim_customers(customer_id),
    constraint chk_or_status check (order_status in ('pending', 'processing', 'completed', 'refunded'))
);

create index cust_id on fact_orders (customer_id);
create index idx_order_timestamp on fact_orders(order_timestamp);

select * from fact_orders;
select * from dim_customers;


SELECT 
    order_id,
    customer_id,
    order_timestamp,
    ingested_at,
    total_amount_inr
FROM fact_orders;

-- total revenue groupby city
select dc.city, sum(total_amount_inr) as total_revenue, 
count(order_id) as total_orders
from fact_orders f 
join DIM_CUSTOMERS dc on f.customer_id = dc.customer_id
where order_status = 'completed'
group by dc.city
order by total_revenue desc;

select sum(total_amount_inr) from fact_orders;
select avg(total_amount_inr) as average_amount from fact_orders;
select min(total_amount_inr) as minimum_amount from fact_orders;
select max(total_amount_inr) as maximum_amount from fact_orders;



create table emp(
    employee_id varchar2(3),
    employee_name varchar2(50),
    manager_id varchar2(3)
);

insert into emp 
values(1,'jim',null);
insert into emp 
values(2,'jeim',20);
insert into emp 
values(3,'jaim',30);
insert into emp 
values(4,'jims',40);
insert into emp 
values(5,'jimwq',50);


-- find employees who are managers

select * from EMP
where MANAGER_ID <> 'null';