show tables;

create table faq (
	idx int primary key auto_increment, 
	question varchar(50) not null, 
	answer text not null, 
	views int default 0
);