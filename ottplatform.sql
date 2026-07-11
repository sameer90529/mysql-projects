create database Ottplatform;
use Ottplatform; 
create table user(user_id int primary key,user_name char(45));
insert into user values(142,"sameer"),(143,"varun"),(144,"sampath");
select * from user;

create table movies(movie_id int primary key,movie_name varchar(255) unique key);
insert into movies values(555,"pokiri"),(556,"peddi"),(557,"varanasi");
select * from movies;

create table directors(movie_id int,dir_id int primary key,dir_name char(45),FOREIGN KEY(movie_id) REFERENCES movies(movie_id));
insert into directors values(555,777,"ssrajamouli"),(556,778,"sukumar"),(557,779,"buchhibabu");
select * from directors;
select * from directors inner join movies on directors.dir_id=movies.movie_id; 

create table subsc(subsc_id int primary key,subsc_app varchar(255));
insert into subsc values(3040,"netflix"),(3041,"Z5"),(3042,"primevideo");
select * from subsc;


create table history(movie_id int,watch_history time,user_id int,subsc_id int,
FOREIGN KEY(movie_id) REFERENCES  movies(movie_id),FOREIGN KEY(subsc_id) REFERENCES subsc(subsc_id),FOREIGN KEY(user_id) REFERENCES user(user_id));
insert into history values(555,"10:30:00",142,3040),(556,"7:30:00",143,3041),(557,"9:30:00",144,3042);
select * from history;
select max(watch_history) from history order by movie_id desc;
select sum(user_id)/avg(user_id) from history;
select max(watch_history) from history order by subsc_id desc;
select * from history where watch_history is null;
                     
create table ratings(rating_id int primary key,movie_id int,movie_name char(45),FOREIGN KEY(movie_id) REFERENCES movies(movie_id));
insert into ratings values(222,555,"pokiri"),(223,556,"peddi"),(224,557,"varanasi");
alter table ratings add column rating decimal;
select * from ratings;
update ratings set rating = 4.5 where rating_id=222;
update ratings set rating = 3.5 where rating_id=223;
update ratings set rating = 2.5 where rating_id=224;
select * from ratings;
select * from ratings where rating_id is null;

create table multiple(user_id int,movie_id int,most_movie_watched_name char(45),howmany_times int,
rating_given decimal,FOREIGN KEY(user_id) REFERENCES user(user_id),FOREIGN KEY(movie_id) REFERENCES movies(movie_id));
insert into multiple values(142,555,"Pokiri",13,4.5),(142,556,"peddi",11,2.5),
(143,555,"Pokiri",13,4.5),(143,556,"peddi",11,2.5),(143,555,"Pokiri",13,4.5),
(144,556,"peddi",11,2.5);
select * from multiple;

create table dir_ratings(dir_id int,dir_name char(45),movie_name char(45),movie_id int,dir_rating decimal);
insert into dir_ratings values(777,"ssrajamouli","pokiri",555,3.5),(778,"sukumar","peddi",556,4.5),
(779,"buchhibabu","varanasi",557,2.5);
select * from dir_ratings;
select avg(dir_rating) from dir_ratings order by dir_id desc;





