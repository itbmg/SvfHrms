<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="DashBoard2.aspx.cs" Inherits="DashBoard2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
     <script type="text/javascript" src="js/jscharts.js"></script>
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
    <script src="amcharts/amcharts.js" type="text/javascript"></script>
    <script src="amcharts/pie.js" type="text/javascript"></script>
    <script src="amcharts/serial.js" type="text/javascript"></script>
    <script src="amcharts/plugins/export/export.js" type="text/javascript"></script>
    <link href="amcharts/plugins/export/export.css" rel="stylesheet" type="text/css" />
    <script src="amcharts/plugins/export/export.min.js" type="text/javascript"></script>
<script src="https://www.amcharts.com/lib/3/themes/light.js"></script>
<script src="https://www.amcharts.com/lib/3/themes/none.js"></script>
    <script type="text/javascript">
        $(function () {
            
//            var hrs = today.getHours();
//            var mnts = today.getMinutes();
            //            $('#ddlmonth').val(mm);
            //            $('#year1').val(yyyy);
            employeeagewisechart();
             Getbranchwisesalary();
            Getemployeegenderdetails();
            Getemployeeaddandsubbarchart();
            Getemployeetypewisedetails();
            Getdepartemntandbranchwisesalary();
           
        });

        function callHandler(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                data: d,
                type: 'GET',
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
            $.ajax({
                type: "GET",
                url: "EmployeeManagementHandler.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function Getemployeegenderdetails() {
            var type = "Gender";
            var ChartType ="All Location";
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employeetypePieChartValues', 'type': type,'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        LineChartforVehicleMileage(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var newXarray = [];
        function LineChartforVehicleMileage(databind) {
            newXarray = [];
            var textname = "";
            var ChartType = "All Location";
            var countgen = databind[0].countgen;
            var branchname = databind[0].branchname;
            for (var i = 0; i < branchname.length; i++) {
                newXarray.push({ "category": branchname[i], "value": parseFloat(countgen[i]) });
            }


            var chart = AmCharts.makeChart("divChart", {
                type: "pie",
                theme: "light",
                dataProvider:newXarray,
                valueField: "value",
                titleField: "category",
                outlineAlpha: 0.4,
                depth3D: 15,
                balloonText: "[[title]]<br><span style='font-size:14px'><b>[[value]]</b> ([[percents]]%)</span>",
                angle: 30,
                export: {
                    enabled: true
                }
            });
            
        }

        function employeeagewisechart() {
            var barnchname = "ALL";
            var campny = '<%= Session["company_id"] %>';
            var data = { 'op': 'Agewiseemployeecount_barChartValues', 'campny': campny, 'barnchname': barnchname };
            var s = function (msg) {
                if (msg == "") {
                    alert("No Data Found");
                    $("#divChart1").css('display', 'none');
                }
                else if (msg) {
                    if (msg.length > 0) {
                        createbarChart(msg)
                        $("#divChart1").css('display', 'block');
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createbarChart(databind) {
            var xbranchname = databind[0].branchname;
            var xcountgen = databind[0].countgen;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    color = ["#d9534f", "#FF6600", "#FF9E01", "#FCD202", "#F8FF01", "#B0DE09", "#04D215"];
                    for (var i = 0; i < xbranchname.length; i++) {
//                    myData.push([xbranchname[i].toString(), parseInt(xcountgen[i])]);
                         myData.push({"branch":xbranchname[i].toString(), "empcount":parseInt(xcountgen[i]),"color":color[i]});
                    }
                }
            }
             var chart = AmCharts.makeChart("divChart1", {
                 "type": "serial",
                 "theme": "light",
                 "marginRight": 70,
                 "rotate": true,
                 dataProvider:myData,
                 "valueAxes": [{
                     "axisAlpha": 0,
                     "position": "left",
                     "title": "Age Distribution"
                 }],
                 "startDuration": 1,
                 "graphs": [{
                     "balloonText": "<b>[[category]]: [[value]]</b>",
                     "fillColorsField": "color",
                     "fillAlphas": 0.9,
                     "lineAlpha": 0.2,
                     "type": "column",
                     "valueField": "empcount"
                 }],
                 "chartCursor": {
                     "categoryBalloonEnabled": false,
                     "cursorAlpha": 0,
                     "zoomable": false
                 },
                 "categoryField": "branch",

                 "categoryAxis": {
                     "gridPosition": "start",
                      "labelRotation": 45
                 },
                 "export": {
                     "enabled": true
                 }

             });
             
//            var myChart = new JSChart('divChart1', 'bar');
//            myChart.setDataArray(myData);
//    myChart.setSize(400, 300);
//	myChart.setBarValues(false);
//	myChart.setBarSpacingRatio(45);
//	myChart.setBarOpacity(0.8);
//	myChart.setBarBorderWidth(0);
//	myChart.setTitle('Age Wise Employee  Count');
//	myChart.setTitleFontSize(10);
//	myChart.setTitleColor('#2D6B96');
//	myChart.setAxisValuesColor('#2D6B96');
//	myChart.setAxisNameX('', );
//	myChart.setAxisNameY('%', );
//	myChart.setAxisColor('#B5B5B5');
//	myChart.setAxisNameColor('#2D6B96');
//	myChart.setGridOpacity(0.8);
//	myChart.setGridColor('#B5B5B5');
//	myChart.setIntervalEndY(50);
//	myChart.setAxisReversed(true);
//	myChart.draw();

        }
        function Getemployeeaddandsubbarchart() {
            var name = "";
            var tmonth = "";
            var ChartType = "All Location";
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            Month = mm; 
            Year = yyyy;
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employee_relieving_joingcount_barChartValues', 'Month': Month, 'Year': Year, 'name': name, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg == "No data Found") {
                    $('#graph').css('display', 'none');
                }
                else if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        createlineChart(msg);
                        $('#graph').css('display', 'block');
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createlineChart(databind) {
            var xbranchname = databind[0].branchname;
            var xcountgen = databind[0].countgen;
            var xcountgen1 = databind[0].countgen1;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    xcountgen1 = databind[0].countgen1;
                    for (var i = 0; i < xbranchname.length; i++) {

//                        myData.push([xbranchname[i].toString(), parseInt(xcountgen[i]), parseInt(xcountgen1[i])]);
                        myData.push({ "branch": xbranchname[i].toString(), "Joiningcount": parseInt(xcountgen[i]), "Relievingcount":  parseInt(xcountgen1[i]) });
                    }
                }
            }
           var chart = AmCharts.makeChart("graph", {
	"type": "serial",
     "theme": "none",
	"categoryField": "branch",
	"startDuration": 1,
	"categoryAxis": {
		"gridPosition": "start",
		"position": "left"
	},
	"trendLines": [],
	"graphs": [
		{
			"balloonText": "Joiningcount:[[value]]",
			"fillAlphas": 0.8,
			"id": "AmGraph-1",
			"lineAlpha": 0.2,
			"title": "Income",
			"type": "column",
			"valueField": "Joiningcount"
		},
		{
			"balloonText": "Relievingcount:[[value]]",
			"fillAlphas": 0.8,
			"id": "AmGraph-2",
			"lineAlpha": 0.2,
			"title": "Expenses",
			"type": "column",
			"valueField": "Relievingcount"
		}
	],
	"guides": [],
	"valueAxes": [
		{
			"id": "ValueAxis-1",
			"position": "top",
			"axisAlpha": 0
		}
	],
	"allLabels": [],
	"balloon": {},
	"titles": [],
	dataProvider: myData,
    "export": {
    	"enabled": true
     }

});
//            var myChart = new JSChart('graph', 'bar');
//            myChart.setDataArray(myData);
//            myChart.setTitle('Employee Joining and Reliveing Count');
//            myChart.setTitleColor('#8E8E8E');
//            myChart.setAxisNameX('');
//            myChart.setAxisNameY('');
//            myChart.setAxisNameFontSize(16);
//            myChart.setAxisNameColor('#999');
//            myChart.setAxisValuesAngle(30);
//            myChart.setAxisValuesColor('#777');
//            myChart.setAxisColor('#B5B5B5');
//            myChart.setAxisWidth(1);
//            myChart.setBarValuesColor('#2F6D99');
//            myChart.setAxisPaddingTop(60);
//            myChart.setAxisPaddingBottom(60);
//            myChart.setAxisPaddingLeft(45);
//            myChart.setTitleFontSize(11);
//            myChart.setBarColor('#02ef79', 1);
//            myChart.setBarColor('#ef0202', 2);
//            myChart.setBarBorderWidth(0);
//            myChart.setBarSpacingRatio(50);
//            myChart.setBarOpacity(0.9);
//            myChart.setFlagRadius(6);
//            myChart.setLegendShow(true);
//            myChart.setLegendPosition('right top');
//            myChart.setLegendForBar(1, 'Joiningcount');
//            myChart.setLegendForBar(2, 'Relievingcount');
//            myChart.setSize(500, 321);
//            myChart.setGridColor('#C6C6C6');
//            myChart.draw();

        }

        function Getemployeetypewisedetails() {
            var type = "Employee Type";
            var ChartType ="All Location";
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employeetypePieChartValues', 'type': type,'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        createemployeetypebarChart(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
         var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
        function createemployeetypebarChart(databind) {
            var xbranchname = databind[0].branchname;
            var xcountgen = databind[0].countgen;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchname;
                    xcountgen = databind[0].countgen;
                    color = ["#ff8000", "#ffff00", "#bfff00", "#40ff00", "#00ffbf", "#00bfff", "#4000ff", "#00ffff", "#0D52D1", "#8A0CCF", "#CD0D74", "#754DEB", "#DDDDDD", "#999999", "#333333", "#000000"];
                    for (var i = 0; i < xbranchname.length; i++) {
                        //                        myData.push([xbranchname[i].toString(), parseInt(xcountgen[i])]);
                        myData.push({ "emptype": xbranchname[i].toString(), "count": parseInt(xcountgen[i]), "color": color[i] });

                    }
                }
            }
            var chart = AmCharts.makeChart("divChart3", {
                "type": "serial",
                "theme": "light",
                "marginRight": 70,
                "rotate": true,
                dataProvider: myData,
                "valueAxes": [{
                    "axisAlpha": 0,
                    "position": "left",
                    "title": "Employees By Status"
                }],
                "startDuration": 1,
                "graphs": [{
                    "balloonText": "<b>[[category]]: [[value]]</b>",
                    "fillColorsField": "color",
                    "fillAlphas": 0.9,
                    "lineAlpha": 0.2,
                    "type": "column",
                    "valueField": "count"
                }],
                "chartCursor": {
                    "categoryBalloonEnabled": false,
                    "cursorAlpha": 0,
                    "zoomable": false
                },
                "categoryField": "emptype",

                "categoryAxis": {
                    "gridPosition": "start",
                   
                },
                "export": {
                    "enabled": true
                }

            });
//            var myChart = new JSChart('divChart3', 'bar');
//            myChart.setDataArray(myData);
//    myChart.setSize(500, 300);
//	myChart.setBarValues(false);
//	myChart.setBarSpacingRatio(45);
//	myChart.setBarOpacity(0.8);
//	myChart.setBarBorderWidth(0);
//	myChart.setTitle('Employees By Status');
//	myChart.setTitleFontSize(10);
//	myChart.setTitleColor('#2D6B96');
//	myChart.setAxisValuesColor('#2D6B96');
//	myChart.setAxisNameX('', );
//	myChart.setAxisNameY('%', );
//	myChart.setAxisColor('#B5B5B5');
//	myChart.setAxisNameColor('#2D6B96');
//	myChart.setGridOpacity(0.8);
//	myChart.setGridColor('#B5B5B5');
//	myChart.setIntervalEndY(50);
//	myChart.setAxisReversed(true);
//	myChart.draw();

        }

         function Getdepartemntandbranchwisesalary() {
            var data = { 'op': 'Getdepartemntandbranchwisesalary' };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        fillsalarydetails(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsalarydetails(msg) {
            var netpay = 0;
            var values = [];
            var emptytable4 = [];
             values = msg[0].EmployeDetalis;
             var distinctMap = {};
            for (var i = 0; i < values.length; i++) {
                var value = values[i].department;
                distinctMap[value] = '';
            };
            var unique_values = [];
            unique_values = Object.keys(distinctMap);
            unique_values.sort(function (a, b) { return a - b });
            var department = [];
            for (var i = 0; i < unique_values.length; i++) {
                department.push([(unique_values[i])]);
            }
            var m = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr>';
            results += '<th scope="col">Sno</th><th scope="col">Branchname</th>';
            for (var i = 0; i < department.length; i++) {
                results += '<th id="header" scope="col">' + department[i] + '</th>';
            }
            results += '</tr></thead></tbody>';
            for (var i = 0; i < values.length; i++) {
                values.sort(function (a, b) {
                    return a.department - b.department;
                });
                results += '<tr>';
                var branchname = values[i].branchname
                var x = values[i].department;
                if (emptytable4.indexOf(branchname) == -1) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + m++ + '</td>';
                    results += '<td data-title="brandstatus" >' + values[i].branchname + '</td>';
                    emptytable4.push(branchname);
                    for (var k = 0; k < values.length; k++) {
                        var x1 = values[i].department;
                        var x2 = department[i];
                        var netpay = values[k].netpay;
                        var netpay1 = 0;
                        if (branchname == values[k].branchname && x1 == values[i].department) {
                            if (branchname != "" && x1 != "") {
                                results += '<td data-title="brandstatus1" >' + values[k].Netpay + '</td>';
                            }
                        }
//                        
                        
                    }

                }
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divnetpay").html(results);
        }
         function Getbranchwisesalary() {
            var data = { 'op': 'Getbranchwisesalaryandemployeecount' };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        fillsalaryempcountdetails(msg);
                        createemployeesalarybarChart(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillsalaryempcountdetails(msg){
        var totalcount=[];
        var salarydetails=[];
         var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            totalcount = msg[0].Employecount;
            salarydetails = msg[0].EmployeDetalis;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;"><th scope="col" ></th><th scope="col" >BRANCH NAME</th><th scope="col">NET PAY</th><th scope="col">Total Employes</th></tr></thead></tbody>';
            for (var k = 0; k < salarydetails.length; k++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td></td>';
                    results += '<th scope="row"  class="1">' + salarydetails[k].branchname + '</th>';
                    results += '<td  class="3">' + salarydetails[k].Netpay + '</td>';
                    results += '<td class="2">' + totalcount[k].employeecount + '</td>';
                    results += '</tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            //}
            results += '</table></div>';
            $("#divtbldata").html(results);
        }
         var datainXSeries = 0;
        var datainYSeries = 0;
        var newXarray = [];
        var newYarray = [];
//        function createemployeesalarybarChart(databind) {
//         salarydetails = databind[0].branchnamecount;
//            var xbranchname = databind[0].branchnamecount;
//            var xcountgen = databind[0].countgen;
//            var newYarray = [];
//            var newXarray = [];
//            var myData = [];
//            if (databind.length > 0) {
//                for (var k = 0; k < databind.length; k++) {
//                    var BranchName = [];
//                    xbranchname = databind[0].branchnamecount;
//                    xcountgen = databind[0].countgen;
//                    for (var i = 0; i < xbranchname.length; i++) {
//                        myData.push([xbranchname[i].toString(), parseInt(xcountgen[i])]);
//                    }
//                }
//            }
//            var myChart = new JSChart('divChart4', 'line');
//            myChart.setDataArray(myData);
//    myChart.setSize(500, 300);
//	myChart.setBarValues(false);
//	myChart.setBarSpacingRatio(45);
//	myChart.setBarOpacity(0.8);
//	myChart.setBarBorderWidth(0);
//	myChart.setTitle('SALARY MASTER By Location');
//	myChart.setTitleFontSize(10);
//	myChart.setTitleColor('#2D6B96');
//	myChart.setAxisValuesColor('#2D6B96');
//	myChart.setAxisNameX('', );
//	myChart.setAxisNameY('%', );
//	myChart.setAxisColor('#B5B5B5');
//	myChart.setAxisNameColor('#2D6B96');
//	myChart.setGridOpacity(0.8);
//	myChart.setGridColor('#B5B5B5');
//	myChart.setIntervalEndY(50);
//	myChart.setAxisReversed(true);
//	myChart.draw();

//        }
        // 
         function createemployeesalarybarChart(databind) {
               var chart;

          var xbranchname = databind[0].branchnamecount;
            var xcountgen = databind[0].countgen;
            var newYarray = [];
            var newXarray = [];
            var myData = [];
            if (databind.length > 0) {
                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    xbranchname = databind[0].branchnamecount;
                    xcountgen = databind[0].countgen;
                    color=["#FF0F00","#FF6600","#FF9E01","#FCD202","#F8FF01", "#F8FF01","#B0DE09", "#04D215","#0D8ECF","#40ff00","#00ff40"," #00ff80"," #00ffff"," #0080ff","#0D52D1", "#2A0CD0","#8A0CCF", "#CD0D74","#754DEB","#DDDDDD","#999999","#333333","#000000"];
                    for (var i = 0; i < xbranchname.length; i++) {
                        myData.push({"branch":xbranchname[i].toString(), "amount":parseInt(xcountgen[i]),"color":color[i]});
                    }
                }
            }

        var chart = AmCharts.makeChart("divChart4", {
                            type: "serial",
                 theme: "light",
                marginRight: 70,
                dataProvider: myData,
                categoryField: "branch",
                categoryAxis: {
                    labelRotation: 45,
                    gridPosition: "start"
                },
                    valueAxes: [{
                    axisAlpha: 0,
                    position: "left",
                    title: "Branch wise Netamount"
                }],
                startDuration: 1,
                graphs: [{
                    valueField: "amount",
                    colorField: "color",
                    type: "column",
                    lineAlpha: 0.2,
                    fillAlphas: 1
                }],
                chartCursor: {
                    cursorAlpha: 0,
                    zoomable: false,
                    categoryBalloonEnabled: false
                },
                "export": {
                    "enabled": true
                }

            });
}
</script>

    <style>
        #divChart4 {
  width: 100%;
  height: 500px;
}

.amcharts-export-menu-top-right {
  top: 10px;
  right: 0;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Activities <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-6">
                <!-- AREA CHART -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-tasks"></i>Employees By Status</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px;">
                              <div id="divChart3" style="height: 300px;"></div>
                        </div>
                    </div>
                </div>
                
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-joomla"></i>Age Distribution</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <!-- /.box-header -->
                        <div class="box-body no-padding" style="height: 300px; ">
                          <div id="divChart1" style="height: 320px; src="">
                    
                     </div>
                        </div>
                        <!-- /.box-body -->
                        <!-- /.box -->
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <!-- LINE CHART -->
                <div class="box box-danger">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-birthday-cake"></i>Additions & Attrition

                        </h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                            <div id="graph" style="height: 300px;"></div>
                        </div>
                    </div>
                </div>
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-user"></i>Gender Distribution - Current Employees</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                           <div id="divChart" style="height: 300px; ">
                         </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
       <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-joomla"></i>SALARY BY BRANCH</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <!-- /.box-header -->
                        <div class="box-body no-padding" style="height: 300px; ">
                          <div id="divChart4" style="width: 100%; height: 400px;"src="">
                    
                     </div>
                        </div>
                        <!-- /.box-body -->
                        <!-- /.box -->
                    </div>
                </div>
                <!-- LINE CHART -->
                <div class="box box-danger" style="width:100%">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-fw fa-birthday-cake"></i>SALARY MASTER By Location & Department

                        </h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px; ">
                          <div id="divnetpay" style="height: 300px;  overflow-y: scroll;overflow-x: scroll;">
                          </div>
                        </div>
                    </div>
                </div>
                 
                <div class="row">
                <div class="col-md-6">
                <!-- AREA CHART -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-tasks"></i>SALARY BY BRANCH</h3>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="box-body no-padding" style="height: 300px;">
                              <div id="divtbldata" style="height: 300px; overflow-y: scroll;overflow-x: scroll;""></div>
                        </div>
                    </div>
                </div>
                
                
            </div>
                </div>
    </section>
</asp:Content>

