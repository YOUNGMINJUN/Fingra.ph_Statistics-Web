<!--
 * Copyright 2014 tgrape Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="fh"%>
<!DOCTYPE html>
<html>
<head>
<meta name="menuId" content="components" />
<meta name="currentMenu" content="activeusers" />
<title>Fingra.ph - <spring:message code="dash.title.components"/></title>
<script type="text/javascript" src="<c:url value="/resources/js/fingraph-yesterday-statConfig.js"/>"></script>
<script type="text/javascript">
$(function() {
	//period setting
	period = $("#period").msDropdown({
			roundedCorner:true,
			on:{change: function(data, ui){addPeriods(data.value);}}
			}).data("dd");
	//term setting
	term = $("#term").msDropdown({
			roundedCorner:true,
			on:{change: function(data, ui){getFingraphData();}}
			}).data("dd");
	//segment setting
	segment = $("#segment").msDropdown().data("dd").set("disabled", true);

});


function getFingraphData(){
	$('#groupkey').val($("#componentGrpList").val());
	$.ajax({
		url: '<c:url value="/components/getActiveUsersAjax"/>',
		data: $('#fingraphSearchParam').serialize(),
		type: 'POST',
		dataType: 'json',
		success: function(data) {
			displayActiveUsers(data.tlist,data.tslist);
			displayActiveUsersTable(data.alist);
			displayActiveUsersExcelTable(data.tlist,data.tslist);
		}
	});
}

