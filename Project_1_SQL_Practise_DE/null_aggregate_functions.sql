select coalesce(null, NULL, 'oracle', 'sql') coalesce_table from dual;

select coalesce(*,null) from hr.EMPLOYEES;


select JOB_ID
from hr.EMPLOYEES
GROUP by JOB_ID
having count(job_id) > 3;


select * from hr.EMPLOYEES 
where salary > (
select avg(salary) from hr.EMPLOYEES
);

select EMPLOYEE_ID,FIRST_NAME,LAST_NAME,salary,
avg(salary) over () as avg_salary,
salary - avg(salary) over() as diff_from_avg
from hr.EMPLOYEES;



select *
from 
(select EMPLOYEES.DEPARTMENT_ID, avg(salary) as avg_sal
from hr.EMPLOYEES
group by DEPARTMENT_ID)
where avg_sal > 7000;


select employee_id,first_name,DEPARTMENT_ID,salary
from hr.EMPLOYEES 
where DEPARTMENT_ID = (
select DEPARTMENT_ID
from hr.EMPLOYEES
where salary = (
select min(salary)
from hr.EMPLOYEES
));


--  here we are printing each department highest salary from hr.employees table

select employee_id,first_name,DEPARTMENT_ID,salary,row_num 
from
(select employee_id,first_name,DEPARTMENT_ID,salary,
row_number() over (partition by DEPARTMENT_ID order by salary desc) as row_num
from hr.EMPLOYEES)
where row_num < 2
ORDER by salary desc;