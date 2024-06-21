<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="ledgerMaster.aspx.cs" Inherits="ledgerMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_ledger_detailes();
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
    function save_ledger_details() {
        var ledgername = document.getElementById('txt_ledgername').value;
        if (ledgername == "") {
            alert("Enter ledgername");
            $('#txt_ledgername').focus();
            return false;
        }
        var ledgerlimt = document.getElementById('txt_legerlimit').value;
        if (ledgerlimt == "") {
            alert("Enter ledgerlimt");
            $('#txt_legerlimit').focus();
            return false;
        }
        var sno = document.getElementById('lbl_sno').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_ledger_details', 'ledgername': ledgername, 'ledgerlimt': ledgerlimt, 'btnVal': btnval, 'sno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_ledger_detailes();
                    $('#div_contact').show();
                    $("#fillform").show();
                    clearall();
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
   
    function get_ledger_detailes() {
        var data = { 'op': 'get_ledger_detailes' };
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
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col">Expenses Name</th><th scope="col">Expenses Limit</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td style="display:none" >' + k++ + '</td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].ledgername + '</th>';
            //results += '<th scope="row" class="2" style="text-align:center;">' + msg[i].fullname + '</th>';
            results += '<th scope="row" class="2" style="text-align:center;">' + msg[i].ledgerlimt + '</th>';
            //results += '<th scope="row" class="5" style="display:none;">' + msg[i].empid + '</th>';
            results += '<td style="display:none" class="3">' + msg[i].sno + '</td>';
            results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
        }
        results += '</table></div>';
        $("#div_cont").html(results);

    }
    function getme(thisid) {
        var ledgername = $(thisid).parent().parent().children('.1').html();
        var ledgerlimt = $(thisid).parent().parent().children('.2').html();
        var sno = $(thisid).parent().parent().children('.3').html();
        document.getElementById('txt_ledgername').value = ledgername;
        document.getElementById('txt_legerlimit').value = ledgerlimt;
        document.getElementById('lbl_sno').value = sno;
        document.getElementById('btn_save').innerHTML = "Modify";

    }
    function clearall() {
        document.getElementById('txt_legerlimit').value = "";
        document.getElementById('txt_ledgername').value = "";
        document.getElementById('btn_save').innerHTML = "Save";

    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
           Expenses Type <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Expenses Type</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Expenses Details
                </h3>
            </div>
            <div class="box-body">
             <div id="div_contact">
                   <div id='fillform' >
                      <table align="center">
                            <tr>
                                <td>
                                    <label>
                                         Expenses Name</label>
                                </td>
                               <td><input type="text" class="form-control" id="txt_ledgername" style="text-transform: capitalize;" placeholder="Enter Expenses Name" /></td>
                             </tr>
                             <tr>
                                <td>
                                    <label>
                                         Expenses Limit</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_legerlimit" class="form-control" type="text" placeholder="Enter Expenses Limit"/>
                               </td>
                             </tr>
                              <tr style="display:none;"><td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                           </table>
                           <br />
                        <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_save1"  onclick="save_ledger_details()"></span><span id="btn_save" onclick="save_ledger_details()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="btn_clear1" onclick="clearall()"></span><span id="btn_clear" onclick="clearall()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                       <div id ="div_cont"></div>
                       </div>
        </div>
    </div>
</div>
    </section>
</asp:Content>

