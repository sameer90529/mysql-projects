'''A food-delivery company wants to analyze customer ordering behavior over several months. 
Only completed orders should be considered. Management wants to identify customers who have placed 
completed orders in at least two different months and whose highest individual order is greater than 
₹2,000. For each qualifying customer, calculate the total number of completed orders, total spending, 
highest order amount, and average order amount. The company also wants to compare each customers
monthly spending with their previous month, showing the previous months spending and the change 
in spending. Finally, rank customers by total spending overall and within their respective city, and 
indicate whether their average order amount is above or below the overall average order amount. 
To perform this analysis, create the necessary customer and order-related tables with appropriate 
information about customers, orders, restaurants, dates, amounts, and order status, along with the 
required relationship between the tables.'''


create database foo_delivery;
use food_delivery;


create table customers(customer_id int primary key,customer_name varchar(255),city varchar(255));
insert into customers values(123,"sameer","vijayawada"),(124,"sampath","vijayanagaram"),(125,"khadeer","ongole"),
(126,"kushwanth","nellore"),(127,"varun","guntur");
select * from customers;

create table restaurants(rest_id int primary key,customer_id int,rest_name varchar(255),rest_city varchar(255),
foreign key(customer_id) references customers(customer_id));
insert into restaurants values(900,123,"KB-RESTAURANTS","vijayawada"),(901,124,"BILAL-RESTAURANTS","vijayanagaram"),(902,125,"MUJEEB-RESTAURANTS","ongole"),
(903,126,"ISMAIL-RESTAURANTS","nellore"),(904,127,"SALMA-RESTAURANTS","guntur");
select * from restaurants;
select * from restaurants inner join customers on restaurants.customer_id=customers.customer_id;

create table orders (order_id int primary key,rest_id int,customer_id int,order_date date,order_placed int,
foreign key(customer_id) references customers(customer_id),foreign key(rest_id) references restaurants(rest_id));
insert into orders values(800,900,123,"2026-09-30",8),(801,901,124,"2026-01-04",9),
(802,902,125,"2026-04-30",3),(803,903,126,"2026-05-12",10),(804,904,127,"2026-11-23",14),
(805,900,123,"2026-01-30",5),(806,901,124,"2026-12-24",7),
(807,902,125,"2026-04-24",7),(808,903,126,"2026-02-03",11),(809,904,127,"2026-12-13",11);
select * from orders;
select * from orders inner join restaurants on orders.rest_id=restaurants.rest_id inner join customers on 
orders.customer_id=customers.customer_id;

create table amount(amount_id int primary key,order_id int,customer_id int,rest_id int,total_amount bigint,
foreign key(order_id)references orders(order_id),foreign key(customer_id)references customers(customer_id),
foreign key(rest_id) references restaurants(rest_id));
insert into amount values(3434,800,123,900,9000),(3435,801,124,901,1000),(3436,802,125,902,9500),
(3437,803,126,903,9647),(3438,804,127,904,7000),(3439,805,123,900,3000),
(3440,801,124,901,5000),(3441,802,125,902,5000),
(3442,803,126,903,6000),(3443,804,127,904,3000);
select * from amount;
select * from amount inner join orders on amount.order_id=orders.order_id inner join restaurants on
amount.rest_id=restaurants.rest_id inner join customers on amount.customer_id=customers.customer_id;

create table order_status(stauts_id int primary key,order_id int ,rest_id int,order_status varchar(255),
foreign key(order_id) references orders(order_id),foreign key(rest_id) references restaurants(rest_id));
insert into order_status values(4545,800,900,"completed"),(4546,801,901,"completed"),(4547,802,902,"not-completed"),
(4548,803,903,"completed"),(4549,804,904,"not-completed"),(4550,805,900,"completed"),(4551,806,901,"not-completed"),
(4552,807,902,"not-completed"),(4553,808,903,"completed"),(4554,809,904,"completed");
select * from order_status;
select * from order_status inner join orders on order_status.order_id=orders.order_id inner join 
restaurants on order_status.rest_id=restaurants.rest_id;

with individual_greater as 
(select a.customer_id,o.order_status,a.total_amount from amount a inner join order_status o on 
a.rest_id=o.rest_id where o.order_status="completed" group by a.customer_id,a.total_amount having 
count(order_status)>1 and sum(total_amount)>2000)
select * from individual_greater;

select count(order_status) as completed_orders from order_status where order_status="completed";
select sum(total_amount) as total_spendings from amount;
select max(total_amount) as higher_order_amount from amount group by customer_id;
select avg(total_amount) as avg_order_amount from amount;

select total_amount,amount_id,customer_id,lag(total_amount) over (partition by customer_id) as spending_change,
total_amount-lag(total_amount) over (partition by customer_id) as comparing_spending_change from amount;

with ranking_customer as 
(select c.customer_id,c.city,a.amount_id,a.total_amount,rank() over (partition by c.city order by c.customer_id) as ranking_customer_by_city
from customers c inner join amount a on c.customer_id=a.customer_id)
select * from ranking_customer;













