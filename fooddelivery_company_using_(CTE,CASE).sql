create database food_delivery_company;
use food_delivery_company;
create table customers(customer_id int primary key,customer_name char(45),customer_city varchar(255));
insert into customers values(123,"sameer","ongole"),(124,"kushwanth","vijayawada"),
(125,"sampath","nellore"),(126,"khadeer","karnool");
select * from customers;

create table restaurants(rest_id int primary key,customer_id int,rest_name varchar(255),
rest_city varchar(255),foreign key(customer_id) references customers(customer_id));
insert into restaurants values(9090,123,"bilal","ongole"),(9091,123,"ismail","ongole"),
(9092,124,"KB","vijayawada"),(9093,124,"V-GRAND","vijayawada"),
(9094,125,"FOOD-BITES","nellore"),(9095,125,"AREBIAN-MANDI","nellore"),
(9096,126,"JAIL-MANDI","karnool"),(9097,126,"Rail-Mandi","karnool");
select * from restaurants;
select * from restaurants inner join customers on restaurants.customer_id=customers.customer_id;

create table orders (order_id int primary key,rest_id int,customer_id int,order_placed int
,foreign key(rest_id) references restaurants(rest_id),
foreign key(customer_id) references customers(customer_id));

insert into orders values(4545,9090,123,83),(4646,9091,123,67),
(4747,9092,124,57),(4848,9093,124,52),(4949,9094,125,67),
(4950,9095,125,77),(4951,9096,126,22),(4952,9097,126,32);
select * from orders;
select * from orders inner join restaurants on orders.rest_id=restaurants.rest_id
 inner join customers on orders.customer_id=customers.customer_id;

create table deliveries(delivery_id int primary key,order_id int,rest_id int,sucessful_orders int,
cancelled_orders int,total_orders int,foreign key(order_id) references orders(order_id),
foreign key(rest_id) references restaurants(rest_id));

insert into deliveries values (7070,4545,9090,123,127,250),(7071,4646,9091,130,140,270),(7072,4747,9092,350,100,450),
(7073,4848,9093,250,250,500),(7074,4949,9094,350,100,450),(7075,4950,9095,100,10,110),
(7076,4951,9096,99,1,100),(7077,4952,9097,300,100,400);
select * from deliveries;
select * from deliveries inner join orders on deliveries.order_id=orders.order_id
 inner join restaurants on deliveries.rest_id=restaurants.rest_id;

create table revenue(revenue_id int primary key,rest_id int ,total_revenue bigint,revenue_city varchar(255),
foreign key(rest_id) references restaurants(rest_id));
insert into revenue values(900,9090,8000000,"ongole"),(901,9091,7284000,"ongole"),
(902,9092,9000000,"vijayawada"),(903,9093,10000000,"vijayawada"),(904,9094,5000000,"nellore"),
(905,9095,1000000,"nellore"),(906,9096,1500000,"karnool"),(907,9097,6500000,"karnool");
select * from revenue;
select * from revenue inner join restaurants on revenue.rest_id=restaurants.rest_id;

create table ratings(rating_id int primary key,customer_id int,rest_id int,rating_given 
decimal,foreign key(customer_id) references customers(customer_id),
foreign key(rest_id) references restaurants(rest_id));

insert into ratings values(800,123,9090,4.5),(801,123,9091,4.3),(802,124,9092,4.1),
(803,124,9093,3.9),(804,125,9094,3.8),(805,125,9095,4.5),(806,126,9096,4.8),
(807,126,9097,4);
select * from ratings;
select * from ratings inner join restaurants on ratings.rest_id=restaurants.rest_id 
inner join customers on ratings.customer_id=customers.customer_id;

select avg(total_orders) as avg_order_value from deliveries order by order_id;

select avg(rating_given) as avg_customer_rating from ratings order by rating_id;

select order_id,(sucessful_orders/total_orders)*100 as sucessful_order_percentage from deliveries order by delivery_id;

with avg_revenue as
(select avg(total_revenue) as avg_revenue_got from revenue)
select r.rest_id,r.rest_name,r.rest_city,m.total_revenue,m.revenue_city from restaurants r inner join revenue m
on r.rest_id=m.rest_id where m.total_revenue >(select avg_revenue_got from avg_revenue order by r.rest_id);

with Performer as
(select r.rating_id,(d.sucessful_orders/d.total_orders)*100,r.rating_given,delivery_id,r.rest_id,
case 
    when r.rating_given >= 4.5 and  (d.sucessful_orders/d.total_orders)*100 >=90  then "top_performer"
    when r.rating_given >= 4 and (d.sucessful_orders/d.total_orders)*100 >=80  then "Good Performer"
else "Needs_Improvement"
end as feedbacks
FROM ratings r INNER JOIN deliveries d ON r.rest_id= d.rest_id)
select * from Performer;

select rest_id,total_revenue,rank() over (order by total_revenue desc) as ranking_restaurants from revenue;

select rest_id,total_revenue,dense_rank() over (partition by revenue_city order by total_revenue desc)
 as ranking_rest_according_cities from revenue;

select rest_id,revenue_city,total_revenue,lag(total_revenue) over (order by total_revenue desc)
as previous_rest_revenue from revenue;

select rest_id,revenue_city,total_revenue,lead(total_revenue) over (order by total_revenue desc)
as previous_rest_revenue from revenue;

select rest_id,revenue_city,total_revenue,lag(total_revenue) over (order by total_revenue desc)
as previous_rest_revenue,total_revenue - lag(total_revenue) over (order by total_revenue desc)
as difference_between_previous from revenue;

select rest_id,total_revenue,revenue_city,row_number() over (partition by revenue_city ) as sum_by_cites
from revenue group by revenue_id having sum(total_revenue);

select rest_id,revenue_city,rank() over (partition by revenue_city) as top_most_cites from revenue
group by revenue_id having max(total_revenue)<=3;

with avg_customer as
(select avg(order_placed) as avg_placed_orders from orders)
select o.order_placed,o.order_id,c.customer_id from orders o inner join customers c on o.customer_id=c.customer_id
where o.order_placed >(select avg_placed_orders from avg_customer);

select * from orders where order_id is null;

select rest_id,revenue_city,total_revenue from revenue order by total_revenue desc;


