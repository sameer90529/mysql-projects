
create table farmers(farmer_id int primary key,farmer_name char(45));
insert into farmers values(123,"sameer"),(124,"sampath"),(125,"kishan"),(126,"kushwanth");
select * from farmers;

create table farms(farm_id int primary key,farmer_id int,farm_name varchar(255),
farm_size int,farm_region varchar(255),foreign key(farmer_id) references farmers(farmer_id));

insert into farms values(9090,123,"green-farm",10,"vaisac"),
(9091,124,"nature-heaven",14,"godavari"),(9092,125,"green-forest",25,"rajamondry"),
(9093,126,"natures-sky",22,"vijayawada");
select * from farms;
select * from farms inner join farmers on farms.farmer_id=farmers.farmer_id;

create table crops(crop_id int primary key,farm_id int,farmer_id int,crop_name varchar(255),
foreign key(farmer_id) references farmers(farmer_id),foreign key(farm_id) references farms(farm_id));

insert into crops values(4545,9090,123,"RICE"),(4547,9091,124,"WHEAT"),(4549,9092,125,"MANGO"),
(4551,9093,126,"TAMATO"),(4546,9090,123,"CORN"),(4548,9091,124,"CHILLES"),(4550,9092,125,"COTTON"),
(4552,9093,126,"POTATO");
select * from crops;
select * from crops inner join farms on crops.farm_id=farms.farm_id 
inner join farmers on crops.farmer_id=farmers.farmer_id;

create table rainfalls(rainfall_id int,farm_id int,crop_id int,farmer_id int,rain_fall varchar(255),
foreign key(crop_id) references crops(crop_id),foreign key(farm_id) references farms(farm_id),
foreign key(farmer_id) references farmers(farmer_id));

insert into rainfalls values(900,9090,4545,123,"MONSOON"),(901,9090,4546,123,"SUMMER"),
(902,9091,4547,124,"SUMMER"),(903,9091,4548,124,"MONSOON"),(904,9092,4549,125,"SUMMER"),
(905,9092,4550,125,"WINTER"),(906,9093,4551,126,"SUMMER"),(907,9093,4552,126,"MONSOON");
select * from rainfalls;
select * from rainfalls inner join crops on rainfalls.crop_id=crops.crop_id inner join farms on 
rainfalls.farm_id=farms.farm_id inner join farmers on rainfalls.farmer_id=farmers.farmer_id;

create table fertillizer (fertillizer_id int primary key,farm_id int,crop_id int,farmer_id int,
fertillizer_produced int,foreign key(crop_id) references crops(crop_id),
foreign key(farm_id) references farms(farm_id),foreign key(farmer_id) references farmers(farmer_id));

insert into fertillizer values(200,9090,4545,123,100),(201,9090,4546,123,150),
(202,9091,4547,124,230),(203,9091,4548,124,167),(204,9092,4549,125,120),
(205,9092,4550,125,140),(206,9093,4551,126,110),(207,9093,4552,126,120);

select * from fertillizer;
select * from fertillizer inner join crops on fertillizer.crop_id=crops.crop_id inner join
farms on fertillizer.farm_id=farms.farm_id inner join farmers on fertillizer.farmer_id=farmers.farmer_id;

create table harvest(harvest_id int primary key,fertillizer_id int,crop_id int,farm_id int,
farmer_id int,harvested int ,foreign key(fertillizer_id) references fertillizer(fertillizer_id),
foreign key(crop_id) references crops(crop_id),foreign key(farm_id) references farms(farm_id),
foreign key(farmer_id) references farmers(farmer_id));

insert into harvest values(600,200,4545,9090,123,3000),(601,201,4546,9090,123,2000),
(602,202,4547,9091,124,3200),(603,203,4548,9091,124,2140),(604,204,4549,9092,125,1900),
(605,205,4550,9092,125,3130),(606,206,4551,9093,126,1500),(607,207,4552,9093,126,3420);
select * from harvest;
select * from harvest inner join crops on harvest.crop_id=crops.crop_id inner join fertillizer on
harvest.fertillizer_id=fertillizer.fertillizer_id inner join farms on harvest.farm_id=farms.farm_id
inner join farmers on harvest.farmer_id=farmers.farmer_id;

create table sales(sale_id int primary key,harvest_id int,crop_id int,farmer_id int,
production bigint,sales_profit bigint,farm_id int,
foreign key(harvest_id) references harvest(harvest_id),foreign key(crop_id) references crops(crop_id),
foreign key(farmer_id) references farmers(farmer_id));

