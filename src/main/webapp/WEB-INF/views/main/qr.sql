show tables;

create table QRTicket(
	ticketIdx int primary key, 
	img varchar(200) not null, 
	foreign key (ticketIdx) references ticketing(idx) on delete cascade on update cascade
);

create table popupNotice(
	noticeIdx int,
	FOREIGN KEY (noticeIdx) REFERENCES notice(idx) on delete cascade on update cascade
)