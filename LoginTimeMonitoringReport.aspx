<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="LoginTimeMonitoringReport.aspx.cs" Inherits="LoginTimeMonitoringReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     $(function () {
         get_login_sys();
         var date = new Date();
         var day = date.getDate();
         var month = date.getMonth() + 1;
         var year = date.getFullYear();
//         var hours = date.getHours();
//         var minute = date.getMinutes();
         if (month < 10) month = "0" + month;
         if (day < 10) day = "0" + day;
         today = year + "-" + month + "-" + day;
         $('#dt_frmdt').val(today);
         $('#dt_todate').val(today);
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
        function get_login_sys() {
            var data = { 'op': 'get_login_sys' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillsystemdetails(msg);
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
        function fillsystemdetails(msg) {
            var data = document.getElementById('slct_sysname');
            var length = data.options.length;
            document.getElementById('slct_sysname').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
            //            opt.setAttribute("disabled", "disabled");
            //            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].sysname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].sysname;
                    option.value = msg[i].sysname;
                    data.appendChild(option);
                }
            }
        }
        function get_logintime_monitor() {
            var sysname = document.getElementById('slct_sysname').value;
            var fromdate = document.getElementById('dt_frmdt').value;
            var todate= document.getElementById('dt_todate').value;
            var data = { 'op': 'get_logintime_monitor' ,'sysname':sysname,'fromdate':fromdate,'todate':todate};
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillloginsystemdetails(msg);
                        document.getElementById('lblTitle').innerHTML = msg[0].title;
                        document.getElementById('lblAddress').innerHTML = msg[0].address;
                        document.getElementById('lblHeading').innerHTML = "Login Time Monitoring Report";
                        $('#divPrint').css('display', 'block');
                        $('#printbtn').css('display', 'block');
                        $('#div_loginmonitor').css('display', 'block');
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
        function fillloginsystemdetails(msg) {
//            document.getElementById('lblTitle').innerHTML = msg[0].title;
//            document.getElementById('lblAddress').innerHTML = msg[0].address;
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + msg[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + msg[0].address + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">'+" Login Time Monitoring Report "+ '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Date</th><th scope="col">Time</th><th scope="col">SystemName</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<th scope="row" class="1">' + msg[i].date + '</th>';
                results += '<th scope="row" class="2">' + msg[i].logintime + '</th>';
                results += '<td  class="8">' + msg[i].sysname + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_loginmonitor").html(results);
        }
        </script>
         <script type="text/javascript">
             function CallPrint(strid) {
                 var divToPrint = document.getElementById(strid);
                 var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
                 newWin.document.open();
                 newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
                 newWin.document.close();
             }

             var tableToExcel = (function () {
                 var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
                 return function (table, name) {
                     if (!table.nodeType) table = document.getElementById(table)
                     var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
                     window.location.href = uri + base64(format(template, ctx))
                 }
             })()
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
        Login Time Monitoring<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">  Login Time Monitoring</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>  Login Time Monitoring
                </h3>
            </div>
            <div class="box-body">
             <div id="div_dup">
                   <div id='fillform' >
                      <table align="center">
                            <tr>
                            <td>
                                <td>
                                    <label>
                                       System Name</label>
                                </td>
                                <td style="height: 40px;">
                                    <select id="slct_sysname" class="form-control"></select>
                                   
                               </td>
                               </td>
                                <td>
                                <td>
                                    <label>
                                       From Date</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="dt_frmdt" class="form-control" type="date"></input>
                                   
                               </td>
                               </td>
                               <td>
                                  <td>
                                    <label>
                                       To Date</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="dt_todate" class="form-control" type="date"></input>
                               </td>
                               </td>
                               <td style="height:40px;"></td>
                               <td colspan="2" align="center" style="height:40px;">
                              <input id="btn_logintime" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="get_logintime_monitor()" />
                            </td> 
                             </tr>
                              <tr style="display:none;">
                              <td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                           </table>
        </div>
        </div>
    </div>
                            
                                   <div id="divPrint" style="display:none">
    <div align="center">
                                                <label id="lblTitle"  Font-Bold="true" Font-Size="20px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                <label id="lblAddress"  Font-Bold="true" Font-Size="12px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                 <label id="lblHeading"  Font-Bold="true" Font-Size="15px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                    <br />
                                                <%--<span style="font-size: 18px; font-weight: bold; color: #0252aa;">Bank  Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                             <div id ="div_loginmonitor" ></div>
                                   <br />
                                   
                                        <table style="width: 100%;">
                                                <tr>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Prepared By</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Audit By</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Accounts</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Authorized Signature</span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div align="center" id="printbtn" style="display:none">
                                        <table>
                                        <tr>
                                        <td>
                                         <button type="button" id="Button2" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                        <td>
                                        <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('div_loginmonitor', 'W3C Example Table')"
                                        value="Export to Excel" />
                                        </td>
                                        </tr>
                                        </table>
                                         </div>
                                         
</div>
    </section>


</asp:Content>

