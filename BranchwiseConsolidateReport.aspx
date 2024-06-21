<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="BranchwiseConsolidateReport.aspx.cs" Inherits="BranchwiseConsolidateReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    function CallPrint(strid) {
        var divToPrint = document.getElementById(strid);
        var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
        newWin.document.open();
        newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
        newWin.document.close();
    }
    function CallPrint1(strid) {
        var divToMainAddNewRow = document.getElementById(strid);
        var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
        newWin.document.open();
        newWin.document.write('<html><body   onload="window.print()">' + divToMainAddNewRow.innerHTML + '</body></html>');
        newWin.document.close();
    }
    function PopupOpen() {
        $('#divMainAddNewRow').css('display', 'block');
    }
    function popupCloseClick() {
        $('#divMainAddNewRow').css('display', 'none');
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
            Consolidate Report <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Consolidate Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Consolidate report Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                            <div align="center">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label1" runat="server" Text="Label">Branch</asp:Label>&nbsp;
                                            <asp:DropDownList ID="slct_branch" runat="server" CssClass="ddlclass">
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label4" runat="server" Text="Label">Year</asp:Label>&nbsp;
                                            <asp:DropDownList ID="slct_year" runat="server" CssClass="ddlclass">
                                          
                                            </asp:DropDownList>
                                        </td>
                                       <td></td>
                                        <td >
                              <asp:Button ID="btn_Generate" runat="server" Text="GENERATE" CssClass="aspbutton"
                                            OnClick="btn_Generate_Click" />
                                </td>
                                    </tr>
                                </table>
                                </div>
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
                                                <%--<td>
                                                    From Month
                                                </td>
                                                <td>
                                                    <asp:Label ID="slct_branch" runat="server" ForeColor="Red"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="slct_year" runat="server" ForeColor="Red"></asp:Label>
                                                </td>--%>
                                            </tr>
                                        </table>
                                        <div>
                                          <asp:GridView ID="grdReports" runat="server" Style="width: 100%;" Font-Bold="true"
                                            OnRowCommand="grdReports_RowCommand">
                                            <Columns>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:Button ID="Button1" runat="server" Text="View"  CssClass="btn btn-success"
                                                            CommandArgument='<%#Container.DataItemIndex%>'  />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                </div>
                                <%--<div id="divclose" style="width: 35px; top: 0%; right: .5%;left:96.5%; position: absolute;
                                    z-index: 99999; cursor: pointer;">
                                    <img src="Images/PopClose.png" alt="close" onclick="popupCloseClick();" />
                                </div>--%>
                            </div>
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
                               <button type="button" class="btn btn-success"  onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                            </asp:Panel>
                            <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                                background: rgba(192, 192, 192, 0.7);overflow:scroll">
                                <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 0%;
                                    background-color: White; width: 100%; height: 50%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                                    border-radius: 10px 10px 10px 10px;">
                                    <asp:UpdatePanel ID="UpdatePanel10" runat="server">
                                        <ContentTemplate>
                                            <asp:GridView ID="GrdProducts" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                GridLines="Both" Font-Bold="true">
                                                <EditRowStyle BackColor="#999999" />
                                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                    Font-Names="Raavi" Font-Size="Small" />
                                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                                <AlternatingRowStyle HorizontalAlign="Center" />
                                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                     <asp:Button ID="Button2" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint1('divMainAddNewRow');"
                                    Text="Print" />
                                </div>
                                <div id="div1" style="width: 35px; top: 0%; right: .5%;left:96.5%; position: absolute;
                                    z-index: 99999; cursor: pointer;">
                                    <img src="Images/PopClose.png" alt="close" onclick="popupCloseClick();" />
                                </div>
                            </div>
                            <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                             </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </section>
                              
</asp:Content>

