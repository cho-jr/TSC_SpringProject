show tables;

create table notice(
	idx int primary key auto_increment, 
	title varchar(50) not null, 
	content text not null, 
	wDate datetime default now(),
	views int default 0, 
	important int default 0		/* 안중요한거 0, 중요할 수록 숫자 증가 */
);

insert into notice values(default, '[필독]리뷰 모아보기 기능 추가 안내', '<p>안녕하십니까 회원 여러분!</p>

<p>많은 분들께서 리뷰 모아보기 기능 추가를 제안해주셨는데요,&nbsp;&nbsp;</p>

<p>드디어 TSC에 리뷰 모아보기 기능이 탄생했습니다~~!!</p>

<p>메인 화면 &#39;광장&#39; 에서 두번째 탭 &#39;리뷰 모아보기&#39;를 클릭하시면 모든 공연의 리뷰를 조회하실 수 있습니다!</p>

<p>참 편리하겠죠~?</p>

<p>&nbsp;</p>

<p>제안해주신 다른 기능도 얼른 준비해서 찾아뵙겠습니다!</p>

<p>커밍 쑨-☆</p>', default, default, 3);