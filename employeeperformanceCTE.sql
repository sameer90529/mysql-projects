
create table employees(emp_id int primary key,emp_name char(45),dep_id int);
insert into employees values(123,"sameer",9090),(124,"sampath",9091),
(125,"kishore",9092),(126,"kiran",9093),(127,"ravi",9094),(138,"revanth",9094),(128,"ramu",9092),
(129,"ravi",9093),(130,"ravi",9094),(131,"ravi",9092),(132,"ravi",9093),(133,"khadeer",9092),(134,"venu",9092),
(135,"pranav",9092),(136,"praneeth",9092),(137,"lokesh",9094),(139,"mani",9094),(140,"keshava",9094),
(141,"kalesha",9094);
select * from employees;

create table departments(dep_id int primary key,emp_id int,dep_name varchar(255),
foreign key(emp_id) references employees(emp_id));

insert into departments values(9090,123,"HR"),(9091,124,"MANAGER"),
(9092,125,"TRAINEE"),(9093,126,"TEAM-LEADER"),(9094,127,"DATA-ANALYST");
select * from departments;
select * from departments inner join employees on departments.dep_id=employees.dep_id;

create table salary_detalis (salary_id int primary key,dep_id int,emp_id int,salary_paying int,
foreign key(dep_id) references departments(dep_id),foreign key(emp_id) references employees(emp_id));

insert into salary_detalis values(143,9090,123,90000),(144,9091,124,67000),
(145,9092,125,80000),(146,9093,126,32000),(147,9094,127,89230),(148,9092,128,82993),
(149,9094,139,89992),(150,9094,140,892893),(151,9094,141,89897),(152,9094,137,89483),(153,9094,138,89675);
select * from salary_detalis;
select * from salary_detalis inner join departments on salary_detalis.dep_id=departments.dep_id
 inner join employees on salary_detalis.emp_id=employees.emp_id;

create table performance(per_id int primary key,emp_id int,dep_id int,rating decimal
,foreign key(dep_id) references departments(dep_id), foreign key(emp_id) references employees(emp_id));

insert into performance values(777,123,9090,4.2),(778,124,9091,4.7),(779,125,9092,3.1),(780,126,9093,4.9),
(781,131,9092,2.9),(782,133,9092,2.4),(783,134,9092,2.1),(784,135,9092,2.3),(785,136,9092,2.5),
(786,130,9094,3.2),(787,138,9094,3.1),(789,137,9094,1.5),(790,139,9094,2.4),(791,132,9093,3.4);

select * from performance;
select * from performance inner join employees on performance.emp_id=employees.emp_id
 inner join departments on performance.dep_id=departments.dep_id;

 with avg_salary as 
 (select * from salary_detalis where salary_paying>(select avg(salary_paying) from salary_detalis))
 select * from avg_salary;

 select emp_id,dep_id,rating from performance where emp_id is not null order by rating desc; 


 WITH avg_salary AS
 (
     SELECT AVG(salary_paying) AS above_avg_paid
     FROM salary_detalis
 ),
 above_departments AS
 (
     SELECT e.dep_id
     FROM employees e
     INNER JOIN salary_detalis s
         ON e.emp_id = s.emp_id
     GROUP BY e.dep_id
     HAVING COUNT(e.emp_id) > 5
        AND AVG(s.salary_paying) > 80000
 )
 
 SELECT *
 FROM above_departments;

select emp_id,dep_id from performance  where rating < 4.0 order by rating desc;

select dep_id,dense_rank() over (order by salary_paying desc )as ranking_employees from salary_detalis;

WITH employee_rank AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.dep_id,
        s.salary_paying,
        RANK() OVER
        (
            PARTITION BY e.dep_id
            ORDER BY s.salary_paying DESC
        ) AS emp_rank
    FROM employees e
    INNER JOIN salary_detalis s
        ON e.emp_id = s.emp_id
)

SELECT *
FROM employee_rank
WHERE emp_rank <= 3;






 
 










