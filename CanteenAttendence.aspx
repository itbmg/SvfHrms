<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="CanteenAttendence.aspx.cs" Inherits="CanteenAttendence" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <style type="text/css">
        .inputstable td
        {
            padding: 5px 5px 5px 5px;
        }
        .col
        {
            border: 1px solid #d5d5d5;
            text-align: center;
        }
        
        .students-table
        {
            width: 100%;
            border-collapse: collapse;
        }
        .students-table th
        {
            font-weight: bold;
            vertical-align: middle;
        }
        .students-table td, .students-table th
        {
            padding: 5px;
            line-height: 20px;
            text-align: left;
            border: 1px solid #ddd;
        }
        
        .students-table tr:nth-child(odd)
        {
            background: #f9f9f9;
        }
        .students-table tr:nth-child(even)
        {
            background: #ffffff;
        }
    </style>
    <script type="text/javascript">
        $(function () {
           // get_Dept_details();
            //get_Employeedetails();
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

        function btn_Students_click() {
            document.getElementById('div_students').innerHTML = "";
            var DOA = document.getElementById("txtDOA").value;
            //var Department = document.getElementById("selct_department").value;
            if (DOA == null || DOA == "") {
                document.getElementById("txtDOA").focus();
                alert("please Select Attendance Date");
                return false;
            }
//            if (Department == null || Department == "") {
//                document.getElementById("selct_department").focus();
//                alert("please Select Department");
//                return false;
//            }
            var Data = { 'op': 'get_employeescanteenAttendence', 'DOA': DOA };
            var s = function (msg) {
                if (msg && msg != 'false') {
                    gradestudentsdata = msg;
                    var status = "0";
                    var divstudents = document.getElementById('div_students');
                    var tablestrctr = document.createElement('table');
                    tablestrctr.id = "tabledetails";
                    tablestrctr.setAttribute("class", "students-table");
                    $(tablestrctr).append('<thead><tr><th>Sno</th><th><i class="fa fa-user" style="font-size:20px;padding-right: 5px;"></i>Employee Name</th><th>RegistrationID</th><th>Present</th><th>Absent</th></tr></thead><tbody></tbody>');
                    for (var i = 0; i < gradestudentsdata.length; i++) {
                        var present = '', absent = '', rename = '', smsstatus = '', Prevsmsstatus = '0';
                        if (gradestudentsdata[i].attendance_status == "1") {
                            present = "checked";
                            smsstatus = '';
                            Prevsmsstatus = '0';
                        }
                        if (gradestudentsdata[i].attendance_status == "2") {
                            absent = "checked";
                            if (gradestudentsdata[i].smsstatus == "1") {
                                smsstatus = "checked";
                                Prevsmsstatus = '1';
                            }
                        }
                        if (gradestudentsdata[i].attendance_status == "3") {
                            rename = "checked";
                            smsstatus = '';
                            Prevsmsstatus = '0';
                        }
                        if (gradestudentsdata[i].attendenceSno != "0") {
                            status = "1";
                        }
                        var j = 0;
                        j = i + 1;
                        $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td><td>' + gradestudentsdata[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td><td><input type="radio" id="ckbpresent" name="' + gradestudentsdata[i].empsno + '" value="1" checked="' + present + '"></td><td><input type="radio" name="' + gradestudentsdata[i].empsno + '" value="2" ' + absent + '></td></tr>');

                    }
                    $(tablestrctr).append('<br/>');
                    $(tablestrctr).append('<br/>');
                    $(tablestrctr).append('<br/>');
                    divstudents.appendChild(tablestrctr);

                    for (var i = 0; i < gradestudentsdata.length; i++) {
                        if (gradestudentsdata[i].status == "1") {
                            $('.students-table tr').each(function () {
                                var studentid = $(this).find(':checkbox');

                                if (studentid[0].value == gradestudentsdata[i].studentsno) {
                                    studentid[0].checked = true;
                                }

                            });
                        }
                    }
                    document.getElementById("btn_Finalize").style.background = 'Green';
                    document.getElementById("btn_Finalize").value = 'Finalize Attendance';
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            callHandler(Data, s, e);
        }
        function selectall_checks(thisid) {
            if ($(thisid).is(':checked')) {
                $('.students-table tr').each(function () {
                    $(this).find(':checkbox').prop('checked', true);
                });
            }
            else {
                $('.students-table tr').each(function () {
                    $(this).find(':checkbox').prop('checked', false);
                });
            }
        }
        function btn_cancelApply_click() {
            document.getElementById('div_students').innerHTML = "";
            document.getElementById('lbl_currentgrade').innerHTML = "...";
            document.getElementById('lbl_currentsection').innerHTML = "...";
        }

        function btn_Finalize_Attendence() {
            var studentslist = [];
            var Absentlist = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                //var remarks = $(this).find('#txt_remarks').val();
                var hdnempsno = $(this).find('#hdnempsno').val();
                var status = "";
                $(this).find('[type="radio"]').each(function () {
                    if ($(this).is(':checked')) {
                        status = "A";
                    }
                    else {
                        status = "P";
                    }
                });
                var abc = { employee: hdnempsno,  status: status };
                studentslist.push(abc);
            });
            var type = $("#select_Type option:selected").val();
            var DOA = document.getElementById("txtDOA").value;
            if (DOA == null || DOA == "") {
                document.getElementById("txtDOA").focus();
                alert("please Select Attendance Date");
                return false;
            }
//            var Department = document.getElementById("selct_department").value;
//            if (Department == null || Department == "") {
//                document.getElementById("selct_department").focus();
//                alert("please Select Department");
//                return false;
           // }
            var Data = { 'op': 'save_CanteenAttendence', 'DOA': DOA,  'type': type, 'employeeslist': studentslist };
            var s = function (msg) {
                if (msg && msg != 'false') {
                    alert(msg);
                    btn_Students_click();
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(Data, s, e);
        }
   </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Canteen Attendence<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Canteen Management</a></li>
            <li><a href="#">Attendence</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Attendence
                </h3>
            </div>
            <table id="tbl_leavemanagement" align="center">
                <tr>
                    <td style="height: 40px;">
                        Date <span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="date" class="form-control" id="txtDOA" class="form-control" />
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td>
                        <input id="btn_Students" type="button" class="btn btn-primary" name="submit" value="Get Employees"
                            onclick="btn_Students_click();" style="width: 100px;">
                    </td>
                </tr>
            </table>
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Select Employee(s)
                    </h3>
                </div>
                <div class="" align="center">
                    <label class="control-label" for="txt_empname">
                        Selection  Type</label>
                    <select name="month" id="select_Type" onchange="" size="1">
                        <option value="1">Breakfast</option>
                        <option value="2">Lunch</option>
                        <option value="3">Dinner</option>
                    </select>
                <div align="center">
                    <div id="div_students" style="padding: 0px 0px 5px 5px; font-family: 'Open Sans';
                        font-size: 13px; margin-top: 10px; margin-bottom: 10px; display: inline-block;">
                    </div>
                </div>
            </div>
            <div style="width: 200px; position: fixed; left: 50%; top: 95%; margin-left: -100px;">
                <table class="inputstable">
                    <tr>
                        <td>
                        </td>
                        <td>
                            <input id="btn_Finalize" type="button" class="btn btn-primary" name="submit" value="Finalize Attendance"
                                onclick="btn_Finalize_Attendence();" style="width: 180px;">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </section>


</asp:Content>

