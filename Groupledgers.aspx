<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="Groupledgers.aspx.cs" Inherits="Groupledgers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_branchdetails();
            get_Groupledger_details();
            get_Grouptype_details();
            get_ledgerdetails();
            $("#div_ledgercodedetails").show();
            canceldetails();
        });

        function showledgercode() {
            $("#div_ledgercodedetails").show();
            $("#div_ledgertype").hide();
            canceldetails();
        }

        function showLedgertype() {
            $("#div_ledgercodedetails").hide();
            $("#div_ledgertype").show();
            get_Groupledger_details();
            grptypecanceldetails();

        }

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

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }


        function savegrplederDetails() {
            var ledgercode = document.getElementById('txt_ldgrCode').value;
            if (ledgercode == "") {
                $("#txt_ldgrCode").focus();
                alert("Enter Code ");
                return false;
            }
            var ledgername = document.getElementById('txt_ldgrNmae').value;
            if (ledgername == "") {
                $("#txt_ldgrNmae").focus();
                alert("Enter ledgername ");
                return false;

            }

            var btnval = document.getElementById('btn_saveledgr').innerHTML;
            var sno = document.getElementById('lbl_ldrsno').value;
            var data = { 'op': 'savegrplederDetails', 'ledgername': ledgername, 'ledgercode': ledgercode, 'btnVal': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_Groupledger_details();
                        canceldetails();
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
        function canceldetails() {
            document.getElementById('txt_ldgrNmae').value = "";
            document.getElementById('txt_ldgrCode').value = "";
            document.getElementById('lbl_ldrsno').value = "";
            document.getElementById('btn_saveledgr').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_Groupledger_details();
        }

        function get_Groupledger_details() {
            var data = { 'op': 'get_Groupledger_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillledgerdetails(msg);
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
        function fillledgerdetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th></th><th scope="col">Ledger Name</th><th scope="col">Ledger Code</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1">' + msg[i].ledgername + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].ledgercode + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].sno + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="ldgrgetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_ledgrcodeData").html(results);
        }
        function ldgrgetme(thisid) {
            $("#fillform").focus();
            var ledgername = $(thisid).parent().parent().children('.1').html();
            var ledgercode = $(thisid).parent().parent().children('.2').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            document.getElementById('txt_ldgrNmae').value = ledgername;
            document.getElementById('txt_ldgrCode').value = ledgercode;
            document.getElementById('btn_saveledgr').innerHTML = "Modify";
            document.getElementById('lbl_ldrsno').value = sno;
            $("#fillform").show();

        }



        var branchname_data = [];
        function get_branchdetails() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    branchname_data = msg;
                    var branchnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var branchname = msg[i].branchname;
                        branchnameList.push(branchname);
                    }
                    $('#txt_branchname').autocomplete({
                        source: branchnameList,
                        change: branchchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function branchchange() {
            var branchname = document.getElementById('txt_branchname').value;
            for (var i = 0; i < branchname_data.length; i++) {
                if (branchname == branchname_data[i].branchname) {
                    document.getElementById('txt_branchid').value = branchname_data[i].branchid;
                }
            }
        }


        var branchname_data = [];
        function get_ledgerdetails() {
            var data = { 'op': 'get_Groupledger_details' };
            var s = function (msg) {
                if (msg) {
                    Ledgername_data = msg;
                    var ledgernameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var ledgername = msg[i].ledgername;
                        ledgernameList.push(ledgername);
                    }
                    $('#txt_grpledgrname').autocomplete({
                        source: ledgernameList,
                        change: ledgerchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function ledgerchange() {
            var ledgername = document.getElementById('txt_grpledgrname').value;
            for (var i = 0; i < Ledgername_data.length; i++) {
                if (ledgername == Ledgername_data[i].ledgername) {
                    document.getElementById('txt_grpid').value = Ledgername_data[i].sno;
                }
            }
        }

        function save_grouptype_click() {
            var branchid = document.getElementById('txt_branchid').value;
            var Groupldrname = document.getElementById('txt_grpid').value;
            var ledgercode = document.getElementById('txt_lgrcode').value;
            var ledgerName = document.getElementById('txt_lgrname').value;
           
           
            if (Groupldrname == "") {
                $("#txt_grpledgrname").focus();
                alert("Enter Group Ledger Name");
                return false;
            }
            
            if (branchid == "") {
                alert("Enter ledger Code");
                $("#txt_lgrcode").focus();
                return false;
            }
            if (branchid == "") {
                alert("Enter Branch Name");
                $("#txt_lgrname").focus();
                return false;
            }

            var sno = document.getElementById('lbl_grpTypeCode').value;
            var btnSave = document.getElementById('btn_savegrpldgr').innerHTML;
            var data = { 'op': 'save_grouptype_click', 'branchid': branchid, 'Groupldrname': Groupldrname, 'btnVal': btnSave, 'ledgercode': ledgercode, 'ledgerName': ledgerName, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        grptypecanceldetails();
                        get_Grouptype_details();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            callHandler(data, s, e);
        }

        function get_Grouptype_details() {
            var data = { 'op': 'get_Grouptype_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillgrptypedetails(msg);
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

        function fillgrptypedetails(msg) {
            var l = 0;
            var k = 1;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">Group Type Name</th><th scope="col">Ledger Name</th><th scope="col">Ledger Code</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1">' + msg[i].branchname + '</th>';
                results += '<td data-title="code"  style="display:none" class="2">' + msg[i].branchid + '</td>';
                results += '<td data-title="code"  style="display:none"  class="3">' + msg[i].Groupldrid + '</td>';
                results += '<td data-title="code" class="4">' + msg[i].Groupldrname + '</td>';
                results += '<td data-title="code" class="5">' + msg[i].ledgername + '</td>';
                results += '<td data-title="code" class="6">' + msg[i].ledgercode + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td ><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="typegetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_grptypedata").html(results);
        }
        function typegetme(thisid) {
            $('html, body').animate({
                scrollTop: $("#divfocus").offset().top
            }, 2000);
            $("#divfocus").focus();
            var branchname = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.2').html();
            var Groupldrid = $(thisid).parent().parent().children('.3').html();
            var Groupldrname = $(thisid).parent().parent().children('.4').html();
            var ledgername = $(thisid).parent().parent().children('.5').html();
            var ledgercode = $(thisid).parent().parent().children('.6').html();
            var sno = $(thisid).parent().parent().children('.7').html();
            document.getElementById('txt_branchid').value = branchid;
            document.getElementById('txt_branchname').value = branchname;
            document.getElementById('txt_grpid').value = Groupldrid;
            document.getElementById('txt_grpledgrname').value = Groupldrname;
            document.getElementById('txt_lgrname').value = ledgername;
            document.getElementById('txt_lgrcode').value = ledgercode;
            document.getElementById('lbl_grpTypeCode').value = sno;
            document.getElementById('btn_savegrpldgr').innerHTML = "Modify";
            $("#fillform").show();

        }

        function grptypecanceldetails() {
            var CompanyName = document.getElementById('txt_branchid').value = "";
            var CSTNo = document.getElementById('txt_branchname').value = "";
            var Add = document.getElementById('txt_grpid').value = "";
            var TINNo = document.getElementById('txt_grpledgrname').value = "";
            var PhoneNo = document.getElementById('txt_lgrcode').value = "";
            var mailId = document.getElementById('txt_lgrname').value = "";
            document.getElementById('btn_savegrpldgr').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content" style="padding: 1%;">
        <!-- Small boxes (Stat box) -->
        <div class="row">
            <section class="content-header">
                <h1>
                    Group ledgers Masters
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
                    <li><a href="#">Masters</a></li>
                </ol>
            </section>
            <section class="content">
                    <div class="box-body" style="padding: 0%;">
                     <div class="box box-info">
                        <div>
                            <ul class="nav nav-tabs">
                                <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showledgercode()"><i
                                    class="fa fa-university"></i>&nbsp;&nbsp;Group LedgerCode</a></li>
                                <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="showLedgertype()"><i
                                    class="fa fa-bar-chart"></i>&nbsp;&nbsp;Group LedgerType</a></li>
                                    </ul>
                        </div>
                        <div id="div_ledgercodedetails" style="display: none;">
                         <div class="box box-info">
                             <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Group Ledger
                    </h3>
                </div>
                <div class="box-body">
                    <div id='fillform'>
                        <table align="center" style="width: 60%;">
                            <tr>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td>
                                 <label class="control-label" >
                                    Group Ledger Code
                                    </label>
                                </td>
                                <td>
                                    <input id="txt_ldgrCode" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter code" /><label id="lbl_code_error_msg" class="errormessage">* Please
                                            Enter Ledger Code</label>
                                </td>
                                 
                            </tr>
                             <tr>
                                <td style="height: 40px;">
                                 <label class="control-label" >
                                    Group Ledger Name<span style="color: red;">*</span>
                                    </label>
                                </td>
                                <td>
                                    <input id="txt_ldgrNmae" type="text" maxlength="45" class="form-control" name="vendorcode"
                                        placeholder="Enter Name" onkeypress="return ValidateAlpha(event);" /><label id="Label1" class="errormessage">* Please </label>
                                </td>
                                
                            </tr>
                            <tr style="display:none;"><td>
                            <label id="lbl_ldrsno"></label>
                            </td>
                            </tr>
                            
                            
                        </table>
                        <br />
                        <table align="center">
                        <tr>
                              <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_saveledgr1" onclick="savegrplederDetails()"></span> <span id="btn_saveledgr" onclick="savegrplederDetails()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='btn_closeldgr1' onclick="canceldetails()"></span> <span id='btn_closeldgr' onclick="canceldetails()">Close</span>
                          </div>
                    </td>
                            </tr>
                        </table>
                        </div>
                         </div>
                          </div>
<div class="box box-primary">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-th-list"></i>GroupLedger Code  list
                </h3>
            </div>
       <div id="div_ledgrcodeData">
                    </div>
                </div>
                        </div>
                        <div id="div_ledgertype" style="display: none;">
                        <div class="box box-primary">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Group Type Master
                </h3>
            </div>
            <div class="box-body">
            <div id="groupfills"> 
                <table id="divfocus"align="center" style="width: 60%;">
                    <tr>
                        <td >
                        <label class="control-label" >
                            Branch Name</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_branchname" placeholder=" Enter Branch Name" style="margin: 0px; height: 35px; width: 312px;"/>
                        </td>
                         <td style="height: 40px;">
                                <input id="txt_branchid" type="hidden" class="form-control" name="hiddenbranchid" />
                            </td>
                    </tr>
                    <tr>
                        <td>
                          <label class="control-label" > Group Ledger Name</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_grpledgrname" placeholder=" Enter Gl Name" style="margin: 0px; height: 35px; width: 312px;"/>
                        </td>
                        <td style="height: 40px;">
                                <input id="txt_grpid" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                    </tr>
                    <tr>
                        <td>
                        <label class="control-label" > Ledger Code</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_lgrcode" placeholder="Enter CODE" style="margin: 0px; height: 35px; width: 312px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="control-label" >Ledger Name</label>
                        </td>
                        <td style="height: 40px;">
                            <input type="text" class="form_control" id="txt_lgrname" placeholder="Enter  Name"  style="margin: 0px; height: 35px; width: 312px;"/>
                        </td>
                    </tr>
                </table>
                <br />
                <table align="center">
                    
                      <tr>
                              <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_savegrpldgr1" onclick="save_grouptype_click()"></span> <span id="btn_savegrpldgr" onclick="save_grouptype_click()">save</span>
                             </div>

                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='close_id1' onclick="grptypecanceldetails()"></span> <span id='close_id' onclick="grptypecanceldetails()">Close</span>
                          </div>
                    </td>
                            </tr>
                    <tr style="display: none;">
                <td>
                    <label id="lbl_grpTypeCode">
                    </label>
                </td>
            </tr>
                </table>
                </div>
            </div>
            </div>
            <div class="box box-primary">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-th-list"></i>GroupLedger Type  list
                </h3>
            </div>
  <div id="div_grptypedata"></div>
                </div>
                        </div>
                        </div>
                    </div>
                </div>
    </section>
</asp:Content>
