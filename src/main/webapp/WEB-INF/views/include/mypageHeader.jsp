<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/include/addressAPI.jsp"/>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	#mypageHeader{border:2px solid #fb4357aa;}
	#mypageHeader tr td {height:120px;font-size:1em;}
	#mypageHeader tr td i {font-size:2.3em;color:#777;margin-top:3px;}	
	
	/* 애니메이션~~ */
	.square, .circle, .triangle, .close, .star, .message {
	  position:absolute;
	  display : none;
	  z-index: 100;
	}
	
	.circle {border-radius:50%;}
	
	.square-1 {
	  width:30px;
	  height:30px;
	  top:0px;
	  left:20px;
	  border:5px solid #FFBB00;
	  /* 추가된 부분 */
	  animation: square-1 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	.square-2 {
	  width:50px;
	  height:50px;
	  top:0px;
	  left:20px;
	  border:5px solid #FFBB00;
	  /* 추가된 부분 */
	  animation:square-2 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	.circle-1 {
	  width:40px;
	  height:40px;
	  top:5px;
	  left:15px;
	  background:#5853EB;
	  /* 추가된 부분 */
	  animation:circle-1 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	.triangle-1 {
	  width:40px;
	  height:40px;
	  top:0px;
	  left:25px;
	  background:#FF2424;
	  clip-path: polygon(50% 0%, 0 100%, 100% 100%);
	  /* 추가된 부분 */
	  animation:triangle-1 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	.close-1 {
	  width:35px;
	  height:35px;
	  top:0px;
	  left:20px;
	  background:#41AF39;
	  clip-path: polygon(20% 0%, 0% 20%, 30% 50%, 0% 80%, 20% 100%, 50% 70%, 80% 100%, 100% 80%, 70% 50%, 100% 20%, 80% 0%, 50% 30%);
	  /* 추가된 부분 */
	  animation:close-1 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	.star-1 {
	  width:25px;
	  height:25px;
	  top:10px;
	  left:25px;
	  background:#FF5E00;
	  clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
	  /* 추가된 부분 */
	  animation:star-1 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	.message-1 {
	  width:35px;
	  height:35px;
	  top:10px;
	  left:20px;
	  background:#990085;
	  clip-path: polygon(0% 0%, 100% 0%, 100% 75%, 75% 75%, 75% 100%, 50% 75%, 0% 75%);
	  /* 추가된 부분 */
	  animation:message-1 2s infinite cubic-bezier(0.415, 0.547, 0, 0.809);
	}
	
	@keyframes clip-top {
	  0% {transform:translateY(0px)}
	  50% {transform:translateY(-150px)}
	  100% {transform:translateY(0px)}
	}
	
	@keyframes clip-left {
	  0% {transform:translateX(0px)}
	  50% {transform:translateX(-150px)}
	  100% {transform:translateX(0px)}
	}
	
	@keyframes clip-right {
	  0% {transform:translateX(0px)}
	  50% {transform:translateX(150px)}
	  100% {transform:translateX(0px)}
	}
	
	@keyframes clip-bottom {
	  0% {transform:translateY(0px)}
	  50% {transform:translateY(150px)}
	  100% {transform:translateY(0px)}
	}
	
	/* 추가된 부분 */
	@keyframes square-1 {
	  0% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	  50% {transform:translateX(-50px) translateY(50px) scale(1) rotateZ(90deg)}
	  100% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	}
	
	/* 추가된 부분 */
	@keyframes square-2 {
	  0% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	  50% {transform:translateX(-80px) translateY(-60px) scale(1) rotateZ(135deg)}
	  100% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	}
	
	/* 추가된 부분 */
	@keyframes circle-1 {
	  0% {transform:translateX(0) translateY(0) scale(0)}
	  50% {transform:translateX(70px) translateY(-80px) scale(1)}
	  100% {transform:translateX(0) translateY(0) scale(0)}
	}
	
	/* 추가된 부분 */
	@keyframes triangle-1 {
	  0% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	  50% {transform:translateX(-100px) translateY(140px) scale(1) rotateZ(-90deg)}
	  100% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	}
	
	/* 추가된 부분 */
	@keyframes close-1 {
	  0% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	  50% {transform:translateX(100px) translateY(140px) scale(1) rotateZ(-270deg)}
	  100% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	}
	
	/* 추가된 부분 */
	@keyframes star-1 {
	  0% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	  50% {transform:translateX(60px) translateY(70px) scale(1) rotateZ(155deg)}
	  100% {transform:translateX(0) translateY(0) scale(0) rotateZ(0)}
	}
	
	/* 추가된 부분 */
	@keyframes message-1 {
	  0% {transform:translateX(0) scale(0) rotateZ(0)}
	  50% {transform:translateX(70px) scale(1) rotateZ(-360deg)}
	  100% {transform:translateX(0) scale(0) rotateZ(0)}
	}
	
	#point:hover {cursor:pointer;}
</style>
<script>
	function pointEffect() {
		$(".square, .circle, .triangle, .close, .star, .message").css("display", "block");
		setTimeout(function() {
			$(".square, .circle, .triangle, .close, .star, .message").css("display", "none");
		}, 2000);
	}
</script>
<table class="table table-bordered" id="mypageHeader">
	<tr>
		<td class="text-center align-middle" style="width:20%;background-color:#fb4357;color:#fff;font-size:1.4em;font-weight:600;">${memberVo.nick}님</td>
		<td class="align-middle" style="width:20%">
			<div class="row" onclick="pointEffect()" id="point">
				<div class="col-3">
					<i class="fab fa-product-hunt"></i><br/> 
				</div>
				<div class="col-9">
					<span>포인트</span><br/>
					<span class="emphasis">${memberVo.point}</span>point
					<div class="square square-1"></div>
					<div class="square square-2"></div>
					<div class="circle circle-1"></div>
					<div class="triangle triangle-1"></div>
					<div class="close close-1"></div>
					<div class="star star-1"></div>
					<div class="message message-1"></div>
				</div>
			</div>
		</td>
		<td class="align-middle" style="width:20%">
			<div class="row">
				<div class="col-3">
					<i class="fas fa-shopping-basket"></i><br/>
				</div>
				<div class="col-9">
					<a href="${ctp}/member/mypage/myTickets/myTickets">
					<span>예매내역</span><br/>
					<span class="emphasis"> ${ticketNum}</span>건
					</a>
				</div>
			</div>
		</td>
		<td class="align-middle" style="width:20%">
			<div class="row">
				<div class="col-3">
					<i class="far fa-comment-dots"></i><br/>
				</div>
				<div class="col-9">
					<a href="${ctp}/member/mypage/qna/qnaList">
						<span>1:1문의</span><br/>
						<span class="emphasis">바로가기</span>
					</a>
				</div>
			</div>
		</td>
		<td class="align-middle" style="width:20%">
			<div class="row">
				<div class="col-3">
					<i class="far fa-edit"></i><br/>
				</div>
				<div class="col-9">
					<span>회원정보</span><br/>
					<span class="emphasis"><a href="${ctp}/member/mypage">수정▶</a></span>
				</div>
			</div>
			
		</td>
	</tr>
</table>