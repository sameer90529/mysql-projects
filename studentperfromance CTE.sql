create table students(student_id int primary key,student_name char(45),
student_dep varchar(255),stud_marks int);
insert into students values(123,"sameer","AI-DS",889),
(124,"sampath","AI-ML",859),
(125,"samuel","AI",989),
(126,"sakthi","DS",789);
alter table students add column age int;
update  students set age=19 where student_id=123;
update students set age=21 where student_id=124;
update students set age=20 where student_id=125;
update  students set age=12 where student_id=126;

  
with older as 
(select * from students where age > 20)
select count(*) from older;

with student_departments as
(select student_dep,count(student_name)as student_names from students group by student_dep)
select * from student_departments order by student_names desc 
limit 1 ;

with student_max_scores as
(select max(stud_marks)as scored_by_student from students)
select * from student_max_scores;

with avgscores as
(select * from students where stud_marks >
(select avg(stud_marks) as above_average_marks from students))
select * from avgscores;

with avg_age as
(select * from students where age >
(select avg(age) as greater_than_average_age from students))
select * from avg_age;

with highest as
(select * from students where stud_marks=
(select max(stud_marks) as highest_marks from students))
select * from highest;

WITH avg_marks_scoring AS
(
    SELECT student_dep,
           AVG(stud_marks) AS average_marks
    FROM students
    GROUP BY student_dep
    HAVING AVG(stud_marks) > 75
)
SELECT *
FROM avg_marks_scoring;

WITH rank_departments AS
(
    SELECT student_id
           student_name,
           student_dep,
           stud_marks,
           RANK() OVER (
               PARTITION BY student_dep
               ORDER BY student_id DESC
           ) AS department_rank
    FROM students 
)
SELECT *
FROM rank_departments;

WITH rank_departments AS
(
    SELECT
        student_dep,
        count(student_id) AS student_count,
        RANK() OVER (
            ORDER BY COUNT(student_id) DESC
        ) AS department_rank
    FROM students
    GROUP BY student_dep
)
SELECT *
FROM rank_departments;
