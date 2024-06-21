<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Print_TravelExpenses.aspx.cs" Inherits="Print_TravelExpenses" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="Css/VyshnaviStyles.css" rel="stylesheet" type="text/css" />
    <script src="Js/JTemplate.js?v=3000" type="text/javascript"></script>
    <script src="js/jquery.blockUI.js?v=3005" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="Css/VyshnaviStyles.css" />
    <script src="js/jquery.json-2.4.js" type="text/javascript"></script>
    <script src="src/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
    <link href="js/DateStyles.css?v=3004" rel="stylesheet" type="text/css" />
    <script src="js/1.8.6.jquery.ui.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=300,height=300,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.write('<link rel="stylesheet" type="text/css" href="Css/print.css" />');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">
        $(function () {
            window.history.forward(1);

        });
        function PopupOpen(ReceiptNo) {
            var data = { 'op': 'GetSubPaybleValues', 'ReceiptNo': ReceiptNo };
            var s = function (msg) {
                if (msg) {
                    var results = '<div style="overflow:auto;"><table class="responsive-table">';
                    results += '<thead><tr><th scope="col">Head Of Account</th><th scope="col">Amount</th></tr></thead></tbody>';
                    for (var i = 0; i < msg.length; i++) {
                        results += '<tr>';
                        results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].Account + '</th>';
                        results += '<th scope="row" class="AmountClass" style="text-align:center;">' + msg[i].amount + '</th></tr>';
                    }
                    results += '</table></div>';
                    $("#divHead").html(results);
                    var TotRate = 0.0;
                }
                else {
                    alert(msg);
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
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
                Error: e
            });
        }
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = encodeURIComponent(d);
            $.ajax({
                type: "GET",
                url: " EmployeeManagementHandler.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
    </script>
    <style>
        .divPrintcss /*{
background:url(http://www.vyshnavi.net/Images/Vlogo.png) no-repeat scroll 0 5px transparent;
height: 40px;
width: 40px;
display: block;
color: #0252AA;
font-weight: bold;
    }*/</style>
    <style type="text/css">
        .mylbl
        {
            font-size: 12px;
        }
        .mylbl1
        {
            font-size: 12px; /*font-weight: bold;
            
            color:#0252aa;
            font-family: ravvi;*/
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
            Travel expense payment<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Payment</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>expense Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div>
                            <table>
                                <tr>
                                    <td>
                                        <div>
                                            <table id="tbltrip">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lbl_tripid" runat="server">REF No:</asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtVoucherNo" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </td>
                                                    <td style="width: 6px;">
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnGenerate" runat="server" CssClass="btn btn-primary" OnClick="btnGenerate_Click"
                                                            Text="Generate" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <div id="divPrint">
                                <div style="width: 100%;">
                                    <table style="width: 100%;">
                                        <tr>
                                            <td style="width: 15%; float: right;">
                                               <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                                            </td>
                                            </tr>
                                            <tr>
                                            <td align="center">
                                                  <asp:Label ID="lblTitle" runat="server"  Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>
                                                    </td>
                                        </tr>
                                        <tr>
                                        <td>
                                        <div align="center" style="border-bottom: 1px solid gray; border-top: 1px solid gray;">
                        <span style="font-size: 26px; font-weight: bold;">Travel expense Details</span>
                    </div>
                    </td>
                    </tr>
                                        
                                        <tr>
                                        <td style="width: 49%; float: left;">
                                              <label>
                                     <b>Voucher No: :</b></label>
                                <asp:label id="lblVoucherno" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                
                                </td>
                                <td style="width: 49%; float: right;">
                                              <label>
                                     <b>Date :</b></label>
                                <asp:label id="lblDate" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                </td>
                                        </tr>
                                    </table>
                                    <div>
                                        <table style="width: 100%;">
                                            <tr>
                                            <td style="width: 49%; float: left;">
                                <label>
                                    <b>Reporting Name :</b></label>
                                <asp:label id="lblPayCash" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                                <label>
                                    <b>From Loaction :</b></label>
                                <asp:label id="lblfromlocation" runat="server" Text=""></asp:label>
                                <br />
                                <label>
                                    <b>From Date :</b></label>
                                <asp:label id="lblfromdate" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                                <label>
                                    <b>Instruction By :</b></label>
                                <asp:label id="lblInstuby" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                            </td>
                             <td style="width: 49%; float: right;">
                                <label>
                                    <b>Employee Name :</b></label>
                                <asp:label id="lbl_employee" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                             
                                 <label>
                                     <b>To Loaction :</b></label>
                                <asp:label id="lbltolocation" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                                 <label>
                                     <b>To Date :</b></label>
                               <asp:label id="lblTodate" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                                 <label>
                                     <b>Approved BY :</b></label>
                                <asp:label id="lblAproveby" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                <br />
                            </td>
                                </tr>
                                            <tr style="background-color: #f4f4f4;">
                                                <td colspan="2" rowspan="1" style="width: 100%;">
                                                    <div id="divHead">
                                                    </div>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>
                                              <label>
                                     <b>Purpose :</b></label>
                                <asp:label id="lblTowards" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                </td>
                                </tr>
                                <tr>
                                <td>
                                              <label>
                                     <b>Received RS :</b></label>
                                <asp:label id="lblReceived" runat="server" Text=""  CssClass="mylbl" ></asp:label>
                                </td>
                                            </tr>
                                            
                                        </table>
                                    </div>
                                    <br />
                                    <div>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="width: 20%;">
                                                    <span style="font-size: 12px;">Receiver's Signature</span>
                                                </td>
                                                <td style="width: 20%;">
                                                    <span style="font-size: 12px;">Verified By</span>
                                                </td>
                                                <td style="width: 20%;">
                                                    <span style="font-size: 12px;">Accounts officer</span>
                                                </td>
                                                <td style="width: 20%;">
                                                    <asp:Label ID="lblApprove" runat="server" Font-Size="10px" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <br />
                            <br />
                            <button type="button" class="btn btn-primary" style="margin-right: 5px;" onclick="javascript:CallPrint('divPrint');">
                                <i class="fa fa-print"></i>Print
                            </button>
                            <br />
                            <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </section>
</asp:Content>
