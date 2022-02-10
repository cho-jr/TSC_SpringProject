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
<jsp:include page="/WEB-INF/views/include/addressAPI.jsp"/>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<script type="text/javascript">
	function registTheater(){
		var theater = myform.theater.value;
		var addrCode = myform.addrCode.value;
		var address1 = myform.address1.value;
		var address2 = myform.address2.value;
		var address3 = myform.address3.value;
		
		if(theater=="") {
			alert("극장명을 입력하세요");
			myform.theater.focus();
			return false;
		}
		if(addrCode==""||address1==""||address2=="") {
			alert("주소를 입력하세요");
			myform.theater.focus();
			return false;
		}
		if(theater.indexOf('/')!=-1){
			theater = theater.substring(0, theater.indexOf('/'));			
		}
		var query = {
				name : theater, 
				address1 : address1, 
				address2 : address2, 
				address3 : address3 
		}
		$.ajax({
			type:"post", 
			url : "${ctp}/admin/setTheater/newTheater", 
			data : query, 
			success : function(data) {
				if(data=="OK") {
					alert("극장을 등록했습니다. ");
					location.reload();
				} else {
					alert("이미 등록된 극장입니다. ");
				}
			}
		});
		

	}
</script>
</head>
<body style="margin-left: 20px;">
	<br/>
	<header><h2>관리자 메뉴</h2></header>
	<section>
		<div class="container" style="border: 1px solid #ccc; padding:40px; border-radius: 13px;box-shadow:0 0 10px #ccccea;">
			<h3>&lt;극장 등록&gt;</h3>
			<table>
				<tr>
					<td>
						<form name="myform">
							<input type="text" name="theater" id="theater" list="theaterList" placeholder="장소/극장명" class="form-control" required/>
							<!-- dataList 에서 선택 -->
							<datalist id="theaterList">
								<c:forEach var="vo" items="${vos}">
									<option value="${vo.name}/${vo.address1}"></option>
								</c:forEach>
							</datalist>
							<br/>
							<span class="text-muted">*신규 극장은 주소를 입력하세요.</span>
							<div class="form-group">
								<div class="input-group mb-1">
									<div class="input-group-prepend">
										<span class="input-group-text">주소</span>
									</div>
									<input type="text" name="addrCode" id="sample4_postcode" placeholder="우편번호" class="form-control" required > 
									<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-danger"><br>
								</div>
								<div class="input-group mt-3">
									<input type="text" name="address1" id="sample4_roadAddress" class="form-control" placeholder="도로명주소" required > 
									<span id="guide" style="color: #999; display: none"></span>
									<input type="text" name="address2" id="sample4_detailAddress" class="form-control" placeholder="상세주소" required > 
									<input type="text" name="address3" id="sample4_extraAddress" class="form-control" placeholder="참고항목" required >
								</div>
							</div>
							<button type="button" onclick="registTheater()" class="btn btn-secondary">등록하기</button>
						</form>
					</td>
				</tr>
			</table>
		</div>
	</section>
</body>
</html>