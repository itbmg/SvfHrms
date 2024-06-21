<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="LeaveManagementAndOdApply.aspx.cs" Inherits="LeaveManagementAndOdApply" %>

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
            ShowLeaveManagementDetails();

            //---leave management---//
            getleave_TypeDetails1();
            get_leaveEmployeedetails();
            show_leavemangement();
            get_leaveapprv_details();
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

            //---Od Approval----//

            $('#btn_addBrand').click(function () {
                $('#fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_Deptdata').hide();
                get_edit_OD_details();
                get_odEmployeedetails();
                ODrequestDetails();
                Get_odFixedrows();
                var date = new Date();
                var day = date.getDate();
                var month = date.getMonth() + 1;
                var year = date.getFullYear();
                if (month < 10) month = "0" + month;
                if (day < 10) day = "0" + day;
                today = year + "-" + month + "-" + day;
                $('#dt_fromdate').val(today);
                $('#dt_todate').val(today);
                $('.txt_dateentry').val(today);
                $('.txt_exitdate').val(today);
                $('.txt_repartngdate').val(today);
                $('#txtfromdate').val(today);
                $('#txttodate').val(today);
                $('#txtrpt_fromdate').val(today);
                $('#txtrpt_todate').val(today);
            });
            $('#Button5').click(function () {
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_Deptdata').show();
                btn_cancel_click();
            });
            get_edit_OD_details();
            get_odEmployeedetails();
            $("#div_Od").css("display", "block");

            //--- canteen attendance details ---//
            canteen_branchdetails();

            $('#div_Deptdata').css('display', 'block');
            //            $("#div_canteenattdncdetails").show();

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

        function ShowLeaveManagementDetails() {
            $("#Div_leavedetails").show();
            $("#div_odapplydetails").hide();
            $("#div_canteenattdncdetails").hide();
        }
        function ShowOdApplayDetails() {
            $("#Div_leavedetails").hide();
            $("#div_odapplydetails").show();
            $("#show_odmaster").show();
            $("#div_Od").show();
//            $("#div_Deptdata").show();
            $("#div_canteenattdncdetails").hide();
        }
        function ShowCanteenAttDetails() {
            $("#Div_leavedetails").hide();
            $("#div_odapplydetails").hide();
            $("#div_canteenattdncdetails").show();
            $("#show_canteenDetails").show();
            
        }

        //-------------Leave Management Details-------------//

        function show_leavemangement() {
            $("#div_approval").css("display", "none");
            $("#div_leavemangement").css("display", "block");
            $("#div_myleave").css("display", "none");
            $("#div_leavreport").css("display", "none");
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
        }
        function show_myleavereport() {
            $("#div_approval").css("display", "none");
            $("#div_leavemangement").css("display", "none");
            $("#div_myleave").css("display", "none");
            $("#div_leavreport").css("display", "block");
        }
        var employeedetails = [];
        function get_leaveEmployeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#Slct_leaveemp1').autocomplete({
                        source: empnameList,
                        change: lvemployeenamechange,
                        autoFocus: true
                    });
                    $('#slct_leavereporting').autocomplete({
                        source: empnameList,
                        change: lvsubemployeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function lvemployeenamechange() {
            var empname = document.getElementById('Slct_leaveemp1').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_empid').value = employeedetails[i].empsno;
                }
            }
        }
        function lvsubemployeenamechange() {
            var empname = document.getElementById('slct_leavereporting').value;
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
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        var data_leadNames;
        function getleave_TypeDetails1() {
            var data = { 'op': 'get_leavetype_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_leavetype1(msg);
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
        function fill_leavetype1(msg) {
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
            document.getElementById('Slct_leaveemp1').value = "";
            document.getElementById('tbl_leavemanagement').value = "";
            document.getElementById('slct_leavetype').selectedIndex = 0;
            document.getElementById('txt_num').value = "";
            document.getElementById('dt_fromdate').value = "";
            document.getElementById('dt_todate').value = "";
            document.getElementById('txt_reason').value = "";
            document.getElementById('txt_days').value = "";
            document.getElementById('slct_leavereporting').value = "";
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
                        fillleave_apprldetails(msg);
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
        function fillleave_apprldetails(msg) {
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
        }
        function closepopup(msg) {
            $("#myModal").css("display", "none");
        }


        //------------- OD approve Details -------------//


        function show_odmaster() {
            $("#div_Od").css("display", "block");
            $("#div_OdApproval").css("display", "none");
            $("#div_myod").css("display", "none");
            $("#div_report").css("display", "none");
            $("#div_Deptdata").show();
            $("#showlogs").show();
            ODrequestDetails();
            get_edit_OD_details();
        }

        function show_odApprove() {
            $("#div_OdApproval").css("display", "block");
            $("#div_Od").css("display", "none");
            $("#div_myod").css("display", "none");
            $("#div_report").css("display", "none");
            $("#div_Deptdata").hide();
            $("#showlogs").hide();
            $("#div_1").hide();
            ODrequestDetails();

        }

        function show_myodrequest() {
            $("#div_OdApproval").css("display", "none");
            $("#div_Od").css("display", "none");
            $("#div_myod").css("display", "block");
            $("#div_report").css("display", "none");
            $("#div_Deptdata").hide();
            $("#showlogs").hide();
            $("#div_1").hide();
        }
        function show_odreport() {
            $("#div_OdApproval").css("display", "none");
            $("#div_Od").css("display", "none");
            $("#div_myod").css("display", "none");
            $("#div_report").css("display", "block");
            $("#div_Deptdata").hide();
            $("#showlogs").hide();
            $("#div_1").hide();
        }
        var employeedetails = [];
        function get_odEmployeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#slct_odemploye').autocomplete({
                        source: empnameList,
                        change: odemployee_namechange,
                        autoFocus: true
                    });
                    $('#slct_odreporting').autocomplete({
                        source: empnameList,
                        change: odsubemployee_namechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function odemployee_namechange() {
            var empname = document.getElementById('slct_odemploye').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_empid').value = employeedetails[i].empsno;
                    document.getElementById('txtempcode').value = employeedetails[i].empnum;
                }
            }
        }
        function odsubemployee_namechange() {
            var empname = document.getElementById('slct_odreporting').value;
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
        function Get_odFixedrows() {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sr.No</th><th scope="col">Place of the Duty</th><th scope="col">Date of Entry</th><th scope="col">Purpose of Duty</th><th scope="col">Date of Exit</th><th scope="col">Reporting Manager Comments</th><th scope="col">Signature of Reporting Manager with Date</th></tr></thead></tbody>';
            for (var i = 1; i < 6; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_branchname" type="text" class="form-control" placeholder= "duty"  /></td>';
                results += '<td ><input id="txt_dateentry" type="date" class="form-control txt_dateentry"   /></td>';
                results += '<td ><input id="txt_purpose" type="text"  class="form-control"  placeholder= "Pupose"   /></td>';
                results += '<td ><input id="txt_exitdate" type="date"  class="form-control txt_exitdate"  placeholder= "Comments"   /></td>';
                results += '<td ><input id="txt_comments" type="text"  class="form-control"  placeholder= "Comments"  /></td>';
                results += '<td ><input id="txt_repartngdate" type="date"  class="form-control txt_repartngdate"   /></td>';
                results += '<td ><input id="txt_sno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_Griddata").html(results);
        }
        var DataTable;
        function odinsertrow() {
            DataTable = [];
            var txtsno = 0;
            branch = 0;
            dateofentry = 0;
            purpose = 0;
            dateofexit = 0;
            comments = 0;
            reportingdate = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                txtsno = rowsno;
                branch = $(this).find('#txt_branchname').val();
                dateofentry = $(this).find('#txt_dateentry').val();
                purpose = $(this).find('#txt_purpose').val();
                dateofexit = $(this).find('#txt_exitdate').val();
                comments = $(this).find('#txt_comments').val();
                reportingdate = $(this).find('#txt_repartngdate').val();
                sno = $(this).find('#txt_sno').val();
                DataTable.push({ Sno: txtsno, branch: branch, dateofentry: dateofentry, purpose: purpose, dateofexit: dateofexit, comments: comments, reportingdate: reportingdate, sno: sno });
                rowsno++;

            });
            branch = 0;
            dateofentry = 0;
            purpose = 0;
            dateofexit = 0;
            comments = 0;
            reportingdate = 0;
            sno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, branch: branch, dateofentry: dateofentry, purpose: purpose, dateofexit: dateofexit, comments: comments, reportingdate: reportingdate, sno: sno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sr.No</th><th scope="col">Place of the Duty</th><th scope="col">Date of Entry</th><th scope="col">Purpose of Duty</th><th scope="col">Date of Exit</th><th scope="col">Reporting Manager Comments</th><th scope="col">Signature of Reporting Manager with Date</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txt_branchname" type="text"   style="width:90px;" placeholder= "branchname"   value="' + DataTable[i].branch + '"/></td>';
                results += '<td ><input id="txt_dateentry" type="date" class="form-control" style="width:120px;"  value="' + DataTable[i].dateofentry + '"/></td>';
                results += '<td ><input id="txt_purpose"  type="text" class="form-control"   style="width:90px;"placeholder= "Pupose"  value="' + DataTable[i].purpose + '"/></td>';
                results += '<td ><input id="txt_exitdate"  type="date" class="form-control"   style="width:120px;" value="' + DataTable[i].dateofexit + '"/></td>';
                results += '<td ><input id="txt_comments" type="text" class="form-control"  style="width:90px;" placeholder= "comments"  value="' + DataTable[i].comments + '"/></td>';
                results += '<td ><input id="txt_repartngdate" type="date" class="form-control"  style="width120px;" value="' + DataTable[i].reportingdate + '"/></td>';
                results += '<th data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + DataTable[i].sno + '" ></input>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Griddata").html(results);
        }
        function oddetails_save() {
            var DataTable = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                branch = $(this).find('#txt_branchname').val();
                dateofentry = $(this).find('#txt_dateentry').val();
                purpose = $(this).find('#txt_purpose').val();
                dateofexit = $(this).find('#txt_exitdate').val();
                comments = $(this).find('#txt_comments').val();
                reportingdate = $(this).find('#txt_repartngdate').val();
                sno1 = $(this).find('#txt_sno').val();
                var abc = { 'branch': branch, 'dateofentry': dateofentry, 'purpose': purpose, 'sno1': sno1, 'dateofexit': dateofexit, 'comments': comments, 'reportingdate': reportingdate };
                if (branch != "" && purpose != "") {
                    DataTable.push(abc);
                }
                else {
                }
            });

            var empid = document.getElementById('txt_empid').value;
            if (empid == "") {
                alert("Select employename ");
                return false;
            }
            var empcode = document.getElementById('txtempcode').value;
            var MobileNumber = document.getElementById('txt_num').value;
            if (MobileNumber == null || MobileNumber == "") {
                alert("Please Enter Mobile Number");
                return false;
            }
            var fromdate = document.getElementById('dt_fromdate').value;
            if (fromdate == "") {
                alert("Select From Date ");
                return false;
            }
            var todate = document.getElementById('dt_todate').value;
            if (todate == "") {
                alert("Select To Date ");
                return false;
            }
            var totaldays = document.getElementById('txt_days').value;
            var reason = document.getElementById('txt_reason').value;
            if (reason == null || reason == "") {
                alert("Please Enter Reason")
                return false;
            }
            var reportingempid = document.getElementById('txt_repempid').value;
            if (reportingempid == "") {
                alert("Select Reporting Employename ");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_Save').value;
            if (DataTable.length == "0") {
                alert("Please enter Sub Details");
                return false;
            }
            var data = { 'op': 'oddetails_save', "empcode": empcode, "fromdate": fromdate, "todate": todate, 'MobileNumber': MobileNumber, 'reason': reason, 'totaldays': totaldays, 'reportingempid': reportingempid, 'empid': empid, 'leavetypesno': leavetypesno, 'DataTable': DataTable, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_edit_OD_details();
                        btn_cancel_click();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        $('#div_Deptdata').show();
                    }

                }
                else {
                }
            }
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }


        function get_edit_OD_details() {
            var data = { 'op': 'get_edit_OD_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_od_details(msg);
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
        var tdssub = [];
        function fill_od_details(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Sno</th><th scope="col">Employee Code</th><th scope="col">Employee Name</th><th scope="col">Designation</th><th scope="col">From Date</th><th scope="col">To Date</th><th scope="col">Reason</th><th scope="col">Reporting</th><th scope="col">status</th><th scope="col">Total Days</th></tr></thead></tbody>';
            tdssub = msg[0].suboddetails1;
            var tds = msg[0].odDetalis1;
            for (var i = 0; i < tds.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + tds[i].empcode + '</th>';
                results += '<td  class="2">' + tds[i].fullname + '</td>';
                results += '<td  class="8">' + tds[i].designation + '</td>';
                results += '<td  class="3">' + tds[i].fromdate + '</td>';
                results += '<td  class="4">' + tds[i].todate + '</td>';
                results += '<td  class="6">' + tds[i].reason + '</td>';
                results += '<td  class="5">' + tds[i].reportingname + '</td>';
                results += '<td  style="display:none"  class="16">' + tds[i].reportingempid + '</td>';
                results += '<td  style="display:none" class="13">' + tds[i].empid + '</td>';
                results += '<td  class="11">' + tds[i].status + '</td>';
                results += '<td   style="display:none" class="7">' + tds[i].MobileNumber + '</td>';
                results += '<td   style="display:none" class="10">' + tds[i].department + '</td>';
                results += '<td  style="display:none" class="12">' + tds[i].sno + '</td>';
                results += '<td   style="display:none" class="14">' + tds[i].designationid + '</td>';
                results += '<td  style="display:none" class="15">' + tds[i].deptid + '</td>';
                results += '<td  class="9">' + tds[i].totaldays + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }

        function getme(thisid) {
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_Deptdata').hide();
            var empcode = $(thisid).parent().parent().children('.1').html();
            var fullname = $(thisid).parent().parent().children('.2').html();
            var totaldays = $(thisid).parent().parent().children('.9').html();
            var fromdate = $(thisid).parent().parent().children('.3').html();
            var todate = $(thisid).parent().parent().children('.4').html();
            var reportingname = $(thisid).parent().parent().children('.5').html();
            var reportingempid = $(thisid).parent().parent().children('.16').html();
            var department = $(thisid).parent().parent().children('.10').html();
            var designation = $(thisid).parent().parent().children('.8').html();
            var reason = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.12').html();
            var empid = $(thisid).parent().parent().children('.13').html();
            var designationid = $(thisid).parent().parent().children('.14').html();
            var deptid = $(thisid).parent().parent().children('.15').html();
            var MobileNumber = $(thisid).parent().parent().children('.7').html();
            document.getElementById('txt_empid').value = empid;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('Slct_emp').value = fullname;
            document.getElementById('txt_days').value = totaldays;
            document.getElementById('dt_fromdate').value = fromdate;
            document.getElementById('dt_todate').value = todate;
            document.getElementById('slct_odreporting').value = reportingname;
            document.getElementById('txt_repempid').value = reportingempid;
            document.getElementById('txt_reason').value = reason;
            document.getElementById('txt_num').value = MobileNumber;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_Save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sr.No</th><th scope="col">Place of the Duty</th><th scope="col">Date of Entry</th><th scope="col">Purpose of Duty</th><th scope="col">Date of Exit</th><th scope="col">Reporting Manager Comments</th><th scope="col">Signature of Reporting Manage with Date</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < tdssub.length; i++) {
                if (sno == tdssub[i].od_refno) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input id="txt_branchname"  class="form-control" type="text" name="branch" value="' + tdssub[i].branch + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txt_dateentry" type="date" name="dateofentry"  value="' + tdssub[i].dateofentry + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txt_purpose" type="text "name="purpose" value="' + tdssub[i].purpose + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txt_exitdate" type="date"  name="dateofexit" value="' + tdssub[i].dateofexit + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txt_comments"  name="remarks" value="' + tdssub[i].comments + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txt_repartngdate" type="date" name="reportingdate" value="' + tdssub[i].reportingdate + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + tdssub[i].sno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }
            results += '</table></div>';
            $("#div_Griddata").html(results);
        }
        function btn_cancel_click2() {
            document.getElementById('txt_empid').value = "";
            document.getElementById('slct_odemploye').value = "";
            document.getElementById('tbl_leavemanagement').value = "";
            document.getElementById('dt_fromdate').value = "";
            document.getElementById('dt_todate').value = "";
            document.getElementById('txt_reason').value = "";
            //document.getElementById('txt_days').value = "";
            document.getElementById('txt_num').value = "";
            document.getElementById('txt_days').value = "";
            document.getElementById('txt_repempid').value = "";
            document.getElementById('slct_odreporting').value = "";
            document.getElementById('txt_branchname').value = "";
            document.getElementById('txt_dateentry').value = "";
            document.getElementById('txt_purpose').value = "";
            document.getElementById('txt_exitdate').value = "";
            document.getElementById('txt_comments').value = "";
            document.getElementById('txt_repartngdate').value = "";
            document.getElementById('btn_Save').value = "Save";
            Get_odFixedrows();
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
        function ODrequestDetails() {
            var table = document.getElementById("tbl_Sessioncategorylist");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var data = { 'op': 'ODrequestDetails' };
            var s = function (msg) {
                if (msg) {
                    var getSessionDetails = msg;
                    var COLOR = ["beige", "Aqua", "Aquamarine", "Azure", "Bisque"];
                    var k = 0;
                    for (var i = 0; i < getSessionDetails.length; i++) {
                        if (getSessionDetails[i].sno != null) {
                            var sno = getSessionDetails[i].sno;
                            var Employeename = getSessionDetails[i].empname;
                            var fromdate = getSessionDetails[i].fromdate;
                            var todate = getSessionDetails[i].todate;
                            var leave_days = getSessionDetails[i].leave_days;
                            var status = getSessionDetails[i].status;
                            var Reporting_manager = getSessionDetails[i].Reporting_manager;
                            var remarks = getSessionDetails[i].remarks;
                            var tablerowcnt = document.getElementById("tbl_Sessioncategorylist").rows.length;
                            $('#tbl_Sessioncategorylist').append('<tr style="background-color:' + COLOR[k] + '"><td style="display:none;" data-title="sno">' + sno + '</td><td data-title="Employeename">' + Employeename + '</td><td data-title="fromdate">' + fromdate + '</td><td data-title="todate">' + todate + '</td><td data-title="leave_days">' + leave_days + '</td><td data-title="status">' + status + '</td><td data-title="Reporting_manager">' + Reporting_manager + '</td><td style="display:none;" data-title="Reporting_manager">' + remarks + '</td><td><input type="button" class="btn btn-primary" name="Update" value =" For Apporval" onclick="updateclick(this);"/></td></tr>');
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
        odid = 0;
        function updateclick(thisid) {
            $('#divMainAddNewRow').css('display', 'block');
            var row = $(thisid).parents('tr');
            var sno = row[0].cells[0].innerHTML;
            var fromdate = row[0].cells[2].innerHTML;
            var todate = row[0].cells[3].innerHTML;
            var leave_days = row[0].cells[4].innerHTML;
            var status = row[0].cells[5].innerHTML;
            var Reporting_to = row[0].cells[6].innerHTML;
            var remarks = row[0].cells[7].innerHTML;
            var Employeename = row[0].cells[1].innerHTML;

            document.getElementById('spn_days').value = leave_days;
            document.getElementById('spnfromdate').value = fromdate;
            document.getElementById('spntodate').value = todate;
            document.getElementById('Spnreason').innerHTML = remarks;
            document.getElementById('spnAprveremarks').value = "";
            odid = sno;
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
        function save_approve_OD_click() {
            var fromdate = document.getElementById('spnfromdate').value;
            var todate = document.getElementById('spntodate').value;
            var leave_days = document.getElementById('spn_days').value;
            var approve_remarks = document.getElementById('spnAprveremarks').value;
            var data = { 'op': 'save_approve_OD_click', 'odid': odid, 'fromdate': fromdate, 'leave_days': leave_days, 'todate': todate, 'approve_remarks': approve_remarks };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        ODrequestDetails();
                        alert(msg);
                        $('#divMainAddNewRow').css('display', 'none');

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
        function save_Reject_OD_click() {
            var approve_remarks = document.getElementById('spnAprveremarks').value;
            var data = { 'op': 'save_Reject_OD_click', 'odid': odid, 'approve_remarks': approve_remarks };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        ODrequestDetails();

                        alert(msg);
                        $('#divMainAddNewRow').css('display', 'none');
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

        function btnODDetails_click() {
            var fromdate = document.getElementById('txtfromdate').value;
            var todate = document.getElementById('txttodate').value
            var table = document.getElementById("tbl_Sessioncategorylist1");
            for (var i = table.rows.length - 1; i > 0; i--) {
                table.deleteRow(i);
            }
            var status = "MyLeaveRequest";
            var data = { 'op': 'ODrequestDetails', 'status': status, 'fromdate': fromdate, 'todate': todate };
            var s = function (msg) {
                if (msg) {
                    var getSessionDetails = msg;
                    var COLOR = ["beige", "Aqua", "Aquamarine", "Azure", "Bisque"];
                    var k = 0;
                    for (var i = 0; i < getSessionDetails.length; i++) {
                        if (getSessionDetails[i].sno != null) {
                            var sno = getSessionDetails[i].sno;
                            var Employeename = getSessionDetails[i].empname;
                            var fromdate = getSessionDetails[i].fromdate;
                            var todate = getSessionDetails[i].todate;
                            var status = getSessionDetails[i].status;
                            var leave_days = getSessionDetails[i].leave_days;
                            var Reporting_manager = getSessionDetails[i].Reporting_manager;
                            var remarks = getSessionDetails[i].remarks;
                            var tablerowcnt = document.getElementById("tbl_Sessioncategorylist1").rows.length;
                            $('#tbl_Sessioncategorylist1').append('<tr style="background-color:' + COLOR[k] + '"><td style="display:none;" data-title="sno">' + sno + '</td><td data-title="Employeename">' + Employeename + '</td><td data-title="fromdate">' + fromdate + '</td><td data-title="todate">' + todate + '</td><td data-title="leave_days">' + leave_days + '</td><td data-title="status">' + status + '</td><td data-title="Reporting_manager">' + Reporting_manager + '</td><td style="display:none;" data-title="Reporting_manager">' + remarks + '</td></tr>');
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


        var meetingdetails = [];
        function btnodreportDetails_click() {
            var fromdate = document.getElementById('txtrpt_fromdate').value;
            var todate = document.getElementById('txtrpt_todate').value
            if (fromdate == "") {
                alert("Please select from date");
                return false;
            }
            if (todate == "") {
                alert("Please select to date");
                return false;
            }
            var formtype = "Meetingreport";
            var data = { 'op': 'get_od_details', 'fromdate': fromdate, 'todate': todate, 'formtype': formtype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_odreportdetails(msg);
                        meetingdetails = msg;
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


        function fill_odreportdetails(msg) {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Ref No</th><th scope="col">Employee Name</th><th scope="col">Reporting</th><th scope="col">Total Days</th></tr></thead></tbody>';
            var l = 0;
            var k = 1;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><th><input id="btn_Print" type="button"   onclick="printclick(this);"  name="Edit" class="btn btn-primary" value="Print" /></th>'
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1"  style="display:none">' + msg[i].sno + '</th>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].reportingempid + '</td>';
                results += '<td data-title="brandstatus" class="4">' + msg[i].totaldays + '</td></tr>';
            }
            results += '</table></div>';
            $("#divoddata").html(results);
        }


        var getodsubdetilaslis = [];
        function printclick(thisid) {
            var sno = $(thisid).parent().parent().children('.1').html();
            var data = { 'op': 'get_odrefrence_details', 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        $('#Button2').css('display', 'block');
                        var meetingdetails = msg[0].odDetalis1list;
                        getodsubdetilaslis = msg[0].suboddetailslist;
                        document.getElementById('spnsempname').innerHTML = meetingdetails[0].fullname;
                        document.getElementById('Spanemplid').innerHTML = meetingdetails[0].empcode;
                        document.getElementById('spntodate').innerHTML = meetingdetails[0].fromdate;
                        document.getElementById('spndate').innerHTML = meetingdetails[0].doe;
                        document.getElementById('SpnREfno').innerHTML = meetingdetails[0].Title;
                        document.getElementById('spnDeprt').innerHTML = meetingdetails[0].department;
                        document.getElementById('spndesig').innerHTML = meetingdetails[0].designation;
                        document.getElementById('spnreportname').innerHTML = meetingdetails[0].reportingempid;
                        fillodpurposedetails(getodsubdetilaslis);
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
        function fillodpurposedetails(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2">';
            results += '<thead><tr style="background:#cbc6dd;"><th scope="col">Sr.No</th><th scope="col">Place of the Duty</th><th scope="col">Date of Entry</th><th scope="col">Purpose of Duty</th><th scope="col">Date of Exit</th><th scope="col">Reporting Manager Comments</th><th scope="col">Signature of Reporting Manage with Date</th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            var j = 1;
            for (k = 0; k < msg.length; k++) {
                results += '<tr><td>' + j++ + '</td>';
                results += '<td class="1">' + msg[k].branch + '</td>';
                results += '<td class="1">' + msg[k].dateofentry + '</td>';
                results += '<td class="1">' + msg[k].purpose + '</td>';
                results += '<td class="1">' + msg[k].dateofexit + '</td>';
                results += '<td class="1">' + msg[k].comments + '</td>';
                results += '<td class="1">' + msg[k].reportingdate + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_ODData").html(results);

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

        //------------- Canteen Attendance Details -------------//


        function show_canteenDetails() {
            get_canteen_details();
            $("#div_can_atten").css("display", "none");
            $("#div_canteen_attandancereport").css("display", "none");
            $("#div_canteen_details").css("display", "block");
        }
        function show_canteenattdence() {
            $("#div_can_atten").css("display", "block");
            $("#div_canteen_attandancereport").css("display", "none");
            $("#div_canteen_details").css("display", "none");
        }
        function show_canattdncereprt() {
            $("#div_can_atten").css("display", "none");
            $("#div_canteen_attandancereport").css("display", "block");
            $("#div_canteen_details").css("display", "none");
        }
        function canteen_branchdetails() {
            var data = { 'op': 'get_branchdetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_canteen_branchdetails(msg);
                        fill_canteen_branchdetails1(msg);
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


        function fill_canteen_branchdetails(msg) {
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
        function fill_canteen_branchdetails1(msg) {
            var data = document.getElementById('ddl_brnch');
            var length = data.options.length;
            document.getElementById('ddl_brnch').options.length = null;
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

        function save_canteen_Details() {
            var branchid = document.getElementById("ddl_brnch").value;
            var type = document.getElementById("select_Type").value;
            var amount = document.getElementById("txt_amount").value;
            var btnval = document.getElementById('btn_save').value;
            var Sno = document.getElementById('lbl_cansno').innerHTML;
            var data = { 'op': 'save_canteen_Details', 'branchid': branchid, 'type': type, 'amount': amount, 'btnval': btnval, 'Sno': Sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_canteen_details();
                        forclearall();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearall() {
            document.getElementById('ddl_brnch').value = "";
            document.getElementById('select_Type').value = "";
            document.getElementById('txt_amount').value = "";
            document.getElementById('btn_save').value = "Save";
            $("#get_canteendetais").show();

        }

        function get_canteen_details() {
            var data = { 'op': 'get_canteen_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcanteendetails(msg);
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
        function fillcanteendetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th></th><th  scope="col"><i class="fa fa-university"></i>Type</th><th scope="col" >Amount</th><th   scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" ><span class="fa fa-university" style="color: cadetblue;"></span>  <span id="1" class="1"> ' + msg[i].branchname + '</span</th>';
                results += '<td data-title="type" class="2">' + msg[i].type + '</td>';
                results += '<td data-title="amount" class="3">' + msg[i].amount + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].Sno + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].branchid + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="canteengetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#get_canteendetais").html(results);
        }
        function canteengetme(thisid) {
            var branchname = $(thisid).parent().parent().children('.6').html();
            var type = $(thisid).parent().parent().children('.2').html();
            if (type == "Breakfast") {
                b = "1";
            }
            if (type == "Lunch") {
                b = "2";
            }
            if (type == "Dinner") {
                b = "3";
            }
            var amount = $(thisid).parent().parent().children('.3').html();
            var Sno = $(thisid).parent().parent().children('.5').html();
            document.getElementById('ddl_brnch').value = branchname;
            document.getElementById('select_Type').value = b;
            document.getElementById('txt_amount').value = amount;
            document.getElementById('lbl_cansno').innerHTML = Sno;
            document.getElementById('btn_save').value = "Modify";
            $("#get_canteendetais").hide();
        }

        function btn_canteen_click() {
            $("#div_imageattdance").css("display", "block");
            document.getElementById('div_employee').innerHTML = "";
            var DOA = document.getElementById("txtDOA").value;
            var branchid = document.getElementById("ddlbrnch").value;
            var Data = { 'op': 'get_canteenAttendence', 'DOA': DOA, 'branchid': branchid };
            var s = function (msg) {
                gradestudentsdata = msg;
                var status = "0";
                var divstudents = document.getElementById('div_employee');
                var tablestrctr = document.createElement('table');
                tablestrctr.id = "tabledetails";
                tablestrctr.setAttribute("class", "students-table");


                $(tablestrctr).append('<thead><tr><th>Sno</th><th><i class="fa fa-user" style="font-size:20px;padding-right: 5px;"></i>Employee Name</th><th>Employee Code</th><th>Breakfast</th><th>Lunch</th><th>Dinner</th></tr></thead><tbody></tbody>');
                var j = 0;
                for (var i = 0; i < gradestudentsdata.length; i++) {
                    j = i + 1;
                    var breakfast = gradestudentsdata[i].breakfast;
                    var lunch = gradestudentsdata[i].lunch;
                    var dinner = gradestudentsdata[i].dinner;
                    var dinnercount = gradestudentsdata[i].dinnercount;
                    var breakfastcount = gradestudentsdata[i].breakfastcount;
                    var lunchcount = gradestudentsdata[i].lunchcount;
                    var count = "Break Fast  : " + breakfastcount + ", Lunch : " + lunchcount + ", Dinner : " + dinnercount + "";
                    document.getElementById('spn_msg').innerHTML = count;
                    $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td>'
                            + '<td>' + gradestudentsdata[i].employee_num + '</td>'
                            + '<td name="idprevsmsstatus" style="display:none"><input name="hdnempsno"   id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td>'
                             + (breakfast == "" ? '<td><input type="checkbox" name="ckBreakfast" id="ckBreakfast" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="1" ></td>' : '<td><input name="ckBreakfast" id="ckBreakfast"  type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="1" checked="checked" ></td>')
                           + (lunch == "" ? '<td><input  name="cklunch" id="cklunch"  type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="2" ></td>' : '<td><input name="cklunch" id="cklunch" type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="2" checked="checked" ></td>')
                           + (dinner == "" ? '<td><input name="ckdinner" id="ckdinner" type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="3" ></td>' : '<td><input name="ckdinner" id="ckdinner" type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="3" checked="checked" ></td>')
                           + '</tr>');
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
        function btn_Finalize_Attendence() {
            var studentslist = [];
            var Absentlist = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            var remarks = "";

            var matches = [];
            $('#tabledetails > tbody > tr').each(function () {
                var empsno = $(this).find('[name="hdnempsno"]').val();
                var Breakfast = 0;
                var lunch = 0;
                var dinner = 0;
                var ckBreakfast = $(this).find('[name="ckBreakfast"]:checked').val();
                if (typeof ckBreakfast === "undefined") {
                    Breakfast = 0;
                }
                else {
                    Breakfast = 1;
                }
                var cklunch = $(this).find('[name="cklunch"]:checked').val();
                if (typeof cklunch === "undefined") {
                    lunch = 0;
                }
                else {
                    lunch = 2;
                }
                var ckdinner = $(this).find('[name="ckdinner"]:checked').val();
                if (typeof ckdinner === "undefined") {
                    dinner = 0;
                }
                else {
                    dinner = 3;
                }
                if (Breakfast == "0" && lunch == "0" && dinner == "0") {
                }
                else {
                    matches.push({ employee: empsno, Breakfast: Breakfast, lunch: lunch, dinner: dinner });
                }
            });
            var branchid = document.getElementById("ddlbrnch").value;
            var DOA = document.getElementById("txtDOA").value;
            if (DOA == null || DOA == "") {
                document.getElementById("txtDOA").focus();
                alert("please Select Attendance Date");
                return false;
            }
            var Data = { 'op': 'save_Finalize_Attendence', 'DOA': DOA, 'branchid': branchid, 'employeeslist': matches };
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


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <div class="row">
            <section class="content-header">
                <h1>
                  Leave Management And Od Applay
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Leave Management And Od Applay Master</a></li>
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
                        <li id="id_ledger" class="active"><a data-toggle="tab" href="#" onclick="ShowLeaveManagementDetails()">
                            <i class="fa fa-building-o" aria-hidden="true"></i>&nbsp;&nbsp;Leave Management Details</a></li>
                        <li id="id_travelexp" class=""><a data-toggle="tab" href="#" onclick="ShowOdApplayDetails()">
                            <i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Od Approval Details</a></li>
                        <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="ShowCanteenAttDetails()">
                            <i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Canteen Attendance Details</a></li>
                    </ul>
                 </div>
               </div>
             </div>

 <%--//-------------Leave Management Details-------------//--%>

    <div id="Div_leavedetails" style="display: none;">
     <section class="content">
    <div class="box box-info">
    <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Leave Management
                </h3>
            </div>
        <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_leavemangement()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Leave Management Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_Approveleave()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Approve Details</a></li>
                             <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="show_myleaverequest()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;My Leave Request Details</a></li>
                            <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="show_myleavereport()">
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
                    <input type="text" class="form-control" id="Slct_leaveemp1" placeholder="Enter Employee Name" />
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
                    <input type="text" class="form-control" id="slct_leavereporting" placeholder="Enter Employee Name" />
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
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
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
    <section id="sec_lvrpt" style="height: 500px !important;">
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
                                            <asp:DropDownList ID="lvddlbranch" runat="server" class="form-control">
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
                                        <asp:TextBox ID="txtTodate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender2" runat="server" Enabled="True"
                                            TargetControlID="txtTodate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                            <td style="width: 6px;">
                            </td>
                                        <td>
                                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                                OnClick="btn_lvGenerate_Click" /><br />
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
                                   <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                </asp:Panel>
                             <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                         </div>
                     </div>
                   </ContentTemplate>
                </asp:UpdatePanel>
             </div>
             </section>
          </div>
        </div>
      </section>
   </div>

    <%--//------------- OD approve Details -------------//--%>

    <div id="div_odapplydetails" style="display: none;">
    <section class="content">
    <div class="box box-info">
    <div>
                    <ul class="nav nav-tabs">
                        <li id="Li4" class="active"><a data-toggle="tab" href="#" onclick="show_odmaster()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;OD Apply</a></li>
                        <li id="Li5" class=""><a data-toggle="tab" href="#" onclick="show_odApprove()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp; OD Approve Details</a></li>
                             <li id="Li6" class=""><a data-toggle="tab" href="#" onclick="show_myodrequest()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;My OD request Details</a></li>
                             <li id="Li7" class=""><a data-toggle="tab" href="#" onclick="show_odreport()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;OD Apply Report</a></li>
                    </ul>
              </div>
              <div id="div_Od" style="display: none;">
              <div class="box-header with-border" id="div_1" style="display:none;">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>OD Request Form Details
            </h3>
        </div>
                  <div class="box-body">
                  <div id="showlogs" align="center">
                        <input id="btn_addBrand" type="button" name="submit" value='Add OD Apply' class="btn btn-primary" />
                    </div>
        <div id='fillform' style="display: none;">
        <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
        src="Iconimages/onduty.png" alt="your image" style="border-radius: 5px; width: 170px;
        height: 150px; border-radius: 50%;" />
        </div>
            <table id="Table1" class="inputstable" align="center">
            <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                        Employee Name
                        </label>
                    </td>
                    <td>
                    <input type="text" class="form-control" id="slct_odemploye" placeholder="Enter Employee Name" />
                     
                    </td>
                     <td style="display: none">
                            <input id="Hidden1" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                         <td style="display: none">
                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                         <td>
                          <label class="control-label">
                            Mobile Number <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td>
                        <input type="text" id="Text2" class="form-control only_no" placeholder="Enter Mobile Number" value="" onkeypress="return isNumber(event)" onblur="checkLength()">
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                            From Date <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td>
                        <input type="date"  id="Date1" class="form-control"  value="" />
                    </td>
                    <td>
                     <label class="control-label">
                            To Date <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td>
                        <input type="date"   id="Date2" class="form-control" onchange="cal();"
                            value=""  />
                    </td>
                </tr>
                <tr hidden>
                        <td>
                            <label id="lbl_sno">
                            </label>
                        </td>
                    </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                        Total OD Days
                        </label>
                    </td>
                    <td>
                        <input type="text" id="Text3" class="form-control" placeholder="Enter Total Leave Days" value="1"  >
                    </td>
                    <td>
                     <label class="control-label">
                           Name of the Departmental Head <span style="color: red;">*</span>
                           </label>
                    </td>
                    <td>
                    <input type="text" class="form-control" id="slct_odreporting" placeholder="Enter Employee Name" />
                    </td>
                     <td style="height: 40px; display: none">
                            <input id="Hidden2" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                            Reason For OD <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td >
                        <textarea cols="35" rows="3" id="Textarea1"  placeholder="Enter Reason" class="form-control"></textarea>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                 </table>
                 <div  id="div_Griddata">
                        </div>
                 <table align="center">
                <tr style="height: 10px;">
                 <p id="newrow">
                  <input type="button" onclick="odinsertrow();" class="btn btn-default" value="Insert row" /></p>
                    <td style="height: 40px;">
                        <input id="Button4" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="oddetails_save();" >
                        <input id="Button5" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="btn_cancel_click2();" >
                    </td>
                </tr>
            </table>
        </div>
         <div>
         <div id="div_Deptdata" style="display:none;">
        </div>
    </div>
    </div>
        </div>

       <div id="div_OdApproval" style="display: none;">
            <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Requests  Details
            </h3>
        </div>
        <div  style="overflow:auto;">
        <table class="table table-bordered table-hover dataTable no-footer"  aria-describedby="example2_info" ID="Table2">'
                <thead>
                    <tr>
                        <th scope="col">
                           Employee Name
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
        <div id="div1" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="div2" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                    id="table3" class="mainText2" border="1">
                    <tr>
                        <td>
                         <label class="control-label">
                           Total Days
                           </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="Text5" class="form-control" />
                        </td>
                         <td>
                          <label class="control-label">
                            Reason
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <span id="Span1" type="text" class="form-control"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                         <label class="control-label">
                            From Date
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="Date3" type="date"class="form-control" value="" />
                        </td>
                          <td>
                           <label class="control-label">
                            To Date
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="Date4" type="date" class="form-control" onchange="caldays();" value="" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                         <label class="control-label">
                            Approve Remarks
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="Text6" type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" class="btn btn-primary" id="Button6" value="Approve" onclick="save_approve_OD_click();" />
                        </td>
                        <td>
                            <input type="button" class="btn btn-danger" id="Button7" value="Reject" onclick="save_Reject_OD_click();" />
                        </td>
                        
                    </tr>
                </table>
            </div>
            <div id="div3" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
            </div>
        </div>
    </div>
       </div>

       <div id="div_myod" style="display: none;">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>My OD Request Details
            </h3>
        </div>
        <div>
        <table align="center">
                    <tr>
                        <td>
                        <label class="control-label">
                                From Date:</label>
                        </td>
                        <td>
                            <input type="date" id="Date5" class="form-control" />
                        </td>
                        <td>
                            <label class="control-label">
                                To Date:</label>
                        </td>
                        <td>
                            <input type="date" id="Date6" class="form-control" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <input id="Button8" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                onclick="btnODDetails_click()" />
                        </td>
                    </tr>
                </table>
            <table id="Table4" class="table table-bordered table-hover dataTable no-footer">
                <thead>
                    <tr>
                        <th scope="col">
                           Employee Name
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
    <div id="div_report" style="display: none;">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>OD Apply Report 
                </h3>
            </div>
            <div class="box-body">
                <div runat="server" id="d">
                    <table>
                        <tr>
                            <td>
                                <label>
                                    From Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtrpt_fromdate" class="form-control" />
                            </td>
                            <td>
                                <label>
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txtrpt_todate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="btn_get" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                onclick="btnodreportDetails_click()" />
                            </td>
                        </tr>
                    </table>
                    <div id="divoddata" style="height: 300px; overflow-y: scroll;">
                    </div>
                </div>
                <br />
                <br />
                <div id="div4" style="display:none;">
                 <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                     <div>
                        <div style="font-family: Arial; font-size: 18pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Dairy Specialities (P) Ltd </span>
                            <br />
                        </div>
                        R.S.No:381/2,Punabaka village Post<br />
                        Pellakuru Mandal,Nellore District -524129.,
                        <br />
                        ANDRAPRADESH (State)<br />
                        Phone: 9440622077, Fax: 044 – 26177799.
                    </div>
                      <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 26px; font-weight: bold;">OUT STATION DUTY APPLICATION  </span>
                    </div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 49%; float: left;">
                                <br />
                                <label>
                                    Name of the Employee:</label>
                                <span id="spnsempname"></span>
                                <br />
                                <label>
                                    Employee ID No :</label>
                                <span id="Spanemplid"></span>
                                <br />
                                <label>
                                    Period of Outstation  Duty: Starting Date:</label>
                                <span id="Span2"></span>
                                <br />
                                <label>
                                    Signature of the Employee:</label>
                                <span id="spnsignature"></span>
                                <br />
                            </td>
                            <td style="width: 49%; float: right;">
                                <span id="SpnREfno" style="font-weight: bold;"></span>
                                <br />
                                <label>
                                    Date :</label>
                                <span id="spndate"></span>
                                <br />
                             
                                 <label>
                                     Department :</label>
                                <span id="spnDeprt"></span>
                                <br />
                                 <label>
                                     Designation:</label>
                                <span id="spndesig"></span>
                                <br />
                                 <label>
                                     Name of the Departmental Head:</label>
                                <span id="spnreportname"></span>
                                <br />
                                 <label>
                                     Signature of the Departmental Head:</label>
                                <span id="ssignature"></span>
                                <br />
                            </td>
                        </tr>
                    </table>
                     <br />
                      <br />
                    <div id="div_ODData">
                    </div>
                     <br />
                      <br />
                       <span style="margin-left:30px;" >
                         FOR OFFICE USE.
                       </span>
                      <br />
                      <span style="margin-left:30px;" >
                       Comments from the HR Department -
                       </span>
                      <textarea cols="35" rows="3" style="margin-left:30px; width: 70%;height: 80px;" placeholder="Comments from the HR Department" class="form-control">
                      </textarea>
                       <br />
                      <br />
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 15px;">On Duty End Date:</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 15px;">Signature of Employee</span>
                            </td>
                            <td style="width: 25%;">
                                <span style="font-weight: bold; font-size: 15px;">Signature of the Departmental Head</span>
                            </td>
                        </tr>
                    </table>
                </div>
                <input id="Button9" type="button" class="btn btn-primary" name="submit" style="display:none; align="center" " value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="Label3" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </div>
   </div>
    </section>
    </div>

<%--//------------- Canteen Attendance Details -------------//--%>

<div id="div_canteenattdncdetails" style="display: none;">
<section class="content" style="overflow:inherit !important;">

<div class="box box-info">
<div>
                <ul class="nav nav-tabs">
                <li id="Li8" class="active"><a data-toggle="tab" href="#" onclick="show_canteenDetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp; Canteen Details</a></li>
                    <li id="Li9" class=""><a data-toggle="tab" href="#" onclick="show_canteenattdence()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Canteen Attendence</a></li>
                         <li id="Li10" class=""><a data-toggle="tab" href="#" onclick="show_canattdncereprt()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Canteen Attendence Report</a></li>
                        </ul>
                        </div>
                        
                 <div id="div_canteen_details">
                 <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Details
                    </h3>
                </div>
               
                <table align="center">
                <tr style="display:none;"><td>
                            <label id="lbl_cansno"></label>
                            </td>
                            </tr>
                <tr>
                <td style="height: 40px;">
                         <label class="control-label" >
                        Branch Name
                        </label>
                        </td>
                        <td>
                            <select id="ddl_brnch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch" onchange="btn_canteen_click();">Select Branch</option>
                            </select>
                        </td>
                        </tr>
                        <tr>
                        <td>
                        <label class="control-label" for="txt_type">
                          Type</label>
                          </td>
                         <td>
                    <select name="month" id="select_Type" onchange="" size="1" class="form-control" style="width: 250px;">
                        <option value="1">Breakfast</option>
                        <option value="2">Lunch</option>
                        <option value="3">Dinner</option>
                    </select>
                        </td>                        
                        </tr>                        
                        <tr>     
                    <td style="height: 40px;">
                        <label class="control-label" >
                            Amount:
                            </label>
                        </td>
                        <td>
                        <input type="text" class="form-control" id="txt_amount" placeholder="Enter Amount " />
                    </td>
                    </tr>
                    <tr >

                    <td style="height: 40px;" >
                        <input id="Button10" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="save_canteen_Details();">
                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="forclearall();" >
                    </td>                   
                </tr>
                </table>
                <div id="get_canteendetais"></div>
                 </div>  
               
                <div class="box-header with-border">
                <div id="div_can_atten" >
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Attendence
                    </h3>
                </div>
             <table id="txtdate" align="center">
                    <tr>
                        <td style="height: 40px;">
                            Date <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="date" class="form-control" id="txtDOA" class="form-control" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                            Branch Name
                        </td>
                        <td>
                            <select id="ddlbrnch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch" onchange="btn_canteen_click();">Select Branch</option>
                            </select>
                        </td>                        
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <input id="btn_canteen" type="button" class="btn btn-primary" name="submit" value="GENERATE"
                                onclick="btn_canteen_click();" style="width: 100px;">
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
          
                                                                    </div>
                                                                    <div>
                                                                    <span style="font-size:20px;font-weight:700; color:Green;" id="spn_msg"></span>
                                                                    </div >
                        <div id="div_employee" style="padding: 0px 0px 5px 5px; font-family: 'Open Sans';
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
                </div>
               <div id="div_canteen_attandancereport" style="display: block; height: 500px !important;">
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
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            
            <section class="content" style="padding: 0px !important;" >
                    <div class="box-header with-border" >
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Attendence Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div align="center">
                            <table>
                                <tr>                                 
                                <td>
                                            <asp:Label ID="Label6" runat="server" Text="Label">Branch</asp:Label>&nbsp;
                                            <asp:DropDownList ID="canteen_ddlbranch" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </td>
                                         <td style="width: 6px;">
                            </td>
                            <td>                            
                               <asp:Label ID="Label7" runat="server" Text="Label">Type</asp:Label>&nbsp;
                                 <asp:DropDownList ID="txt_type" runat="server" CssClass="form-control">
                                 <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                 <asp:ListItem Value="1">Breakfast</asp:ListItem>
                                 <asp:ListItem Value="2">Lunch</asp:ListItem>
                                 <asp:ListItem Value="3">Dinner</asp:ListItem>
                                   </asp:DropDownList>                                
                                  </td>
                                    <td style="overflow:inherit" >
                                        <asp:Label ID="Label8" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_FromDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="True"
                                            TargetControlID="dtp_FromDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_Todate" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:CalendarExtender ID="CalendarExtender2" runat="server" Enabled="True"
                                            TargetControlID="dtp_Todate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Button ID="Button11" runat="server" Text="GENERATE" CssClass="btn btn-primary" OnClick="btn_canteenGenerate_Click" /><br />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="Panel1" runat="server" Visible='false'>
                                <div id="div5">
                                    <div style="width: 100%;">
                                        <div style="width: 13%; float: left;">
                                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                        </div>
                                        <div align="center">
                                            <asp:Label ID="Label10" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                            <asp:Label ID="Label11" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                             <asp:Label ID="lblbname" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                Text=""></asp:Label><span style="font-size: 18px; font-weight: bold; color: #0252aa;">&nbsp Canteen Attendence Register</span><br />
                                        </div>
                                        <table style="width: 80%">
                                            <tr>
                                                <td>
                                                    from Date
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label12" runat="server" ForeColor="Red"></asp:Label>
                                                </td>
                                                <td>
                                                    To date:
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label13" runat="server"  ForeColor="Red"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                        <div>
                                            <asp:GridView ID="GridView1" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
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
                                <asp:Button ID="btnsave" runat="Server" CssClass="btn btn-success" OnClick="btnlogssave_click" Text="Finalize Canteen Attendance" />
                                <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint('divPrint');"
                                    Text="Print" />
                            </asp:Panel>
                            <asp:Label ID="Label14" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                        </div>
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
        </div>
</div>
</section>
</div>

 </section>
</asp:Content>
