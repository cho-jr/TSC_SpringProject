
show tables;
/* 공연 정보 테이블 */
create table perform(
	idx int not null primary key auto_increment, 	/* 고유번호 */
	manager varchar(30) not null, 					/* 담당자 닉네임 */
	title varchar(30) not null, 					/* 제목 */
	theater varchar(100) not null, 					/* 극장, 장소 */
	startdate datetime not null,					/* 공연 시작일 */
	enddate datetime not null,						/* 공연 마지막일 */
	rating varchar(10) default '0',					/* 관람등급 */
	runningTime int, 								/* 관람시간 */
	seat varchar(150) not null,						/* 좌석등급, 이름 */
	price varchar(150) not null,					/* 좌석별가격 */
	sale varchar(150) default '', 					/* 할인항목 */
	salePrice varchar(150) default '', 					/* 할인가격/비율 */
	saleMethod varchar(50) default 0, 					/* 할인방식 1: -n%, 2: -n원 3: n원 */
	posterOGN varchar(200) default 'noimage.jpeg', 		/* 포스터, 대표사진 Original File Name*/
	posterFSN varchar(200) default 'images/perform/poster/noimage.jpeg', 		/* 포스터, 대표사진 File System Name*/
	content text not null, 							/* 상세정보 */
	checked boolean default false					/* 관리자 인증 */
);

/* drop table perform; */
select * from perform;
alter table perform change sale sale varchar(300);
alter table perform change seat seat varchar(300);

alter table perform add column startdate datetime not null;
alter table perform add column enddate datetime not null;

alter table perform modify enddate datetime after startdate;

alter table perform alter column rating set default '0';
alter table perform alter column posterOGN set default 'noimage.jpeg';
alter table perform alter column posterFSN set default 'images/perform/poster/noimage.jpeg';

desc perform;

select * from perform where enddate > now() order by idx desc;


/******************************************************/
/* 공연 일정 테이블 */

/*drop table performSchedule;*/
create table performSchedule(
	idx int not null primary key auto_increment, 
	performIdx int not null, 	
	schedule datetime not null, 
	seatNum varchar(150) not null,
	remainSeatNum varchar(150) not null,
	foreign key (performIdx) references perform(idx) on delete cascade
);

alter table performSchedule add column remainSeatNum varchar(150) not null;

2022-01-08 15:00
select * from performSchedule where schedule='2022-01-08 15:00' and;
select * from performSchedule order by schedule;
select * from performSchedule where performIdx=1 order by schedule;
select * from performSchedule where schedule between date_format('2022-1-8', '%Y-%m-%d') and date_add(date_format('2022-1-8', '%Y-%m-%d'), interval 1 day);
select date_add(date_format('2021-1-3', '%Y-%m-%d'), interval 1 day);
/******************************************************/
create table theater(
	idx int primary key auto_increment,
	name varchar(50) not null, 
	address1 varchar(50) not null, 
	address2 varchar(50) not null, 
	address3 varchar(50) not null
);

select * from theater;
/******************************************************/
/* 리뷰 테이블 */
create table review(
	idx int primary key auto_increment, 
	performIdx int not null, 
	nick varchar(30) not null, 
	star int not null, 
	reviewContent text not null, 
	date datetime default now(), 
	foreign key (performIdx) references perform(idx) on delete cascade, 
	foreign key (nick) references member(nick) on update cascade
);

desc review;

select * from review;
select * from review where performIdx = 1 order by date desc limit 0, 5;

insert into review value(default, 1, '모충동솜방망이', 5, '연말연초에 보기 좋은 극이었어요. 재미있는 이야기를 따뜻하게 풀어내줘서 좋았는데 나와서 생각해보니 사실 좀 차갑고 슬픈 이야기였어요. 따뜻한 프라푸치노 같았습니다.<br/>비눗방울과 오르골 소리 반짝이는 공연장에 있을 때는 마치 환상처럼 아름다운 이야기로 느껴졌는데 생각해보니 한스와 마리에게 닥친 현실이 너무 거대한 비극이었네요. 현실과 환상의 경계를 공연 끝나고 나서까지 경험할 수 있는 특별한 시간을 보낼 수 있었어요.', default);
insert into review values(default, 3, '모충동솜방망이', 5, '모든 배우들의 사랑스러운 연기가 참 좋다!! ', default);
insert into review values(default, 1, '관리자', 5, '재밌어요~', default);
select max(idx) from review;

