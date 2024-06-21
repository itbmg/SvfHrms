<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="ResignatinApplicationAndAproval.aspx.cs" Inherits="ResignatinApplicationAndAproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<style type="text/css">
        label1
        {
            max-width: 100%;
            margin-bottom: 5px;
            font-weight: 700;
            width: 1px;
        }
    </style>
<script type="text/javascript">
    $(function () {
        ShowRegAppDetails();

        //---Reg Application---//
        get_ResignationAppDetails();
        get_RegAppEmployeeNamedetails();
        var date = new Date();
        var day = date.getDate();
        var month = date.getMonth() + 1;
        var year = date.getFullYear();
        if (month < 10) month = "0" + month;
        if (day < 10) day = "0" + day;
        today = year + "-" + month + "-" + day;
        $('#txt_regsumbitedate').val(today);
        $('#txt_noticeprioed').val(today);
        $('#txtLastWorkingDay').val(today);

        //---Reg Approval----//
        get_ResignationDetails();
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
    function ShowRegAppDetails() {
        $("#Div_RegAppdetails").show();
        $("#div_RegApprlDetails").hide();
    }
    function ShowRegApprovalDetails() {
        $("#Div_RegAppdetails").hide();
        $("#div_RegApprlDetails").show();

    }

  //-------------Reg Application Details-------------//

    function RegApp_canceldetails() {
        document.getElementById('selct_regappemploye').value = "";
        $("#fillRegAppGrid").show();
        $("#fillRegAppform").hide();
        $('#showRegApplogs').show();
    }
    function showdesign() {
        get_ResignationAppDetails();
        $("#fillRegAppGrid").hide();
        $("#fillRegAppform").show();
        $('#showRegApplogs').hide();
        forclearall_RegApp();
    }
    var employeedetails = [];
    function get_RegAppEmployeeNamedetails() {
        var data = { 'op': 'get_reg_search_employee' };
        var s = function (msg) {
            if (msg) {
                employeedetails = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].empname;
                    empnameList.push(empname);
                }
                $('#selct_regappemploye').autocomplete({
                    source: empnameList,
                    change: employee_regappnamechange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function employee_regappnamechange() {
        var empname = document.getElementById('selct_regappemploye').value;
        for (var i = 0; i < employeedetails.length; i++) {
            if (empname == employeedetails[i].empname) {
                document.getElementById('txtsupid').value = employeedetails[i].empid;
                document.getElementById('txtEmployeeCode').innerHTML = employeedetails[i].empnum;
                document.getElementById('txtEmployeeName').innerHTML = employeedetails[i].empname;
                document.getElementById('txtDepartment').innerHTML = employeedetails[i].department;
                document.getElementById('txtDesignation').innerHTML = employeedetails[i].designation;
                document.getElementById('txtDoj').innerHTML = employeedetails[i].joindate;
            }
        }
    }

    function saveResignationAppDetails() {
        var empid = document.getElementById('txtsupid').value;
        if (empid == "") {
            alert(" Enter Employee Name");
            return false;

        }
        var reason = document.getElementById('txt_remarks').value;
        if (reason == "") {
            alert(" Fill reason");
            return false;

        }
        var workingday = document.getElementById('txtLastWorkingDay').value;
        if (workingday == "") {

            alert("Fill notice ");
            return false;
        }
        var empcode = document.getElementById('txtEmployeeCode').innerHTML;
        if (empcode == "") {
            alert("Fill empcode ");
            return false;
        }

        var resignsumbiteon = document.getElementById("txt_regsumbitedate").value;
        if (resignsumbiteon == "") {

            alert("resignsumbiteo ");
            return false;
        }
        var arliernoticeperiod = document.getElementById('txtNoticePeriod').value;
        var noticeperiod = document.getElementById("txt_noticeprioed").value;
        if (noticeperiod == "") {

            alert("noticeperiod");
            return false;
        }
        var quitedate = document.getElementById("txtDate").value;
        var sno = document.getElementById('lbl_sno').innerHTML;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'saveResignationDetails', 'empid': empid, 'reason': reason, 'noticeperiod': noticeperiod, 'workingday': workingday, 'quitedate': quitedate, 'arliernoticeperiod': arliernoticeperiod, 'resignsumbiteon': resignsumbiteon, 'btnVal': btnval, 'sno': sno, 'empcode': empcode };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall_RegApp();
                    get_ResignationAppDetails();

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

    function get_ResignationAppDetails() {
        var data = { 'op': 'get_ResignationDetails' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillresignationApp(msg);
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

    function fillresignationApp(msg) {
        var l = 0;
        var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Reason</th><th scope="col">LastWorkingDay</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getmeRegApp(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].reason + '</th>';
            results += '<td  class="2">' + msg[i].lastworkingday + '</td>';
            results += '<td style="display:none" class="3">' + msg[i].willingtoquitdate + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].willingtoquitearlierthannoticeperiod + '</td>';
            results += '<td style="display:none" class="5">' + msg[i].sno + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].fullname + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].joindate + '</td>';
            results += '<td style="display:none" class="9">' + msg[i].noticeperiod + '</td>';
            results += '<td style="display:none" class="10">' + msg[i].empnum + '</td>';
            results += '<td style="display:none" class="11">' + msg[i].resignsumbiteon + '</td>';
            results += '<td style="display:none" class="12">' + msg[i].designation + '</td>';
            results += '<td style="display:none" class="13">' + msg[i].department + '</td>';
            results += '<td style="display:none" class="14">' + msg[i].empnum + '</td>';
            results += '<td style="display:none" class="7">' + msg[i].empid + '</td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#fillRegAppGrid").html(results);
    }

    function getmeRegApp(thisid) {
        var reason = $(thisid).parent().parent().children('.1').html();
        var lastworkingday = $(thisid).parent().parent().children('.2').html();
        var willingtoquitdate = $(thisid).parent().parent().children('.3').html();
        var willingtoquitearlierthannoticeperiod = $(thisid).parent().parent().children('.4').html();
        var sno = $(thisid).parent().parent().children('.5').html();
        var empid = $(thisid).parent().parent().children('.7').html();
        var fullname = $(thisid).parent().parent().children('.6').html();
        var joindate = $(thisid).parent().parent().children('.8').html();
        var empnum = $(thisid).parent().parent().children('.10').html();
        var noticeperiod = $(thisid).parent().parent().children('.9').html();
        var resignsumbiteon = $(thisid).parent().parent().children('.11').html();
        var designation = $(thisid).parent().parent().children('.12').html();
        var department = $(thisid).parent().parent().children('.13').html();
        var empnum = $(thisid).parent().parent().children('.14').html();
        document.getElementById('txtDate').value = willingtoquitdate;
        document.getElementById('txt_remarks').value = reason;
        document.getElementById('txtLastWorkingDay').value = lastworkingday;
        document.getElementById('txtNoticePeriod').value = willingtoquitearlierthannoticeperiod;
        document.getElementById('txtEmployeeName').innerHTML = fullname;
        document.getElementById('txtDoj').innerHTML = joindate;
        document.getElementById('txtEmployeeCode').value = joindate;
        document.getElementById('txt_noticeprioed').value = noticeperiod;
        document.getElementById('lbl_sno').innerHTML = sno;
        document.getElementById('txtDesignation').innerHTML = designation;
        document.getElementById('txtDepartment').innerHTML = department;
        document.getElementById('txtEmployeeCode').innerHTML = empnum;
        document.getElementById('txtsupid').value = empid;
        document.getElementById('txt_regsumbitedate').value = resignsumbiteon;
        document.getElementById('btn_save').value = "Modify";
        $("#fillRegAppGrid").hide();
        $("#fillRegAppform").show();
        $('#showRegApplogs').hide();
    }
    $(function () {
        $("#txtNoticePeriod").click(function () {
            if ($(this).is(":checked")) {
                $("#div_date").show();
            } else {
                $("#div_date").hide();
            }
        });
    });
    function forclearall_RegApp() {
        document.getElementById('txtsupid').innerHTML = "";
        document.getElementById('selct_regappemploye').innerHTML = "";
        document.getElementById('txtEmployeeCode').innerHTML = "";
        document.getElementById('txtEmployeeName').innerHTML = "";
        document.getElementById('txtDepartment').innerHTML = "";
        document.getElementById('txtDesignation').innerHTML = "";
        document.getElementById('txtDoj').innerHTML = "";
        document.getElementById('lbl_sno').innerHTML = "";
        document.getElementById('txt_noticeprioed').value = "";
        document.getElementById('txt_remarks').value = "";
        document.getElementById('txtLastWorkingDay').value = "";
        document.getElementById('txtNoticePeriod').value = "";
        document.getElementById('txtDate').value = "";
        document.getElementById('txt_regsumbitedate').value = "";
        document.getElementById('btn_save').value = "Add";
        get_ResignationAppDetails();
    }
    //-----------Resignation Approval Details------------//
   
    function get_ResignationDetails() {
        var data = { 'op': 'get_ResignationDetails' };
        var s = function (msg) {
            if (msg) {
                fillresignation(msg);
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function fillresignation(msg) {
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">Department</th><th scope="col">Date Of Joining</th><th scope="col">Relieving Date</th><th scope="col">Reason</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
            results += '<td  class="2">' + msg[i].department + '</td>';
            results += '<td  class="3">' + msg[i].joindate + '</td>';
            results += '<td  class="4">' + msg[i].resignationdate + '</td>';
            results += '<td class="5">' + msg[i].reason + '</td>';
            results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_resignation_approve_click(this);" value="Apporval" /></td><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-danger" value="Reject" /></td>';
            results += '<td style="display:none" class="7">' + msg[i].status + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].empid + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#fillGrid").html(results);
    }
    function CloseClick() {
        $('#divMainAddNewRow').css('display', 'none');
    }

    var sno = 0;
    function getme(thisid) {
        $('#divMainAddNewRow').css('display', 'block');
        var fullname = $(thisid).parent().parent().children('.1').html();
        var department = $(thisid).parent().parent().children('.2').html();
        var joindate = $(thisid).parent().parent().children('.3').html();
        var resignationdate = $(thisid).parent().parent().children('.4').html();
        var reason = $(thisid).parent().parent().children('.5').html();
        sno = $(thisid).parent().parent().children('.6').html();
        var status = $(thisid).parent().parent().children('.7').html();
    }

    function save_resignation_reject_click() {
        var reason = document.getElementById("txt_remarks").value;
        var data = { 'op': 'save_resignation_reject_click', 'sno': sno, 'reason': reason };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    $('#divMainAddNewRow').css('display', 'none');
                    get_ResignationDetails();
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

    function save_resignation_approve_click(thisid) {
        var empid = $(thisid).parent().parent().children('.8').html();
        sno = $(thisid).parent().parent().children('.6').html();
        var data = { 'op': 'save_resignation_approve_click', 'sno': sno, 'empid': empid };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_ResignationDetails();
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
    

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content">
        <div class="row">
            <section class="content-header">
                <h1>
                  Resignation Appliocation And Approval
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Resignation Appliocation And Approval Master</a></li>
                    <li><a href="#">Master</a></li>
                </ol>
            </section>
        </div>
        <div class="box box-info">
            <div class="box-header with-border">
            </div>
            <div class="box-body">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_ledger" class="active"><a data-toggle="tab" href="#" onclick="ShowRegAppDetails()">
                            <i class="fa fa-building-o" aria-hidden="true"></i>&nbsp;&nbsp;Resignation Application Details</a></li>
                        <li id="id_travelexp" class=""><a data-toggle="tab" href="#" onclick="ShowRegApprovalDetails()">
                            <i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Resignation Approval Details</a></li>
                    </ul>
                 </div>
               </div>
             </div>

    <%-- -----------Reg Application Details-------------%>

    <div id="Div_RegAppdetails" style="display: none;">
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Resignation Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showRegApplogs" align="center">
                    <input id="btn_addbank" type="button" name="submit" value='Employee Resignation'
                        class="btn btn-primary" onclick="showdesign();" />
                </div>
                <div id="fillRegAppGrid">
                </div>
                <div id="fillRegAppform" style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label1>
                                Employee Name</label1>
                            </td>
                            <td style="width: 6px;">
                            </td>
                             <td>
                        <input type="text" class="form-control" id="selct_regappemploye" placeholder="Enter employee name" />
                    </td>
                    <td style="height: 40px; display: none">
                        <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                            <%--<td>
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Generate'
                                    onclick="btn_Purchase_order_click()" />
                            </td>--%>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                Employee Code</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="txtEmployeeCode" />
                            </td>
                            <td style="height: 40px;">
                                <label>
                                Employee Name</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="txtEmployeeName" />
                            </td>
                            <td style="height: 40px;">
                                <label>
                                Department</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="txtDepartment" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                Designation</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="txtDesignation" />
                            </td>
                            <td style="height: 40px;">
                                <label>
                                Joining Date</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="txtDoj" />
                            </td>
                        </tr>
                    </table>
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                Reason
                            </label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="height: 40px;">
                                <textarea id="txt_remarks" class="form-control" type="text" placeholder="Enter Reason"
                                    rows="4" cols="45"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                Resignation sumbited on
                            </label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input id="txt_regsumbitedate" type="date" name="Notice" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                 Notice Period
                            </label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input id="txt_noticeprioed" type="date" name="Notice" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label>
                                LastWorking Day By Notice Period
                            </label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input id="txtLastWorkingDay" type="date" placeholder="Enter day" name="Notice" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                                <label for="chk_add_login" id="change_dat" title="Check">
                                    Willing To Quit Earlier Than Notice Period</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input id="txtNoticePeriod" type="checkbox" value="willingtoquitearlierthannoticeperiod"
                                    style="width: 60px;" />
                            </td>
                        </tr>
                        <tr id="div_date" style="display: none">
                            <td style="height: 40px;">
                                <label for="chk_add_login" id="change_date" title="Check">
                                    Willing date To Quite</label>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                                <input id="txtDate" type="date" name="Date" class="form-control" />
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                            <td>
                            </td>
                            <tr align="center">
                                <td colspan="2" align="center" style="height: 40px;">
                                    <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Add'
                                        onclick="saveResignationAppDetails()" />
                                    <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                        onclick="RegApp_canceldetails()" />
                                </td>
                            </tr>
                    </table>
                </div>
            </div>
        </div>
    </section>
    </div>

     <%-- -----------Reg Approval Details-------------%>

    <div id="div_RegApprlDetails" style="display: none;">
     <section class="content">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Requests  Details
            </h3>
        </div>
        <div class='divcontainer' style="overflow:auto;">
        <div id="fillGrid">
                </div>
        </div>
        <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                    id="tableCollectionDetails" class="mainText2" border="1">
                    <tr>
                        <td>
                                 <label class="control-label">
                                Remarks</label>
                        </td>
                        <td style="height: 40px;">
                            <textarea id="Textarea1" type="text" class="form-control" name="Remarks" placeholder="Enter remarmks"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_resignation_reject_click();" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
            </div>
        </div>
    </div>
    </section>
    </div>

   </section>
</asp:Content>

