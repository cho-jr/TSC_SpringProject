<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/setPerform/updatePerformSchedule"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style>
    #td1,#td8,#td15,#td22,#td29,#td36 {color: red;}
    #td7,#td14,#td21,#td28,#td35,#td42 {color: blue;}
    .today { font-size: 1.5em;background-color: pink;color: #fff;}
    .badge:hover{cursor: pointer;}
    .chkDay, input[name=selectedDate] {visibility: hidden;} 
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$('#myModal').on('hide.bs.modal', function () {
			  location.reload();
		});
		$('#manyModal').on('hide.bs.modal', function () {
			  location.reload();
		});
		$("#selectAll").on("change", function() {
			if($("#selectAll").is(":checked")) {
				$("input[name=selectedDate]").prop("checked", true);
				$(".chkDay").prop("checked", true);
				$("input[name=selectedDate]").parent().parent().css("backgroundColor", "#fff");
				$("input[name=selectedDate]:checked").parent().parent().css("backgroundColor", "#fdd");
			} else {
				$("input[name=selectedDate]").prop("checked", false);
				$(".chkDay").prop("checked", false);
				$("input[name=selectedDate]").parent().parent().css("backgroundColor", "#fff");
			}
		});
		$("td").on("click", function(){
			if($(this).children().children().is(":checked")) {
				$(this).children().children().prop("checked", false);
				$("input[name=selectedDate]").parent().parent().css("backgroundColor", "#fff");
				$("input[name=selectedDate]:checked").parent().parent().css("backgroundColor", "#fdd");
			} else {
				$(this).children().children().prop("checked", true);
				$("input[name=selectedDate]").parent().parent().css("backgroundColor", "#fff");
				$("input[name=selectedDate]:checked").parent().parent().css("backgroundColor", "#fdd");
			}
			
			if($("input[name=selectedDate]:checked").length==$("input[name=selectedDate]").length) {
				$("#selectAll").prop("checked", true);
			} else {
				$("#selectAll").prop("checked", false);
			}
			
			for(var i=1; i<=7; i++) {
				if($("td:nth-child("+i+") a input[name=selectedDate]:checked").length==$("td:nth-child("+i+") a input[name=selectedDate]").length){
					$("#chkDay"+i).prop("checked", true);
					$("th:nth-child("+i+")").css("backgroundColor", "#ddd");
				} else {
					$("#chkDay"+i).prop("checked", false);
					$("th:nth-child("+i+")").css("backgroundColor", "#eee");
				}
			}
		});
		$("th").on("click", function(){
			if($(this).children().is(":checked")) {
				$(this).children().prop("checked", false);
				$("td:nth-child("+$(this).children().val()+") a input[type=checkbox]").prop("checked", false);		
				$(this).css("backgroundColor", "#eee");
			} else {
				$(this).children().prop("checked", true);				
				$("td:nth-child("+$(this).children().val()+") a input[type=checkbox]").prop("checked", true);
				$(this).css("backgroundColor", "#ddd");
			}
			
			if($(".chkDay:checked").length==$(".chkDay").length) {
				$("#selectAll").prop("checked", true);
			} else {
				$("#selectAll").prop("checked", false);
			}
			$("input[name=selectedDate]").parent().parent().css("backgroundColor", "#fff");
			$("input[name=selectedDate]:checked").parent().parent().css("backgroundColor", "#fdd");
		});
	});


	
	//ajax로 등록 후 reload
	function registPerformSchedule(opt) {
		var performIdx = $("#performIdx").val();
		var startDate = new Date("${fn:substring(performVo.startDate, 0, 10)}");
		var endDate = new Date("${fn:substring(performVo.endDate, 0, 10)}");
		// 정규화, 데이터 확인~~
		var date = $("#date").val();
		var time = $("#time").val();
		
		if(date=="") {
			alert("날짜를 입력하세요");
			return false;
		}
		var newDate = new Date(date);
		if(newDate<startDate || newDate>endDate) {
			alert("공연 기간과 입력한 일자가 일치하지 않습니다. ");
			return false;
		}
		if(time =="") {
			alert("시간을 입력하세요");
			return false;
		}
		var schedule = date +" "+ time;
		
		var sw = true;
		var seatNum = "";
		var sumAllSeat = 0;
		
		$("input[name=seatNum]").each(function(index, item) {
			if($(item).val().trim()=="") {
				alert("모든 좌석 수를 입력하세요. (없으면 0 입력)");
				sw = false;
				return false;
			}
			seatNum += ","+$(item).val();
			sumAllSeat += parseInt($(item).val());
		});
		seatNum = seatNum.substring(1);
		seatNumArr = seatNum.split(',');
		var query = {
				performIdx : performIdx, 
				schedule : schedule,
				seatNum : seatNum
		}
		if(!sw) return false;
		
		
		$.ajax({
			type : "post", 
			url : "${ctp}/admin/setPerform/updatePerformSchedule", 
			data : query, 
			success : function(data) {
				if(data=="fail") {
					alert("같은 일정 정보가 있습니다. 기존 일정 삭제 후 등록 가능합니다. ");
					return false;
				} else {
					if(opt==1) location.reload();
					else {
						alert("등록 되었습니다.");
						var addHtml = "";
						addHtml += '<div style="border:2px solid #ed4357;padding:10px;"><b>추가 '+ time + '</b><br/> 좌석 정보 (잔여/전체) 예매율<br/>';
						for(var i=0; i<seatNumArr.length;i++){
							addHtml += seatArr[i]+' ('+seatNumArr[i]+'/'+seatNumArr[i]+') 0% <br/>';
						}
						addHtml += '전체 예매율 : (0/'+sumAllSeat+') 0% <br/>'
											+'<button type="button" onclick="deleteSchedule('+parseInt(data)+')" class="btn btn-danger btm-sm p-1">삭제</button></div><br/>';
						
						$("#scheduleInfo").html($("#scheduleInfo").html() + addHtml);
					}
				}
			}
		});
	}
	
	// 일정 삭제
	function deleteSchedule(idx) {
		var ans = confirm("일정을 삭제하시겠습니까? ");
		if(!ans) return false;
		
		$.ajax({
			type : "post", 
			url : "${ctp}/admin/setPerform/deletePerformSchedule", 
			data : {idx : idx}, 
			success : function() {
				alert("삭제했습니다. ");
				location.reload();
			}
		});
	}
	var seatArr;
	function showModal(ymd){
		var performIdx = ${performVo.idx};
		var bodyHtml = "";
		$("#myModalTitle").html(ymd + ' 공연 일정 <button class="btn btn-danger" onclick="showRegistForm(\''+ymd+'\')">+</button>');
		// ajax로 일정 가져와!
		var query = {
				ymd:ymd,
				performIdx:performIdx
				};
		$.ajax({
			type:"post", 
			url: "${ctp}/member/mypage/myPerform/getScheduleDetail" , 
			data : query, 
			success: function(data) {
				for(let i=0;i<data.length;i++) {
					bodyHtml += '<div style="border:2px solid #ed4357;padding:10px;"><b>'+(i+1) + '회차 ' 
						+ data[i].schedule.substring(11, 16) + "</b><br/> 좌석 정보 (잔여/전체) 예매율<br/>";
					seatArr = data[i].seat.split(',');
					var seatNumArr = data[i].seatNum.split(',');
					var remainSeatNumArr = data[i].remainSeatNum.split(',');
					
					var sumAllSeat = 0;
					var sumRemainSeat = 0;
					for(let j=0;j<seatArr.length; j++){
						bodyHtml += seatArr[j]+' ('+remainSeatNumArr[j]+'/'+seatNumArr[j]+') ';
						if(seatNumArr[j] !='0'){
							bodyHtml += Math.floor((seatNumArr[j]-remainSeatNumArr[j])/seatNumArr[j]*100)+'%';
						}
						bodyHtml += '<br/>';
						sumAllSeat += parseInt(seatNumArr[j]);
						sumRemainSeat += parseInt(remainSeatNumArr[j]);
					}
					bodyHtml += '전체 예매율 : ('+(sumAllSeat-sumRemainSeat)+'/'+sumAllSeat+') '+Math.floor((sumAllSeat - sumRemainSeat)/sumAllSeat*100)+'% <br/>'
					+'<button type="button" onclick="deleteSchedule('+data[i].idx+')" class="btn btn-danger btm-sm p-1">삭제</button></div><br/>';
				}
				$("#scheduleInfo").html(bodyHtml);
				$("#addScheduleForm").toggle();
				$("#myModal").modal();
			}
		});
	}
	
	function showRegistForm(ymd){
		ymd = dateformating(ymd);
		$("#date").val(ymd);
		$("#addScheduleForm").toggle(100);
	}
	
	function dateformating(ymd){
		var date = new Date(ymd);
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var day = date.getDate();
		var format = year+"-"+(("00"+month.toString()).slice(-2))+"-"+(("00"+day.toString()).slice(-2));
		return format;
	}
	
	var cnt = 0;
	function batchRegist() {
		if($("input[name=selectedDate]:checked").length==0) {
			alert("선택된 날짜가 없습니다. ");
			return false;
		}
		var dateHtml = "";
		$("input[name=selectedDate]:checked").each(function(){
			dateHtml += "<span id='"+cnt+"'>"+$(this).val() + "</span><br/>";
			cnt++;			
		});
		$("#ymds").html(dateHtml);
		$("#manyModal").modal();
	} 
	
	function batchRegistPerformSchedule(opt) {
		var performIdx = $("#performIdx").val();
		var startDate = new Date("${fn:substring(performVo.startDate, 0, 10)}");
		var endDate = new Date("${fn:substring(performVo.endDate, 0, 10)}");
		
		var time = $("#mtime").val();
		if(time =="") {
			alert("시간을 입력하세요");
			return false;
		}
		
		var seatNum = "";
		var sw = true;
		$("input[name=BseatNum]").each(function(index, item) {
			if($(item).val().trim()=="") {
				alert("모든 좌석 수를 입력하세요. (없으면 0 입력)");
				sw = false;
				return false;
			}
			seatNum += ","+$(item).val();
		});
		seatNum = seatNum.substring(1);
		if(!sw) return false;
		var failDate = "";
		for(var i=0; i<cnt; i++) {
			var date = $("#"+i).html();
			var newDate = new Date(date);
			if(newDate<startDate || newDate>endDate) {
				failDate += date + "/";
			} else {
				var schedule = date +" "+ time;
				var query = {
						performIdx : performIdx, 
						schedule : schedule,
						seatNum : seatNum
				}
				$.ajax({
					type : "post", 
					url : "${ctp}/admin/setPerform/updatePerformSchedule", 
					data : query, 
					success : function(data) {
						if(data=="fail") {
							alert("같은 일정 정보가 있습니다. 기존 일정 삭제 후 등록 가능합니다. ");
							return false;
						} else {
							if(opt==1) location.reload();
						}
					}
				});
			}
		}
		if(failDate != ""){
			alert("아래 일자는 공연 기간과 불일치하여 등록되지 않았습니다. \n"+failDate);
		}
		alert("등록 되었습니다.");
	}
	
	function batchDelete() {
		if($("input[name=selectedDate]:checked").length==0) {
			alert("선택된 날짜가 없습니다. ");
			return false;
		}
		
		var ans = confirm("선택한 날짜의 공연 일정을 모두 삭제하시겠습니까?");
		if(!ans) return false;
		var performIdx = $("#performIdx").val();
		$("input[name=selectedDate]:checked").each(function(){
			console.log($(this).val());
			$.ajax({
				type : "post", 
				url : "${ctp}/admin/setPerform/batchDeletePerformSchedule", 
				data : {performIdx : performIdx, date : $(this).val()}
			});  
		});
		alert("삭제했습니다. ");
		location.reload();
	}
