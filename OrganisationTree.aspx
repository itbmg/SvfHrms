<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="OrganisationTree.aspx.cs" Inherits="OrganisationTree" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Employeedetails();
            get_organisation_tree_details();
//            $("#showdivform").css("display", "block");
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

        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                    $('#selct_sub_employe').autocomplete({
                        source: empnameList,
                        change: subemployeenamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function employeenamechange() {
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_empid').value = employeedetails[i].empsno;
                }
            }
        }
        function subemployeenamechange() {
            var empname = document.getElementById('selct_sub_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_sub_empid').value = employeedetails[i].empsno;
                }
            }
        }
        var gridBinding = [];
        function AddTogridClick() {
            $("#div_Deptdata").hide();
            var txt_sub_empid = document.getElementById('txt_sub_empid').value;
            var sub_employe_name = document.getElementById('selct_sub_employe').value;
            if (txt_sub_empid == "") {
                alert("Please select sub emp name");
                return false;
            }
            var Checkexist = false;
            $('.empid').each(function (i, obj) {
                var IName = $(this).text();
                if (IName == txt_sub_empid) {
                    alert("sub emp name Already Added");
                    Checkexist = true;
                }
            });
            if (Checkexist == true) {
                return;
            }
            gridBinding.push({ 'empid': txt_sub_empid, 'sub_employe_name': sub_employe_name });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Empid</th><th scope="col">Emp Name</th></tr></thead></tbody>';
            for (var i = 0; i < gridBinding.length; i++) {
                results += '<td scope="row"  class="empid">' + gridBinding[i].empid + '</td>';
                results += '<td scope="row"  class="empname">' + gridBinding[i].sub_employe_name + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_vendordata").html(results);
        }
        function save_organisation_tree_save_click() {
            var empname = document.getElementById('selct_employe').value;
            if (empname == "") {
                $("#selct_employe").focus();
                alert("Select Employee Name ");
                return false;
            }
            var btnsave = document.getElementById('btnSave').value;
            var Data = { 'op': 'save_organisation_tree_save_click', 'gridBinding': gridBinding, 'empid': empname };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    RefreshClick();
                    get_organisation_tree_details();
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
        }
        function RefreshClick() {
            document.getElementById('txt_empid').value = "";
            gridBinding = [];
            $("#div_vendordata").hide();
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table"><caption></casption>';
            results += '<thead><tr><th scope="col">Employee Id</th><th scope="col">Employee Name</th></tr></thead></tbody>';
            for (var i = 0; i < gridBinding.length; i++) {
                results += '<td scope="row"  class="empid">' + gridBinding[i].empid + '</td>';
                results += '<td scope="row"  class="empname">' + gridBinding[i].sub_employe_name + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_vendordata").html(results);
        }


        function get_organisation_tree_details() {
            var data = { 'op': 'get_organisation_tree_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        //                        //empdata = msg;
                        //                        filldata(msg);
                        //                        filldata1(msg);
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
        function filldetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto; text-align: center;padding:1%"><table style="text-align: center;" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr ><th scope="col" style="text-align: center;">Sno</th><th scope="col" style="text-align: center;">Employee Code</th><th scope="col" style="text-align: center;"><i class="fa fa-user"></i>Employee Name</th><th scope="col"style="text-align: center;" >Sub Employee Code</th><th scope="col" style="text-align: center;"><i class="fa fa-user"></i>Sub Employee Name</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                //k++;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                results += '<td  class="11">' + msg[i].fullname + '</td>';
                results += '<td data-title="Code" class="2">' + msg[i].empcode1 + '</td>';
                results += '<td class="5">' + msg[i].fullname1 + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].employeid1 + '</td>';
                results += '<td style="display:none" class="12">' + msg[i].employeid + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_orignaizedata").html(results);
        }

        function showdivform() {
            $("#div_Import").css("display", "none");
            $("#div_OFTForm").css("display", "block");
        }
        function showdivimport() {
            $("#div_Import").css("display", "block");
            $("#div_OFTForm").css("display", "none");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Organisation Tree<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">Organisation Tree</a></li>
        </ol>
    </section>
    <section class="content">
     <div style="background-color: aliceblue;">
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Form" ><a data-toggle="tab" href="#" onclick="showdivform()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Organisation Tree</a></li>
                        <li id="id_tab_Import" class=""><a data-toggle="tab" href="#" onclick="showdivimport()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Organisation Tree Import</a></li>
                    </ul>
                </div>
                <div id="div_OFTForm">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Organisation Tree Details
                </h3>
            </div>
            <div class="box-body">
                <table>
                    <tr>
                        <td style="height: 40px;">
                        <label class="control-label" >
                            Employee Name<span style="color: red;">*</span>
                            </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name" />
                        </td>
                        <td style="height: 40px; display: none">
                            <input id="txt_empid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                        <td style="height: 40px;">
                        <label class="control-label" >
                            Sub Employee Name<span style="color: red;">*</span>
                            </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="selct_sub_employe" placeholder="Enter Sub Employee Name" />
                        </td>
                        <td style="height: 40px; display: none">
                            <input id="txt_sub_empid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                        <td style="height: 40px;">
                        <%--<input type="button" class="btn btn-success" name="submit" class="btn btn-primary"
                                id="btn_save" value='Add' onclick="AddTogridClick()" />--%>
                            <div class="btn btn-success" style="width: 56px;">
                                <span class="glyphicon glyphicon-plus-sign" onclick="AddTogridClick()"></span> <span onclick="AddTogridClick()">Add</span>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <div id="div_vendordata" style="background: #ffffff">
                </div>
                <br />
            </div>
             <table align="center">
            <tr>
            <td>
                <div class="input-group">
                    <div class="input-group-addon">
                    <span class="glyphicon glyphicon-ok" id="btnSave1" onclick="save_organisation_tree_save_click()"></span><span id="btnSave" onclick="save_organisation_tree_save_click()">Save</span>
                </div>
                </div>
                </td>
                </table>
            <div id="div_orignaizedata">
            </div>
        </div>
        </div>
        <div id="div_Import" style="display: none;">
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
    <div>
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Organisation Employee Import Details
                </h3>
            </div>
            <div class="box-body">
                <table>
                    <tr>
                    <td> 
                        <label class="control-label" >
                        <asp:Label ID="Label1" runat="server"  Text="Label">Employee Name</asp:Label>&nbsp;
                        </label>
                        <td>
                        <asp:DropDownList ID="ddlemployee" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </td>
                        <td>
                            <asp:FileUpload ID="FileUploadToServer" runat="server"  />
                        </td>
                        <td style="width: 5px;">
                        </td>
                            <label class="control-label" >
                        </label>
                        <td>
                            <asp:Button ID="btnImport" runat="server" Text="Import" class="btn btn-primary" OnClick="btnImport_Click" />
                        </td>
                    </tr>
                </table>
                <br />
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="grvExcelData" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                            GridLines="Both" Font-Bold="true" Font-Size="Smaller">
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                            <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                Font-Names="Raavi" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                            <AlternatingRowStyle HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                        </asp:GridView>
                        </dr>
                        <asp:Button ID="Button1" runat="server" Text="Save" class="btn btn-primary" OnClick="btnSave_Click" />
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
            <div>
                <asp:Label ID="lblMessage" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label><br />
            </div>
            </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        </div>
    </div>
        </div>
    </section>
</asp:Content>
