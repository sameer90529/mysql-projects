create table shopping_malls(mall_id int primary key,mall_name varchar(255),mall_location varchar(25),
vehical_entries int,exist int,parking_duration time,parking_fee int,occupancy_level int,payment_transaction bigint);

insert into shopping_malls values(123,"CMR","Gandhi-road",90,78,"2:00:00",50,180,50000),
(124,"KALAMANDIR","Mangamur-road",120,58,"6:46:59",100,250,200000),
(125,"ANJALI","Guntur-road",24,0,"1:00:00",30,90,10000);
select * from shopping_malls;


create table airport(airport_id int primary key,airport_name varchar(255),airport_loc varchar(255),vehical_entries_airport int,
exist_airport int,parking_duration_airport time,parking_fee_airport int,occupancy_level_airport int,payment_transaction_airport bigint);


insert into airport values(9090,"INDRAGANDHI-INTERNATIONAL-AIRPORT","hyderbad-8980",300,130,"24:00:00",500,1000,30000000),

(9091,"SHAMDABAAD-INTERNATIONAL-AIRPORT","KARIMNAGAR-8877",200,110,"24:00:00",300,600,3000000),

(9092,"ALLURISITARAMARAJU-INTERNATIONAL","VAISAC-AIRPORT-8568",250,180,"24:00:00",600,800,1585800);
select * from airport;

create table railway_station(station_id int primary key,station_name varchar(255),station_loc varchar(255),vehical_entries_station int,
exist_station int,parking_duration_station time,parking_fee_station int,occupancy_level_station int,payment_transaction_station bigint);

insert into railway_station values
(4545,"ONGOLE-RALIWAY-STATION","SONTHAPET-523001",90,50,"24:00:00",30,120,50000),

(4546,"NELLORE-RALIWAY-STATION","GANDI-NAGAR-523020",70,30,"24:00:00",45,150,70000),

(4547,"GUDUR-JUNCTION-RALIWAY-STATION","GUDUR-523019",150,20,"24:00:00",75,170,100000);
select * from railway_station;

create table commercial_complex(complex_id int primary key,complex_name varchar(255),complex_loc varchar(255),vehical_entries_complex int,
exist_complex int,parking_duration_complex time,parking_fee_complex int,occupancy_level_complex int,payment_transaction_complex bigint);

insert into commercial_complex values
(6464,"SRI-SRINIVASA-COMPLEX","ONGOLE-523001",20,10,"12:00:00",0,30,0),
(6465,"SRI-ANNAMAYYA-COMPLEX","NELLORE-523020",40,30,"12:00:00",0,40,0),
(6466,"SRI-KALAHASTI-COMPLEX","KANDUKUR-523839",20,10,"12:00:00",0,30,0);
select * from commercial_complex;

create table customers( customer_id int primary key,mall_id int,customer_name char(45),customer_vehical varchar(45),
parking_activity varchar(255),foreign key(mall_id) references shopping_malls(mall_id));

insert into customers values(111,123,"sameer","car","broke-two-lights"),
(116,123,"sampath","van","broke-two-rods"),
(112,124,"samveer","bike","NILL"),
(113,124,"kumar","cycle","fought-with-secrurity"),
(114,125,"deelip","bus","Drunk"),
(115,123,"Vamsi","bike","dashed-other-vehicals");
select * from customers;

create table customers_airport( air_customer_id int primary key,airport_id int,airport_customer_name char(45),
airport_customer_vehical varchar(45),
parking_activity_airport varchar(255),foreign key (airport_id) references airport(airport_id));

INSERT INTO customers_airport VALUES
(119,9092,"sameer","car","broke-two-lights"),
(120,9090,"sampath","van","broke-two-rods"),
(121,9091,"samveer","bike","NILL"),
(122,9092,"kumar","cycle","fought-with-security"),
(123,9091,"deelip","bus","Drunk"),
(124,9092,"Vamsi","bike","dashed-other-vehicles");

create table railway_station_customers( station_customer_id int primary key,station_id int,station_customer_name char(45),
station_customer_vehical varchar(45),
parking_activity_station varchar(255),foreign key (station_id) references railway_station(station_id));

INSERT INTO railway_station_customers VALUES
(200,4545,"sameer","car","broke-two-lights"),
(201,4546,"sampath","van","broke-two-rods"),
(202,4547,"samveer","bike","NILL"),
(203,4545,"kumar","cycle","fought-with-security"),
(204,4546,"deelip","bus","Drunk"),
(205,4547,"Vamsi","bike","dashed-other-vehicles");


create table commercial_complex_customers( complex_customer_id int primary key,complex_id int,complex_customer_name char(45),
complex_customer_vehical varchar(45),
parking_activity_complex varchar(255),foreign key (complex_id) references commercial_complex(complex_id));

INSERT INTO commercial_complex_customers VALUES
(280,6464,"sameer","car","broke-two-lights"),
(281,6465,"sampath","van","broke-two-rods"),
(272,6466,"samveer","bike","NILL"),
(283,6464,"kumar","cycle","fought-with-security"),
(284,6465,"deelip","bus","Drunk"),
(285,6464,"Vamsi","bike","dashed-other-vehicles");

select sum(payment_transaction) as revenue from  shopping_malls group by mall_id;

select sum(payment_transaction_airport) as airport_revenu from airport group by airport_id;

select sum(payment_transaction_complex) as complex_revenue from commercial_complex group by complex_id;

select mall_location,rank() over (order by payment_transaction desc) as high_demand_loc from shopping_malls;

select airport_loc,rank() over (order by payment_transaction_airport desc) as high_demand_aiport from airport;

select complex_loc,rank() over (order by payment_transaction_complex desc) as high_demand_loc_complex from commercial_complex;



select mall_name,max(parking_duration) as peak_hours from shopping_malls where parking_duration >"6:00:00" group by mall_id having avg(parking_duration)>0;

select station_name,max(parking_duration_station) as peak_hours from railway_station where parking_duration_station >"6:00:00" group by station_id having avg(parking_duration_station)>0;

select airport_name,max(parking_duration_airport) as peak_hours from airport where parking_duration_airport >"6:00:00" group by airport_id having avg(parking_duration_airport)>0;

select complex_name,max(parking_duration_complex) as peak_hours from commercial_complex where parking_duration_complex >"6:00:00" group by complex_id having avg(parking_duration_complex)>0;


select parking_activity from customers;

select parking_activity_airport from customers_airport;

select parking_activity_station from  railway_station_customers;

select parking_activity_complex from  commercial_complex_customers;












