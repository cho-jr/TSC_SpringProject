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
<link rel="icon" href="${ctp}/icons/titleIcon.ico">
<style type="text/css">
	td {min-width: 100px;}
</style>
<script type="text/javascript">
	var selectedTheme = "";
	var selectedPerform = "";
	
	$(function() {
		$('#lost_mask').css({'width':'0','height':'0'});
		$("button").addClass("btn btn-secondary btn-sm");
		$("select").addClass("form-control");
		
		$("#performList").on("click", function() {
			selectedPerform = $(this).val();
		});
		$("#themeList").on("click", function() {
			$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
			$('#lost_mask').fadeIn(0);      
			$('#lost_mask').fadeTo("fast");
			// 선택한 테마 공연 목록 가져와서 #selectedPerform에 뿌려!
			selectedTheme = $(this).val(); 
			if($(this).val()!= null) {
				$.ajax({
					type:"post", 
					url : "${ctp}/admin/setMain/getPerforms", 
					data : {theme : $(this).val().substring($(this).val().indexOf(')')+1)}, 
					success : function(data) {
						var inputHtml = "";
						for(let i=0; i<data.length; i++) {
							if(data[i]!=null){
								inputHtml += '<option value="'+data[i].idx+'" id="'+data[i].idx+'">'+data[i].title+'</option>';
								
							}
						}
						$("#selectedPerform").html(inputHtml);
						$('#lost_mask').css({'width':'0','height':'0'});
					}, 
					error: function() {
						$('#lost_mask').css({'width':'0','height':'0'});
					}
				});
			}
		});
	});
	// 테마 추가!
	function addTheme(){
		var addThemeName = $("#addThemeName").val();
		if(addThemeName=="")return false;
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});
		$('#lost_mask').fadeIn(0);      
		$('#lost_mask').fadeTo("fast");
		$.ajax({
			type:"post", 
			url : "${ctp}/admin/setMain/addThemeName", 
			data : {theme : addThemeName}, 
			success : function() {
				location.href='${ctp}/admin/setMain/setThemePerform';
			}, 
			error : function() {
				$('#lost_mask').css({'width':'0','height':'0'});
			}
		});
	}
	
	// 선택한 테마에 작품 추가
	function addPerformInTheme() {
		if(selectedTheme==""){
			alert("테마를 선택해주세요. ");
			return false;
		}
		var performIdx = selectedPerform;
		if(performIdx!=null || performIdx!="") {
			$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});$('#lost_mask').fadeIn(0);$('#lost_mask').fadeTo("fast");
			var query = {performIdx : performIdx, theme : selectedTheme.substring(selectedTheme.indexOf(')')+1)}
			
			$.ajax({
				type:"post", 
				url : "${ctp}/admin/setMain/addPerformInTheme", 
				data : query, 
				success : function(data) {
					if(data==""){
						alert("최대 작품수을 초과했습니다. (최대 4개)")					
						$('#lost_mask').css({'width':'0','height':'0'});
					} else {
						alert("작품을 목록에 추가했습니다. ");
						location.href='${ctp}/admin/setMain/setThemePerform';
					}
				}, 
				error : function() {
					$('#lost_mask').css({'width':'0','height':'0'});
				}
			});
		}
	}
	// 선택한 테마에 작품 삭제
	function deletePerformInTheme() {
		if(selectedTheme==""){
			alert("테마를 선택해주세요. ");
			return false;
		}
		selectedTheme = selectedTheme.substring(selectedTheme.indexOf(')')+1);
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});$('#lost_mask').fadeIn(0);$('#lost_mask').fadeTo("fast");
		var performIdx = $("#selectedPerform").val();
		var query = {performIdx : performIdx, theme : selectedTheme}
		
		$.ajax({
			type:"post", 
			url : "${ctp}/admin/setMain/deletePerformInTheme", 
			data : query, 
			success : function() {
				alert("선택한 작품을 목록에서 제거했습니다. ");
				location.href='${ctp}/admin/setMain/setThemePerform';
			}, 
			error : function(){
				$('#lost_mask').css({'width':'0','height':'0'});
			}
		});
	}
	
	// 선택한 테마 노출
	function showTheme() {
		if($("#themeListAll").val()!=null) {
			$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});$('#lost_mask').fadeIn(0);$('#lost_mask').fadeTo("fast");
			selectedTheme = $("#themeListAll").val();
			$.ajax({
				type:"post", 
				url : "${ctp}/admin/setMain/addShowTheme", 
				data : {theme : selectedTheme.substring(selectedTheme.indexOf(')')+1)}, 
				success : function(data) {
					if(data=='fail') {
						alert("3 작품 이상 선택된 테마만 메인 화면 노출 가능합니다. ");
						$('#lost_mask').css({'width':'0','height':'0'});
					} else {
						alert("선택하신 테마가 추가되었습니다. ");
						location.href = "${ctp}/admin/setMain/setThemePerform";					
					}
				}, 
				error : function(){
					$('#lost_mask').css({'width':'0','height':'0'});
				}
			});
		}
	}
	
	// 선택한 테마 숨기기
	function hideTheme(){
		var selectTheme = $("#showThemeList").val();
		if(selectTheme != null) {
			$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});$('#lost_mask').fadeIn(0);$('#lost_mask').fadeTo("fast");
			$.ajax({
				type:"post", 
				url : "${ctp}/admin/setMain/delShowTheme", 
				data : {theme : selectTheme}, 
				success : function() {
					location.href = "${ctp}/admin/setMain/setThemePerform";					
				}, 
				error : function(){
					$('#lost_mask').css({'width':'0','height':'0'});
				}
			});
		}
	}

	//선택한 테마 삭제
	function delTheme(){
		var theme = $("#themeList").val();
		if(theme==null) {
			alert("선택된 테마가 없습니다. ");
			return false;
		}
		
		var ans = confirm("선택한 테마를 삭제하시겠습니까?");
		if(!ans) return false;
		
		$('#lost_mask').css({'width':$(window).width(),'height':$(window).height()});$('#lost_mask').fadeIn(0);$('#lost_mask').fadeTo("fast");
		$.ajax({
			type:"post", 
			url : "${ctp}/admin/setMain/delTheme", 
			data : {theme : theme.substring(selectedTheme.indexOf(')')+1)}, 
			success : function() {
				location.href = "${ctp}/admin/setMain/setThemePerform";	
			}, 
			error : function(){
				$('#lost_mask').css({'width':'0','height':'0'});
			}
		});
	}
