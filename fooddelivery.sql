create table restaurants (rest_id int primary key,rest_name varchar(255),rest_city varchar(255));

insert into restaurants values(123,"NALLAMALLA-FOREST-MANDI","VIJAYAWADA"),
(124,"KB-FAMILY-RESTAURANTS","ONGOLE"),(125,"AREBIAN-FOREST-MANDI","NELLORE"),
(126,"VR-GRAND-FAMILY","GUDUR");
select * from restaurants;


create table customers (customer_id int primary key,rest_id int,customer_name varchar(255),order_id int,customer_ratings decimal,
foreign key(rest_id) references  restaurants(rest_id));

insert into customers values(9090,123,"vamsi",456,4.1),(9091,124,"kushi",457,3.1),
(9092,126,"varun",458,4.3),(9093,123,"vamika",458,4.8),
(9094,124,"kishan",459,4.2),(9095,125,"khadeer",460,3.6),
(9096,126,"kiran",461,4.5),(9097,123,"lakshmi",462,4.3);
select * from customers;
select * from customers inner join restaurants on customers.rest_id=restaurants.rest_id;


create table orders(order_id int primary key,customer_id int,rest_id int,sucessful_orders int,canclled_orders int,
order_month char(45),foreign key(customer_id) references customers(customer_id),foreign key(rest_id) references restaurants(rest_id));
insert into orders values(456,9090,123,302,150,"JAN"),(457,9091,124,393,210,"FEB"),
(458,9092,125,292,150,"MARCH"),
(459,9093,126,402,250,"APRIL"),(460,9094,123,342,210,"MAY"),
(461,9095,124,282,190,"JUNE"),(462,9096,125,299,240,"JULY");
select * from orders;
select * from orders inner join  customers on orders.order_id=customers.order_id;
select * from orders left join customers on orders.order_id=customers.order_id;

create table delivery_partners (partner_id int primary key,rest_id int,customer_id int,sucssful_delivery int, 
foreign key(rest_id) references restaurants (rest_id),foreign key(customer_id) references
customers(customer_id));

insert into delivery_partners values(2323,123,9090,200),(2324,124,9091,170),(2325,125,9092,195),
(2332,126,9093,180),(2326,123,9094,194),(2327,124,9095,167),(2328,125,9096,194),
(2329,126,9093,400),(2330,123,9091,183),(2331,124,9095,143);
select * from delivery_partners;
select * from delivery_partners inner join restaurants on delivery_partners.rest_id=restaurants.rest_id 
inner join 
customers on delivery_partners.customer_id=customers.customer_id;

create table payments(pay_id int primary key,rest_id int,rest_revenue bigint,
foreign key(rest_id) references restaurants(rest_id));
insert into payments values(111,123,2000000),(112,124,1829392),(113,125,3000000),(114,126,4282949);
select * from payments;
select * from payments inner join restaurants on payments.rest_id=restaurants.rest_id;

create table rest_ratings(rest_id int,rest_ratings decimal,foreign key(rest_id)
 references restaurants(rest_id));
insert into rest_ratings values(123,4.5),(124,3.8),(125,4.2),(126,4.3);
select * from rest_ratings;
select * from rest_ratings inner join restaurants on rest_ratings.rest_id=restaurants.rest_id;

 select rest_name,rest_city from restaurants;
 alter table orders add column total_orders int;
 update orders set total_orders=580 where order_id=456;
 update orders set total_orders=895 where order_id=457;
 update orders set total_orders=793 where order_id=458;
 update orders set total_orders=829 where order_id=459;
 update orders set total_orders=899 where order_id=460;


 select avg(total_orders) as order_value  from orders group by sucessful_orders,canclled_orders;

 select sum(rest_revenue) as total_revenue from payments;

 select avg(customer_ratings) as customer_rating from customers;

 select rest_id,partner_id,dense_rank() over (partition by rest_id order by  sucssful_delivery desc ) as ranking_delivery_partners from delivery_partners;

 alter table  customers add column customer_orders int; 
 update customers set customer_orders=78 where customer_id=9090;
 update  customers set customer_orders=48 where customer_id=9091;
 update customers  set customer_orders=55 where customer_id=9092;
 update customers  set customer_orders=29 where customer_id=9093;
 update customers  set customer_orders=48 where customer_id=9094;
 update customers  set customer_orders=94 where customer_id=9095;
 update customers  set customer_orders=34 where customer_id=9096;
 update customers  set customer_orders=7 where customer_id=9097;
 
 select customer_id,customer_name,customer_orders from customers order by customer_orders desc;

 select * from customers where customer_orders >300;

 select * from payments  where rest_revenue > 2000000;

select customer_id,customer_name from customers group by customer_id having avg(customer_ratings)>4.5;

select rest_id,pay_id ,rank() over ( order by rest_revenue desc) as best_restaurants from payments;

select  order_id,(sucessful_orders / canclled_orders ) as cancellation_below_ten from orders;







 







  



















  








