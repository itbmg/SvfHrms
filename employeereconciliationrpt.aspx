<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="employeereconciliationrpt.aspx.cs" Inherits="employeereconciliationrpt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employe Reconcilation Report
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Employee reconciliation report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee reconciliation Details
                </h3>
            </div>
            <div style="padding-left:30%;">
            <table>
                <tr>
                    <td>
                        <label>
                            PayRoll</label>
                    </td>
                    <td style="width:20px;">
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlmonth" runat="server" CssClass="ddlclass" Width="200px" Height="30px">
                        </asp:DropDownList>
                    </td>
                    <td style="width:20px;">
                    </td>
                    <td>
                        <asp:Button ID="btngenarate" runat="server" Text="Genarate" OnClick="btn_genarate_click" CssClass="btn btn-primary"/> 
                    </td>
                </tr>
                </table>
            </div>
            <br />
            <br />
            <div class="box-body">
                <div id='fillform' style="border-style: ridge;">
                    <table>
                        <tr>
                            <td>
                                <label>
                                 1 &nbsp&nbsp Employee processed in <span id="spnbmonth" runat="server"></span> </label>
                            </td>
                            <td>
                               <asp:Label ID="lblmay" runat="server"></asp:Label>
                            </td>
                        </tr>
                       <tr>
                            <td>
                                <label>
                                 2 &nbsp&nbsp Employees processed in <span id="spncmonth" runat="server"></span> ( Including Settled )  </label>
                            </td>
                            <td>
                               <asp:Label ID="Label1" runat="server" Text="8"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                 3 &nbsp&nbsp Employees joined and not excluded  </label>
                            </td>
                            <td>
                               <asp:Label ID="Label2" runat="server"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                 4 &nbsp&nbsp Employees joined last month and processed for the first time this month  </label>
                            </td>
                            <td>
                               <asp:Label ID="Label3" runat="server"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                 5 &nbsp&nbsp Employees excluded last month but not resigned this month and not excluded this month </label>
                            </td>
                            <td>
                               <asp:Label ID="Label4" runat="server"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                 6 &nbsp&nbsp Employees resigned last month but still a part of previous month and not In this month </label>
                            </td>
                            <td>
                               <asp:Label ID="Label5" runat="server"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                 7 &nbsp&nbsp Employees in last month and excluded this month </label>
                            </td>
                            <td>
                               <asp:Label ID="Label6" runat="server"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                 8 &nbsp&nbsp Employees in last month and resigned this month </label>
                            </td>
                            <td>
                               <asp:Label ID="Label7" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                 9 &nbsp&nbsp Employees in current month and joined after this month </label>
                            </td>
                            <td>
                               <asp:Label ID="Label8" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                 10 &nbsp&nbsp Employees resigned in previous month(s) and settled in June2016 </label>
                            </td>
                            <td>
                               <asp:Label ID="Label9" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                 11 &nbsp&nbsp Employees resigned in previous month(s) and settled in May2016 </label>
                            </td>
                            <td>
                               <asp:Label ID="Label10" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>
                                 12 &nbsp&nbsp NET ( 1 + 3 + 4 + 5 + 9) - ( 2 + 6 + 7 + 8 + 10 + 11 )  </label>
                            </td>
                            <td>
                               <asp:Label ID="Label11" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 3 . ( Employees joined and not excluded )</label>
                
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 4. ( Employess joined last month and processed for the first time this month ) </label>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 5. ( Employee excluded last month but not resigned this month and not excluded this month )</label>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 6. ( Employees resigned last month but still a part of previous month and not in this month )</label>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 7. ( Employees in last month and excluded this month )</label>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 8. ( Employees in last month and resigned this month )</label>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 9. ( Employees in current month and joined after this month )</label>
                </div>

                <div style="border-style:ridge;">
                <label>Schedule 10. Employees resigned in previous month(s) and settled in June2016 </label>
                </div>
                <div style="border-style:ridge;">
                <label>Schedule 11. Employees resigned in previous month(s) and settled in May2016 </label>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
