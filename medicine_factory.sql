create table patients(patient_id int primary key,patient_name varchar(255));
insert into patients values(123,"sameer"),(124,"sampath"),(125,"kushwanth"),(126,"khadeer");
select * from patients;

create table medicines(medicine_id int primary key,patient_id int,medicine_orderd varchar(255),
foreign key(patient_id) references patients(patient_id));
insert into medicines values(900,123,"DOLO-650"),(901,124,"PARACITMOL"),(902,125,"CITRIZEN"),
(903,126,"SARIDON");
select * from medicines;
select * from medicines inner join patients on medicines.patient_id=patients.patient_id;

create table doctors(doctor_id int primary key,doc_dep varchar(255),patient_id int,foreign key(patient_id)
references patients(patient_id));
insert into doctors values(800,"RMP",123),(801,"General_Practitioner",124),
(802,"Pediatrician",125),(803,"Psychiatrist",126);
select * from doctors;
select * from doctors inner join patients on doctors.patient_id=patients.patient_id;

create table prescriptions(prescriptions_id int primary key,doctor_id int,patient_id int,
medicine_id int, prescriptions_given varchar(255),foreign key(doctor_id) references doctors(doctor_id),
foreign key(patient_id) references
patients(patient_id),foreign key(medicine_id) references medicines(medicine_id));
insert into prescriptions values(3434,800,123,900,"Eveing_morning"),(3435,801,124,901,"Eveing"),
(3436,802,125,902,"Eveing"),(3437,803,126,903,"Eveing_morning");
select * from prescriptions;
select * from prescriptions inner join doctors on prescriptions.doctor_id=doctors.doctor_id inner join 
patients on prescriptions.patient_id=patients.patient_id inner join medicines on prescriptions.medicine_id=
medicines.medicine_id;

create table medicine_orders (order_id int primary key,patient_id int,doctor_id int,medicine_id int,quantity int,
order_date date,price bigint,order_status varchar(255),foreign key(patient_id) references patients(patient_id),
foreign key(doctor_id) references doctors(doctor_id),foreign key(medicine_id) references medicines(medicine_id));
insert into medicine_orders values(8383,123,800,900,6,"2024-05-11",3000,"completed"),
(8384,124,801,901,9,"2026-01-12",6700,"completed"),(8385,125,802,902,3,"2025-02-01",1000,"not-completed"),
(8386,126,803,903,2,"2026-07-19",1900,"not-completed"),  (8387,123,800,900,3,"2024-09-11",2000,"not-completed"),
(8388,124,801,901,5,"2026-11-02",3200,"completed"),(8389,125,802,902,7,"2025-10-31",5000,"completed"),
(8390,126,803,903,9,"2026-01-09",7100,"completed");
select * from medicine_orders inner join patients on medicine_orders.patient_id=patients.patient_id inner join
doctors on medicine_orders.doctor_id=doctors.doctor_id inner join medicines on medicine_orders.medicine_id=
medicines.medicine_id;

with individual_greater as 
(select p.patient_id,p.patient_name,m.price from patients p inner join medicine_orders m 
on p.patient_id=m.patient_id where m.order_status="completed" group by m.patient_id,m.price
having count(order_id)>1 and max(price)>2000)
select * from individual_greater;

select count(order_status) from medicine_orders where order_status="completed";
select sum(price) as amount_spent from medicine_orders where order_status="completed";
SELECT
    order_id,
    patient_id,
    quantity,
    price,
    quantity * price AS order_value
FROM medicine_orders;

select max(price) as highest_individual_order from medicine_orders where order_status="completed"
group by patient_id;

select min(price) as lowest_individual_order from medicine_orders where order_status="completed"
group by patient_id;

select year(order_date) as year_of_medicine_order from medicine_orders;

select month(order_date) as months_of_medicine_order from medicine_orders;

select day(order_date) as days_of_medicine_order from medicine_orders;

select datediff("2026-10-07",order_date) as date_diff_from_years from medicine_orders;

select date_add("2026-10-07",interval 30 day) as excepted_days from medicine_orders where order_status="completed";

select date_sub("2026-10-07",interval 07 day) as review_days from medicine_orders where order_status="completed";

WITH total_spendings AS (
    SELECT
        m.patient_id,
        d.doc_dep,
        SUM(m.price) AS total_spendings
    FROM medicine_orders m
    INNER JOIN doctors d
        ON m.doctor_id = d.doctor_id
    WHERE m.order_status = 'completed'
    GROUP BY m.patient_id, d.doc_dep
)
SELECT
    patient_id,
    doc_dep,
    total_spendings,
    RANK() OVER (
        PARTITION BY doc_dep
        ORDER BY total_spendings DESC
    ) AS spending_rank
FROM total_spendings;


WITH order_comparison AS (
    SELECT
        patient_id,
        order_id,
        order_date,
        quantity * price AS current_order_value,

        LAG(quantity * price) OVER (
            PARTITION BY patient_id
            ORDER BY order_date
        ) AS previous_order_value

    FROM medicine_orders
    WHERE order_status = 'completed'
)

SELECT
    patient_id,
    order_id,
    order_date,
    current_order_value,
    previous_order_value,

    CASE
        WHEN previous_order_value IS NULL THEN 'No Previous Order'
        WHEN current_order_value > previous_order_value THEN 'Increased'
        WHEN current_order_value < previous_order_value THEN 'Decreased'
        ELSE 'Remained Same'
    END AS spending_change

FROM order_comparison;