//activeUsers Excel table
function displayActiveUsersExcelTable(tlist, tslist){
	// remove all exclude header
	while($("#report_table_0 tr").length > 0) {
		$("#report_table_0 tr").last().remove();
	}
	if(tlist == null || tslist == null){return;}

	var html = "";
	var term = $('#term').val();
 	var excel_date = '';

	html += "<tr><th width='50'> Date</th>";
	for(var i = 0;i<tlist.length;i++) {
		var row = tlist[i];
		html += "<th width='30'>"+row.name+"</th>";
	}
	html += "<th width='30'>App Total</th></tr>";

	for(var j=0 ; j < tslist.length ; j++){
		html += "<tr>";
		if(term == 'daily'){
			excel_date = moment(tslist[j].date).format('YYYY-MM-DD');
		}else if(term=='weekly'){
			excel_date = moment(tslist[j].fromDate).format('YYYY-MM-DD') + ' ~ ' + moment(tslist[j].toDate).format('YYYY-MM-DD');
		}else if(term=='monthly'){
			excel_date = moment(tslist[j].year + '-' + tslist[j].month).format('YYYY-MM');
		}
		html += "<td>" + excel_date + "</td>";
		for(var i = 0;i<tlist.length;i++) {
			html += "<td class='numFormat'>"+ eval('tslist['+j+'].top'+i); +"</td>";
		}

		html += "<td class='numFormat'>" + tslist[j].appTotal + "</td>";
		html +="</tr>";
	}
	$("#report_table_0").append(html);
}
//activeUsers Daily graph&table
function displayActiveUsers(tlist, tslist){
	var chart = null;
	var term = $('#term').val();
	var fromTo = $('#fromTo').val();
	var colors = Highcharts.getOptions().colors;
	//bar chart
	var category = new Array(tlist.length);
	var column_data_array = new Array(tlist.length);
	var total = 0;
	for(var i = 0;i<tlist.length;i++) {
		var row = tlist[i];
		category[i]= row.name;
		column_data_array[i] = {y: row.value, color: colors[i]};
		total+=row.value;
	}
	//graph title
	var groupVal = $('#componentGrpList').val();
	var groupText = $('#componentGrpList option:selected').text();
	var termText = $('#term option:selected').text();
	var barTitle='<spring:message code="chart.comp.activeUser.bar.title.topc"/>';
	var lineTitle=termText +'<spring:message code="chart.comp.activeUser.line.title.topc"/>';
	if (groupVal==-1){
		barTitle='<spring:message code="chart.comp.activeUser.bar.title.interg"/>';
		lineTitle=termText +' <spring:message code="chart.comp.activeUser.line.title.interg"/>';
	}else if(groupVal>=0){
		barTitle=groupText +': '+'<spring:message code="chart.comp.activeUser.bar.title.group"/>';
		lineTitle=groupText +': '+termText +'<spring:message code="chart.comp.activeUser.line.title.group"/>';
	}
	var subTitle = makeSubTitle(term, fromTo);
    makeDefaultColumnChart(chart, 'barChart', barTitle, subTitle, '<spring:message code="chart.comp.activeUser.var.y.text"/>', category, column_data_array,total);

    if(tslist == null){
       	makeMultiLineChart(chart, 'line', lineTitle, subTitle, '<spring:message code="chart.comp.activeUser.line.y.text"/>', '','', '');
       	return;
    }
    var cate = new Array(tslist.length);
	var line_data_array = new Array(tlist.length+1);
 	var name;
 	var isVisible;
	for(var i = 0;i<tlist.length+1;i++) {
		if(i  < tlist.length){
			name=tlist[i].name;
			isVisible=i<3?true:false;
		}else{
			name='App Total';
			isVisible=false;
		}
		var dArray = new Array(tslist.length);
		for(var j=0 ; j < tslist.length ; j++){
			if(i  < tlist.length){
				dArray[j] = eval('tslist['+j+'].top'+i);
			}else{
				dArray[j] = tslist[j].appTotal;
			}
			if(term == 'daily'){
				cate[j]=moment(tslist[j].date).format('MMM D, YYYY');
			}else if(term=='weekly'){
				cate[j] = moment(tslist[j].fromDate).format('MMM D, YYYY') + ' ~ ' + moment(tslist[j].toDate).format('MMM D, YYYY');
			}else if(term=='monthly'){
				cate[j] = moment(tslist[j].year + '-' + tslist[j].month).format('MMM, YYYY');
			}
		}
		line_data_array[i]={name:name,data:dArray,visible: isVisible};
	}
	var space = term=='daily'?0.2:(term=='weekly'?0.4:0.15);
	var xstep = parseInt(tslist.length * space);
	makeMultiLineChart(chart, 'line', lineTitle, subTitle, '<spring:message code="chart.comp.activeUser.line.y.text"/>', cate, xstep, line_data_array);
}
function displayActiveUsersTable(result){
	// remove all except header.
	while($("#actual_table tr").length > 1) {
		$("#actual_table tr").last().remove();
	}
	//table td-title
	if($('#componentGrpList').val() ==-1){
		$("#actual_table tr th.tdName").html('<spring:message code="chart.comp.table.groupNm"/>');
		$("#actual_table tr th.tdOfAll").html('<spring:message code="chart.comp.table.ofAllGroup"/>');
	}else{
		$("#actual_table tr th.tdName").html('<spring:message code="chart.comp.table.compNm"/>');
		$("#actual_table tr th.tdOfAll").html('<spring:message code="chart.comp.table.ofAllComp"/>');
	}
	if(result == null) return;
	// make table
	for(var i = 0 ; i<result.length ; i++) {
		var html = "";
		var row = result[i];

		var name = row.name;
		var actual = $.formatNumber(row.actual, {format:"#,##0", locale:"us"});
		var appTotal = $.formatNumber(row.appTotal, {format:"#,##0", locale:"us"});
		var percentTotal = $.formatNumber(row.percentTotal, {format:"#0.0", locale:"us"});
		var percentAllCom = $.formatNumber(row.percentAllCom, {format:"#0.0", locale:"us"});

		html += '<tr>\n';
		html += '	<th>'+name+'</th>\n';
		html += '   <td>'+actual+'</td>\n';
		html += '   <td>'+appTotal+'</td>\n';
		html += '	<td>'+percentTotal+'%</td>\n';
		html += '	<td>'+percentAllCom+'%</td>\n';
		html += '</tr>\n'
		$("#actual_table").append(html);
		$("#actual_table tbody tr:odd").addClass('m1');
		$("#actual_table tbody tr:even").addClass('m2');
	}
}
</script>
</head>
<body>
	<div id="main-cont">
	<!-- section start -->
	<jsp:include page="/components/include/section" flush="true">
	 <jsp:param name="appkey" value="${app.appkey}"/>
	 <jsp:param name="subMenu" value="activeUsers" />
	</jsp:include>
	<!-- section end -->
	<!-- graph start -->
	<div class="sub-content">
	   	<div class="sub-title-wrap">
	   		<a class="sub-down-report" href="javascript:download_report('1');"><img src="<c:url value="/resources/img/btn-excel.png"/>"  alt="Excel Down" title="Excel Down"/></a>
	   		<h2 class="title"><spring:message code="dash.card.activeUser.title"/></h2>
	       </div>
	       <div class="box">
	       	<form name="fingraphSearchParam" id="fingraphSearchParam">
	   			<input type="hidden" name="appkey" id="appkey" value="${app.appkey}"/>
		    	<input type="hidden" name="fromTo" id="fromTo" value=""/>
		    	<input type="hidden" name="groupkey" id="groupkey" value=""/>
		    	<div class="sel-menu">
	       			<div class="fromToArea">
	       			<img id="periodPrev" src="<c:url value="/resources/img/btn_pride_prev_inactive.png"/>" alt="" title="지정기간 앞 기간" class="periodPrev" >
	           		<input type="text" class="date-width" id="from" name="from" value="" readonly="readonly" style="color: #3A414B;margin: 0;padding:3px 0 2px 5px;"/><span id="periodDiffDays">to</span>
					<input type="text" class="date-width" id="to" name="to" value="" readonly="readonly" style="color: #3A414B;margin: 0;padding:3px 0 2px 10px;"/>
                    <div id="calImgDiv" style="display: none;">
					    <img id="calImg" src="<c:url value="/resources/img/btn_calendar.png"/>" alt="" class="trigger calImg" style=" cursor: pointer; margin: 0 4px;">
					</div>
					<img id="periodNext" src="<c:url value="/resources/img/btn_pride_next_inactive.png"/>" alt="" title="지정기간 뒤 기간" class="periodNext" style="margin-left: -5px;">
	               </div>
	               <select name="period" id="period" class="period-width">
					    <option value="7-d"><spring:message code="chart.select1.option1"/></option>
					    <option value="30-d" selected="selected"><spring:message code="chart.select1.option2"/></option>
					    <option value="3-m"><spring:message code="chart.select1.option4"/></option>
					    <option value="6-m"><spring:message code="chart.select1.option5"/></option>
					    <option value="t-y"><spring:message code="chart.select1.option6"/></option>
					    <option value="c-u"><spring:message code="chart.select1.option7"/></option>
					 </select>
					 <select name="term" id="term" class="input-small">
					    <option value="daily"><spring:message code="chart.select2.option1"/></option>
					    <option value="weekly"><spring:message code="chart.select2.option2"/></option>
					    <option value="monthly"><spring:message code="chart.select2.option3"/></option>
					 </select>
					 <select name="segment" id="segment" class="input-medium">
					    <option value=""><spring:message code="chart.select3.default.option0"/></option>
					 </select>
	          </div>
	          </form>
	           <div class="chart" id="barChart" class="graph_visual"></div>
	           <div class="chart" id="line" class="graph_visual"></div>
	           <div>
                <table class="comp-table" id="actual_table">
	                <colgroup>
		                <col />
		                <col width="18%" />
		                <col width="18%" />
		                <col width="18%" />
		                <col width="18%" />
	                </colgroup>
                    <thead>
	                    <tr>
	                        <th scope="col" class="top tdName"><spring:message code="chart.comp.table.compNm"/></th>
	                        <th scope="col" class="top"><spring:message code="chart.comp.table.actualAu"/></th>
	                        <th scope="col" class="top"><spring:message code="chart.comp.table.totalAu"/></th>
	                        <th scope="col" class="top"><spring:message code="chart.comp.table.ofTotalAu"/></th>
	                        <th scope="col" class="top tdOfAll"><spring:message code="chart.comp.table.ofAllComp"/></th>
	                    </tr>
                    </thead>
                    <tbody>
						<!-- actual data table -->
                    </tbody>
                 </table>
                </div>
	       </div>
	  </div>
	  <!-- graph end -->
	  <!-- Excel table -->
	  <table id="report_table_0" style="display:none;">
      </table>
	</div>
</body>
</html>