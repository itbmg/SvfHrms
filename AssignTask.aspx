<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="AssignTask.aspx.cs" Inherits="AssignTask" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            //get_Dept_details();
            get_Employeedetails();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_dateofassigning').val(today);
            $('#txt_dateofFinshing').val(today);
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
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                }
            }
        }


        function save_assign_task_click() {
            //var department = document.getElementById('selct_department').value;
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                alert("Enter Employee Name");
                return false;
            }
            var project = document.getElementById('txt_Project').value;
            if (project == "") {
                alert("Enter project");
                return false;
            }
            var module = document.getElementById('txt_module').value;
            var task = document.getElementById('txt_Task').value;
            if (task == "") {
                alert("Enter task");
                return false;
            }
            var dateofassign = document.getElementById('txt_dateofassigning').value;
            var dateoffinshing = document.getElementById('txt_dateofFinshing').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_assign_task_click', 'employeid': employeid, 'project': project, 'task': task, 'module': module, 'dateofassign': dateofassign, 'dateoffinshing': dateoffinshing, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("Task Details Assigned Successfully");
                        canceldetails();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function canceldetails() {
            //document.getElementById('selct_department').selectedIndex = 0;
            document.getElementById('selct_employe').value = "";
            document.getElementById('txt_Project').value = "";
            document.getElementById('txt_module').value = "";
            document.getElementById('txt_Task').value = "";
            document.getElementById('txt_dateofassigning').value = "";
            document.getElementById('txt_dateofFinshing').value = "";
        }

        function validateEmail(email) {
            var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
            if (reg.test(email)) {
                return true;
            }
            else {
                return false;
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



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Assign Task Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Task Management</a></li>
            <li><a href="#">Assign Task Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Assign Task Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="Up1" runat="server">
                    <ContentTemplate>
                        <div class="row-fluid">
                            <div style="padding-left: 150px;">
                                <table id="tblAppraisals" runat="server" class="tablecenter" width="98%">
                                    <tr>
                                        <%--<td>
                                            Department
                                        </td>
                                        <td>
                                            <select id="selct_department" class="form-control">
                                                <option selected disabled value="Select Department">Select Department</option>
                                            </select>
                                        </td>--%>
                                        <td>
                                            Employee Name
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name" />
                                        </td>
                                        <td style="height: 40px; display:none">
                                            <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                        </td>
                                        <td style="height: 40px;">
                                            Project
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_Project" placeholder="Enter Project" onkeypress="return ValidateAlpha(event);" />
                                        </td>
                                        </tr>
                                        <tr>
                                        <td style="height: 40px;">
                                            Module
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_module" placeholder="Enter Module" onkeypress="return ValidateAlpha(event);"/>
                                        </td>
                                   
                                        <td style="height: 40px;">
                                            Task
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_Task" placeholder="Enter Task" onkeypress="return ValidateAlpha(event);"/>
                                        </td>
                                         </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            Date Of Assigning
                                        </td>
                                        <td>
                                            <input type="date" class="form-control" id="txt_dateofassigning" />
                                        </td>
                                        <td style="height: 40px;">
                                            Date Of Finishing
                                        </td>
                                        <td>
                                            <input type="date" class="form-control" id="txt_dateofFinshing" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div>
                            <table align="center">
                                <tr>
                                    <td>
                                        <input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="save_assign_task_click();" />
                                        <input type="button" class="btn btn-danger" id="close_id" value="Close" onclick="canceldetails();" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </section>
</asp:Content>
