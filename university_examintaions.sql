create table departments(dep_id int primary key,dep_name varchar(255),faculty_name varchar(255));
insert into departments values(900,"AI-DS","NOORJAHA"),(901,"AI-ML","JANSI"),(902,"AI","KAJAWALI"),
(903,"IT","VENU"),(904,"ECE","MADHU");
select * from departments;

create table students(student_id int primary key,student_name varchar(255),dep_id int,
city varchar(255),foreign key(dep_id) references departments(dep_id));
insert into students values(123,"sameer",900,"ongole"),(124,"sampath",901,"chirala"),(125,"khadeer",902,"nellore"),
(126,"kushwant",903,"kadapa"),(127,"varun",904,"chitoor");
select * from students;
select * from students inner join departments on students.dep_id=departments.dep_id;


create table exam_results(result_id int primary key,student_id int,semester int,exam_date date,
subject_name varchar(255),marks_obtained int,maximum_marks int,result_status varchar(255),foreign key(student_id)
references students(student_id));
insert into exam_results values(800,123,2,"2026-01-20","Applied_Maths",34,100,"Failed"),
(801,124,4,"2026-10-12","Java-programming",84,100,"Pass"),
(802,125,3,"2026-11-09","Cloud-Computing",44,100,"Failed"),
(803,123,3,"2026-10-29","Mobile_computing",NULL,100,"Absent"),
(804,123,2,"2026-01-20","DBMS",94,100,"Pass");
select * from exam_results;
select * from exam_results inner join students on exam_results.student_id=students.student_id;

create table fee_payments(payment_id int primary key,student_id int,payment_date date,amount_paid bigint,
payment_status varchar(255),foreign key(student_id) references students(student_id));
insert into fee_payments values(700,123,"2025-12-12",75000,"Completed"),(701,124,"2026-01-12",65000,"pending"),
(702,125,"2026-05-02",85000,"Completed"),(703,126,"2026-08-22",55000,"Completed"),
(704,127,"2025-12-21",NULL,"pending");
select * from fee_payments;
select * from fee_payments inner join students on fee_payments.student_id=students.student_id;

with avg_marks as 
(select s.student_id,s.student_name,avg(e.marks_obtained * 100.0/e.maximum_marks) as average_marks 
from students s inner join exam_results e on s.student_id=e.student_id where result_status="Pass"
group by s.student_id,s.student_name)
select student_id,student_name from avg_marks group by student_id,student_name 
having avg(average_marks)>85;

select avg(marks_obtained * 100.0/maximum_marks) as avg_marks_percentage from exam_results where 
result_status="Pass";
select subject_name,max(marks_obtained * 100.0/maximum_marks) as highest_subject_percentage from exam_results 
where result_status ="Pass" group by subject_name;
select sum(amount_paid) as total_sucessful_payments from fee_payments where payment_status="Completed";
select sum(amount_paid) as remaining_payments from fee_payments where payment_status="pending";

select coalesce(marks_obtained,0) as missing_marks from exam_results;
select coalesce(amount_paid,0) as missing_amount from fee_payments;

with ranking_students as 
(select s.student_id,s.student_name,avg(e.marks_obtained * 100.0/e.maximum_marks) as avg_marks_percentage,
rank() over (partition by s.dep_id order by student_id desc) as ranking_depeartment_wise from 
students s inner join exam_results e on s.student_id=e.student_id where result_status="Pass" 
group by s.student_id,s.student_name)
select * from ranking_students;


with ranks as 
(select s.student_id,s.dep_id,s.student_name,avg(e.marks_obtained * 100.0/e.maximum_marks) as avg_marks_percentage
from students s inner join exam_results e on s.student_id=e.student_id where result_status="Pass"
group by s.student_id,s.dep_id,s.student_name)
select student_id,student_name,avg_marks_percentage,rank() over (partition by dep_id order by student_id 
desc) as ranking_depeartment_wise from ranks group by student_id,student_name;

WITH semester_avg AS (
    SELECT
        s.student_id,
        e.semester,
        AVG(e.marks_obtained * 100.0 / e.maximum_marks)
            AS semester_avg
    FROM students s
    INNER JOIN exam_results e
        ON s.student_id = e.student_id
    WHERE e.result_status = 'Pass'
    GROUP BY s.student_id, e.semester
),
semester_comparison AS (
    SELECT
        student_id,
        semester,
        semester_avg,
        LAG(semester_avg) OVER (
            PARTITION BY student_id
            ORDER BY semester
        ) AS previous_semester_avg
    FROM semester_avg
)
SELECT
    student_id,
    semester,
    semester_avg,
    previous_semester_avg,
    CASE
        WHEN previous_semester_avg IS NULL
            THEN 'No Previous Semester'
        WHEN semester_avg > previous_semester_avg
            THEN 'Improved'
        WHEN semester_avg < previous_semester_avg
            THEN 'Declined'
        ELSE 'Remained Same'
    END AS semester_trend
FROM semester_comparison;

with datedifference as 
(select datediff(p.payment_date,e.exam_date) as date_differnce from exam_results e inner join
fee_payments p on e.student_id=p.student_id)
select * from datedifference;

select year(exam_date) as year_of_exam_date from exam_results;
select month(exam_date) as month_of_exam_date from exam_results;
select * from fee_payments where payment_status="pending";



















