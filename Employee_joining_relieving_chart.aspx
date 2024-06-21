<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="Employee_joining_relieving_chart.aspx.cs" Inherits="Employee_joining_relieving_chart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Totaly Employee Joining&Relieving Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                        <tr>
                         <td>
                                <span>Type</span>
                            </td>
                            <td >
                                <select id="slct_type" class="form-control" onchange="ddlTypeChange(this);">
                                    <option>Select Type</option>
                                     <option>Joinnig Count</option>
                                    <option>Relieving Count</option>
                                </select>
                            </td>
                            <td>
                                <span>Chart Type</span>
                            </td>
                            <td >
                                <select id="ddlChartType" class="form-control" onchange="ddlTypeChange(this);">
                                    <option>Select Type</option>
                                     <option>All Location</option>
                                    <option>Location Wise</option>
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <span id="bname">Branch Name</span>
                            </td>
                            <td>
                                <select id="Slect_Name" class="form-control">
                                </select>
                            </td>
                           <td>
                             <label>
                             Month
                             </label>
                             <select  id="ddlmonth">
                                 <option value="00">Select Month</option>
                                 <option value="01">January</option>
                                 <option value="02">February</option>
                                 <option value="03">March</option>
                                 <option value="04">April</option>
                                 <option value="05">May</option>
                                 <option value="06">June</option>
                                 <option value="07">July</option>
                                 <option value="08">August</option>
                                 <option value="09">September</option>
                                 <option value="10">October</option>
                                 <option value="11">November</option>
                                 <option value="12">December</option>
                             </select>

                                        </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 90px; height: 50px;">
                                <span> Year</span>
                              <select  id="year1"></select>
                            </td>
                            <td>
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="GetVehicleWisePerformanceclick()" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divChart" align="center" style="height: 500px;">
                </div>
            </div>
    
    <script type="text/javascript">
        $(document).ready(function () {

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
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#ddlmonth').val(mm);
//            $('#year1').val(yyyy);
               var myselect = document.getElementById('year1'), year = new Date().getFullYear();
                var gen = function (max) { do { myselect.add(new Option(year++, max--), null); } while (max > 0); } ();
                        var year = 1980;
                        var min = new Date().getFullYear(),
                        max = min + 9
                        for (i = 0; i < 100; i++) {
                            $("#year1").get(0).options[$("#year1").get(0).options.length] = new Option(year, year);
                            year = year + 1;
                        }
                        $('#year1').val(yyyy);
            get_Branch_details();
        });
        function ddlTypeChange() {
            var type = document.getElementById('slct_type').value;
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                $("#bname").css("display", "none");
                $("#Slect_Name").css("display", "none");
                //get_Branch_details();
            }
            if (ChartType == "Location Wise") {
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
                        //fillbranchname(msg);
                        //fillempcode(msg);
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
        
        function GetVehicleWisePerformanceclick() {
            var name = "";
            var tmonth = "";
            var type = document.getElementById('slct_type').value;
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                name = document.getElementById('Slect_Name').value;
                
            }
            
            if (ChartType == "Location Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name ") {
                    alert("Please Select name ");
                    return false;
                }
            }
            Month = document.getElementById('ddlmonth').value;
            if (Month == "Select Month") {
             
                    alert("Please Select name ");
                    return false;

                }
                Year = document.getElementById('year1').value;
            if (Year == "") {
                    alert("Please Select name ");
                    return false;
                }
            var salarywiseLinechart = "salarywiseLinechart";
            var data = { 'op': 'employee_relieving_joingcount_PieChartValues', 'type':type,'Month': Month, 'Year': Year, 'name': name, 'ChartType': ChartType, 'FormName': salarywiseLinechart };
            var s = function (msg) {
                if (msg == "No data Found") {
                    $('#divChart').css('display', 'none');
                }
                else if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        LineChartforVehicleMileage(msg);
                        $('#divChart').css('display', 'block');
                        $('#divHide').css('display', 'block');
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
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "All Location") {
                var agent = document.getElementById("Slect_Name");
                //                var branchname = agent.options[agent.selectedIndex].text;
                //                textname = branchname + " Amount Collections ";
            }

            if (ChartType == "Location Wise") {
                var agent = document.getElementById("Slect_Name");
                //                var branchname = agent.options[agent.selectedIndex].text;
                //                textname = branchname + " Products ";
            }
            var countgen = databind[0].countgen;
            var branchname = databind[0].branchname;
            for (var i = 0; i < branchname.length; i++) {
                newXarray.push({ "category": branchname[i], "value": parseFloat(countgen[i]) });
            }

            $("#divChart").kendoChart({
                title: {
                    position: "bottom",
                    text: name,
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
    </script>
        </div>
    </section>
</asp:Content>

