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
<style type="text/css">
	.star-rating {
	  display:flex;
	  flex-direction: row-reverse;
	  font-size:1.5em;
	  justify-content:space-around;
	  padding:0 0.2em;
	  text-align:center;
	  width:5em;
	}
	
	.star-rating input { display:none;}
	
	.star-rating label {color:#ccc;cursor:pointer;}
	
	.star-rating :checked ~ label {color:#f90;}
	
	.star-rating label:hover,
	.star-rating label:hover ~ label {color:#fc0;}
	.ustar-rating {
	  display:flex;
	  flex-direction: row-reverse;
	  font-size:1.5em;
	  justify-content:space-around;
	  padding: 0em 0.2em;
	  text-align:center;
	  width:5em;
	}
</style>
<script type="text/javascript">
	$(function() {
		$(document).on("click", "input[name=rating]", function() {
			myform.star.value = $(this).val();
		});
	})
	function fCheck(){
		var idx = myform.idx.value;
		var star = myform.star.value;
		var reviewContent = myform.reviewContent.value;
		if(star=="") {
			alert("별점을 입력해주세요.");
			return false;
		}
		if(reviewContent=="") {
			alert("리뷰 내용을 입력해주세요.");
			return false;
		}
		
		var query = {
				idx : idx, 
				star : star, 
				reviewContent : reviewContent
		}
		
		$.ajax({
			type: "post", 
			url : "${ctp}/member/mypage/myReview/updateReview", 
			data : query, 
			success: function() {
				alert("리뷰를 수정했습니다. ");
				opener.location.reload();
				window.close();
			}
		});
		
		
	}
</script>
</head>
<body>
	<section>
		<div style="width:500px;margin:0 auto;">
			<br/><br/>
			<form name="myform" action="${ctp}/" method="post" style="border:1px solid gray;padding:20px;margin:10px 0 30px 0;border-radius: 13px;">
				<h3>리뷰 수정</h3>
				<hr/>
				<div class="star-rating">
					<input type="radio" id="5-stars" name="rating" value="5" />
					<label for="5-stars" class="star">&#9733;</label>
					<input type="radio" id="4-stars" name="rating" value="4" />
					<label for="4-stars" class="star">&#9733;</label>
					<input type="radio" id="3-stars" name="rating" value="3" />
					<label for="3-stars" class="star">&#9733;</label>
					<input type="radio" id="2-stars" name="rating" value="2" />
					<label for="2-stars" class="star">&#9733;</label>
					<input type="radio" id="1-star" name="rating" value="1" />
					<label for="1-star" class="star">&#9733;</label>
				</div>
				<textarea rows="3" class="form-control" name="reviewContent">${vo.reviewContent}</textarea>
				<div class="text-right">
					<button type="button" class="btn btn-danger btn-sm m-2" onclick="fCheck()">등록</button>
				</div>
				<input type="hidden" name="idx" value="${vo.idx}"/>
				<input type="hidden" name="star">
			</form>
		</div>
	</section>
</body>
</html>