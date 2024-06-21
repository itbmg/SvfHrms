<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="AddLeaveTypes.aspx.cs" Inherits="AddLeaveTypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_leavetype_details();
            forclearall();
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

        function for_save_edit_leavetype() {
            var leavetype = document.getElementById('txtleavetype').value;
            if (leavetype == "") {
                $("#txtleavetype").focus();

                alert("Enter leavetype");
                return false;
            }
            var leavetypecode = document.getElementById('txtleavetypecode').value;
            if (leavetypecode == "") {
                $("#txtleavetypecode").focus();
                alert("Enter leavetypecode");
                return false;
            }
            var monthlyaccum = document.getElementById('txtmonthly').value;
            if (monthlyaccum == "") {
                $("#txtleavetypecode").focus();
                alert("Enter monthlyaccum");
                return false;
            }
            var maximumaccum = document.getElementById('txtmaximum').value;
            if (maximumaccum == "") {
                $("#txtmaximum").focus();
                alert("Enter maximumaccum");
                return false;
            }
            var Reason = document.getElementById('txtreason').value;
            if (Reason == "") {
                $("#txtreason").focus();
                alert("Enter Reason");
                return false;
            }
            var status = document.getElementById('ddlstatus').value;
            if (status == "") {
                $("#ddlstatus").focus();
                alert("Select status");
                return false;
            }
            var leavetypeId = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').innerHTML;
            var flag = false;
            if (leavetype == "") {
                $("#lbl_code_error_msg").show();
                flag = true;
            }
            if (leavetypecode == "") {
                alert("required leavetype code");
                flag = true;
            }

            if (flag) {
                return;
            }
            var data = { 'op': 'save_leavetype_click', 'leavetype': leavetype, 'leavetypecode': leavetypecode, 'monthlyaccum': monthlyaccum, 'maximumaccum': maximumaccum, 'Reason': Reason, 'status': status, 'btnval': btnval, 'leavetypeId': leavetypeId };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_leavetype_details();
                        forclearall();
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
            document.getElementById('txtleavetype').value = "";
            document.getElementById('ddlstatus').selectedIndex = 0;
            document.getElementById('txtleavetypecode').value = "";
            document.getElementById('txtmonthly').value = "";
            document.getElementById('txtmaximum').value = "";
            document.getElementById('txtreason').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_leavetype_details();
        }

        function get_leavetype_details() {
            var data = { 'op': 'get_leavetype_details' };
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
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Leave Type</th><th scope="col">Leave Code</th><th scope="col">Status</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                var status = msg[i].status;
                if (status == "0") {

                    status = "Inactive";
                }
                else {
                    status = "Active";
                }
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].leavetype + '</th>';
                results += '<td data-title="Code" class="2">' + msg[i].leavetypecode + '</td>';
                results += '<td data-title="Code" class="3">' + status + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].monthlyaccumulation + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].maximumaccumulation + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].leavetypeId + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].Reason + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }
        function getme(thisid) {
            var leavetypeId = $(thisid).parent().parent().children('.6').html();
            var leavetype = $(thisid).parent().parent().children('.1').html();
            leavetype = replaceHtmlEntites(leavetype);
            var leavetypecode = $(thisid).parent().parent().children('.2').html();
            var monthlyaccumulation = $(thisid).parent().parent().children('.4').html();
            var maximumaccumulation = $(thisid).parent().parent().children('.5').html();
            var Reason = $(thisid).parent().parent().children('.7').html();
            var statuscode = $(thisid).parent().parent().children('.3').html();
            if (statuscode == "Active") {

                status = "1";
            }
            else {
                status = "0";
            }
            document.getElementById('txtleavetype').value = leavetype;
            document.getElementById('ddlstatus').value = status;
            document.getElementById('txtleavetypecode').value = leavetypecode;
            document.getElementById('txtmonthly').value = monthlyaccumulation;
            document.getElementById('txtmaximum').value = maximumaccumulation;
            document.getElementById('txtreason').value = Reason;
            document.getElementById('lbl_sno').innerHTML = leavetypeId;
            document.getElementById('btn_save').innerHTML = "Modify";
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

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Add LeaveTypes<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Leave Types</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info" style="padding-bottom: 3%;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Leave Types Master
                </h3>
            </div>
             <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Iconimages/typeleave.png" alt="your image" style="border-radius: 10px; width: 350px;
                                                                    height: 250px; border-radius: 20%;" />
                                                                    </div>
            <div>
                <table id="tbl_leavemanagement" align="center">
                   
                    <tr>
                    <td style="height: 40px;">
                        <label class="control-label" >
                            Leave Type
                        </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txtleavetype"  placeholder="Enter Leave Type" onkeypress="return ValidateAlpha(event);" />
                        </td>
                    </tr>
                    <tr>
                    <td style="height: 40px;">
                       <label class="control-label" >
                            LeaveType Code
                        </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txtleavetypecode"  placeholder="Enter Code" />
                        </td>
                    </tr>
                    <tr>
                    <td style="height: 40px;">
                         <label class="control-label" >
                            Monthly Accumulation
                        </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txtmonthly"  placeholder="Enter Monthly Acc" onkeypress="return isNumber(event)"/>
                        </td>
                    </tr>
                    <tr>
                    <td style="height: 40px;">
                         <label class="control-label" >
                            Maximum Accumulation
                        </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="txtmaximum"  placeholder="Enter Maximum Acc" onkeypress="return isNumber(event)" />
                        </td>
                    </tr>
                     <tr>
                     <td style="height: 40px;">
                      <label class="control-label" >
                            Status<span style="color: red;">*</span>
                        </label>
                        </td>
                        <td>
                            <select id="ddlstatus" class="form-control">
                                <option value="1">Active</option>
                                <option value="0">InActive</option>
                            </select>
                        </td>
                      </tr>
                    <tr>
                    <td style="height: 40px;">
                           <label class="control-label" >
                            Reason <span style="color: red;">*</span>
                        </label>
                        </td>
                        <td>
                            <textarea cols="35" rows="3" id="txtreason"  class="form-control" placeholder="Enter Reason"></textarea>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="lbl_sno">
                            </label>
                        </td>
                    </tr>
                </table>
                <br />
                <table style="margin-left:65%">
                    <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="for_save_edit_leavetype()"></span> <span id="btn_save" onclick="for_save_edit_leavetype()">save</span>
                             </div>
                    </td>
                    <td   style="width:2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="forclearall()"></span> <span id='btn_close' onclick="forclearall()">Close</span>
                          </div>
                    </td>
                    </table>
            </div>
            <div style="padding-top: 2%;">
            </div>
        <div class="box box-primary">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Leave Types list
                </h3>
            </div>
        <div id="div_Deptdata">
                </div>
                </div>
                 </div>
    </section>
</asp:Content>
