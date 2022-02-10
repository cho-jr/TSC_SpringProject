show tables;




create table ticketing(
	idx int primary key auto_increment, 
	memberNick varchar(30) not null, 
	performIdx int not null, 
	performScheduleIdx int not null, 
	selectSeatNum varchar(100) not null, 
	price int not null, 
	usePoint int not null,
	finalPrice int not null, 
	payBy varchar(20) not null, 
	payDate datetime default CURRENT_TIMESTAMP,
	print boolean not null default false, 
	foreign key (memberNick) references member(nick), 
	foreign key (performIdx) references perform(idx),
	foreign key (performScheduleIdx) references performSchedule(idx)
);

desc ticketing;

select * from ticketing;

select ticketing.idx as idx, ticketing.memberNick as memberNick, 
perform.title as performTitle, perform.theater as performTheater, 
DATE_FORMAT(performSchedule.schedule, '%Y년 %m월 %d일 %H:%i') as performSchedule, 
ticketing.selectSeatNum as selectSeatNum, 
perform.seat as performSeat, ticketing.price as price, 
ticketing.print as print
from ticketing, perform, performSchedule 
where ticketing.performIdx = perform.idx 
and ticketing.performScheduleIdx = performSchedule.idx 
and performSchedule.performIdx = perform.idx
order by ticketing.idx desc;

