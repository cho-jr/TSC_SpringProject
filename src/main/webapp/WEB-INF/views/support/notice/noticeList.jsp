<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:set var="linkpath" value="support/notice/noticeList"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>title</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp" %>
<link href="${ctp}/css/main.css" rel="stylesheet" type="text/css" />
<link rel="icon" href="${ctp}/resources/images/icons/titleIcon.ico">
<script type="text/javascript">
	$(function() {
		$(".detail").toggle(0);
		$("#orderBy").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy="+$(this).val()+"&pag=1&pageSize=${pagingVO.pageSize}";
			location.href = link;
		});
		$("#pageSize").on("change", function() {
			var link = "${ctp}/${linkpath}?orderBy=${orderBy}&pag=1&pageSize="+$(this).val();
			location.href = link;
		});
		$("#selectAll").on("change", function() {
			if($("#selectAll").is(":checked")) {
				$("input[name=selectedIdx]").prop("checked", true);
			} else {
				$("input[name=selectedIdx]").prop("checked", false);
			}
		});
		$("input[name=selectedIdx]").on("change", function() {
			if($("input[name=selectedIdx]:checked").length==$("input[name=selectedIdx]").length) {
				$("#selectAll").prop("checked", true);
			} else {
				$("#selectAll").prop("checked", false);
			}
		});
		
	});
	
	function search(){
		var link = "${ctp}/${linkpath}?keyWord="+$("#keyWord").val()
					+"&orderBy=${orderBy}&pag=1&pageSize=${pagingVO.pageSize}";
		location.href = link;
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
					<h3>공지사항</h3>
					<table class="table table-borderless m-0 p-0" id="tableHeader">
						<tr>
							<td style="width:12%; min-width: 140px;" >
							</td>
							<td style="width:10%">
								<select class="form-control" id="pageSize">
									<option value="2" <c:if test="${pagingVO.pageSize==2}">selected</c:if>>2건</option>
									<option value="5" <c:if test="${pagingVO.pageSize==5}">selected</c:if>>5건</option>
									<option value="10" <c:if test="${pagingVO.pageSize==10}">selected</c:if>>10건</option>
								</select>
							</td>
							<td style="width:33%">
								<div class="input-group mb-3">
								    <input type="text" class="form-control" id="keyWord" placeholder="제목, 내용 검색가능">
								    <div class="input-group-append">
								    	<button class="btn btn-danger" type="submit" onclick="search()">검색</button>
								    </div>
								</div>
							</td>
						</tr>
					</table>
					<table class="table table-hover">
						<tr class="table-danger">
							<th>번호</th>
							<th>제목</th>
							<th>날짜</th>
							<th>조회수</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td>${vo.idx}</td>
								<td>
									<c:if test="${vo.important>3}"><span class="badge badge-pill badge-danger">중요</span></c:if>
									<c:if test="${vo.important>=2}"><span style="color:#c00;"></c:if>
									<c:if test="${vo.important>=1}"><b></c:if>
									<a href="${ctp}/support/notice/noticeDetail?idx=${vo.idx}">${vo.title}</a>
									<c:if test="${vo.important>1}"></b></c:if>
									<c:if test="${vo.important>2}"></span></c:if>
								</td>
								<td>${fn:substring(vo.WDate, 0, 10)}</td>
								<td>${vo.views}</td>	
							</tr>
						</c:forEach>
					</table>
					<%@ include file="/WEB-INF/views/include/paging.jsp" %>
				</div>
			</div>
		</div>
	</section>
	<footer style="margin-top:30px;"><jsp:include page="/WEB-INF/views/include/footer.jsp"/></footer>
</body>
</html>