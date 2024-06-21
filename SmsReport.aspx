<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="SmsReport.aspx.cs" Inherits="SmsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_Date').val(today);
            $('#txt_fleetdate').val(today);
            $('#txt_procdate').val(today);
            $("#div_sales").css("display", "block");
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
        function sales_close() {
            $("#div_salesdiv").css("display", "block");
            $("#divsmsrepo").css("display", "block");
            $("#divsmsrepo2").css("display", "none");
            $("#div_smsrepo2").css("display", "none");
        }
        function fleet_close() {
            $("#divFleetSmsRepo").css("display", "block");
            $("#divFleetSmsRepo2").css("display", "none");
            $("#div_fleet_close").css("display", "none");
        }
        function procure_close() {
            $("#div_procurerepo").css("display", "block");
            $("#div_procurerepo2").css("display", "none");
            $("#div_Procure_close").css("display", "none");
        }
        function show_sales() {
            $("#div_sales").css("display", "block");
            $("#div_fleet").css("display", "none");
            $("#div_procure").css("display", "none");
        }

        function show_fleet() {
            $("#div_sales").css("display", "none");
            $("#div_fleet").css("display", "block");
            $("#div_procure").css("display", "none");
        }
        function show_procure() {
            $("#div_sales").css("display", "none");
            $("#div_fleet").css("display", "none");
            $("#div_procure").css("display", "block");
        }
         <%--//-------------Sales---------//--%>
        function generate_report() {
            $("#div_sales").css("display", "block");
            $("#divFleetSmsRepo_div").css("display", "block");
//            $("#div_procure").css("display", "none");
            $("#divsmsrepo").css("display", "block");
            $("#divsmsrepo2").css("display", "none");
//            $("#divFleetSmsRepo").css("display", "none");
//            $("#div_procurerepo").css("display", "none");
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'sms_report_details', 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        sms_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function sms_details(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" ></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Company Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viewsms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="3" style="text-align:  center;">' + msg[k].companyname + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td class="5" style="Display:  none;">' + msg[k].companyid + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divsmsrepo").html(results);
        }
        function viewsms_details(thisid) {
            $("#div_smsrepo2").css("display", "block");
            $("#div_close").css("display", "block");
            $("#divsmsrepo").css("display", "none");
            $("#divsmsrepo2").css("display", "block");
            var doe = document.getElementById('txt_Date').value;
            var companycode = $(thisid).parent().parent().children('.5').html();
            var data = { 'op': 'sms_reportbybranch_details', 'doe': doe, 'companycode': companycode };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        sms_branch_wise(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function sms_branch_wise(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Branch Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viewsms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="5" style="text-align:  center;">' + msg[k].BranchName + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td  class="5" style="text-align:  center; display:none">' + msg[k].companycode + '</td>';
                results += '<td  class="5" style="text-align:  center; display:none"">' + msg[k].branchid + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divsmsrepo2").html(results);
        }           
         <%--//-------------Fleet---------//--%>
        function generate_fleetreport() {
            $("#div_fleet").css("display", "block");
            $("#divFleetSmsRepo").css("display", "block");
            $("#divsmsrepo").css("display", "none");
            $("#divsmsrepo2").css("display", "block");
            var doe = document.getElementById('txt_fleetdate').value;
            var data = { 'op': 'sms_fleet_reportbybranch_details', 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fleet_sms_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fleet_sms_details(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" ></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Company Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viefleetwsms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="3" style="text-align:  center;">' + msg[k].companyname + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td class="5" style="Display:  none;">' + msg[k].companycode + '</td>';
                results += '<td class="6" style="Display:  none;">' + msg[k].branchid + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divFleetSmsRepo").html(results);
        }

        function viefleetwsms_details(thisid) {
            $("#divFleetSmsRepo").css("display", "none");
            $("#divFleetSmsRepo2").css("display", "block");
            $("#div_fleet_close").css("display", "block");
            var doe = document.getElementById('txt_fleetdate').value;
            var companycode = $(thisid).parent().parent().children('.5').html();
            var data = { 'op': 'fleetsms_reportbybranch_details', 'doe': doe, 'companycode': companycode };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fleet_sms_branch_wise(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fleet_sms_branch_wise(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Branch Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                //                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viewsms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="5" style="text-align:  center;">' + msg[k].BranchName + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td  class="5" style="text-align:  center; display:none">' + msg[k].companycode + '</td>';
                results += '<td  class="5" style="text-align:  center; display:none"">' + msg[k].branchid + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divFleetSmsRepo2").html(results);
        }
                 <%--//-------------Procurement---------//--%>
        function generate_procurereport() {
            $("#div_procure_close").css("display", "block");
            $("#div_sales").css("display", "none");
            $("#div_fleet").css("display", "none");
            $("#div_procure").css("display", "block");
            $("#divsmsrepo").css("display", "none");
            $("#divFleetSmsRepo").css("display", "none");
            $("#div_procurerepo").css("display", "block");
            var doe = document.getElementById('txt_procdate').value;
            var data = { 'op': 'procuresms_reportbybranch_details', 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        procure_sms_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function procure_sms_details(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" ></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Company Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="vieprocurewsms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="3" style="text-align:  center;">' + msg[k].companyname + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td class="5" style="Display:  none;">' + msg[k].companycode + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_procurerepo").html(results);
        }
         function vieprocurewsms_details(thisid) {
          $("#div_procurerepo").css("display", "none");
            $("#div_procurerepo2").css("display", "block");
            $("#div_Procure_close").css("display", "block");
            var doe = document.getElementById('txt_procdate').value;
            var companycode = $(thisid).parent().parent().children('.5').html();
            var data = { 'op': 'procuresms_reportbybranch_wise_details', 'doe': doe, 'companycode':companycode };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        procure_sms_branchwise_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function procure_sms_branchwise_details(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" ></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Branch Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viefleetwsms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="3" style="text-align:  center;">' + msg[k].BranchName + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td class="5" style="Display:  none;">' + msg[k].branchid + '</td>';
                results += '</tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_procurerepo2").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           Sms Report <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Sms Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_sales" class="active"><a data-toggle="tab" href="#" onclick="show_sales()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Sales Sms Details</a></li>
                        <li id="id_tab_fleet" class=""><a data-toggle="tab" href="#" onclick="show_fleet()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp; Fleet Sms Details</a></li>
                             <li id="id_tab_procure" class=""><a data-toggle="tab" href="#" onclick="show_procure()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Procurement sms Details</a></li>
                    </ul>
              </div>
                 <%--//-------------Sales---------//--%>
              <div id="div_sales" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Sales Sms Report Details
                </h3>
            </div>
            <div class="box-body" id="div_salesdiv">
                     <div align="center" >
                       <table>
                        <tr>
                            <td>
                                <label class="control-label" >
                                    Date</label>
                                    </td>
                                    <td>&nbsp</td>
                                    <td>
                                <input type="date" class="form-control" id="txt_Date" style="border-radius: 0px; important"/>
                            </td>
                            <td >
                            <div class="input-group">
                              <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-flash" onclick="generate_report();"  ></span> <span id="btn_generate"  onclick="generate_report();">Genarate</span>
                             </div>
                          </div>
                       </td>
                     </tr>
                   </table>
                </div>
                 </div>
                <div>
                <div id="divsmsrepo" style="display:none;">
             </div>
             </div>
             <div id="div_smsrepo2">
             <div id="divsmsrepo2" style="display:none;">
             </div>
             <div id="div_close" class="modal-footer" style="text-align: center; width: 100%; display:none;" >
                <button type="button" class="btn btn-default" id="btn_sales_close" onclick="sales_close();" style="background-color:  rosybrown;">
                    Close</button>
               </div>
             </div>
           
           </div>
              <%--//-------------fleet---------//--%>
           <div id="div_fleet" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Fleet Sms Report Details
                </h3>
            </div>
            <div class="box-body"  id="div_fleetdiv">
                     <div align="center">
                       <table>
                        <tr>
                            <td>
                                <label class="control-label" >
                                    Date</label>
                                    </td>
                                    <td>&nbsp</td>
                                    <td>
                                <input type="date" class="form-control" id="txt_fleetdate" style="border-radius: 0px; important"/>
                            </td>
                            <td >
                            <div class="input-group">
                              <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-flash" onclick="generate_fleetreport();"  ></span> <span id="Span1"  onclick="generate_fleetreport();">Genarate</span>
                             </div>
                          </div>
                       </td>
                     </tr>
                   </table>
                     </div>
              </div>
                <div id="divFleetSmsRepo" style="display:none;"></div>
             <div id="div_FleetSmsRepo2" style="display:block;">
                 <div id="divFleetSmsRepo2" style="display:none;" >
                 </div>
                 <div id="div_fleet_close" class="modal-footer" style="text-align: center; width: 100%;display:none;" >
                    <button type="button" class="btn btn-default" id="btn_fleet_close" onclick="fleet_close();" style="background-color:  rosybrown;">
                        Close</button>
                   </div>
             </div>
           </div>
    <%--//-------------procurement---------//--%>
           <div id="div_procure" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>procurement Sms Report Details
                </h3>
            </div>
            <div class="box-body" id="div_procurediv">
                     <div align="center">
                       <table>
                        <tr>
                            <td>
                                <label class="control-label" >
                                    Date</label>
                                    </td>
                                    <td>&nbsp</td>
                                    <td>
                                <input type="date" class="form-control" id="txt_procdate" style="border-radius: 0px; important"/>
                            </td>
                            <td >
                            <div class="input-group">
                              <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-flash" onclick="generate_procurereport();"  ></span> <span id="Span2"  onclick="generate_procurereport();">Genarate</span>
                             </div>
                          </div>
                       </td>
                     </tr>
                   </table>
                </div>
              </div>
              <div>
                <div id="div_procurerepo" style="display:none;">
             </div>
             </div>
              <div id="div_procuresmsrepo2" style="display:block;">
             <div id="div_procurerepo2" style="display:none;">
             </div>
             <div id="div_Procure_close" class="modal-footer" style="text-align: center; width: 100%; display:none;" >
                <button type="button" class="btn btn-default" id="Button1" onclick="procure_close();" style="background-color:  rosybrown;">
                    Close</button>
               </div>
             </div>
           </div>
           </div>
        </section>
</asp:Content>
