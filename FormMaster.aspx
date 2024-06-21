<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="FormMaster.aspx.cs" Inherits="FormMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_Form_details();
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
            var fromid = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').value;
            var flag = false;
            var data = { 'op': 'save_form_click', 'projectmodule': projectmodule, 'fromname': fromname, 'btnval': btnval, 'fromid': fromid };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("New Department Successfully Created");
                        forclearall();
                        get_Form_details();
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
            document.getElementById('txt_Project').value = "";
            document.getElementById('txt_form').value = "";
            //document.getElementById('ddlstatus').selectedIndex = 0;
            document.getElementById('btn_save').value = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_Form_details();
        }

        function get_Form_details() {
            var data = { 'op': 'get_Form_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
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
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Project Module</th><th scope="col">Form Name</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].projectmodule + '</th>';
                //results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].fromname + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].fromid + '</td>';
                //results += '<td style="display:none" class="4">' + msg[i].Reason + '</td>';
                results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }
        function getme(thisid) {
            var fromid = $(thisid).parent().parent().children('.3').html();
            var fromname = $(thisid).parent().parent().children('.2').html();
            var projectmodule = $(thisid).parent().parent().children('.1').html();
            document.getElementById('txt_Project').value = projectmodule;
            document.getElementById('txt_form').value = fromname
            document.getElementById('lbl_sno').innerHTML = fromid;
            document.getElementById('btn_save').value = "Modify";
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
                            <select  class="form-control" id="txt_Project" onchange="Getbranchcode(this);" >
                            <option  value="Procurement">Procurement</option>
                            <option  value="HR Module">HR Module</option>
                            <option  value="Plant ERP">Plant ERP</option>
                            <option  value="Purchase & Stores">Purchase & Stores</option>
                            <option  value="Marketing & Sales">Marketing & Sales</option>
                            <option  value="Finance & Accounting">Finance & Accounting</option>
                            <option  value="Fleet Management"> Fleet Management</option>
                            </select>
                        </td>
                    </tr>
                     <tr>
                        <td style="height: 40px;">
                            Form Name
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txt_form"  placeholder="Enter Form"/>
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


