<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="bankfiledownload.aspx.cs" Inherits="bankfiledownload" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
        <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
        <script type="text/javascript">
            $("[id*=chkHeader]").live("click", function () {
                var chkHeader = $(this);
                var grid = $(this).closest("table");
                $("input[type=checkbox]", grid).each(function () {
                    if (chkHeader.is(":checked")) {
                        $(this).attr("checked", "checked");
                        $("td", $(this).closest("tr")).addClass("selected");
                    } else {
                        $(this).removeAttr("checked");
                        $("td", $(this).closest("tr")).removeClass("selected");
                    }
                });
            });
            $("[id*=chkRow]").live("click", function () {
                var grid = $(this).closest("table");
                var chkHeader = $("[id*=chkHeader]", grid);
                if (!$(this).is(":checked")) {
                    $("td", $(this).closest("tr")).removeClass("selected");
                    chkHeader.removeAttr("checked");
                } else {
                    $("td", $(this).closest("tr")).addClass("selected");
                    if ($("[id*=chkRow]", grid).length == $("[id*=chkRow]:checked", grid).length) {
                        chkHeader.attr("checked", "checked");
                    }
                }
            });
        </script>
        <script type="text/javascript">
            $(function () {
                //          $("[id*=netpay]").val("0");
                //            $("[id*=txtchkamount]").val("0");

                var cctot = $(row).find('[id*=netpay]');

                $("[id*=lblTotal]").html(cctot.toString());

            });
            $(".calculate").live("keyup", function () {
                var row = $(this).closest('tr');
                var amount = $(row).find('[id*=netpay]');
                var typeamount = $(row).find('[id*=txtchkamount]');

                //            $("[id*=lblTotal]", row).html(parseFloat($(amount).val()));
                if (typeamount <= amount) {

                    if (!jQuery.trim($(amount).val()) == '' && !jQuery.trim($(typeamount).val()) == '') {
                        if (!isNaN(parseFloat($(amount).val())) && !isNaN(parseFloat($(typeamount).val()))) {
                            if (typeamount <= amount) {
                                $("[id*=lblTotal]", row).html(parseFloat($(amount).val()) - parseFloat($(typeamount).val()));
                            }
                            else {
                                alert("Please Check Value: " + typeamount);
                            }
                        }
                    } else {
                        //                $(amount).val('');
                        $(typeamount).val('');
                        $(typeamount).val('0');
                    }
                }
                else {

                    alert("Please Check Value: " + typeamount);
                    $(typeamount).val('0');
                    $("#" + typeamount).focus();

                }

                if (!isNaN(parseFloat($(typeamount).val())) < 0) {

                    alert("Please Check Value: " + typeamount);
                    $(typeamount).val('0');
                    $("#" + typeamount).focus();
                }

                var grandTotal = 0;
                $("[id*=lblTotal]").each(function () {
                    grandTotal = grandTotal + parseFloat($(this).html());
                });
                $("[id*=lblGrandTotal]").html(grandTotal.toString());
            });




        </script>
        <script type="text/javascript">
            function calcsum() {
                $("[id*=lbltotal1]").val("0");

                var sum = 0;
                var txtamount = 0;
                $('.chk').each(function () {
                    var chkbox = $(this).children('input').get(0);
                    if (chkbox.checked) {
                        var tr = $(chkbox).parent().parent().parent(); //get the parent tr of the checkbox.
                        var txtamount = $("td input[type=text]", tr).get(1); //get the textbox within the parent tr.
                        sum += parseFloat($(txtamount).val()); //get the value and sum up.
                    }
                    else {
                        var zz = 0;
                        $("[id*=lbltotal1]").html(zz.toString());

                        //   sum += parseFloat($(0).val()); //get the value and sum up.

                    }

                    //  $("[id*=lbltotal]").val(sum.toString());



                });
                if (sum > 0) {
                    $("[id*=lbltotal1]").html(sum.toString());
                }
                else {
                    sum = 0;
                    $("[id*=lbltotal1]").html(sum.toString());
                }
            }
 
        </script>
        <script type="text/javascript" language="javascript">
            function numeric(evt) {
                var charCode = (evt.which) ? evt.which : event.keyCode
                if (charCode > 31 && ((charCode >= 48 && charCode <= 57) || charCode == 46))
                    return true;
                else {
                    alert('Please Enter Numeric values.');
                    return false;
                }
            }
        </script>
        <script type="text/javascript">
            function ConfirmDelete() {
                var favcolor = 'TEST';
                if (confirm('Are you sure to want to Continue?'))
                    return true;
                else
                    return false;
            }
        </script>
        <script type="text/javascript">
            function Delete() {
                var favcolor = 'TEST';
                if (confirm('Are you sure to want to Delete?'))
                    return true;
                else
                    return false;
            }
        </script>
        <script type="text/javascript">
            $(document).ready(function () {
                $('.dropdown-toggle').dropdown();
            });
        </script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <script type="text/javascript">
        function Confirm() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            if (confirm("Do you want to save data?")) {
                confirm_value.value = "Yes";
            } else {
                confirm_value.value = "No";
            }
            document.forms[0].appendChild(confirm_value);
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
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Salary File Details
                </h3>
            </div>
            <div class="box-body">
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <table width="100%">
                            <tr>
                                <td>
                                    <label>
                                        Branch Name
                                    </label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlbranch" runat="server" class="form-control">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <label>
                                        Month</label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlmonth" runat="server" Font-Bold="True" Font-Size="Large">
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
                                    <label>
                                        Year
                                    </label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlyear" runat="server" class="form-control">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:Button ID="Btn_Load" runat="server" class="btn btn-primary" Text="Load" OnClick="Btn_Load_Click">
                                    </asp:Button>
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <asp:Panel ID="Panel3" runat="server" CssClass="checkpanelsize1" Width="1000px" align="center">
                <table class="nav-justified">
                    <tr width="100%">
                        <td valign="top">
                            <asp:GridView ID="GridView7" runat="server" CssClass="gridcls" OnRowDataBound="GridView7_RowDataBound"
                                OnSelectedIndexChanged="GridView7_SelectedIndexChanged">
                                <Columns>
                                    <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
                                </Columns>
                                <EditRowStyle BackColor="#999999" />
                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" Font-Italic="False" Font-Names="Raavi"
                                    Font-Size="12px" ForeColor="Black" />
                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="#ffffff" ForeColor="#333333" Height="40px" HorizontalAlign="Center" />
                                <AlternatingRowStyle HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                            </asp:GridView>
                            <br />
                            <asp:GridView ID="GridView8" runat="server" CssClass="gridcls" OnRowDataBound="GridView8_RowDataBound"
                                ShowFooter="true" Width="90%">
                                <EditRowStyle BackColor="#999999" />
                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" Font-Italic="False" Font-Names="Raavi"
                                    Font-Size="12px" ForeColor="Black" />
                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="#ffffff" ForeColor="#333333" Height="40px" HorizontalAlign="Center" />
                                <AlternatingRowStyle HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                <Columns>
                                    <asp:TemplateField HeaderText="SNo.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex + 1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td valign="top">
                            <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" OnCheckedChanged="CheckBox1_CheckedChanged"
                                Text=" Show Download" Font-Size="50px" Style="font-size: xx-large" />
                            <asp:Panel ID="Panel4" runat="server">
                               
                                        <table class="nav-justified">
                                            <tr>
                                                <td>
                                                    <label>
                                                        <asp:Label ID="Label12" runat="server" Style="text-align: left" Text="File Name"></asp:Label>
                                                    </label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddl_filename" runat="server" class="form-control" Width="150px"
                                                        AutoPostBack="True" OnSelectedIndexChanged="ddl_filename_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <label>
                                                        <asp:Label ID="Label1" runat="server" Style="text-align: left" Text="PayMent Type"></asp:Label>
                                                    </label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddl_bankname" runat="server" class="form-control" OnSelectedIndexChanged="ddl_bankname_SelectedIndexChanged"
                                                        Width="150px" AutoPostBack="True">
                                                        <asp:ListItem>HDFC TO OTHERS</asp:ListItem>
                                                        <asp:ListItem>KOTACK</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <label>
                                                        <asp:Label ID="Label2" runat="server" Style="text-align: left" Text="Account NO"></asp:Label>
                                                    </label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddl_kotacklist" runat="server" class="form-control" OnSelectedIndexChanged="ddl_BillDate_SelectedIndexChanged"
                                                        Width="150px">
                                                        <asp:ListItem Value="425044000438">425044000438</asp:ListItem>
                                                        <asp:ListItem>328044039913</asp:ListItem>
                                                        <asp:ListItem>334044049195</asp:ListItem>
                                                        <asp:ListItem>337044040029</asp:ListItem>
                                                        <asp:ListItem>334044032411</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lbl_totamt" runat="server" Style="color: #000066; font-weight: 700"
                                                        Text="Label" Visible="False"></asp:Label>
                                                </td>
                                                <td align="center">
                                                    <asp:Button ID="Btn_Download" runat="server" class="btn btn-primary" OnClick="Btn_Download_Click"
                                                        OnClientClick="return ConfirmDelete();" Text="DownLoad File" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <asp:Label ID="lblmsga" runat="server" Font-Bold="true" ForeColor="Red" Font-Size="Large"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                  
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr width="100%">
                        <td align="center" valign="top" width="65%">
                            <asp:Button ID="Button2" runat="server" CssClass="btn btn-primary" Font-Size="Smaller"
                                OnClick="Button2_Click" Text="Export" />
                        </td>
                        <td valign="top">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="GridView6" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                BackColor="White" BorderColor="#3366CC" BorderStyle="None" BorderWidth="1px"
                                CellPadding="4" CssClass="gridview1" EnableViewState="False" Font-Italic="False"
                                Font-Size="X-Small" PageSize="2" Visible="False">
                                <Columns>
                                    <asp:BoundField DataField="TranType" HeaderText="TranType" ReadOnly="True" SortExpression="TranType">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ACCOUNT" HeaderText="ACCOUNT" ReadOnly="True" SortExpression="ACCOUNT">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AMOUNT" HeaderText="AMOUNT" ReadOnly="True" SortExpression="AMOUNT">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EMPName" HeaderText="EMPName" ReadOnly="True" SortExpression="AgentName">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="EMP_Id" HeaderText="EMP_Id" ReadOnly="True" SortExpression="EMP_Id">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PayDate" HeaderText="PayDate" ReadOnly="True" SortExpression="PayDate">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Ifsccode" HeaderText="Ifsccode" ReadOnly="True" SortExpression="Ifsccode">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BankName" HeaderText="BankName" ReadOnly="True" SortExpression="BankName">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Pmail" HeaderText="Pmail" ReadOnly="True" SortExpression="Pmail">
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
                        </td>
                        <td>
                            <asp:GridView ID="GridView5" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                BackColor="White" BorderColor="#3366CC" BorderStyle="None" BorderWidth="1px"
                                CellPadding="4" CssClass="gridview1" EnableViewState="False" Font-Italic="False"
                                Font-Size="X-Small" PageSize="2" Visible="False">
                                <Columns>
                                    <asp:BoundField DataField="ACCOUNT" HeaderText="ACCOUNT" ReadOnly="True" SortExpression="ACCOUNT">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="C" HeaderText="C" ReadOnly="True" SortExpression="C">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="AMOUNT" HeaderText="AMOUNT" ReadOnly="True" SortExpression="AMOUNT">
                                        <ControlStyle Width="45px" />
                                        <FooterStyle Width="45px" />
                                        <HeaderStyle Width="45px" />
                                        <ItemStyle Width="45px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NARRATION" HeaderText="NARRATION" ReadOnly="True" SortExpression="NARRATION">
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
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:GridView ID="GridView9" runat="server">
                                <HeaderStyle ForeColor="#660066" HorizontalAlign="Right" />
                                <FooterStyle ForeColor="#660066" HorizontalAlign="Right" />
                            </asp:GridView>
                            <br />
                            <asp:GridView ID="GridView10" runat="server">
                                <HeaderStyle ForeColor="#660066" HorizontalAlign="Right" />
                                <FooterStyle ForeColor="#660066" HorizontalAlign="Right" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <br />
                <%--<asp:Table ID="Table2" runat="Server" BorderColor="White" BorderWidth="1" 
                                            CaptionAlign="Top" CellPadding="1" CellSpacing="1" Height="40px" Width="294px" 
                                            style="font-size: small">
                                            <asp:TableRow ID="TableRow1" runat="Server" BorderWidth="1" Width="300px">
                                                <asp:TableCell ID="TableCell2" runat="Server" BorderWidth="1"> <asp:Table ID="Table1" runat="Server" BorderColor="White" BorderWidth="1" CaptionAlign="Top" CellPadding="1" CellSpacing="1" Height="40px" Width="300px"><asp:TableRow ID="TableRow12" runat="Server" BackColor="#3399CC" BorderColor="Silver" BorderWidth="1" ForeColor="white" Width="150px"><asp:TableCell ID="TableCell4" runat="Server" BorderWidth="2" > <asp:CheckBox ID="MChk_Menu1" runat="server" Width="170px" AutoPostBack="True" Enabled="false"  Text="Agent_Id" oncheckedchanged="MChk_Menu1_CheckedChanged"  /></asp:TableCell><asp:TableCell ID="TableCell5" runat="Server" BorderWidth="2" > <asp:CheckBox ID="MChk_Menu2" runat="server" Width="120px" AutoPostBack="True" Text="Amount" oncheckedchanged="MChk_Menu2_CheckedChanged" /></asp:TableCell></asp:TableRow><asp:TableRow ID="TableRow2" runat="Server" BackColor="#fffafa" BorderColor="Silver" BorderWidth="1"><asp:TableCell ID="TableCell1" runat="Server" BorderWidth="1" > <asp:CheckBoxList ID="CheckBoxList1" runat="server" BorderWidth="0" Enabled="false" ></asp:CheckBoxList></asp:TableCell><asp:TableCell ID="TableCell3" runat="Server" BorderWidth="1" > <asp:CheckBoxList ID="CheckBoxList2" runat="server" BorderWidth="0"></asp:CheckBoxList></asp:TableCell></asp:TableRow></asp:Table></asp:TableCell>
                                            </asp:TableRow>
                                        </asp:Table>--%>
            </asp:Panel>
        </div>
    </section>
</asp:Content>
