<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="LoanRequestInFormation.aspx.cs" Inherits="LoanRequestInFormation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
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
    <div>
        <asp:UpdateProgress ID="updateProgress1" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                    right: 0; left: 0; z-index: 9999; background-color: #FFFFFF; opacity: 0.7;">
                    <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                        Style="padding: 10px; position: absolute; top: 40%; left: 40%; z-index: 99999;" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </div>
    <section class="content-header">
        <h1>
         Employee Loan Information<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Employee Reports</a></li>
            <li><a href="#">   Employee Loan Information</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Employee Loan Information Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table id="tbltrip">
                            <tr>
                                <td>
                                    <asp:Label ID="lbl_tripid" runat="server">Employee Name:</asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlEmployeeName" runat="server" CssClass="ddlclass">
                                    </asp:DropDownList>
                                </td>
                                <td style="width:5px;">
                                </td>
                                <td>
                                    <asp:Button ID="btnGenerate" runat="server" CssClass="btn btn-primary" OnClick="btnGenerate_Click"
                                        Text="Generate" />
                                </td>
                            </tr>
                        </table>
                        <div id="divPrint">
                            <div style="width: 100%;">
                                <div style="width: 13%; float: left;">
                                    <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                </div>
                                <div align="center">
                                    <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                        Text=""></asp:Label>
                                    <br />
                                    <asp:Label ID="LBLADD" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                        Text=""></asp:Label>
                                    <br />
                                </div>
                                <div>
                                </div>
                                <div style="width: 100%;">
                                    <span style="font-size: 16px; font-weight: bold; padding-left: 25%; text-decoration: underline;">
                                        Loan INFORMATION</span><br />
                                    <span style="font-size: 16px; font-weight: bold; padding-left: 25%; color: #0252aa">
                                        Employee Name:</span>
                                    <asp:Label ID="lblDriverName" runat="server" Text="" Font-Bold="true" ForeColor="Red"></asp:Label>
                                    <br />
                                </div>
                                <table style="width: 80%">
                                    <tr>
                                        <td>
                                            Employee Code
                                        </td>
                                        <td>
                                            <asp:Label ID="lblEmpID" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Fathers Name
                                        </td>
                                        <td>
                                            <asp:Label ID="lblFathersName" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td>
                                            Address
                                        </td>
                                        <td>
                                            <asp:Label ID="lblAdress" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Permanent Address
                                        </td>
                                        <td>
                                            <asp:Label ID="lblperementaddress" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td>
                                            Contact Number:
                                        </td>
                                        <td>
                                            <asp:Label ID="lblContactNumber" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            DOB
                                        </td>
                                        <td>
                                            <asp:Label ID="lblDOB" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td>
                                            Designation
                                        </td>
                                        <td>
                                            <asp:Label ID="lblDesignation" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Experience in the company
                                        </td>
                                        <td>
                                            <asp:Label ID="lblExprnceCompany" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td>
                                            Salary paid as on date
                                        </td>
                                        <td>
                                            <asp:Label ID="lblSalaryPaydate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Purpose of Loan
                                        </td>
                                        <td>
                                            <asp:Label ID="lblPuposeloan" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td>
                                            Any previous Loan
                                        </td>
                                        <td>
                                            <asp:Label ID="lblAnyprivoesloan" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Loan amount
                                        </td>
                                        <td>
                                            <asp:Label ID="lblLoanAmount" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td>
                                            Loan to be recovered in no.of months
                                        </td>
                                        <td>
                                            <asp:Label ID="lblLoanNomonth" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Starting month Of date
                                        </td>
                                        <td>
                                            <asp:Label ID="lblstartmonthpdate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="font-size: 20px; " style="padding-left: 18%;">
                                            <label ID="Label9" title="">
                                            Referance Employees
                                            </label>
                                        </td>
                                    <tr>
                                        <td>
                                            Name
                                        </td>
                                        <td>
                                            <asp:Label ID="lblname1" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                        <td>
                                            Name
                                        </td>
                                        <td>
                                            <asp:Label ID="lblname2" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Designation
                                        </td>
                                        <td>
                                            <asp:Label ID="lblDesgnation1" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                        <td>
                                            Designation
                                        </td>
                                        <td>
                                            <asp:Label ID="lblDesgnation2" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Address
                                        </td>
                                        <td>
                                            <asp:Label ID="lblAddress1" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                        <td>
                                            Address
                                        </td>
                                        <td>
                                            <asp:Label ID="lblAddress2" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <br />
                            <table style="width: 100%;">
                                <tr>
                                    <td style="width: 25%;">
                                        <span style="font-weight: bold; font-size: 12px;">PREPARED BY</span>
                                    </td>
                                    <td style="width: 25%;">
                                        <span style="font-weight: bold; font-size: 12px;">INCHARGE SIGNATURE</span>
                                    </td>
                                    <td style="width: 25%;">
                                        <span style="font-weight: bold; font-size: 12px;">DRIVER SIGNATURE</span>
                                    </td>
                                    <td style="width: 25%;">
                                        <span style="font-weight: bold; font-size: 12px;">AUTHORISED SIGNATURE</span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <br />
                <br />
                <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint('divPrint');"
                    Text="Print" />
            </div>
        </div>
    </section>
</asp:Content>

