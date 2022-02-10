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
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<style type="text/css">
	#inputTable tr th {width:10%;}
</style>
<script type="text/javascript">
	var cntP=1;
	var cntS=0;
	var checkedManager = false;	
	// 가격 옵션 추가
	function addPriceForm() {
		cntP++;
		var addPriceForm = '<div class="input-group mb-3" id="priceForm'+cntP+'">'+
		    				'<input type="text" name="seat" id="seat'+cntP+'" class="form-control" placeholder="좌석명/등급">'+
		    				'<input type="number" name="price" id="price'+cntP+'" class="form-control" placeholder="가격">'+
		    				'<div class="input-group-append">'+
			   					'<button class="btn btn-secondary" type="button" onclick="deleteForm(\'#priceForm'+cntP+'\')">삭제</button>'+
							'</div>'+
						'</div>';
		$("#priceForm").append(addPriceForm);
	}
	// 세일 항목 추가
	function addSaleForm() {
		cntS++;
		var addSaleForm = '<div class="input-group mb-3" id="saleForm'+cntS+'">'
							    +'<input type="text" name="sale" id="sale'+cntS+'" class="form-control" placeholder="할인 항목명">'
						    +'<input type="number" name="salePrice" id="salePrice'+cntS+'" class="form-control" placeholder="가격(원)/비율(%)">'
							+'<div class="input-group-prepend">'
							    +'<select name="saleMethod" id="saleMethod'+cntS+'" class="form-control">'
								        +'<option value="0">--할인 방식 선택--</option>'
								        +'<option value="1">할인비율(-%)</option>'
								        +'<option value="2">할인가격(-원)</option>'
								        +'<option value="3">판매가격(원)</option>'
							    +'</select>'
							+'</div>'
						    +'<div class="input-group-append">'
							    +'<button class="btn btn-secondary" type="button" onclick="deleteForm(\'#saleForm'+cntS+'\')">삭제</button>'
							+'</div>'
						+'</div>';
		$("#saleForm").append(addSaleForm);
	}
	
	// 폼 삭제
	function deleteForm(selected) {
		$(selected).remove();
	}
	
	// 등록하기
	function fCheck() {
		// 정규화시작
		var manager = myform.manager.value;
		var title = myform.title.value;
		var theater = myform.theater.value;
		var startDate = myform.startDate.value;
		var endDate = myform.endDate.value;
		var rating = myform.rating.value;
		var runningTime = myform.runningTime.value;
		var seat1 = $("#seat1").val();
		var price1 = $("#price1").val();
		var fName = myform.fName.value;
		
		if(!checkedManager) {
			alert("담당자 이메일을 확인해주세요. ");
			return false;
		}
		if(title==""){
			alert("제목을 입력하세요.");
			return false;
		}
		if(theater==""){
			alert("극장을 입력하세요.");
			return false;
		}
		if(startDate==""){
			alert("공연 시작일을 입력하세요.");
			return false;
		}
		if(endDate==""){
			alert("공연 종료일을 입력하세요.");
			return false;
		}
		if(rating==""){
			alert("관람등급을 입력하세요.");
			return false;
		}
		if(runningTime==""){
			alert("관람시간을 입력하세요.");
			return false;
		}
		if(seat1==""){
			alert("좌석명을 입력하세요. ");
			return false;
		}
		if(price1==""){
			alert("티켓가격을 입력하세요.");
			return false;
		}
		if(fName==""){
			alert("포스터를 선택하세요.");
			return false;
		}

		// 정규화 끝

		var ans = confirm("입력하신 내용으로 변경됩니다. 정말 등록하시겠습니까?");
		if(!ans) return false;
		
		
		myform.submit();
	}
	
	//ajax 담당자 이메일 존재하는지 조회
	function checkManager() {
		var manager = $("#manager").val();
		$.ajax({
			type:"post", 
			url: "${ctp}/admin/setPerform/searchManager", 
			data: {manager:manager}, 
			success: function(data) {
				if(data=="no") {
					alert("사용불가한 이메일입니다. ");
					$("#manager").val('');
				} else {
					alert("사용가능한 이메일입니다. ");
					checkedManager = true;
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
		<div class="container">
			<form class="form-group" name="myform" method="post" enctype="multipart/form-data" action="${ctp}/admin/setPerform/newPerform">
				<table class="table" id="inputTable">
					<tr>
						<th class="table-secondary">담당자<br/> 이메일</th>
						<td colspan="3">
							<div class="input-group">
								<input type="text" name="manager" id="manager" value="${vo.manager}" class="form-control" required/>
								<div class="input-group-append">
									<button type="button" onclick="checkManager()" class="btn btn-danger">이메일 확인</button>
								</div>
							</div>
						</td>
					</tr>				
					<tr>
						<th class="table-secondary">제목</th>
						<td colspan="3"><input type="text" name="title" id="title" placeholder="제목" class="form-control" required/></td>
					</tr>				
					<tr>
						<th class="table-secondary">극장</th>
						<td colspan="3">
							<input type="text" name="theater" id="theater" list="theaterList" placeholder="장소/극장명" class="form-control" required/>
							<datalist id="theaterList">
								<c:forEach var="vo" items="${vos}">
									<option value="${vo.name}/${vo.address1}"></option>
								</c:forEach>
							</datalist>
							<span class="text-muted">*신규 극장은 주소를 입력하세요.</span>
							<div class="form-group">
								<div class="input-group mb-1">
									<div class="input-group-prepend">
										<span class="input-group-text">주소</span>
									</div>
									<input type="text" name="addrCode" id="sample4_postcode" placeholder="우편번호" class="form-control" required > 
									<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-danger"><br>
								</div>
								<div class="input-group">
									<input type="text" name="address1" id="sample4_roadAddress" class="form-control" placeholder="도로명주소" required > 
									<span id="guide" style="color: #999; display: none"></span>
									<input type="text" name="address2" id="sample4_detailAddress" class="form-control" placeholder="상세주소" required > 
									<input type="text" name="address3" id="sample4_extraAddress" class="form-control" placeholder="참고항목" required >
								</div>
							</div>
						</td>
					</tr>	
					<tr>
						<th class="table-secondary">공연 기간</th>
						<td>
							<input type="date" name="startDate">~<input type="date" name="endDate">
						</td>
					</tr>			
					<tr>
						<th class="table-secondary">관람등급</th>
						<td>
							<select name="rating" id="rating" class="form-control">
								<option selected value="0">전체이용가</option>
								<c:forEach var="age" begin="4" end="18" step="1" >
									<option value="${age}">만${age}세이상 </option>
								</c:forEach>
							</select>
						</td>
						<th class="table-secondary">관람시간(분)</th>
						<td>
							<div class="input-group mb-3">
								<input type="number" name="runningTime" id="runningTime" min="10" max="999" value="100" class="form-control" required/>
							    <div class="input-group-append">
							      <span class="input-group-text">분</span>
							    </div>
							</div>
						</td>
					</tr>							
					<tr>
						<!-- 동적폼 -> 좌석, 가격 -->
						<th class="table-secondary">가격</th>
						<td colspan="3">
							<div id="priceForm">
								<div class="input-group mb-3">
								    <input type="text" name="seat" id="seat1" class="form-control" placeholder="좌석명/등급" required>
								    <input type="number" name="price" id="price1" class="form-control" placeholder="가격" required>
								</div>
							</div>
							<button type="button" onclick="addPriceForm()" class="btn btn-secondary">좌석/가격 추가</button>
						</td>
					</tr>				
					<tr>
						<!-- 동적폼 -> 할인 항목, 가격/비율 선택 -->
						<th class="table-secondary">할인</th>
						<td colspan="3">
							<button type="button" onclick="addSaleForm()" class="btn btn-secondary">할인 항목 추가</button>
							<div id="saleForm"></div>
						</td>
					</tr>				
					<tr>
						<th class="table-secondary">포스터</th>
						<!-- 파일로 받아서 이미지 저장 -->
						<td colspan="3">
							<input type="file" name="fName" id="fName" placeholder="포스터 (.jpg, .png)파일을 선택하세요. " class="form-control" accept=".jpg,.png"/>
						</td>
					</tr>				
					<tr>
						<th class="table-secondary">상세정보</th>
						<td colspan="3">
							<textarea rows="6" name="content" id="CKEDITOR" class="form-control" required>
								<b>[공연시간 정보]</b><br/><br/>
								<b>[공지사항]</b><br/>
								<p>
								</p><br/>
								<b>[할인정보]</b><br/><br/>
								<b>[상세정보]</b><br/><br/>
								<b>[기획사 및 제작사 정보]</b><br/><br/>
								<b>[상품관련정보]</b><br/>
								<table>
									<caption>상품관련정보</caption>
									<tbody>
										<tr>
											<th scope="row" style="width: 15%;">주최/기획</th>
											<td style="width:35%">&nbsp;</td>
											<th scope="row" style="width: 15%;">고객문의</th>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<th scope="row">공연시간</th>
											<td>&nbsp;</td>
											<th scope="row">관람등급</th>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<th scope="row">주연</th>
											<td>&nbsp;</td>
											<th scope="row">공연장소</th>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<th scope="row">예매수수료</th>
											<td>500원</td>
											<th scope="row">배송료</th>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<th scope="row">유효기간/이용조건</th>
											<td colspan="3">&nbsp;</td>
										</tr>
										<tr>
											<th scope="row">예매취소조건</th>
											<td colspan="3">취소일자에 따라 아래와 같이 취소수수료가 부과됩니다. 예매일 기준보다 관람일 기준이 우선 적용됩니다.<br />
											단, 예매 당일 밤 12시 이전 취소 시에는 취소수수료가 없으며 예매수수료도 환불됩니다. (취소기한 내에 한함)<br />
											<br />
											예매후 7일 이내 : 취소수수료 없음<br />
											예매후 8일 ~ 관람일 10일 전 : 뮤지컬/콘서트/클래식 등 공연 장당 4,000원, 연극/전시 등 입장권 장당 2,000원<br />
											(단, 최대 티켓금액의 10% 이내)<br />
											관람일 9일 전 ~ 7일 전 : 티켓금액의 10%<br />
											관람일 6일 전 ~ 3일 전 : 티켓금액의 20%<br />
											관람일 2일 전 ~ 1일 전 : 티켓금액의 30%<br />
											공연 취소 시 : 없음</td>
										</tr>
										<tr>
											<th scope="row">취소환불방법</th>
											<td colspan="3">&#39;마이페이지 &gt; 예매/취소내역&#39;에서 취소마감시간 이내에 취소할 수 있습니다.<br />
											단, 티켓이 배송된 이후에는 인터넷 취소가 불가하며 취소마감 시간 이전에 티켓이 아래 주소로 반송되어야 합니다.<br />
											- 주소 : 13487, 경기도 성남시 분당구 대왕판교로<br />
											- 받는사람 : 환불담당자<br />
											- 연락처: 1588-1234<br />
											취소수수료는 도착일자 기준으로 부과되며 배송료는 환불되지 않습니다.</td>
										</tr>
									</tbody>
								</table>
								<br/>
							</textarea>
						</td>
					    <script>
					      	CKEDITOR.replace("content",{
					      		uploadUrl: "${ctp}/imageUpload",				
					      		filebrowserUploadUrl : "${ctp}/imageUpload",	
					      		height:460
					      	});
					   	</script>
					</tr>	
					<tr>
						<th></th>
						<td align="right" colspan="3">
							<button type="button" onclick="fCheck()" class="btn btn-secondary">등록</button>
						</td>
					</tr>			
				</table>
				<input type="hidden" value="true" name="checked"/>
			</form>
		</div>
	</section>
</body>
</html>