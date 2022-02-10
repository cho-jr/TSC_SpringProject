<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="member/mypage/myTickets/myTickets"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<style>
	#detail {font-size: 1.2em;}
</style>
<script type="text/javascript">
	// 예매 상세 정보 조회
	function newWin(idx) {
		var url = "${ctp}/member/mypage/myTickets/ticketInfo?idx="+idx;
		window.open(url, "nWin", "width=500px, height=700px");
	}
	
	// 예매 취소
	function cancleTicket(idx) {
		// idx = ticketingVo.idx
		var ans = confirm("같은 좌석으로 재예매 불가능할 수 있습니다. 정말 취소하시겠습니까?");
		if(!ans) return false;
		
		$.ajax({
			type: "post", 
			url: "${ctp}/member/mypage/myTickets/ticketCancle", 
			data : {idx:idx}, 
			success: function(data) {
				if(data=="fail") {
					alert("예매 취소 불가능합니다. ");
				} else {
					alert("예매 취소 처리 하였습니다. 결제 금액과 사용하셨던 포인트가 환불되었습니다. ");
					location.href = "${ctp}/${linkpath}?pag=${pagingVO.pag}&pageSize=${pagingVO.pageSize}";
				}
			}, 
			error : function() {
				alert("전송오류");
			}
		});
	}
	
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<h2>마이페이지</h2>
			<jsp:include page="/WEB-INF/views/include/mypageHeader.jsp"/>
			<div class="row" style="width:990px;margin:0;">
				<jsp:include page="/WEB-INF/views/include/mypageSideBar.jsp"/>
				<div id="detail" class="col-9">
					<h4>예매내역</h4><hr>
					<span style="color: #777;">예매번호를 클릭하면 예매 상세 내용을 확인할 수 있습니다.</span><br/>
					<span style="color: #777;">관람일 3일 전 후에는 예매 취소 불가능합니다. </span><br/>
					<span style="color: #777;">
						예매한 내역이 확인이 안되실 경우 
						<span style="color: #b55;font-weight: bold;">
							<a href="${ctp}/support/qna">1:1 문의</a>
						</span>
						를 이용해주세요.</span><br/><br/>
					<table class="table table-hover">
						<tr>
							<th>번호</th>
							<th>티켓명</th>
							<th style="min-width:100px;">발권처리</th>
							<th>예매취소</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
						<tr>
							<td><a href="javascript:newWin(${vo.idx})">${vo.idx}</a></td>
							<td>
								<a href="javascript:newWin(${vo.idx})">
									[${vo.performTitle}]${vo.performTheater}(${vo.performSchedule})<br/>
									--${vo.performSeat}/${vo.selectSeatNum}
								</a>
								<c:if test="${vo.print && !vo.cancle}">
									(<a href="${ctp}/perform/performInfo?idx=${vo.performIdx}#review" class="text-primary">리뷰쓰러가기</a>)
								</c:if>
							</td>
							<td>
								<c:if test="${!vo.print && !vo.cancle}">
									<button type="button" class="btn btn-outline-danger btn-sm" disabled onclick="printTicket(${vo.print}, ${vo.idx})">미발권</button>
								</c:if>
								<c:if test="${vo.print}">
									<button class="btn btn-danger btn-sm" disabled>발권 완료</button>
								</c:if>
								<c:if test="${!vo.print && vo.cancle}">
									<button class="btn btn-danger btn-sm" disabled>예매 취소</button>
								</c:if>
							</td>
							<td>
								<c:if test="${!vo.print && !vo.cancle}">
									<button type="button" class="btn btn-outline-danger btn-sm" onclick="cancleTicket(${vo.idx})">예매취소</button>
								</c:if>
							</td>
						</tr>
						</c:forEach>
					</table>
					<c:set var="linkpath" value="member/mypage/myTickets/myTickets"/>
					<%@ include file="/WEB-INF/views/include/paging.jsp" %>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>