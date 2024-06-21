<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master"   enableEventValidation="false"
    CodeFile="PayslipGeneration.aspx.cs" Inherits="PayslipGeneration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
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
            var status = "payslipgenration";
            var data = { 'op': 'get_Employeedetails', 'status': status };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    var empcodeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empnum = msg[i].empnum;
                        empcodeList.push(empnum);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                    $('#txt_Empcode').autocomplete({
                        source: empcodeList,
                        change: employeecodechange,
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
                    document.getElementById('<%=txtsupid.ClientID %>').value = employeedetails[i].empsno;
                    document.getElementById('txt_Empcode').value = employeedetails[i].empnum;
                }
            }
        }
        function employeecodechange() {
            var empnum = document.getElementById('txt_Empcode').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empnum == employeedetails[i].empnum) {
                    document.getElementById('<%=txtsupid.ClientID %>').value = employeedetails[i].empsno;
                    document.getElementById('selct_employe').value = employeedetails[i].empname;
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Payslip Generation<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Generation Management</a></li>
            <li><a href="#">Payslip</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Payslip Generation
                </h3>
            </div>
            <table id="tbl_leavemanagement" align="center">
                <tr>
                <td style="height: 40px;">
                        Employee Code<span style="color: red;">*</span>
                    </td>
                     <td>
                        <input type="text" class="form-control" id="txt_Empcode" placeholder="Enter employee Code" />
                    </td>
                    <td style="height: 40px;">
                        Employee Name<span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" />
                    </td>
                    <td style="height: 40px; display: none">
                        <asp:TextBox ID="txtsupid" runat="server"></asp:TextBox>
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td>
                        Month
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlmonth" runat="server">
                            <asp:ListItem Value="1" Selected="True" Text="Month">Month</asp:ListItem>
                            <asp:ListItem Value="2"  Text="lastMonth">lastMonth</asp:ListItem>
                            <asp:ListItem Value="3" Text="Last 3 Months">Last 3 Months</asp:ListItem>
                            <asp:ListItem Value="10" Text="Last 6 Months">Last 6 Months</asp:ListItem>
                        </asp:DropDownList>
                        <%--<select name="month" id="selct_month" onchange="" class="form-control" size="1">
                            <option value="1">Month</option>
                            <option value="3">Last 3 Months</option>
                            <option value="6">Last 6 Months</option>
                        </select>--%>
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td>
                        <asp:Button ID="btngenerate" runat="server" Text="Generate" OnClick="btn_generate_click" />
                        <asp:Button ID="btnmnthgenerate" runat="server" Text="Generete" OnClick="btn_mnthgenarate_click" />
                    </td>
                </tr>
                <tr>
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
                            <asp:TextBox ID="txtemail" runat="server"></asp:TextBox>
                        </td>
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
                          <td style="height: 100px;">
                            <asp:TextBox ID="txtpan" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
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
                                                 <td>
                                            </td>
                                            <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblMediclaim" runat="server" Text="Mediclaim" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txt_Mediclaim" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                             <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblothededuction" runat="server" Text="Mediclaim" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txt_Otherdeduction" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblmobile" runat="server" Text="Loan" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtMobile" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lbl_tds" runat="server" Text="Loan" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txt_TdsDeduction" runat="server" Font-Bold="true"></asp:TextBox>
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
    </section>
</asp:Content>
