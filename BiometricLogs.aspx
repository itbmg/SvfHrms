
<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="BiometricLogs.aspx.cs" Inherits="BiometricLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     $(function () {
         get_Branch_details();
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


     function get_Branch_details() {
         var data = { 'op': 'get_Branch_details' };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     // fillbranchdetails(msg);
                     //fillbranchdetails1(msg);
                     fillbranchworkhours(msg)
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
         var data = document.getElementById('selct_branch');
         var length = data.options.length;
         document.getElementById('selct_branch').options.length = null;
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

     var TotalDate = []; var attendancearry = []; var totattendance = []; var emptytable4 = [];
     function btn_employee_click() {
         var branch = document.getElementById("selct_branch").value;
         var fromdate = document.getElementById("txt_fromdate").value;
         var todate = document.getElementById("txt_todate").value;
         if (branch == null || branch == "") {
             document.getElementById("selct_branch").focus();
             alert("please Select branch");
             return false;
         }
         var Data = { 'op': 'get_employeesAttendencebiometric', 'branch': branch, 'fromdate': fromdate, 'todate': todate };
         var s = function (msg) {
             TotalDate = msg[0].Allbiomertcdates;
             totattendance = msg[0].biometricAttendance;
             attendancearry = msg[0].employeebiomeruc;
             var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
             results += '<thead><tr>';
             results += '<th scope="col">Employee Name</th>';
             for (var i = 0; i < TotalDate.length; i++) {
                 results += '<th scope="col" id="txtDate">' + TotalDate[i].Betweendates + '</th>';
             }
             results += '</tr></thead></tbody>';
             for (var i = 0; i < totattendance.length; i++) {
                 var Employeename = totattendance[i].Employeename
                 if (emptytable4.indexOf(Employeename) == -1) {
                     results += '<tr><th scope="row" class="sno">' + totattendance[i].Employeename + '</th>';
                     emptytable4.push(Employeename);
                 }
                 for (var k = 0; k < TotalDate.length; k++) {
                     if (TotalDate[k].Betweendates == totattendance[i].LogDate) {
                         results += '<td>' + totattendance[i].status + '</td>';
                     }
                     else {
                         results += '<td>' + totattendance[i].status + '</td>';
                     }
                 }
                 //             for (var i = 0; i < TotalDate.length; i++) {
                 //                 var tdate = TotalDate[i].Betweendates;
                 //                 results += '<tr>';
                 //                 for (var j = 0; j < totattendance.length; j++) {
                 //                     if (tdate == totattendance[j].LogDate) {
                 //                         results += '<td>"' + totattendance[j].Employeename + '"</td>';
                 //                         results += '<td>"' + totattendance[j].status + '"</td>';
                 //                     }
                 //                 }
                 //             }
             }
             results += '</tr>';
             results += '</table></div>';
             $("#tbl_employeemonthlyattendance").html(results);
         };
         var e = function (x, h, e) {
         };
           callHandler(Data, s, e);
     }
     function btn_cancelApply_click() {
         document.getElementById('divemployee').innerHTML = "";
         document.getElementById('lbl_currentgrade').innerHTML = "...";
         document.getElementById('lbl_currentsection').innerHTML = "...";
          }


//     var TotalDate = []; var attendancearry = []; var totattendance = []; var emptytable4 = [];
//     function btn_employee_click() {
//         var branch = document.getElementById("selct_branch").value;
//         var fromdate = document.getElementById("txt_fromdate").value;
//         var todate = document.getElementById("txt_todate").value;
//         if (branch == null || branch == "") {
//             document.getElementById("selct_branch").focus();
//             alert("please Select branch");
//             return false;
//         }
//         var Data = { 'op': 'get_employeesAttendencebiometric', 'branch': branch, 'fromdate': fromdate, 'todate': todate };
//         var s = function (msg) {
//             TotalDate = msg[0].Alldates;
//             totattendance = msg[0].Attendance;
//             attendancearry = msg[0].Employeemonthlyattendence;
//             var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
//             results += '<thead><tr>';
//             results += '<th scope="col">Employee Name</th>';
//             for (var i = 0; i < TotalDate.length; i++) {
//                 results += '<th scope="col" id="txtDate">' + TotalDate[i].Betweendates + '</th>';
//             }
//             results += '</tr></thead></tbody>';
//             for (var i = 0; i < totattendance.length; i++) {
//                 var Employeename = totattendance[i].Employeename
//                 if (emptytable4.indexOf(Employeename) == -1) {
//                     results += '<tr><th scope="row" class="sno">' + totattendance[i].Employeename + '</th>';
//                     emptytable4.push(Employeename);
//                 }
//                 for (var k = 0; k < TotalDate.length; k++) {
//                     if (TotalDate[k].Betweendates == totattendance[i].LogDate) {
//                         results += '<td><"' + status + '"></td>';
//                     }
//                     else {
//                         results += '<td><"' + status + '"></td>';
//                     }
//                 }
//                 results += '</tr>';
//             }
//             results += '</table></div>';
//             $("#tbl_employeemonthlyattendance").html(results);
//         };
//         var e = function (x, h, e) {
//         };
//         callHandler(Data, s, e);
//     }
     function btn_cancelApply_click() {
         document.getElementById('divemployee').innerHTML = "";
         document.getElementById('lbl_currentgrade').innerHTML = "...";
         document.getElementById('lbl_currentsection').innerHTML = "...";
     }

//     function btn_employee() {

//     }


//     function btnemployeDetails_click() {
//         //document.getElementById('div_students').innerHTML = "";
//         // var DOA = document.getElementById("txtDOA").value;
//         //var branchid = document.getElementById("ddlbrnch").value;
//         //         if (DOA == null || DOA == "") {
//         //             document.getElementById("txtDOA").focus();
//         //             alert("please Select Attendance Date");
//         //             return false;
//         //         }
//         //         if (branchid == null || branchid == "") {
//         //             document.getElementById("ddlbrnch").focus();
//         //             alert("please Select Branch");
//         //             return false;
//         //         }
//         var branch = document.getElementById('slct_branch').value;
//         var fromdate = document.getElementById('txtfromdate').value;
//         var todate = document.getElementById('txttodate').value
//         if (fromdate == "") {
//             alert("Please select from date");
//             return false;
//         }
//         if (todate == "") {
//             alert("Please select to date");
//             return false;
//         }
//         var Data = { 'op': 'get_employeesAttendencebiometric', 'branch': branch, 'fromdate': fromdate, 'todate': todate };
//         var s = function (msg) {
//             if (msg && msg != 'false') {
//                 gradestudentsdata = msg;
//                 var status = "0";
//                 var divstudents = document.getElementById('div_students');
//                 var tablestrctr = document.createElement('table');
//                 //                var Date = document.getElementById("txtDOA").value;
//                 //                var date = Date.toString("dd/MM/yyyy")
//                 tablestrctr.id = "tabledetails";
//                 tablestrctr.setAttribute("class", "students-table");
//                 $(tablestrctr).append('<thead><tr><th>Sno</th><th><i class="fa fa-user" style="font-size:20px;padding-right: 5px;"></i>Employee Name</th><th>RegistrationID</th><th>Present</th></tr></thead><tbody></tbody>');
//                 for (var i = 0; i < gradestudentsdata.length; i++) {
//                     var present = '', absent = '', rename = '', smsstatus = '', Prevsmsstatus = '0';
//                     if (gradestudentsdata[i].attendance_status == "1") {
//                         present = "checked";
//                         smsstatus = '';
//                         Prevsmsstatus = '0';
//                     }
//                     if (gradestudentsdata[i].attendance_status == "2") {
//                         absent = "checked";
//                         if (gradestudentsdata[i].smsstatus == "1") {
//                             smsstatus = "checked";
//                             Prevsmsstatus = '1';
//                         }
//                     }
//                     if (gradestudentsdata[i].attendance_status == "3") {
//                         rename = "checked";
//                         smsstatus = '';
//                         Prevsmsstatus = '0';
//                     }
//                     if (gradestudentsdata[i].attendenceSno != "0") {
//                         status = "1";
//                     }
//                     var j = 0;
//                     j = i + 1;
//                     var date = gradestudentsdata[i].Date
//                     if (date == gradestudentsdata[i].LogDate) {
//                         //$(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td><td>' + gradestudentsdata[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input  id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td><td><input type="radio" class="checkedid" onclick="selectall_checks()"; id="ckbpresent"  value="' + gradestudentsdata[i].empsno + '" checked="' + present + '"></td><td><input class="checkedid" type="radio" onclick="selectall_checks()"; value="' + gradestudentsdata[i].empsno + '" ' + absent + '></td><td><input type="text" style="border:2px solid green;border-radius:4px;" id="txt_remarks" value=""/></tr>');
//                         $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td><td>' + gradestudentsdata[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input  id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td><td><input type="checkbox" class="checkedid" onclick="selectall_checks(this)"; id="ckbpresent"  value="' + gradestudentsdata[i].empsno + '" checked="' + present + '"></td></tr>');
//                     }
//                     else {
//                         $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td><td>' + gradestudentsdata[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td><td><input type="checkbox" class="checkedid" id="ckbpresent" onclick="selectall_checks(this)";  value="' + gradestudentsdata[i].empsno + '"></td></tr>');
//                         //  $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td><td>' + gradestudentsdata[i].registrationid + '</td><td name="idprevsmsstatus" style="display:none"><input id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td><td><input type="radio"  id="ckbpresent" onclick="selectall_checks()";  value="' + gradestudentsdata[i].empsno + '"></td><td><input type="radio" onclick="selectall_checks()"; value="' + gradestudentsdata[i].empsno + '" ' + absent + '></td><td><input type="text" style="border:2px solid green;border-radius:4px;" id="txt_remarks" value=""/></tr>');
//                     }
//                 }
//                 $(tablestrctr).append('<br/>');
//                 $(tablestrctr).append('<br/>');
//                 $(tablestrctr).append('<br/>');
//                 divstudents.appendChild(tablestrctr);
//                 for (var i = 0; i < gradestudentsdata.length; i++) {
//                     if (gradestudentsdata[i].status == "1") {
//                         $('.students-table tr').each(function () {
//                             var studentid = $(this).find(':checkbox');

//                             if (studentid[0].value == gradestudentsdata[i].studentsno) {
//                                 studentid[0].checked = true;
//                             }

//                         });
//                     }
//                 }
//                 //                 document.getElementById("btn_Finalize").style.background = 'Green';
//                 //                 document.getElementById("btn_Finalize").value = 'Finalize Attendance';
//             }
//             else {
//                 document.location = "Default.aspx";
//             }
//         };
//         var e = function (x, h, e) {
//         };
//         callHandler(Data, s, e);
//     }

//     function btnemployeDetails_click() {
//         var branch = document.getElementById('slct_branch').value;
//         var fromdate = document.getElementById('txtfromdate').value;
//         var todate = document.getElementById('txttodate').value
//         if (fromdate == "") {
//             alert("Please select from date");
//             return false;
//         }
//         if (todate == "") {
//             alert("Please select to date");
//             return false;
//         }
//         var data = { 'op': 'get_Biometric_details_click', 'branch': branch, 'fromdate': fromdate, 'todate': todate };
//         var s = function (msg) {
//             if (msg) {
//                 if (msg.length > 0) {
//                     fillWorkingdetails(msg);
//                 }
//             }
//             else {
//             }
//         };
//         var e = function (x, h, e) {
//         };
//         $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//         callHandler(data, s, e);
//     }
//     function fillWorkingdetails(msg) {
//         var k = 1;
//         // var status = "A";
//         var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//         results += '<thead><tr><th scope="col">Sno</th></th><th scope="col">EmployeeName</th><th scope="col">Date</th><th scope="col">End Time</th><th scope="col">WorkingHours</th></tr></thead></tbody>';
//         for (var i = 0; i < msg.length; i++) {
//             //if (status == msg[i].status) {
//             results += '<tr><td>' + k++ + '</td>';
//             results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
//             results += '<td data-title="brandstatus" class="2">' + msg[i].Status + '</td>';
//             results += '<td data-title="brandstatus" class="2">' + msg[i].EndTime + '</td>';
//             results += '<td data-title="brandstatus" class="2">' + msg[i].WorkingHours + '</td></tr>';
//             // results += '<td data-title="brandstatus" class="2">' + msg[i].expiredate + '</td></tr>';
//             //}
//         }
//         results += '</table></div>';
//         $("#divPOdata").html(results);
//     }

        </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            Employee Working Days <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Employee Working Days</a></li>
            <li><a href="#">Employee Working Days</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
<div id="div_Monthlyattdnce" >
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Monthly Attendence
                    </h3>
                </div>
                <table id="mytable" align="center">
                    <tr>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                            Branch Name
                        </td>
                        <td>
                            <select id="selct_branch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Department">Select Department</option>
                            </select>
                        </td>
                        <td style="height: 40px;">
                            From Date <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="date" class="form-control" id="txt_fromdate" class="form-control" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                            TO Date <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="date" class="form-control" id="txt_todate" class="form-control" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <input id="btn_addBrand" type="button" class="btn btn-primary" name="submit" value="Get Employees"
                                onclick="btn_employee_click();" style="width: 100px;">
                        </td>
                    </tr>
                </table>
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Select Employee(s)
                        </h3>
                    </div>
                    <div class="col span_1_of_2">
                        <div id="tbl_employeemonthlyattendance" style="background: #ffffff">
                        </div>
                    </div>
                </div>
                <div style="width: 200px; position: fixed; left: 50%; top: 95%; margin-left: -100px;">
                    <table class="inputstable">
                        <tr>
                            <td>
                            </td>
                            <td>
                                <input id="Button2" type="button" class="btn btn-primary" name="submit" value="Monthly Attendance"
                                    onclick="btn_Finalize_MonthlyAttendence();" style="width: 180px;">
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        </section>
</asp:Content>

