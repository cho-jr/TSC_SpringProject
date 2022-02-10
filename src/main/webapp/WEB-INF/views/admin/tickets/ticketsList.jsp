<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/tickets/ticketsList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style type="text/css">
	#tableHeader td{padding-bottom: 0;}
</style>
<script>
	$(document).ready(function(){
		$("#tableHeader td").addClass("align-bottom");
		$('#lost_mask').css({'width':'0','height':'0'});
		$("#pageSize").on("change", function() {
			location.href = "${ctp}/${linkpath}?keyWord=${keyWord}&orderBy=${orderBy}&pag=1&date=${date}&pageSize="+$("#pageSize").val();
		});
		$("#orderBy").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy="+$(this).val()+"&pag=1&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}&date=${date}";
			location.href = link;
		});
		$("#selectAll").on("change", function() {
			if($("#selectAll").is(":checked")) {
				$("input[name=selectedIdx]").prop("checked", true);
			} else {
				$("input[name=selectedIdx]").prop("checked", false);
			}
		});
		$("input[name=selectedIdx]").on("change", function() {
			if($("input[name=selectedIdx]:checked").length==$("input[name=selectedIdx]").length) {
				$("#selectAll").prop("checked", true);
			} else {
				$("#selectAll").prop("checked", false);
			}
		});
	});
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}&date=${date}";
		location.href = link;
	}
	
	var printFalse = "";
	function printTicket(isPrinted, idx, isCancled) {
		if(isPrinted=="true") {
			alert(idx+"번 티켓은 이미 발권되었습니다. 중복 발권 불가한 상품입니다. ");
			return false;
		}
		if(isCancled) {
			alert(idx+"번 티켓은 취소되었습니다. ");
			return false;
		}
		var ans = confirm(idx+"번 티켓을 발권처리 하시겠습니까?");
		if(!ans) return false;
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		$.ajax({
			type: "post", 
			url: "${ctp}/admin/tickets/printTicket", 
			data: {idx:idx}, 
			success:function() {
				setTimeout(function(){
					alert("발권 처리 했습니다. ");
				}, 1000);
					location.href="${ctp}/${linkpath}?pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}&orderBy=${orderBy}&date=${date}";
			}
		});
	}
	
	// 선택 티켓 발권--> 체크한 여러장 동시 발권 처리
	function printAllTicket() {
		// 체크된 티켓 번호 리스트에 저장
		var tickets = [];
		var printed = [];
		var cancled = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			printed.push($(this).val().substring(0, $(this).val().indexOf('/')));
			tickets.push( $(this).val().substring( $(this).val().indexOf('/')+1, $(this).val().lastIndexOf('/') ));
			cancled.push($(this).val().substring($(this).val().lastIndexOf('/')+1));
		});
		if(tickets.length==0) {
			alert("발권할 티켓을 선택해주세요. ");
			return false;
		}
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		setTimeout(function(){
			for(let i=0; i<tickets.length; i++) {
				if(tickets[i]!=""){
					if(printed[i]=="true" || cancled[i]=="true") {
						printFalse += tickets[i] + "번, ";
					} else {
						$.ajax({
							type: "post", 
							url: "${ctp}/admin/tickets/printTicket", 
							data: {idx:tickets[i]}
						});
					}
				}
			}
			if(printFalse!=""){
				printFalse = printFalse.substring(0, printFalse.length-2) + " 티켓은 이미 발권되었거나 취소되었습니다. 발권 완료되었습니다.  ";
				alert(printFalse);
			} else {
				alert("발권처리 했습니다. ");
			}
			location.href="${ctp}/${linkpath}?pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}&orderBy=${orderBy}&date=${date}";
		}, 1000);
	}
	
	function cancleTicket(idx) {
		var ans = confirm("결제금액과 포인트가 환불됩니다. 정말 취소하시겠습니까?");
		if(!ans) return false;
		
		$.ajax({
			type: "post", 
			url: "${ctp}/admin/tickets/ticketCancle", 
			data : {idx:idx}, 
			success: function(data) {
				if(data=="fail") {
					alert("예매 취소 불가능합니다. ");
				} else {
					alert("예매 취소 처리 하였습니다. ");
					location.href = "${ctp}/${linkpath}?pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}&date=${date}";
				}
			}, 
			error : function() {
				alert("전송오류");
			}
		});
	}
	function cancleAllTicket() {
		var tickets = [];
		var printed = [];
		var cancled = [];
		$('input:checkbox[type=checkbox]:checked').each(function () {
			printed.push($(this).val().substring(0, $(this).val().indexOf('/')));
			tickets.push( $(this).val().substring( $(this).val().indexOf('/')+1, $(this).val().lastIndexOf('/') ));
			cancled.push($(this).val().substring($(this).val().lastIndexOf('/')+1));
		});
		if(tickets.length==0) {
			alert("취소할 티켓을 선택해주세요. ");
			return false;
		}
		var cancleFalse = "";
		for(let i=0; i<tickets.length; i++) {
			if(cancled[i]=="true") {
				cancleFalse += tickets[i] + "번, ";
			} else {
				$.ajax({
					type: "post", 
					url: "${ctp}/admin/tickets/ticketCancle", 
					data : {idx:tickets[i]}, 
					error : function() {
						alert("전송오류");
					}
				});
			}
		}
		if(cancleFalse!=""){
			cancleFalse = cancleFalse.substring(0, cancleFalse.length-2) + " 티켓은 이미 취소되었습니다. 취소 완료되었습니다.  ";
			alert(cancleFalse);
		} 
		location.href="${ctp}/${linkpath}?pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}&orderBy=${orderBy}&date=${date}";
	}
	
	function searchDate(){
		var date = document.getElementById("searchdate").value;
		location.href="${ctp}/${linkpath}?pag=1&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}&orderBy=${orderBy}&date="+date;
	}
	function alldate() {
		location.href="${ctp}/${linkpath}?pag=1&pageSize=${pagingVO.pageSize}&keyWord=${keyWord}&orderBy=${orderBy}";
	}
