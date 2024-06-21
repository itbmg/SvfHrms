<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="PFLineChart.aspx.cs" Inherits="PFLineChart" %>

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
            PF wise Chart<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Reports</a></li>
            <li><a href="#">PF wise Chart</a></li>
        </ol>
    </section>
     <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>PF wise Performance Details
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
                                <select id="ddl_type" class="form-control">
                                    <option>Select Type</option>
                                    <option value="ALL">ALL</option>
                                    <option value="PF">PF</option>
                                    <option value="NONPF">NONPF</option>
                                </select>
                            </td>
                            <td style="width: 6px;">
                            </td>
                              <td>
                                <span>Type</span>
                            </td>
                            <td >
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
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="PFwiselinechartclick()" />
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
            if (ChartType == "All Location") {
                $("#bname").css("display", "none");
                $("#Slect_Name").css("display", "none");
            }
            if (ChartType == "Location Wise") {
                $("#bname").css("display", "none");
                $("#Slect_Name").css("display", "none");
                get_Branch_details();
            }
            if (ChartType == "Department Wise") {
                $("#bname").css("display", "none");
                $("#Slect_Name").css("display", "none");
                get_Dept_details();
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
        function PFwiselinechartclick() {
            var name = "";
            var ChartType = document.getElementById('ddlChartType').value;
            var Type = document.getElementById('ddl_type').value;
            $('#divHide').css('display', 'block');
            var Linechartsalary = "Linechartsalary";
            var data = { 'op': 'PFwiselinechartclick', 'name': name, 'ChartType': ChartType, 'FormName': Linechartsalary, 'Type': Type };
            var s = function (msg) {
                if (msg) {
                    if (msg == "Time Out Expired") {
                        alert(msg);
                        return false;
                    }
                    else {
                        LineChartforPFdetails(msg);
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
        function LineChartforPFdetails(databind) {
            var datainXSeries = 0;
            var datainYSeries = 0;
            var newXarray = [];
            var newYarray = [];
            var name = "";
            var ChartType = document.getElementById('ddlChartType').value;
            if (ChartType == "Loaction Wise") {
                for (l = 0; l < veh_data.length; l++) {
                    if (veh_data[l].vm_sno == sel) {
                        name = veh_data[l].registration_no + "-" + veh_data[l].VehMake + "-" + veh_data[l].VehType + "-" + veh_data[l].Capacity;
                    }
                }
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
                    text: document.getElementById('ddlChartType').value + "  PFdetails " + name,
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
