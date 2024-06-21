<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="ChangePassWord.aspx.cs" Inherits="ChangePassWord" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            ChangePassWord<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">ChangePassWord</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>PassWord Details
                </h3>
            </div>
            <div class="box-body">
                    <table align="center">
                        <tr>
                            <td>
                              <label> Current Password</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <asp:TextBox ID="txtOldPassWord" TextMode="Password" runat="server" CssClass="form-control" placeholder="Enter Current Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtOldPassWord"
                                    ForeColor="Red" ErrorMessage="*">
                                </asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>New Password</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <asp:TextBox ID="txtNewPassWord" TextMode="Password" runat="server" CssClass="form-control" placeholder="Enter New Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNewPassWord"
                                    ForeColor="Red" ErrorMessage="*">
                                </asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                 <label>Conform Password</label><span style="color: red;">*</span>
                            </td>
                            <td>
                                <asp:TextBox ID="txtConformPassWord" TextMode="Password" runat="server" CssClass="form-control" placeholder="Enter Confirm Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtConformPassWord"
                                    ForeColor="Red" ErrorMessage="*">
                                </asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="LogOut.aspx">Back To Login Page</a>
                            </td>
                            <td>
                                <asp:Button ID="btnSubmitt" runat="server" CssClass="btn btn-success" Text="Submitt"
                                    OnClick="btnSubmitt_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="lblError" ForeColor="Red" runat="server" Text=""></asp:Label>
                                <asp:Label ID="lblMessage" ForeColor="Red" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>
            </div>  
        </div>
    </section>
</asp:Content>


