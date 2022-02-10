show tables;

create table advertise(
	idx int primary key auto_increment, 
	OFName varchar(200) not null, 
	FSName varchar(200) not null, 
	adtype varchar(10) not null, 
	title varchar(100), 
	subMent text, 
	checked boolean default true
);