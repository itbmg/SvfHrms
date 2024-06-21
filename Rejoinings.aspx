<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Rejoinings.aspx.cs" Inherits="Payroll_Rejoinings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Dept_details();
            get_Desgnation_details();
            get_Employee_details();
            get_Employeedetails();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_Doj').val(today);
        });
        function close_vehmaster() {
            $("#fillform").hide();
            forclearall();
        }
        function show_rejoiningdetails() {
            $("#div_approval").css("display", "none");
            $("#div_rejoining").css("display", "block");
        }
        function show_Approverejoining() {
            $("#div_approval").css("display", "block");
            $("#div_rejoining").css("display", "none");
            get_RejoiningDetails();
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
        var depdetails = [];
        function get_Dept_details() {
            var data = { 'op': 'get_Dept_details' };
            var s = function (msg) {
                if (msg) {
                    depdetails = msg;
                    var depList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var depname = msg[i].Department;
                        depList.push(depname);
                    }
                    $('#ddldeptment').autocomplete({
                        source: depList,
                        change: depnamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }

        function depnamechange() {
            var depname = document.getElementById('ddldeptment').value;
            for (var i = 0; i < depdetails.length; i++) {
                if (depname == depdetails[i].Department) {
                    document.getElementById('txtdepid').value = depdetails[i].Deptid;
                    document.getElementById('txtDeprt').value = depdetails[i].Department;
                }
            }
        }
        var desigdetails = [];
        function get_Desgnation_details() {
            var data = { 'op': 'get_Desgnation_details' };
            var s = function (msg) {
                if (msg) {
                    desigdetails = msg;
                    var designetionList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var designetionname = msg[i].designation;
                        designetionList.push(designetionname);
                    }
                    $('#slct_emprole').autocomplete({
                        source: designetionList,
                        change: designetionnamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function designetionnamechange() {
            var designetionname = document.getElementById('slct_emprole').value;
            for (var i = 0; i < desigdetails.length; i++) {
                if (designetionname == desigdetails[i].designation) {
                    document.getElementById('txtdesid').value = desigdetails[i].designationid;
                }
            }
        }
        var reportemployeedetails = [];
        function get_Employee_details() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    reportemployeedetails = msg;
                    var reportempnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var reportempname = msg[i].empname;
                        reportempnameList.push(reportempname);
                    }
                    $('#slct_rep').autocomplete({
                        source: reportempnameList,
                        change: reportemployeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function reportemployeenamechange() {
            var reportempname = document.getElementById('slct_rep').value;
            for (var i = 0; i < reportemployeedetails.length; i++) {
                if (reportempname == reportemployeedetails[i].empname) {
                    document.getElementById('txtreportempid').value = reportemployeedetails[i].empsno;
                }
            }
        }
        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_search_employee' };
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
                    document.getElementById('txtsupid').value = employeedetails[i].employeid;
                    document.getElementById('txtcode').innerHTML = employeedetails[i].empcode;
                    document.getElementById('txtusername').innerHTML = employeedetails[i].username;
                    document.getElementById('txt_username').value = employeedetails[i].username;
                    document.getElementById('txtPassword').innerHTML = employeedetails[i].password;
                    document.getElementById('txtDoj').innerHTML = employeedetails[i].joindate;
                    document.getElementById('txtDesig').innerHTML = employeedetails[i].designation;
                    document.getElementById('txtDeprt').innerHTML = employeedetails[i].department;
                    document.getElementById('txtRegDate').innerHTML = employeedetails[i].resignationdate;
                    document.getElementById('txtEname').innerHTML = employeedetails[i].empname;
                }
            }
        }
        $(function () {
            $("#chk_add_login").click(function () {
                if ($(this).is(":checked")) {
                    $("#login_details").show();
                } else {
                    $("#login_details").hide();

                }
            });
        });
        function save_rejion_detailes() {
            var empid = document.getElementById('txtsupid').value;
            if (empid == "") {
                alert("Select Employee Name ");
                return false;
            }
            var rejoiningdate = document.getElementById('txt_Doj').value;
            if (rejoiningdate == "") {
                alert("Select rejoiningdate");
                return false;
            }
            var Department = document.getElementById('txtdepid').value;
            var Designation = document.getElementById('txtdesid').value;
            var reportingto = document.getElementById('txtreportempid').value;
            if (Department == "") {
                alert("Enter Department");
                return false;
            }
            if (Designation == "") {
                alert("Enter Designation");
                return false;
            }
            var btnval = document.getElementById('btn_save').value;
            var login_check = "";
            var password = "";
            var username = "";
            var confrmpassword = "";
            if (document.getElementById('chk_add_login').checked == true) {
                username = document.getElementById('txt_username').value;
                password = document.getElementById('txt_password').value;
                if (username == "") {
                    alert("Please Enter username");
                    return;
                }
                if (password == "") {
                    alert("Please Enter Password");
                    return;
                }
                confrmpassword = document.getElementById('txt_confpassword').value;
                login_check = "checked";
            }
            var data = { 'op': 'save_rejion_detailes', 'empid': empid, 'rejoiningdate': rejoiningdate, 'Department': Department, 'Designation': Designation, 'reportingto': reportingto, 'username': username, 'password': password, 'btnval': btnval, 'login_check': login_check };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        canceldetails();
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
        function canceldetails() {
            document.getElementById('txtdepid').value = "";
            document.getElementById('txtdesid').value = "";
            document.getElementById('txtreportempid').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('selct_employe').value = "";
            document.getElementById('txtcode').innerHTML = "";
            document.getElementById('txtusername').innerHTML = "";
            document.getElementById('txt_username').value = "";
            document.getElementById('txtPassword').innerHTML = "";
            document.getElementById('txtDoj').innerHTML = "";
            document.getElementById('txtDesig').innerHTML = "";
            document.getElementById('txtDeprt').innerHTML = "";
            document.getElementById('txtRegDate').innerHTML = "";
            document.getElementById('txtEname').innerHTML = "";
            document.getElementById('txt_Doj').value = "";
            document.getElementById('txt_password').value = "";
            document.getElementById('txt_confpassword').value = "";
            document.getElementById('btn_save').value = "save";
            $("#lbl_name_error_msg").hide();
        }

        function get_RejoiningDetails() {
            var data = { 'op': 'get_RejoiningDetails' };
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
            results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">Department</th><th scope="col">Dateofjoining</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
                results += '<td  class="2">' + msg[i].department + '</td>';
                results += '<td  class="3">' + msg[i].joindate + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].reportingto + '</td>';
                results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_rejoining_approve_click(this);" value="Apporval" /></td><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-danger" value="Reject" /></td>';
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
            var reason = $(thisid).parent().parent().children('.5').html();
            sno = $(thisid).parent().parent().children('.6').html();
            var status = $(thisid).parent().parent().children('.7').html();
        }

        function save_rejoining_reject_click() {
            var reason = document.getElementById("txt_remarks").value;
            var data = { 'op': 'save_rejoining_reject_click', 'sno': sno, 'reason': reason };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        $('#divMainAddNewRow').css('display', 'none');
                        get_RejoiningDetails();
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

        function save_rejoining_approve_click(thisid) {
            sno = $(thisid).parent().parent().children('.6').html();
            var empid = $(thisid).parent().parent().children('.8').html();
            var data = { 'op': 'save_rejoining_approve_click', 'sno': sno, 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_RejoiningDetails();
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<section class="content-header">
        <h1>
            Employee Rejoinings
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">Employee Rejoinings</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info" style="margin-bottom:0px">
                    <ul class="nav nav-tabs" >
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_rejoiningdetails()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Employee Rejoining Details</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_Approverejoining()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Approve  Details</a></li>
                    </ul>
                </div>
        <div class="box box-info" >
        <div id="div_rejoining">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Rejoinings Details
                </h3>
            </div>
            <div class="box-body">
    <div id="div_basic_details" style="display: block;">
        <div style="padding-bottom: 2%;">
            <table>
                <tr>
                    <td>
                        <label>
                            Employee Name</label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" />
                    </td>
                    <td style="height: 40px; display: none">
                        <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                    <td>
                        <input id="gen_button" type="button" class="btn btn-primary" name="submit" value='Generate'
                            onclick="btn_Purchase_order_click()" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="box box-danger">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Details</h3>
            </div>
            <div class="box-body">
                <div id="fillform" style="display: none;">
                </div>
                <div class="row" >
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            Employee code:</label>
                        <span style="color: Red;">*</span> <span id="txtcode"></span>
                    </div>
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            Employee Name:</label>
                        <span id="txtEname"></span>
                    </div>
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            Department:</label>
                        <span style="color: Red;">*</span> <span id="txtDeprt"></span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            Designation:</label>
                        <span id="txtDesig"></span>
                    </div>
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            DOJ:</label>
                        <span id="txtDoj"></span>
                    </div>
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            Resigned Date:</label>
                        <span type="date" id="txtRegDate">
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            Reporting To:</label>
                        <span id="txtReporting"></span>
                    </div>
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            username:</label>
                        <span id="txtusername"></span>
                    </div>
                    <div class="col-sm-4">
                        <label class="control-label" for="txt_empname">
                            password:</label>
                        <span id="txtPassword"></span>
                    </div>
                    <div class="col-sm-4">
                    </div>
                </div>
            </div>
            <div class="box box-danger">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Rejoin Details</h3>
                </div>
                <div id="div_rejoinData" style="padding-bottom: 2%;">
                    <div id='fillform' style="display: none;">
                    </div>
                    <div class="row" >
                        <div class="col-sm-4">
                            <label class="control-label" for="txt_empname">
                                DOJ</label>
                            <span style="color: Red;">*</span>
                            <input type="date" id="txt_Doj" class="form-control" value="" />
                        </div>
                        <div class="col-sm-4">
                            <label class="control-label" for="txt_empname">
                                Department</label>
                                <input  id="ddldeptment" class="form-control" placeholder="Enter Department name" />
                           <%-- <select id="ddldeptment" class="form-control">
                                <option selected disabled value="Select Department">Select Department</option>
                            </select>--%>
                            <input id="txtdepid" type="hidden" class="form-control" name="hiddendepid" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <label class="control-label" for="txt_empname">
                                Designation</label>
                                <input id="slct_emprole" class="form-control" placeholder="Enter Designation name" />
                                  <input id="txtdesid" type="hidden" class="form-control" name="hiddendepid" />
                           <%-- <select id="slct_emprole" class="form-control">
                                <option selected disabled value="Select Department">Select Designation</option>
                            </select>--%>
                        </div>
                        <div class="row">
                            <div class="col-sm-4">
                                <label class="control-label" for="txt_empname">
                                    Reporting To:</label>
                                    <input id="slct_rep" class="form-control" placeholder="Enter Reporting name"/>
                                    <input id="txtreportempid" type="hidden" class="form-control" name="hiddenreportempid"/>
                               <%-- <select id="slct_rep" class="form-control">
                                    <option selected disabled value="Select Department">Select Reporting</option>
                                </select>--%>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box box-danger" style="box-shadow: 0 1px 1px rgba(0,0,0,0);">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>login Details</h3>
                    </div>
                    <div class="panelWidget">
                        <input type="checkbox" id="chk_add_login" name="add_login" value="add_login">
                        <label for="chk_add_login" id="add_login" title="Check">
                            Add Login</label>
                        <div class="queryPanelWidget" id="login_details" style="display: none">
                            <table class="qpwTable">
                                <tbody>
                                    <tr>
                                    <td>
                                        <label   class="control-label">
                                            User Name
                                        </label>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_username" style="height: 35px;" placeholder="Enter User Name ">
                                        </td>
                                        <td>
                                         <label   class="control-label">
                                            Password
                                        </label>
                                        </td>
                                        <td>
                                            <input type="password" class="form-control" id="txt_password" style="height: 35px;" placeholder="Enter Password">
                                        </td>
                                        <td>
                                         <label   class="control-label">
                                            Conform Password
                                        </label>
                                        </td>
                                        <td>
                                            <input type="password" class="form-control" id="txt_confpassword" style="height: 35px;" placeholder="Enter Conform Password">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="btn_modify" style="width: 100%; text-align: center; display: block;">
                    <input type="button" class="btn btn-success" id="btn_save" value="save" onclick="save_rejion_detailes();" />
                    <input id="close_vehmaster" type="button" class="btn btn-primary" name="Close" value="Close"
                        onclick="canceldetails();" />
                </div>
            </div>
        </div>
    </div>
    </div>
    </div>
    <div id="div_approval">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Requests Details
                </h3>
            </div>
            <div class='divcontainer' style="overflow: auto;">
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
                                <label>
                                    Remarks</label>
                            </td>
                            <td style="height: 40px;">
                                <textarea id="txt_remarks" type="text" class="form-control" name="Remarks" placeholder="Enter remarmks"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_rejoining_reject_click();" />
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
    </div>
    </section>
</asp:Content>
