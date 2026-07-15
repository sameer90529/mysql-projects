create table aircraft(aircraft_id int primary key,aircraft_name varchar(255));
insert into aircraft values(123,"KingFisher"),(122,"INDIGO"),(124,"AIRINDIA");
select * from aircraft;

create table passengers(passenger_id int primary key,aircraft_id int,passenger_name char(45),foreign key(aircraft_id) references aircraft(aircraft_id));
insert into passengers values(9091,123,"shaiksameer"),(9092,123,"shaikrazik"),
(9093,124,"kondusampath"),(9094,124,"yedugruivarun"),(9095,122,"govanakushwanth"),
(9096,122,"shaikrushma");
select * from passengers;
select * from passengers inner join aircraft on passengers.aircraft_id=aircraft.aircraft_id;

create table crew(crew_id int primary key,aircraft_id int,crew_name char(45),schedule_id int,foreign key(aircraft_id) references aircraft(aircraft_id));
insert into crew values(4545,123,"shaikrushma",143),(4546,124,"kitty",146),(4547,123,"likitha",147), 
(4548,124,"mahareen",148), (4549,122,"imanvi",149), (4560,122,"sulthana",150);
select * from crew;
select * from crew inner join aircraft on crew.aircraft_id=aircraft.aircraft_id;

create table fight_schedule(schedule_id int primary key,aircraft_id int,passenger_id int,crew_id int,
travel_route varchar(255),schedule_date date,foreign key(aircraft_id) references aircraft(aircraft_id),
foreign key(passenger_id) references passengers(passenger_id));

insert into fight_schedule  values
(143,123,9091,4545,"vijayawada-tirupathi","2026-09-26"),
(146,123,9092,4546,"vijayawada-chennai","2026-04-25"),
(147,124,9093,4547,"hyderbad-tirupathi","2026-05-6"),
(148,122,9094,4548,"vaisac-rajamendri","2026-09-16"),
(149,122,9095,4549,"goa-vijawada","2026-05-16"),
(150,123,9096,4560,"kedarnath-chennai","2026-05-06");
select * from fight_schedule;
select * from fight_schedule inner join crew on fight_schedule.aircraft_id=crew.aircraft_id;


create table bookings(booking_id int primary key,passenger_id int,aircraft_id int,schedule_id int,
payment_status varchar(255),booked_seat varchar(255),booking_behaviour varchar(255),transaction_id int,
foreign key(passenger_id) references passengers(passenger_id),
foreign key(aircraft_id) references aircraft(aircraft_id),
foreign key(schedule_id) references fight_schedule(schedule_id));


insert into bookings values
(111,9091,123,143,"completed","bussiness-class","good",900),
(112,9092,124,146,"pending","economy-class","broke two glasses",901),
(115,9093,122,143,"completed","normal-class","good",902),
(113,9094,123,143,"rejected","bussiness-class","fought-with-police",903),
(116,9095,124,143,"completed","economy-class","good",904),
(114,9096,122,143,"completed","normal-class","good",905);
select * from bookings;
select * from bookings inner join fight_schedule on bookings.passenger_id=fight_schedule.passenger_id;

create table ticket_transaction(transaction_id int primary key,booking_id int,passenger_id int,
transaction_status varchar(255),transaction_through varchar(255),transaction_amount bigint,
foreign key(booking_id) references bookings(booking_id));

insert into ticket_transaction values
(900,111,9091,"completed","UPI",10000),
(901,112,9092,"pending","HAND-CASH",222000),
(902,113,9093,"running","GOOGLE-PAY",94000),
(903,114,9094,"rejected","UPI",38480),
(904,115,9095,"cancelled","NAVY-PAY",11300),
(905,116,9096,"completed","DEBIRT",740400),
(906,116,9092,"completed","UPI",933000);
select * from ticket_transaction;
select * from ticket_transaction inner join bookings on 
ticket_transaction.transaction_id=bookings.transaction_id
inner join passengers on ticket_transaction.passenger_id=passengers.passenger_id;

alter table aircraft add column flight_hours time;
update aircraft set flight_hours ="600:00:00" where aircraft_id=123;
update aircraft set flight_hours ="600:00:00" where aircraft_id=124;
update aircraft set flight_hours ="300:00:00" where aircraft_id=122;
select * from aircraft;
select max(flight_hours) as flight_performance from aircraft group by aircraft_id,aircraft_name;
select travel_route as popular_routes from fight_schedule;

select count(aircraft_id) as flight_usage from  fight_schedule group by schedule_date;

select sum(transaction_amount) as total_sum from ticket_transaction;

select passenger_id,booking_behaviour from bookings;

select schedule_id,aircraft_id,travel_route from fight_schedule;

select * ,lag(aircraft_id) over (order by travel_route)as previous_flights from fight_schedule;

select * ,lead(aircraft_id) over (order by travel_route)as previous_flights from fight_schedule;

select aircraft_id,flight_hours ,dense_rank() over(order by flight_hours desc) as best_flights from aircraft;

alter table passengers add column passenger_experiance varchar(255);
update passengers set passenger_experiance="great" where passenger_id=9091;
update passengers set passenger_experiance="bad" where passenger_id=9092;
update passengers set passenger_experiance="good" where passenger_id=9093;
update passengers set passenger_experiance="average" where passenger_id=9094;
update passengers set passenger_experiance="best" where passenger_id=9095;
update passengers set passenger_experiance="average" where passenger_id=9096;
select passenger_id,passenger_experiance  from passengers ;



