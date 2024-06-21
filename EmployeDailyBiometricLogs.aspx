<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeDailyBiometricLogs.aspx.cs" Inherits="EmployeDailyBiometricLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   <script type="text/javascript">
       $(function () {
           get_CompanyMaster_details();
//           employeetype();
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
//       function employeetype() {
//           var data = { 'op': 'get_employeetype_fill' };
//           var s = function (msg) {
//               if (msg) {
//                   if (msg.length > 0) {
//                       fillemployeetype1(msg);
//                   }
//               }
//               else {
//               }
//           };
//           var e = function (x, h, e) {
//           };
//           $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
//           callHandler(data, s, e);
//       }


//       function fillemployeetype1(msg) {
//           var data = document.getElementById('emp_type');
//           var length = data.options.length;
//           document.getElementById('emp_type').options.length = null;
//           var opt = document.createElement('option');
//           opt.innerHTML = "EmployeeType";
//           opt.value = "EmployeeType";
//           opt.setAttribute("selected", "selected");
//           opt.setAttribute("disabled", "disabled");
//           opt.setAttribute("class", "dispalynone");
//           data.appendChild(opt);
//           for (var i = 0; i < msg.length; i++) {
//               if (msg[i].employee_type != null) {
//                   var option = document.createElement('option');
//                   option.innerHTML = msg[i].employee_type;
//                   option.value = msg[i].employee_type;
//                   data.appendChild(option);
//               }
//           }
//       }
       function btn_attendance_click() {
           $("#div_attendance").css("display", "block");
           var doe = document.getElementById('txtDOA').value;
           var company_code = document.getElementById("selct_Cmpny").value;
           var branchid = document.getElementById('ddlbrnch').value;
           var data = { 'op': 'btn_attendance_click', 'doe': doe, 'company_code': company_code, 'branchid': branchid };
           var s = function (msg) {
               if (msg) {
                   if (msg.length > 0) {
                       filldetails(msg);
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
       function filldetails(msg) {
           var l = 0;
//           var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
           var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
           results += '<thead><tr style="background-color:white;font-size: 12px;"><th scope="col" >BranchName</th><th scope="col">TotalEmp</th><th scope="col">Present </th><th scope="col">Absent </th></tr></thead></tbody>';
           for (var k = 0; k < msg.length; k++) {
               results += '<tr >';
//               results += '<th scope="row"  class="1"><span id="spninqty"  onclick="get_DeptemployeesAttendence(this);"><i class="fa fa-arrow-circle-right" style="width: 22px;" aria-hidden="true"></i><span style="text-decoration: none;">' + msg[k].deptname + '</th>';
               results += '<td class="2" >' + msg[k].branchname + '</td>';
               results += '<td class="3" >' + msg[k].totemp + '</td>';
               results += '<td class="4" >' + msg[k].ToatalEmpPresent + '</td>';
               results += '<td  class="6" >' + msg[k].absentemploys + '</td>';
               results += '</tr>';
               l = l + 1;
               if (l == 4) {
                   l = 0;
               }
           }
           results += '</table></div>';
           $("#divattendance").html(results);
       }
    </script>   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
        <section class="content-header">
        <h1>
            Employe DailyBiometric Logs <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Employe DailyBiometric Logs</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employe DailyBiometric Logs
                </h3>
            </div>
        <div class="box box-info">
            <div id="div_empattdance" >
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
                        <%--<td style="height: 40px;">
                           Employee Type
                        
                            <select id="emp_type" class="form-control" style="width: 200px;"  style="display:none";>
                                <option selected disabled value="Select state">EmployeeType</option>
                            </select>
                        </td>--%>

                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                            <input id="btn_Students" type="button" class="btn btn-primary" name="submit" value="Get Employees"
                                onclick="btn_attendance_click();" style="width: 100px;">
                        </td>
                            </tr>
                        </table>
                     </div>
                         <div class="box-body" id="div_attendance" style="display:none;">
                        <div class="box-body no-padding" style="height: 300px; ">
                         <div id="divattendance" style="height: 300px; overflow-y: scroll;">
                  </div>
                </div>
            </div>
            </div>
            </section>
</asp:Content>

