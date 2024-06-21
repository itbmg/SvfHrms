<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="HrApprovalemployee.aspx.cs" Inherits="HrApprovalemployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_hrjoinnemployee();
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
    function get_hrjoinnemployee() {
        var data = { 'op': 'get_hrjoinnemployee' };
        var s = function (msg) {
            if (msg) {
                fillresignation(msg);
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function fillresignation(msg) {
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr></th></th><th scope="col">Emploeename</th><th scope="col">Satus</th><th scope="col">Empcode</th><th scope="col"></th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
            results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
//            results += '<td  class="3">' + msg[i]. + '</td>';
//            results += '<td  class="4">' + msg[i].resignationdate + '</td>';
                 results += '<td style="display:none" class="3">' + msg[i].mobilenumbr + '</td>';
            results += '<td  class="4">' + msg[i].status + '</td>';
            results += '<td  class="5">' + msg[i].empcode + '</td>';
            //results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
            results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" style="display:none" onclick="save_resignation_reject_click(this);" value="Apporval" /></td><td><input id="btn_poplate" type="button"  onclick="otp_approve_click(this)" name="submit" class="btn btn-danger" value="OTP" /></td></td><td><input id="btn_poplate" type="button"  onclick="FP_approve_click(this)" name="submit" class="btn btn-danger" value="FP" /></td></tr>';
        }
        results += '</table></div>';
        $("#fillGrid").html(results);
    }
    function CloseClick() {
        $('#divMainAddNewRow').css('display', 'none');
    }

    var sno = 0;
    function getme(thisid) {
        $('#divMainAddNewRow').css('display', 'block');
        var fullname = $(thisid).parent().parent().children('.1').html();
        var department = $(thisid).parent().parent().children('.2').html();
        var joindate = $(thisid).parent().parent().children('.3').html();
        var resignationdate = $(thisid).parent().parent().children('.4').html();
        var reason = $(thisid).parent().parent().children('.5').html();
        var employeid = $(thisid).parent().parent().children('.2').html();
        sno = $(thisid).parent().parent().children('.3').html();
        var status = $(thisid).parent().parent().children('.7').html();
    }
    function save_resignation_reject_click() {
    }
    function FP_approve_click() {
        //var reason = document.getElementById("txt_remarks").value;
        var data = { 'op': 'FP_approve_click'};
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_hrjoinnemployee();
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

    function otp_approve_click(thisid) {
        var employeid = $(thisid).parent().parent().children('.2').html();
        //        sno = $(thisid).parent().parent().children('.6').html();
        var data = { 'op': 'otp_approve_click', 'employeid': employeid };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    var link = window.open(msg, '_blank');
                    get_hrjoinnemployee();
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           HR Approval join Employee<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Approval For join</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Requests  Details
            </h3>
        </div>
        <div class='divcontainer' style="overflow:auto;">
        <div id="fillGrid">
                </div>
        </div>
        <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
            width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
            background: rgba(192, 192, 192, 0.7);">
            <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                border-radius: 10px 10px 10px 10px;">
                <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                    id="tableCollectionDetails" class="mainText2" border="1">
                    <tr>
                        <td>
                            <label>
                                Remarks</label>
                        </td>
                        <td style="height: 40px;">
                            <textarea id="txt_remarks" type="text" class="form-control" name="Remarks" placeholder="Enter remarmks"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_resignation_reject_click();" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                z-index: 99999; cursor: pointer;">
                <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
            </div>
        </div>
    </div>
    </section>
</asp:Content>


