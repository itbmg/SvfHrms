<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="AgewiseEmployeeCount.aspx.cs" Inherits="AgewiseEmployeeCount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <%--<script type="text/javascript">
     function CallPrint(strid) {
         var divToPrint = document.getElementById(strid);
         var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
         newWin.document.open();
         newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
         newWin.document.close();
     }
    </script>--%>
      <script type="text/javascript" src="js/jscharts.js"></script>
      <%--<script src="js/JSchart.js" type="text/javascript"></script>--%>
    <script type="text/javascript">
        $(function () {
//            get_Branch_details();
            get_CompanyMaster_details();
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
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        function exportfn() {
            window.location = "exporttoxl.aspx";
        }

        //------------>Prevent Backspace<--------------------//
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD'))
            || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                } else {
                    doPrevent = true;
                }
            }

            if (doPrevent) {
                event.preventDefault();
            }
        });
        function get_CompanyMaster_details() {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompany(msg);
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
        function fillcompany(msg) {
            var data = document.getElementById('selct_Cmpny');
            var length = data.options.length;
            document.getElementById('selct_Cmpny').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Company";
            opt.value = "Select Company";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].CompanyName != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].CompanyName;
                    option.value = msg[i].CompanyCode;
                    data.appendChild(option);
                }
            }
        }
        function branchnamechange() {
            var companyid = document.getElementById('selct_Cmpny').value;
            var data = { 'op': 'get_compaywisebranchname_fill', 'companyid': companyid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranchdetails1(msg);
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
//        function get_Branch_details() {
//            var data = { 'op': 'get_Branch_details' };
//            var s = function (msg) {
//                if (msg) {
//                    if (msg.length > 0) {
//                        fillbranchdetails1(msg)
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
        function fillbranchdetails1(msg) {
            var data = document.getElementById('ddlbrnch');
            var length = data.options.length;
            document.getElementById('ddlbrnch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
            //            opt.setAttribute("disabled", "disabled");
            //            opt.setAttribute("class", "dispalynone");
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
        function btnemployeeage_click() {
            var barnchname = document.getElementById("ddlbrnch").value;
            var campny = document.getElementById("selct_Cmpny").value;
            var data = { 'op': 'get_agewise_employee_details', 'campny': campny, 'barnchname': barnchname };
            var s = function (msg) {
                if (msg == "") {
                    alert("No Data Found");
                    $("#divemployeeaagedata").css('display', 'none');
                }
                else if (msg) {
                    if (msg.length > 0) {
                        fillagewiseemployeedetails(msg)
                        $("#divemployeeaagedata").css('display', 'block');
                        btnemployeeage_barchart(msg);
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
        function btnemployeeage_barchart() {
            var barnchname = document.getElementById("ddlbrnch").value;
            var campny = document.getElementById("selct_Cmpny").value;
            var data = { 'op': 'Agewiseemployeecount_barChartValues', 'campny': campny, 'barnchname': barnchname };
            var s = function (msg) {
                if (msg == "") {
                    alert("No Data Found");
                    $("#divemployeeaagedata").css('display', 'none');
                }
                else if (msg) {
                    if (msg.length > 0) {
                        createbarChart(msg)
                        $("#divemployeeaagedata").css('display', 'block');
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
        function fillagewiseemployeedetails(msg) {
            var k = 1;
            // var status = "A";
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th></th><th scope="col">AgeRange</th><th scope="col">EmployeeCount</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].AgeRange + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].employeecount + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }

            results += '</table></div>';
            $("#divemployeeaagedata").html(results);
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
                    for (var i = 0; i < xbranchname.length; i++) {
                        myData.push([xbranchname[i].toString(), parseInt(xcountgen[i])]);
                    }
                }
            }
            var myChart = new JSChart('divChart', 'bar');
            myChart.setDataArray(myData);
            myChart.setTitle('Age Wise Employee  Count');
            myChart.setTitleColor('#8E8E8E');
            myChart.setAxisNameX('');
            myChart.setAxisNameY('');
            myChart.setAxisNameFontSize(16);
            myChart.setAxisNameColor('#999');
            myChart.setAxisValuesAngle(30);
            myChart.setAxisValuesColor('#777');
            myChart.setAxisColor('#B5B5B5');
            myChart.setAxisWidth(1);
            myChart.setBarValuesColor('#2F6D99');
            myChart.setAxisPaddingTop(60);
            myChart.setAxisPaddingBottom(60);
            myChart.setAxisPaddingLeft(45);
            myChart.setTitleFontSize(11);
            myChart.setBarColor('#2D6B96', 1);
            myChart.setBarColor('#9CCEF0', 2);
            myChart.setBarBorderWidth(0);
            myChart.setBarSpacingRatio(50);
            myChart.setBarOpacity(0.9);
            myChart.setFlagRadius(6);
            //            myChart.setTooltip(['North America', 'Click me', 1], callback);
            //            myChart.setTooltipPosition('nw');
            //            myChart.setTooltipOffset(3);
            myChart.setLegendShow(true);
            myChart.setLegendPosition('right top');
            myChart.setLegendForBar(1, 'Agewisecount');
//            myChart.setLegendForBar(2, 'Relievingcount');
            myChart.setSize(616, 321);
            myChart.setGridColor('#C6C6C6');
            myChart.draw();


         
        }
         
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <section class="content-header">
        <h1>
           Age wise Employee Count Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Age wise Employee Count Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Age wise Employee Count Report
                </h3>
            </div>
            <div class="box-body">
                <div runat="server" id="d">
                    <table>
                        <tr>
                          <td>
                                <label>
                                    Company Name</label>
                            </td>
                            <td>
                                <select id="selct_Cmpny" class="form-control" onchange="branchnamechange()">
                                    <option selected disabled value="Select state">Select company</option>
                                </select>
                            </td>
                            <td style="height: 40px;">
                            Branch Name
                        </td>
                        <td>
                            <select id="ddlbrnch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch">Select Branch</option>
                            </select>
                        </td>
                            <td style="width: 5px;">
                            </td>
                           
                            <td>
                                <input id="btn_get" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnemployeeage_click()" />
                            </td>
                        </tr>
                    </table>
                    <table>
                    <tr>
                    <td>
                    <div id="divemployeeaagedata" >
                    </div>
                    </td>
                    <td>
                     <div style="top: -321px; position: absolute;">
                     <img width="77" height="19" alt="" src="Images/js1.png" style="border:0; height: auto;"/>
                     </div>
                     <div id="divChart" style="height: 500px;float:right;" src="">
                    
                     </div>
                     </td>
                     </tr>
                     </table>
                </div>
                <br />
                <br />
         
                <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </section>
</asp:Content>

