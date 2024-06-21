<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Resignation.aspx.cs" Inherits="Resignation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        label1
        {
            /* display: inline-block; */
            max-width: 100%;
            margin-bottom: 5px;
            font-weight: 700;
            width: 1px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            get_ResignationDetails();
            get_Employeedetails();
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
        });
        function canceldetails() {
            $("#fillGrid").show();
            $("#fillform").hide();
            $('#showlogs').show();

        }
        function showdesign() {
            get_ResignationDetails();
            $("#fillGrid").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            forclearall();
        }
        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_reg_search_employee' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function employeenamechange() {
            var empname = document.getElementById('selct_employe').value;
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

        function saveResignationDetails() {
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
            var data = { 'op': 'saveResignationDetails', 'empid': empid, 'reason': reason, 'noticeperiod': noticeperiod, 'workingday': workingday, 'quitedate': quitedate, 'arliernoticeperiod': arliernoticeperiod, 'resignsumbiteon': resignsumbiteon, 'btnVal': btnval, 'sno':sno, 'empcode': empcode };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
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

        function get_ResignationDetails() {
            var data = { 'op': 'get_ResignationDetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillresignation(msg);
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

        function fillresignation(msg) {
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Reason</th><th scope="col">LastWorkingDay</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
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
            $("#fillGrid").html(results);
        }

        function getme(thisid) {
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
            $("#fillGrid").hide();
            $("#fillform").show();
            $('#showlogs').hide();
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
        function forclearall() {
            document.getElementById('txtsupid').innerHTML = "";
            document.getElementById('selct_employe').innerHTML = "";
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
            get_ResignationDetails();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Resignation
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">EmployeeResignation</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Resignation Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <input id="btn_addbank" type="button" name="submit" value='Employee Resignation'
                        class="btn btn-primary" onclick="showdesign();" />
                </div>
                <div id="fillGrid">
                </div>
                <div id="fillform" style="display: none;">
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                <label1>
                                Employee Name</label1>
                            </td>
                            <td style="width: 6px;">
                            </td>
                             <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" />
                    </td>
                    <td style="height: 40px; display: none">
                        <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                            <td>
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Generate'
                                    onclick="btn_Purchase_order_click()" />
                            </td>
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
                                        onclick="saveResignationDetails()" />
                                    <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                        onclick="canceldetails()" />
                                </td>
                            </tr>
                    </table>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
