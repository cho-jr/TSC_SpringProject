<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판 수정</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
	function fCheck() {
		var title = myform.title.value;
		var content = CKEDITOR.instances.CKEDITOR.getData();
		if(title.trim()=="") {
			alert("제목을 입력하세요");
			myform.title.focus();
			return false;
		}
		if (CKEDITOR.instances.CKEDITOR.getData() == "") {
			alert("내용을 입력해 주세요.");
			myform.content.focus();
			return;
		}
		myform.title.value = title.trim();
		
		if(!confirm("등록하시겠습니까?")) return false;
		myform.oriContent.value = $("#oriContent").val();
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
			<%@ include file="/WEB-INF/views/include/main/carouselAdv.jsp" %>
			<br/><br/>
			
			<h3>자유게시판 - 글쓰기</h3>
			<form name="myform" method="post">
				<table class="table table-bordered">
					<tr>
						<th>제목</th>
						<td><input type="text" class="form-control" name="title" value="${vo.title}"/></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea class="form-control" name="content" id="CKEDITOR" rows="6">${vo.content}</textarea></td>
						<script>
						      	CKEDITOR.replace("content",{
						      		uploadUrl: "${ctp}/imageUpload",				
						      		filebrowserUploadUrl : "${ctp}/imageUpload",	
						      		height:260
						      	});
						</script>
					</tr>
					<tr>
						<th>등록</th>
						<td class="text-right">
							<input type="button" class="btn btn-outline-danger" onclick="location.href='${ctp}/plaza/freeBoardDetail?idx=${vo.idx}'" value="돌아가기"/>
							<input type="button" class="btn btn-danger" onclick="fCheck()" value="등록"/>
							<input type="hidden" name="idx" value="${vo.idx}">
							<input type="hidden" name="oriContent">
							<div style="display:none" id="oriContent">${vo.content}</div>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</section>
	<footer><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>