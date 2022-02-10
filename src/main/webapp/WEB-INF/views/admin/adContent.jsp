<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adContent.jsp</title>
<%@ include file="/WEB-INF/views/include/bs4.jsp"%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type='text/javascript' src='http://www.google.com/jsapi'></script>
<script>
    var range="day";
    google.charts.load('current', {packages: ['corechart', 'line', 'calendar','geochart']});
    google.charts.setOnLoadCallback(drawStringChart);
    google.charts.setOnLoadCallback(drawPieChart);
    google.charts.setOnLoadCallback(drawCalendarChart);
    google.charts.setOnLoadCallback(drawGeoChart);
	
    function drawCalendarChart() {
	    var data = new google.visualization.DataTable();
	    data.addColumn({ type: 'date', id: 'Date'});
	    data.addColumn({ type: 'number', id: 'Visitant'});            
	
	    var options = {
     		title: "Visitant", 
     		height: 250,
     		colors: ['#a52714', '#097138']
	    };
            
        var myData = [];
		
        $.ajax({
           	type: "post", 
           	url : "${ctp}/admin/visitChartCalendar", 
           	data : {range:'date'}, 
           	success : function(dt){
           		for(let i=0;i<dt.length; i++) {
           			myData.push([new Date(dt[i].vdate), dt[i].count]);
           		}
           		data.addRows(myData);
                var chart = new google.visualization.Calendar(document.getElementById('VisitantCalendarChart'));
                chart.draw(data, options);
           	},
            error : function() {
            	alert("전송오류!");
        	}
    	});
	}
    
    function drawDateChart() {
	    var data = new google.visualization.DataTable();
	    data.addColumn('date', 'Date');
	    data.addColumn('number', 'Visitant');            
	
	    var options = {
	        hAxis: {
	    		title: 'Date',
	       		textStyle: {color: '#01579b',fontSize: 10,fontName: 'Arial',bold: true,italic: true},
	        	titleTextStyle: {color: '#01579b', fontSize: 16,fontName: 'Arial',bold: false,italic: true}
     		},
     		vAxis: {
      			title: 'Visitant',
	       		textStyle: {color: '#1a237e',fontSize: 16,bold: true},
	       		titleTextStyle: {color: '#1a237e', fontSize: 16, bold: true}
     		},
     		colors: ['#a52714', '#097138']
	    };
            
        var myData = [];
		$.ajax({
           	type: "post", 
           	url : "${ctp}/admin/visitChart", 
           	data : {range:range}, 
           	success : function(dt){
           		for(let i=0;i<dt.length; i++) {
           			myData.push([new Date(dt[i].vdate), dt[i].count]);
           		}
           		data.addRows(myData);
                var chart = new google.visualization.LineChart(document.getElementById('linechart_material'));
                chart.draw(data, options);
           	},
            error : function() {
            	alert("전송오류!");
        	}
    	});
	}
      
    function drawNumberChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('number', range);
        data.addColumn('number', 'Visitant');            

        var options = {
            hAxis: {
              	title: range,
              	textStyle: {color: '#01579b',fontSize: 10,fontName: 'Arial',bold: true,italic: true},
              	titleTextStyle: {color: '#01579b',fontSize: 16,fontName: 'Arial',bold: false,italic: true}
        	},
           	vAxis: {
             	title: 'Visitant',
	            textStyle: {color: '#1a237e',fontSize: 16,bold: true},
	            titleTextStyle: {color: '#1a237e',fontSize: 16,bold: true}
            },
            colors: ['#a52714', '#097138']
        };
          
        var myData = [];
        $.ajax({
          	type: "post", 
          	url : "${ctp}/admin/visitChart", 
          	data : {range:range}, 
          	success : function(dt){
          		for(let i=0;i<dt.length; i++) {
          			myData.push([parseInt(dt[i].vdate), dt[i].count]);
          		}
          		data.addRows(myData);
                  var chart = new google.visualization.LineChart(document.getElementById('linechart_material'));
                  chart.draw(data, options);
          	},
          	error : function() {
          		alert("전송오류!");
          	}
    	});
    }
    function drawStringChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', range);
        data.addColumn('number', 'Visitant');            

        var options = {
            hAxis: {
              	title: range,
              	textStyle: {color: '#01579b',fontSize: 10,fontName: 'Arial',bold: true,italic: true},
              	titleTextStyle: {color: '#01579b',fontSize: 16,fontName: 'Arial',bold: false,italic: true}
        	},
           	vAxis: {
             	title: 'Visitant',
	            textStyle: {color: '#1a237e',fontSize: 16,bold: true},
	            titleTextStyle: {color: '#1a237e',fontSize: 16,bold: true}
            },
            colors: ['#a52714', '#097138']
        };
          
        var myData = [];
        $.ajax({
          	type: "post", 
          	url : "${ctp}/admin/visitChart", 
          	data : {range:range}, 
          	success : function(dt){
          		for(let i=0;i<dt.length; i++) {
          			myData.push([dt[i].day, dt[i].count]);
          		}
          		data.addRows(myData);
                  var chart = new google.visualization.LineChart(document.getElementById('linechart_material'));
                  chart.draw(data, options);
          	},
          	error : function() {
          		alert("전송오류!");
          	}
    	});
    }
      
    function chartReload(selrange) {
    	google.charts.load('current', {packages: ['corechart', 'line']});
        google.charts.setOnLoadCallback(drawDateChart);
		range = selrange;
        drawDateChart();
    }
    function stringChartReload(selrange) {
    	google.charts.load('current', {packages: ['corechart', 'line']});
        google.charts.setOnLoadCallback(drawStringChart);
		range = selrange;
		drawStringChart();
    }
    function numberChartReload(selrange) {
    	google.charts.load('current', {packages: ['corechart', 'line']});
        google.charts.setOnLoadCallback(drawNumberChart);
		range = selrange;
		drawNumberChart(selrange);
    }
    
    function drawPieChart() {
    	var myData = [];
    	 $.ajax({
           	type: "post", 
           	url : "${ctp}/admin/ticketingdata", 
           	success : function(dt){
           		myData.push(['제목', '판매량']);
           		for(let i=0;i<dt.length; i++) {
           			myData.push([dt[i].performTitle, dt[i].ticketNum]);
           		}
           		
           		var data = google.visualization.arrayToDataTable(myData);
           		
           	 	var options = {
                     title: '예매량',
                     pieHole: 0.3,
                     width: 550, 
                     height: 500
                };
	           	var chart = new google.visualization.PieChart(document.getElementById('donutchart'));
	            chart.draw(data, options);
           	},
           	error : function() {
           		alert("전송오류!");
           	}
     	});
      }
    
    function drawGeoChart() {
    	var data = new google.visualization.DataTable();
    	var options = {};
		var regionRank = "<tr class='thead-light text-center'><th>순위</th><th>지역</th><th>판매량</th></tr>";
    	data.addColumn('string', 'Country');
    	data.addColumn('number', 'Value'); 
    	$.ajax({
    		type: "post", 
    		url : "${ctp}/admin/getRegionTicketSales", 
    		success: function(dt) {
    			var max = 0;
    			for(let i=0; i < dt.length; i++){
    				if(i<7){
    					if(max < dt[i].cnt) max = dt[i].cnt;
	    				regionRank += "<tr class='";
	    				if(dt[i].cnt==max) regionRank += "table-danger ";
	    				if(dt[i].cnt<max && dt[i].cnt>(max*0.5)) regionRank += "table-warning ";
	    				regionRank += "text-center'><td>"+(i+1)+"위</td><td>"+dt[i].regionName + "</td><td>" + dt[i].cnt + "장</td></tr>";
    				}
			    	data.addRows([[{v:dt[i].regionCode, f:dt[i].regionName},dt[i].cnt]]);
    			}
    			options = {
    		    		backgroundColor: {fill:'#FFFFFF',stroke:'#FFFFFF' ,strokeWidth:0 },
    		    		colorAxis:  {minValue: 0, maxValue: max,  colors: ['#e3eef3','#aec7d3','#87aec0','#6897ad','#669fb9','#4486a5','#3e83a3','#3182bd','#3182BD','#1e70ac']},
    		    		legend: 'none',	
    		    		backgroundColor: {fill:'#FFFFFF',stroke:'#FFFFFF' ,strokeWidth:0 },	
    		    		datalessRegionColor: '#f5f5f5',
    		    		displayMode: 'regions', 
    		    		enableRegionInteractivity: 'true', 
    		    		resolution: 'provinces',
    		    		sizeAxis: {minValue: 1, maxValue:1,minSize:10,  maxSize: 10},
    		    		region:'KR', //country code
    		    		keepAspectRatio: true,
    		    		width:600,
    		    		height:400,
    		    		tooltip: {textStyle: {color: '#444444'}, trigger:'focus'}	
    		    };
		    	var chart = new google.visualization.GeoChart(document.getElementById('geoChart')); 
		    	document.getElementById('regionRank').innerHTML = regionRank;
		    	chart.draw(data, options);
    		}
    	});
		var chart = new google.visualization.GeoChart(document.getElementById('geoChart')); 
		chart.draw(data, options);

    	
    	google.visualization.events.addListener(chart, 'select', function() {
    	 	var selection = chart.getSelection();
    	 	if (selection.length == 1) {
    	 		var selectedRow = selection[0].row;
    	 		var selectedRegion = data.getValue(selectedRow, 0);
    	 		if(ivalue[selectedRegion] != '') {
    	 			document.getElementsByTagName('body')[0].style.background=ivalue[selectedRegion]; 
    	 		}
    	 	}
    	});
    }
    