</script>
</head>
<body style="margin-left: 20px;">
	<section>
		<div class="container-fluid p-4">
			<h3>&lt;공연일정 등록/수정&gt;</h3>
			<h5>공연 고유 번호 : ${performVo.idx} &nbsp;&nbsp;&nbsp;공연 제목 : ${performVo.title}</h5>
			<h5>공연 기간:  ${fn:substring(performVo.startDate, 0, 10)} ~ ${fn:substring(performVo.endDate, 0, 10)}</h5>
			<div id="calendar">
				<div class="row" style="align-items: flex-end;">
					<div class="col-6" style="margin:0px;font-size:1.2em;text-align:center;opacity: 0.5;color:#000;">
						<span class="badge badge-primary" onclick="location.href='${ctp}/${linkpath}?idx=${performVo.idx}&yy=${yy-1}&mm=${mm}'" title="이전년도">◁◁</span>
						<span class="badge badge-primary" onclick="location.href='${ctp}/${linkpath}?idx=${performVo.idx}&yy=${yy}&mm=${mm-1}'" title="이전월">◀</span>
						&nbsp; <span style="font-weight: 700;">${yy}년 ${mm+1}</span> &nbsp;
						<span class="badge badge-primary" onclick="location.href='${ctp}/${linkpath}?idx=${performVo.idx}&yy=${yy}&mm=${mm+1}'" title="다음월">▶</span>
						<span class="badge badge-primary" onclick="location.href='${ctp}/${linkpath}?idx=${performVo.idx}&yy=${yy+1}&mm=${mm}'" title="다음년도">▷▷</span>
						&nbsp;
						<span class="badge badge-primary" onclick="location.href='${ctp}/${linkpath}?idx=${performVo.idx}'" title="오늘날짜"><i class="fa fa-home"></i></span>
					</div>
					<div class="col-3" style="margin:0px;text-align:center">
						<span class="custom-control custom-checkbox">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</span>
					</div>
					<div class="col-3" style="margin:0px;text-align:center">
						<button class="btn btn-danger btn-sm mt-1" onclick="batchRegist()">일괄등록</button>				
						<button class="btn btn-danger btn-sm mt-1" onclick="batchDelete()">일괄삭제</button>				
					</div>
				</div>
				<br/>
				<div class="row">
				    <div class="col-sm-12" style="height:450px;">
						<table class="table table-bordered" style="height:100%">
							<tr style="text-align:center;font-size:1em;background-color:#eee;height:10%;">
								<th style="color:red;width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay1" value="1" />일
								</th>
								<th style="width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay2" value="2"/>월
								</th>
								<th style="width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay3" value="3"/>화
								</th>
								<th style="width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay4" value="4"/>수
								</th>
								<th style="width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay5" value="5"/>목
								</th>
								<th style="width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay6" value="6"/>금
								</th>
								<th style="color:blue;width:13%;vertical-align:middle;">
									<input type="checkbox" class="chkDay" id="chkDay7" value="7"/>토
								</th>
							</tr>
							<tr>
								<c:set var="cnt" value="1"/>
								<c:forEach var="preDay" begin="${preLastDay - (startWeek - 2) }" end="${preLastDay}">
									<td id="td${cnt}" style="color: #ddd;font-size:0.6em">
										<a href='${ctp}/${linkpath}?idx=${performVo.idx}&yy=${yy}&mm=${mm-1}'>${preMonth+1}-${preDay}</a>
									</td>
									<c:set var="cnt" value="${cnt=cnt+1}"/>
								</c:forEach>
					
								<c:forEach begin="1" end="${lastDay}" varStatus="st">
									<c:set var="todaySw" value="${yy == toYear && mm == toMonth && st.count == toDay ? 1 : 0}"/>	
									<td id="td${cnt}" ${todaySw == 1 ? 'class=today' : '' } style="font-size:0.9em;padding:8px;">	
										<c:set var="ymd" value="${yy}-${mm+1}-${st.count}"/>
										<a href="javascript:showModal('${ymd}')">
											${st.count} <input type="checkbox" value="${ymd}" name="selectedDate"/><br/>
											<c:forEach var="vo" items="${vos}">
												<c:if test="${fn:substring(vo.schedule,8,10) == st.count}">
													<c:if test="${yy < toYear || (yy == toYear && mm < toMonth) || (yy == toYear && mm == toMonth && fn:substring(vo.schedule,8,10) < toDay)}">
														<span class="badge badge-secondary" style="opacity:0.8;">${fn:substring(vo.schedule,11,16)}</span>
													</c:if>
													<c:if test="${yy > toYear || (yy == toYear && mm > toMonth) || (yy == toYear && mm == toMonth && fn:substring(vo.schedule,8,10) >= toDay)}">
														<span class="badge badge-danger" style="opacity:0.7;">${fn:substring(vo.schedule,11,16)}</span>
													</c:if>
												</c:if>
											</c:forEach>
										</a>
									</td>
									<c:if test="${cnt % 7 == 0}">		
								</tr><tr>
									</c:if>
									<c:set var="cnt" value="${cnt=cnt+1}"/>	
								</c:forEach>
					
								<c:forEach begin="${nextStartWeek}" end="7" varStatus="nextDay">
									<td id="td${cnt}" style="color: #ddd;font-size:0.6em">
										<a href='${ctp}/${linkpath}?idx=${performVo.idx}&yy=${yy}&mm=${mm+1}'>${nextMonth+1}-${nextDay.count}</a>
									</td>
									<c:set var="cnt" value="${cnt=cnt+1}"/>
								</c:forEach>
						    </tr>
					    </table>
					</div>
				</div>
			</div>
		</div>
	</section>
	<div class="modal fade" id="myModal">
		<div class="modal-dialog modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalTitle"></h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="modal-body" >
					<div id="scheduleInfo"></div>
					<div id="addScheduleForm">
						<form name="myform">
							<input type="hidden" id="performIdx" name="performIdx" value="${performVo.idx}" />
							<div class="input-group mb-3">
								<div class="input-group-prepend">
								    <div class="input-group-text">날짜</div>
								</div>
								<input type="date" value="2022-01-01" min="${fn:substring(performVo.startDate, 0, 10)}" readonly max="${fn:substring(performVo.endDate, 0, 10)}" class="form-control" name="date" id="date"/>
								<div class="input-group-prepend">
								    <div class="input-group-text">시간</div>
								</div>
								<input type="time" value="00:00" class="form-control" name="time" id="time"/>
							</div>
							<c:set var="seatArr" value="${fn:split(performVo.seat,',')}"/>
								<div class="input-group mb-3">
									<c:forEach var="seat" items="${seatArr}" varStatus="st">
										<div class="input-group-prepend">
									    	<div class="input-group-text">${seat}</div>
										</div>
										<input type="number" min="0" name="seatNum" class="form-control"/>
									</c:forEach>
								</div>
							<input type="button" class="btn btn-secondary" value="등록" onclick="registPerformSchedule(1)">
							<input type="button" class="btn btn-secondary" value="같은날 추가 등록" onclick="registPerformSchedule(2)">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="manyModal">
		<div class="modal-dialog modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">공연 일정 일괄 추가</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="modal-body" >
					<div id="addManyScheduleForm">
						<form name="manyform">
							<input type="hidden" id="performIdx" name="performIdx" value="${performVo.idx}" />
							<div class="input-group mb-3">
								<div class="input-group-prepend">
								    <div class="input-group-text">시간</div>
								</div>
								<input type="time" value="00:00" class="form-control" name="time" id="mtime"/>
							</div>
							<c:set var="seatArr" value="${fn:split(performVo.seat,',')}"/>
								<div class="input-group mb-3">
									<c:forEach var="seat" items="${seatArr}" varStatus="st">
										<div class="input-group-prepend">
									    	<div class="input-group-text">${seat}</div>
										</div>
										<input type="number" min="0" name="BseatNum" class="form-control"/>
									</c:forEach>
								</div>
							<input type="button" class="btn btn-secondary" value="등록" onclick="batchRegistPerformSchedule(1)">
							<input type="button" class="btn btn-secondary" value="같은날 추가 등록" onclick="batchRegistPerformSchedule(2)">
						    <div class="input-group-text mb-2">선택날짜</div>
							<div id="ymds"></div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>