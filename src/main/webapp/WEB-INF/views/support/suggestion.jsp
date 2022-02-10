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
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script type="text/javascript">
	function fSubmit() {
		if(myform.agree.checked) {
			alert("건의사항이 접수되었습니다. 회원님의 애정과 관심에 보답하는 TSC가 되겠습니다. ");
			myform.submit();
		} else {
			alert("개인정보 수집 및 이용에 동의해주세요.");
			return false;
		}
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
					<h3>건의하기</h3>
					<div>
						희망 개선사항을 자유롭게 건의하세요. TSC는 회원님의 만족을 위해 노력합니다. <br/>
						건의사항을 모두 검토하지만 답변은 하지 않습니다. 답변이 필요한 문의사항은 1:1문의를 이용해주세요. 
						<br/><br/>
					</div>
					<form name="myform" method="post">
						<span style="float:right;margin-right: 20px;"><span class="text-danger">*</span> 항목은 필수입력 항목입니다</span>
						<table class="table">
							<tr>
								<td style="width:100px;"><span class="text-danger">*</span> 이메일</td>
								<td><input type="text" class="form-control" name="email" value="${email}" readonly></td>
							</tr>
							<tr>
								<td style="width:100px;"><span class="text-danger">*</span> 건의제목</td>
								<td><input type="text" class="form-control" name="title"></td>
							</tr>
							<tr>
								<td style="width:100px;"><span class="text-danger">*</span> 건의내용</td>
								<td>
									<textarea rows="3" class="form-control" name="content"></textarea>
								</td>
							</tr>
							<tr>
								<td colspan="2" style="padding:20px 40px;">
									<span style="color: #777;">
										수집하는 개인정보[(필수)이메일, 건의내용]는 건의 
										내용 처리 및 고객 불만의 해결을 위해 사용되며, 
										<b>관련 법령에 따라 3년간 보관 후 삭제됩니다. </b>
										건의 접수 및 처리를 위한 필요최소한의 개인정보이므로 동의를 해주셔야 
										서비스를 이용하실 수 있습니다.
									</span>
									<br/><br/>
									<div style="display: flex;">
										<input type="checkbox" id="agree" style="margin-top:3px;">&nbsp;<label for="agree"><b>위, 개인정보 수집 및 이용에 동의합니다. </b></label>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2" class="text-center">
									<button type="button" class="btn btn-danger" onclick="fSubmit()">&nbsp;&nbsp;&nbsp;확 인&nbsp;&nbsp;&nbsp;</button>
									<button type="button" class="btn btn-secondary" onclick="location.reload()">&nbsp;&nbsp;&nbsp;취 소&nbsp;&nbsp;&nbsp;</button>
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