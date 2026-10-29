create database food_delivery;
use food_delivery;

create table customers(customer_id int primary key,customer_name varchar(255),city varchar(255),registration_date date);
insert into customers values(123,"sameer","ongole","2026-04-20"),(124,"sampath","guntur","2026-03-10"),
(125,"kushwanth","nellore","2026-03-20"),(126,"varun","gudur","2026-05-20"),
(127,"ravi","chirala","2026-05-30");
select * from customers;

create table restaurants(rest_id int primary key,rest_name varchar(255),cuisine varchar(255),city varchar(255));
insert into restaurants values(900,"VR-GRAND","INDIA","ongole"),(901,"ISMAIL","IRAQ","guntur"),
(902,"KG-FAMILY","USA","nellore"),(903,"AREBIAN-MANDI","DUBAI","gudur"),(904,"JAIL-MANDI","IRAN","chirala");
select * from restaurants;

create table orders(order_id int primary key,customer_id int,rest_id int,order_date date,order_status varchar(255),
total_amount bigint,delivery_date varchar(255),foreign key(customer_id) references customers(customer_id),
foreign key(rest_id) references restaurants(rest_id));
insert into orders values(800,123,900,"2026-06-05","completed",4000,"2026-06-05"),
(801,124,901,"2026-06-05","completed",4000,"2026-06-05"),
(802,125,902,"2026-06-25","pending",4000,NULL),
(803,126,903,NULL,"pending",6000,"2026-06-15"),
(804,127,904,"2026-06-25","completed",9000,"2026-06-26");
select * from orders;
select * from orders inner join restaurants on orders.rest_id=restaurants.rest_id inner join customers on 
orders.customer_id=customers.customer_id;

with  successfully_orders as 
(select c.customer_id,c.customer_name,o.order_date from customers c inner join orders o on 
c.customer_id=o.customer_id where order_status="completed" and delivery_date < "2027-01-01" and 
delivery_date > "2026-01-01" group by c.customer_id,c.customer_name,o.order_date having count(order_id)>3)
select * from successfully_orders;

select customer_id,sum(total_amount) as total_spendings,avg(total_amount) as avg_order_value,
max(total_amount) as highest_order_value from orders where order_status="completed" group by customer_id;

with latest_delivery as 
(select c.customer_id,c.customer_name,o.order_id,o.delivery_date,lag(delivery_date) over (partition by customer_id order by 
delivery_date  desc) as previous_orders from customers c inner join orders o on c.customer_id=o.customer_id
where order_status="completed" group by c.customer_id,o.order_id)
select customer_id,order_id,customer_name,delivery_date,previous_orders from latest_delivery
group by customer_id,order_id having count(previous_orders)>20;

WITH previous_ordering AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        o.order_id,
        o.order_date,
        o.delivery_date,
        o.total_amount,
        LAG(o.delivery_date) OVER (
            PARTITION BY c.customer_id
            ORDER BY o.delivery_date, o.order_id
        ) AS previous_delivery_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id
            ORDER BY o.delivery_date DESC, o.order_id DESC
        ) AS latest_order_rank
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date >= '2026-01-01'
      AND o.order_date < '2027-01-01'
),
customer_totals AS (
    SELECT
        customer_id,
        COUNT(*) AS delivered_orders,
        SUM(total_amount) AS total_spending,
        AVG(total_amount) AS average_order_value
    FROM previous_ordering
    GROUP BY customer_id
    HAVING COUNT(*) >= 3
),
eligible_customers AS (
    SELECT
        p.customer_id,
        p.customer_name,
        p.city,
        t.delivered_orders,
        t.total_spending,
        t.average_order_value,
        p.previous_delivery_date,
        p.delivery_date AS latest_delivery_date,
        DATEDIFF(
            p.delivery_date,
            p.previous_delivery_date
        ) AS days_between_deliveries
    FROM previous_ordering p
    INNER JOIN customer_totals t
        ON p.customer_id = t.customer_id
    WHERE p.latest_order_rank = 1
      AND p.previous_delivery_date IS NOT NULL
      AND DATEDIFF(
          p.delivery_date,
          p.previous_delivery_date
      ) >= 20
)
SELECT
    *,
    RANK() OVER (
        PARTITION BY city
        ORDER BY total_spending DESC
    ) AS spending_rank
FROM eligible_customers;

with ranking_customers as 
(select c.customer_id,o.total_amount,rank() over (partition by c.city order by o.total_amount desc)
as ranking_customers_city from customers c inner join orders o on c.customer_id=o.customer_id where
order_status="completed" group by c.customer_id,o.total_amount)
select * from ranking_customers;

select order_id,coalesce(delivery_date,0) as no_delivery_date,coalesce(order_date,0) as no_order_date
from orders where order_status="pending";