create table passengers(passenger_id int primary key,passenger_name varchar(255),city varchar(255));
insert into passengers values(123,"sameer","godavari"),(124,"sampath","kakinada"),(125,"kumar","vijayawada"),
(126,"vamsi","hyderbad"),(127,"khadeer","Goa");
select * from passengers;

create table bookings(booking_id int primary key,passenger_id int,flight_id int,ticket_price bigint,
booking_date date,travel_date date,refund_amount int,booking_status varchar(255),foreign key(passenger_id) references
passengers(passenger_id));
insert into bookings values(900,123,1282,78000,"2026-01-30","2026-02-14",Null,"confirmed"),
(901,124,1283,39000,"2026-01-30",Null,12000,"Cancelled"),
(902,125,1284,58000,"2026-03-10",Null,30000,"Pending"),
(903,126,1285,28000,"2026-05-15","2026-02-14",Null,"confirmed"),
(904,127,1286,38000,"2026-07-17","2026-02-14",Null,"confirmed");
select * from bookings;
select * from bookings inner join passengers on bookings.passenger_id=passengers.passenger_id;
select passenger_id from bookings where booking_status="confirmed" group by passenger_id having max(ticket_price)>30000;

with  qualifying_passenger as 
(select p.passenger_id,p.passenger_name,p.city,sum(b.ticket_price) as total_spendings,avg(b.ticket_price) as avg_ticket_price,
max(b.ticket_price) from passengers p inner join bookings b on p.passenger_id=b.passenger_id where b.booking_status='confirmed'
group by p.passenger_id) 
select * from qualifying_passenger;

with ranking_passenger as 
(select p.passenger_id,p.city,b.ticket_price,sum(b.ticket_price) as total_spendingss,max(b.ticket_price) over (partition by p.city order by 
p.passenger_id desc) as highest_spender_first from passengers p inner join bookings b on p.passenger_id=b.passenger_id
where booking_status="confirmed" group by p.passenger_id,b.ticket_price)
select * from ranking_passenger;

with previous_bookings as 
(select p.passenger_id,b.ticket_price,lag(ticket_price) over ( partition by p.passenger_id order by ticket_price desc)
as previous_bookings from passengers p inner join bookings b on p.passenger_id=b.passenger_id where b.booking_status="confirmed")
select passenger_id,ticket_price,previous_bookings,case 
  when previous_bookings < ticket_price then "Increased"
  when previous_bookings > ticket_price then "Decreased"
  when previous_bookings is null then "no_previous_bookings"
else "Remained_same"
end as previous_bookingss
from previous_bookings;

select year(booking_date) as year_of_booking ,month(booking_date)
 as month_of_bookings,datediff("2026-10-18",booking_date) as elapsed_time from bookings;
select * from bookings where travel_date is Null;
select ticket_price-refund_amount as final_amount from bookings;
select coalesce(refund_amount,0) as missing_refunds from bookings;




