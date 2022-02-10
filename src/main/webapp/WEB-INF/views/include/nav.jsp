<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
.nav {
	display: flex;
	justify-content: space-between;
	position: sticky;
	width: 980px;
	margin: 0 auto;
	/* border-top: 1px solid #aaa;
	border-bottom: 1px solid #aaa; */
}
.nav .logo{
	vertical-align: center;
}
.nav .nav_totalSearch {
	display: block;
    position: absolute;
    right: 10px;
    top: -1px;
}
.nav ul:after {
	content: '';
    clear: both;
    display: block;
}
.nav ul, li{
	list-style: none;
	display: inline-flex;
}
.nav .nav_menu {
	display: inline-flex;
}
.nav .nav_menu > li {
	padding: 20px 0 0 0; 
}
.nav_menu > li{
    width: 120px;
}
.nav .totalSearch{
    right: 0;
    top: 7px;
    padding: 0 36px 15px 10px;
    align-items: center;

}
</style>
<script>
	function searchPerform(){
		var keyWord = $("#search").val(); 
		location.href="${ctp}/perform/performList?keyWord="+keyWord+"&condition=all";
	}
</script>
<div class="nav">
	<ul class="nav_menu">
		<li>
			<h5><a href="${ctp}/perform/performList">공연</a></h5>
		</li>
		<li>
			<h5><a href="${ctp}/ticketing/ticketing">예매</a></h5>
		</li>
		<li>
			<h5><a href="${ctp}/plaza/plaza">광장</a></h5>
		</li>
		<li>
			<h6><a href="${ctp}/support/notice/noticeList">공지사항</a></h6>
		</li>
	</ul>
	<div class="totalSearch input-group col-4">
		<input type="text" id="search" name="search" class="form-control" value="${keyWord}" placeholder="다양한 작품을 만나보세요!">
		<div class="input-group-append">
			<button type="button" class="btn btn-outline-danger" style="height:38px" onclick="searchPerform()">검색</button>
		</div>
	</div>
</div>