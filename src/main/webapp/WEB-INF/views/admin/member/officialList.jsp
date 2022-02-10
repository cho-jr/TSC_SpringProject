<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="admin/member/officialList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script type="text/javascript">
	$(document).ready(function() {
		
	});
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}&date=${date}";
		location.href = link;
	}

	//상세보기
	function officialDetail(nick) {
		url = "${ctp}/admin/member/officialDetail?nick="+nick;
		window.open(url, "newWin", "width=500px, height=600px");
	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid p-3">
			<h3>&lt;관계자 목록&gt;</h3>
			<table style="width:100%">
				<tr>
					<td>
						
					</td>
					<td class="text-right">
						<div class="input-group mb-2">
						    <input type="text" class="form-control" id="keyWord" placeholder="검색">
						    <div class="input-group-append">
						    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
						    </div>
						</div>					
					</td>
				</tr>
			</table>
		    
		    <table class="table table-hover">
				<tr>
					<!-- <th>선택</th> -->
					<th>닉네임</th>
					<th>사업자명</th>
					<th>정산계좌</th>
					<th>사업자번호</th>
					<th>상세보기</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<%-- <td>
							<input type="checkbox" name="selectedIdx" id="${vo.nick}" value="${vo.nick}">
						</td> --%>
						<td>${vo.nick}</td>
						<td>${vo.BName}</td>
						<td>${vo.bank} ${vo.accountHolder} ${vo.accountNum}</td>
						<td>${vo.BNumber}</td>
						<td><button type="button" class="btn btn-sm btn-outline-danger hoverShow" onclick="officialDetail('${vo.nick}')">상세보기</button></td><!-- 새창 팝업 -->
					</tr>
				</c:forEach>
			</table>
			<c:set var="linkpath" value="admin/member/officialList"/>
			<%@ include file="/WEB-INF/views/include/paging.jsp" %>
		</div>
	</section>
</body>
</html>