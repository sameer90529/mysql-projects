create database hotels;
use hotels;
create table customers(cust_id int primary key,cust_name char(45));
insert into customers values(123,"rohith"),(124,"sameer");
select * from customers;

create table hotels(cust_id int,restu_id int primary key,restu_name varchar(255),
FOREIGN KEY(cust_id)  REFERENCES customers(cust_id));
insert into hotels values(123,333,"ismail"),(124,334,"KB");
select * from hotels;
select * from hotels inner join customers on hotels.restu_id=customers.cust_id;

create table del_boy(del_id int primary key,del_name char(45));
insert into del_boy values(3434,"koushik"),(3535,"kushwanth");
select * from del_boy inner join hotels on del_boy.del_id=hotels.restu_id;
create table orders(order_id int primary key ,order_name char(45));
insert into orders values(777,"biriyani"),(778,"chicken");
select * from orders;
select * from orders where order_id is null;

create table payment(pay_id int primary key,payment_method char(45));
insert into payment values(8989,"upi"),(9898,"cashondelivery");
select * from payment;
select * from payment where pay_id is null;
select * from payment inner join orders on payment.pay_id=orders.order_id;
select * from payment;

create table ordering(ordering_id int primary key,cust_id int,restu_id int,order_id int,orderd_item char(45),del_id int,

 FOREIGN KEY (del_id)	REFERENCES del_boy(del_id));

insert ordering values(6565,123,333,777,"biriyani",3434),(6644,124,334,778,"biriyani",3535),
(6567,123,334,777,"lolipop",3535),(6655,124,333,778,"kabab",3535);
select * from ordering;

alter table del_boy add column most_del int;
update  del_boy set most_del=4 where del_id=3434;
update  del_boy set most_del=3 where del_id=3535;
select * from del_boy;
select * from del_boy order by most_del  desc;

alter table customers add column cost_del int;
update  customers set cost_del = 23434 where cust_id =123;
update  customers set cost_del = 23434 where cust_id=124;
select * from customers;
select * from customers where cost_del>2000 group by cust_id having avg(cost_del)>2;

alter table del_boy add column time_del time;
update  del_boy set time_del = "10:00:00" where del_id=3434;
update  del_boy set time_del = "10:45:00" where del_id=3535;
select min(time_del) from del_boy;
select * from del_boy where most_del>1 group by del_id having avg(time_del)>'0';









