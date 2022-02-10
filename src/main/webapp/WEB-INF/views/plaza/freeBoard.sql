
show tables;

create table freeBoard(
	idx int primary key auto_increment, 
	nick varchar(30), 
	title varchar(100) not null, 
	content text not null, 
	wDate datetime default now(), 
	views int default 0, 
	foreign key (nick) references member(nick) on update cascade on delete set null
);

select * from freeboard;

/** 댓글 테이블 만들기 **/
create table boardReply(
	idx int primary key auto_increment, 
	boardIdx int not null, 
	nick varchar(30), 
	content text not null, 
	wDate datetime default now(), 
	level int not null default 0,
	levelOrder int not null default 0,	
	foreign key (boardIdx) references freeBoard(idx) on delete cascade, 
	foreign key (nick) references member(nick) on delete set null on update cascade 
);

desc boardReply;



create table recommend(
	nick varchar(30), 
	boardIdx int not null, 
	rDate datetime default now(), 
	foreign key (boardIdx) references freeBoard(idx) on delete cascade, 
	foreign key (nick) references member(nick) on delete set null on update cascade
);

desc member;

select count(*) from boardReply where boardIdx = 10 and date_format(wDate, '%Y-%m-%d') > date_add(now(), interval -24 hour);