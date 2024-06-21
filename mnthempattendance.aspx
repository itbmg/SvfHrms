<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="mnthempattendance.aspx.cs" Inherits="mnthempattendance" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
    <style>
        input[type=checkbox]
        {
            transform: scale(1.5);
        }
        input[type=checkbox]
        {
            width: 30px;
            height: 18px;
            margin-right: 8px;
            cursor: pointer;
            font-size: 10px;
            visibility: hidden;
        }
        input[type=checkbox]:after
        {
            content: " ";
            background-color: #fff;
            display: inline-block;
            margin-left: 10px;
            padding-bottom: 0px;
            color: #24b6dc;
            width: 16px;
            height: 16px;
            visibility: visible;
            border: 1px solid rgba(18, 18, 19, 0.12);
            padding-left: 3px;
            border-radius: 0px;
        }
        input[type="checkbox"]:not(:disabled):hover:after
        {
            border: 1px solid #24b6dc;
        }
        input[type=checkbox]:checked:after
        {
            content: "\2714";
            padding: -5px;
            font-weight: bold;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">
        $(function () {
            get_Branch_details();
            get_CompanyMaster_details();
            employeetype();
            $("#div_empattdance").css("display", "block");
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txtDOA').val(today);
            $('#txtfromdate').val(today);
            $('#txttodate').val(today);
            $('#txt_abfromdate').val(today);
        });
        function show_employeeattdence() {
            $("#div_empattdance").css("display", "block");
            $("#div_empworkhours").css("display", "none");
            $("#div_employee_attandancereport").css("display", "none");
            $("#div_absent").css("display", "none");
        }

        function show_empattdncereprt() {
            $("#div_empattdance").css("display", "none");
            $("#div_empworkhours").css("display", "none");
            $("#div_employee_attandancereport").css("display", "block");
            $("#div_absent").css("display", "none");
            $("#div_perdayInOut").css("display", "none");
        }

        function show_empworkinghours() {
            $("#div_empattdance").css("display", "none");
            $("#div_empworkhours").css("display", "block");
            $("#div_employee_attandancereport").css("display", "none");
            $("#div_absent").css("display", "none");
            $("#div_perdayInOut").css("display", "none");
            get_Branch_details();
        }
        function show_empabsentdetails() {
            $("#div_empattdance").css("display", "none");
            $("#div_empworkhours").css("display", "none");
            $("#div_employee_attandancereport").css("display", "none");
            $("#div_absent").css("display", "block");
            $("#div_perdayInOut").css("display", "none");
            //ODrequestDetails();
            get_Branch_details();
        }
        function show_empperdayInOutTime() {
            $("#div_empattdance").css("display", "none");
            $("#div_empworkhours").css("display", "none");
            $("#div_employee_attandancereport").css("display", "none");
            $("#div_absent").css("display", "none");
            $("#div_perdayInOut").css("display", "block");
           
            get_Branch_details();
        }
        

        function show_devicedetails() {

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


        function fillbranchdetails1(msg) {
            var data = document.getElementById('ddlbrnch');
            var length = data.options.length;
            document.getElementById('ddlbrnch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
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

        function employeetype() {            
            var data = { 'op': 'get_employeetype_fill'};
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillemployeetype1(msg);
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


        function fillemployeetype1(msg) {
            var data = document.getElementById('emp_type');
            var length = data.options.length;
            document.getElementById('emp_type').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "EmployeeType";
            opt.value = "EmployeeType";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].employee_type != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].employee_type;
                    option.value = msg[i].employee_type;
                    data.appendChild(option);
                }
            }
        }

        function btn_Students_click() {
            $("#div_imageattdance").css("display", "block");
            document.getElementById('div_students').innerHTML = "";
            var DOA = document.getElementById("txtDOA").value;
            var branchid = document.getElementById("ddlbrnch").value;
            var company_code = document.getElementById("selct_Cmpny").value;
            var Employee_Type = document.getElementById("emp_type").value;
            if (DOA == null || DOA == "") {
                document.getElementById("txtDOA").focus();
                alert("please Select Attendance Date");
                return false;
            }
            if (branchid == null || branchid == "") {
                document.getElementById("ddlbrnch").focus();
                alert("please Select Branch");
                return false;
            }
            var Data = { 'op': 'get_employeesAttendence', 'DOA': DOA, 'branchid': branchid, 'company_code': company_code, 'Employee_Type': Employee_Type };
            var s = function (msg) {
                gradestudentsdata = msg;
                if (gradestudentsdata.length > 1) {
                    var status = "0";
                    var divstudents = document.getElementById('div_students');
                    var tablestrctr = document.createElement('table');
                    tablestrctr.id = "tabledetails";
                    tablestrctr.setAttribute("class", "students-table");
                    var count = gradestudentsdata[0].totcount;
                    if (count > 2) {
                        document.getElementById("spn_msg").style.color = 'Green';
                        document.getElementById('spn_msg').innerHTML = "This date already finalized " + count;
                        $("#btn_Finalize").css("display", "none");
                    }
                    else {
                        document.getElementById("spn_msg").style.color = 'Red';
                        document.getElementById('spn_msg').innerHTML = "Attendence not finalized " + count;
                        $("#btn_Finalize").css("display", "block");
                    }
                    $(tablestrctr).append('<thead><tr><th>Sno</th><th><i class="fa fa-user" style="font-size:20px;padding-right: 5px;"></i>Employee Name</th><th>Employee Code</th><th>Present</th></tr></thead><tbody></tbody>');
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
                        var date = gradestudentsdata[i].Date
                        if (date == gradestudentsdata[i].LogDate) {
                            $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td>'
                            + '<td>' + gradestudentsdata[i].registrationid + '</td>'
                            + '<td name="idprevsmsstatus" style="display:none"><input  id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /><input id="hdnbranchsno" type="hidden" value="' + gradestudentsdata[i].branchid + '" /></td>'
                            + '<td><input type="checkbox" class="checkedid" onclick="selectall_checks(this)"; id="ckbpresent"  value="' + gradestudentsdata[i].empsno + '" checked="' + present + '"></td></tr>');
                        }
                        else {
                            $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td><td>' + gradestudentsdata[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /><input id="hdnbranchsno" type="hidden" value="' + gradestudentsdata[i].branchid + '" /></td><td><input type="checkbox" class="checkedid" id="ckbpresent" onclick="selectall_checks(this)";  value="' + gradestudentsdata[i].empsno + '"></td></tr>');
                        }
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
            };
            var e = function (x, h, e) {
            };
            callHandler(Data, s, e);
        }
        function selectall_checks(thisid) {
            if ($(thisid).is(':checked')) {
                $(this).find(':checkbox').prop('checked', true);
            }
            else {
                $(this).find(':checkbox').prop('checked', true);
            }
        }
        function btn_cancelApply_click() {
            document.getElementById('div_students').innerHTML = "";
            document.getElementById('lbl_currentgrade').innerHTML = "...";
            document.getElementById('lbl_currentsection').innerHTML = "...";
        }
        function CallHandlerUsingJson_POST(d, s, e) {
            d = JSON.stringify(d);
            d = encodeURIComponent(d);
            $.ajax({
                type: "POST",
                url: "EmployeeManagementHandler.axd",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function btn_Finalize_Attendence() {
            var studentslist = [];
            var Absentlist = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            var remarks = "";
            $(rows).each(function (i, obj) {
                remarks = $(this).find('#txt_remarks').val();
                branchid = $(this).find('#hdnbranchsno').val();
            });
            $("input:checkbox[class=checkedid]:checked").each(function () {
                var empid = $(this).val();
                status = "P";
                var abc = { employee: empid, status: status };
                studentslist.push(abc);
            });
            var DOA = document.getElementById("txtDOA").value;
            if (DOA == null || DOA == "") {
                document.getElementById("txtDOA").focus();
                alert("please Select Attendance Date");
                return false;
            }
            var branchname = document.getElementById("ddlbrnch").value;
            if (branchname == null || branchname == "") {
                document.getElementById("ddlbrnch").focus();
                alert("please Select Branch Name");
                return false;
            }
            var Employee_Type = document.getElementById("emp_type").value;
            if (Employee_Type == "EmployeeType" || Employee_Type == "") {
                document.getElementById("emp_type").focus();
                alert("please Select Employee Type ");
                return false;
            }
            var Data = { 'op': 'save_employeeAttendence', 'DOA': DOA, 'branchname': branchname, 'employeeslist': studentslist, 'Employee_Type': Employee_Type };
            var s = function (msg) {
                if (msg && msg != 'false') {
                    alert(msg);
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson_POST(Data, s, e);
        }

        function btnempabsentDetails_click() {
            var fromdate = document.getElementById("txt_abfromdate").value;
            var branchid = document.getElementById("slct_abranch").value;
            var data = { 'op': 'get_employeesabsent_details', 'fromdate': fromdate, 'branchid': branchid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillabsentdetails(msg);
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
        function fillabsentdetails(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;text-align:left"><table class="students-table">';
            results += '<thead><tr><th style="text-align: center;"><i class="fa fa-user" style="font-size:20px;padding-right: 5px;"></i>Employee Name</th><th style="text-align: center;">Employee Code</th><th>Present</th></tr></thead><tbody></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var date = msg[i].Date
                if (msg[i].LogDate != date) {
                    results += '<tr><td class="1" style="text-align: center;">' + msg[i].employee_name + '</td><td style="text-align: center;">' + msg[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input  id="hdnempsno" type="hidden" value="' + msg[i].empsno + '" /><input id="hdnbranchsno" type="hidden" value="' + msg[i].branchid + '" /></td></tr>';
                }
                else {

                }
            }
            results += '</table></div>';
            $("#div_absentemployes").html(results);
        }
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranchworkhours(msg);
                        fillabsentbranch(msg);
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

        function fillbranchworkhours(msg) {
            var data = document.getElementById('slct_branch');
            var length = data.options.length;
            document.getElementById('slct_branch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch";
            opt.value = "Select Branch";
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
        function fillabsentbranch(msg) {
            var data = document.getElementById('slct_abranch');
            var length = data.options.length;
            document.getElementById('slct_abranch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch";
            opt.value = "Select Branch";
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


        function btnempworkhoursDetails_click() {
            var time = document.getElementById('Slct_Time').value;
            var branch = document.getElementById('slct_branch').value;
            var fromdate = document.getElementById('txtfromdate').value;
            var todate = document.getElementById('txttodate').value
            if (fromdate == "") {
                alert("Please select from date");
                return false;
            }
            if (todate == "") {
                alert("Please select to date");
                return false;
            }
            var data = { 'op': 'get_empwork_details_click', 'branch': branch, 'fromdate': fromdate, 'todate': todate, 'time': time };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillWorkingdetails(msg);
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
        function fillWorkingdetails(msg) {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th></th><th scope="col">EmployeeName</th><th scope="col">Start Time</th><th scope="col">End Time</th><th scope="col">WorkingHours</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].StartTime + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].EndTime + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].WorkingHours + '</td></tr>';
            }
            results += '</table></div>';
            $("#divPOdata").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_employeeattdence()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Employee Attendence</a></li>
                         <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="show_empattdncereprt()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Employee Attendence Report</a></li>
                         <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="show_empworkinghours()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Employee Working Hours</a></li>
                         <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="show_empabsentdetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Employee Absent Report</a></li>
                         <li id="Li4" class=""><a data-toggle="tab" href="#" onclick="show_empperdayInOutTime()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; PerDayInOutTime Report</a></li>

                        <%--<li id="Li4" class=""><a data-toggle="tab" href="#" onclick="show_devicedetails()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Device Report</a></li>--%>
                </ul>
            </div>
            <div id="div_empattdance" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Attendence
                    </h3>
                </div>
                <table id="tbl_leavemanagement" align="center">
                    <tr>
                        <td style="height: 40px;">
                            Date <span style="color: red;">*</span>
                        
                            <input type="date" class="form-control" id="txtDOA" class="form-control" style="width: 200px;" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">                                
                                    Company Name                            
                                <select id="selct_Cmpny" class="form-control" onchange="branchnamechange()" style="width: 200px;">
                                    <option selected disabled value="Select state">Select company</option>
                                </select>
                            </td>
                            <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                            Branch Name
                        
                            <select id="ddlbrnch" class="form-control" style="width: 200px;">
                                <option selected disabled value="Select Branch">Select Branch</option>
                            </select>
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                           Employee Type
                        
                            <select id="emp_type" class="form-control" style="width: 200px;" >
                                <option selected disabled value="Select state">EmployeeType</option>
                            </select>
                        </td>

                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">

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
                    <div align="center">
                    <div id="div_imageattdance" style="float:left; padding-left:20px; display:none;">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/attendance.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                                                                    <div>
                                                                    <span style="font-size:20px;font-weight:700;" id="spn_msg"></span>
                                                                    </div >
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
                                    onclick="btn_Finalize_Attendence();" style="width: 180px;" />
                                     </td>
                        </tr>
                    </table>
                </div>
            </div>

          <div id="div_empworkhours" style="display: none;">
            <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Working Hours
                    </h3>
                </div>
             <div runat="server" id="d">
                    <table>
                    <tr>
                      <td style="height: 40px;">
                            TIME
                        </td>
                        <td>
                            <select class="form-control" id="Slct_Time">
                                <option>Select Time</option>
                                <option>Day</option>
                                <option>AM</option>
                                <option>PM</option>
                                </select>
                                </td>
                        <td style="height: 40px;">
                            Branch Name
                        </td>
                        <td>
                            <select id="slct_branch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch">Select Branch</option>
                            </select>
                        </td>
                        <td style="width: 5px;">
                        </td>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtfromdate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                        </td>
                            <td>
                                <label>
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txttodate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnempworkhoursDetails_click()" />
                                    </td>
                            
                        </tr>
                    </table>
                    <div id="divPOdata">
                    </div>
                </div>
        </div>
        <div id="div_employee_attandancereport" style="display: none;">
           <asp:UpdateProgress ID="updateProgress1" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                right: 0; left: 0; z-index: 9999999; background-color: #FFFFFF; opacity: 0.7;">
                <br />
                <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                    AlternateText="Loading ..." ToolTip="Loading ..." Style="padding: 10px; position: absolute;
                    top: 35%; left: 40%;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="updPanel" runat="server">
        <ContentTemplate>
            <section class="content-header">
                <h1>
                    Employee Attendence Report<small>Preview</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
                    <li><a href="#">Employee AttendenceReport</a></li>
                </ol>
            </section>
            <section class="content" style="overflow: inherit; padding-bottom: 129px;">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Attendence Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div align="center">
                            <table>
                                <tr>
                                 <td>
                                            <asp:Label ID="Label2" runat="server" Text="Label">Clowe Leave Days</asp:Label>&nbsp;
                                            <asp:TextBox ID="txt_cl" runat="server" placeholder=" Enter Days" CssClass="form-control" >
                                            </asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label3" runat="server" Text="Label">EmployeeType</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlemptype" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </td>
                                <td>
                                            <asp:Label ID="Label1" runat="server" Text="Label">Branch</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlbranch" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </td>
                                         <td style="width: 6px;">
                            </td>
                                    <td style="overflow:inherit" >
                                        <asp:Label ID="Label4" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_FromDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="dtp_FromDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_Todate" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender2" runat="server" Enabled="True"
                                            TargetControlID="dtp_Todate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Button ID="Button1" runat="server" Text="GENERATE" CssClass="btn btn-primary" OnClick="btn_Generate_Click" /><br />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="hidepanel" runat="server" Visible='false'>
                                <div id="divPrint">
                                    <div style="width: 100%;">
                                        <div style="width: 13%; float: left;">
                                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                        </div>
                                        <div align="center">
                                            <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                            <asp:Label ID="lblAddress" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                             <asp:Label ID="lblbname" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                Text=""></asp:Label><span style="font-size: 18px; font-weight: bold; color: #0252aa;">&nbsp Employee Attendence Register</span><br />
                                        </div>
                                        <table style="width: 80%">
                                            <tr>
                                                <td>
                                                    from Date
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblFromDate" runat="server" ForeColor="Red"></asp:Label>
                                                </td>
                                                <td>
                                                    To date:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbltodate" runat="server"  ForeColor="Red"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                        <div>
                                            <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                GridLines="Both" Font-Bold="true">
                                                <EditRowStyle BackColor="#999999" />
                                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                    Font-Names="Raavi" Font-Size="Small" />
                                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                                <AlternatingRowStyle HorizontalAlign="Center" />
                                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            </asp:GridView>
                                        </div>
                                        <br />
                                        <table style="width: 100%;">

                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">INCHARGE SIGNATURE</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">ACCOUNTS DEPARTMENT</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">AUTHORISED SIGNATURE</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">PREPARED BY</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <br />
                                <br />
                                <asp:Button ID="btnsave" runat="Server" CssClass="btn btn-success" OnClick="btnlogssave_click" Text="Finalize Salary Statement" />
                                <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint('divPrint');"
                                    Text="Print" />
                            </asp:Panel>
                            <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                        </div>
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
        </div>

        <div id="div_absent" style="display: none;">
            <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Absent Details
                    </h3>
                </div>
             <div runat="server" id="Div2">
                    <table>
                    <tr>
                     
                        <td style="height: 40px;">
                            Branch Name
                        </td>
                        <td>
                            <select id="slct_abranch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch">Select Branch</option>
                            </select>
                        </td>
                        <td style="width: 5px;">
                        </td>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txt_abfromdate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                        </td>
                            
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="Button2" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnempabsentDetails_click()" />
                                    </td>
                                
                        </tr>
                    </table>
                    <div id="div_absentemployes">
                    </div>
                </div>
        </div>
        <div id="div_perdayInOut" style="display:none;">
         <asp:UpdateProgress ID="updateProgress2" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                right: 0; left: 0; z-index: 9999999; background-color: #FFFFFF; opacity: 0.7;">
                <br />
                <asp:Image ID="imgUpdateProgress1" runat="server" ImageUrl="thumbnails/loading.gif"
                    AlternateText="Loading ..." ToolTip="Loading ..." Style="padding: 10px; position: absolute;
                    top: 35%; left: 40%;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
         <section class="content-header">
                <h1>
                    Employee Attendence Report<small>Preview</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
                    <li><a href="#">Employee PerDayInOutTime Report</a></li>
                </ol>
            </section>
         <section class="content" style="overflow: inherit; padding-bottom: 129px;">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee PerDayInOutTime Report
                        </h3>
                    </div>
                     <div class="box-body">
                        <div align="center">
                          <table>
                                <tr>
                                 
                                        <td>
                                            <asp:Label ID="Label7" runat="server" Text="Label">EmployeeType</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddl_Emptype_InOutTime" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </td>
                                <td>
                                            <asp:Label ID="Label8" runat="server" Text="Label">Branch</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddl_Branch_InOutTime" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </td>
                                         <td style="width: 6px;">
                            </td>
                                    <td style="overflow:inherit" >
                                        <asp:Label ID="Label9" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_InoutTimeFrmDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender7" runat="server" Enabled="True"
                                            TargetControlID="dtp_InoutTimeFrmDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Label ID="Label10" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_InoutTimeToDate" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender8" runat="server" Enabled="True"
                                            TargetControlID="dtp_InoutTimeToDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Button ID="btn_InOutTime" runat="server" Text="GENERATE" CssClass="btn btn-primary" OnClick="btn_InOutTime_Click" />
                                    </td>
                                </tr>
                            </table>
                          <asp:Panel ID="hidepanelInOutTime" runat="server" Visible='false'>
                           <div id="divInOutTimePrint">
                           <div style="width: 100%;">
                           <div style="width: 13%; float: left;">
                                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                        </div>
                           <div align="center">
                                            <asp:Label ID="lblTitle1" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                            <asp:Label ID="lblAddress1" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                             <asp:Label ID="lblbname1" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                Text=""></asp:Label><span style="font-size: 18px; font-weight: bold; color: #0252aa;">&nbsp Employee PerDay InOutTime Report</span><br />
                                        </div>
                           <table style="width: 80%">
                                            <tr>
                                                <td>
                                                    from Date
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblFromDate1" runat="server" ForeColor="Red"></asp:Label>
                                                </td>
                                                <td>
                                                    To date:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbltodate1" runat="server"  ForeColor="Red"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                           <div>
                                            <asp:GridView ID="gd_PerdayInOutTime" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                GridLines="Both" Font-Bold="true">
                                                <EditRowStyle BackColor="#999999" />
                                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                    Font-Names="Raavi" Font-Size="Small" />
                                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                                <AlternatingRowStyle HorizontalAlign="Center" />
                                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            </asp:GridView>
                           </div>
                           <br />
                           <table style="width: 100%;">

                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">INCHARGE SIGNATURE</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">ACCOUNTS DEPARTMENT</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">AUTHORISED SIGNATURE</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">PREPARED BY</span>
                                                </td>
                                            </tr>
                                        </table>
                           </div>
                           </div>
                           <br />
                           <br />                            
                           <asp:Button ID="btn_InOutTimePrint" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint('divInOutTimePrint');" Text="Print" />
                            </asp:Panel>
                          <asp:Label ID="Lbl_Error_InOutTime" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label> 
                        </div>
                        </div>
                    </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
        </div>

        </div>
    </section>
</asp:Content>
