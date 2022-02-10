show tables;

create table qna(
	idx int primary key auto_increment, 
	nick varchar(30) not null, 
	email varchar(100) not null, 
	title varchar(100) not null, 
	content text not null, 
	alert boolean default false, 
	wDate datetime default now(), 
	answer text, 
	aDate datetime, 
	foreign key (nick) references member(nick) on delete cascade on update cascade
);

select * from qna;

create table suggestion(
	idx int primary key auto_increment, 
	nick varchar(30) not null, 
	email varchar(100) not null, 
	title varchar(100) not null, 
	content text not null, 
	wDate datetime default now(), 
	foreign key (nick) references member(nick) on delete cascade on update cascade
);

show tables;

select * from suggestion where condition = 0;
desc suggestion;
select * from suggestion;
alter table suggestion add _condition int not null default 0;
ALTER TABLE suggestion MODIFY condition int NOT NULL DEFAULT 'E33268';
