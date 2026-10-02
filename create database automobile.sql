create database automobile;
use automobile;

create table service_center(center_id int primary key,center_name varchar(255),center_city varchar(255));
insert into service_center values(123,"RK-BALAJI-CENTER","ONGOLE"),(124,"KISHAN-VEHICLE-CENTER","VAISAC"),
(125,"RAVI-BABU-SERVICE","VIJAYAWADA"),(126,"VISHNU-AUTOMOBILE-SERVICE","GUNTUR");
select * from service_center;

create table customer(customer_id int primary key,center_id int,vehicle_type varchar(255),service_date date,
foreign key(center_id) references service_center(center_id));
insert into customer values(900,123,"BIKE","2026-02-21"),(901,124,"CAR","2026-06-12"),(902,125,"LORRY","2026-06-22"),
(903,126,"JCB","2026-09-30"),(904,123,"TRUCK","2026-04-01"),(905,124,"BICYCLE","2026-03-02"),(906,125,"VAN","2026-04-22"),
(907,126,"TRACTOR","2026-09-09");
select * from customer;
select * from customer inner join service_center on customer.center_id=service_center.center_id;

create table cost(cost_id int primary key,customer_id int,center_id int,total_cost bigint,completed_status varchar(255),
foreign key(customer_id) references customer(customer_id),foreign key(center_id) references service_center(center_id));
insert into cost values(800,900,123,900000,"completed"),(801,901,124,850000,"completed"),(802,902,125,950000,"Not-completed"),
(803,903,126,1000000,"completed"),(804,904,123,999999,"completed"),(805,905,124,10000000,"not-completed"),
(806,906,125,9500000,"completed"),(807,907,126,1200000,"completed");
select * from cost;
select * from cost inner join customer on cost.customer_id=customer.customer_id inner join 
service_center on cost.center_id=service_center.center_id;

alter table customer add column least_service int;

update  customer set   least_service=5 where customer_id=900;
update  customer set  least_service=4 where customer_id=901;
update  customer set least_service=7 where customer_id=902;
update  customer set least_service=8 where customer_id=903;
update  customer set least_service=6 where customer_id=904;
update  customer set least_service=5 where customer_id=905;
update  customer set least_service=6 where customer_id=906;
update  customer set least_service=5 where customer_id=907;
select * from customer;

select center_id from customer where least_service >= 5;

select c.customer_id,c.center_id,o.cost_id,o.total_cost from customer c inner join cost o on
c.customer_id=o.customer_id group by o.cost_id having count(vehicle_type)>=1 and sum(total_cost)>100000;


with higher_avg_sal as 
(select avg(total_cost) as avg_total_cost from cost)
select c.center_id,o.cost_id,o.total_cost from service_center c inner join cost o on c.center_id=o.center_id 
where total_cost > (select avg_total_cost from higher_avg_sal);








