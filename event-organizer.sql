create database sameer;
use sameer;
create table events(event_id int primary key,event_name varchar(255),event_catogeris varchar(255));
insert into events values(123,"THAMAN-BANGLORE-EVENT","concert"),
(124,"100MRUNNIG-CHENNAI-SPORTEVENT","EVENT"),
(125,"SAVEETHACOLLGE-CHENNAI-CULTURUALEVENT","CULTURALS"),
(126,"JONITAGANDI-ANDHRAPRADESH-PARTYCONFERENCE","CONFERENCE");
select * from events;

create table organizers(organizer_id int primary key,event_id int,organizer_name char(45),
foreign key(event_id)
 references events(event_id));
insert into organizers values(9090,123,"shaiksameer"),(9091,124,"sampath"),
(9092,125,"varun"),(9093,126,"revanth"),(9094,124,"ravi");
select * from organizers ;
select * from organizers inner join events on organizers.event_id=events.event_id;

create table attendees (attendees_id int primary key,event_id int,organizer_id int,attendees_name char(45),
foreign key(event_id) references events(event_id),
foreign key(organizer_id) references organizers(organizer_id));

insert into attendees values(4545,123,9090,"kushwanth"),(4546,124,9091,"kishan"),
(4547,125,9092,"balu"),(4548,126,9093,"venu"),(4549,123,9094,"keerty"),
(4544,124,9091,"kiran"),(4543,125,9094,"lava"),(4542,126,9093,"kishore");
select * from attendees;
select * from attendees inner join organizers on attendees.event_id=organizers.event_id;

create table bookings (ticket_id int primary key,event_id int,attendees_id int,organizer_id int,ticket_cost bigint,
foreign key(attendees_id) references attendees(attendees_id),
foreign key(organizer_id) references organizers(organizer_id));

insert into bookings values(111,123,4545,9090,90000),(112,124,4546,9091,120000),(113,125,4547,9092,10000),
(114,126,4548,9093,150000),(115,126,4549,9094,8000),
(116,123,4544,9091,9000);
select * from bookings;
select * from bookings inner join attendees on bookings.attendees_id=attendees.event_id;
select * from bookings left join attendees on bookings.attendees_id=attendees.event_id;

create table payments (payment_id int primary key,attendees_id int,event_id int,payment_methond varchar(255),ticket_id int,
foreign key(attendees_id) references attendees(attendees_id),
foreign key(event_id) references events(event_id),
foreign key(ticket_id) references bookings(ticket_id));

insert into payments values(333,4545,123,"UPI",111),(334,4546,124,"WALLET",112),
(335,4547,125,"COD",113),(336,4548,126,"NAVYPAY",114),(337,4549,123,"PAYMENT",115),
(338,4544,123,"UPI",116),(339,4545,123,"COD",111);
select * from payments;
                      
select * from payments inner join bookings on payments.ticket_id=bookings.ticket_id;


create table staff(staff_id int primary key,organizer_id int,event_id int,
foreign key(organizer_id) references organizers(organizer_id),
foreign key(event_id) references events(event_id));

insert into staff values(777,9090,123),(778,9090,123),(779,9091,124),
(780,9092,124),(781,9093,125),(782,9094,125),(786,9090,126),
(783,9091,126),(784,9092,126),(787,9093,126),
(785,9092,126);
select * from staff;
select * from staff inner join organizers on staff.organizer_id=organizers.organizer_id 
inner join events on   events.event_id=organizers.event_id;

create table event_schedules(schedule_id int primary key,event_id int,organizer_id int,attendees_id int,
schedule_date date,foreign key(event_id) references events(event_id),foreign key(organizer_id)
 references organizers(organizer_id),foreign key(attendees_id) references attendees(attendees_id));

insert into event_schedules values(1234,123,9091,4545,"2026-05-07"),
(1235,124,9092,4546,"2026-03-20"),(1236,125,9091,4547,"2026-07-27"),
(1237,126,9091,4548,"2026-07-28"),(1238,126,9091,4549,"2026-05-17"),
(1239,124,9091,4543,"2026-07-31"),(1240,125,9091,4544,"2026-05-30");
select * from event_schedules;
select * from event_schedules inner join events on event_schedules.event_id=events.event_id;

select event_id,lag(ticket_cost) over (order by event_id desc) as  ticket_sales_performance from bookings; 

select event_id,lead(ticket_cost) over (order by event_id desc) as  ticket_sales_performance from bookings; 

alter table bookings add column ticket_sold int;
update bookings set ticket_sold=8083 where event_id=123;
update bookings set ticket_sold=5938 where event_id=124;
update bookings set ticket_sold=6463 where event_id=125;
update bookings set ticket_sold=8953 where event_id=126;
select * from bookings;

select dense_rank() over (order by ticket_sold desc) as most_demanded_performance from bookings;


alter table organizers add column event_utilization varchar(255);
update organizers set event_utilization="VERY-GOOD" where event_id=123;
update organizers set event_utilization="VERY-BAD" where event_id=124;
update organizers set event_utilization="VERY-POOR" where event_id=125;
update organizers set event_utilization="AVERAGE" where event_id=126;
select * from organizers;

alter table attendees add column attendee_preferences varchar(255);
update attendees set attendee_preferences="WE-WANT-MORE-TIME" where attendees_id=4545;
update attendees set attendee_preferences="WE-WANT-FOOD-FACILITIES" where attendees_id=4546;
update attendees set attendee_preferences="WE-WANT-REDUCE-COST" where attendees_id=4547;
update attendees set attendee_preferences="WE-WANT-MORE-SECURITY" where attendees_id=4548;
update attendees set attendee_preferences="WE-WANT-MORE-TIME" where attendees_id=4549;
update attendees set attendee_preferences="BAD-PERFORMANCE" where attendees_id=4544;
select * from attendees;

select attendees_id,attendee_preferences as attendee_preferenceses from attendees;

select event_id,ticket_sold,dense_rank() over (partition by event_id)as event_catogerises from bookings;

select avg(ticket_sold)as ticket_sold from bookings  group by ticket_id;
select event_id,attendees_id,count(ticket_id) as total_tickets from bookings group by ticket_id;

select organizer_id,event_id,staff_id from staff;


 


 