</script>
</head>
<body style="margin-left: 20px;">
	<div id="lost_mask" style="position:fixed;z-index:9000;display:none;left:0;top:0; z-index:9000;background-color:#5558;text-align:center;color:white;">
		<div style="display: flex; align-items: center;margin: auto; height:100%;">
			<div class="spinner-border" style="margin: auto;"></div>
		</div>
	</div> 
	<br/>
	<header><h2>관리자 메뉴</h2></header>

	<section>
		<div class="container-fluid p-3">
			<h3>&lt;테마별 작품 설정&gt;</h3>
			<div>테마별 작품은 3~4개만 조회 가능합니다. </div>
			<table class="table">
				<tr>
					<td style="width:27%;">
						<!-- 테마 목록 -->
						<h4>테마 목록</h4>
						<select size="6" id="themeList">
							<c:forEach var="vo" items="${themeVos}">
								<option title="${vo.theme}(${vo.count})">(${vo.count})${vo.theme}</option>
							</c:forEach>
						</select>
						<br/>
						<div class="input-group">
							<input type="text" class="form-control" id="addThemeName">
							<div class="input-group-append">
								<button type="button" onclick="addTheme()">테마추가</button>
							</div>
						</div>
						<button type="button" class="mt-2" onclick="delTheme()">선택테마삭제</button>
					</td>
					<td style="width:27%;">
						<!-- 공연중인 작품 목록 -->
						<h4>전체 작품 목록</h4>
						<select size="6" id="performList">
							<optgroup label="공연중" style="background-color: #fff3f5">	
								<c:forEach var="vo" items="${performVos}">
									<option value="${vo.idx}" title="${vo.title}">${vo.title}</option>		
								</c:forEach>
							</optgroup>		
							<optgroup label="공연예정" style="background-color: #f3f5ff;">
								<c:forEach var="vo" items="${prePerformVos}">
									<option value="${vo.idx}" title="${vo.title}">${vo.title}</option>		
								</c:forEach>
							</optgroup>				
						</select>
					</td>
					<td style="width:10%;text-align: center;padding-top:70px">
						<button type="button" onclick="addPerformInTheme()">등록&nbsp;&nbsp;&gt;</button><br/><br/>
						<button type="button" onclick="deletePerformInTheme()">&lt;&nbsp;&nbsp;제거</button>
					</td>
					<td style="width:27%;">
						<!-- 선택한 테마 공연  -->
						<h4>테마 작품 목록</h4>
						<select size="6" id="selectedPerform"></select>
					</td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td >
						<!-- 테마 전체 목록 -->
						<h4>전체 테마 목록</h4>
						<select size="6" id="themeListAll">
							<c:forEach var="vo" items="${themeVos}">
								<option title="${vo.theme}"
									<c:forEach var="theme" items="${selectedTheme}">
										<c:if test="${theme == vo.theme}"> style="background-color:#fee;"</c:if>
									</c:forEach>
									>
									(${vo.count})${vo.theme}
								</option>
							</c:forEach>
						</select>
					</td>
					
					<td style="width:10%;text-align: center;padding-top:70px">
						<button type="button" onclick="showTheme()">등록&nbsp;&nbsp;&gt;</button><br/><br/>
						<button type="button" onclick="hideTheme()">&lt;&nbsp;&nbsp;제거</button>
					</td>
					<td>
						<!-- 메인에 보여줄 목록 -->
						<h4>메인화면 노출 테마 목록</h4>
						<select size="5" id="showThemeList">
							<c:forEach var="theme" items="${selectedTheme}">
									<option title="${theme}">${theme}</option>
							</c:forEach>
						</select>
					</td>
					<td></td>
				</tr>
			</table>
		</div>
	</section>
</body>
</html>