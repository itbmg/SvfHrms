<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="bulkmailsend.aspx.cs" Inherits="bulkmailsend" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {

        });

        function Check_Click(objRef) {
            var row = objRef.parentNode.parentNode;
            if (objRef.checked) {
                row.style.backgroundColor = "aqua";
            }
            else {
                if (row.rowIndex % 2 == 0) {
                    row.style.backgroundColor = "#C2D69B";
                }
                else {
                    row.style.backgroundColor = "white";
                }
            }
            var GridView = row.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var headerCheckBox = inputList[0];
                var checked = true;
                if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {
                    if (!inputList[i].checked) {
                        checked = false;
                        break;
                    }
                }
            }
            headerCheckBox.checked = checked;
        }

        function checkAll(objRef) {
            var GridView = objRef.parentNode.parentNode.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var row = inputList[i].parentNode.parentNode;
                if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                    if (objRef.checked) {
                        row.style.backgroundColor = "aqua";
                        inputList[i].checked = true;
                    }
                    else {
                        if (row.rowIndex % 2 == 0) {
                            row.style.backgroundColor = "#C2D69B";
                        }
                        else {
                            row.style.backgroundColor = "white";
                        }
                        inputList[i].checked = false;
                    }
                }
            }
        }
        function MouseEvents(objRef, evt) {
            var checkbox = objRef.getElementsByTagName("input")[0];
            if (evt.type == "mouseover") {
                objRef.style.backgroundColor = "orange";
            }
            else {
                if (checkbox.checked) {
                    objRef.style.backgroundColor = "aqua";
                }
                else if (evt.type == "mouseout") {
                    if (objRef.rowIndex % 2 == 0) {
                        //Alternating Row Color
                        objRef.style.backgroundColor = "white";
                    }
                    else {
                        objRef.style.backgroundColor = "white";
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
                     <label class="control-label" >
                        Department Name<span style="color: red;">*</span>
                        </label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddldepartment" runat="server" OnSelectedIndexChanged="ddldepartment_SelectedIndexChanged"
                            AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td>
                     <label class="control-label" >
                        Month
                        </label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlmonth" runat="server">
                            <asp:ListItem Value="1" Selected="True" Text="Month">Month</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <div>
                <div id="div_employeedata">
                </div>
            </div>
            <div>
                <div id="div_departdata" style="padding-left: 190px;">
                    <asp:GridView ID="GridView2" runat="server" HeaderStyle-CssClass="header" AutoGenerateColumns="false"
                        Font-Names="Arial" OnRowDataBound="RowDataBound" Font-Size="11pt">
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:CheckBox ID="checkAll" runat="server" onclick="checkAll(this);" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" onclick="Check_Click(this)" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                             <ItemTemplate>
                                    <asp:Label ID="lblempid" runat="server" Text='<%# Eval("empid") %>' Visible="false"></asp:Label> </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField ItemStyle-Width="150px" DataField="empid" HeaderText="empid" />
                            <asp:BoundField ItemStyle-Width="150px" DataField="employee_num" HeaderText="employee no" />
                            <asp:BoundField ItemStyle-Width="150px" DataField="fullname" HeaderText="fullname" />
                            <asp:BoundField ItemStyle-Width="150px" DataField="department" HeaderText="department" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="box-body" style="display: none;">
                <table id="Table1" runat="server" class="tablecenter" width="98%">
                    <tr>
                        <td style="height: 40px;">
                            <label class="control-label" >
                                Employee Code:</label>
                                
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="txtEmployeeCode" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label class="control-label" >
                                Employee Name:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnemployeename" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                             <label class="control-label" >
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
                            <label class="control-label" >
                                No. of Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnnoofdays" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label class="control-label" >
                                Effective Working Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnnoofworkingdays" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                           <label class="control-label" >
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
                            <label class="control-label" >
                                LOP:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnlop" style="color: Red;" />
                        </td>
                         <td style="height: 40px;">
                             <label class="control-label" >
                               PAN Number:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="spn_pan" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label class="control-label" >
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
            <div>
                <table align="center">
                    <tr>
                        <td>
                           <%-- <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                OnClick="btn_generate_click" /><br />--%>
                                <td>
                        <asp:Button ID="btngenerate" runat="server" Text="Generate" OnClick="btn_generate_click" />
                        <asp:Button ID="btnmnthgenerate" runat="server" Text="Generete" OnClick="btn_mnthgenarate_click" />
                    </td>
                            <%-- <input id="SendMail" type="button" class="btn btn-primary" name="submit" value="Send Mail" OnClick="btn_generate_click()">--%>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </section>
</asp:Content>
