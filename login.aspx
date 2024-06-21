<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="icon" href="images/hr.png" type="image/x-icon" title="Vyshnavi HRMS" />
    <title>Vyshnavi HRMS</title>
    <link href="Styles/LoginStyleSheet.css?v=9003" rel="stylesheet" type="text/css" />
    <style type="text/css">
        html
        {
            height: 100%;
        }
        body
        {
            height: 100%;
            min-height: 100%;
            background: #017fbc;
            color: #FFFFFF;
            position: relative;
            margin: 0px;
        }
        #header
        {
            height: 50px;
            width: 100%;
            top: 0px;
            left: 0px;
            background: #CCCCCC;
            position: absolute;
        }
        #footer
        {
            height: 50px;
            width: 100%;
            bottom: 0px;
            left: 0px;
            background: #e5e5e5;
            position: absolute;
        }
        #content
        {
            height: 100%;
            background-color: #017fbc;
        }
        #outer
        {
            position: absolute;
            top: 50%;
            left: 0px;
            width: 100%;
            height: px;
            overflow: visible;
            background-color: skyblue;
        }
        #inner
        {
            width: 970px;
            height: 477px;
            margin-left: -485px;
            position: absolute;
            top: -228px;
            left: 50%;
            background-image: url(Images/bg.png);
            background-repeat: no-repeat;
        }
        .alertBox
        {
            position: absolute;
            top: 222px;
            left: 80%;
            width: 450px;
            margin-left: -250px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            padding: 4px 8px;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function Validate() {
            var msg = document.getElementById('<%=lblMsg.ClientID %>');
            if (document.getElementById('<%=txtUserName.ClientID %>').value.length == 0) {
                msg.innerHTML = "Please enter user name ";
                msg.style.color = "red";
                document.getElementById('<%=txtUserName.ClientID %>').focus();
                return false;
            }

            if (document.getElementById('<%=txtPassword.ClientID %>').value.length == 0) {
                msg.innerHTML = "Please enter password ";
                msg.style.color = "red";
                document.getElementById('<%=txtPassword.ClientID %>').focus();
                return false;
            }

            msg.innerHTML = "";
            return true;
        }    
    </script>
</head>
<body>
    <form id="loginForm" runat="server">
    <div id="header">
        <div style="width: 100%; height: 70px; background-color: #FFF">
            <div class="logo">
            </div>
        </div>
    </div>
    <div id="content">
        <div id="outer">
            <div id="inner">
                <div class="managmentcricle">
                </div>
                <div class="signinbg">
                </div>
                <div class="textbox1">
                </div>
                <div class="textbox2">
                </div>
                <div class="username">
                    User Name:</div>
                <div class="password">
                    Pass Word:</div>
                <div class="Rememberme">
                    Remember Me</div>
                <asp:textbox id="txtUserName" runat="server" class="input1" maxlength="100" placeholder="Enter User Name">
                </asp:textbox>
                <asp:textbox id="txtPassword" runat="server" class="input2" textmode="Password" placeholder="Enter Password">
                </asp:textbox>
                <asp:label id="lbl_passwords" runat="server" visible="false"></asp:label>
                <asp:label id="lbl_username" runat="server" visible="false"></asp:label>
                <input type="checkbox" class="checkbox" />
                <asp:button id="btnLogin" runat="server" class="loginbtn" tooltip="Click Here To Login"
                    onclientclick="return Validate();" onclick="btnLogin_Click" />
                <div class="labels">
                    <asp:label id="lblMsg" runat="server" forecolor="Red" font-size="15px" font-bold="true">
                    </asp:label>
                </div>
                <!-- Alert message -->
                <div runat="server" id="AlertBox" class="alertBox" visible="false">
                    <div runat="server" id="AlertBoxMessage" style="padding-left: 0%; color: black;">
                    </div>
                    <asp:label text="" runat="server" id="lbl_validations" forecolor="Blue" font-bold="true"
                        font-size="18px" style="padding-top: 3%;"></asp:label>
                    <table style="padding-left: 20%;">
                        <tr>
                            <td style="padding-top: 10%; padding-bottom: 4%;">
                                <asp:panel id="Panel1" runat="server">
                                    <asp:button id="btn_logoutsession" text="Kill All Sessions" runat="server" onclick="sessionsclick_click"
                                        class="small" />
                                </asp:panel>
                            </td>
                            <td>
                                <asp:panel id="Panel2" runat="server" style="padding-left: 17%; padding-top: 23%;">
                                    <asp:button id="Button1" text="Close" runat="server" onclick="sessionsclick_Close"
                                        class="small" />
                                </asp:panel>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="labels" style="height: 200px; width: 400px; margin-top: 43% !important;">
                    <a target="_blank" href='https://play.google.com/store/apps/details?id=io.cordova.myapp211f39&hl=en&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'>
                        <img alt='Get it on Google Play' style="width: 50%;" src="Images/googleplay.png"
                            align="left"></a>
                </div>
            </div>
        </div>
    </div>
    <div id="footer">
        <div style="margin-right: auto; margin-left: auto; width: 100%; background-color: #e5e5e5">
            <div style="width: 970px; margin-left: auto; margin-right: auto">
                <div>
                    <div style="clear: left">
                        <ul style="list-style-type: none; float: left; width: 338px; margin-top: -21px; padding-left: 0px;
                            font-family: Arial; font-size: 13px; font-weight: bold">
                            <li id="footerlinks"><a href="#">Privacy Policy</a><span style="float: left; color: #4C4B4B;
                                margin-top: 40px; margin-left: 8px;">l</span></li>
                            <li id="footerlinks"><a href="#">Disclaimer</a><span style="float: left; color: #4C4B4B;
                                margin-top: 40px; margin-left: 8px;">l</span></li>
                            <li id="footerlinks"><a href="#">Site Map</a></li>
                        </ul>
                        <div class="copyright">
                            © 2016 Vyshnavi Dairy Spl Pvt. Ltd.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
