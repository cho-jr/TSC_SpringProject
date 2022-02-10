<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<link href="${ctp}/css/calendar.css" rel="stylesheet" type="text/css" />
<style>
	h2{letter-spacing :-3px;}
	td a:hover {text-decoration: underline;}
	#selectedTable {width:1000px;height:150px;border:2px solid #444; overflow: scroll;}
	#selectedTable tr td {font-weight: 600; font-size: 1.3em;padding: 15px; line-height: 1.5em;}
	#selectedTable tr td a {font-size: 1.2em;}
	#dataTable {width:100%;min-width:750px;height:400px;background-color: #eee;}
	#dataTable tr td {font-weight: 600; font-size: 1.1em; padding: 15px; line-height: 1.5em;}
	table table tr:hover {background-color: #ccc4};
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
</style>
<script type="text/javascript">
	$(function() {
		$('#lost_mask').css({'width':'0','height':'0'});
		$(".this").parent().css('cursor', 'pointer');
		$(".performList").on("click", function() {
			$(".performList").css("backgroundColor", "#eee")
			$(this).css("backgroundColor", "#bbb");
		});
		if(choicePerform!=""){
			$("#perform"+choicePerform+" a").trigger("click");
			$("#perform"+choicePerform).css("backgroundColor", "#bbb");
			
			selectDate(schedule.substring(0, 10));
			
			setTimeout(getSeatInfo, 200, '${scheduleVo.idx}', '${scheduleVo.schedule}');
		}
	});
	
	var scheduleVos = '${scheduleVos}';
	if('${sTicketingVO}' != "") {
		
		var ans = confirm("진행중인 예매가 있습니다. 결제 페이지로 이동하시겠습니까?");
		if(ans) {
			location.href = "${ctp}/ticketing/payment";
		}
	}

	var choicePerform="${scheduleVo.performIdx}";
	var schedule="${scheduleVo.schedule}";
	
	var performSeat = "";
	var performPrice = "";
	var performSale = "";
	var performSalePrice = "";
	var performSaleMethod = "";
	
	// 공연 선택
	function selectPerform(performIdx, title, theater, rating, runningTime, seat, price, sale, salePrice, saleMethod) {
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		
		myform.performIdx.value = performIdx;
		performSeat = seat.split(',');
		performPrice = price.split(',');
		performSale = sale.split(',');
		performSalePrice = salePrice.split(',');
		performSaleMethod = saleMethod.split(',');
			
		// 선택한 공연 정보 selectedTable에 보여주기
		if(rating==0) rating="전체이용가";
		else rating="만 "+rating+"세 이상";
		
		$("#selectedTitle").html('<a href="${ctp}/perform/performInfo?idx='+performIdx+'" title="상세정보 보러가기">'+title+'</a>');
		$("#selectedTheater").html('<a href="${ctp}/perform/performInfo?idx='+performIdx+'#theater"  style="font-size:1em;" target="_blank" title="극장 위치 보러가기">'+theater+'</a>');
		$("#selectedRunningTime").html(runningTime+"분");
		$("#selectedRating").html(rating);
		
		myform.performTitle.value=title;
		myform.performTheater.value=theater;
		myform.performSeat.value=seat;
		
		// 기존 정보 초기화
		$("#selectSeat").html("");
		$("#performTime").html("");
		$(".totalPrice").html("0원");
		$("#date").html("");
		$("#time").html("");
		$("#showSelectSeat").html("(미선택)");
		for (let date of document.querySelectorAll('.this')) {
		    	date.classList.remove('selected');
		}
		myform.performScheduleIdx.value=0;
		myform.selectSeatNum.value=0;
		myform.price.value=0;
		
		// 해당 공연 일정 가져와서 달력에 미리 보여주기
		$.ajax({
			type: "post", 
			url: "${ctp}/ticketing/getPerformScheduleList", 
			data : {performIdx : performIdx}, 
			success : function(data) {
					scheduleVos = data;
					renderCalender();
					$('#lost_mask').css({'width':'0','height':'0'});
			}
		});
	}
	
	// 날짜별 공연 정보 가져오기
	var remainSeatNum = [];
	function selectDate(date){
		$("#date").html(date);
		
		// 공연, 날짜 외 다른 정보 초기화
		$("#selectSeat").html("");
		$("#performTime").html("");
		$(".totalPrice").html("0원");
		$("#time").html("");
		$("#showSelectSeat").html("(미선택)");
		myform.performScheduleIdx.value=0;
		myform.selectSeatNum.value=0;
		myform.price.value=0;
		var performIdx = myform.performIdx.value;
		if(performIdx=="") {
			alert("작품을 선택해주세요. ");
			return false;
		}	
		
		var query = {
				schedule : date, 
				performIdx : performIdx
		}
		//ajax로 선택한 날짜(, 공연idx)의 공연 시간 가져옴
		$.ajax({
			type: "post", 
			url: "${ctp}/perform/getPerformTime", 
			data : query, 
			success : function(data) {
				var timeHtml = "";
				for(let i=0; i<data.length; i++) {
					var time = data[i].schedule.substring(11, 16);
					timeHtml += '<div class="btn btn-outline-danger mt-1 mr-1 timeBtn" id="timeBtn'+data[i].idx+'" onclick="getSeatInfo(\''+data[i].idx+'\', \''+data[i].schedule+'\')">'+time+'</div>';
					remainSeatNum[data[i].idx] = data[i].remainSeatNum.split(',');
				}
				$("#remainSeat span").html('');
				$("#performTime").html(timeHtml);
				if(data.length<1) $("#performTime").html("<br/><h6><b>해당 날짜에는 공연이 없습니다. 😭</b></h6>자세한 일정은 상세페이지를 참고하세요.");
				// 선택한 날짜 달력에 표시
//				const selectedDate = new Date(date);
				const selectedDate = new Date($("#date").html());
				for (let caldate of document.querySelectorAll('.this')) {
				    if (+caldate.innerText == selectedDate.getDate()) {
				    	caldate.classList.add('selected');
				    } else {
				    	caldate.classList.remove('selected');
				    }
				}
			}, 
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	// 잔여좌석, 가격, 할인정보 가져오기
	var finalPricePerTicketArr;
	var remainSeat;
	function getSeatInfo(scheduleIdx, date) {
		myform.selectSeatNum.value=0;
		myform.price.value=0;
		$(".totalPrice").html("0원");
		$("#showSelectSeat").html("(미선택)");
		
		$(".timeBtn").removeClass("btn-danger");
		$(".timeBtn").addClass("btn-outline-danger");
		
		$("#timeBtn"+scheduleIdx).removeClass("btn-outline-danger");
		$("#timeBtn"+scheduleIdx).addClass("btn-danger");
		
		myform.performScheduleIdx.value = scheduleIdx;
		$("#time").html(date.substring(11, 16));
		myform.performSchedule.value = $("#date").html() + " " + $("#time").html();
		
		remainSeat = remainSeatNum[parseInt(scheduleIdx)];
		
		// 좌석별로 할인항목마다 할인가 저장할 배열 만듦
		finalPricePerTicketArr = new Array(performSeat.length);	
		for(let i = 0; i < finalPricePerTicketArr.length; i++) {
			finalPricePerTicketArr[i] = new Array(performSale.length);
		}
		var addForm = "코로나19로 인해 1인 4매까지 구매 가능합니다. <br/>";
		console.log(remainSeat);
		if(remainSeat.indexOf(',')!=-1){
			$("#selectSeat").hide();
			addForm += '잔여 좌석수 : '+remainSeat+'<div class="input-group mb-3">'+
			'<br/><div class="input-group-prepend">'+
			'<span class="input-group-text">'+performSeat+'</span>';
			let j = 0;
			if(remainSeat<4) {
				addForm +='</div><input type="number" name="selectSeatNum" id="selectSeatNum'+j+'" class="form-control select" value="0" min="0" max="'+remainSeat+'"/></div>';
			} else {
				addForm +='</div><input type="number" name="selectSeatNum" id="selectSeatNum'+j+'" class="form-control select" value="0" min="0" max="4"/></div>';
			}
			addForm += "<select class='form-control select' id='selectPrice"+j+"'>";
			saleCalc(j,performPrice); // j번째 좌석 가격
			
			addForm += "<option value='"+performPrice+"'>일반 - "+performPrice+"원</option>";
			for(let k=0; k<finalPricePerTicketArr[j].length; k++){
				addForm += "<option value='"+finalPricePerTicketArr[j][k]+"'>"+performSale[k]+" - "+finalPricePerTicketArr[j][k]+"원</option>";
			}
			addForm += "</select><hr/>";
		} else{
			for(let j=0; j<remainSeat.length; j++){
				$("#selectSeat").hide();
				addForm += '잔여 좌석수 : '+remainSeat[j]+'<div class="input-group mb-3">'+
						'<br/><div class="input-group-prepend">'+
						'<span class="input-group-text">'+performSeat[j]+'</span>';
				if(remainSeat[j]<4) {
					addForm +='</div><input type="number" name="selectSeatNum" id="selectSeatNum'+j+'" class="form-control select" value="0" min="0" max="'+remainSeat[j]+'"/></div>';
				} else {
					addForm +='</div><input type="number" name="selectSeatNum" id="selectSeatNum'+j+'" class="form-control select" value="0" min="0" max="4"/></div>';
				}
				addForm += "<select class='form-control select' id='selectPrice"+j+"'>";
				saleCalc(j,performPrice[j]); // j번째 좌석 가격
				
				addForm += "<option value='"+performPrice[j]+"'>일반 - "+performPrice[j]+"원</option>";
				for(let k=0; k<finalPricePerTicketArr[j].length; k++){
					addForm += "<option value='"+finalPricePerTicketArr[j][k]+"'>"+performSale[k]+" - "+finalPricePerTicketArr[j][k]+"원</option>";
				}
				addForm += "</select><hr/>";
			}
		}
		$("#selectSeat").html(addForm);
		$("#selectSeat").fadeIn(20);
	}
	
	// j번째 좌석의 할인 가격 계산 후 finalPricePerTicketArr[j]에 저장
	function saleCalc(j,price){	
		if(performSaleMethod.length==1){
			if(performSaleMethod==1){
				finalPricePerTicketArr[j][0] = price*(100-performSalePrice)/100;
			} 
			else if(performSaleMethod==2){
				finalPricePerTicketArr[j][0] = price-performSalePrice;
			} 
			else if(performSaleMethod==3){
				finalPricePerTicketArr[j][0] = performSalePrice;
			} 
			
		}
		for(let i=0; i<performSaleMethod.length; i++) {// 할인 항목수만큼 반복
			if(performSaleMethod[i]==1){
				finalPricePerTicketArr[j][i] = price*(100-performSalePrice[i])/100;
			} 
			else if(performSaleMethod[i]==2){
				finalPricePerTicketArr[j][i] = price-performSalePrice[i];
			} 
			else if(performSaleMethod[i]==3){
				finalPricePerTicketArr[j][i] = performSalePrice[i];
			} 
			
		}
	}
	var countCheck = false;
	document.onchange = function(event) {
		var totalPrice = 0;
		var selectSeatNum = "";
		var selectSeat = "";
		var count = 0;
		for(let i=0; i<remainSeat.length; i++){
			if(parseInt($("#selectSeatNum"+i).val())<0){
				alert("좌석 수는 양수만 입력 가능합니다. ");
				$("#selectSeatNum"+i).val(0);
				return false;
			}
			count += parseInt($("#selectSeatNum"+i).val());
			selectSeat += performSeat[i]+": "+$("#selectSeatNum"+i).val()+"매/";
			totalPrice += $("#selectSeatNum"+i).val() * $("#selectPrice"+i).val();
			selectSeatNum += $("#selectSeatNum"+i).val()+",";
		}
		// if(count > 4 || count == 0) {
		if(count > 4) {
			alert("코로나19로 인해 1인당 1~4매까지 구매 가능합니다. ");
			countCheck = false;
		} else {
			countCheck = true;
			myform.ticketNum.value=count;
		}
		selectSeatNum = selectSeatNum.substring(0, selectSeatNum.length-1);
		myform.selectSeatNum.value = selectSeatNum;
		$(".totalPrice").html(totalPrice.toLocaleString('ko-KR')+"원");
		myform.price.value = totalPrice;
		$("#showSelectSeat").html(selectSeat);
	}
	
	function fCheck() {
		var performIdx = myform.performIdx.value;
		var performScheduleIdx = myform.performScheduleIdx.value;
		var selectSeatNum = myform.selectSeatNum.value;
		if(performIdx=="" || performIdx==0) {
			alert("작품을 선택하세요. ");
			return false;
		}
		if(performScheduleIdx=="" || performScheduleIdx==0) {
			alert("공연 일정을 선택하세요. ");
			return false;
		}
		if(selectSeatNum=="" || selectSeatNum==0) {
			alert("구매 좌석을 선택하세요. ");
			return false;
		}
		
		if(!countCheck) {
			alert("구매 가능 수량을 초과하였습니다. ");
			return false;
		}
		const ans = confirm("공연 일시와 좌석을 확인해주세요. 선택하신대로 결제 진행하시겠습니까?");
		if(!ans) return false;
		myform.submit();
	}

</script>
</head>
<body>
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5556;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div class="spinner-border" style="margin: auto;"></div>
		</div>
	</div> 
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section class="row">
		<div class="col-lg-2 col-md-1 col-sm-0"></div>
		<div class="col-lg-8 col-md-10 col-sm-12">
			<br/>
			<%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %>
			<br/><br/>
			<h2>예매</h2>
			<table class="table" id="dataTable">
				<tr>
					<td style="width:30%;">
						공연 목록
						<div style="height:400px;overflow-y: scroll;overflow-x: hidden">
							<table style="width:100%;">
								<c:forEach var="vo" items="${performVos}">
									<tr>
										<td style="border:1px solid #d99" class="performList" id="perform${vo.idx}"
										onclick="selectPerform(${vo.idx}, '${vo.title}', '${vo.theater}', '${vo.rating}', '${vo.runningTime}', '${vo.seat}', '${vo.price}', '${vo.sale}', '${vo.salePrice}', '${vo.saleMethod}')">
											${vo.title}<a href="${ctp}/perform/performInfo?idx=${vo.idx}" style="font-weight:300;">(상세보기)</a><br/>
											${vo.theater}<br/>
											${fn:substring(vo.startDate, 0, 10)} ~ ${fn:substring(vo.endDate, 0, 10)}<br/>
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>
					</td>
					<td style="width:36%;padding-left:0;">
						<div style="height:420px;overflow-y: scroll;overflow-x: hidden">
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
							<script src="${ctp}/js/performInfoCalendar.js"></script>
					    	<div class="ticketingInfo">예매 가능 회차</div>
					    	<div id="performTime" class="text-center pl-4 mb-1">
					    	</div>
				    	</div>
					</td>
					<td style="width:33%;">
						<h4>&lt;좌석 선택&gt;</h4><br/>
						<div style="height:360px;overflow-y: scroll;overflow-x: hidden">
							<p id="selectSeat">작품과 공연 회차를 선택하세요. </p>
							<p>결제 금액 : <span class="totalPrice"></span></p>
						</div>
					</td>
				</tr>
			</table>
			
			<table id="selectedTable" class="mb-4">
				<tr>
					<td style="width:35%;">
						제목 : <span id="selectedTitle"></span><br/>
						장소 : <span id="selectedTheater"></span><br/>
						관람시간 : <span id="selectedRunningTime"></span><br/>
						관람등급 : <span id="selectedRating"></span><br/>
					</td>
					<td style="width:20%;">
						날짜 : <span id="date"></span><br/>
						시간 : <span id="time"></span><br/>
					</td>
					<td style="width:25%;">
						선택 좌석<br/>
						<span id="showSelectSeat"></span>
					</td>
					<td style="width:20%;">
						총 금액 : <span class="totalPrice"></span><br/>
					<form name="myform" method="post" action="${ctp}/ticketing/payment">
						<span style="margin:20px 50%;"><button class="btn btn-danger" type="button" onclick="fCheck()">결제하기</button></span>
						<input type="hidden" name="memberNick" value="${sNick}"/>
						<input type="hidden" name="performIdx"/>
						<input type="hidden" name="performScheduleIdx"/>
						<input type="hidden" name="selectSeatNum"/>
						<input type="hidden" name="price"/>
						
						<input type="hidden" name="performTitle"/>
						<input type="hidden" name="performTheater"/>
						<input type="hidden" name="performSeat"/>
						<input type="hidden" name="performSchedule"/>
						<input type="hidden" name="ticketNum"/>
					</form>
					</td>
				</tr>
			</table>
		</div>
		<div class="col-lg-2 col-md-0 col-sm-0 pl-4">
			<div style="position:sticky; top:20px;">
				<img class="cardAdv" src="${ctp}/images/advertise/${CAVo1.FSName}"/>
				<img class="cardAdv" src="${ctp}/images/advertise/${CAVo2.FSName}"/>
			</div>
		</div>
	</section>
	
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>