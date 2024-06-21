<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="AgewiseLinechart.aspx.cs" Inherits="AgewiseLinechart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="Kendo/jquery.min.js" type="text/javascript"></script>
    <script src="Kendo/kendo.all.min.js" type="text/javascript"></script>
    <link href="Kendo/kendo.common.min.css" rel="stylesheet" type="text/css" />
    <link href="Kendo/kendo.default.min.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery.blockUI.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<section class="content-header">
        <h1>
            Age wise Chart<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Reports</a></li>
            <li><a href="#">Age wise Chart</a></li>
        </ol>
    </section>
     <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Age wise Performance Details
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;" align="center">
                    <table>
                        <tr>
                            <td>
                                <span>Chart Type</span>
                            </td>
                            <td >
                                <select id="ddlChartType" class="form-control" onchange="ddlTypeChange(this);">
                                    <option>Select Type</option>
                                     <option> All Location</option>
                                    <option>Location Wise</option>
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <span>Branch Name</span>
                            </td>
                            <td>
                                <select id="Slect_Name" class="form-control">
                                </select>
                            </td>
                           <%-- <td style="width: 6px;">
                            </td>
                            <td>
                                <span>From Month</span>
                            </td>
                            <td >
                               <select id="ddl_Frommonth" class="form-control">
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
                            <td>
                                <span>To Month</span>
                            </td>
                            <td >
                                <select id="ddl_Tomonth" class="form-control">
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
                            </td>--%>
                            <td>
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="Agewiselinechartclick()" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divChart" style="height: 700px;">
                </div>
            </div>

    <script type="text/javascript">
        function ddlTypeChange() {
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "Location Wise") {
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
//        function get_Dept_details() {
//            var data = { 'op': 'get_Dept_details' };
//            var s = function (msg) {
//                if (msg) {
//                    if (msg.length > 0) {
//                        filldepdetails(msg);
//                    }
//                }
//                else {
//                }
//            };
//            var e = function (x, h, e) {
//            };
//            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//            callHandler(data, s, e);
//        }
//        function filldepdetails(msg) {
//            var data = document.getElementById('Slect_Name');
//            var length = data.options.length;
//            document.getElementById('Slect_Name').options.length = null;
//            var opt = document.createElement('option');
//            opt.innerHTML = "Select Department";
//            opt.value = "Select deptid";
//            opt.setAttribute("selected", "selected");
//            opt.setAttribute("disabled", "disabled");
//            opt.setAttribute("class", "dispalynone");
//            data.appendChild(opt);
//            for (var i = 0; i < msg.length; i++) {
//                if (msg[i].Department != null) {
//                    var option = document.createElement('option');
//                    option.innerHTML = msg[i].Department;
//                    option.value = msg[i].Deptid;
//                    data.appendChild(option);
//                }
//            }
//        }
        //        function bindvehiclemake(msg) {
        //            var data = document.getElementById('slct_vehicle_no');
        //            var length = data.options.length;
        //            document.getElementById('slct_vehicle_no').options.length = null;
        //            var opt = document.createElement('option');
        //            opt.innerHTML = "Select Make";
        //            opt.value = "Select Make";
        //            opt.setAttribute("selected", "selected");
        //            opt.setAttribute("disabled", "disabled");
        //            opt.setAttribute("class", "dispalynone");
        //            data.appendChild(opt);
        //            for (var i = 0; i < msg.length; i++) {
        //                if (msg[i].make != null) {
        //                    var option = document.createElement('option');
        //                    option.innerHTML = msg[i].make;
        //                    option.value = msg[i].sno;
        //                    data.appendChild(option);
        //                }
        //            }
        //        }
        function Agewiselinechartclick() {
            var name = "";
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "Location Wise") {
                name = document.getElementById('Slect_Name').value;
                if (name == "" || name == "Select name ") {
                    alert("Please Select name ");
                    return false;
                }
            }
//            if (ChartType == "Department Wise") {
//                name = document.getElementById('Slect_Name').value;
//                if (name == "" || name == "Select name") {
//                    alert("Please Select  Name");
//                    return false;
//                }
//            }

//            var frommonth = document.getElementById('ddl_Frommonth').value;
//            if (frommonth == "") {
//                alert("Please Select From Date");
//                return false;
//            }
//            var tomonth = document.getElementById('ddl_Tomonth').value;
//            if (tomonth == "") {
//                alert("Please Select To date");
//                return false;
//            }
            $('#divHide').css('display', 'block');
            var Linechartsalary = "Linechartsalary";
            var data = { 'op': 'Agewiselinechartclick', 'name': name,  'ChartType': ChartType, 'FormName': Linechartsalary };
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
        function LineChartforVehicleMileage(databind) {
            var datainXSeries = 0;
            var datainYSeries = 0;
            var newXarray = [];
            var newYarray = [];
            var sel = document.getElementById("Slect_Name").value;
            var name = "";
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
                //                for (var i = 0; i < yvaluestr.length; i++) {
                //                  
                //                }
            }
            $("#divChart").kendoChart({
                title: {
                    position: "left",
                    text: document.getElementById('ddlChartType').value + "  Mileage " ,
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
                    template: "#= series.name #: #= value #"
                }
            });
        }
    </script>
        </div>
    </section>
</asp:Content>

