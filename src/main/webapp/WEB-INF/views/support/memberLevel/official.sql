show tables;

create table official(
	idx int primary key auto_increment, 
	nick varchar(30) not null, 
	bname varchar(50) not null, 
	bnumber varchar(50), 
	addrCode varchar(20), 
	addr1 varchar(100), 
	addr2 varchar(100), 
	addr3 varchar(100), 
	mname varchar(30), 
	department varchar(30), 
	bank varchar(20) not null, 
	accountHolder varchar(30) not null, 
	accountNum varchar(50) not null, 
	homepage varchar(100), 
	etc text, 
	checked boolean default false;
	foreign key (nick) references member(nick) on update cascade on delete cascade
);

desc member;


		
select * from official;