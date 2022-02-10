<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	  <meta charset="UTF-8">
	  <title>message.jsp</title>
	  <jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
	  <link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
	  <script>
		    var msg = "${msg}";
		    var url = "${ctp}/${url}";
		    
		    alert(msg);
		    if(url != "") location.href = url;
	  </script>
</head>
<body>
</body>
</html>