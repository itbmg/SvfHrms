<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="logininformation.aspx.cs" Inherits="logininformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<style>
    .blink_me {
    -webkit-animation-name: blinker;
    -webkit-animation-duration: 1s;
    -webkit-animation-timing-function: linear;
    -webkit-animation-iteration-count: infinite;
    
    -moz-animation-name: blinker;
    -moz-animation-duration: 1s;
    -moz-animation-timing-function: linear;
    -moz-animation-iteration-count: infinite;
    
    animation-name: blinker;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
}
@-moz-keyframes blinker {  
    0% { opacity: 1.0; }
    50% { opacity: 0.0; }
    100% { opacity: 1.0; }
}

@-webkit-keyframes blinker {  
    0% { opacity: 1.0; }
    50% { opacity: 0.0; }
    100% { opacity: 1.0; }
}

@keyframes blinker {  
    0% { opacity: 1.0; }
    50% { opacity: 0.0; }
    100% { opacity: 1.0; }
}
</style>
<script type="text/javascript">
    $(function () {
        $('#div_loginreport').css('display', 'block');
        $('#div_livelogin').css('display', 'none');
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
        $('#txt_date').val(yyyy + '-' + mm + '-' + dd);
        $('#txt_fdate').val(yyyy + '-' + mm + '-' + dd);
        $('#txt_tdate').val(yyyy + '-' + mm + '-' + dd);
    });
    function showloginreport() {
        $('#div_loginreport').css('display', 'block');
        $('#div_livelogin').css('display', 'none');
    }
    function showlivelogin() {
        $('#div_loginreport').css('display', 'none');
        $('#div_livelogin').css('display', 'block');
        get_livelogin_details();
    }
    function showemplyeewise() {
        $('#showlogs_rptdetails').css('display', 'block');
        $('#showlogs_date').css('display', 'none');
        get_employee_details();
    }
    function showdatewise() {
        $('#showlogs_date').css('display', 'block');
        $('#showlogs_rptdetails').css('display', 'none');
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
            Error: e
        });
    }
    var employeenames = [];
    function get_employee_details() {
        var data = { 'op': 'get_loginemployee_details' };
        var s = function (msg) {
            if (msg) {
                employeenames = msg;
                var availableTags = [];
                for (var i = 0; i < msg.length; i++) {
                    var employeename = msg[i].employeename;
                    availableTags.push(employeename);
                }
                $('#txt_employeename').autocomplete({
                    source: availableTags,
                    change: empnamechange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function empnamechange() {
        var name = document.getElementById('txt_employeename').value;
        for (var i = 0; i < employeenames.length; i++) {
            if (name == employeenames[i].employeename) {
                document.getElementById('txt_employeeid').value = employeenames[i].sno;
            }
        }
    }
    function btn_getlogininfoemployee_details() {
        var employeeid = document.getElementById('txt_employeeid').value;
        var fromdate = document.getElementById('txt_fdate').value;
        var todate = document.getElementById('txt_tdate').value;
        if (employeeid == "") {
            alert("Please select Employee Name");
            return false;
        }
        if (fromdate == "") {
            alert("Please select from date");
            return false;
        }
        if (todate == "") {
            alert("Please select to date");
            return false;
        }
        var data = { 'op': 'btn_getlogininfoemployee_details', 'employeeid': employeeid, 'fromdate': fromdate, 'todate': todate };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails(msg);
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function btn_getlogininfodatewise_details() {
        var date = document.getElementById('txt_date').value;
        if (date == "") {
            alert("Please select to date");
            return false;
        }
        var data = { 'op': 'btn_getlogininfoemployee_details', 'date': date };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails(msg);
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function filldetails(msg) {
        var emptable = [];
        var results = '<div    style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid" aria-describedby="example2_info">';
        results += '<thead><tr role="row" style="background:#5aa4d0; color: white; font-weight: bold;"><th scope="col" style="font-weight: bold;">Employee Name</th><th scope="col" style="font-weight: bold;">LogIn Date</th><th scope="col" style="font-weight: bold;">LogIn Time</th><th scope="col" style="font-weight: bold;">LogOut Time</th><th scope="col" style="font-weight: bold;">Time Interval</th><th scope="col" style="font-weight: bold;">IpAddress</th><th scope="col" style="font-weight: bold;">DeviceType</th></tr></thead></tbody>';
        var k = 1;
        var l = 0;
        var COLOR = [""];
        for (var i = 0; i < msg.length; i++) {
            if (emptable.indexOf(msg[i].employeename) == -1) {
                if (i == 0) {
                }
                else {
                }
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td data-title="Capacity" class="1" style="text-align:center;">' + msg[i].employeename + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].indate + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].intime + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].outtime + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].timeinterval + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].ipaddress + '</td>';
                results += '<td  class="5" style="text-align:center;">' + msg[i].devicetype + '</td></tr>';
                emptable.push(msg[i].employeename);
            }
            else {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td scope="row" class="1" ></td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].indate + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].intime + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].outtime + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].timeinterval + '</td>';
                results += '<td  class="4" style="text-align:center;">' + msg[i].ipaddress + '</td>';
                results += '<td  class="5" style="text-align:center;">' + msg[i].devicetype + '</td></tr>';
            }
        }
        results += '</table></div>';
        $("#get_logreport").html(results);
    }
    function get_livelogin_details() {
        var data = { 'op': 'get_loginemployee_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails_fill(msg);
                    blinkFont();
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function filldetails_fill(msg) {
        var results = '<div    style="overflow:auto;"><table class="table table-bordered table-hover dataTable" role="grid" aria-describedby="example2_info">';
        results += '<thead><tr role="row" style="background:#5aa4d0; color: white; font-weight: bold;"><th scope="col" style="font-weight: bold;">Employee Name</th><th scope="col" style="font-weight: bold;">Level Type</th><th scope="col" style="font-weight: bold;">Status</th></tr></thead></tbody>';
        var k = 1;
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        for (var i = 0; i < msg.length; i++) {
            var loginstatuss = msg[i].loginstatus;
            if (loginstatuss == "Active") {
                results += '<tr style="background-color: aqua;" class="blink_me">';
                results += '<td data-title="Capacity" class="1" style="text-align:center;">' + msg[i].employeename + '</td>';
                results += '<td  class="2" style="text-align:center;">' + msg[i].leveltype + '</td>';
                //var loginstatus = msg[i].loginstatus;
                //results += '<td  class="8"><span style="border-radius: 5px;color: white; letter-spacing: 0.05em; background-color:' + loginstatuss + '"><span id="8" class="8">' + msg[i].loginstatus + '</span></span></td></tr>';
                results += '<td  class="2" style="text-align:center;">' + msg[i].loginstatus + '</td></tr>';
            }
            else {
                results += '<tr>';
                results += '<td data-title="Capacity" class="1" style="text-align:center;">' + msg[i].employeename + '</td>';
                results += '<td  class="2" style="text-align:center;">' + msg[i].leveltype + '</td>';
                //var loginstatus = msg[i].loginstatus;
                //results += '<td  class="8"><span style="border-radius: 5px;color: white; letter-spacing: 0.05em; background-color:' + loginstatuss + '"><span id="8" class="8">' + msg[i].loginstatus + '</span></span></td></tr>';
                results += '<td  class="2" style="text-align:center;">' + msg[i].loginstatus + '</td></tr>';
            }
        }
        results += '</table></div>';
        $("#div_livereport").html(results);
    }
    function blinkFont() {
        $('.blinck').each(function (i, obj) {
            var qtyclass = $(this).text();
            if (qtyclass == "            " || qtyclass == "") {
                $(this).parent().css('background', 'aqua');
                $(this).parent().css('color', 'white');
            }
        });
        setTimeout("setblinkFont()", 100)
    }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            <i class="fa fa-files-o" aria-hidden="true"></i>Login Information<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Login Information Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showloginreport()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Login Report</a></li>
                    <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showlivelogin()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Live Login</a></li>
                </ul>
            </div>
            <div id="div_loginreport" style="display:none" >
            <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Login Report Details
                </h3>
            </div>
             <div class="box-body">
                <div id="fill_loginrpt" style="text-align: -webkit-center;">
                <table>
                    <tr>
                        <td>
                             <input id="rdolst_0" type="radio" name="selected" onclick="showemplyeewise();" />
                                                Employee Wise
                        </td>
                        <td   style="padding-left: 10%;">
                        </td>
                        <td>
                            <input id="rdolst_1" type="radio" name="selected" onclick="showdatewise();" />
                                                Date Wise
                        </td>
                    </tr>
                 </table>
                </div>
                  <div id="showlogs_rptdetails" style="display: none;text-align: -webkit-center;padding-top: 2%;padding-bottom: 2%;">
                    <table>
                        <tr>
                          <td>
                                <label>
                                 Employee Name : </label>
                            </td>
                            <td>
                              <input id="txt_employeename" type="text" class="form-control" name="branch_search" onchange="empnamechange();" placeholder="Enter Employee  Name">
                              <input id="txt_employeeid" type="text" style="display:none" class="form-control" name="employeeid" />
                            </td>
                            <td>
                                <label>
                                 From Date : </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_fdate" class="form-control" type="date" name="fromdate"/>
                            </td>
                            <td>
                                <label>
                                 To Date : </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_tdate" class="form-control" type="date" name="todate"/>
                            </td>
                            
                            <td style="width: 5px;">
                            </td>
                            <%--<td>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-flash"></span> <span id="btn_save" onclick="btn_getlogininfoemployee_details();">Get Details</span>
                                    </div>
                                </div>
                            </td>--%>
                            <td>
                       <div class="input-group">
                                <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-plus-sign"  onclick="btn_getlogininfoemployee_details()"></span> <span  onclick="btn_getlogininfoemployee_details()">Get Details</span>
                          </div>
                          </div>
               
                </td>
                     </tr>
                    </table>
                </div>
                <div id="showlogs_date"  style="display:none;text-align: -webkit-center;padding-top: 2%;padding-bottom: 2%;"> 
                  <table>
                  <tr>
                     <td>
                                <label>
                                 Date : </label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_date" class="form-control" type="date" name="date"/>
                            </td>
                             <td style="width: 5px;">
                            </td>
                            <%--<td>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-flash"></span> <span id="Span1" onclick="btn_getlogininfodatewise_details();">Get Details</span>
                                    </div>
                                </div>
                            </td>--%>
                            <td>
                            <div class="input-group">
                                <div class="input-group-addon" style="border-color: #3c8dbc;background-color: #3c8dbc;border-radius: 4px;color: whitesmoke;">
                                <span class="glyphicon glyphicon-plus-sign"  onclick="btn_getlogininfodatewise_details()"></span> <span  onclick="btn_getlogininfodatewise_details()">Get Details</span>
                          </div>
                          </div>
                          </td>
                  </tr>
                  </table>
                </div>
                <div id="get_logreport">
                </div>
             </div>
            </div>
            </div>
            <div id="div_livelogin" style="display:none" >
            <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Live Login Details
                </h3>
            </div>
            <div  class="box-body">
              <div id="div_livereport">
              </div>
            </div>
            </div>
    </div>
        </div>
    </section>
</asp:Content>

