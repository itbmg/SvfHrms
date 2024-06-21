<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeeFamilyDetailsReport.aspx.cs" Inherits="EmployeeFamilyDetailsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link rel="stylesheet" href="Styles/chosen.css"/>
   <style> a img{border: none;}
		ol li{list-style: decimal outside;}
		div#container{width: 780px;margin: 0 auto;padding: 1em 0;}
		div.side-by-side{width: 100%;margin-bottom: 1em;}
		div.side-by-side > div{float: left;width: 50%;}
		div.side-by-side > div > em{margin-bottom: 10px;display: block;}
		.clearfix:after{content: "\0020";display: block;height: 0;clear: both;overflow: hidden;visibility: hidden;}
		
     </style>
     <script>
         $.widget.bridge('uibutton', $.ui.button);
    </script>
    <script type="text/javascript">
        $(function () {
            $(".chzn-select").chosen();
            $(".chzn-select-deselect").chosen({ allow_single_deselect: true });
        });
    </script>
    	<script src="Scripts/jquery.min.js" type="text/javascript"></script>
		<script src="Scripts/chosen.jquery.js" type="text/javascript"></script>

    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
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
                error: e
            });
        }


        //        function ravi() {
        //            var empname = document.getElementById('ddlEmployeeType').value;
        //            for (var i = 0; i < empname_data.length; i++) {
        //                if (empname == empname_data[i].empname) {
        //                    document.getElementById('txtempid').value = empname_data[i].empsno;
        //                    document.getElementById('txtempcode').value = empname_data[i].empnum;
        //                }
        //            }
        //        }

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
            Employee Family Details Report  <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Employee Family Details Report</a></li>
        </ol>
    </section>
    <section class="content" style="overflow:inherit !important;">
        <div class="box box-info" style="height: 100%;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Family Details Report
                </h3>
            </div>
            <div class="box-body">
              <%--  <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>--%>
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
                                            <asp:Label ID="lblemp" type="hidden" runat="server" Text="Label">Employee Name</asp:Label>&nbsp;
                                                <asp:Label runat="server" type="hidden" ID="lblSelectedValue" Style="color: red" Width="200px" ></asp:Label>
                                                <asp:DropDownList ID="ddlemployee" Width="200px" data-placeholder="Choose a Name..." runat="server" class="chzn-select  form-control" >
                                                </asp:DropDownList>
                                                </asp:Panel>
                                                </td>
                                                 <td>
                                            <asp:Button ID="Button2" runat="server" Text="GENERATE" CssClass="btn btn-primary"
                                                OnClick="btn_Generate_Click" /><br />
                                        </td>
                                        <td>
                                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                                        </td>
                                    </tr>
                                    <br />
                                <br />
                                </table>
                                
                                   <%-- <asp:Panel ID="hideemployee" runat="server" Visible="false">
                                        <asp:TextBox type="text" runat="server" class="form-control" id="selct_employe" placeholder="Enter Employe Name"></asp:TextBox>
                                    <td style="display: none">
                                        <asp:TextBox ID="txtsupid" type="hidden" runat="server"></asp:TextBox>
                                    </td>
                                    <td style="display: none">
                                        <asp:TextBox  id="txtempcode"  runat="server" type="hidden" class="form-control" name="hiddenempid" ></asp:TextBox>
                                    </td>
                                     </asp:Panel>--%>
                                       
                                       
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
                                                   <%-- <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Employee Wise Report</span><br />
                                                <asp:Label ID="lblemployeename" runat="server" Font-Bold="true" Font-Size="14px" ForeColor="#0252aa"
                                                    Text=""></asp:Label>--%>
                                               <%-- <span style="font-size: 18px; font-weight: bold; color: #0252aa;">Salary Statement
                                                    Report</span><br />--%>
                                            </div>
                                            <table style="width: 80%">
                                                <tr>
                                                    <%--<td>
                                                        From Date
                                                    </td>--%>
                                                    <td>
                                                        <asp:Label ID="lblFromDate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                    <%--<td>
                                                        To date:
                                                    </td>--%>
                                                    <td>
                                                        <asp:Label ID="lbltodate" runat="server" Text="" ForeColor="Red"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
                                            <div >
                                                <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                    GridLines="Both" Font-Bold="true" OnDataBinding="gvMenu_DataBinding">
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
                                                        <span style="font-weight: bold; font-size: 12px;">A.O</span>
                                                    </td>
                                                     <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">GM</span>
                                                    </td>
                                                    <td style="width: 25%;">
                                                        <span style="font-weight: bold; font-size: 12px;">Director</span>
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
                  <%--  </ContentTemplate>
                </asp:UpdatePanel>--%>
            </div>
        </div>
    </section>
</asp:Content>


