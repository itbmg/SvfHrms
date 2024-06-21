<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="piesalarychat.aspx.cs" Inherits="piesalarychat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Pie Chart<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-pie-chart"></i>Chart Reports</a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Totaly Salary Performance Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                        <tr>
                         <td>
                                <span>Chart Type</span>
                                <select id="slct_type" class="form-control" onchange="ddlTypeChange(this);">
                                    <option>Select Type</option>
                                     <option>Pie Chart</option>
                                    <option>Line Chart</option>
                                </select>
                            </td>
                             <td style="width: 6px;">
                            </td>
                            <td>
                                <span>Type</span>
                                <select id="ddlChartType" class="form-control" onchange="ddlTypeChange(this);">
                                    <option>Select Type</option>
                                     <option>All Location</option>
                                    <option>Location Wise</option>
                                    <option>Department Wise</option>
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <span id="bname">Branch Name</span>
                                <select id="Slect_Name" class="form-control">
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                             <td style="width: 90px; height: 50px;">
                                <span>Month</span>
                                <%--<input type="date" id="txtFromdate" class="form-control" />--%>
                             <select name="month" id="selct_month" onchange="" class="form-control" size="1">
                            <option value="1">Month</option>
                            <option value="3">Last 3 Months</option>
                            <option value="6">Last 6 Months</option>
                        </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                          <%--  <td style="width: 90px; height: 50px;">
                                <span>To Date</span>
                                <input type="date" id="txtTodate" class="form-control" />
                            </td>--%>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="Getnetpaymonthlyvalues()" />
                            </td>
                        </tr>
                    </table>
                </div>
                  <div id="divnetpay" >
                </div>
                <p style="display:none" id="header"></p>
                 <div id="divChart" style="width:1000px; height:500px;">
                </div>
            </div>

    <script type="text/javascript">
        function ddlTypeChange() {
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                $("#bname").css("display", "none");
                $("#Slect_Name").css("display", "none");
                // get_Branch_details();
            }
            if (ChartType == "Location Wise") {
                $("#bname").css("display", "block");
                $("#Slect_Name").css("display", "block");
                get_Branch_details();
            }
            if (ChartType == "Department Wise") {
                $("#bname").css("display", "block");
                $("#Slect_Name").css("display", "block");
                get_Branch_details();
            }
        }

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



        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                        
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch(msg) {
            var data = document.getElementById('Slect_Name');
            var length = data.options.length;
            document.getElementById('Slect_Name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branchname";
            //opt.value = "Select Branchname";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
        function get_Dept_details() {
            var data = { 'op': 'get_Dept_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldepdetails(msg);
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
        function filldepdetails(msg) {
            var data = document.getElementById('Slect_Name');
            var length = data.options.length;
            document.getElementById('Slect_Name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Department";
            opt.value = "Select deptid";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Department != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Department;
                    option.value = msg[i].Deptid;
                    data.appendChild(option);
                }
            }
        }
       
        function Getnetpaymonthlyvalues() {
            var name = "";
            var tmonth = "";
            var type = document.getElementById('slct_type').value;
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
            }
            name = document.getElementById('Slect_Name').value;

            if (ChartType == "Location Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name ") {
                    alert("Please Select name ");
                    return false;
                }
            }
            if (ChartType == "Department Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name") {
                    alert("Please Select  Name");
                    return false;
                }
            }
//            var now = new Date();
//            var sixMonthsFromNow = new Date(now.setMonth(now.getMonth() - 3));
//            var sortByQueryString = '&fq=lastmodified:[' + sixMonthsFromNow.toISOString() + '+TO+NOW]';
//            var now = new Date();
//            var sixMonthsFromNow = new Date(now.setMonth(now.getMonth() - 6));
//            var sortByQueryString ='&fq=lastmodified:[' + sixMonthsFromNow.toISOString() + '+TO+NOW]';

            var month = document.getElementById('selct_month').value;
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'GetNetPaymonthlyValues', 'type': type, 'name': name, 'month': month, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        filldetails(msg);
                        GetNetpaychartvalues(msg);
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

        function filldetails(msg) {
            var netpay = 0;
            var values = [];
            var emptytable4 = [];
            values = msg[0].EmployeDetalis;
            var distinctMap = {};
            for (var i = 0; i < values.length; i++) {
                var value = values[i].month;
                distinctMap[value] = '';
            };
            var unique_values = [];
            unique_values = Object.keys(distinctMap);
            unique_values.sort(function (a, b) { return a - b });
            document.getElementById("header").innerHTML = unique_values;
            var nmonth = [];
            for (var i = 0; i < unique_values.length; i++) {
                var month = new Array();
                var months = ["","January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December"];
                nmonth.push(months[(parseInt(unique_values[i]))]);
            }
            var m = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr>';
            results += '<th scope="col">Sno</th><th scope="col">Branchname</th>';
            for (var i = 0; i < nmonth.length; i++) {
                results += '<th id="header" scope="col">' + nmonth[i] + '</th>';
            }
            results += '</tr></thead></tbody>';
            for (var i = 0; i < values.length; i++) {
                values.sort(function (a, b) {
                    return a.month - b.month;
                });
                results += '<tr>';
                var branchname = values[i].branchname
                var x = values[i].month;
                if (emptytable4.indexOf(branchname) == -1) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + m++ + '</td>';
                    results += '<td data-title="brandstatus" >' + values[i].branchname + '</td>';
                    emptytable4.push(branchname);
                    for (var k = 0; k < values.length; k++) {
                        var x1 = values[i].month;
                        var x2 = nmonth[i];
                        var netpay = values[k].netpay;
                        var netpay1 = 0;
                        if (branchname == values[k].branchname && x1 == values[i].month) {
                            if (branchname != "" && x1 != "") {
                                results += '<td data-title="brandstatus1" >' + values[k].netpay + '</td>';
                            }
                            else {
                                results += '<td data-title="brandstatus1" >' + values[k].netpay1 + '</td>';
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
        var values1 = [];
        function GetNetpaychartvalues() {
            var name = "";
            var tmonth = "";
            var type = document.getElementById('slct_type').value;
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
            }
            name = document.getElementById('Slect_Name').value;

            if (ChartType == "Location Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name ") {
                    alert("Please Select name ");
                    return false;
                }
            }
            if (ChartType == "Department Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name") {
                    alert("Please Select  Name");
                    return false;
                }
            }
            var month = document.getElementById('selct_month').value;
            $('#divHide').css('display', 'block');
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'GetPieChartValues', 'type': type, 'name': name, 'month': month, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        LineChartforVehicleMileage(msg);
                        values1 =msg[0].EmployeDetalis;
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

        function LineChartforVehicleMileage(databind) {
            var datainXSeries = 0;
            var datainYSeries = 0;
            var newXarray = [];
            var newYarray = [];
            var textname = "";
            var type = document.getElementById('slct_type').value;
            if (type == "Pie Chart") {
                var ChartType = document.getElementById('ddlChartType').value;
                if (ChartType == "All Location") {
                    var agent = document.getElementById("Slect_Name");
                }
                if (ChartType == "Department Wise") {
                    var agent = document.getElementById("Slect_Name");
                }
                var netpay = databind[0].netpay;
                var branchname = databind[0].branchname;
//                var month = databind[0].month;
                for (var i = 0; i < branchname.length; i++) {
                    newXarray.push({ "category": branchname[i], "value": parseFloat(netpay[i])});
                }
                $("#divChart").kendoChart({
                    title: {
                        position: "bottom",
                        text: textname,
                        color: "#006600",
                        font: "bold italic 18px Arial,Helvetica,sans-serif"
                    },
                    legend: {
                        visible: false
                    },
                    chartArea: {
                        background: ""
                    },
                    seriesDefaults: {
                        labels: {
                            visible: true,
                            background: "transparent",
                            template: "#= category #: #= value#"
                        }
                    },
                    dataSource: {
                        data: newXarray
                    },
                    series: [{
                        type: "pie",
                        field: "value",
                        categoryField: "category"
                    }],
                    seriesColors: ["#3275a8", "#267ed4", "#068c35", "#808080", "#FFA500", "#A52A2A", "#FF7F50", "#00FF00", "#808000", "#0041C2", "#800517", "#1C1715"],
                    tooltip: {
                        visible: true,
                        format: "{0}%"
                    }
                });
            }
            else if (type == "Line Chart") {
                var ChartType = document.getElementById('ddlChartType').value;
                if (ChartType == "Loaction Wise") {
                    for (l = 0; l < veh_data.length; l++) {
                        if (veh_data[l].vm_sno == sel) {
                            name = veh_data[l].registration_no + "-" + veh_data[l].VehMake + "-" + veh_data[l].VehType + "-" + veh_data[l].Capacity;
                        }
                    }
                }
                if (ChartType == "Department Wise") {
                    var driver = document.getElementById("Slect_Name");
                    name = driver.options[driver.selectedIndex].text;
                }

                for (var k = 0; k < databind.length; k++) {
                    var BranchName = [];
                    var xvaluestr = databind[k].xvaluestr;
                    var yvaluestr = databind[k].yvaluestr;
                    var Status = databind[k].Status;
                    newXarray = xvaluestr.split(',');
                    newYarray.push({ 'data': yvaluestr.split(','), 'name': Status });
                }
                $("#divChart").kendoChart({
                    title: {
                        position: "left",
                        text: document.getElementById('ddlChartType').value + "  Mileage " + name,
                        color: "#006600",
                        font: "bold italic 20px Arial,Helvetica,sans-serif"
                    },
                    legend: {
                        visible: false
                    },

                    seriesDefaults: {
                        type: "line",
                        style: "smooth",
                        width: 90
                    },
                    series: newYarray,
                    valueAxis: {
                        line: {
                            visible: false
                        },
                        minorGridLines: {
                            visible: true
                        }
                    },
                    categoryAxis: {
                        categories: newXarray,
                        majorGridLines: {
                            visible: false
                        },
                        labels: {
                            rotation: 65
                        }
                    },
                    seriesColors: ["#FF00FF", "#0041C2", "#800517"],
                    tooltip: {
                        visible: true,
                        template: "#= series.name #: #= value "
                    }
                });
            }
        }
    </script>
        </div>
    </section>
</asp:Content>
