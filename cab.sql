create table drivers (driver_id int primary key,driver_name char(45));
insert into drivers values(123,"sameer"),(124,"sampath"),(125,"kushwanth"),(126,"kiran");
select * from drivers ;

create table riders(rider_id int primary key,driver_id int,riding_city varchar(255),
foreign key(driver_id) references drivers(driver_id));

insert into riders values(9090,123,"MGRCENTRALSTATION"),(9091,124,"KOYEMBED"),(9092,125,"POONAMALEY");
select * from riders;
select * from riders inner join drivers on riders.driver_id=drivers.driver_id;

create table cities (city_id int primary key,rider_id int,driver_id int,city_riding varchar(255),
foreign key(driver_id) references drivers(driver_id),foreign key(rider_id) references riders(rider_id));
insert into cities values(4545,9090,123,"MGRCENTRALSTATION"),(4646,9091,124,"KOYEMBED"),
(4747,9092,125,"POONAMALEY");

select * from cities;
select * from cities inner join riders on cities.rider_id=riders.rider_id 
inner join drivers on cities.driver_id=drivers.driver_id;

create table vehicals(vehical_id int primary key,rider_id int,driver_id int,vehcials_type varchar(255),
foreign key(driver_id) references drivers(driver_id) ,foreign key(rider_id) references riders(rider_id));

insert into vehicals values(8989,9090,123,"car"),(8990,9091,124,"bike"),(8991,9092,125,"auto");
select * from vehicals;
select * from vehicals inner join riders on vehicals.rider_id=riders.rider_id 
inner join drivers on vehicals.driver_id=drivers.driver_id;

create table rides (ride_id int primary key,driver_id int,rider_id int,city_id int,vehical_id int,total_rides int ,
foreign key(rider_id) references riders(rider_id),foreign key(driver_id) references drivers(driver_id));

insert into rides values(111,123,9090,4545,8989,40),(112,124,9091,4646,8990,38),(113,125,9092,4747,8991,37);
select * from rides;
select * from rides inner join riders on rides.rider_id=riders.rider_id;

create table payments (payment_id int primary key,driver_id int,rider_id int,city_id int,payment_amount int,
foreign key(city_id) references cities(city_id),foreign key(rider_id) references riders(rider_id),foreign key(driver_id) references drivers(driver_id));

insert into payments values(777,123,9090,4545,900),(778,124,9091,4646,853),(779,125,9092,4747,958);
select * from payments;
select * from payments inner join rides on payments.rider_id=rides.rider_id 
inner join drivers on payments.driver_id=drivers.driver_id;


create table ratings(rating_id int primary key,driver_id int ,rating_performance decimal,
foreign key(driver_id) references drivers(driver_id));

insert into ratings values(900,123,4.5),(9001,124,4.6),(9002,125,4.2);
select * from ratings;
select * from ratings inner join drivers on ratings.driver_id=drivers.driver_id;

create table cancellation (cancel_id int primary key,driver_id int,canclled_rides int,sucssful_rides int,
foreign key(driver_id) references drivers(driver_id));

insert into cancellation values(888,123,9,31),(889,124,12,27),(890,125,10,28);
select * from cancellation ;
select * from cancellation inner join drivers on cancellation.driver_id=drivers.driver_id;

create table bonus(bonus_id int,driver_id int,total_rides int,bonus_giving varchar(255),ride_id int,
foreign key(ride_id) references rides(ride_id),foreign key(driver_id) references drivers(driver_id));

insert into bonus values(999,123,40,"EXTRA-LEAVE",111),(998,124,38,"EXTRA-CASH",112),(999,125,37,"TREAT",113);
select * from bonus;

create table promotions ( driver_id int,promotion_giving varchar(255),foreign key(driver_id) 
references drivers(driver_id));

insert into promotions values(123,"PROMOTION-GRANTED"),(124,"NO-PROMOTION"),(125,"NO-PROMOTION");
select * from promotions;
select * from promotions inner join drivers on promotions.driver_id=drivers.driver_id;

alter table payments  add column revenue bigint;
update payments set revenue=5000000 where city_id =4545;
update payments set revenue=8974379 where city_id =4646;
update payments set revenue=4545366 where city_id =4747;
select * from payments;

with avg_riding as 
(select driver_id,payment_id,avg(payment_amount) as avg_ride_fare from payments group by driver_id
 having avg(payment_amount)>450 and sum(revenue)>5000000)

 select e.driver_id,e.driver_name,d.payment_amount,d.revenue from drivers e 
 inner join payments d on e.driver_id=d.driver_id where revenue > 5000000 and payment_amount  > 450;

 select ride_id,total_rides,dense_rank() over(order by total_rides desc) as ranking_riders from rides;

 with above_riders as
(select avg(total_rides)  as above_avg from rides)
select e.driver_id,e.driver_name, t.total_rides from drivers e inner join rides t on e.driver_id=t.driver_id
where t.total_rides > (select above_avg from above_riders);

select rating_performance > 4.5 as above from ratings;






