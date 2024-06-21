<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Tabs.aspx.cs" Inherits="Tabs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script type="text/JavaScript">
    $(function () {
        showEmployeeImport();
    });


    function showEmployeeImport() {
        $("#div_EmployeeImport").show();
        $("#div_ImportAttendance").hide();
        $("#div_CanteenDeduction").hide();
        $("#div_MobileDeduction").hide();
        }
        function showMonthlyAttendanceImport() {
            $("#div_ImportAttendance").show();
            $("#div_EmployeeImport").hide();
            $("#div_CanteenDeduction").hide();
            $("#div_MobileDeduction").hide();
        }
        function showCanteenDeductionmport() {
            $("#div_CanteenDeduction").show();
            $("#div_EmployeeImport").hide();
            $("#div_ImportAttendance").hide();
            $("#div_MobileDeduction").hide(); ;
        }
        function showMobileDeductionImport() {
            $('#div_MobileDeduction').show()
            $("#div_EmployeeImport").hide();
            $("#div_CanteenDeduction").hide();
            $("#div_ImportAttendance").hide();
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
    <div>
        <section class="content-header">
            <h1>
                 Import<small>Preview</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
                <li><a href="#"> Import</a></li>
            </ol>
            <div class="box box-info">
                <div class="box-header with-border">
                </div>
                <div class="box-body">
                    <div>
                        <ul class="nav nav-tabs">
                            <li id="Li2" class="active"><a data-toggle="tab" href="#" onclick="showEmployeeImport()"><i
                                class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Employee Details</a></li>
                            <li id="id_tab_Personal" class=""><a data-toggle="tab" href="#" onclick="showMonthlyAttendanceImport()">
                                <i class="fa fa-registered" aria-hidden="true"></i>&nbsp;&nbsp;MonthlyAttendance</a></li>
                            <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showCanteenDeductionmport()">
                                <i class="fa fa-file-text"></i>&nbsp;&nbsp;CanteenDeduction</a></li>
                            <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showMobileDeductionImport()">
                                <i class="fa fa-mobile" aria-hidden="true"></i>&nbsp;&nbsp;MobileDeduction</a></li>
                        </ul>
                    </div>
                    <div id="div_EmployeeImport" style="display: none;">
                    <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Import Details
                    </h3>
                </div>
                <div class="box-body">
                    <table>
                        <tr>
                            <td>
                                <asp:FileUpload ID="EmployeeFileUploadToServer" runat="server" Style="height: 25px; font-size: 16px;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <asp:Button ID="btn_ImportEmp" runat="server" Text="Import" class="btn btn-primary" OnClick="btnEmployeeImport_Click" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="grvempExcelData" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                GridLines="Both" Font-Bold="true" Font-Size="Smaller">
                                <EditRowStyle BackColor="#999999" />
                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                    Font-Names="Raavi" />
                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                <AlternatingRowStyle HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                            </asp:GridView>
                            </dr>
                            <asp:Button ID="btn_empSave" runat="server" Text="Save" class="btn btn-primary" OnClick="btnEmployeeSave_Click" />
                            <asp:Label ID="Label1" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label><br />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </div>
                    </div>
                    <div id="div_ImportAttendance" style="display: none;">
                        <div class="box-header with-border">
                            <h3 class="box-title">
                                <i style="padding-right: 5px;" class="fa fa-cog"></i>Monthly Attendance Import Details
                            </h3>
                        </div>
                        <div class="box-body">
                            <table>
                                <tr>
                                    <td>
                                        <asp:FileUpload ID="FileUploadToServer" runat="server" Style="height: 25px; font-size: 16px;" />
                                    </td>
                                    <td style="width: 5px;">
                                    </td>
                                    <td>
                                        <asp:Button ID="btnImport" runat="server" Text="Import" class="btn btn-primary" OnClick="btnAttendanceImport_Click" />
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <asp:Label ID="lblMessage" runat="server" Visible="False" Font-Bold="True" ForeColor="#009933"></asp:Label><br />
                            <asp:UpdatePanel ID="updPanel" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="grvExcelData" runat="server">
                                        <HeaderStyle BackColor="#df5015" Font-Bold="true" ForeColor="White" />
                                    </asp:GridView>
                                    </dr>
                                    <asp:Button ID="btnsave" runat="server" Text="Save" class="btn btn-primary" OnClick="btnAttendanceSave_Click" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                    <div id="div_CanteenDeduction" style="display: none;">
                    <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Deduction Import Details
                    </h3>
                </div>
                <div class="box-body">
                    <table>
                        <tr>
                            <td>
                                <asp:FileUpload ID="CanteenFileUploadToServer" runat="server" Style="height: 25px; font-size: 16px;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <asp:Button ID="btn_canteen" runat="server" Text="Import" class="btn btn-primary"
                                    OnClick="btnCanteenImport_Click" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:Label ID="lblMessage1" runat="server" Visible="False" Font-Bold="True" ForeColor="#009933"></asp:Label><br />
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="grvcanteenexceldata" runat="server">
                                <HeaderStyle BackColor="#df5015" Font-Bold="true" ForeColor="White" />
                            </asp:GridView>
                            </dr>
                            <asp:Button ID="btn_canteensave" runat="server" Text="Save" class="btn btn-primary"
                                OnClick="btnCanteenSave_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </div>
                    </div>
                    <div id="div_MobileDeduction" style="display: none;">
                    <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Mobile Deduction Import Details
                    </h3>
                </div>
                <div class="box-body">
                    <table>
                        <tr>
                            <td>
                                <asp:FileUpload ID="MobileFileUploadToServer" runat="server" Style="height: 25px; font-size: 16px;" />
                            </td>
                            <td style="width: 5px;">
                            </td>
                            <td>
                                <asp:Button ID="btn_MobileImport" runat="server" Text="Import" class="btn btn-primary"
                                    OnClick="btnMobileImport_Click" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:Label ID="lblMessage2" runat="server" Visible="False" Font-Bold="True" ForeColor="#009933"></asp:Label><br />
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="grvmobileexceldata" runat="server">
                                <HeaderStyle BackColor="#df5015" Font-Bold="true" ForeColor="White" />
                            </asp:GridView>
                            </dr>
                            <asp:Button ID="btn_MobileSave" runat="server" Text="Save" class="btn btn-primary"
                                OnClick="btnMobileDeductionSave_Click" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </div>
                    </div>
                </div>
            </div>
  </section>
</div>
</asp:Content>
