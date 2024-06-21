<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="biometriclogdetails.aspx.cs" Inherits="biometriclogdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
            $('#txt_fromdate').val(today);
            $('#txt_todate').val(today);
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
                alert("Please Select Branch");
                return false;
            }
            var result = [];
            emptytable4 = [];
            var Data = { 'op': 'get_blogs', 'branch': branch, 'fromdate': fromdate, 'todate': todate };
            var s = function (msg) {
                TotalDate = msg[0].Allbiomertcdates;
                totattendance = msg[0].biometricAttendance;
                var results = '<div class="divcontainer" style="overflow:auto;"><table id="tblbiologs" class="responsive-table">';
                results += '<thead><tr>';
                results += '<th scope="col" style="text-align:center;"><i class="fa fa-user" aria-hidden="true"></i> Employee Name</th>';
                for (var i = 0; i < TotalDate.length; i++) {
                    results += '<th scope="col" id="txtDate"><i class="fa fa-calendar" aria-hidden="true"></i> ' + TotalDate[i].Betweendates + '</th>';
                }
                results += '</tr></thead></tbody>';
                for (var i = 0; i < totattendance.length; i++) {
                    results += '<tr>';
                    var Employeename = totattendance[i].Employeename
                    if (emptytable4.indexOf(Employeename) == -1) {
                        results += '<td data-title="brandstatus" class="4">' + totattendance[i].Employeename + '</td>';
                        results += '<td style="display:none" data-title="brandstatus" class="3">' + totattendance[i].Empid + '</td>';
                        emptytable4.push(Employeename);
                        for (var j = 0; j < TotalDate.length; j++) {
                            var d = 1;
                            for (var k = 0; k < totattendance.length; k++) {
                                if (TotalDate[j].Betweendates == totattendance[k].LogDate && Employeename == totattendance[k].Employeename) {
                                    if (totattendance[k].status != "") {
                                        var st = totattendance[k].Empid + '-' + totattendance[k].LogDate;
                                        results += '<td class="1" style="display:none"><input class="form-control" type="text" name="empid" id="txtempid"  value="' + st + '"/></td>';
                                        results += '<td id="' + st + '" data-title="brandstatus" class="1"><a id="' + st + '"  onclick="logsclick(this);" title="' + st + '" data-toggle="modal" data-target="#myModal">' + totattendance[k].Time_diff + '</a></td>';
                                        results += '<td style="display:none" data-title="brandstatus" class="2">' + totattendance[k].LogDate + '</td>';
                                        d = 0;
                                    }
                                }
                            }
                            if (d == 1) {
                                var status = "A"
                                st = 1 + '-' + 1;
                                results += '<td class="1" style="display:none"><input class="form-control" type="text" name="empid" id="txtempid"  value="' + st + '"/></td>';
                                results += '<td id="' + st + '" data-title="brandstatus" class="1"><a id="' + st + '"   title="' + st + '" data-toggle="modal" data-target="#myModals">A</a></td>';
                                results += '<td style="display:none" data-title="brandstatus" class="2"></td>';
                            }
                        }
                        results += '</tr>';
                    }
                }
                results += '</table></div>';
                $("#tbl_employeemonthlyattendance").html(results);
            };
            var e = function (x, h, e) {
            };
            callHandler(Data, s, e);
        }
        function logsclick(thisid) {
           var empid = $(thisid).attr('title');
            var data = { 'op': 'get_bimetriclogdetails_details', 'empid': empid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbiologs(msg)
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
        function fillbiologs(msg) {
            $("#divlogs").html('');
            var k = 1;
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Log DATE</th><th scope="col">Status</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].logdate + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#divlogs").html(results);
        }
        function btn_cancelApply_click() {
            document.getElementById('divemployee').innerHTML = "";
            document.getElementById('lbl_currentgrade').innerHTML = "...";
            document.getElementById('lbl_currentsection').innerHTML = "...";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employe Bio-Metric Logs <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Employe Bio-Metric Logs</a></li>
            <li><a href="#">Employe Bio-Metric Logs</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
<div id="div_Monthlyattdnce" >
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employe Bio-Metric Logs
                    </h3>
                </div>
                <table id="mytable" align="center">
                    <tr>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                          <label class="control-label">
                            Branch Name
                            </label>
                        </td>
                        <td>
                            <select id="selct_branch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Department">Select Department</option>
                            </select>
                        </td>
                        <td style="height: 40px;">
                          <label class="control-label">
                            From Date <span style="color: red;">*</span>
                            </label>
                        </td>
                        <td>
                            <input type="date" class="form-control" id="txt_fromdate" class="form-control" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                          <label class="control-label">
                            TO Date <span style="color: red;">*</span>
                            </label>
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
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Select Branch(s)
                           
                        </h3>
                    </div>
                    <div class="col span_1_of_2">
                        <div id="tbl_employeemonthlyattendance" style="background: #ffffff">
                        </div>
                    </div>
                </div>
                
            </div>
        </div>

        <div id="myModal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            &times;</button>
                        <h4 class="modal-title">
                            Logs Details</h4>
                    </div>
                    <div class="modal-body">
                       <table align="center">
                        <tr>
                            <td colspan="4">
                                <div id="divlogs">
                                </div>
                            </td>
                        </tr>
                    </table>
                    
                    </div>
                    <div class="modal-footer">
                        <button id="btnaclose" type="button" class="btn btn-default" data-dismiss="modal">
                            Close</button>
                    </div>
                </div>
            </div>
        </div>
        </section>
</asp:Content>
