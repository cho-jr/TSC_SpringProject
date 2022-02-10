<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<style>
	#noticeContainer {width:1000px;margin:0 auto;}
	/*#noticeContainer:hover {box-shadow: 0 0 5px #bbb;}*/
	.cont {border:1px solid #ccc;border-radius: 13px; height: 300px;}
	.cont:hover {box-shadow: 0 0 5px #edd;}
	th{font-size: 1.2em}
	#noticelink:hover{text-decoration: underline;}
</style>
<section>
	<div id="noticeContainer" class="row">
		<div class="col-7 cont cont1 p-4">
			<table class="table table-borderless">
				<tr>
					<th>공지사항</th>
					<td class="align-middle"><a id="noticelink" href="${ctp}/support/notice/noticeDetail?idx=${vo.idx}">${vo.title}</a></td>
					<td><a class="btn btn-light btn-sm" href="${ctp}/support/notice/noticeList">더보기</a></td>
				</tr>
				<tr><td></td><td></td><td></td></tr>
				<tr>
					<th>고객센터</th>
					<th>1577-1234</th>
					<td></td>
				</tr>
				<tr><td></td><td>고객센터 운영시간 (평일 09:20~17:50+@)</td><td></td></tr>				
				<tr><td></td><td>업무시간 외 자동응답 안내 가능합니다.</td><td></td></tr>				
				<tr><td></td><td></td><td></td></tr>				
			</table>
		</div>
		
		<div class="col-4 cont cont2 ml-4 p-4">
			<table class="table table-borderless">
				<tr><td><a href="${ctp}/support/FAQ/FAQList" class="btn btn-light form-control" style="font-size: 1.2em;"><b>FAQ</b></a></td></tr>
				<tr><td><a href="${ctp}/support/qna" class="btn btn-light form-control" style="font-size: 1.2em;"><b>1:1문의</b></a></td></tr>
				<tr><td><a href="${ctp}/support/home" class="btn btn-light form-control" style="font-size: 1.2em;"><b>고객센터</b></a></td></tr>
				<tr><td><a href="${ctp}/support/ticketCancleInfo" class="btn btn-light form-control" style="font-size: 1.2em;"><b>예매취소/환불문의</b></a></td></tr>
			</table>
		</div>
	</div>
</section>
