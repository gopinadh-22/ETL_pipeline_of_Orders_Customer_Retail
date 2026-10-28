SELECT
    SYSDATE
FROM
    DUAL; -- this dual is used from free oracle sql ide for running and remaining all the tables which are used below are same as this.

SELECT
    *
FROM
    HR.DEPARTMENTS;

select employee_id,email, hire_date, sysdate from hr.EMPLOYEES;

SELECT systimestamp from dual;

select days, systimestamp, add_months(systimestamp, 2)as after_two_months_for_current_month from dual
where days = after_two_months_for_current_month - systimestamp;

select systimestamp, last_day(systimestamp)as last_day_for_current_month from dual;

select systimestamp, next_day(systimestamp, 5)as next_day_for_current_month from dual;

select systimestamp, next_day(systimestamp, 'tuesday')as next_day_for_current_month from dual;

select systimestamp, current(systimestamp)as current_day_for_current_month from dual;

select add_months(HIRE_DATE,3),floor((add_months(HIRE_DATE,3) - HIRE_DATE)/30) as working_period_in_months,HIRE_DATE from hr.EMPLOYEES;

select EXTRACT (year from sysdate) as year from dual;

select e.*, extract(year from hire_date) as hire_year, count(hire_year) from hr.EMPLOYEES e
order by HIRE_DATE;

select * from hr.EMPLOYEES;

SELECT JOB_ID, count(JOB_ID) as count_per_job_id
from hr.EMPLOYEES
group by JOB_ID;

select e.*, count(JOB_ID)
over (partition by JOB_ID) as employees_per_job
from hr.EMPLOYEES e;


select * from 
(select e.*,
row_number() over(partition by JOB_ID order by salary desc) as desc_salaries
from hr.EMPLOYEES e) x
where desc_salaries = 1;

select e.*,
row_number() over(partition by JOB_ID order by salary desc) as desc_salaries
from hr.EMPLOYEES e;

-- aggregate functions: sum,count,max,min,avg

-- analytical functions: row_number(it will give the continuously wheather it is duplicate or not),rank(it will skip the value, if any duplicate is there),dense_rank(it will give the all the values continuoulsy if it is duplicate also),lead(depends on next values),lag(depends on previous values),first_value(it will take the very first value to the whole set of group),last_value(it will give the last_value for the rest of the set records).

-- using of row_number() finding of top-5 highest salaries.

select *
from (
    select e.EMPLOYEE_ID, e.FIRST_NAME,salary, 
    row_number() over(order by salary desc) as highest_paid_employees_using_row_number
    from hr.EMPLOYEES e)
where highest_paid_employees_using_row_number <= 5;

-- find employees with top-3 salary ranks using dense_rank() 
-- includes employees having same salary

select * from
(
select employee_id,FIRST_NAME,salary,
DENSE_RANK() over(order by salary DESC) as top_3_salaries
from hr.EMPLOYEES)
where top_3_salaries <= 3;


-- Rank employees based on highest salary
-- same salary = same rank, next salary may be skipped

select employee_id,FIRST_NAME,salary,
RANK() over(order by salary DESC) as top_salaries
from hr.EMPLOYEES;


--  show the year each employee joined

SELECT EMPLOYEE_ID,FIRST_NAME, extract(year from hire_date) as joining_year from hr.EMPLOYEES;

SELECT EMPLOYEE_ID,FIRST_NAME, to_char(hire_date, 'yyyy') as joining_year from hr.EMPLOYEES
order by HIRE_DATE;

--  show the month each employee joined
-- to_char is useful for to extract specific thing from timestamp or anyother

SELECT EMPLOYEE_ID,FIRST_NAME, to_char(hire_date, 'mm') as joining_month from hr.EMPLOYEES;


-- this will give you the names of the months of joining dates januaray/febuary like that using of to_char and 'fmmonth'
SELECT EMPLOYEE_ID,FIRST_NAME, to_char(hire_date, 'fmmonth') as joining_month from hr.EMPLOYEES;

-- show the day each employee joined
SELECT EMPLOYEE_ID,FIRST_NAME, to_char(hire_date, 'dd') as joining_day from hr.EMPLOYEES;

-- show the weekday each employee joined like monday or tuesday like that using to_char and 'fmday'
SELECT EMPLOYEE_ID,FIRST_NAME, to_char(hire_date, 'fmday') as joining_weekday from hr.EMPLOYEES;

-- show me who joined in 2015
SELECT EMPLOYEE_ID,FIRST_NAME, hire_date from hr.EMPLOYEES
where to_char(HIRE_DATE, 'yyyy') = 2015
order by HIRE_DATE;

SELECT EMPLOYEE_ID,FIRST_NAME, hire_date from hr.EMPLOYEES
where to_char(HIRE_DATE, 'yyyy') between 2005 and 2015
order by HIRE_DATE;

-- show me who joined in january

SELECT EMPLOYEE_ID,FIRST_NAME, to_char(HIRE_DATE, 'fmmonth') as months from hr.EMPLOYEES
where to_char(HIRE_DATE, 'fmmonth') = 'january';





