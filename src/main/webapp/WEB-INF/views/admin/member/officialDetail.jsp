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
<style type="text/css">
	th{background-color: #cccaca;}
</style>
<script type="text/javascript">
	
	function warn(){
		if(!confirm("경고가 누적되면 회원 활동에 제약이 있습니다. 선택한 회원을 경고하시겠습니까?")) return false;
		
		var query = {
				nick : '${vo.nick}'
		}
		$.ajax({
			type:"post", 
			url:"${ctp}/admin/member/addWarn", 
			data: query, 
		});
		alert("선택한 회원을 경고했습니다. ");
		location.href='${ctp}/admin/member/officialDetail?nick=${vo.nick}'
	}	
	
	function deleteRecord() {
		var ans = confirm("신청 내용이 회원에게 통보 없이 삭제됩니다. 신청 내역을 삭제하시겠습니까? ");
		if(!ans) return false;
		
		location.href='${ctp}/admin/member/officialDelete?nick=${vo.nick}'
	}
	
	function levelUp() {
		var ans = confirm("관계자 등급으로 변경하시겠습니까?");
		if(!ans) return false;
		
		location.href='${ctp}/admin/member/officialLevelUp?nick=${vo.nick}'
	}
	
	function memberInfo(){
		url="${ctp}/admin/member/memberDetail?nick=${vo.nick}";
		window.open(url, "memberInfoWin", "width=500px, height=500px, left=300px, top=100px");
	}
</script>
</head>
<body style="padding:20px;">
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5558;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div class="spinner-border" style="margin: auto;"></div>
		</div>
	</div> 
	<table class="table table-bordered">
		<tr>
			<th colspan="2" style="text-align: center;">신 청 정 보</th>
		</tr>
		<tr>
			<th>닉네임</th>
			<td>${vo.nick}&nbsp;<a href="javascript:memberInfo()" class="text-primary">(회원정보보기)</a></td>
		</tr>
		<tr>
			<th>사업자명</th>
			<td>${vo.BName}</td>
		</tr>
		<tr>
			<th>사업자번호</th>
			<td>${vo.BNumber}</td>
		</tr>
		<tr>
			<th>주소</th>
			<td>${vo.addrCode} ${vo.addr1} ${vo.addr2} ${vo.addr3}</td>
		</tr>
		<tr>
			<th>담당자이름</th>
			<td>${vo.MName}</td>
		</tr>
		<tr>
			<th>부서/직책</th>
			<td>${vo.department}</td>
		</tr>
		<tr>
			<th>정산계좌</th>
			<td>${vo.bank} (${vo.accountHolder}) ${vo.accountNum}</td>
		</tr>
		<tr>
			<th>홈페이지</th>
			<td>${vo.homepage}</td>
		</tr>
		<tr>
			<th>추가</th>
			<td>${vo.etc}</td>
		</tr>
		<tr>
			<th></th>
			<td>
				<button type="button" onclick="warn()" class="badge badge-secondary">경고하기</button>
				<button type="button" onclick="levelUp()" class="badge badge-danger">등업</button>
				<button type="button" onclick="deleteRecord()" class="badge badge-secondary">신청기록삭제</button>
			</td>
		</tr>
		<tr>
			<th></th>
			<td><button class="btn btn-danger btn-sm" onclick="window.close();" >닫기</button></td>
		</tr>
	</table>
</body>
</html>