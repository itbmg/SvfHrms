<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="bankfileformat.aspx.cs" Inherits="bankfileformat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
       
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdateProgress ID="UpdateProgress" runat="server">
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
    <asp:ModalPopupExtender ID="modalPopup" runat="server" TargetControlID="UpdateProgress"
        PopupControlID="UpdateProgress" BackgroundCssClass="modalPopup" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <section class="content-header">
            <h1>
                Bank File<small>Preview</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i>Finance</a></li>
                <li><a href="#">Bank File</a></li>
            </ol>
            </section>
            <section class="content">
            <div class="box box-info">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>SMP Details Report
                    </h3>
                </div>
                <div class="box-body">
            
            <table>
                <tr>
                    <td>
                       <div >
                        <table style="width: 100%;">
                                <tr>
                                    <td>
                                        <asp:Label ID="lbl_PlantName" runat="server" Text="Branch"></asp:Label>
                                    </td>
                                    <td  style="padding-top:5px;">
                                        <asp:DropDownList ID="ddlbranch" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </td>
                                
                                    <td>
                                        <asp:Label ID="lbl_BankName" runat="server" Text="Bank Name"></asp:Label>
                                        <asp:CheckBox ID="Chk_Cash" runat="server" AutoPostBack="True" OnCheckedChanged="Chk_Cash_CheckedChanged"
                                            Text="Cash" />
                                        <asp:DropDownList ID="ddl_BankName" runat="server" AutoPostBack="True"  Width="300px"
                                            OnSelectedIndexChanged="ddl_BankName_SelectedIndexChanged" CssClass="ddlclass">
                                        </asp:DropDownList>
                                    </td>
                                    <td  style="padding-top:5px;">
                                        <asp:DropDownCheckBoxes ID="ddchkCountry" runat="server" AddJQueryReference="True" Width="350px"
                                            Font-Bold="True" Font-Size="Small" OnSelectedIndexChanged="ddchkCountry_SelectedIndexChanged"
                                             UseButtons="True" UseSelectAllNode="True" CssClass="form-control" >
                                            <Texts SelectBoxCaption="Select BankName"/>
                                        </asp:DropDownCheckBoxes>
                                    </td>
                                
                                    <td>
                                        <asp:Label ID="lbl_RouteName" runat="server" Text="Employe Type"></asp:Label>
                                    </td>
                                    <td>
                                       <asp:DropDownList ID="ddlemptype" runat="server" CssClass="ddlclass">
                                            </asp:DropDownList>
                                    </td>

                                     <td>
                                            <asp:Label ID="Label2" runat="server" Text="Label">Month</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlmonth" runat="server" CssClass="ddlclass">
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
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label4" runat="server" Text="Label">Year</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlyear" runat="server" CssClass="ddlclass">
                                          
                                            </asp:DropDownList>
                                        </td>
                                </tr>
                                <tr>
                                    <td>

                                        <asp:CheckBox ID="chk_OldFileName" runat="server" AutoPostBack="True" OnCheckedChanged="chk_OldFileName_CheckedChanged"
                                            Text="OldFileName" />
                                    </td>
                                    <td  style="padding-top:5px;">
                                    <asp:Label ID="Label1" runat="server" Text="FileName"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txt_FileName"
                                            ErrorMessage="Enter FileName"  SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        <asp:TextBox ID="txt_FileName" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:DropDownList ID="ddl_oldfilename" runat="server" AutoPostBack="True" CssClass="form-control"
                                            OnSelectedIndexChanged="ddl_oldfilename_SelectedIndexChanged" >
                                        </asp:DropDownList>
                                        <br />
                                        <br />
                                    </td>

                                     <td>
                                        <asp:Button ID="btn_load" runat="server" CssClass="btn btn-primary" 
                                            OnClick="btn_load_Click" Text="Load"  />
                                      </td>
                                      <td>  <asp:Button ID="btn_Check" runat="server"  CssClass="btn btn-primary"
                                            OnClick="btn_Check_Click" Text="Check"  /> </td>
                                      
                                       <td>  <asp:Button ID="btn_save" runat="server"  CssClass="btn btn-primary"
                                            OnClick="btn_save_Click" Text="Save" /> </td>
                                       <td>  <asp:Button ID="btn_updatestatus" runat="server"   OnClick="btn_updatestatus_Click" Text="Update" Visible="false" 
                                             CssClass="btn btn-primary" /> </td>
                                      <td>   <asp:Button ID="btn_delete" runat="server"   OnClick="btn_delete_Click" Text="Delete" Visible="false" 
                                            CssClass="btn btn-primary" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                   
                                    <td>
                                        <asp:DropDownList ID="ddl_Plantcode" runat="server" AutoPostBack="true" CssClass="form-control" 
                                            OnSelectedIndexChanged="ddl_Plantcode_SelectedIndexChanged" Visible="false">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width:3%;">
                                    </td>
                                    <td  style="padding-top:5px;">
                                        <asp:TextBox ID="txt_Allotamount" runat="server" Enabled="False" 
                                             Visible="False" CssClass="form-control" ></asp:TextBox>
                                        <asp:Label ID="lbl_Alottedamount" runat="server" Text="Allotted Amount" Visible="False"></asp:Label>
                                       
                                        <br />
                                    </td>
                                </tr>
                            </table>
                       </div>
                    </td>
                </tr>
            </table>
            <div align="center">
                <asp:Label ID="lbl_ErrorMsg" runat="server" Font-Bold="True" ForeColor="#CC0000"></asp:Label></div>
            <center>
                <table>
                    <tr align="center" valign="top">
                        <td style="height: auto">
                            <fieldset style="width: 484px; height: auto;">
                                <legend style="color: #3399FF">Employe List</legend>
                                <table align="CENTER" style="width: 442px; height: 1271px;">
                                    <tr>
                                        <td>
                                            <asp:Panel ID="Panel3" runat="server" CssClass="checkpanelsize1" Height="2500px"
                                                Width="422px" align="center">
                                                <asp:Table ID="Table2" runat="Server" BorderColor="White" BorderWidth="1" CaptionAlign="Top"
                                                    CellPadding="1" CellSpacing="1" Height="40px" Width="294px" Style="font-size: small">
                                                    <asp:TableRow ID="TableRow1" runat="Server" BorderWidth="1" Width="300px">
                                                        <asp:TableCell ID="TableCell2" runat="Server" BorderWidth="1">
                                                            <asp:Table ID="Table1" runat="Server" BorderColor="White" BorderWidth="1" CaptionAlign="Top"
                                                                CellPadding="1" CellSpacing="1" Height="40px" Width="300px">
                                                                <asp:TableRow ID="TableRow12" runat="Server" BackColor="#3399CC" BorderColor="Silver"
                                                                    BorderWidth="1" ForeColor="white" Width="150px">
                                                                    <asp:TableCell ID="TableCell4" runat="Server" BorderWidth="2">
                                                                        <asp:CheckBox ID="MChk_Menu1" runat="server" Width="170px" AutoPostBack="True" Enabled="false"
                                                                            Text="Employe_Id" OnCheckedChanged="MChk_Menu1_CheckedChanged" /></asp:TableCell><asp:TableCell
                                                                                ID="TableCell5" runat="Server" BorderWidth="2">
                                                                                <asp:CheckBox ID="MChk_Menu2" runat="server" Width="120px" AutoPostBack="True" Text="Amount"
                                                                                    OnCheckedChanged="MChk_Menu2_CheckedChanged" /></asp:TableCell></asp:TableRow>
                                                                <asp:TableRow ID="TableRow2" runat="Server" BackColor="#fffafa" BorderColor="Silver"
                                                                    BorderWidth="1">
                                                                    <asp:TableCell ID="TableCell1" runat="Server" BorderWidth="1">
                                                                        <asp:CheckBoxList ID="CheckBoxList1" runat="server" BorderWidth="0" Enabled="false">
                                                                        </asp:CheckBoxList>
                                                                    </asp:TableCell><asp:TableCell ID="TableCell3" runat="Server" BorderWidth="1">
                                                                        <asp:CheckBoxList ID="CheckBoxList2" runat="server" BorderWidth="0">
                                                                        </asp:CheckBoxList>
                                                                    </asp:TableCell></asp:TableRow>
                                                            </asp:Table>
                                                        </asp:TableCell>
                                                    </asp:TableRow>
                                                </asp:Table>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                </table>
            </center>
             </div>
             </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
