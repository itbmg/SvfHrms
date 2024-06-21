<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="ODMaster.aspx.cs" Inherits="ODMaster" %>

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
            $('#btn_addBrand').click(function () {
                $('#fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_Deptdata').hide();
                get_edit_OD_details();
                get_Employeedetails();
                ODrequestDetails();
                GetFixedrows();
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



            $('#btn_Cancel').click(function () {
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_Deptdata').show();
                btn_cancel_click();
            });
            get_edit_OD_details();
            get_Employeedetails();
            $("#div_Od").css("display", "block");
        });
        function show_odmaster() {
            $("#div_Od").css("display", "block");
            $("#div_OdApproval").css("display", "none");
            $("#div_myod").css("display", "none");
            $("#div_report").css("display", "none");
            ODrequestDetails();
            get_edit_OD_details();
        }

        function show_odApprove() {
            $("#div_OdApproval").css("display", "block");
            $("#div_Od").css("display", "none");
            $("#div_myod").css("display", "none");
            $("#div_report").css("display", "none");

            ODrequestDetails();

        }

        function show_myodrequest() {
            $("#div_OdApproval").css("display", "none");
            $("#div_Od").css("display", "none");
            $("#div_myod").css("display", "block");
            $("#div_report").css("display", "none");

        }
        function show_odreport() {
            $("#div_OdApproval").css("display", "none");
            $("#div_Od").css("display", "none");
            $("#div_myod").css("display", "none");
            $("#div_report").css("display", "block");

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
                    document.getElementById('txtempcode').value = employeedetails[i].empnum;
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
        function GetFixedrows() {
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
        function insertrow() {
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
                        filldetails(msg);
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
        function filldetails(msg) {
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
            document.getElementById('slct_reporting').value = reportingname;
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
        function btn_cancel_click() {
            document.getElementById('txt_empid').value = "";
            document.getElementById('Slct_emp').value = "";
            document.getElementById('tbl_leavemanagement').value = "";
            document.getElementById('dt_fromdate').value = "";
            document.getElementById('dt_todate').value = "";
            document.getElementById('txt_reason').value = "";
            //document.getElementById('txt_days').value = "";
            document.getElementById('txt_num').value = "";
            document.getElementById('txt_days').value = "";
            document.getElementById('txt_repempid').value = "";
            document.getElementById('slct_reporting').value = "";
            document.getElementById('txt_branchname').value = "";
            document.getElementById('txt_dateentry').value = "";
            document.getElementById('txt_purpose').value = "";
            document.getElementById('txt_exitdate').value = "";
            document.getElementById('txt_comments').value = "";
            document.getElementById('txt_repartngdate').value = "";
            document.getElementById('btn_Save').value = "Save";
            GetFixedrows();
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
                        fillreportdetails(msg);
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


        function fillreportdetails(msg) {
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
    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            OD Apply<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> OD Apply</a></li>
            <li><a href="#">OD Apply</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
    <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_odmaster()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;OD Apply</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_odApprove()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp; OD Approve Details</a></li>
                             <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="show_myodrequest()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;My OD request Details</a></li>
                             <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="show_odreport()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;OD Apply Report</a></li>
                    </ul>
              </div>
              <div id="div_Od" style="display: none;">
              <div class="box-header with-border">
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
            <table id="tbl_leavemanagement" class="inputstable" align="center">
            <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                        Employee Name
                        </label>
                    </td>
                    <td>
                    <input type="text" class="form-control" id="Slct_emp" placeholder="Enter Employee Name" />
                     
                    </td>
                     <td style="display: none">
                            <input id="txt_empid" type="hidden" class="form-control" name="hiddenempid" />
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
                        <input type="text" id="txt_num" class="form-control only_no" placeholder="Enter Mobile Number" value="" onkeypress="return isNumber(event)" onblur="checkLength()">
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                            From Date <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td>
                        <input type="date"  id="dt_fromdate" class="form-control"  value="" />
                    </td>
                    <td>
                     <label class="control-label">
                            To Date <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td>
                        <input type="date"   id="dt_todate" class="form-control" onchange="cal();"
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
                        <input type="text" id="txt_days" class="form-control" placeholder="Enter Total Leave Days" value="1"  >
                    </td>
                    <td>
                     <label class="control-label">
                           Name of the Departmental Head <span style="color: red;">*</span>
                           </label>
                    </td>
                    <td>
                    <input type="text" class="form-control" id="slct_reporting" placeholder="Enter Employee Name" />
                    </td>
                     <td style="height: 40px; display: none">
                            <input id="txt_repempid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label">
                            Reason For OD <span style="color: red;">*</span>
                            </label>
                    </td>
                    <td >
                        <textarea cols="35" rows="3" id="txt_reason"  placeholder="Enter Reason" class="form-control"></textarea>
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
                                    <input type="button" onclick="insertrow();" class="btn btn-default" value="Insert row" /></p>
                
                   
                    <td style="height: 40px;">
                        <input id="btn_Save" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="oddetails_save();" >
                        <input id="btn_Cancel" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="btn_cancel_click();" >
                            <td>
                    </td>
                    </td>
                </tr>
            </table>
            
                          </div>
         <div>
         <div id="div_Deptdata">
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
        <table class="table table-bordered table-hover dataTable no-footer"  aria-describedby="example2_info" ID="tbl_Sessioncategorylist">'
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
                           Total Days
                           </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="spn_days" class="form-control" />
                        </td>
                         <td>
                          <label class="control-label">
                            Reason
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <span id="Spnreason" type="text" class="form-control"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                         <label class="control-label">
                            From Date
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="spnfromdate" type="date"class="form-control" value="" />
                        </td>
                          <td>
                           <label class="control-label">
                            To Date
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="spntodate" type="date" class="form-control" onchange="caldays();" value="" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                         <label class="control-label">
                            Approve Remarks
                            </label>
                        </td>
                        <td style="height: 40px;">
                            <input id="spnAprveremarks" type="text" class="form-control"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" class="btn btn-primary" id="btn_save" value="Approve" onclick="save_approve_OD_click();" />
                        </td>
                        <td>
                            <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_Reject_OD_click();" />
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
                                <input type="date" id="txtfromdate" class="form-control" />
                            </td>
                            <td>
                              <label class="control-label">
                                    To Date:</label>
                            </td>
                            <td>
                                <input type="date" id="txttodate" class="form-control" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Get Details'
                                    onclick="btnODDetails_click()" />
                            </td>
                        </tr>
                    </table>
            <table id="tbl_Sessioncategorylist1" class="table table-bordered table-hover dataTable no-footer">
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
                <div id="divPrint" style="display:none;">
                 <div style="width: 13%; float: right;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
                     <div>
                        <div style="font-family: Arial; font-size: 18pt; font-weight: bold; color: Black;">
                            <span>Sri Vyshnavi Foods Pvt Ltd </span>
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
                                <span id="Span1"></span>
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
                
                <input id="Button2" type="button" class="btn btn-primary" name="submit" style="display:none; align="center" " value='Print'
                    onclick="javascript:CallPrint('divPrint');" />
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
            </div>
        </div>
    </div>


   </div>
    </section>
</asp:content>
