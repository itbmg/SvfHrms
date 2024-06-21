<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="SendMailPayslip.aspx.cs" Inherits="SendMailPayslip" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Dept_details();
            get_Employeedetails();
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
                        change: getdatadepchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function getdatadepchange() {
            document.getElementById('txt_department').value = "";
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('<%=txtsupid.ClientID %>').value = employeedetails[i].empsno;
                    document.getElementById('selct_employe').value = employeedetails[i].empsno;
                    var empname = document.getElementById('selct_employe').value;
                    var data = { 'op': 'getdatadepchange', 'empname': empname };
                    var s = function (msg) {
                        if (msg) {
                            if (msg.length > 0) {
                                fillemployee(msg);
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
            }
        }

        var emptydata = []; var emptydata1 = [];
        function fillemployee(msg) {
            $("#div_departdata").hide();
            $("#div_employeedata").show();
            emptydata = msg;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table" class="btn btn-primary" id="tabledetailss">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Department</th><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Branch</th></tr></thead></tbody>';
            for (var i = 0; i < emptydata.length; i++) {
                results += '<tr><td><input id="btn_poplate" scope="col" type="checkbox"  onclick="getme(this)"  name="submit" value="Edit" /></td>';
                results += '<td data-title="PlantCode" style="display:none"   class="10">' + emptydata[i].empsno + '</td>';
                results += '<td data-title="BankID" class="checkall">' + emptydata[i].Department + '</td>';
                results += '<td data-title="PlantCode"   class="11">' + emptydata[i].empname + '</td>';
                results += '<td data-title="VehicleNumber"  class="checkall">' + emptydata[i].empnum + '</td>';
                results += '<td data-title="AccountNumber" class="checkall">' + emptydata[i].branchname + '</td>';
                results += '<td data-title="ifsccode" style="display:none"  class="6">' + emptydata[i].deptid + '</td>';
                results += '<td data-title="Status" style="display:none"  class="7">' + emptydata[i].branchid + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_employeedata").html(results);
            //  $("#div_employeedata").show();
        }


        var depatmentdetails = [];
        function get_Dept_details() {
            var data = { 'op': 'get_Dept_details' };
            var s = function (msg) {
                if (msg) {
                    depatmentdetails = msg;
                    var depnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var Department = msg[i].Department;
                        depnameList.push(Department);
                    }
                    $('#txt_department').autocomplete({
                        source: depnameList,
                        change: getdataemployeechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function getdataemployeechange() {
            document.getElementById('selct_employe').value = "";
            var Department = document.getElementById('txt_department').value;
            for (var i = 0; i < depatmentdetails.length; i++) {
                if (Department == depatmentdetails[i].Department) {
                    document.getElementById('txt_department').value = depatmentdetails[i].Deptid;
                    var Department = document.getElementById('txt_department').value;
                    var data = { 'op': 'getdataemployeechange', 'Department': Department };
                    var s = function (msg) {
                        if (msg) {
                            if (msg.length > 0) {
                                filldata(msg);

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
            }
        }

        var emptydata = []; var emptydata1 = [];
        function filldata(msg) {
            $("#div_employeedata").hide();
            $("#div_departdata").show();
            emptydata = msg;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table" class="btn btn-primary" id="tabledetails">';
            results += '<thead><tr><th><input id="chkAll" class="chckclass" scope="col" type="checkbox" onclick="return Check_employee_onclick();" value="SelectAll"/></th><th scope="col">Department</th><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Branch</th></tr></thead></tbody>';
            for (var i = 0; i < emptydata.length; i++) {
                results += '<tr><td><input id="btn_poplate" class="chckclass" scope="col" type="checkbox"  name="submit" value="Edit" /></td>';
                results += '<td data-title="PlantCode" style="display:none" class="chckclass"   class="10">' + emptydata[i].empsno + '</td>';
                results += '<td data-title="BankID" class="chckclass">' + emptydata[i].Department + '</td>';
                results += '<td data-title="PlantCode"   class="chckclass">' + emptydata[i].empname + '</td>';
                results += '<td data-title="VehicleNumber"  class="chckclass">' + emptydata[i].empnum + '</td>';
                results += '<td data-title="AccountNumber" class="chckclass">' + emptydata[i].branchname + '</td>';
                results += '<td data-title="ifsccode" style="display:none"  class="6">' + emptydata[i].deptid + '</td>';
                results += '<td data-title="Status" style="display:none"  class="7">' + emptydata[i].branchid + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_departdata").html(results);
            // $("#div_Agentdata").show();
        }

        function Check_employee_onclick() {
            $(function () {
                $("#tabledetails [id*=chkAll]").click(function () {
                    if ($(this).is(":checked")) {
                        $("#tabledetails [id*=btn_poplate]").attr("checked", "checked");
                    } else {
                        $("#tabledetails [id*=btn_poplate]").removeAttr("checked");
                    }
                });
                $("#tabledetails [id*=chkRow]").click(function () {
                    if ($("#tabledetails [id*=btn_poplate]").length == $("#tabledetails [id*=btn_poplate]:checked").length) {
                        $("#tabledetails [id*=chkAll]").attr("checked", "checked");
                    } else {
                        $("#tabledetails [id*=chkAll]").removeAttr("checked");
                    }
                });
            });
        }


    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
            SendMail Payslip Generation<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Generation Management</a></li>
            <li><a href="#">Send Mail Payslip</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
        <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>SendMail Payslip Generation
                </h3>
            </div>
            <table id="tbl_leavemanagement" align="center">
                <tr>
                 <td style="height: 40px;">
                        Department Name<span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txt_department" placeholder="Enter Department name" onchange="getdataemployeechange();"/>
                    </td>
                    <td style="height: 40px; display: none">
                        <asp:TextBox ID="txt_departmentid" runat="server"></asp:TextBox>
                    </td>
                     <td style="width: 35px">
                                    OR
                                </td>
                    <td style="height: 40px;">
                        Employe Name<span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" onchange="getdataemployeechange();" />
                    </td>
                    <td style="height: 40px; display: none">
                        <asp:TextBox ID="txtsupid" runat="server"></asp:TextBox>
                    </td>
                    <td style="width: 5px;">
                    </td>
                     <td style="width: 5px;">
                    </td>
                    <td>
                        Month
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlmonth" runat="server">
                            <asp:ListItem Value="1" Selected="True" Text="Month">Month</asp:ListItem>
                            <asp:ListItem Value="3" Text="Last 3 Months">Last 3 Months</asp:ListItem>
                            <asp:ListItem Value="6" Text="Last 6 Months">Last 6 Months</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                    </td>
               
                <td colspan="9">
                <div>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" EmptyDataText="No files available">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server"/>
                                <asp:Label ID="lblFilePath" runat="server" Text='<%# Eval("Value") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Text" HeaderText="File Name" />
                    </Columns>
                </asp:GridView>
            </div>
            </td>
             </tr>
            </table>
        <div>
                <div id="div_employeedata">
                </div>
            </div>
            <div>
                <div id="div_departdata">
                </div>
            </div>
            <div class="box-body" style="display: none;">
                <table id="Table1" runat="server" class="tablecenter" width="98%">
                    <tr>
                        <td style="height: 40px;">
                            <label>
                                Employee Code:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="txtEmployeeCode" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                Employee Name:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnemployeename" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                For Month:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnmonth" style="color: Red;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <label>
                                No. of Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnnoofdays" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                Effective Working Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnnoofworkingdays" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                Days paid:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spndayspaid" style="color: Red;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <label>
                                LOP:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnlop" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                OT Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="spnot" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtyear" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtcnten" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="Span4" style="color: Red;" />
                        </td>
                    </tr>
                </table>
                
                <table id="Table2" style="display: none;" runat="server" class="tablecenter" width="98%">
                    <tr>
                        <td style="width: 200px;">
                            <asp:TextBox ID="txtempcode" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtempname" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtmonth" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtnoofdays" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txteffectiveworkdays" runat="server"></asp:TextBox>
                        </td>
                        <td style="width: 200px;">
                            <asp:TextBox ID="txtdayspaid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtlop" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtotdays" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
            <table id="tblDetails" style="display: none;" runat="server" class="tablecenter"
                width="100%">
                <tr>
                    <td>
                        <fieldset id="Fieldset1" class="fieldset_dashed" runat="server">
                            <legend class="legend_right" align="right">
                                <asp:Label ID="lblPayrollProcessDetails" runat="server" Text="Payroll Process Details"></asp:Label>
                            </legend>
                            <table class="tablecenter" width="95%">
                                <tr>
                                    <td colspan="4" style="padding-top: 25px">
                                        <table width="100%" style="border: 1Px Solid Black;">
                                            <tr>
                                                <td colspan="3" valign="middle" align="center" style="border-style: none solid solid none;
                                                    border-width: 1px; border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblEarnings" Text="Earnings" runat="server" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td colspan="3" valign="middle" align="center" style="border-bottom: 1px solid Black;
                                                    height: 30px;">
                                                    <asp:Label ID="lblDeductions" Text="Deductions" runat="server" Font-Bold="true"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; width: 160px; height: 30px;">
                                                    <asp:Label ID="lblParticularE" runat="server" Text="Particular" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; width: 120px;">
                                                    <asp:Label ID="lblGrossEarnings" runat="server" Text="Gross Earnings (Rs.)" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblEarningsForMonth" runat="server" Text="Earnings For Month (Rs.)"
                                                        Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; width: 120px;">
                                                    <asp:Label ID="lblParticularD" runat="server" Text="Particular" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center" style="border-bottom: 1px solid Black;">
                                                    <asp:Label ID="lblDeductionsForMonth" runat="server" Text="Deductions For Month (Rs.)"
                                                        Font-Bold="true"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblBasic" runat="server" Text="Basic" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactbasic" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthbasic" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblPF" runat="server" Text="Provident Fund" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthpf" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblHRA" runat="server" Text="House Rent Allowence" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtacthra" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthhra" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblPT" runat="server" Text="Professional Tax" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthpt" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblConveyance" runat="server" Text="Conveyance" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactconveyance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthconveyance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblESI" runat="server" Text="ESI" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthesi" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblSplConveyance" runat="server" Text="Medical Allowance" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactmedicalallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthmedicalallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblIncomeTax" runat="server" Text="Income Tax" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthincometax" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                 

                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblwash" runat="server" Text="Washing Allowance" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactwashingallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthwashingallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblcanteen" runat="server" Text="Canteen Deduction" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthcanteendeduction" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-right: 1px solid Black; height: 30px;">
                                                    <asp:Label ID="lblTotalE" runat="server" Text="Total" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-right: 1px solid Black;">
                                                    <asp:TextBox ID="txtActTotalEarnings" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-right: 1px solid Black;">
                                                    <asp:TextBox ID="txtMonthTotalEarnings" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" style="border-right: 1px solid Black;">
                                                    <asp:Label ID="lblTotalD" runat="server" Text="Total" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="">
                                                    <asp:TextBox ID="txtMonthTotalDeductions" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>
                                            </td>
                                            <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblLoan" runat="server" Text="Loan" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtloan" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>
                                            </td>
                                            <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblmobile" runat="server" Text="Loan" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtMobile" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" align="center" style="padding-top: 15px">
                                        <asp:Label ID="Label7" runat="server" Text="Net Pay: " Font-Bold="true"></asp:Label>
                                        <asp:TextBox ID="txtNetPayAmount" runat="server" Font-Bold="true"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
            </div>
            <div>
                <table align="center">
                    <tr>
                        <td>
                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                                OnClick="btn_generate_click" /><br />
                           <%-- <input id="SendMail" type="button" class="btn btn-primary" name="submit" value="Send Mail" OnClick="btn_generate_click()">--%>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </section>
</asp:Content>


