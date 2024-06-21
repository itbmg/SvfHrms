<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="bankfileformatreport.aspx.cs" Inherits="bankfileformatreport" %>

<%@ Register Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
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
    <script>
        $(function () {

        });
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
        function CallHandlerUsingJson(d, s, e) {
            d = JSON.stringify(d);
            d = d.replace(/&/g, '\uFF06');
            d = d.replace(/#/g, '\uFF03');
            d = d.replace(/\+/g, '\uFF0B');
            d = d.replace(/\=/g, '\uFF1D');
            $.ajax({
                type: "GET",
                url: "EmployeeManagementHandler.axd?json=",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function get_filenames_details() {
            var branchname = document.getElementById("Slect_Name").value;
            var month = document.getElementById("ddlmonth").value;
            var year = document.getElementById("year1").value;
            var data = { 'op': 'get_filenames_details', 'branchname': branchname, 'month': month, 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillfiledetails(msg);

                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillfiledetails(msg) {
            var data = document.getElementById('ddl_filenames');
            var length = data.options.length;
            document.getElementById('ddl_filenames').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Filenames";
            opt.value = "Select Filenames";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].filename != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].filename;
                    option.value = msg[i].filename;
                    data.appendChild(option);
                }
            }
        }
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                        //                    get_filenames_details();
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch(msg) {
            var data = document.getElementById('Slect_Name');
            var length = data.options.length;
            document.getElementById('Slect_Name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branchname";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }

        //        function getCheckedRadio(theRadio) {
        //            var input = theRadio.value;
        //            var data = { 'op': 'get_companyaccountno_details', 'input': input };
        //            var s = function (msg) {
        //                if (msg) {
        //                    if (msg.length > 0) {
        //                        fillaccountno(msg);
        //                        //                    get_filenames_details();
        //                    }
        //                    else {
        //                    }
        //                }
        //                else {
        //                }
        //            };
        //            var e = function (x, h, e) {
        //            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //            callHandler(data, s, e);
        //        }
        //        function fillaccountno(msg) {
        //            var data = document.getElementById('Slect_account');
        //            var length = data.options.length;
        //            document.getElementById('Slect_account').options.length = null;
        //            var opt = document.createElement('option');
        //            opt.innerHTML = "Select Company Accountno";
        //            opt.setAttribute("selected", "selected");
        //            opt.setAttribute("disabled", "disabled");
        //            opt.setAttribute("class", "dispalynone");
        //            data.appendChild(opt);
        //            for (var i = 0; i < msg.length; i++) {
        //                if (msg[i].branchname != null) {
        //                    var option = document.createElement('option');
        //                    option.innerHTML = msg[i].branchname;
        //                    option.value = msg[i].branchid;
        //                    data.appendChild(option);
        //                }
        //            }
        //        }

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
            Bank FileFormat Report<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-pie-chart"></i>Bank FileFormat Reports</a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank FileFormatReports
                </h3>
            </div>
            <div class="box-body">
            <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>

                    <div>
                            <div align="center">
                                <table>
                                    <tr>
                                     <td>
                                       <label class="control-label" >
                                           Branch Name</label>
                                            </td>
                                            <td>
                                            <asp:DropDownList ID="ddlbranch" runat="server" CssClass="form-control">
                                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                                        </td>
                                        
                                         <td>
                                           <label class="control-label" >
                                            <asp:Label ID="Label2" runat="server" Text="Label">Month</asp:Label>&nbsp;
                                            </label>
                                            <asp:DropDownList ID="ddlmonth" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="00">Select Month</asp:ListItem>
                                            <asp:ListItem Value="01">January</asp:ListItem>
                                            <asp:ListItem Value="02">February</asp:ListItem>
                                            <asp:ListItem Value="03">March</asp:ListItem>
                                            <asp:ListItem Value="04">April</asp:ListItem>
                                            <asp:ListItem Value="05">May</asp:ListItem>
                                            <asp:ListItem Value="06">June</asp:ListItem>
                                            <asp:ListItem Value="07">July</asp:ListItem>
                                            <asp:ListItem Value="08">August</asp:ListItem>
                                            <asp:ListItem Value="09">September</asp:ListItem>
                                            <asp:ListItem Value="10">October</asp:ListItem>
                                            <asp:ListItem Value="11">November</asp:ListItem>
                                            <asp:ListItem Value="12">December</asp:ListItem>
                                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td>
                                          <label class="control-label" >
                                            <asp:Label ID="Label4" runat="server" Text="Label">Year</asp:Label>&nbsp;
                                            </label>
                                            <asp:DropDownList ID="year1" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="00">Select Year</asp:ListItem>
                                            <asp:ListItem Value="2013">2013</asp:ListItem>
                                            <asp:ListItem Value="2014">2014</asp:ListItem>
                                            <asp:ListItem Value="2015">2015</asp:ListItem>
                                            <asp:ListItem Value="2016">2016</asp:ListItem>
                                            <asp:ListItem Value="2017">2017</asp:ListItem>
                                            <asp:ListItem Value="2018">2018</asp:ListItem>
                                            <asp:ListItem Value="2019">2019</asp:ListItem>
                                            <asp:ListItem Value="2020">2020</asp:ListItem>
                                            <asp:ListItem Value="2020">2021</asp:ListItem>
                                            <asp:ListItem Value="2020">2022</asp:ListItem>
                                            <asp:ListItem Value="2020">2023</asp:ListItem>
                                            <asp:ListItem Value="2020">2024</asp:ListItem>
                                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                                        </td>
                                       
                                        <td>
                                            <asp:Button ID="Button1" runat="server" Text="Load" CssClass="btn btn-primary"
                                                OnClick="btn_Generate_Click" />&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td>
                                          <label class="control-label" >
                                        <asp:Label ID="Label1" runat="server" Text="Label">Filename</asp:Label>&nbsp;
                                        </label>
                                            <asp:DropDownList ID="ddl_filenames" runat="server" CssClass="form-control" AutoPostBack="true"
                                                onselectedindexchanged="ddl_filenames_SelectedIndexChanged1">
                                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                                        </td>
                                    </tr>
                                    <caption>
                                        <tr>
                                       <td  align="center" colspan="2" >  
                                    </br>
                                    </br>       
             <asp:Label ID="Lbl_selectedReportItem" runat="server" visible="false"></asp:Label>
              <asp:RadioButtonList ID="rbtLstReportItems" CssClass="myrblclass" AutoPostBack="true"   RepeatDirection="Horizontal" RepeatLayout="Table"  enabled="true" OnSelectedIndexChanged="RadioButton_CheckedChanged" runat="server" >
                  <asp:ListItem   GroupName="selected" Text="Sbi" Value="SBI"  style="margin-right:9px;" ></asp:ListItem>
                  <asp:ListItem   GroupName="selected" Text="Ing" Value="ING" style="margin-right:9px;" ></asp:ListItem>
                  <asp:ListItem   GroupName="selected" Text="Hdfc" Value="HDFC Bank"   style="margin-right:9px;" ></asp:ListItem>
                   <asp:ListItem    GroupName="selected" Text="Hdfcoth" Value="HDFCBank"  style="margin-right:9px;" ></asp:ListItem>
                 <asp:ListItem   GroupName="selected" Text="Kotack Mahindra"  Value="KOTAK Bank"  style="margin-right:9px;" >Kotack Mahindra</asp:ListItem>
                </asp:RadioButtonList>
             </td>
           <td style="padding-top:38px;">
             <label class="control-label" >Company Accountno
            </label>
             </td><td style="padding-top:35px;">
                                            <asp:DropDownList ID="Slect_account" runat="server" CssClass="form-control">
                                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;
                               
                            </td>
                                            <td>
                                              </br>
                                                <asp:Button ID="Button" runat="server" CssClass="btn btn-primary" 
                                                    Text="Download" OnClick="btn_Submit_Click" />
                                                <br />
                                            </td>
                                        </tr>
                                    </caption>
                                </table>
                                    <div >
        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" BackColor="White" BorderColor="#3366CC" 
        BorderStyle="None" BorderWidth="1px" CellPadding="4" Font-Size="X-Small"        
         PageSize="2" EnableViewState="False"            
            CssClass="gridview1" Font-Italic="False">
            <Columns>
             <asp:BoundField DataField="Name" HeaderText="Name" 
                SortExpression="Name" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="Accountno" HeaderText="A/C No" 
                SortExpression="Account_no" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="NetAmount" HeaderText="NetAmount" 
                SortExpression="NetAmount" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="IFSCCode" HeaderText="IFSCCode" 
                SortExpression="IFSCCode" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="EMPMOBILENO" HeaderText="EMPMOBILENO" 
                SortExpression="EMPMOBILENO" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="Standard" HeaderText="Standard" 
                SortExpression="Standard" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>

            </Columns>
            <FooterStyle BackColor="#99CCCC" Font-Size="Small" ForeColor="#003399" />
            <HeaderStyle BackColor="#003399" Font-Bold="True" ForeColor="#CCCCFF" />
            <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
            <RowStyle BackColor="White" ForeColor="#003399" />
            <SelectedRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
            <SortedAscendingCellStyle BackColor="#EDF6F6" />
            <SortedAscendingHeaderStyle BackColor="#0D4AC4" />
            <SortedDescendingCellStyle BackColor="#D6DFDF" />
            <SortedDescendingHeaderStyle BackColor="#002876" />
            </asp:GridView>
        <asp:GridView ID="GridView2" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" BackColor="White" BorderColor="#3366CC" 
        BorderStyle="None" BorderWidth="1px" CellPadding="4" Font-Size="X-Small"        
         PageSize="2" EnableViewState="False"            
            CssClass="gridview1" Font-Italic="False">
            <Columns>
             <asp:BoundField DataField="Accountno" HeaderText="Ac_no" 
                SortExpression="Accountno" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="NetAmount" HeaderText="NetAmount" 
                SortExpression="NetAmount" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="IFSCCode" HeaderText="IFSCCode" 
                SortExpression="IFSCCode" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="EMPMOBILENO" HeaderText="EMPMOBILENO" 
                SortExpression="EMPMOBILENO" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="EMPID" HeaderText="EMPID" 
                SortExpression="agent_id" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
              <asp:BoundField DataField="Standards" HeaderText="Standards" 
                SortExpression="Standards" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="CompanyAccountNumber" HeaderText="CompanyAccountNumber" 
                SortExpression="CompanyAccountNumber" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            </Columns>
            <FooterStyle BackColor="#99CCCC" Font-Size="Small" ForeColor="#003399" />
            <HeaderStyle BackColor="#003399" Font-Bold="True" ForeColor="#CCCCFF" />
            <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
            <RowStyle BackColor="White" ForeColor="#003399" />
            <SelectedRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
            <SortedAscendingCellStyle BackColor="#EDF6F6" />
            <SortedAscendingHeaderStyle BackColor="#0D4AC4" />
            <SortedDescendingCellStyle BackColor="#D6DFDF" />
            <SortedDescendingHeaderStyle BackColor="#002876" />
            </asp:GridView>


        <asp:GridView ID="grdReports" runat="server"  AutoGenerateColumns="false"  ForeColor="White" Width="100%" CssClass="gridcls"
                                                    GridLines="Both" Font-Bold="true" >
                                                    <EditRowStyle BackColor="#999999" />
                                                     <Columns>
                                                      
            
            <asp:BoundField DataField="EMPNAME" HeaderText="EMPNAME" 
            SortExpression="EMPCODE" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>

              <asp:BoundField DataField="EMPNAME" HeaderText="EMPNAME" 
            SortExpression="EMPCODE" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>

             <asp:BoundField DataField="C" HeaderText="C" 
                SortExpression="C" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>

               <asp:BoundField DataField="IFSCCode" HeaderText="IFSCCode" 
                SortExpression="IFSCCode" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="EMPMOBILENO" HeaderText="EMPMOBILENO" 
                SortExpression="EMPMOBILENO" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="NETPAY" HeaderText="NETPAY" 
                SortExpression="NETPAY" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="NARRATION" HeaderText="NARRATION" 
                SortExpression="BANKNAME" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            
            </Columns>
                                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                        Font-Names="Raavi" Font-Size="Small" />
                                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" Height="40px"/>
                                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                </asp:GridView>


        <asp:GridView ID="GridView3" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" BackColor="White" BorderColor="#3366CC" 
        BorderStyle="None" BorderWidth="1px" CellPadding="4" Font-Size="X-Small"        
         PageSize="2" EnableViewState="False"            
            CssClass="gridview1" Font-Italic="False">
            <Columns>
             <asp:BoundField DataField="BeneficiaryName" HeaderText="BeneficiaryName" SortExpression="BeneficiaryName" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
            <asp:BoundField DataField="BeneficiaryBankName" HeaderText="BeneficiaryBankName" SortExpression="BeneficiaryBankName" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
            <asp:BoundField DataField="AccountNo" HeaderText="AccountNo"  SortExpression="AccountNo" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
            <asp:BoundField DataField="BeneficiaryAccountType" HeaderText="BeneficiaryAccountType" 
                SortExpression="BeneficiaryAccountType" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
            <asp:BoundField DataField="IFSCCode" HeaderText="IFSCCode" 
                SortExpression="IFSCCode" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
              <asp:BoundField DataField="Amount" HeaderText="Amount" 
                SortExpression="Amount" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
             <asp:BoundField DataField="SendertoReceiverInfo" HeaderText="SendertoReceiverInfo" 
                SortExpression="SendertoReceiverInfo" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
             <asp:BoundField DataField="OwnReferenceNumber" HeaderText="OwnReferenceNumber" 
                SortExpression="OwnReferenceNumber" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
             <asp:BoundField DataField="Remarks" HeaderText="Remarks" 
                SortExpression="Remarks" ReadOnly="True">
            <ControlStyle Width="60px" />
            <FooterStyle Width="60px" />
            <HeaderStyle Width="60px" />
            <ItemStyle Width="60px" />
            </asp:BoundField>
            </Columns>
            <FooterStyle BackColor="#99CCCC" Font-Size="Small" ForeColor="#003399" />
            <HeaderStyle BackColor="#003399" Font-Bold="True" ForeColor="#CCCCFF" />
            <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
            <RowStyle BackColor="White" ForeColor="#003399" />
            <SelectedRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
            <SortedAscendingCellStyle BackColor="#EDF6F6" />
            <SortedAscendingHeaderStyle BackColor="#0D4AC4" />
            <SortedDescendingCellStyle BackColor="#D6DFDF" />
            <SortedDescendingHeaderStyle BackColor="#002876" />
            </asp:GridView>
        <asp:GridView ID="GridView4" runat="server"  AutoGenerateColumns="false"  ForeColor="White" Width="100%" CssClass="gridcls"
                                                    GridLines="Both" Font-Bold="true" >
                                                    <EditRowStyle BackColor="#999999" />
                                                     <Columns>
                                                      
            <%-- <asp:BoundField DataField="CompanyAccountNumber"  HeaderText="CompanyAccountNumber" 
                SortExpression="CompanyAccountNumber" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>--%>
           
             <asp:BoundField DataField="ACCOUNT" HeaderText="ACCOUNT" 
                SortExpression="ACCOUNT" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="C" HeaderText="C" 
                SortExpression="C" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
              <%-- <asp:BoundField DataField="IFSCCode" HeaderText="IFSCCode" 
                SortExpression="IFSCCode" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="EMPMOBILENO" HeaderText="EMPMOBILENO" 
                SortExpression="EMPMOBILENO" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>--%>
            <asp:BoundField DataField="NETPAY" HeaderText="NETPAY" 
                SortExpression="NETPAY" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="NARRATION" HeaderText="NARRATION" 
                SortExpression="BANKNAME" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            
            </Columns>
                                                    <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                    <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                        Font-Names="Raavi" Font-Size="Small" />
                                                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                    <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" Height="40px"/>
                                                    <AlternatingRowStyle HorizontalAlign="Center" />
                                                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                </asp:GridView>
        <asp:GridView ID="GridView6" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" BackColor="White" BorderColor="#3366CC" 
        BorderStyle="None" BorderWidth="1px" CellPadding="4" Font-Size="X-Small"        
         PageSize="2" EnableViewState="False"            
            CssClass="gridview1" Font-Italic="False">
            <Columns>
             
             <asp:BoundField DataField="ACCOUNT" HeaderText="ACCOUNT" 
                SortExpression="ACCOUNT" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="AMOUNT" HeaderText="AMOUNT" 
                SortExpression="AMOUNT" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="Empname" HeaderText="Empname" 
                SortExpression="EmployeeName" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            <asp:BoundField DataField="Empid" HeaderText="Empid" 
                SortExpression="Empid" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
             <asp:BoundField DataField="EMPMOBILENO" HeaderText="EMPMOBILENO" 
                SortExpression="EMPMOBILENO" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
                <asp:BoundField DataField="IFSCCode" HeaderText="IFSCCode" 
                SortExpression="IFSCCode" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
           
             
             <asp:BoundField DataField="BankName" HeaderText="BankName" 
                SortExpression="BankName" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
              <asp:BoundField DataField="ComapnyAccountno" HeaderText="ComapnyAccountno" 
                SortExpression="ComapnyAccountno" ReadOnly="True">
            <ControlStyle Width="45px" />
            <FooterStyle Width="45px" />
            <HeaderStyle Width="45px" />
            <ItemStyle Width="45px" />
            </asp:BoundField>
            </Columns>
            <FooterStyle BackColor="#99CCCC" Font-Size="Small" ForeColor="#003399" />
            <HeaderStyle BackColor="#003399" Font-Bold="True" ForeColor="#CCCCFF" />
            <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
            <RowStyle BackColor="White" ForeColor="#003399" />
            <SelectedRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
            <SortedAscendingCellStyle BackColor="#EDF6F6" />
            <SortedAscendingHeaderStyle BackColor="#0D4AC4" />
            <SortedDescendingCellStyle BackColor="#D6DFDF" />
            <SortedDescendingHeaderStyle BackColor="#002876" />
            </asp:GridView>
          
        <asp:GridView ID="GridView9" runat="server" CssClass="serh-grid" Width="200%" >
                            <HeaderStyle ForeColor="#660066" HorizontalAlign="Right" />
                           <FooterStyle ForeColor="#660066" HorizontalAlign="Right" />
                       </asp:GridView>
            
                                            </div>
                                
                                <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                            </div>
                        </div>

                    </ContentTemplate>
                     <Triggers>
                <asp:PostBackTrigger  ControlID="Button"  />
               </Triggers>
                </asp:UpdatePanel>
                
               


                                        
            </div>
            </section>
</asp:Content>