update review set star=1, reviewContent='수정함' where idx=39;

/******************************************************/
/* 신고 테이블 */
create table report(
	idx int primary key auto_increment, 
	reporterNick varchar(30) not null, 
	reviewIdx int not null, 
	reason text not null, 
	rDate datetime default now(), 
	foreign key (reporterNick) references member(nick) on update cascade,
	foreign key (reviewIdx) references review(idx)
);

select * from report;

/******************************************************/
/* 공연 상세 페이지 조회수 */

create table performInfoViews(
	idx int primary key auto_increment, 
	nick varchar(30), 
	performIdx int not null, 
	vDate datetime default now(), 
	foreign key (nick) references member(nick) on update cascade, 
	foreign key (performIdx) references perform(idx) on delete cascade
);

select * from performInfoViews;


select * from perform
			where checked=true and (manager like concat('%', '', '%') or title like concat('%','', '%')
			or theater like concat('%', '', '%') or sale like concat('%', '', '%'))
and date_format(enddate, '%Y-%m-%d')>=curdate() and date_format(startdate, '%Y-%m-%d')<=curdate()




/******************************************************/
/* 공연 상세 페이지 조회수 */
create table themePerform(
	theme varchar(50); not null, 
	performIdx int not null, 
	foreign key (performIdx) references perform(idx) on delete cascade
)
insert into themePerform values('세상의 모든 걱정을 잊고싶다면!', null);
insert into themePerform values('세상의 모든 걱정을 잊고싶다면!', 9);

insert ignore into themePerform(theme) values('세상의 모든 걱정을 잊고싶다면!') where not exists;
insert ignore into themePerform(theme) values('세상의 모든 걱정을 잊고싶다면!');
insert ignore into themePerform values('세상의 모든 걱정을 잊고싶다면!', null);
REPLACE into themePerform values('세상의 모든 걱정을 잊고싶다면!', null);
insert into themePerform(theme) values('세상의 모든 걱정을 잊고싶다면!');
select * from themePerform where theme = '세상의 모든 걱정을 잊고싶다면!' and performIdx is not null;

select * from themePerform;

insert ignore into themePerform(theme) value('몰아치는 전율!') where not exists;

ALTER TABLE themePerform ADD UNIQUE KEY uniquekey(theme,performIdx);
delete from themePerform where theme = '세상의 모든 걱정을 잊고싶다면!' and performIdx = 8;



/* 관리자가 선택한 theme 목록 */
create table showTheme(
	theme varchar(50) primary key,
	orderInt int,
	foreign key (theme) references themePerform(theme) on update cascade on delete cascade
);

/*drop table showTheme;*/


update review set reviewContent = '@@WARN' where ifnull(idx, 0) = 12;



select * from ticketing 
where memberNick = '관리자' and performIdx=1 and print=true and cancle=false 
and performScheduleIdx in 
(select idx from performSchedule 
where date_format(schedule, '%Y-%M-%d') <= date_format(now(), '%Y-%M-%d')
and performIdx=1);

select * from performSchedule 
where date_format(schedule, '%Y-%M-%d') <= date_format(now(), '%Y-%M-%d')
and performIdx=1;


select * from visitdata;

SELECT DATE_FORMAT(vDate, '%Y-%m-%d') as vDate, count(*) as count
FROM visitdata
GROUP BY DATE_FORMAT(vDate, '%Y%m%d')
ORDER BY vDate ASC;

SELECT DATE_FORMAT(vDate, '%Y-%m-%d %H') as vDate, count(*) as count FROM visitdata	
GROUP BY DATE_FORMAT(vDate, '%H') ORDER BY DATE_FORMAT(vDate, '%H') ASC;


SELECT
  CASE DAYOFWEEK(vDate)
    WHEN 1 THEN "Sun"
    WHEN 2 THEN "Mon"
    WHEN 3 THEN "Tue"
    WHEN 4 THEN "Wed"
    WHEN 5 THEN "Thu"
    WHEN 6 THEN "Fri"
    WHEN 7 THEN "Sat"
  END AS DateRange
