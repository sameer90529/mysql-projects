create table doctors (doctor_id int primary key,doctor_name char(45));
insert into doctors values(123,"sameer"),(124,"sampath"),(125,"kushwanth"),(126,"kumar");
select * from doctors;

create table departments (dep_id int primary key,dep_name varchar(255),doctor_id int,total_patients_treated int,foreign key(doctor_id) references doctors(doctor_id));
insert into departments values(4545,"CARDIOLIGST",123,400),(4646,"DENIST",124,340),(4747,"SAICRIASTIC",125,410),(4848,"PERMINOLIGST",126,343);
select * from departments ;
select * from departments inner join doctors on departments.doctor_id=doctors.doctor_id;

create table treatment(doctor_id int,dep_id int,sucessful_treatments int,failed_treatment int,total_patients int ,foreign key(doctor_id) references doctors(doctor_id),foreign key(dep_id) references departments(dep_id));

insert into treatment values(123,4545,230,170,400),(124,4646,200,140,340),(125,4747,230,180,410),(126,4848,193,150,343);
select * from treatment;
select * from treatment inner join doctors on treatment.doctor_id=doctors.doctor_id inner join 
departments on treatment.dep_id=departments.dep_id;

create table payments(payment_id int,doctor_id int,dep_id int,consultation_revenue bigint,foreign key(doctor_id) references doctors(doctor_id),foreign key(dep_id) references departments(dep_id));

insert into payments values(9090,123,4545,5000000),(9091,124,4646,4700000),(9092,125,4747,4300000),(9093,126,4848,4100000);
select * from payments;
select * from payments inner join doctors on payments.doctor_id=doctors.doctor_id;

create table ratings(rating_id int primary key,doctor_id int,dep_id int,rating_given decimal,foreign key(doctor_id) references doctors(doctor_id),foreign key(dep_id) references departments(dep_id));
insert into ratings values(8989,123,4545,4.5),(8988,124,4646,4.2),(8987,125,4747,4.1),(8986,126,4848,4.3);
select * from ratings;
select * from ratings inner join doctors on ratings.doctor_id=doctors.doctor_id inner join departments on ratings.dep_id=departments.dep_id;

select avg(rating_given) as average_ratings from ratings;
select doctor_id,dep_id,sucessful_treatments from treatment;

with avg_revenue as
(select avg(consultation_revenue) as above_revenue from payments)
select d.doctor_id,d.doctor_name,e.dep_id,e.dep_name,r.consultation_revenue from doctors d inner join departments e on
d.doctor_id=e.doctor_id inner join payments r on d.doctor_id=r.doctor_id
where r.consultation_revenue > (select above_revenue from avg_revenue);

with avg_patients as
(select avg(total_patients) as above_patients from treatment)
select d.doctor_id,d.doctor_name,e.dep_id,p.total_patients from doctors d inner join departments e on 
d.doctor_id=e.doctor_id inner join treatment p on d.doctor_id=p.doctor_id
where p.total_patients >(select above_patients from avg_patients);

select doctor_id,dep_id from ratings where rating_given > 4.5;

select (sucessful_treatments/total_patients)*100 as percentages from treatment where (sucessful_treatments/total_patients)*100  > 90;

select doctor_id,dep_id,dense_rank() over ( order by consultation_revenue desc) as 
ranking_best from payments;

select doctor_id,dep_id,consultation_revenue,lag(consultation_revenue) over (order by doctor_id desc) 
as previous_revenue from payments;

select doctor_id,dep_id,consultation_revenue,lead(consultation_revenue) over (order by doctor_id desc) 
as previous_revenue from payments;

select doctor_id,dep_id,consultation_revenue,row_number() over (order by consultation_revenue) as row_numbers from payments;

alter table ratings add column classification varchar(45);
update ratings set classification="excellent" where doctor_id=123;
update ratings set classification="need-to-be-improve" where doctor_id=124;
update ratings set classification="good" where doctor_id=125;
update ratings set classification="keep-going" where doctor_id=126;
select * from ratings;

select dep_id,doctor_id,consultation_revenue,rank() over (order by consultation_revenue)as ranking 

 from payments where consultation_revenue <=3 ;












