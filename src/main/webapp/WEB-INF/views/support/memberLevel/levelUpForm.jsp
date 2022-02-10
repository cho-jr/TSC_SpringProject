<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/include/addressAPI.jsp"/>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script>
	$(document).ready(function() {
		if(myform.nick.value=="") {
			alert("로그인이 필요한 서비스 입니다. ");
			location.href="${ctp}/member/login";
		}
	});

	function fCheck() {
		if(myform.nick.value=="") {
			alert("로그인이 필요한 서비스 입니다. ");
			return false;
		}
		if(myform.bName.value=="") {
			alert("사업자명을 입력하세요. ");
			myform.bName.focus();
			return false;
		}
		if(myform.bank.value=="은행선택") {
			alert("은행을 선택하세요. ");
			myform.bank.focus();
			return false;
		}
		if(myform.accountHolder.value=="") {
			alert("예금주를 입력하세요. ");
			myform.accountHolder.focus();
			return false;
		}
		if(myform.accountNum.value=="") {
			alert("계좌번호를 입력하세요. ");
			myform.accountNum.focus();
			return false;
		}
		var ans = confirm("기존 신청내용이 있는 경우 새로 신청한 내용으로 덮어쓰고, 기존 신청 내용은 지워집니다. 신청하시겠습니까? ");
		if(!ans) return false;
		myform.submit();
	}
</script>
</head>
<body>
	<header><jsp:include page="/WEB-INF/views/include/header.jsp"/></header>
	<nav><jsp:include page="/WEB-INF/views/include/nav.jsp"/></nav>
	<section>
		<div style="width:1000px;margin:0 auto;">
			<br/>
			<jsp:include page="/WEB-INF/views/support/include/supportHeader.jsp"/>
			<div class="row">
				<jsp:include page="/WEB-INF/views/support/include/supportSideBar.jsp"/>
				<div id="detail" class="col-9">
					<h4>관계자 신청/변경</h4>
					<div>
						관계자는 TSC 홈페이지를 통한 공연 등록 신청, 내 담당 작품 통계 조회 등의 기능을 사용할 수 있습니다.<br/>
						위 링크에서 주어진 양식을 작성 후 제출하시면 심사 후 관계자로 등급 변경됩니다.
					</div>
					<br/>
					<span style="float:right;margin-right: 20px;"><span class="text-danger">*</span> 항목은 필수입력 항목입니다</span>
					<form name="myform" method="post">
						<table class="table">
							<tr>
								<th style="width:150px;"><span class="text-danger">*</span> 사업자명</th>
								<td><input type="text" class="form-control" name="bName" value="${empty vo ? '' : vo.BName}"></td>
							</tr>
							<tr>
								<th>사업자등록번호</th>
								<td><input type="text" class="form-control" name="bNumber" value="${vo.BNumber}"></td>
							</tr>
							<tr>
								<th>사업장주소</th>
								<td>
									<div class="form-group">
										<div class="input-group mb-1">
											<input type="text" name="addrCode" value="${vo.addrCode}" id="sample4_postcode" placeholder="우편번호" class="form-control" required > 
											<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-danger"><br>
										</div>
										<div class="input-group">
											<input type="text" name="addr1" value="${vo.addr1}" id="sample4_roadAddress" class="form-control" placeholder="도로명주소" required > 
											<span id="guide" style="color: #999; display: none"></span> 
											<input type="text" name="addr2" value="${vo.addr2}" id="sample4_detailAddress" class="form-control" placeholder="상세주소" required > 
											<input type="text" name="addr3" value="${vo.addr3}" id="sample4_extraAddress" class="form-control" placeholder="참고항목" required >
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th>담당자 이름</th>
								<td><input type="text" class="form-control" value="${vo.MName}" name="mName" placeholder="로그인 계정과 일치해야 합니다. "></td>
							</tr>
							<tr>
								<th>소속부서/직책</th>
								<td><input type="text" class="form-control" name="department" value="${vo.department}"></td>
							</tr>
							<tr>
								<th><span class="text-danger">*</span> 정산계좌</th>
								<td class="pl-4">
									<div class="row">
										<select class="col-4 form-control" name="bank">
											<option>은행선택</option>
											<option <c:if test="${vo.bank=='국민'}">selected</c:if>>국민</option>
											<option <c:if test="${vo.bank=='농협'}">selected</c:if>>농협</option>
											<option <c:if test="${vo.bank=='하나'}">selected</c:if>>하나</option>
											<option <c:if test="${vo.bank=='새마을금고'}">selected</c:if>>새마을금고</option>
										</select>
										<input type="text" class="col-4 form-control mb-1" placeholder="예금주" value="${vo.accountHolder}" name="accountHolder">
									</div>
									<input type="text" class="row form-control" placeholder="계좌번호" value="${vo.accountNum}" name="accountNum">
								</td>
							</tr>
							<tr>
								<th>홈페이지</th>
								<td>
									<c:if test="${vo.homepage==''}">
										<input type="text" class="form-control" value="https://" name="homepage">
									</c:if>
									<c:if test="${vo.homepage!=''}">
										<input type="text" class="form-control" value="${vo.homepage}" name="homepage">
									</c:if>
								</td>
							</tr>
							<tr>
								<th>공연정보</th>
								<td><input type="text" class="form-control" name="etc" value="${vo.etc}"></td>
							</tr>
							<tr>
								<th></th>
								<td align="right">
									<input type="button" class="btn btn-danger" value="신청" onclick="fCheck()"/>
									<input type="hidden" name="nick" value="${sNick}">
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>