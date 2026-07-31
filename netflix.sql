
create table content(content_id int primary key,title varchar(255),genre varchar(255),
production_studio varchar(255),total_viewers int );

insert into content values(123,"pokiri","romance-action","anapurna-studio",3000000),
(124,"maharshi","drama-action","NKRstudio",3100000),
(125,"spyder","scifi-action","SP-production",100010),
(126,"1","scifi-emotion","FOX-STUDIO",4000053);
select * from content;

create table viewers(view_id int primary key,content_id int,title varchar(255),watching_time time,
foreign key(content_id) references content(content_id));

insert into viewers values(4545,123,"pokiri","18:00:00"),(4646,124,"maharshi","23:00:00"),
(4747,125,"spyder","12:00:00"),(4848,126,"1","45:00:00");
select * from viewers;
select * from viewers inner join content on viewers.content_id=content.content_id;

create table revenue(revenue_id int,view_id int ,subsc_revenue bigint,content_id int,foreign key(view_id)
 references viewers(view_id),foreign key(content_id) references content(content_id));

insert into revenue values(8989,4545,700000,123),(8988,4646,670000,124),(8987,4747,900000,125),(8986,4848,790000,126);
select * from revenue;
select * from revenue inner join viewers on revenue.view_id=viewers.view_id inner join 
content on revenue.content_id=content.content_id;

create table ratings (rating_id int primary key,view_id int,content_id int,rating_given decimal ,
foreign key(view_id) references viewers(view_id),foreign key(content_id) references content(content_id));

insert into ratings values(9090,4545,123,4.5),(9091,4646,124,4.3),(9092,4747,125,4.4),(9093,4848,126,4.9);
select * from ratings;
select * from ratings inner join content on ratings.content_id=content.content_id 
inner join viewers on ratings.view_id=viewers.view_id;

select 
title ,content_id,
case

  when title='pokiri' then 2006
  when title='maharshi' then 2023
  when title='spyder' then 2022
  when title='1' then 2014
else 'no-realse-date'
end as year_of_relases
from content;
select * from content;


with movie_status as
(
select r.rating_id,r.content_id,t.title,t.watching_time,r.rating_given,t.view_id,
case 
  when t.watching_time="24:00:00" and r.rating_given>=4.5 then 'Blockbuster'
  when t.watching_time="18:00:00" and r.rating_given>=4.0 then 'Hit'
  when t.watching_time="16:00:00" and r.rating_given<=3.9 then 'Average'
else 'flop'
end as move_hit_status
from viewers t inner join ratings r on t.view_id=r.view_id)
select * from movie_status;

with avg_revenue as
(select avg(subsc_revenue) as avg_revenue_gotf from revenue)
select r.revenue_id,r.subsc_revenue,v.content_id from revenue r inner join content v on r.content_id=v.content_id
where r.subsc_revenue >(select avg_revenue_gotf from avg_revenue);

select revenue_id,content_id,lag(subsc_revenue) over(order by subsc_revenue desc) as previous_revenu from revenue;

select revenue_id,content_id,lead(subsc_revenue) over(order by subsc_revenue desc) as next_revenu from revenue;

select revenue_id,content_id,row_number() over(order by subsc_revenue desc) as next_revenu from revenue;


SELECT
    content_id,
    SUM(watching_time) AS total_watch_time
FROM viewers
GROUP BY content_id
HAVING SUM(watching_time) > 0;

select content_id,title,lag(title) over (order by content_id desc) as title_lag from content;

select content_id,total_viewers from content  where total_viewers>100000 order by content_id desc ;







