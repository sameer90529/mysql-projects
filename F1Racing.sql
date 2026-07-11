create database racing;
use racing;
create table drivers(driver_id int primary key,driver_name char(45));
insert into drivers values(123,"sameer"),(124,"sameeer"),(125,"samer"),(126,"sampath");
select * from drivers;

create table teams(team_id int primary key,driver_id int,team_name char(45),race_id int);
insert into teams values(9090,123,"CSK",6565),(9091,124,"SRH",6566),(9092,125,"RCB",6567);
select * from teams;
select * from teams inner join drivers on teams.driver_id=drivers.driver_id;
select * from teams left join drivers on  teams.driver_id=drivers.driver_id;

create table race(race_id int primary key,team_id int,race_name char(45),race_won int,driver_id int,foreign key(team_id)
 references teams(team_id),foreign key(driver_id) references drivers(driver_id));
insert into race values(1919,9090,"F1",3,123),(1918,9091,"F1",8,124),(1917,9092,"F1",2,125);
select * from race;

select *,rank() over(order by race_won desc ) 
as performances_of_teams from race;

select team_id,rank() over(order by race_won desc ) 
as performances_of_teams from race;

alter table drivers add column scores int;
update drivers set scores=183 where driver_id=123;
update drivers set scores=193 where driver_id=124;
update drivers set scores=143 where driver_id=125;
select * from drivers;

select * from drivers group by driver_id having max(scores)>0;

alter table drivers add column_points int;
update drivers set column_points=898 where driver_id=123;
update drivers set column_points=983 where driver_id=124;
update drivers set column_points=798 where driver_id=125;
select * from drivers;

select driver_id,driver_name,rank() over (order by column_points desc) as total_points from drivers;

select driver_id,driver_name,lag(column_points) over(order by driver_id) as previous_points from drivers;
select driver_id,driver_name,lead(column_points) over(order by driver_id) as previous_points from drivers;

SELECT
    team_id,
    AVG(race_won) AS avg_wins
FROM race
GROUP BY team_id
HAVING AVG(race_won) >
(
    SELECT AVG(race_won)
    FROM race
);

select driver_id,driver_name,rank() over(partition by driver_id order by column_points desc) as best_drivers from drivers;

