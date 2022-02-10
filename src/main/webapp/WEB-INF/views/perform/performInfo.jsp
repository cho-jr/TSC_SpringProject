<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link href="${ctp}/css/calendar.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css'/>
<style>
	body{font-size: 1.1em;}
	h2{font-weight: 500;}
	section hr{height:2px;color:#000;background-color: #111;}
	th, td {font-size: 1.1em;}
	.info th, td{padding-left:5px;}

    .top{position: fixed;bottom:100px; right:20px;font-size: 2em;border-radius: 8px;display: none;}
    
	.ticketingInfo {
		text-align: center;
		color:#000;
		font-size: 1.3em;
		font-weight: 600;
		background-color: #dac7c7aa;
		line-height: 2em;
		border-radius: 8px;
		border: 1px solid #ccc;
	}
	#discountTable td {padding: 3px 5px;}
	#priceTable td {padding: 3px 5px;}
	
	.mynav {border:1px solid #fff0;border-bottom:1px solid #d69;padding:5px;background-color: #efefef;}
	.mynav .mynav-item {width:230px;font-size:1.5em;text-align: center;padding:5px;}
	.mynav:hover {border:1px solid #d69a;}
	.act {border:1px solid #d69;border-bottom:0;background-color: #fff;}
	.act:hover {border-bottom:1px solid #fff0;}
	
	.star-rating {
	  display:flex;
	  flex-direction: row-reverse;
	  font-size:1.5em;
	  justify-content:space-around;
	  padding:0 0.2em;
	  text-align:center;
	  width:5em;
	}
	
	.star-rating input { display:none;}
	
	.star-rating label {color:#ccc;cursor:pointer;}
	
	.star-rating :checked ~ label {color:#f90;}
	
	.star-rating label:hover,
	.star-rating label:hover ~ label {color:#fc0;}
	
	.inner-star::before{color: #FF9600;}
	.outer-star {position: relative;display: inline-block;color: #CCCCCC;}
	.inner-star {position: absolute;left: 0;top: 0;width: 0%;overflow: hidden;white-space: nowrap;}
	.outer-star::before, .inner-star::before {content: '\f005 \f005 \f005 \f005 \f005';font-family: 'Font Awesome 5 free';font-weight: 900;}
				
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$('#lost_mask').css({'width':'0','height':'0'});
		$("img").attr("style", "width:100%");
		$("#poster").attr("style", "width:320px");
		$("p").css("fontSize", "1.2em");
		$(".this").parent().css('cursor', 'pointer');
		$(".detail").toggle(0);
		$("#remainSeat").hide();
		$(".cardAdv").attr("style", "width:160px");
		
		if('${tab}'=='review'){
			window.scrollTo(0, $("#review").position().top+1000);
		}
	});
	
	function show(idx) {
		$(".det"+idx).toggle(0);
		$(".sum"+idx).toggle(0);
	}
	
	var remainSeatNum = [];
	function selectDate(date){
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		$("#remainSeat").hide();
		myform.scheduleIdx.value="";
		
		const selectDate = new Date(date);
		for (let date of document.querySelectorAll('.this')) {
		    if (+date.innerText === selectDate.getDate()) {
		        date.classList.add('selected');
		    } else {
		    	date.classList.remove('selected');
		    }
		}
		var query = {
				schedule : date, 
				performIdx : ${vo.idx}
		}
		//ajax로 선택한 날짜(, 공연idx)의 공연 시간 가져옴
		$.ajax({
			type: "post", 
			url: "${ctp}/perform/getPerformTime", 
			data : query, 
			success : function(data) {
				var now = new Date();
				now.setHours(now.getHours() + 1);
				var timeHtml = "";
				for(let i=0; i<data.length; i++) {
					var performTime = new Date(data[i].schedule);
					var time = data[i].schedule.substring(11, 16);
					if(performTime < now){
						timeHtml += '<div class="btn btn-outline-secondary mt-1 mr-1 timeBtn" '
									+'id="timeBtn'+i+'" onclick="fail()" >'+time+'</div>';					
					} else {
						timeHtml += '<div class="btn btn-outline-danger mt-1 mr-1 timeBtn"'
									+' id="timeBtn'+i+'" onclick="getSeatInfo('+i+',\''+data[i].idx+'\')">'
									+time+'</div>';					
					}
					remainSeatNum[i] = data[i].remainSeatNum;
				}
				$("#remainSeat span").html('');
				$("#performTime").html(timeHtml);
				$('#lost_mask').css({'width':'0','height':'0'});
			}, 
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	// fail(공연시간 임박 또는 지남 예매 불가)
	function fail() {alert("예매 불가한 상품입니다. ");}
	
	function getSeatInfo(i, scheduleIdx) {
		$("#scheduleIdx").val(scheduleIdx);
		var thisTimeSeat = remainSeatNum[i].split(',');
		for(let j=0; j<thisTimeSeat.length; j++) {
			$("#remainSeat").hide();
			$("#remainSeatNum"+j).html(thisTimeSeat[j]+"석");
			$("#remainSeat").fadeIn(20);
		}
		
		$(".timeBtn").removeClass("btn-danger");
		$(".timeBtn").addClass("btn-outline-danger");
		
		$("#timeBtn"+i).removeClass("btn-outline-danger");
		$("#timeBtn"+i).addClass("btn-danger");
	}
	
	// 예매 페이지로 이동
	function fCheck() {
		if(!loginCheck()) return false;
		else {
			if(myform.scheduleIdx.value!="") myform.submit();
			else location.href="${ctp}/ticketing/ticketing";
		}
	}
	
	$(document).on("click", "input[name=rating]", function() {
		reviewForm.star.value = $(this).val();
	});
	
	$(document).on("click", "input[name=updateRating]", function() {
		$("#updateStar").val($(this).val());
	});
	
	//리뷰등록
	function submitReview(){
		var nick = reviewForm.nick.value;
		if(!loginCheck()) return false;
		var performIdx = reviewForm.performIdx.value;
		var star = reviewForm.star.value;
		if(star=="") {
			alert("별점을 입력해주세요.");
			return false;
		}
		var reviewContent = reviewForm.reviewContent.value;
		reviewContent = reviewContent.replace('<', '&lt;');
		reviewContent = reviewContent.replace('>', '&gt;');
		var query = {
				performIdx : performIdx, 
				nick : nick, 
				star : star, 
				reviewContent : reviewContent 
		}
		var yStar = "";
		for(let i=0; i<star; i++){yStar += '★';}
		var bStar = "";
		for(let i=0; i<5-star; i++){bStar += '★';}
		reviewContent = reviewContent.replaceAll("\n", "<br/>");
		$.ajax({
			type : "post", 
			url : "${ctp}/perform/addReview", 
			data : query, 
			success : function(data) {
				if(data=="fail") {
					alert("로그인이 필요한 서비스 입니다. ");
					location.href="${ctp}/member/login";
				} else if(data == "warn"){
					alert("리뷰를 작성할 수 없습니다. ");
				} else {
					data = data.split('/');
					var newReview = '<table class="table table-borderless" id="table'+data[0]+'">'+
										'<tr>'+
											'<td style="width:30%;padding:0;" class="pl-1">'+nick;
											
					if(data[1]=='ok'){
						newReview += '&nbsp;<span style="opacity: 0.6;" class="badge badge-pill badge-danger">관객</span>';
					}						
					newReview += '</td>'+
											'<td class="text-right"  style="padding:0;">'+
												'<button onclick="deleteReview('+data[0]+')" class="btn">삭제</button>'+
												'<button onclick="updateReview()" class="btn">수정</button>'+
												'<button onclick="report('+data[0]+')" class="btn">신고</button>'+
											'</td>'+
										'</tr>'+
										'<tr><td style="padding:0;" class="pl-1" id="star'+data[0]+'">'+
											'<span style="color:#f90">'+yStar+'</span>'+bStar+'new'+
											'</td></tr>'+
										'<tr><td colspan="2" id="reviewContent'+data[0]+'">'+reviewContent+'</td></tr>'+
									'</table>'+
									'<hr style="background-color:#ddd; height:1px;"/>';
					var oldHtml = $("#reviewList").html();
					$("#reviewList").html(newReview + oldHtml);
					reviewForm.reviewContent.value="";
					$("#reviewCnt").html(Number($("#reviewCnt").html())+1);
				}
			}, 
			error:function() {
				alert("이미 리뷰를 작성 하셨습니다. \n작성한 리뷰는 [마이페이지]-[리뷰관리]에서 조회/수정 가능합니다. ");
				reviewForm.reviewContent.value="";
			}
		});
	}
	
	// 리뷰 삭제
	function deleteReview(idx) {
		var ans = confirm("리뷰를 삭제하시겠습니까?");
		if(!ans) return false;
		
		$.ajax({
			type: "post", 
			url: "${ctp}/perform/reviewDelete", 
			data : {idx:idx+0}, 
			success: function() {
				alert("삭제되었습니다. ");
				location.reload();
			}, 
			error:function() {
				alert("전송오류");
			}
		});
	}
	
	// 마이페이지 내가쓴 리뷰로 이동
	function updateReview() {
		var ans = confirm("[마이페이지]-[내가쓴리뷰]에서 수정 가능합니다. 마이페이지로 이동하시겠습니까?");
		if(!ans) return false;
		location.href="${ctp}/member/mypage/myReview/myReview";
	}
	
	// 네비바 스크롤에 따른 클래스 변경
	var detailInfo = 0;
	var theater = 0;
	var review = 0;
	var ticketCancle = 0; 
	$(document).ready(function() {
		
		$(window).scroll(function() {
			detailInfo = $("#detailInfo").position().top+600;
			theater = $("#theater").position().top+600;
			review = $("#review").position().top+600;
			ticketCancle = $("#ticketCancle").position().top+600;
			
			var scroll = $(window).scrollTop();
			if(scroll < theater) {
				$("#mynav-detailInfo").addClass("act");
				$("#mynav-theater").removeClass("act");
				$("#mynav-review").removeClass("act");
				$("#mynav-ticketCancle").removeClass("act");
			} else if(theater < scroll && scroll < review) {
				$("#mynav-detailInfo").removeClass("act");
				$("#mynav-theater").addClass("act");
				$("#mynav-review").removeClass("act");
				$("#mynav-ticketCancle").removeClass("act");
				$(".cardAdv").fadeIn(300);
			} else if(review < scroll && scroll < ticketCancle) {
				$("#mynav-detailInfo").removeClass("act");
				$("#mynav-theater").removeClass("act");
				$("#mynav-review").addClass("act");
				$("#mynav-ticketCancle").removeClass("act");
				$(".cardAdv").fadeOut(300);
			} else if(ticketCancle < scroll) {
				$("#mynav-detailInfo").removeClass("act");
				$("#mynav-theater").removeClass("act");
				$("#mynav-review").removeClass("act");
				$("#mynav-ticketCancle").addClass("act");
				$(".cardAdv").fadeIn(300);
			}
		});
	});
	
	// 로그인 여부 확인
	function loginCheck(){
		var sNick = '${sNick}';
		if(sNick==""){
			let ans = confirm("로그인이 필요한 서비스입니다. ");
			if(!ans) return false;
			location.href="${ctp}/member/login";
			return false;			
		} return true;
	}
	// 신고처리
	function report(idx) {
		if(!loginCheck()) return false;
		var sNick = '${sNick}';
		var ans = prompt("신고 사유를 입력해주세요. ");
		if(ans=="" || ans==null) {
			alert("신고처리 되지 않았습니다. ");
			return false;
		}
		
		var query = {
				reporterNick : sNick, 
				reviewIdx:idx, 
				reason:ans
		}
		
		$.ajax({
			type:"post", 
			url:"${ctp}/perform/reportReview",  		
			data: query, 
			success:function() {
				alert("신고처리하였습니다. 불편을 드려 죄송합니다. 더 나은 TSC를 위해 노력하겠습니다. ");
			}
		});
	}
	
	function setSchedule(){
		url = "${ctp}/member/mypage/myPerform/updatePerformSchedule?idx=${vo.idx}";
		window.open(url, "scheduleWin", "width=600px, height=600px");
	}
	
</script>
</head>
<body>
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5556;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div class="spinner-border" style="margin: auto;"></div>
		</div>
	</div> 
	<header id="header"><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section class="">
		<article class="">
			<div class="" style="margin:0 auto;width:1100px;">
				<br/><br/>
				<h2>
					&lt;${vo.title}&gt;
				</h2>
				<hr/>
				<table>
					<tr>
						<td class="align-top" style="width:28%"><img src="${ctp}/${vo.posterFSN}" id="poster" style="width:300px;"/></td>
						<td class="align-top" style="border-right: 1px solid #ccc;width:42%">
							<table class="table table-borderless info">
								<tr>
									<th style="width:22%;">장소</th>
									<td>
										<a href="${ctp}/perform/theaterMap?theater=${vo.theater}" title="극장 위치 보러가기">
											<b>${vo.theater}</b>
										</a>
									</td>
								</tr>
								<tr><th>기간</th><td>${fn:substring(vo.startDate,0,10)} ~ ${fn:substring(vo.endDate,0,10)}</td></tr>
								<tr><th>관람시간</th><td>${vo.runningTime} 분</td></tr>
								<c:if test="${vo.rating!=0}">
									<tr><th>관람등급</th><td>만 ${vo.rating}세 이상</td></tr>
								</c:if>
								<c:if test="${vo.rating==0}">
									<tr><th>관람등급</th><td>전체관람가</td></tr>
								</c:if>
								<tr><td style="padding:3px;" colspan="2"></td></tr>
								<tr style="border: 1px solid #ccc;"></tr>
								<tr><td style="padding:3px;" colspan="2"></td></tr>
								<tr>
									<th>가격</th>
									<td class="pt-2">
										<table id="priceTable">
											<c:set var="seatArr" value="${fn:split(vo.seat,',')}"/>
											<c:set var="priceArr" value="${fn:split(vo.price,',')}"/>
											
											<c:forEach var="seat" items="${seatArr}" varStatus="st">
												<tr><td>${seat} - <span class="emphasis text-danger">${priceArr[st.index]}</span>원</td></tr>
											</c:forEach>
										</table>
									</td>
								</tr>
								<tr><td style="padding:3px;" colspan="2"></td></tr>
								<tr><td style="padding:3px;" colspan="2"></td></tr>
								<tr>
									<th>할인</th>
									<td class="pt-2">
										<table id="discountTable">
											<c:set var="saleArr" value="${fn:split(vo.sale,',')}"/>
											<c:set var="salePriceArr" value="${fn:split(vo.salePrice,',')}"/>
											<c:set var="saleMethodArr" value="${fn:split(vo.saleMethod,',')}"/>
											
											<c:forEach var="sale" items="${saleArr}" varStatus="st">
												<tr>
													<td>
														${saleArr[st.index]} - <span class="emphasis text-danger">${salePriceArr[st.index]}</span>
														<c:if test="${saleMethodArr[st.index]==1}">% 할인</c:if>
														<c:if test="${saleMethodArr[st.index]==2}">원 할인</c:if>
														<c:if test="${saleMethodArr[st.index]==3}">원</c:if>
													</td>
												</tr>
											</c:forEach>
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td class="align-top" style="width:30%;" id="calendar">
					        <h3>
					        	&lt;공연 일정&gt;
					        	<c:if test="${email==vo.manager}">
					        		<button class="btn btn-danger btn-sm" onclick="setSchedule()">일정 등록</button>
					        		<button class="btn btn-outline-danger btn-sm" onclick="location.href='${ctp}/member/mypage/myPerform/performList'">내작품관리</button>
					        	</c:if>
					        </h3>
 					    	<!-- 자바스크립트 달력 -->
					    	<div class="calendar">
	    						<div class="calheader row">
							        <div class="year-month col-8 pl-4"></div>
							        <div class="nav col-3" id="moveDate2">
								        <button class="nav-btn go-prev" onclick="prevMonth()"><i class="fas fa-angle-left"></i></button>
								        <button class="nav-btn go-today" onclick="goToday()"><i class="fas fa-carrot"></i></button>
								        <button class="nav-btn go-next" onclick="nextMonth()"><i class="fas fa-angle-right"></i></button>
							        </div>
							        <div class="col-1"></div>
							    </div>
							    <div class="main">
							        <div class="days">
								        <div class="day">일</div>
								        <div class="day">월</div>
								        <div class="day">화</div>
								        <div class="day">수</div>
								        <div class="day">목</div>
								        <div class="day">금</div>
								        <div class="day">토</div>
							        </div>
							        <div class="dates"></div>
							    </div>
							</div>
							<script type="text/javascript">
								var scheduleVos = '${scheduleVos}';
							</script>
							<script src="${ctp}/js/performInfoCalendar.js"></script>
							<div class="ml-4"><span style="background-color:#d563">&nbsp; &nbsp; &nbsp;</span> : 공연 있는 날</div>
							<br/>
					    	<div class="ticketingInfo">예매 가능 회차</div>
					    	<div id="performTime" class="text-center pl-4 mb-1">
					    	</div>
					    	<div class="ticketingInfo">예매 가능 좌석</div>
					    	<div id="remainSeat" class="mt-1" style="font-size:1.2em; font-weight: 600;">
					    		<c:forEach var="seat" items="${seatArr}" varStatus="st">
					    			${seat}: <span id="remainSeatNum${st.index}"></span>&nbsp;&nbsp;<br/>
					    		</c:forEach>
					    	</div>
					    	<br/>
					    	<form method="post" name="myform" action="${ctp}/ticketing/ticketing">
					    		<div class="text-right mr-4"><button type="button" onclick="fCheck()" class="btn btn-danger btn-lg">예매하기</button></div>
						    	<input type="hidden" id="scheduleIdx" name="scheduleIdx"/>
					    	</form>
						</td>
					</tr>
				</table>
			</div>
		</article>
		<article class="row">
			<div class="col-2"></div>
			<section style="width:960px;" class="col-8">
				<hr width="960px"/>
				<div style="color:#111;font-weight:600;background-color: #fff; width:100%;margin:0;position: sticky; top:0; z-index: 99;">
					<ul class="nav"style="justify-content: flex-start;">
					    <li class="mynav act" id="mynav-detailInfo">
					        <a class="mynav-item" href="#detailInfo">상세정보</a>
					    </li>
					    <li class="mynav" id="mynav-theater">
					        <a class="mynav-item" href="#theater">극장</a>
					    </li>
					    <li class="mynav" id="mynav-review">
					        <a class="mynav-item" href="#review">리뷰</a>
					    </li>
					    <li class="mynav" id="mynav-ticketCancle">
					        <a class="mynav-item" href="#ticketCancle">예매 취소 안내</a>
					    </li>
					</ul>
				</div><br/>
				<br/>
				<!-- 상세정보, 리뷰, 예매 취소 안내 페이지네이션처럼 선택하기-->
				<article id="detailInfo">
					<h3>상세정보</h3><hr/>
					<div class="container" style="width:900px;height: 500px; overflow: hidden;">
						<c:set var="content" value="${fn:replace(vo.content, newLine, '<br/>')}"/> 
						<c:set var="content" value="${fn:replace(vo.content, '<p>&nbsp;</p>', '<br/>')}"/> 
						${content}
					</div>
					<div style="text-align: center;"><button class="btn btn-outline-danger btn-lg" id="showMoreDI">상세 정보 더보기 👇🔽</button></div>
					<script type="text/javascript">
						$(document).on("click", "#showMoreDI", function() {
							$("#detailInfo>div").css("height", "auto");
							$("#showMoreDI").remove();
							setTimeout(function(){
								detailInfo = $("#detailInfo").position().top-200;
								review = $("#review").position().top-200;
								ticketCancle = $("#ticketCancle").position().top-200;
							}, 10)
						});
					</script>
				</article>
				<br/><br/><br/><br/>
				<article id="theater">
					<c:if test="${not empty theaterVo}">
						<%@ include file="/WEB-INF/views/perform/theaterMap.jsp" %>
					</c:if>
					<c:if test="${empty theaterVo}">
						<h3>극장</h3>
						<hr/>
						<h5> 정보가 없습니다. </h5>
					</c:if>
				</article>
				<br/><br/><br/><br/>
				<article id="review">
					<h3>리뷰<span style="font-size: 0.8em;">(<span id="reviewCnt">${pagingVO.totRecCnt}</span> 건)</span> <b>${fn:substring(reviewAvg, 0, 3)}</b>/5점 </h3><hr/> <!-- 리뷰는 페이징 -->
					<div class="container" style="width:900px; overflow: hidden;">
						<div class="star-rating">
							<input type="radio" id="5-stars" name="rating" value="5" />
							<label for="5-stars" class="star">&#9733;</label>
							<input type="radio" id="4-stars" name="rating" value="4" />
							<label for="4-stars" class="star">&#9733;</label>
							<input type="radio" id="3-stars" name="rating" value="3" />
							<label for="3-stars" class="star">&#9733;</label>
							<input type="radio" id="2-stars" name="rating" value="2" />
							<label for="2-stars" class="star">&#9733;</label>
							<input type="radio" id="1-star" name="rating" value="1" />
							<label for="1-star" class="star">&#9733;</label>
						</div>
						<form name="reviewForm" method="post" action="${ctp}/perform/addReview">
							<input type="hidden" name="performIdx" value="${vo.idx}">
							<input type="hidden" name="nick" value="${sNick}">
							<input type="hidden" name="star">
							<textarea rows="5" class="form-control" name="reviewContent" maxlength="500" onclick="loginCheck()" placeholder="이메일, 전화번호 등 개인정보를 남기면 타인에 의해 악용될 수 있습니다. "></textarea>
							<button type="button" class="btn btn-danger" onclick="submitReview()">등록</button>
						</form>
						<hr/>
						<div class="container">
							<div id="reviewList">
								<c:forEach var="rvo" items="${reviewVos}">
									<table class="table table-borderless" id="table${rvo.idx}">
										<tr>
											<td style="width:30%;padding:0;" class="pl-1">
												<c:if test="${empty rvo.nick}"><span style="color:#777;">(알 수 없음)</span></c:if>
												${rvo.nick}
												<c:if test="${rvo.watched}">
													<span style="opacity: 0.6;" class="badge badge-pill badge-danger">관객</span>
												</c:if>
											</td>
											<td class="text-right" style="padding:0;">
												<c:if test="${not empty sNick && (rvo.nick==sNick || slevel==2)}">
													<button onclick="deleteReview(${rvo.idx})" class="btn btn-sm">삭제</button>
													<button onclick="updateReview()" class="btn btn-sm">수정</button>
												</c:if>
												<button onclick="report(${rvo.idx})" class="btn btn-sm">신고</button>
											</td>
										</tr>
										<tr>
											<td style="padding:0;" class="pl-1" id="star${rvo.idx}">
												<c:choose>
													<c:when test="${rvo.star==1}"><span style="color:#f90">★</span>★★★★</c:when>
													<c:when test="${rvo.star==2}"><span style="color:#f90">★★</span>★★★</c:when>
													<c:when test="${rvo.star==3}"><span style="color:#f90">★★★</span>★★</c:when>
													<c:when test="${rvo.star==4}"><span style="color:#f90">★★★★</span>★</c:when>
													<c:when test="${rvo.star==5}"><span style="color:#f90">★★★★★</span></c:when>
													<c:otherwise>별점 없음</c:otherwise>
												</c:choose>
												${fn:substring(rvo.WDate, 0, 10)}
											</td>
										</tr>
										<tr>
											<td colspan="2" id="reviewContent${rvo.idx}" onclick="show(${rvo.idx})">
												<div id="summary${rvo.idx}" class="summary sum${rvo.idx}">
													<c:if test="${fn:contains(rvo.reviewContent, '@@WARN')}">
														<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
													</c:if>
													<c:if test="${not fn:contains(rvo.reviewContent, '@@WARN')}">
														${fn:substring(rvo.reviewContent, 0, 50)}
														<c:if test="${fn:length(rvo.reviewContent)>50}">...</c:if>
													</c:if>
												</div>
												<c:set var="reviewContent" value="${fn:replace(rvo.reviewContent, newLine, '<br/>')}"/> 
												<div id="detail${rvo.idx}" class="detail det${rvo.idx}">
													<c:if test="${fn:contains(reviewContent, '@@WARN')}">
														<span style="color:#777">관리자에 의해 숨겨진 글입니다. </span>
													</c:if>
													<c:if test="${not fn:contains(reviewContent, '@@WARN')}">
														<c:out value="${reviewContent}" escapeXml="false"/>											
													</c:if>
												</div>
											</td>
										</tr>
									</table>
									<hr style="background-color:#ddd; height:1px;"/>
								</c:forEach>
							</div>
							<c:set var="linkpath" value="perform/performInfo"/>
							<c:set var="idx" value="${vo.idx}"/>
							<c:set var="tab" value="review"/>
							<%@ include file="/WEB-INF/views/include/paging.jsp" %>	
						</div>
					</div>
				</article>
				<br/><br/><br/><br/>
				<article id="ticketCancle">
					<h3>예매 취소 안내</h3><hr/>
					<div class="container" style="width:900px;height: 500px; overflow: hidden;color:#333; line-height: 2em;">
				        <strong>[티켓 수령 안내]</strong>
				        <div class="contents">
			                <strong>1) 일반배송</strong><br>
							티켓 예매 확인 후 인편으로 배송되며, 예매 후 10일 이내(영업일 기준) 수령 가능합니다.<br>
							일괄 배송 상품의 경우 고지된 배송일 이후 10일 이내(영업일 기준) 수령 가능합니다.<br>
							배송비는 행사에 따라 상이합니다. 상품 상세 페이지 안내에서 확인할 수 있습니다. <br>
							행사 또는 행사일에 따라 우편배송 방법의 선택이 제한될 수 있습니다.<br><br>
				
				
							<strong>2) 현장수령</strong><br>
							행사당일 공연 시작 1시간~30분 전까지 행사장 매표소에서 수령하실 수 있습니다.<br>
							예매번호, 예매하신 분의 신분증(필수), 예매확인서(프린트 또는, 티켓링크 앱 예매확인 페이지)를 매표소에 제시하시면 편리하게 티켓을 수령하실 수 있습니다.<br>
							행사 또는 행사일에 따라 현장수령 방법의 선택이 제한될 수 있습니다.<br>
							수령장소는 각 행사장 매표소이며, 매표소의 예매자 전용 창구를 이용하시면 됩니다. <br>
				        </div>
				    
				    
				        <strong>[예매 취소 안내]</strong>
				        <div class="contents">
			                <strong>예매 취소 시 주의사항</strong><br>	 
			                티켓 예매 후 7일 이내에 취소 시, 취소수수료가 없습니다. <br>
			                단, 예매 후 7일 이내라도 취소 시점이 공연일로부터 10일 이내라면 그에 해당하는 취소수수료가 부과됩니다.<br>
			                예매 당일 자정(12:00) 전에 취소할 경우 예매 수수료가 환불되며, 그 이후에는 환불되지 않습니다.<br>
			                예매티켓 취소는 아래 안내된 취소가능일 이내에만 할 수 있습니다.	 
			                <table class="detail_info_tbl mgt15">
				                <caption>예매 취소 안내</caption>
				                <colgroup><col style="width: 180px;"><col style="width: 130px;"><col></colgroup>
				                <thead>
				                	<tr>
				                		<th rowspan="1" colspan="1" scope="col">행사일</th><th rowspan="1" colspan="1" scope="col">배송방법</th>
				                		<th rowspan="1" colspan="1" scope="col">취소가능시간</th>
				                	</tr>
				                </thead>
				                <tbody>
				                	<tr><td rowspan="2">평일/토요일</td><td>현장수령</td><td>행사 전 일, 17:00까지</td></tr>
				                	<tr><td>인편배송</td><td>행사 전 일, 17:00까지 반송하여 도착하는 티켓</td></tr>
				                	<tr><td rowspan="2">일요일</td><td>현장수령</td><td>행사 전 토요일, 17:00까지</td></tr>
				                	<tr><td>인편배송</td><td>행사 전 토요일, 11:00까지 반송하여 도착하는 티켓</td></tr>
				                	<tr><td rowspan="2">행사전일 : 평일<br>행사일 : 연휴기간/연휴다음날</td><td>현장수령</td><td>행사 전 일, 17:00까지</td></tr>
				                	<tr><td>인편배송</td><td>행사 전 일, 17:00까지 반송하여 도착하는 티켓</td></tr>
				                	<tr><td rowspan="2">행사전일 : 토요일<br> 행사일 : 연휴기간/연휴다음날</td><td>현장수령</td><td>연휴 전 토요일, 17:00까지</td></tr><tr><td>인편배송</td><td>연휴 전 토요일, 11:00까지 반송하여 도착하는 티켓</td></tr>
				                </tbody>
			                </table>
			                <p>
			                	롯데콘서트홀 공연의 경우 관람일 하루 전 18:00까지 취소 가능하며, 토/일/월 공연의 경우 금요일 18:00까지 취소 가능합니다.<br>
			                	클립서비스 연동 판매 공연의 경우 일요일 관람 공연은 토요일 오전 11:00까지 취소 가능합니다.</p>
			                <p>&nbsp;</p>
			                <p>
			                	구입하신 예매채널을 통해서만 취소가 가능합니다. (티켓링크에서는 티켓링크에서 예매한 티켓만 취소 가능합니다.) <br>
			                	구입하신 티켓의 일부분 취소, 날짜/시간/좌석등급/좌석위치 변경은 불가능합니다. (관련 상담 : 티켓링크 콜센터 1588-7890)<br>
			                	반송 시, 고객님의 예매번호와 연락처, 반송사유, 환불계좌, 예금주를 적으셔서 티켓과 동봉해 보내주시면 정확한 처리에<br>
			                	 도움이 됩니다.<br>
			                	 취소 가능 시간이 공연일까지 3일 이상 남지 않았을 경우 특급우편을 이용하거나 콜센터 1588-7890으로 문의 바랍니다.<br>
			                	 발송 받으신 티켓이 분실되거나 훼손되었을 경우 취소 및 변경이 절대 불가합니다.<br>
			                	 공연상의 문제로 환불을 받으실 경우 별도의 수수료를 공제하지 않으며, 환불 주체가 티켓링크가 아닌 행사 주최사가 <br>
			                	 될 수 있습니다.
			                </p>
			                <p><strong>취소수수료 안내</strong><br>
			                무통장 입금으로 결제하신 경우, 취소수수료와 송금수수료 500원을 제외한 나머지 금액이 고객 환불 계좌에 입금됩니다.<br>
			                	환불은행, 계좌번호, 예금주는 본인명의로 정확히 입력 부탁드리며, 취소처리를 접수한 날로부터 3~5일 이내에 환불 받으실 수 있습니다.<br>
							또한, 타인의 계좌를 이용하거나 명의를 도용했을 경우 서비스 이용이 제한될 수 있습니다.<br>
							신용카드로 결제 시, 취소수수료 및 우편 발송비를 재승인 후 기존 승인금액을 취소 처리합니다.
							</p>
							티켓금액의 10%
							<table class="detail_info_tbl mgt15"><caption></caption>
								<colgroup><col style="width: 86px;"><col style="width: 163px;"><col style="width: 180px;"><col></colgroup>
								<thead>
									<tr>
									<th rowspan="1" colspan="2" scope="col">행사일</th>
									<th rowspan="1" colspan="1" scope="col">취소수수료 (인터넷, 콜센터)</th>
									<th rowspan="1" colspan="1" scope="col">비고</th>
									</tr>
								</thead>
								<tbody>
									<tr>
									<th rowspan="5" colspan="1">공연 / 전시</th>
										<td>예매후 7일 이내 / 예매당일</td>
										<td>없음</td>
										<td rowspan="8">예매 당일에 취소하는 경우 이외에는<br>예매수수료가 환불되지 않음 (약관 25조 의거)<br><br>예매 후 7일 이내라도 취소 시점이 공연일로부터<br>10일 이내라면 그에 해당하는 취소수수료가 부과됨<br>(약관 29조 의거)</td>
									</tr>
									<tr>
										<td>예매후 8일 ~ 관람일 10일 전</td>
										<td>뮤지컬, 콘서트, 클래식 등 공연권<br>: 장당 4,000원<br>	 연극, 전시 등 입장권 <br>	 장당 2,000원<br>* 티켓금액의 10% 이내</td>
									</tr>
									<tr>
										<td>관람일 9일 전 ~ 7일 전</td>
								                <td>티켓금액의 10%</td></tr>
									
									<tr>
										<td>관람일 6일 전 ~ 3일 전</td>
										<td>티켓금액의 20%</td></tr>
									<tr>
										<td>관람일 2일 전 ~ 1일 전</td>
										<td>티켓금액의 30%</td>
									</tr>
									<tr>
									<th rowspan="2" colspan="1" scope="row">스포츠</th>
										<td>예매당일</td>
										<td>예매 당일 밤 12시 이전 취소시에는 취소수수료 없음 <br>(단, 취소기한내에 한함)</td>
									</tr>
									<tr>
										<td>예매 익일~취소마감시간 전</td>
										<td>티켓금액의 10%</td>
									</tr>
								</tbody>
							</table>
				        </div>
				        <strong>[티켓 환불 안내]</strong>
				        <div class="contents">
				            <span class="fbold">신용카드</span> : 취소 시 승인이 취소됩니다.<br><span class="fbold">무통장입금</span> : 인터넷 또는 콜센터(1588-7890)로 접수된 고객님의 환불계좌로 입금해드립니다.
				        </div>
				        <strong>[기타 안내]</strong>
				        <div class="contents">
			                <p><span class="fbold"><strong>입금 계좌 번호</strong></span> </p><p>예매 완료 페이지에 별도 표시 (기록해두면 환불 시 편리합니다.)<br>
							<strong></strong></p><p><strong><br></strong></p><p><strong>주의사항</strong>
							<br>입금 계좌를 분실했을 경우 예매확인/취소 메뉴를 이용해서 각 예매건에 대한 입금계좌를 확인하시기 바랍니다.
							<br>1일 1건 이상 무통장 입금으로 티켓을 예매한 경우, 각각의 예매건에 대한 입금계좌가 다르게 부여됩니다.
							<br>예매금액과 입금금액이 일치하지 않을 경우 입금 오류가 발생하여 입금처리 되지 않습니다. 예매 시 예매금액을 꼭 확인하세요.
							<br>예매당일을 포함하여 그 다음날  23:59(주말 및 공휴일 포함)까지 지정된 계좌로 입금하셔야만 예매가 유효합니다.</p><p>&nbsp;</p><p><span style="line-height: 1.5;">은행에 따라 23:30에 온라인 입금이 마감되는 경우가 있으니 참고 부탁드립니다.</span>
							(단, 외환은행, 수협은 22:40에 온라인 입금이 마감됩니다.)</p>
							<p>&nbsp;</p><p>무통장 입금의 경우 입금 확인 및 고객 확인을 위한 기간이 필요하므로 이용기간이 제한됩니다. 양해 부탁 드립니다.
							<br>예매 당일을 포함하여 그 다음날  23:59(주말 및 공휴일 포함)까지 입금하지 않으실 경우 별도의 통보 없이 예매가 취소됩니다.</p>
				        </div>
				        <strong>[예매수수료 안내]</strong>
				        <div class="contents">
				                티켓링크 인터넷, 콜센터를 통한 티켓 예매 시, 소정의 수수료가 부과됩니다. (시행일 2002.3.4)<br><br>
				        </div>
					</div>
					<div style="text-align: center;"><button class="btn btn-outline-danger btn-lg" id="showMoreTC">예매 취소 안내 더보기 👇🔽</button></div>
					<script type="text/javascript">
						$(document).on("click", "#showMoreTC", function() {
							$("#ticketCancle>div").css("height", "auto");
							$("#showMoreTC").remove();
						});
					</script>
				</article>
			</section>
			<div class="col-2 pl-0" style="margin-top: 80px;">
				<div style="position:sticky; top:80px;">
					<img class="cardAdv" src="${ctp}/images/advertise/${CAVo1.FSName}"/>
					<img class="cardAdv" src="${ctp}/images/advertise/${CAVo2.FSName}"/>
				</div>
			</div>
		</article>
	</section>
	<br/><br/><br/><br/>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>