</script>
</head>
<body style="margin-left: 20px;">
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5558;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div style="margin:auto;font-size: 2em;">티켓 출력중, 삐빅삐빅..</div>
		</div>
	</div> 
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid p-3">
			<h3>&lt;예매 내역&gt;</h3>
			<input type="date" name="searchdate" id="searchdate" value="${date}"><input type="button" value="날짜검색" onclick="searchDate()"/>
			<input type="button" onclick="alldate()" value="전체날짜"/>
			<table class="table table-borderless m-0 p-0" id="tableHeader">
				<tr>
					<td style="width:12%; min-width: 140px;">
						<div class="custom-control custom-checkbox mb-2">
						    <input type="checkbox" id="selectAll">
						    <label class="custom-cntrol-label" for="selectAll"><b>전체선택</b></label>
						</div>
					</td>
					<td>
						<button type="button" class="btn btn-outline-secondary btn-sm mb-2" onclick="printAllTicket()">선택티켓발권</button>
						<button type="button" class="btn btn-outline-secondary btn-sm mb-2" onclick="cancleAllTicket()" >선택티켓취소/환불</button></td>
					<td>
						<select id="pageSize" class="form-control mb-2">
							<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5건씩 보기</option>
							<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10건씩 보기</option>
							<option value="20" <c:if test="${pagingVO.pageSize==20}">selected</c:if>>20건씩 보기</option>
						</select>
					</td>
					<td style="width:20%">
						<select class="form-control mb-2" id="orderBy">
							<option value="idx" <c:if test="${orderBy=='idx'}">selected</c:if>>결제일순</option>
							<option value="schedule" <c:if test="${orderBy=='schedule'}">selected</c:if>>공연일순</option>
							<option value="title" <c:if test="${orderBy=='title'}">selected</c:if>>공연제목</option>
							<option value="theater" <c:if test="${orderBy=='theater'}">selected</c:if>>극장</option>
							<option value="nick" <c:if test="${orderBy=='nick'}">selected</c:if>>회원별</option>
							<option value="performIdx" <c:if test="${orderBy=='performIdx'}">selected</c:if>>작품별</option>
							<option value="payBy" <c:if test="${orderBy=='payBy'}">selected</c:if>>결제수단</option>
						</select>
					</td>
					<td style="width:33%">
						<div class="input-group mb-2">
						    <input type="text" class="form-control" id="keyWord" placeholder="제목, 극장, 회원 검색가능">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
			<table class="table table-hover">
				<tr>
					<th>선택</th>
					<th>번호</th>
					<th>구매 회원</th>
					<th>제목</th>
					<th>극장</th>
					<th>날짜</th>
					<th>구매 좌석</th>
					<th>티켓금액</th>
					<th>사용포인트</th>
					<th>결제금액</th>
					<th>결제수단</th>
					<th>결제일</th>
					<th>발권처리</th>
					<th>예매취소</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
				<tr>
					<td><input type="checkbox" name="selectedIdx" value="${vo.print}/${vo.idx}/${vo.cancle}"></td>
					<td>${vo.idx}</td>
					<td><c:if test="${empty vo.memberNick}"><span style="color:#777">(Unknown)</span></c:if>${vo.memberNick}</td>
					<td>${vo.performTitle}</td>
					<td>${vo.performTheater}</td>
					<td>${vo.performSchedule}</td>
					<td>${vo.performSeat}, ${vo.selectSeatNum}</td>
					<td><fmt:formatNumber value="${vo.price}"/></td>
					<td><fmt:formatNumber value="${vo.usePoint}"/></td>
					<td><fmt:formatNumber value="${vo.finalPrice}"/></td>
					<td>${vo.payBy}</td>
					<td>${vo.payDate}</td>
					<td>
						<c:if test="${!vo.print}">
							<button type="button" class="btn btn-outline-secondary btn-sm" onclick="printTicket(${vo.print}, ${vo.idx}, ${vo.cancle})">발권</button>
						</c:if>
						<c:if test="${vo.print}">
							<button class="btn btn-secondary btn-sm" disabled>발권 완료</button>
						</c:if>
					</td>
					<td>
						<c:if test="${vo.cancle}">
							취소됨
						</c:if>
						<c:if test="${!vo.cancle && !vo.print}">
							<button type="button" class="btn btn-outline-secondary btn-sm" onclick="cancleTicket(${vo.idx})">취소</button>
						</c:if>
						<c:if test="${!vo.cancle && vo.print}">
							<button type="button" class="btn btn-outline-secondary btn-sm hoverShow" onclick="cancleTicket(${vo.idx})">취소</button>
						</c:if>
					</td>
				</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/tickets/ticketsList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>