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
<style>
	#notice td:last-child {text-align: right;}
	#notice td:first-child, #faq td:first-child {font-weight: 500;font-size: 1.2em;}
	#notice td:first-child:hover, #faq td:first-child:hover {text-decoration: underline;}
	.plus{float:right;font-size: 0.6em;padding:5px;border-radius:8px;}
	.plus:hover {
		padding:5px;
		border-radius:8px;
		box-shadow: 0px 0px 3px #fb435766;
	}
	#redBox{
	 width:100%;height:130px;
/* 	 background: linear-gradient( to right top, #ff5343aa , #ff4343 50%, #ff4543aa ); */
	 /* background: linear-gradient( to right top, #eb5343, #eb4343aa , #eb4343); */
	 /* background-image: linear-gradient(61deg, #073f60, #744554, #ba4247, #ff2d38) */
	 /* background-image: linear-gradient(25deg, #2c3033, #663834, #9e3a34, #d73333) */
		/* background-image: linear-gradient(25deg, #fa0d00, #ea8354, #c2c49e, #40ffed); */
		background-image: linear-gradient(61deg, #bf1521, #b65c65, #9789ad, #00b3fb);
	 /* background-image: linear-gradient(25deg, #002290, #80216d, #bd2549, #f32c1a) */
	 
	}
</style>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<jsp:include page="/WEB-INF/views/support/include/supportHeader.jsp"/>
			<div class="row" style="width:990px;margin:0;">
				<jsp:include page="/WEB-INF/views/support/include/supportSideBar.jsp"/>
				<div id="detail" class="col-9 p-0">
					<div id="redBox" class="align-middle p-4">
						<div class="row" style="width:60%;margin:0 auto;color:#eee;font-size: 1.3em;">
							<div class="col-3">
								<i class="fas fa-search" style="font-size: 5em;color:#eee;"></i>						
							</div>
							<div class="col-9">
								자주찾는 질문 빠른검색<br/><br/>
								<form method="get" action="${ctp}/support/FAQ/FAQList">
									<div class="input-group mb-3">
									    <input type="search" class="form-control" placeholder="Search" name="keyWord">
									    <div class="input-group-append">
									   		<button class="btn btn-outline-danger bg-light" type="submit">검색</button>
									    </div>
									</div>
								</form>
							</div>
						</div>
					</div>
					<div><br/><br/><br/><h1 style="text-align: center;text-decoration: underline;">무엇을 도와드릴까요?</h1><br/><br/><div>
					<div class="row">
						<div class="col-6">
							<br/><br/>
							<div style="font-size: 1.6em; margin-bottom: 10px;">
								<b>자주찾는 질문</b>
								<span class="plus"><a href="${ctp}/support/FAQ/FAQList">더보기</a></span>
							</div>
							<table class="table-borderless" style="width:100%;" id="faq">
								<c:forEach var="vo" items="${FAQVos}">
									<tr>
										<td class="pb-2">
											<a href="${ctp}/support/FAQ/FAQDetail?idx=${vo.idx}">
												${fn:substring(vo.question, 0, 20)}
												<c:if test="${fn:length(vo.question)>20}">...</c:if>
											</a>
										</td>
									</tr>
								</c:forEach>
							</table>
						</div>
						<div class="col-6">
							<br/><br/>
							<div style="font-size: 1.6em; margin-bottom: 10px;">
								<b>공지사항</b>
								<span class="plus"><a href="${ctp}/support/notice/noticeList">더보기</a></span>
							</div>
							<table class="table-borderless" style="width:100%;" id="notice">
								<c:forEach var="vo" items="${noticeVos}">
									<tr>
										<td class="pb-2">
											<a href="${ctp}/support/notice/noticeDetail?idx=${vo.idx}">
												${fn:substring(vo.title, 0, 20)}
												<c:if test="${fn:length(vo.title)>20}">...</c:if>
											</a>
										</td>
										<td class="pb-2" style="min-width: 100px;">${fn:substring(vo.WDate, 0, 10)}</td>
									</tr>
								</c:forEach>
							</table>
						</div>
					</div>
					<br/><br/>
					<div class="row">
						<div class="col-6" style="height:200px;background-color:#eee;text-align:center;padding:30px;">
							<a href="${ctp}/support/qna" class="stretched-link"></a>
							<i class="far fa-question-circle m-2" style="font-size: 5em;color:#999;"></i>
							<h4>1:1 문의하기</h4>
							24시간 365일 언제든 문의해주세요. 
						</div>
						<div class="col-6" style="height:200px;background-color:#eee;border-left:1px solid #bbb;text-align: center;padding:30px;">
							<a href="${ctp}/member/mypage/qna/qnaList" class="stretched-link"></a>
							<i class="fas fa-clipboard-list m-2" style="font-size: 5em;color:#999;"></i><br/>
							<h4>상담내역</h4>
							문의하신 내역을 확인하실 수 있습니다. 
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>