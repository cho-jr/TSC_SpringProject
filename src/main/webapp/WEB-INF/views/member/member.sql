show databases;

show tables;

CREATE TABLE member(
  nick VARCHAR(30) NOT NULL,
  email VARCHAR(100) NOT NULL,
  pwd VARCHAR(100) NOT NULL,
  name VARCHAR(30) NOT NULL,
  phone VARCHAR(100) NOT NULL,
  birth DATE NOT NULL,
  addrCode VARCHAR(20) NOT NULL,
  addr1 VARCHAR(100) NOT NULL,
  addr2 VARCHAR(100) NOT NULL,
  addr3 VARCHAR(100) NOT NULL,
  level INT DEFAULT 0,	/* 0: 일반회원, 1: 관계자, 2: 관리자 */
  joinDate DATETIME NOT NULL DEFAULT NOW(),
  lastDate DATETIME NOT NULL DEFAULT NOW(),
  point INT NOT NULL DEFAULT 0,
  PRIMARY KEY(nick)
);

DESC member;

select * from member;
/*DROP TABLE member;*/
/* 1234 암호화 한 것 : $2a$10$RVnhC2YNE2UMhgXRIXDjV.qns43fwkhDxO379F04.atfRiqHgs/Py  */
update member set pwd = '$2a$10$wDzUGG2vjIv7/hlCEgNrHuteP574YF5s51qMV/A8gROAuHGgvwI/u' where email = 'pksaho@hanmail.net';
update member set pwd = '$2a$10$RVnhC2YNE2UMhgXRIXDjV.qns43fwkhDxO379F04.atfRiqHgs/Py' where name = '관리자';
update member set email = 'admin' where addr2 = '';
update member set name = '박상훈' where email = 'pksaho@hanmail.net';
update member set name = '조재령' where addr2 = '103호';
update member set level = 2 where email = 'admin';

select * from member where email = 'admin'; 
select * from member where nick like '%모%' order by joinDate desc;
select * from member where nick like concat('%', '모', '%') order by joinDate desc;
select * from member where nick like ‘모%’ order by joinDate desc;
select * from member where nick='모솜' order by joinDate desc;
select * from member  order by joinDate desc;
select concat('a', 'b')
select * from member where nick like '%모%';
select count(*) from ticketing where memberNick = '관리자';

update member set nick = '관리자린고비' where nick = '관리자';

update member set addrCode = #{addrCode}, addr1 = #{addr1}, addr2 = #{addr2}, addr3 = #{addr3} where nick = #{nick};


/* 방문 데이터 수집 */

create table visitData(
	idx int primary key auto_increment, 
	vDate datetime default now(), 
	nick varchar(30), 
	sessionId varchar(60) not null, 
	hostIp varchar(50) not null, 
	foreign key (nick) references member(nick) on update cascade
);

select * from visitData;




select * from performSchedule where performIdx = 1 and date_format(schedule, '%Y-%m-%d')=date_format('2022-1-30', '%Y-%m-%d');

select count(*) from freeboard where date_format(wDate, '%Y-%m-%d %H') > date_add(now(), interval -24 hour);

