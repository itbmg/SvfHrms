<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="OveralSmsReport.aspx.cs" Inherits="OveralSmsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
            generate_report();
        });
        function company_close() {
            $("#div_overal_smsrepo").css("display", "block");
            $("#divcompwise_smsrepo").css("display", "none");
            $("#div_comp_close").css("display", "none");
        }
        function branch_close() {
            $("#div_overal_smsrepo").css("display", "none");
            $("#divcompwise_smsrepo").css("display", "block");
            $("#divbranch_wise_smsrepo").css("display", "none");
            $("#div_branch_close").css("display", "none");
            $("#div_comp_close").css("display", "block");
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
        function generate_report() {
            $("#div_overal_smsrepo").css("display", "block");
            $("#divcompwise_smsrepo").css("display", "none");
            $("#divbranch_wise_smsrepo").css("display", "none");
            var doe = document.getElementById('txt_Date').value;
            var data = { 'op': 'overal_sms_report_details', 'doe': doe };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        overal_sms_details(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function overal_sms_details(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" ></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Module</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            var grandtotsms = 0;
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="view_companywise_sms(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="3" style="text-align:  center;">' + msg[k].Moduleid + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].salestotsms + '</td>';
                results += '</tr>';
                var totalsms = parseFloat(msg[k].salestotsms) || 0;
                grandtotsms += totalsms;
            }
            results += '<tr style="color:  chocolate;background: lavenderblush;">';
            results += '<th  scope="row"  class="1"></th>';
            results += '<th  scope="row"  class="1" style="text-align:  center;">' + "Grand Total" + '</th>';
            results += '<th  scope="row"  class="1"></th>';
            results += '<td  scope="row"  class="1" style="text-align:  center;">' + grandtotsms + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#div_overal_smsrepo").html(results);
        }
        function view_companywise_sms(thisid) {
            $("#div_overal_smsrepo").css("display", "none");
            $("#divcompwise_smsrepo").css("display", "block");
            $("#divbranch_wise_smsrepo").css("display", "none");
            $("#div_comp_close").css("display", "block");
            var doe = document.getElementById('txt_Date').value;
            var moduleid = $(thisid).parent().parent().children('.3').html();
            var data = { 'op': 'overal_sms_compwise_details', 'doe': doe, 'moduleid': moduleid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        comp_wisesms_details(msg);
                    }
                    else {
                        $("#divcompwise_smsrepo").css("display", "none");
                        $("#div_overal_smsrepo").css("display", "block");
                        $("#div_comp_close").css("display", "none");
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function comp_wisesms_details(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" ></th><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Company Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            var grandtotsms = 0;
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viewbranch_Wisesms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="3" style="text-align:  center;">' + msg[k].companyname + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td class="5" style="Display:  none;">' + msg[k].companyid + '</td>';
                results += '<td class="6" style="Display:  none;">' + msg[k].Moduleid + '</td>';
                results += '</tr>';
                var totalsms = parseFloat(msg[k].totaltms) || 0;
                grandtotsms += totalsms;
            }
            results += '<tr style="color:  chocolate;background: lavenderblush;">';
            results += '<th  scope="row"  class="1"></th>';
            results += '<th  scope="row"  class="1" style="text-align:  center;">' + "Grand Total" + '</th>';
            results += '<th  scope="row"  class="1"></th>';
            results += '<td  scope="row"  class="1" style="text-align:  center;">' + grandtotsms + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#divcompwise_smsrepo").html(results);
        }
        function viewbranch_Wisesms_details(thisid) {
            $("#div_overal_smsrepo").css("display", "none");
            $("#divcompwise_smsrepo").css("display", "none");
            $("#divbranch_wise_smsrepo").css("display", "block");
            $("#div_comp_close").css("display", "none");
            $("#div_branch_close").css("display", "block");
            var doe = document.getElementById('txt_Date').value;
            var companycode = $(thisid).parent().parent().children('.5').html();
            var Moduleid = $(thisid).parent().parent().children('.6').html();
            var data = { 'op': 'branch_wisesms_details', 'doe': doe, 'companycode': companycode, 'Moduleid': Moduleid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        branch_wise_smsrepo(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function branch_wise_smsrepo(msg) {
            var l = 0;
            var i = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" style="text-align:  center;">Sno</th><th scope="col" style="text-align:  center;">Branch Name</th><th scope="col" style="text-align:  center;">Sms Count</th></tr></thead></tbody>';
            var grandtotsms = 0;
            for (var k = 0; k < msg.length; k++) {
                results += '<tr >';
//                results += '<tr><td style="text-align:  center;"><span id="btn_poplate"  onclick="viewdep_wisesms_details(this)"  name="submit" class="glyphicon btn-glyphicon glyphicon-share img-circle text-info""></span></td>';
                results += '<td style="text-align:  center;">' + i++ + '</td>';
                results += '<td  class="5" style="text-align:  center;">' + msg[k].BranchName + '</td>';
                results += '<td class="4" style="text-align:  center;">' + msg[k].totaltms + '</td>';
                results += '<td  class="5" style="text-align:  center; display:none">' + msg[k].companycode + '</td>';
                results += '<td  class="5" style="text-align:  center; display:none"">' + msg[k].branchid + '</td>';
                results += '</tr>';
                var totalsms = parseFloat(msg[k].totaltms) || 0;
                grandtotsms += totalsms;
            }
            results += '<tr style="color:  chocolate;background: lavenderblush;">';
            results += '<th  scope="row"  class="1"></th>';
            results += '<th  scope="row"  class="1" style="text-align:  center;">' + "Grand Total" + '</th>';
//            results += '<th  scope="row"  class="1"></th>';
            results += '<td  scope="row"  class="1" style="text-align:  center;">' + grandtotsms + '</td>';
            results += '</tr>';
            results += '</table></div>';
            $("#divbranch_wise_smsrepo").html(results);
        } 
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-user-plus"></i>Sms Details
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
                <div id="div_overal_smsrepo" style="display:none;">
             </div>
             </div>
             <div id="div_smsrepo2">
             <div id="divcompwise_smsrepo" style="display:none;">
             </div>
             <div id="div_comp_close" class="modal-footer" style="text-align: center; width: 100%; display:none;" >
                <button type="button" class="btn btn-default" id="btn_company_close" onclick="company_close();" style="background-color:  rosybrown;">
                    Close</button>
               </div>
             </div>
             <div id="div_branchwise_smsrepo2">
             <div id="divbranch_wise_smsrepo" style="display:none;">
             </div>
             <div id="div_branch_close" class="modal-footer" style="text-align: center; width: 100%; display:none;" >
                <button type="button" class="btn btn-default" id="btn_branch_close" onclick="branch_close();" style="background-color:  rosybrown;">
                    Closee</button>
               </div>
             </div>
           </div>
        </section>
</asp:Content>

