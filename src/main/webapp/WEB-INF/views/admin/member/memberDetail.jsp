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
	function sendMailForm(email){
		myform.to.value = email;
		$("#myModal").modal();
	}
	
	function sendMail(){
		var title = myform.title.value;
		var content = myform.content.value;
		var to = myform.to.value;
		
		if(to==""){
			alert("받는 사람을 입력하세요. ");
			return false;
		}
		if(title==""){
			alert("제목을 입력하세요. ");
			return false;
		}
		if(content==""){
			alert("내용을 입력하세요. ");
			return false;
		}
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(500);      
		$('#lost_mask').fadeTo("slow");
		myform.submit();
	}
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
		location.href='${ctp}/admin/member/memberDetail?nick=${vo.nick}'
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
			<th colspan="2" style="text-align: center;">회 원 정 보</th>
		</tr>
		<tr>
			<th>이름</th>
			<td>${vo.name}</td>
		</tr>
		<tr>
			<th>닉네임</th>
			<td>${vo.nick}</td>
		</tr>
		<tr>
			<th>이메일</th>
			<td>${vo.email} <button class="btn btn-outline-danger btn-sm" onclick="sendMailForm('${vo.email}')">메일 쓰기</button></td>
		</tr>
		<tr>
			<th>연락처</th>
			<td>${vo.phone}</td>
		</tr>
		<tr>
			<th>주소</th>
			<td>${vo.addrCode} ${vo.addr1} ${vo.addr2} ${vo.addr3}</td>
		</tr>
		<tr>
			<th>회원등급</th>
			<td>
				<c:choose>
					<c:when test="${vo.level==-1}">탈퇴</c:when>
					<c:when test="${vo.level==0}">일반</c:when>
					<c:when test="${vo.level==1}">관계자</c:when>
					<c:when test="${vo.level==2}">관리자</c:when>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th>가입일</th>
			<td>${fn:substring(vo.joinDate, 0, 10)}</td>
		</tr>
		<tr>
			<th>마지막접속일</th>
			<td>${fn:substring(vo.lastDate, 0, 10)}</td>
		</tr>
		<tr>
			<th>포인트</th>
			<td>${vo.point}</td>
		</tr>
		<tr>
			<th>경고</th>
			<td>
				${vo.warn}&nbsp;&nbsp;&nbsp;
				<button type="button" onclick="warn()" class="badge badge-danger">경고하기</button>
			</td>
		</tr>
		
		<tr>
			<th></th>
			<td><button class="btn btn-danger btn-sm" onclick="window.close();" >닫기</button></td>
		</tr>
	</table>
	
	<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">메일 쓰기</h4>
					<button type="button" class="close" data-dismiss="modal">×</button>
				</div>
				<div class="modal-body text-right">
					<form name="myform" method="post" action="${ctp}/admin/member/sendMail">
						<input type="text" name="to" class="form-control mb-1" placeholder="받는 사람"/>
						<input type="text" name="title" class="form-control mb-1" placeholder="제목"/>
						<textarea rows="5" name="content" class="form-control" placeholder="내용을 입력하세요. "></textarea>
						<button class="btn btn-danger btn-sm" type="button" onclick="sendMail()">전 송</button>
						<input type="hidden" name="nick" value="${vo.nick}"/>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>