create database youtube;
use youtube;
create table creaters(creater_id int primary key,creater_name varchar(255));
insert into creaters values(123,"sameer"),(124,"sampath"),(125,"kushwath"),(126,"varun"),(127,"khadeer");
select * from creaters;

create table uploaded(uploaded_id int primary key,creater_id int,uploaded_videos int,foreign key(creater_id) references creaters(creater_id));
insert into uploaded values(900,123,909),(901,124,834),(902,125,434),(903,126,343),(904,127,990);
select * from uploaded;
select * from uploaded inner join creaters on uploaded.creater_id=creaters.creater_id;

create table categories(category_id int primary key,uploaded_id int,creater_id int,category_type varchar(255),
foreign key(uploaded_id) references uploaded(uploaded_id),foreign key(creater_id) references creaters(creater_id));

insert into categories values(800,900,123,"COMEDEY"),(801,901,124,"HORROR"),
(802,902,125,"SUSPENCE-THRILLER"),(803,903,126,"DIVINE"),(804,904,127,"RAW-TALKS"),
(805,900,123,"DAILY-NEWS"),(806,901,124,"SC-FI"),(807,902,125,"MYSERIOUS"),(808,903,126,"WEATHER-REPORTS"),(809,904,127,"SHORTS");

select * from categories;
select * from categories inner join creaters on categories.creater_id=creaters.creater_id inner join 
uploaded on categories.uploaded_id=uploaded.uploaded_id;

create table views(views_id int primary key,creater_id int,uploaded_id int,total_views bigint,
foreign key(creater_id) references creaters(creater_id),foreign key(uploaded_id) references uploaded(uploaded_id));

insert into views values(700,123,900,454325),(701,124,901,453454),(702,125,902,989798),
(703,126,903,989835),(704,127,904,9978908);

select * from views;
select * from views inner join creaters on views.creater_id=creaters.creater_id inner join uploaded on views.uploaded_id=uploaded.uploaded_id;

create table likes(likes_id int primary key,creater_id int,uploaded_id int ,total_likes bigint,
foreign key(creater_id) references creaters(creater_id),foreign key(uploaded_id) references uploaded(uploaded_id));

insert into likes values(600,123,900,3254454),(601,124,901,9980908),(602,125,902,98970987),
(603,126,903,980979708),(604,127,904,98097987);
select * from likes inner join creaters on likes.creater_id=creaters.creater_id 
inner join uploaded on likes.uploaded_id=uploaded.uploaded_id;

create table comments(comments_id int primary key,creater_id int,uploaded_id int,total_comments bigint, 
foreign key(creater_id) references creaters(creater_id),foreign key(uploaded_id) references uploaded(uploaded_id));
insert into comments values(600,123,900,980970),(601,124,901,97907008),(602,125,902,9809708),
(603,126,903,987070798),(604,127,903,8098080);

select * from comments;
select * from comments inner join creaters on comments.creater_id=creaters.creater_id 
inner join uploaded on comments.uploaded_id=uploaded.uploaded_id;

with mul_categories as 
(select c.creater_id,c.creater_name,count(o.category_type) as mul_categorieses from 
creaters c inner join categories o on c.creater_id=o.creater_id group by c.creater_id having 
count(o.category_type)>1)
select * from mul_categories;

with higher_views as 
(select avg(total_views) as avg_views from views)
select c.creater_id,sum(v.total_views) as higher_total_views from creaters c inner join views v on c.creater_id=v.creater_id 
group by c.creater_id having sum(v.total_views) >
(select avg_views from higher_views);


with higher_likes as 
(select avg(total_likes) as avg_likes from likes)
select c.creater_id,sum(l.total_likes) as higher_total_likes from creaters c inner join likes l on c.creater_id=l.creater_id 
group by c.creater_id having sum(l.total_likes) >
(select avg_likes from higher_likes);

with higher_comments as 
(select avg(total_comments) as avg_comments from comments)
select c.creater_id,sum(s.total_comments) as higher_total_comments from creaters c inner join comments s on c.creater_id=s.creater_id 
group by c.creater_id having sum(s.total_comments) >
(select avg_comments from higher_comments);

select avg(total_views) avg_views_per_video from views;

select sum(total_likes) as total_likeses from likes;

select sum(total_comments) as total_comments from comments;

with latest_videos as 
(select u.uploaded_id,u.uploaded_videos,v.total_views,lag(v.total_views) over (order by v.total_views desc) as 
latest_videoss from views v inner join uploaded u on v.uploaded_id=u.uploaded_id)
select * from latest_videos;

select uploaded_id,total_views,total_views-lag(total_views) over (order by total_views desc) as 
latest_videos,case 
  when  total_views-lag(total_views) over (order by total_views desc)> total_views then "views_increased"
else "views_decreased"
end as latest_performances
from views;









