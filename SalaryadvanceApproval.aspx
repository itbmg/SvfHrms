<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="SalaryadvanceApproval.aspx.cs" Inherits="SalaryadvanceApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_salaryadvanceRequestDetails();
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
    function get_salaryadvanceRequestDetails() {
        var data = { 'op': 'get_salaryadvanceRequestDetails' };
        var s = function (msg) {
            if (msg) {
                fillsalaryadvancedetails(msg);
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }
    function fillsalaryadvancedetails(msg) {
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr></th></th><th scope="col">Employee Name</th><th scope="col">EmployeeCode</th><th scope="col">BranchName</th><th scope="col">DOJ</th><th scope="col">Purpose of Advance</th><th scope="col">Advance amount</th><th scope="col"></th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><th scope="row" class="1" style="text-align:center;">' + msg[i].fullname + '</th>';
            results += '<td  class="2">' + msg[i].Empcode + '</td>';
            results += '<td  class="2">' + msg[i].branchname + '</td>';
//            results += '<td  class="2">' + msg[i].designation + '</td>';
            results += '<td  class="3">' + msg[i].joindate + '</td>';
            results += '<td  class="5">' + msg[i].purpose_of_advance + '</td>';
            results += '<td class="4">' + msg[i].Advanceamount + '</td>';
            results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_salaryadvancerequest_approve_click(this);" value="Approval" /></td><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-danger" value="Reject" /></td>';
            results += '<td style="display:none" class="7">' + msg[i].status + '</td>';
            results += '<td style="display:none" class="6">' + msg[i].sno + '</td></tr>';
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
        var designation = $(thisid).parent().parent().children('.2').html();
        var joindate = $(thisid).parent().parent().children('.3').html();
        var purpose_of_loan = $(thisid).parent().parent().children('.5').html();
        var loanamount = $(thisid).parent().parent().children('.4').html();
        sno = $(thisid).parent().parent().children('.6').html();
        var status = $(thisid).parent().parent().children('.7').html();
    }

    function save_salaryadvancerequest_reject_click() {
        var rejectremarks = document.getElementById("txt_remarks").value;
        var data = { 'op': 'save_salaryadvancerequest_reject_click', 'sno': sno, 'rejectremarks': rejectremarks };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                $('#divMainAddNewRow').css('display', 'none');
                get_salaryadvanceRequestDetails();
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }

    function save_salaryadvancerequest_approve_click(thisid) {
        sno = $(thisid).parent().parent().children('.6').html();
        var data = { 'op': 'save_salaryadvancerequest_approve_click', 'sno': sno };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                get_salaryadvanceRequestDetails();
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <section class="content-header">
        <h1>
           Salary Advance Approval <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Requests For Salary Advance</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i> Salary Advance Requests Details
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
                        </td>
                        <td>
                            <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_salaryadvancerequest_reject_click();" />
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

