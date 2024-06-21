<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="compensationconsolidedstatement.aspx.cs" Inherits="compensationconsolidedstatement" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .container
        {
            max-width: 100%;
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
    <asp:UpdatePanel ID="updPanel" runat="server">
        <ContentTemplate>
            <section class="content-header">
                <h1>
                    Compensation item statement-Consolidated <small>Preview</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
                    <li><a href="#">Compensation item statement-Consolidated </a></li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Compensation item statement-Consolidated Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div align="center">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Text="Label">Compensation Type</asp:Label>&nbsp;
                                        <asp:DropDownList ID="ddlcompantype" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="00" Selected="True">Select Type</asp:ListItem>
                                            <asp:ListItem Value="1">Attandance</asp:ListItem>
                                            <asp:ListItem Value="2">Annual CTC</asp:ListItem>
                                            <asp:ListItem Value="3">Basic</asp:ListItem>
                                            <asp:ListItem Value="4">HRA</asp:ListItem>
                                            <asp:ListItem Value="5">Conviyance Allowance</asp:ListItem>
                                            <asp:ListItem Value="6">Medical Allowance</asp:ListItem>
                                            <asp:ListItem Value="7">Washing Allowance</asp:ListItem>
                                            <asp:ListItem Value="8">Canteen Deduction</asp:ListItem>
                                            <asp:ListItem Value="9">Mobile Dedection</asp:ListItem>
                                            <asp:ListItem Value="10">Outher Dedection</asp:ListItem>
                                            <asp:ListItem Value="11">PF</asp:ListItem>
                                            <asp:ListItem Value="12">ESI</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text="Label">From</asp:Label>&nbsp;
                                        <asp:DropDownList ID="ddlfrompayroll" runat="server" CssClass="form-control">
                                           
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Text="Label">To</asp:Label>&nbsp;
                                        <asp:DropDownList ID="ddltopayroll" runat="server" CssClass="form-control">
                                           
                                        </asp:DropDownList>
                                    </td>
                                    <td style="padding-left: 2%;padding-top: 3%;">
                                        <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-primary"
                                            OnClick="btn_Generate_Click" /><br />
                                    </td>
                                    <td style="padding-left: 2%;padding-top: 3%;">
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
                                            <%--<span style="font-size: 18px; font-weight: bold; color: #0252aa;">Mobile Deduction Report</span><br />--%>
                                        </div>
                                        <br />
                                        <div>
                                            <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                GridLines="Both" Font-Bold="true" OnRowDataBound="grdReports_RowDataBound">
                                                <EditRowStyle BackColor="#999999" />
                                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                    Font-Names="Raavi" Font-Size="Small" HorizontalAlign="Center" />
                                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                                <AlternatingRowStyle HorizontalAlign="Center" />
                                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            </asp:GridView>
                                        </div>
                                        <br />
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Prepared By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Audit By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">A.O</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">GM</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Director</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <br />
                                <br />
                                <button type="button" class="btn btn-success" onclick="javascript:CallPrint('divPrint');">
                                    <i class="fa fa-print"></i>Print</button>
                            </asp:Panel>
                            <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                        </div>
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

