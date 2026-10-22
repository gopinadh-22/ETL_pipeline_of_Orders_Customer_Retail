-- ===========================================================
-- Creating PRODUCT Table
-- ===========================================================
create table Product (
    product_id number primary key,
    product_name varchar2(50),
    price number(5,2),
    stock number(5)
);

-- ===========================================================
-- Creating Sales Table
-- ===========================================================
create table Sales (
    sales_id number primary key,
    product_id number,
    quantity number,
    total_amount number,
    constraint fk_prod_id foreign key (product_id) references Product(product_id) 
);

alter table Product
modify price number(10,2);

insert into Product values (101, 'Laptop', 50000, 20);
insert into Product values (102, 'Mobile', 25000, 30);
insert into Product values (103, 'Headphones', 2000, 50);
insert into Product values (104, 'Keyboard', 1500, 40);
insert into Product values (105, 'Mouse', 800, 60);

commit;

select * from PRODUCT;

select * from SALES;

-- delete from product
-- where product_id = '106';

-- ===========================================================
-- creating add product procedure of pl/sql
-- ===========================================================
create or replace procedure add_product (
    p_id in number,
    p_name in varchar2,
    p_price in number,
    p_stock in number
)
as
begin
    insert into PRODUCT values(p_id,p_name,p_price,p_stock);
    commit;
    DBMS_OUTPUT.PUT_LINE('Product Added.');
end;
/

begin
    ADD_PRODUCT(106, 'Monitor', 12000, 10);
end;
/


-- begin
--     ADD_PRODUCT(107, 'Monitor', 12000, 10);
-- end;
-- /

-- delete from PRODUCT
-- where PRODUCT_ID = '107';

-- ===========================================================
-- Updating product price using procedure pl/sql
-- ===========================================================

create or replace procedure update_price(
    p_id in number,
    p_new_price in number
)
as
begin
    update PRODUCT
    set PRODUCT.PRICE = p_new_price
    where PRODUCT.PRODUCT_ID = p_id;
    commit;
    DBMS_OUTPUT.put_line('Product price Updated.');
end;
/

begin
    UPDATE_PRICE (105,1000);
end;
/

-- ===========================================================
-- add stock product using procedure pl/sql
-- ===========================================================

create or replace procedure add_stock(
    p_id in number,
    p_quantity in number
)
as
begin 
    update PRODUCT
    set stock = stock + p_quantity
    where PRODUCT_ID = p_id;
    commit;
    DBMS_OUTPUT.PUT_LINE('Adding stock sucessfully.');
end;
/
begin
    add_stock (102,15);
end;
/

-- ===========================================================
-- Make sales for product using procedure pl/sql
-- ===========================================================

create or replace procedure make_sales(
    s_id in number,
    p_id in number,
    p_quantity in number
)
as
    v_price number;
    v_total number;
begin
    select price into v_price from product
    where product_id = p_id;
    v_total := v_price * p_quantity;

    insert into sales values (s_id,p_id,p_quantity,v_total);

    update product
    set stock = stock - p_quantity
    where product_id = p_id;

    commit;
    DBMS_OUTPUT.put_line('Sale Completed');
    DBMS_OUTPUT.put_line('Total Amount = ' || v_total);

end;
/
begin
    make_sales(1001,102,23);
end;
/


-- ===========================================================
--  Apply Discount for product using procedure pl/sql
-- ===========================================================

create or replace procedure apply_discount (
    p_id in number,
    p_discount in number
)
as 
begin
    update PRODUCT
    set price = price - (price * p_discount /100)
    where PRODUCT_ID = p_id;
    commit;
    DBMS_OUTPUT.PUT_LINE('Discount Applied');
end;
/

begin
    APPLY_DISCOUNT(101,5);
end;
/

begin
    MAKE_SALES(1002,101,2);
end;
/

-- ===========================================================
--  DELETE PRODUCT using procedure pl/sql
-- ===========================================================

create or replace procedure delete_product(
    p_id in number
)
as
begin
    delete from PRODUCT
    where product_id = p_id;
    commit;
    DBMS_OUTPUT.PUT_LINE('Product_Deleted');
end;
/
begin
    DELETE_PRODUCT(106);
end;
/
