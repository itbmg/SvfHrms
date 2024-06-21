<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="OtpAuthentication.aspx.cs" Inherits="OtpAuthentication" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 <link href="css/fieldset.css" rel="stylesheet" type="text/css" />
  <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_loginotp_details();
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

        var branchnamearr = [];
        function get_loginotp_details() {
            //var refid = document.getElementById('txt_Project').value;
            var data = { 'op': 'get_loginotp_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        branchnamearr = msg;
                        get_logindetails_details(msg);
                        get_formdetails_details(msg);
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
          var emptytable1 = [];
        var employeelogindetails = [];
        function get_logindetails_details(msg) {
            employeelogindetails = msg;
            var fromid = document.getElementById('txt_Project').value;
            var empnameloginList = [];
            for (var i = 0; i < msg.length; i++) {
                if (fromid = msg[i].fromid) {
                    var username = msg[i].loginname;
                    empnameloginList.push(username);
                }
            }
            $('#txt_Loginname').autocomplete({
                source: empnameloginList,
                autoFocus: true
            });

        }
                    
        var emptytable = [];var logindetails=[];
        function filldetails(msg) {
            var data = document.getElementById('txt_Project');
            var length = data.options.length;
            document.getElementById('txt_Project').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Project";
            opt.value = "Select Project";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].projectmodule != null) {
                    if (msg[i].projectmodule != null) {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].projectmodule;
                        option.value = msg[i].fromid;
                        data.appendChild(option);
                    }
                }
            }
        }
        var emptytable1 = [];
        var employeefromdetails = [];
        function get_formdetails_details(msg) {
            employeefromdetails = msg;
            var fromid = document.getElementById('txt_Project').value;
            var empnamefromList = [];
            for (var i = 0; i < msg.length; i++) {
                if (fromid = msg[i].fromid) {
                    var fromname = msg[i].fromname;
                    empnamefromList.push(fromname);
                }
            }
            $('#txt_form').autocomplete({
                source: empnamefromList,
                autoFocus: true
            });

        }
        //Function for only no
        $(document).ready(function () {
            $("#txt_phoneno").keydown(function (event) {
                // Allow: backspace, delete, tab, escape, and enter
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 || event.keyCode == 190 ||
                // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
                // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                }
                else {
                    // Ensure that it is a number and stop the keypress
                    if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                        event.preventDefault();
                    }
                }
            });
        });

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
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }
        function validateEmail(email) {
            var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
            if (reg.test(email)) {
                return true;
            }
            else {
                return false;
            }
        }

        function for_save_edit_Form() {
            var projectmodule = document.getElementById('txt_Project').value;
            var fromname = document.getElementById('txt_form').value;
            var status = document.getElementById('ddlstatus').value;
            var moblenumbr = document.getElementById('txt_Numbr').value;
            var loginname = document.getElementById('txt_Loginname').value;
            var fromid = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').value;
            var flag = false;
            var data = { 'op': 'save_otpauthecation_click', 'projectmodule': projectmodule, 'fromname': fromname, 'btnval': btnval, 'fromid': fromid, 'moblenumbr': moblenumbr, 'status': status, 'loginname': loginname };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("New Department Successfully Created");
                        forclearall();
                       // get_Form_details();
                    }

                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearall() {
            document.getElementById('txt_Project').selectedIndex = 0;
            document.getElementById('txt_form').value = "";
            document.getElementById('btn_save').value = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }

        var replaceHtmlEntites = (function () {
            var translate_re = /&(nbsp|amp|quot|lt|gt);/g;
            var translate = {
                "nbsp": " ",
                "amp": "&",
                "quot": "\"",
                "lt": "<",
                "gt": ">"
            };
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Add Form<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Form</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Form Master Details
                </h3>
            </div>
            <div>
                <table id="tbl_leavemanagement" align="center">
                    <tr>
                        <td style="height: 40px;">
                            Project Moudle
                        </td>
                        <td>
                            <select  class="form-control" id="txt_Project" >
                            </select>
                        </td>
                    </tr>
                     <tr>
                        <td style="height: 40px;">
                            Form Name
                        </td>
                        <td>
                            <input  class="form-control" id="txt_form" />
                            
                        </td>
                    </tr>
                     <tr>
                        <td style="height: 40px;">
                            Mobile Number
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txt_Numbr"  placeholder="Enter Numbr"/>
                        </td>
                        </tr>
                    <tr>
                        <td style="height: 40px;">
                            Login Name
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txt_Loginname"  placeholder="Enter Loginname"/>
                        </td>
                    </tr>
                       <tr>
                             <td style="height:40px;">
                             Status<span style="color: red;">*</span>     
                            </td>
                             <td>
                             <select ID="ddlstatus"  class="form-control">
                             <option value="1">Active</option>
                             <option value="0">InActive</option>
                             </select>
                             </td>
                      </tr>
                    <tr>
                        <td>
                        </td>
                        <td style="height: 40px;">
                            <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                onclick="for_save_edit_Form();">
                            <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                onclick="forclearall();">
                        </td>
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="lbl_sno">
                            </label>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
                <div id="div_Deptdata">
                </div>
            </div>
        </div>
    </section>
</asp:Content>