</script>
</head>
<body>
	<p><br></p>
	<div class="container">
		<h2>작업상황</h2>
		<hr />
		<p>
			<a href="${ctp}/admin/member/official">관계자 등업 신청(<font color="red"><b>${newApplyOfficial}</b></font> 건)</a> <br/>
			<a href="${ctp}/admin/setPerform/adminPerformList?orderBy=checked">인증대기작품(<font color="red"><b>${noAccessPerform}</b></font> 건)</a><br/>
			<a href="${ctp}/admin/plaza/freeBoard">신규게시글(<font color="red"><b>${newBoardNum}</b></font> 건)</a><br/>
			<a href="${ctp}/admin/plaza/freeBoard">신규댓글(<font color="red"><b>${newReplyNum}</b></font> 건)</a><br/>
			
			<a href="${ctp}/admin/support/qna/qnaList">신규문의(<font color="red"><b>${newQnaCnt}</b></font> 건)</a><br/>
			<a href="${ctp}/admin/review/reportedReview">신고리뷰(<font color="red"><b>${newReportCnt}</b></font> 건)</a>
		</p>
		<hr />
		<p>오늘 방문수 <font color="red">${todayVisit}</font> 건<br/>
		누적 방문수 <font color="red">${totalVisit}</font> 건</p>
		<hr />
		
		<p>예매량, 인기있는 작품 차트, 연령.성별등 기준별 인기차트</p>
		<hr />
		
    	<div id="VisitantCalendarChart" style="width: 100%;"></div>
		<div class="row">
			<div class="col-6">
				<div id="linechart_material" style="width: 100%; height:300px"></div>
				<div style="width:100%;text-align:center;opacity:0.6;">
					<button class="badge badge-pil badge-primary" onclick="stringChartReload('day')">요일별</button>
					<button class="badge badge-pil badge-primary" onclick="numberChartReload('time')">시간대별</button>
					<button class="badge badge-pil badge-primary" onclick="chartReload('date')">일별</button>
					<button class="badge badge-pil badge-primary" onclick="numberChartReload('month')">월별</button>
					<button class="badge badge-pil badge-primary" onclick="numberChartReload('year')">연도별</button>
				</div>
			</div>
			<div class="col-5">
	    		<div id="donutchart" style="width:100%;"></div>
	    	</div>
    	</div>
    	<div class="row mt-3">
    		<div class="col-6">
    			<h4>지역별 예매량(회원 주소지 기준)</h4>
    			<div id='geoChart' style="width:606px;height:406px;border:3px solid gray;padding:0;"></div>
    		</div>
    		<div class="col-3 ml-4 pl-4">
    			<table id="regionRank" class="table table-bordered" style="background-color: #fafafa">
    				
    			</table>
    		</div>
    	</div>
	</div>
	<br />
</body>
</html>