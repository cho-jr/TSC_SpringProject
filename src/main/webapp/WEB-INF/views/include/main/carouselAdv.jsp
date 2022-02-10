<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.carousel-inner .carousel-item {
	  transition: -webkit-transform 1s ease;
	  transition: transform 1s ease;
	  transition: transform 1s ease, -webkit-transform 1s ease;
	}
</style>
<script>
	$(document).ready(function() {
	  //jQuery.fn.carousel.Constructor.TRANSITION_DURATION = 1000  // 2 seconds
	  $('.carousel').carousel({ interval: 4000 });
	});
</script>
<div id="myCarousel" class="carousel slide" data-ride="carousel">
	<!-- Indicators -->
	<ul class="carousel-indicators">
		<c:forEach items="${BAVos}" var="vo" varStatus="st">
			<li data-target="#myCarousel" data-slide-to="${st.index}" class="${st.index==0? 'active' : '' }"></li>
		</c:forEach>
	</ul>
	
	<!-- The slideshow -->
	<div class="carousel-inner">
		<c:forEach items="${BAVos}" var="vo" varStatus="st">
		    <div class="carousel-item ${st.index==0?'active':''}">
				<img src="${ctp}/images/advertise/${vo.FSName}" width="100%"/>
		    </div>
		</c:forEach>
	</div>
	
	<a class="carousel-control-prev" href="#myCarousel" data-slide="prev">
		<span class="carousel-control-prev-icon"></span>
	</a>
	<a class="carousel-control-next" href="#myCarousel" data-slide="next">
		<span class="carousel-control-next-icon"></span>
	</a>
</div>