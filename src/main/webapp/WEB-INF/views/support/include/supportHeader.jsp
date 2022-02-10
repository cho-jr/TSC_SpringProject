<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/include/addressAPI.jsp"/>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	#supportHeader{border:2px solid #fb4357aa;}
	#supportHeader tr td {height:120px;font-size:1em;}
	#supportHeader tr td i {font-size:2.3em;color:#777;margin-top:3px;}
</style>

<table class="table table-bordered" id="supportHeader">
	<tr class="text-center">
		<td style="width:20%;background-color:#fb4357;color:#fff;font-size:1.7em;font-weight:600;padding:0;">
			<div class="position-relative align-middle" style="width:100%;height:100%;padding:44px;margin:0;">
				<a href="${ctp}/support/home" class="stretched-link" >고객센터</a>
			</div>
		</td>
		<td class="align-middle position-relative" style="width:20%;padding:0;">
			<div class="text-center" style="width:100%;height:100%;padding:30px;margin:0;">
				<a href="${ctp}/support/memberLevel/info" class="stretched-link">
					<i class="fas fa-user-lock"></i><br/></br/>
					<span>패스워드 찾기</span><br/>
				</a>
			</div>
		</td>
		<td class="align-middle" style="width:20%;padding:0;">
			<div class="text-center position-relative" style="width:100%;height:100%;padding:30px;margin:0;">
				<a href="${ctp}/support/ticketCancleInfo" class="stretched-link">
					<i class="fas fa-sync-alt"></i><br/></br/>
					<span>예매취소/환불 문의</span><br/>
				</a>
			</div>
		</td>
		<td class="align-middle" style="width:20%;padding:0;">
			<div class="text-center position-relative" style="width:100%;height:100%;padding:30px;margin:0;">
				<a href="${ctp}/support/qna" class="stretched-link">
					<i class="far fa-comments"></i><br/></br/>
					<span>1:1문의</span><br/>
				</a>
			</div>
		</td>
		<td class="align-middle" style="width:20%;padding:0;">
			<div class="text-center position-relative" style="width:100%;height:100%;padding:30px;margin:0;">
				<a href="${ctp}/member/mypage/qna/qnaList" class="stretched-link">
					<i class="fas fa-clipboard-list"></i><br/></br/>
					<span>상담내역</span><br/>
				</a>
			</div>
		</td>
	</tr>
</table>