,count(*) AS Total
FROM visitdata 
WHERE date_format(vDate,"%Y%m%d") BETWEEN "20181101" AND "20221116"
GROUP BY DAYOFWEEK(vDate);

select title as performTitle, sum(ticketNum) as ticketNum from perform, ticketing 
where ticketing.performIdx = perform.idx group by performIdx
order by sum(ticketNum) desc;

SELECT DATE_FORMAT(vDate, '%Y-%m-%d') as vDate, count(*) as count FROM visitdata	
where DATE_FORMAT(vDate, '%Y-%m-%d') > DATE_ADD(NOW(), INTERVAL -1 MONTH)
GROUP BY DATE_FORMAT(vDate, '%Y%m%d')
ORDER BY vDate ASC;

select count(*) from themeperform where theme = '세상의 모든 걱정을 잊고싶다면!' and performIdx is not null;


select memberNick, ticketNum, addrCode as code 
from ticketing, member where member.nick = ticketing.membernick;


/* 서울 */
(select 'KR-11' as regionCode, '서울' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>0 and cast(substr(addrCode, 1, 2) as unsigned)<=8)
union

/* 경기 */
(select 'KR-41', '경기' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=10 and cast(substr(addrCode, 1, 2) as unsigned)<19)
union
/* 인천 */
(select 'KR-28', '인천' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=21 and cast(substr(addrCode, 1, 2) as unsigned)<24)

/* 강원 */
union
(select 'KR-42', '강원' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=24 and cast(substr(addrCode, 1, 2) as unsigned)<27)

/* 충북+세종 */
union
(select 'KR-43', '충북/세종' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=27 and cast(substr(addrCode, 1, 2) as unsigned)<31)


/* 충남 */
union
(select 'KR-44', '충남' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=31 and cast(substr(addrCode, 1, 2) as unsigned)<34)

/* 대전 */
union
(select 'KR-30', '대전' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=34 and cast(substr(addrCode, 1, 2) as unsigned)<36)

/* 경북 */
union
(select 'KR-47', '경북' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=36 and cast(substr(addrCode, 1, 2) as unsigned)<41)

/* 대구 */
union
(select 'KR-27', '서울' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=41 and cast(substr(addrCode, 1, 2) as unsigned)<44)

/* 울산 */
union
(select 'KR-31', '울산' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=44 and cast(substr(addrCode, 1, 2) as unsigned)<46)

/* 부산 */
union
(select 'KR-26', '부산' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=46 and cast(substr(addrCode, 1, 2) as unsigned)<50)

/* 경남 */
union
(select 'KR-48', '경남' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=50 and cast(substr(addrCode, 1, 2) as unsigned)<54)

/* 전북 */
union
(select 'KR-45', '전북' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=54 and cast(substr(addrCode, 1, 2) as unsigned)<57)

/* 전남 */
union
(select 'KR-46', '전남' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=57 and cast(substr(addrCode, 1, 2) as unsigned)<60)

/* 광주 */
union
(select 'KR-29', '광주' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)>=61 and cast(substr(addrCode, 1, 2) as unsigned)<63)

/* 제주 */
union
(select 'KR-49', '제주' as regionName, sum(ticketNum) as cnt 
from ticketing, member 
where member.nick = ticketing.membernick and
cast(substr(addrCode, 1, 2) as unsigned)=63)
order by cnt desc
;




select ticketing.idx as idx, ticketing.memberNick as memberNick, 
		perform.title as performTitle, perform.theater as performTheater, 
		DATE_FORMAT(performSchedule.schedule, '%Y년 %m월 %d일 %H:%i') as performSchedule, 
		ticketing.selectSeatNum as selectSeatNum, 
		perform.seat as performSeat, ticketing.price as price, 
		ticketing.usePoint as usePoint, ticketing.finalPrice as finalPrice, ticketing.payBy as payBy, 
		ticketing.payDate as payDate,
		ticketing.print as print, 
		ticketing.cancle as cancle
		
		from ticketing, perform, performSchedule 
		where ticketing.performIdx = perform.idx 
		and ticketing.performScheduleIdx = performSchedule.idx 
		and performSchedule.performIdx = perform.idx

		order by date(performSchedule.schedule), time(performSchedule.schedule)





