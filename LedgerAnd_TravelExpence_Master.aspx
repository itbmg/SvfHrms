<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="LedgerAnd_TravelExpence_Master.aspx.cs" Inherits="LedgerAnd_TravelExpence_Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {

    //---ledger details---//
        get_ledger_detailes();
        ShowLedgerdetails();
        get_divledger_detailes();

        //---travel exp----//
        get_collections_details();
        get_travelexpEmployeedetails();
        var date = new Date();
        var day = date.getDate();
        var month = date.getMonth() + 1;
        var year = date.getFullYear();
        if (month < 10) month = "0" + month;
        if (day < 10) day = "0" + day;
        today = year + "-" + month + "-" + day;
        $('#txt_fromdate').val(today);
        $('#txt_todate').val(today);
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
    function ShowLedgerdetails() {
        $("#Div_ledgerdetails").show();
        $("#div_travelExpDetails").hide();
    }
    function ShowTravelExpdetails() {
        $("#Div_ledgerdetails").hide();
        $("#div_travelExpDetails").show();

    }

    //-----------Ledger Details-------------//

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
                    $("#fillledgerform").show();
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
            results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getmeledger(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
        }
        results += '</table></div>';
        $("#div_ledgercont").html(results);

    }
    function getmeledger(thisid) {
        var ledgername = $(thisid).parent().parent().children('.1').html();
        var ledgerlimt = $(thisid).parent().parent().children('.2').html();
        var sno = $(thisid).parent().parent().children('.3').html();
        document.getElementById('txt_ledgername').value = ledgername;
        document.getElementById('txt_legerlimit').value = ledgerlimt;
        document.getElementById('lbl_sno').value = sno;
        document.getElementById('btn_save').innerHTML = "Modify";

    }
    function forceclearall_ledger() {
        document.getElementById('txt_legerlimit').value = "";
        document.getElementById('txt_ledgername').value = "";
        document.getElementById('btn_save').innerHTML = "Save";

    }

    //-----------------Travel expense Master---------------//

    var empname1_data = [];
    function get_travelexpEmployeedetails() {
        var data = { 'op': 'get_Employeedetails' };
        var s = function (msg) {
            if (msg) {
                empname1_data = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].empname;
                    empnameList.push(empname);
                }
                $('#txt_travelexp_empname').autocomplete({
                    source: empnameList,
                    change: travelexp_empnamechange,
                    autoFocus: true
                });
                $('#txt_approvename').autocomplete({
                    source: empnameList,
                    change: travelexp_approvenamechange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function travelexp_empnamechange() {
        var empname = document.getElementById('txt_travelexp_empname').value;
        for (var i = 0; i < empname1_data.length; i++) {
            if (empname == empname1_data[i].empname) {
                document.getElementById('txtempid').value = empname1_data[i].empsno;
                document.getElementById('txtempcode').value = empname1_data[i].empnum;
            }
        }
    }
    function travelexp_approvenamechange() {
        var empname = document.getElementById('txt_approvename').value;
        for (var i = 0; i < empname1_data.length; i++) {
            if (empname == empname1_data[i].empname) {
                document.getElementById('txtaprvempid').value = empname1_data[i].empsno;
                document.getElementById('txt_Approvempcode').value = empname1_data[i].empnum;
            }
        }
    }
    function save_travelexpenses_click() {
        var reportingname = document.getElementById("txt_RptName").value;
        if (reportingname == "") {
            alert("Enter Reporting Name");
            return false;
        }
        var empid = document.getElementById("txtempid").value;
        if (empid == "") {
            alert("Enter Employee Name");
            return false;
        }
        var empcode = document.getElementById("txtempcode").value;
        var fromdate = document.getElementById("txt_fromdate").value;
        if (fromdate == "") {
            alert("Enter fromdate");
            return false;
        }
        var todate = document.getElementById("txt_todate").value;
        if (todate == "") {
            alert("Enter todate");
            return false;
        }
        var fromlocation = document.getElementById("txt_frmloaction").value;
        if (fromlocation == "") {
            alert("Enter fromlocation");
            return false;
        }
        var tolocation = document.getElementById("to_loaction").value;
        if (tolocation == "") {
            alert("Enter tolocation");
            return false;
        }
        var instructionby = document.getElementById("txt_Instrct").value;
        if (instructionby == "") {
            alert("Enter instructionby");
            return false;
        }
        var purpose = document.getElementById('txt_Purpose').value;
        if (purpose == "") {
            alert("Enter Remarks");
            return false;
        }
        var approvedby = document.getElementById('txtaprvempid').value;
        if (approvedby == "") {
            alert("Enter Apporove Name");
            return false;
        }
        //var approvedcode = document.getElementById('txtempcode2').value;
        var totalamount = document.getElementById('txt_totalamount').value;
        var sno = document.getElementById("txtsno").value;
        var btnval = document.getElementById("btn_save").value;
        var rows = $("#tableCashFormdetails tr:gt(0)");
        var colleciondetails = new Array();
        $(rows).each(function (i, obj) {
            colleciondetails.push({ SNo: $(this).find('#hdnHeadSno').val(), Account: $(this).find('#txtAccount').text(), amount: $(this).find('#txtamount').text(), remarks: $(this).find('#txt_ledremarks').text() });
        });
        if (colleciondetails.length == "0") {
            alert("Please enter head of account details");
            return false;
        }
        var Data = { 'op': 'save_travelexpenses_click', 'reportingname': reportingname, 'empid': empid, 'btnval': btnval, 'empcode': empcode, 'todate': todate, 'fromlocation': fromlocation, 'tolocation': tolocation, 'instructionby': instructionby, 'purpose': purpose, 'approvedby': approvedby, 'fromdate': fromdate, 'totalamount': totalamount, 'colleciondetails': colleciondetails, 'sno': sno };
        var s = function (msg) {
            if (msg) {
                alert(msg);
                get_collections_details();
                forclearall_travelexp();
            }
        }
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        CallHandlerUsingJson(Data, s, e);
    }

    var AccountNameDetails = [];
    function get_divledger_detailes() {
        var data = { 'op': 'get_ledger_detailes' };
        var s = function (msg) {
            if (msg) {
                AccountNameDetails = msg;
                var AccountNameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var ledgername = msg[i].ledgername;
                    AccountNameList.push(ledgername);
                }
                $('#ddlheadaccounts').autocomplete({
                    source: AccountNameList,
                    change: AccountNamechange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function AccountNamechange() {
        var ledgername = document.getElementById('ddlheadaccounts').value;
        for (var i = 0; i < AccountNameDetails.length; i++) {
            if (ledgername == AccountNameDetails[i].ledgername) {
                document.getElementById('txt_head').value = AccountNameDetails[i].sno;
            }
        }
    }
    var Collectionform = [];
    //        var Collectionform = [];
    function get_collections_details() {
        var data = { 'op': 'get_collections_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillcolectiondetails(msg);
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
    function fillcolectiondetails(msg) {
        var results = '<div  style="overflow:auto; width:100%;"><table class="responsive-table" style="width:100;">';
        results += '<thead><tr><th scope="col"></th><th scope="col"></th><th scope="col">Employee Name</th><th scope="col">From Location</th><th scope="col">To Location</th><th scope="col">From Date</th><th scope="col">TO Date</th><th scope="col">Approve Name</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr><td><input id="btn_poplate" type="button"  onclick="getcoln(this)" name="submit" class="btn btn-primary" value="Edit" /></td>';
            results += '<td><input id="btn_poplate" type="button"  onclick="getprintreceipt(this)" name="submit" class="btn btn-primary" value="Print" /></td>';
            results += '<th scope="row" class="1"  style="display:none" style="text-align:center;">' + msg[i].reportingname + '</th>';
            results += '<td  class="13">' + msg[i].fullname + '</td>';
            results += '<td  class="6">' + msg[i].fromlocation + '</td>';
            results += '<td class="7">' + msg[i].tolocation + '</td>';
            results += '<td class="4">' + msg[i].fromdate + '</td>';
            results += '<td  class="5">' + msg[i].todate + '</td>';
            results += '<td  class="14">' + msg[i].aupporvebyname + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].instructionby + '</td>';
            results += '<td style="display:none" class="9">' + msg[i].purpose + '</td>';
            results += '<td style="display:none" class="10">' + msg[i].approvedby + '</td>';
            results += '<td style="display:none" class="11">' + msg[i].totalamount + '</td>';
            results += '<td style="display:none" class="2">' + msg[i].empid + '</td>';
            results += '<td style="display:none" class="3">' + msg[i].empcode + '</td>';
            results += '<td style="display:none" class="13">' + msg[i].fullname + '</td>';
            results += '<td style="display:none" class="14">' + msg[i].aupporvebyname + '</td>';
            results += '<td style="display:none" class="12">' + msg[i].sno + '</td></tr>';
        }
        results += '</table></div>';
        $("#div_travelexpndata").html(results);
    }
    function getprintreceipt(thisid) {
        var sno = $(thisid).parent().parent().children('.12').html();
        var data = { 'op': 'btnReceiptPrintClick', 'Receiptno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        };
        $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
        window.location = "Print_TravelExpenses.aspx";
    }
    function getcoln(thisid) {
        var reportingname = $(thisid).parent().parent().children('.1').html();
        var empid = $(thisid).parent().parent().children('.2').html();
        var fullname = $(thisid).parent().parent().children('.13').html();
        var empcode = $(thisid).parent().parent().children('.3').html();
        var fromdate = $(thisid).parent().parent().children('.4').html();
        var todate = $(thisid).parent().parent().children('.5').html();
        var fromlocation = $(thisid).parent().parent().children('.6').html();
        var tolocation = $(thisid).parent().parent().children('.7').html();
        var instructionby = $(thisid).parent().parent().children('.8').html();
        var purpose = $(thisid).parent().parent().children('.9').html();
        var approvedby = $(thisid).parent().parent().children('.10').html();
        var aupporvebyname = $(thisid).parent().parent().children('.14').html();
        var totalamount = $(thisid).parent().parent().children('.11').html();
        var sno = $(thisid).parent().parent().children('.12').html();
        //        var todate = $(thisid).parent().parent().children('.8').html();
        document.getElementById('txt_RptName').value = reportingname;
        document.getElementById('txtempid').value = empid;
        document.getElementById('txt_travelexp_empname').value = fullname;
        document.getElementById('txtempcode').value = empcode;
        document.getElementById('txt_fromdate').value = fromdate;
        document.getElementById('txt_todate').value = todate;
        document.getElementById('txt_frmloaction').value = fromlocation;
        document.getElementById('to_loaction').value = tolocation;
        document.getElementById('txt_Instrct').value = instructionby;
        document.getElementById('txt_Purpose').value = purpose;
        document.getElementById('txtaprvempid').value = approvedby;
        document.getElementById('txt_approvename').value = aupporvebyname;
        document.getElementById('txt_totalamount').value = totalamount;
        document.getElementById('txtsno').value = sno;
        document.getElementById('btn_save').value = "Modify";
        var data = { 'op': 'get_collectionssubdetails', 'sno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillcolectioneditdetails(msg);
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

    function fillcolectioneditdetails(msg) {
        $("#divHeadAcount").css("display", "block");
        Collectionform = [];
        for (var i = 0; i < msg.length; i++) {
            //var subno = msg[i].sno;
            var HeadSno = msg[i].SNo;
            var HeadOfAccount = msg[i].Account;
            var Amount = msg[i].amount;
            var remarks = msg[i].remarks;
            Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, remarks: remarks });
        }
        var results = '<div style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < Collectionform.length; i++) {
            results += '<tr><td></td>';
            results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
            results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
            results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
            results += '<td><span    class="remarksClass"  id="txt_ledremarks"><b>' + Collectionform[i].remarks + '</b></span></td>';
            results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
        }
        results += '</table></div>';
        $("#divHeadAcount").html(results);
    }

    function forclearall_travelexp() {
        document.getElementById('txt_RptName').value = "";
        document.getElementById('txtempid').value = 0;
        document.getElementById('txtempcode').value = "";
        document.getElementById('txt_fromdate').value = "";
        document.getElementById('txt_todate').value = "";
        document.getElementById('txt_frmloaction').value = "";
        document.getElementById('to_loaction').value = "";
        document.getElementById('txt_Instrct').value = "";
        document.getElementById('txt_Purpose').value = "";
        document.getElementById('txtaprvempid').value = "";
        document.getElementById('txt_totalamount').value = "";
        document.getElementById('txt_travelexp_empname').value = "";
        document.getElementById('txt_approvename').value = "";
        document.getElementById('ddlheadaccounts').value = "";
        document.getElementById('txtamount').value = "";
        document.getElementById('btn_save').value = "Save";
        Collectionform = [];
        var results = '<div style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < Collectionform.length; i++) {
            results += '<tr><td></td>';
            results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
            results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
            results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
            results += '<td><span    class="remarksClass"  id="txt_ledremarks"><b>' + Collectionform[i].remarks + '</b></span></td>';
            //results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
            results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
        }
        results += '</table></div>';
        $("#divHeadAcount").html(results);
    }

    Collectionform = [];
    function BtnAddClick() {
        $("#divHeadAcount").css("display", "block");
        var HeadSno = document.getElementById("txt_head").value;
        var HeadOfAccount = document.getElementById("ddlheadaccounts").value;
        if (HeadOfAccount == null || HeadOfAccount == "") {
            document.getElementById("ddlheadaccounts").focus();
            alert("Please enter Head Of Account ");
            return false;
        }
        var remarks = document.getElementById("txt_ledremarks").value;
        var Checkexist = false;
        $('.AccountClass').each(function (i, obj) {
            var IName = $(this).text();
            if (IName == HeadOfAccount) {
                alert("Account Already Added");
                Checkexist = true;
            }
        });
        if (Checkexist == true) {
            return;
        }
        $('.remarksClass').each(function (i, obj) {
            var remarkName = $(this).text();
        });
        if (Checkexist == true) {
            return;
        }
        var remarks = document.getElementById("txt_ledremarks").value;
        var Amount = document.getElementById("txtamount").value;
        if (Amount == "") {
            alert("Enter Amount");
            return false;
        }
        else {
            Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, remarks: remarks });
            var results = '<div style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
            results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < Collectionform.length; i++) {
                results += '<tr><td></td>';
                results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
                results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
                results += '<td style="display:none" class="7"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
                results += '<td><span    class="remarksClass"  id="txt_ledremarks"><b>' + Collectionform[i].remarks + '</b></span></td>';
                results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
            }
            results += '</table></div>';
            $("#divHeadAcount").html(results);
            var TotRate = 0.0;
            $('.AmountClass').each(function (i, obj) {
                if ($(this).text() == "") {
                }
                else {
                    TotRate += parseFloat($(this).text());
                }
            });
            TotRate = parseFloat(TotRate).toFixed(2);
            document.getElementById("txt_totalamount").value = TotRate;
        }
    }


    function RowDeletingClick(Account) {
        Collectionform = [];
        var HeadOfAccount = "";
        var HeadSno = "";
        var remarks = "";
        var Account = $(Account).closest("tr").find("#txtAccount").text();
        var Amount = "";
        var rows = $("#tableCashFormdetails tr:gt(0)");
        $(rows).each(function (i, obj) {
            if ($(this).find('#txtamount').text() != "") {
                HeadOfAccount = $(this).find('#txtAccount').text();
                HeadSno = $(this).find('#hdnHeadSno').val();
                Amount = $(this).find('#txtamount').text();
                remarks = $(this).find('#txt_ledremarks').text();
                if (Account == HeadOfAccount) {
                }
                else {
                    Collectionform.push({ HeadSno: HeadSno, HeadOfAccount: HeadOfAccount, Amount: Amount, remarks: remarks });
                }
            }
        });
        var results = '<div style="overflow:auto;"><table id="tableCashFormdetails" class="responsive-table">';
        results += '<thead><tr><th scope="col"></th><th scope="col">Head Of Account</th><th scope="col">Amount</th><th scope="col">Remarks</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < Collectionform.length; i++) {
            results += '<tr><td></td>';
            results += '<td scope="row" class="1" style="text-align:center;"><span id="txtAccount" style="font-size: 16px; color: Red;  font-weight: bold;" class="AccountClass"><b>' + Collectionform[i].HeadOfAccount + '</b></span></td>';
            results += '<td class="2"><span id="txtamount" style="font-size: 16px; color: green; font-weight: bold;"class="AmountClass"><b>' + Collectionform[i].Amount + '</b></span></td>';
            results += '<td style="display:none" class="8"><input type="hidden" id="hdnHeadSno" value="' + Collectionform[i].HeadSno + '" /></td>';
            results += '<td><span    class="remarksClass"  id="txt_ledremarks"><b>' + Collectionform[i].remarks + '</b></span></td>';
            //results += '<td style="display:none" class="6"><input type="hidden" id="hdnsubSno" value="' + Collectionform[i].subsno + '"/></td>';
            results += '<td  class="6"> <img src="Images/Odclose.png" onclick="RowDeletingClick(this);" style="cursor:pointer;" width="30px" height="30px" alt="Edit" title="Edit Qty"/> </td></tr>';
        }
        results += '</table></div>';
        $("#divHeadAcount").html(results);
        var TotRate = 0.0;
        $('.AmountClass').each(function (i, obj) {
            if ($(this).text() == "") {
            }
            else {
                TotRate += parseFloat($(this).text());
            }
        });
        TotRate = parseFloat(TotRate).toFixed(2);
        document.getElementById("txt_totalamount").value = TotRate;
    }

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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="content">
        <div class="row">
            <section class="content-header">
                <h1>
                  Ledger And Travel Expense Master
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Ledger And Travel Expense Master</a></li>
                    <li><a href="#">Master</a></li>
                </ol>
            </section>
        </div>
        <div class="box box-info">
            <div class="box-header with-border">
            </div>
            <div class="box-body">
                <div>
                    <ul class="nav nav-tabs">
                        <li id="id_ledger" class="active"><a data-toggle="tab" href="#" onclick="ShowLedgerdetails()">
                            <i class="fa fa-building-o" aria-hidden="true"></i>&nbsp;&nbsp;Ledger Details</a></li>
                        <li id="id_travelexp" class=""><a data-toggle="tab" href="#" onclick="ShowTravelExpdetails()">
                            <i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Travel Expense Details</a></li>
                    </ul>
                </div>
                </div>
                </div>

               <%-- -----------Ledger Details-------------%>

                <div id="Div_ledgerdetails" style="display: none;">
            <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Expenses Details
                </h3>
            </div>
            <div class="box-body">
                   <div id='fillledgerform' >
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
                                   <span class="glyphicon glyphicon-remove" id="btn_clear1" onclick="forceclearall_ledger()"></span><span id="btn_clear" onclick="forceclearall_ledger()">Close</span>
                                </div>
                            </div>
                         </td>
                       </tr>
                    </table>
                 <div id ="div_ledgercont"></div>
               </div>
            </div>
          </div>
       </section>
     </div>

    <%-------------Travel Expense Master--------------%>

      <div id="div_travelExpDetails" style="display: none;">
     <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Travel Expense Details
                </h3>
            </div>
            <div class="box-body">
                <div id="div_Payment">
                </div>
                <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
            src="Iconimages/travel.png" alt="your image" style="border-radius: 5px; width: 200px;
            height: 200px; border-radius: 50%;" />
            </div>
                <div id='fillform'>
                        <table align="center">
                            <tr>
                                <td>
                                    <label>
                                        ReportingName</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_RptName" class="form-control" type="text" placeholder="Enter Reporting Name"/>
                                </td>
                                <td>
                                    <label>
                                        Employee Name</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_travelexp_empname" class="form-control" type="text" placeholder="Enter Employee Name" />
                                </td>
                                <td style="height: 40px;">
                                    <input id="txtempid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                                <td style="height: 40px;">
                                    <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        From Date</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_fromdate" class="form-control" type="date" />
                                </td>
                                <td>
                                    <label>
                                        To Date</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_todate" class="form-control" type="date" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        From Location</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_frmloaction" class="form-control" type="text" placeholder="Enter From Location"/>
                                </td>
                                <td>
                                    <label>
                                        To Location</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="to_loaction" class="form-control" type="text" placeholder="Enter To Location" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Instruction By</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_Instrct" class="form-control" type="text" placeholder="Enter Instruction Name" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Ledger Name
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="ddlheadaccounts" type="text" class="form-control" placeholder="Enter head of accounts" />
                                </td>
                                <td style="height: 40px;">
                                    <input id="txtamount" class="form-control" type="text" placeholder="Enter Amount" onkeypress="return isNumber(event)"/>
                                </td>
                               <%--     <td style="width: 5px;">
                                    </td>--%>
                                 <td style="height: 40px;">
                                    <textarea rows="1" cols="45" id="txt_ledremarks" class="form-control" type="text" placeholder="Enter Remarks"></textarea>
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <input id="btn_add" type="button" onclick="BtnAddClick();" class="btn btn-success"
                                        name="Add" value='Add' />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div id="divHeadAcount" style="display:none;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Total Amount</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_totalamount" class="form-control" type="text" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                        Approved BY</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_approvename" class="form-control" type="text" placeholder="Enter Approve Name" />
                                </td>
                                <td style="height: 40px;">
                                    <input id="txtaprvempid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_Approvempcode" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label>
                                        Remarks</label>
                                </td>
                                <td colspan="2">
                                    <textarea rows="3" cols="45" id="txt_Purpose" class="form-control" maxlength="2000"
                                        placeholder="Enter Remarks"></textarea>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>
                                    <label id="txtsno">
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td style="display: none">
                                    <input id="txt_head" type="hidden" style="height: 28px; opacity: 1.0; width: 150px;" />
                                </td>
                            </tr>
                        </table>
                        <table align="center">
                            <tr>
                                <td colspan="2" align="center" style="height: 40px;">
                                    <input id="Button1" type="button" class="btn btn-success" name="submit" value='Save'
                                        onclick="save_travelexpenses_click()" />
                                    <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                        onclick="forclearall_travelexp()" />
                                </td>
                            </tr>
                        </table>
                        <div id="">
                        </div>
                </div>
            </div>
            <div id="div_travelexpndata">
            </div>
        </div>
    </section>
    </div>
  </section>
</asp:Content>