insert into sales values(800,600,4545,123,1500000,8000000,9090),(801,601,4546,123,1700000,1200000,9090),
(802,602,4547,124,1200000,6000000,9091),(803,603,4548,124,10000000,5000000,9091),
(804,604,4549,125,10000000,7000000,9092),(805,605,4550,125,14000000,9000000,9092),
(806,606,4551,126,18000000,1200000,9093),(807,607,4552,126,15000000,9000000,9093);
select * from sales;
select * from sales inner join crops on sales.crop_id=crops.crop_id inner join harvest on 
sales.harvest_id=harvest.harvest_id inner join farmers on sales.farmer_id=farmers.farmer_id;

select sale_id,farm_id,sum(sales_profit) over (partition by farm_id) as total_production_per_farm from sales;

select farm_id,sale_id,avg(sales_profit) over (partition by farm_id) as avg_production_per_farm from sales;

with yield_per_acre as
(select h.harvest_id,h.crop_id,h.harvested,f.farm_id,f.farm_size from harvest h inner join 
farms f on h.farm_id=f.farm_id)
select * from yield_per_acre;

select sale_id,crop_id,sum(sales_profit) over (partition by crop_id) as total_production_per_crop from sales;

with fertilizer_efficiecny as
(select f.fertillizer_id,f.fertillizer_produced,h.harvest_id,h.harvested from  fertillizer f inner join
harvest h on f.fertillizer_id=h.fertillizer_id)
select * from fertilizer_efficiecny;

select farm_id,crop_id,case
  when harvested>=3000 then "excellent"
  when harvested<=2000 then "good"
  when harvested=1200 then "average"
  when harvested=1000 then "poor"
else "NEED-IMPORVEMENT"
end as performance_rating_for_farm
from harvest;

with more_production  as
(select avg(harvested) as avg_harvested from harvest)
select f.farm_id,f.farm_name,f.farm_region,h.harvest_id,h.harvested from farms f inner join harvest h 
on f.farm_id=h.farm_id where h.harvested > (select avg_harvested from more_production);

with above_profit as
(select avg(sales_profit) as avg_sales from sales)
select s.sale_id,s.sales_profit,c.crop_id,c.crop_name from sales s inner join crops c on s.crop_id=c.crop_id
where s.sales_profit >(select avg_sales from above_profit);

with not_harvested as
(select h.harvest_id,h.harvested,c.crop_id,c.crop_name from harvest h inner join crops c 
on h.crop_id=c.crop_id )
select * from not_harvested where harvested is not null;

select farm_id,harvest_id,lag(harvested) over (order by farm_id desc) as previous_production from harvest;

select farm_id,harvest_id,harvested-lag(harvested) over (order by farm_id desc) as comparision_production from harvest;

with seasons as
(select f.farm_id,f.farm_name,f.farm_region,h.harvest_id,h.harvested ,sum(h.harvested) over (partition by f.farm_id order by h.harvest_id desc ) as cummulative_production
from farms f inner join harvest h on f.farm_id=h.farm_id) select * from seasons;

with ranking_with_region as
(select f.farm_id,f.farm_name,f.farm_region,h.harvest_id,h.harvested ,rank() over (partition by f.farm_region order by h.harvest_id desc ) as ranking_production
from farms f inner join harvest h on f.farm_id=h.farm_id) select * from ranking_with_region;

with profitability as
(select c.crop_id,c.crop_name,s.sales_profit,s.sale_id,dense_rank() over (order by s.sale_id desc)as 
ranking_profitability from crops c inner join sales s on c.crop_id=s.crop_id)
select * from profitability;

with top_three_crops as
(select c.crop_id,f.farm_id,f.farm_name,f.farm_region,h.harvest_id,h.harvested,rank() over 
(partition by f.farm_region order by f.farm_id desc)  as ranking_top_three from farms f
inner join crops c on f.farm_id=c.farm_id inner join harvest h on f.farm_id=h.farm_id)
select * from top_three_crops where ranking_top_three<=3;


with high_amount as
(select avg(fertillizer_produced) as avg_fertillizer from fertillizer),

low_yields as
(select avg(harvested) as avg_harvested from harvest)

select f.fertillizer_id,f.fertillizer_produced,h.harvest_id,h.harvested from fertillizer f 
inner join harvest h on f.fertillizer_id=h.fertillizer_id 
where  f.fertillizer_produced>(select avg_fertillizer from high_amount)
and h.harvested
<(select avg_harvested from low_yields);


with high_crops as
(select avg(harvested) as avg_crops from harvest),

avg_sales_profit as
(select avg(sales_profit) as avg_sales_profit_given from sales)

select h.harvest_id,h.harvested,s.sale_id,s.sales_profit from harvest h inner join sales s
on h.harvest_id=s.harvest_id 
where h.harvested >(select avg_crops from high_crops) 
and s.sales_profit <(select avg_sales_profit_given from avg_sales_profit);

select farm_id,harvest_id,harvested,case
  when harvested>=3000 then 'excellent'
  when harvested<=2000 then 'great'
  when harvested<=15000 then 'good'
else 'need_improvement'
end as overall_performing
from harvest;

















