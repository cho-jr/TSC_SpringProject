<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<style type="text/css">
	th{background-color: #ccc;}
</style>
<script type="text/javascript">
	function fCheck() {
		var title = myform.title.value;
		if(title=="") {
			alert("제목을 입력하세요. ");
			return false;
		}
		myform.submit();
		
		opener.location.href="${ctp}/admin/support/FAQ/FAQList";
	}
</script>
</head>
<body>
	<section>
		<div style="width:100%;padding:0 20px;">
		<br/>
			<h3>FAQ 등록 폼</h3>
			<form method="post" name="myform" action="${ctp}/admin/support/FAQ/newFAQ">
				<table class="table">
					<tr>
						<th style="width:80px;">질문</th>
						<td><input type="text" name="question" class="form-control"/></td>
					</tr>
					<tr>
						<th>답변</th>
						<td>
							<textarea rows="6" name="answer" id="CKEDITOR" class="form-control" required></textarea>
						</td>
						<script>
					      	CKEDITOR.replace("answer",{
					      		uploadUrl: "${ctp}/imageUpload",				
					      		filebrowserUploadUrl : "${ctp}/imageUpload",	
					      		height:460
					      	});
					   	</script>
					</tr>
					<tr>
						<th>등록</th>
						<td class="text-right p-3"><input type="button" value="등록" onclick="fCheck()" class="btn btn-danger"/></td>
					</tr>
				</table>
			</form>
		</div>
	</section>
</body>
</html>