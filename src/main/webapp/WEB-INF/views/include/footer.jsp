<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
.footer a {
	margin: 10px;
	color: inherit;
}
</style>
<c:if test="${not empty SAVo1}">
	<img class="footAdv" src="${ctp}/images/advertise/${SAVo1.FSName}" style="width:100%"/>
</c:if>
<div class="footer" style="background-color: #ddd; padding: 20px 40px;">
	<div style="width:980px; margin:0 auto;">
	<a>이용약관</a>
	<a>개인정보처리방침</a>
	<a href="${ctp}/support/home">고객센터</a>
	<a>의견수렴</a>
	<hr/>
	고객센터 1588-2188 (09:20 ~ 17:50 평일)<br/>
	Copyright &copy; The Scesent. All Rights reserved.<br/>
	</div>
</div>
<a href="#" class="stretched-link top bg-danger text-white pl-2 pr-2 pt-2" style=""><i class="fas fa-sort-up"></i></a>