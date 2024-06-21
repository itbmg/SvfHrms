<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Leave_management.aspx.cs" Inherits="Leave_management" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
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
            getleave_TypeDetails();
            get_Employeedetails();
            get_leaveapprv_details();
            //get_allwise_Employeedetails();
            $("#div_leavemangement").css("display", "block");
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = day + "-" + month + "-" + year; 
            $('#dt_fromdate').val(today);
            $('#dt_todate').val(today);
            $('#txtfromdate').val(today);
            $('#txttodate').val(today);
            $('#lbl_date').text(today);
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
        function show_leavemangement() {
            $("#div_approval").css("display", "none");
            $("#div_leavemangement").css("display", "block");
            $("#div_myleave").css("display", "none");
            $("#div_leavreport").css("display", "none");
            //MyleaverequestDetails();
            MyapproveleaverequestDetails();
        }
        function show_Approveleave() {
            $("#div_approval").css("display", "block");
            $("#div_leavemangement").css("display", "none");
            $("#div_myleave").css("display", "none");
            $("#div_leavreport").css("display", "none");
            MyapproveleaverequestDetails();
        }
        function show_myleaverequest() {
            $("#div_approval").css("display", "none");
            $("#div_leavemangement").css("display", "none");
            $("#div_myleave").css("display", "block");
            $("#div_leavreport").css("display", "none");
           // MyleaverequestDetails();
        }
        function show_myleavereport() {
            $("#div_approval").css("display", "none");
            $("#div_leavemangement").css("display", "none");
            $("#div_myleave").css("display", "none");
            $("#div_leavreport").css("display", "block");
           // MyleaverequestDetails();
        }
        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#Slct_emp').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                    $('#slct_reporting').autocomplete({
                        source: empnameList,
                        change: subemployeenamechange,
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
            var empname = document.getElementById('Slct_emp').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_empid').value = employeedetails[i].empsno;
                }
            }
        }
        function subemployeenamechange() {
            var empname = document.getElementById('slct_reporting').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_repempid').value = employeedetails[i].empsno;
                }
            }
        }
        function GetDays() {
            var dropdt = new Date(document.getElementById("dt_fromdate").value);
            var pickdt = new Date(document.getElementById("dt_todate").value);
            days = parseInt((pickdt - dropdt) / (24 * 3600 * 1000));
            totaldays = days + 1;
            return totaldays;
        }
        function cal() {
            if (document.getElementById("dt_todate")) {
                document.getElementById("txt_days").value = GetDays();
            }

        }
        function leavedetails_save() {
            var empid = document.getElementById('txt_empid').value;
            if (empid == "") {
                alert("Select employename ");
                return false;
            }
            var leaveType = document.getElementById('slct_leavetype').value;
            if (leaveType == null || leaveType == "" || leaveType == "Select leave type") {
                document.getElementById("slct_leavetype").focus();
                alert("leaveType  must be filled out");
                return false;
            }
            var MobileNumber = document.getElementById('txt_num').value;
            if (MobileNumber == null || MobileNumber == "") {                
                alert("Please Enter Mobile Number");
                return false;
            }
            var fromdate = document.getElementById('dt_fromdate').value;
            if (fromdate == null || fromdate == "") {
                document.getElementById("dt_fromdate").focus();
                alert("FromDate  must be filled out");
                return false;
            }
            var todate = document.getElementById('dt_todate').value;
            if (todate == null || todate == "") {
                document.getElementById("dt_todate").focus();
                alert("ToDate  must be filled out");
                return false;
            }
            var totaldays = document.getElementById('txt_days').value;
            var reason = document.getElementById('txt_reason').value;
            if (reason == null || reason == "") {
                document.getElementById("txt_reason").focus();
                alert("Reason  must be filled out");
                return false;
            }
            var reportingempid = document.getElementById('txt_repempid').value;
            if (reportingempid == "") {
                alert("Select Reporting Employename ");
                return false;
            }
            var data = { 'op': 'leavedetails_save', 'leaveType': leaveType, "operation": operation, "fromdate": fromdate, "todate": todate, 'MobileNumber': MobileNumber, 'reason': reason, 'totaldays': totaldays, 'reportingempid': reportingempid, 'empid': empid, 'leavetypesno': leavetypesno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        btn_cancel_click();
                        MyapproveleaverequestDetails();
                    }
                }
                else {
                    //document.location = "Default.aspx";
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        var data_leadNames;
        function getleave_TypeDetails() {
            var data = { 'op': 'get_leavetype_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillleavetypes(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillleavetypes(msg) {
            var data = document.getElementById('slct_leavetype');
            var length = data.options.length;
            document.getElementById('slct_leavetype').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select leave type";
            opt.value = "Select leave type";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].leavetypecode != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].leavetypecode;
                    option.value = msg[i].leavetypeId;
                    data.appendChild(option);
                }
            }
        }
        function btn_cancel_click() {
            document.getElementById('txt_empid').value = "";
            document.getElementById('Slct_emp').value = "";
            document.getElementById('tbl_leavemanagement').value = "";
            document.getElementById('slct_leavetype').selectedIndex = 0;
            document.getElementById('txt_num').value = "";
            document.getElementById('dt_fromdate').value = "";
            document.getElementById('dt_todate').value = "";
            document.getElementById('txt_reason').value = "";
            document.getElementById('txt_days').value = "";
            document.getElementById('slct_reporting').value = "";
            document.getElementById('txt_repempid').value = "";
            sessionsno = null;
            operation = "SAVE";
        }
        var leavetypesno;
        var operation = "SAVE";
        function updateclick(thisid) {
            var selectedrow = $(thisid).closest('tr');
            sessionsno = selectedrow[0].cells[0].innerHTML;
            operation = "MODIFY";
            document.getElementById('txt_sessionname').value = selectedrow[0].cells[1].innerHTML;
            document.getElementById('dt_session1').value = selectedrow[0].cells[2].innerHTML
            document.getElementById('dt_session2').value = selectedrow[0].cells[3].innerHTML
            if (selectedrow[0].cells[4].innerHTML == "Enable") {
                document.getElementById('slct_status1').value = "1";
            }
            else {
                document.getElementById('slct_status1').value = "0";
            }
            document.getElementById('rank1').value = selectedrow[0].cells[5].innerHTML
            if (selectedrow[0].cells[6].innerHTML == "Y") {
                document.getElementById('slct_status2').value = "1";
            }
            else {
                document.getElementById('slct_status2').value = "0";
            }
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)
                return false;
            return true;
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function CloseClick() {
            $('#divMainAddNewRow').css('display', 'none');
        }
        function MyapproveleaverequestDetails() {
            var table = document.getElementById("tbl_Sessioncategorylist");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            //var status = "MyLeaveRequest";
            var data = { 'op': 'MyleaverequestDetails' };
            var s = function (msg) {
                if (msg) {
                    var getSessionDetails = msg;
                    var COLOR = ["beige", "Aqua", "Aquamarine", "Azure", "Bisque"];
                    var k = 0;
                    for (var i = 0; i < getSessionDetails.length; i++) {
                        if (getSessionDetails[i].sno != null) {
                            var sno = getSessionDetails[i].sno;
                            var Employeename = getSessionDetails[i].empname;
                            var leave_type = getSessionDetails[i].leave_type;
                            var fromdate = getSessionDetails[i].fromdate;
                            var todate = getSessionDetails[i].todate;
                            var leave_days = getSessionDetails[i].leave_days;
                            var status = getSessionDetails[i].status;
                            var Reporting_manager = getSessionDetails[i].Reporting_manager;
                            var approved_by = getSessionDetails[i].aproved_by;
                            var remarks = getSessionDetails[i].remarks;
                            var tablerowcnt = document.getElementById("tbl_Sessioncategorylist").rows.length;
                            $('#tbl_Sessioncategorylist').append('<tr style="background-color:' + COLOR[k] + '"><td style="display:none;" data-title="sno">' + sno + '</td><td data-title="Employeename">' + Employeename + '</td><td  data-title="leave_type">' + leave_type + '</td><td data-title="fromdate">' + fromdate + '</td><td data-title="todate">' + todate + '</td><td data-title="leave_days">' + leave_days + '</td><td data-title="status">' + status + '</td><td data-title="Reporting_manager">' + Reporting_manager + '</td><td style="display:none;" data-title="Reporting_manager">' + remarks + '</td><td style="display:none;" data-title="Reporting_manager">' + approved_by + '</td><td><input type="button" class="btn btn-primary" name="Update" value =" For Approval" onclick="updateclick(this);"/></td></tr>');
                            k++;
                        }
                    }
                }
                else {
                    document.location = "Default.aspx";
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        leaveapplicationid = 0;
        fromdate = 0;
        todate = 0;
        function updateclick(thisid) {
            $('#divMainAddNewRow').css('display', 'block');
            var row = $(thisid).parents('tr');
            var sno = row[0].cells[0].innerHTML;
            var leave_type = row[0].cells[2].innerHTML;
            var fromdate = row[0].cells[3].innerHTML;
            var todate = row[0].cells[4].innerHTML;
            var leave_days = row[0].cells[5].innerHTML;
            var status = row[0].cells[6].innerHTML;
            var Reporting_to = row[0].cells[7].innerHTML;
            var remarks = row[0].cells[8].innerHTML;
            var Employeename = row[0].cells[1].innerHTML;

            document.getElementById('spnName').innerHTML = leave_type;
            document.getElementById('Spnrep').innerHTML = Reporting_to;
            document.getElementById('spnfromdate').value = fromdate;
            document.getElementById('spntodate').value = todate;
            document.getElementById('spn_days').value = leave_days;
            document.getElementById('Spnreason').innerHTML = remarks;
            document.getElementById('spnAprveremarks').value = "";
            leaveapplicationid = sno;
        }
        function GetDays1() {
            var dropdt = new Date(document.getElementById("spnfromdate").value);
            var pickdt = new Date(document.getElementById("spntodate").value);
            days = parseInt((pickdt - dropdt) / (24 * 3600 * 1000));
            totaldays = days + 1;
            return totaldays;
        }
        function caldays() {
            if (document.getElementById("spntodate")) {
                document.getElementById("spn_days").value = GetDays1();
            }
        }
        function save_approve_leave_click() {
            var fromdate = document.getElementById('spnfromdate').value;
            var todate = document.getElementById('spntodate').value;
            var leave_days = document.getElementById('spn_days').value;
            var approve_remarks = document.getElementById('spnAprveremarks').value;
            var data = { 'op': 'save_approve_leave_click', 'leaveapplicationid': leaveapplicationid, 'fromdate': fromdate, 'todate': todate, 'leave_days': leave_days, 'approve_remarks': approve_remarks };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        $('#divMainAddNewRow').css('display', 'none');
                        MyapproveleaverequestDetails();
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
        function save_Reject_leave_click() {
            var approve_remarks = document.getElementById('spnAprveremarks').value;
            var data = { 'op': 'save_Reject_leave_click', 'leaveapplicationid': leaveapplicationid, 'approve_remarks': approve_remarks };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        $('#divMainAddNewRow').css('display', 'none');
                        MyapproveleaverequestDetails();
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
        function btnleaveDetails_click() {
            //        function MyleaverequestDetails() {
            var fromdate = document.getElementById('txtfromdate').value;
            var todate = document.getElementById('txttodate').value
            var table = document.getElementById("tbl_Sessioncategorylist1");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var status = "MyLeaveRequest";
            var data = { 'op': 'MyleaverequestDetails', 'status': status, 'fromdate': fromdate, 'todate': todate };
            var s = function (msg) {
                if (msg) {
                    var getSessionDetails = msg;
                    var l = 0;
                    var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
                    for (var i = 0; i < getSessionDetails.length; i++) {
                        if (getSessionDetails[i].sno != null) {
                            var sno = getSessionDetails[i].sno;
                            var Employeename = getSessionDetails[i].empname;
                            var leave_type = getSessionDetails[i].leave_type;
                            var fromdate = getSessionDetails[i].fromdate;
                            var todate = getSessionDetails[i].todate;
                            var status = getSessionDetails[i].status;

                            var leave_days = getSessionDetails[i].leave_days;
                            var Reporting_manager = getSessionDetails[i].Reporting_manager;
                            var approved_by = getSessionDetails[i].aproved_by;
                            var tablerowcnt = document.getElementById("tbl_Sessioncategorylist1").rows.length;
                            $('#tbl_Sessioncategorylist1').append('<tr style="background-color:' + COLOR[l] + '"><td style="display:none;" data-title="sno">' + sno + '</td><td data-title="Employeename">' + Employeename + '</td><td  data-title="leave_type">' + leave_type + '</td><td data-title="fromdate">' + fromdate + '</td><td data-title="todate">' + todate + '</td><td data-title="leave_days">' + leave_days + '</td><td data-title="status">' + status + '</td><td data-title="Reporting_manager">' + Reporting_manager + '</td><td style="display:none;" data-title="Reporting_manager">' + approved_by + '</td></tr>');
                            l = l + 1;
                            if (l == 4) {
                                l = 0;
                            }
                        }
                    }
                }
                else {
                    document.location = "Default.aspx";
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
            //}
        }
        function checkLength() {
            var textbox = document.getElementById("txt_num");
            if (textbox.value.length == 10) {                
            }
            else {
                alert("Enter 10 Digit Valid Phone Number");
                return false;
            }
        }
        function get_leaveapprv_details() {
            var data = { 'op': 'get_leaveapprv_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillleavedetails(msg);
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
        function fillleavedetails(msg) {
            var k = 1;
            var j = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Sno</th><th scope="col" >Employe Name</th><th scope="col"><i class="fa fa-user"></i>Leave Type</th><th scope="col">From Date</th><th scope="col">To Date</th><th scope="col">Total leave days</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                results += '<tr><td> <button type="button" title="Click Here To Print!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5" style="color: #68d2ec; border-color: #00acd6;border-radius: 100% !important;padding:0px !important;height:30px !important;width:30px !important;"  onclick="getmeprint(this)"><span class="glyphicon glyphicon-print" style="top: 0px !important;"></span></button></td>';
                //k++;
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].employee_no + '</th>';
                results += '<td  class="2">' + msg[i].department + '</td>';
                results += '<td data-title="Code" class="3">' + msg[i].fromdate + '</td>';
                results += '<td data-title="Code" class="4">' + msg[i].todate + '</td>';
                results += '<td data-title="Code" class="5">' + msg[i].NoOfdays + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].description + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].request_to + '</td>';
                results += '<td data-title="Code" style="display:none" class="8">' + msg[i].designation + '</td>';
                results += '<td style="display:none" class="9" >' + msg[i].branchcode + '' + j++ + '</td>';
                results += '<td style="display:none" class="10" >' + msg[i].leavetype + '' + j++ + '</td>';
                results += '<td style="display:none" class="11" >' + msg[i].mobilenum + '' + j++ + '</td>';
            }
            results += '</table></div>';
            $("#div_leavemngmnt").html(results);
        }
        function getmeprint(thisid) {
            $('#myModal').css('display', 'block');
            $('#divPrints').css('display', 'block');
            var employee_no = $(thisid).parent().parent().children('.1').html();
            var department = $(thisid).parent().parent().children('.2').html();
            var fromdate = $(thisid).parent().parent().children('.3').html();
            var todate = $(thisid).parent().parent().children('.4').html();
            var NoOfdays = $(thisid).parent().parent().children('.5').html();
            var description = $(thisid).parent().parent().children('.6').html();
            var request_to = $(thisid).parent().parent().children('.7').html();
            var designation = $(thisid).parent().parent().children('.8').html();
            var branchcode = $(thisid).parent().parent().children('.9').html();
            

            document.getElementById('lblempname').innerHTML = employee_no;
            document.getElementById('lblEmpID').innerHTML = department;
            document.getElementById('lblleavedays').innerHTML = NoOfdays;
            document.getElementById('lblfromdt').innerHTML = fromdate;
            document.getElementById('lbltodates').innerHTML = todate;
            document.getElementById('lblrefrenceno').innerHTML = description;
            document.getElementById('lbldisgn').innerHTML = designation;
            document.getElementById('lblbrnch').innerHTML = branchcode;

            //convertNumberToWords(value);
        }
        function closepopup(msg) {
            $("#myModal").css("display", "none");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Leave Management<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Leave Management</a></li>
            <li><a href="#">Leave Management</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
    <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_leavemangement()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Leave Management Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_Approveleave()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Approve Details</a></li>
                             <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="show_myleaverequest()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;My Leave Request Details</a></li>
                            <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="show_myleavereport()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Leave Details</a></li>
                    </ul>
                </div>
                <div id="div_leavemangement" style="display: none;">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Leave Request Form Details
            </h3>
        </div>
        <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Iconimages/leavemangement.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 20%;" />
                                                                    </div>
        <div>
            <table id="tbl_leavemanagement" class="inputstable" align="center">
            <tr>
                    <td style="height: 40px;">
                        Employee Name
                    </td>
                    <td>
                    <input type="text" class="form-control" id="Slct_emp" placeholder="Enter Employee Name" />
                        <%--<select class="form-control" id="Slct_emp" >
                        </select>--%>
                    </td>
                     <td style="height: 40px; display: none">
                            <input id="txt_empid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                            Leave Type <span style="color: red;">*</span>
                    </td>
                    <td>
                        <select class="form-control" id="slct_leavetype" >
                        </select>
                    </td>
                    <td>
                            Mobile Number <span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="text" id="txt_num" class="form-control only_no" placeholder="Enter Mobile Number" value="" onblur="checkLength()" onkeypress="return isNumber(event)">
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                            From Date <span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="date" id="dt_fromdate" class="form-control"  value="">
                    </td>
                    <td>
                            To Date <span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="date" id="dt_todate" class="form-control" onchange="cal();"
                            value="">
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                        Total Leave Days
                    </td>
                    <td>
                        <input type="text" id="txt_days" class="form-control" value="1" placeholder="Enter Total Leave Days"  >
                    </td>
                    <td>
                            Reporting To <span style="color: red;">*</span>
                    </td>
                    <td>
                    <input type="text" class="form-control" id="slct_reporting" placeholder="Enter Employee Name" />
                      <%--  <select class="form-control" id="slct_reporting" >
                        </select>--%>
                    </td>
                     <td style="height: 40px; display: none">
                            <input id="txt_repempid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                            Reason For Leave <span style="color: red;">*</span>
                    </td>
                    <td >
                        <textarea cols="35" rows="3" id="txt_reason"  placeholder="Enter Reason" class="form-control"></textarea>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr style="height: 10px;">
                </tr>
                <tr>
                    <td>
                    </td>
                    <td style="height: 40px;">
                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="leavedetails_save();" >
                        <input id="btn_cancel" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="btn_cancel_click();" >
                    </td>
                </tr>
            </table>
            <div id="div_leavemngmnt"></div>
            <table>
                <tr>
                      
                </tr>
            </table>
            <div class="modal" id="myModal" role="dialog" style="overflow:auto;">
    <div class="modal-dialog">
      <!-- Modal content-->
     
      <div class="modal-content">
        <div class="modal-header" >
        
         
        </div>
        <div class="modal-body">
           <div id="divPrints" style="display:none">
                    <div style="width: 23%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                    <br />
                    <div>
                        <div align="center"  style="font-family: Arial; font-size: 18pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Foods Pvt Ltd </span>
                            <br />
                        </div>
                        <span style="text-align:center; padding-left:5%;">
                        Survey No.381-2, Punabaka (V), Pellakur (M), SPSR Nellore Dt - 524129.</span>
                         <span style="text-align:center; padding-left:19%;">Phone: 9440622077, Fax: 044 – 26177799.</span>
                    </div>
                    <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 26px; font-weight: bold;"><u>Leave Form </u></span>
                    </div>
                    <div style="width: 100%;">
                        <table style="width: 100%;">
                        <tr>

                                <td style="float: left;padding-left: 30%;">
                                  <label class="control-label" >
                                        No :</label>
                                    <span id="lblbrnch"></span>
                                    <br />
                                </td>
                                <td colspan="2">
                                </td>
                                     <td style="float: right;padding-right: 30%;">
                                    <label class="control-label" >
                                        Date :</label>
                                    <span id="lbl_date"></span>
                                    <br />
                                </td>

                        </tr>
                        <tr>
                        <td style="height:15px;"></td>
                        </tr>
                            <tr>
                              <td colspan="2"><label class="control-label" >
                                       <b>Name :</b> </label>
                                    <span id="lblempname"></span></td>
                                <td >
                                    <label class="control-label" >
                                      <b>Department :</b>  </label>
                                    <span id="lblEmpID"></span>
                                    </td>
                                    
                                    <td>
                                 <label class="control-label" >
                                       <b>Designation:</b> </label>
                                    <span id="lbldisgn"></span>
                                    </td>
                                <td>
                                </tr>
                                <tr>
                                <td>
                                    <label class="control-label" >
                                      <b> Leave from :</b></label>
                                    <span id="lblfromdt"></span>
                                    <br />
                                </td>
                                    <td></td>
                                    <td>
                                    <label class="control-label" >
                                       <b>Leave To :</b></label>
                                    <span id="lbltodates"></span>
                                    <br />
                                </td>
                              <td colspan="2">
                                       <label class="control-label" >
                                             <b>No of Days :</b></label>
                                        <span id="lblleavedays"></span>
                                        <br />
                                    </td>
                                    </tr>
                                    <tr>
                                    <td colspan="2">
                                       <label class="control-label" >
                                             <b>Purpose :</b></label>
                                        <span id="lblrefrenceno"></span>
                                        <br />
                                    </td>
                             </tr>
                           <tr>
                           </tr>
                        </table>
                    </div>
                    <br />
                    <br />
                     
                     <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">Employee Sig </span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 13px;">Dept Head  </span>
                            </td>
                            <td style="width: 19%;">
                                <span style="font-weight: bold; font-size: 13px;">H.R.D</span>
                            </td>
                              <td style="width: 19%;">
                                <span style="font-weight: bold; font-size: 12px;">Manager</span>
                            </td>
                              <td style="width: 27%;">
                                <span style="font-weight: bold; font-size: 12px;">Authorised By</span>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <br />                   
                </div>
                
                <asp:Label ID="Label2" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
        </div>
        <div class="modal-footer">
         <input id="Button3" type="button" class="btn btn-primary" name="submit" value='Print'
                    onclick="javascript:CallPrint('divPrints');" />
          <button type="button" class="btn btn-default" id="close" onclick="closepopup();">Close</button>
        </div>
      </div>
      
    </div>
  </div>
        </div>
        </div>
        <div id="div_approval" style="display: none;">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Requests  Details
            </h3>
        </div>
        <div  style="overflow:auto;">
        <table class="table table-bordered table-hover dataTable no-footer"  aria-describedby="example2_info" ID="tbl_Sessioncategorylist">'
            <%--<table id="tbl_Sessioncategorylist" class="responsive-table">--%>
                <thead>
                    <tr>
                      <%--  <th scope="col">
                            Sno
                        </th>--%>
                         <th scope="col">
                         Employee Name
                         </th>
                        <th scope="col">
                            Leave Type
                        </th>
                        <th scope="col">
                            From Date
                        </th>
                        
                         <th scope="col">
                            To Date
                        </th>
                        <th scope="col">
                           Total Days
                        </th>
                        <th scope="col">
                            Status
                        </th>
                        <th scope="col">
                            Reporting to
                        </th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
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
                            Leave Type
                        </td>
                        <td style="height: 40px;">
                            <span id="spnName" class="form-control"></span>
                        </td>
                        <td>
                            Reporting To
                        </td>
                        <td style="height: 40px;">
                            <span id="Spnrep" class="form-control"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            From Date
                        </td>
                        <td style="height: 40px;">
                            <input id="spnfromdate" type="date"class="form-control" value="" />
                        </td>
                          <td>
                            To Date
                        </td>
                        <td style="height: 40px;">
                            <input id="spntodate" type="date" class="form-control" onchange="caldays();" value="" />
                        </td>
                    </tr>
                    <tr>
                    <td>
                            No Of Days
                        </td>
                        <td style="height: 40px;">
                            <input id="spn_days"  class="form-control" />
                        </td>
                        <td>
                            Remarks
                        </td>
                        <td style="height: 40px;">
                            <span id="Spnreason" class="form-control"></span>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            Approve Remarks
                        </td>
                        <td style="height: 40px;">
                            <input id="spnAprveremarks" type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" class="btn btn-primary" id="btn_aprrovesave" value="Approve" onclick="save_approve_leave_click();" />
                        </td>
                        <td>
                            <input type="button" class="btn btn-danger" id="btn_rejcancel" value="Reject" onclick="save_Reject_leave_click();" />
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
    <div id="div_myleave" style="display: none;">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>My Leave Request Details
            </h3>
        </div>
        <div >
         <table align="center">
                        <tr>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtfromdate" class="form-control" />
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
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnleaveDetails_click()" />
                            </td>
                        </tr>
                    </table>
            <table id="tbl_Sessioncategorylist1" class="table table-bordered table-hover dataTable no-footer">
                <thead>
                    <tr>
                      <%--  <th scope="col">
                            Sno
                        </th>--%>
                         <th scope="col">
                         Employee Name
                         </th>
                        <th scope="col">
                            Leave Type
                        </th>
                        <th scope="col">
                            From Date
                        </th>
                        
                         <th scope="col">
                            To Date
                        </th>
                        <th scope="col">
                           Total Days
                        </th>
                        <th scope="col">
                            Status
                        </th>
                        <th scope="col">
                            Reporting To
                        </th>
                        
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <div id="div_leavreport" style="display: none;">
        <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Leave Report
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <div>
                            <div align="center">
                                <table>
                                    <tr>
                                     <td>
                                            <asp:Label ID="Label1" runat="server" Text="Label">Branch</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlbranch" runat="server" class="form-control">
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 6px;">
                            </td>

                             <td>
                                        <asp:Label ID="Label4" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="txtFromdate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="txtFromdate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                    <td style="width: 6px;">

                            </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="txtTodate" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender2" runat="server" Enabled="True"
                                            TargetControlID="txtTodate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                            <td style="width: 6px;">
                            </td>
                                        <td>
                                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                                OnClick="btn_Generate_Click" /><br />
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
                                                 <asp:Label ID="lblHeading" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                    <br />
                                                     <td>
                                            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                                        </td>
                                               <%-- <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                                            <table style="width: 80%">
                                                <tr>
                                                    <td>
                                                        From Date
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblFromDate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                    <td>
                                                        To date:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lbltodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div >
                                                <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                    GridLines="Both" Font-Bold="true" OnRowDataBound="grdReports_RowDataBound">
                                                    <EditRowStyle BackColor="#999999" />
                                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                        Font-Names="Raavi" Font-Size="Small" />
                                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" Height="40px"/>
                                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                </asp:GridView>
                                            </div>
                                            <br />
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                   <%-- <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-success" OnClientClick="javascript:CallPrint('divPrint');"
                                        Text="Print" />--%>
                                        <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                </asp:Panel>
                                <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
    </div>
    </div>
    </section>
</asp:Content>
