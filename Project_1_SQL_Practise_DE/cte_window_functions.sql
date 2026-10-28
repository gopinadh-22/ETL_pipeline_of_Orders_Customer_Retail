--  first example of query using with (cte) clause
with empl_sal as (
    select salary
    from hr.employees
    where salary < 6000
    order by salary desc
)
select * from empl_sal;


-- for each department the highest salary we are taking out and printing it.
-- using of both with clause(cte) and the partition by over window function.

with highest_salary_from_each_dept as (
(
select employee_id,first_name,job_id,department_id,salary,
row_number() over(partition by department_id order by salary desc) as r_num 
from hr.employees) 
)
select * from highest_salary_from_each_dept
where r_num < 2
order by salary desc;



-- with clause ----> subquery of again with clause ---> final select.

with sum_of_sal_for_each_dept as(
select department_id, sum(salary) as sum_sal
from hr.EMPLOYEES
group by department_id
),
ranked_department_with_resp_sal as (
select department_id, sum_sal,
dense_rank() over(order by sum_sal desc) as sal
from sum_of_sal_for_each_dept
)
select * from ranked_department_with_resp_sal
order by sum_sal desc;


-- the below one is used only one cte with clause to reperesent the above code result
-- with clause ---> final select query

with ranked_department_with_resp_sal as (
select department_id, salary,
dense_rank() over(partition by department_id order by salary desc) as den_ran
from hr.EMPLOYEES
)
select DEPARTMENT_ID, sum(salary) as total_salary 
from ranked_department_with_resp_sal
group by department_id
order by total_salary DESC;
