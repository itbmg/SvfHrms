<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="Employeewiseattadance.aspx.cs" Inherits="Employeewiseattadance" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">
        function exportfn() {
            window.location = "exporttoxl.aspx";
        }

        //------------>Prevent Backspace<--------------------//
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD'))
            || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                } else {
                    doPrevent = true;
                }
            }

            if (doPrevent) {
                event.preventDefault();
            }
        });
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
            Employee Wise Attendance<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Employee Wise Attendance</a></li>
        </ol>
    </section>
    <section class="content" style="overflow:inherit !important;">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Wise Attendance Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <div style="overflow:auto">
                            <div align="center">
                                <table>
                                    <tr>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_FromDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="dtp_FromDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_Todate" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender2" runat="server" Enabled="True"
                                            TargetControlID="dtp_Todate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                        <td>
                                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-success"
                                                OnClick="btn_Generate_Click" /><br />
                                        </td>
                                        <td>
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
                                            </div>
                                            <table style="width: 80%">
                                                <tr>
                                                    <td>
                                                        From Date
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblFromDate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                    <td>
                                                        To date:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lbltodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
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
                                            <%--<table style="width: 100%;">
                                                <tr>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Prepared By</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Audit By</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">A.M</span>
                                                    </td>
                                                     <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">GM</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Authorized Signature</span>
                                                    </td>
                                                </tr>
                                            </table>--%>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
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