<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="AadhaarCardDetails.aspx.cs" Inherits="AadhaarCardDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script type="text/javascript">
     $(function () {
         //get_Dept_details();
         //get_Employeedetails();
         //getdataemployeechange();
     });
     function CallPrint(strid) {
         var divToPrint = document.getElementById(strid);
         var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
         newWin.document.open();
         newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
         newWin.document.close();
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
            Aadhaar Card Details  <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Aadhaar Card Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Aadhaar Card Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <div>
                            <div align="center">
                                    <table align="center" style="width: 60%;">
                                <tr>
                                <td>
                                 <asp:Label ID="Label6" runat="server" Text="Label">Employee Type</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlEmployeeType" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlemployee_SelectedIndexChanged">
                                                <asp:ListItem>All</asp:ListItem>
                                                <asp:ListItem>Employee Wise</asp:ListItem>
                                            </asp:DropDownList>
                                </td>
                                    <td>
                                    </td>
                                    <td>
                                    <asp:Panel ID="hideemployee" runat="server" Visible="false">
                                                    <asp:Label ID="Label1" runat="server" Text="Label">Employee Name</asp:Label>&nbsp;
                                                    <asp:DropDownList ID="ddlemployee" runat="server" CssClass="form-control">
                                                    </asp:DropDownList>
                                                </asp:Panel>
                                                </td>


                                   <%-- <asp:Panel ID="hideemployee" runat="server" Visible="false">
                                        <asp:TextBox type="text" runat="server" class="form-control" id="selct_employe" placeholder="Enter Employe Name"></asp:TextBox>
                                    <td style="display: none">
                                        <asp:TextBox ID="txtsupid" type="hidden" runat="server"></asp:TextBox>
                                    </td>
                                    <td style="display: none">
                                        <asp:TextBox  id="txtempcode"  runat="server" type="hidden" class="form-control" name="hiddenempid" ></asp:TextBox>
                                    </td>
                                     </asp:Panel>--%>
                                        <td style="padding-top: 3%;">
                                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-primary"
                                                OnClick="btn_Generate_Click" /><br />
                                        </td>
                                        <td style="padding-top: 3%;">
                                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                                <asp:Panel ID="hidepanel" runat="server" Visible='false'>
                                    <div id="divPrint">
                                        <div style="width: 100%;">
                                            <div style="width: 13%; float: left;">
                                                <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                            </div>
                                            <div align="center">
                                                <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                <br />
                                                <asp:Label ID="lblAddress" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                <br />
                                                 <asp:Label ID="lblHeading" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                    <br />
                                                    <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Employee Wise Report</span><br />
                                                <asp:Label ID="lblemployeename" runat="server" Font-Bold="true" Font-Size="14px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                               <%-- <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                                            <table style="width: 80%">
                                                <tr>
                                                    <%--<td>
                                                        From Date
                                                    </td>--%>
                                                    <td>
                                                        <asp:Label ID="lblFromDate" runat="server" Text="" ForeColor="Red" style="display:none"></asp:Label>
                                                    </td>
                                                    <%--<td>
                                                        To date:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lbltodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>--%>
                                                </tr>
                                            </table>
                                            <div >
                                                <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                    GridLines="Both" Font-Bold="true">
                                                    <EditRowStyle BackColor="#999999" />
                                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                        Font-Names="Raavi" Font-Size="Small" />
                                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" Height="40px"/>
                                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                </asp:GridView>
                                            </div>
                                            <br />
                                            <table style="width: 100%;">
                                                <tr>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Prepared By</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Audit By</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Accounts</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Authorized Signature</span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                   <%-- <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-success" OnClientClick="javascript:CallPrint('divPrint');"
                                        Text="Print" />--%>
                                        <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                </asp:Panel>
                                <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </section>
</asp:Content>

