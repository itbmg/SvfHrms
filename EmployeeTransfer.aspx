<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeeTransfer.aspx.cs" Inherits="EmployeeTransfer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(function () {
        get_transfer_branch_details();
        get_Employeedetails();
        get_Branch_details();
        get_from_Branch_details();
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
                document.getElementById('txtsupid').value = employeedetails[i].empsno;
                document.getElementById('txtempcode').value = employeedetails[i].empnum;
//                document.getElementById('txt_Frombranch').value = employeedetails[i].branchname;
                document.getElementById('txt_fromid').value = employeedetails[i].branchid;
            }
        }
    }


    var branchdetails = [];
    function get_Branch_details() {
        var data = { 'op': 'get_Branch_details' };
        var s = function (msg) {
            if (msg) {
                branchdetails = msg;
                var branchList = [];
                for (var i = 0; i < msg.length; i++) {
                    var branchname = msg[i].branchname;
                    branchList.push(branchname);
                }
                $('#txt_tobranch').autocomplete({
                    source: branchList,
                    change: branchTochange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function branchTochange() {
        var branchname = document.getElementById('txt_tobranch').value;
        for (var i = 0; i < branchdetails.length; i++) {
            if (branchname == branchdetails[i].branchname) {
                document.getElementById('txt_Toid').value = branchdetails[i].branchid;
            }
        }
    }

    var branchdetails = [];
    function get_from_Branch_details() {
        var data = { 'op': 'get_Branch_details' };
        var s = function (msg) {
            if (msg) {
                branchdetails = msg;
                var branchList = [];
                for (var i = 0; i < msg.length; i++) {
                    var branchname = msg[i].branchname;
                    branchList.push(branchname);
                }
                $('#txt_Frombranch').autocomplete({
                    source: branchList,
                    change: branchfromchange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function branchfromchange() {
        var branchname = document.getElementById('txt_Frombranch').value;
        for (var i = 0; i < branchdetails.length; i++) {
            if (branchname == branchdetails[i].branchname) {
                document.getElementById('txt_fromid').value = branchdetails[i].branchid;
            }
        }
    }


//    function employeefillbranch() {
//        var employeid = document.getElementById('txtsupid').value;
//        document.getElementById('txt_Frombranch').value = branchid;
//    }
    

    function save_employee_transfer() {
        var employeid = document.getElementById('txtsupid').value;
        if (employeid == "") {
            alert("Select Employee Name ");
            $('#selct_employe').focus();
            return false;
        }
        var empcode = document.getElementById('txtempcode').value;
        var tobranch = document.getElementById('txt_Toid').value;
        if (tobranch == "") {
            alert("Select to branch");
            $('#txt_Toid').focus();
            return false;
        }
        var frombranch = document.getElementById('txt_fromid').value;
        var date = document.getElementById('txt_date').value;
        if (date == "") {
            alert("select date");
            $('#txt_date').focus();
            return false;
        }
        var sno = document.getElementById('lbl_sno').innerHTML;
        var btnval = document.getElementById('btn_save').innerHTML;
        var flag = false;
        var data = { 'op': 'save_employee_transfer', 'employeid': employeid, 'empcode': empcode, 'tobranch': tobranch, 'frombranch': frombranch, 'date': date, 'btnval': btnval, 'sno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall();
                    get_transfer_branch_details();
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
        document.getElementById('txtsupid').value = "";
        document.getElementById('txt_tobranch').value = "";
        document.getElementById('txt_Frombranch').value = "";
        document.getElementById('txtempcode').value = "";
        document.getElementById('selct_employe').value = "";
        document.getElementById('txt_Toid').value = "";
        document.getElementById('txt_fromid').value = "";
        document.getElementById('txt_date').value = "";
        document.getElementById('btn_save').innerHTML = "Save";
        $("#lbl_code_error_msg").hide();
        $("#lbl_name_error_msg").hide();
        get_transfer_branch_details();
    }

    function get_transfer_branch_details() {
        var data = { 'op': 'get_transfer_branch_details' };
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
        results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">EmpName</th><th scope="col">FromBranch</th><th scope="col">ToBranch</th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
            results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
            results += '<td data-title="brandstatus" class="5">' + msg[i].frombranch + '</td>';
            results += '<td data-title="brandstatus"  class="6">' + msg[i].tobranch + '</td>';
            results += '<th scope="row" class="1" style="display:none">' + msg[i].empid + '</th>';
            results += '<td data-title="brandstatus" style="display:none" class="3">' + msg[i].date + '</td>';
            results += '<td data-title="brandstatus"   style="display:none" class="4">' + msg[i].empcode + '</td>';
            results += '<td data-title="brandstatus" style="display:none" class="7">' + msg[i].sno + '</td>';
            results += '<td data-title="brandstatus"   style="display:none" class="8">' + msg[i].frombranchid + '</td>';
            results += '<td data-title="brandstatus" style="display:none" class="9">' + msg[i].tobranchid + '</td>';
            results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_bulentdata").html(results);
    }
    function getme(thisid) {
        $('html, body').animate({
            scrollTop: $("#emptrnasdiv").offset().top
        }, 2000);
        var fullname = $(thisid).parent().parent().children('.2').html();
        var date = $(thisid).parent().parent().children('.3').html();
        var tobranch = $(thisid).parent().parent().children('.6').html();
        var frombranch = $(thisid).parent().parent().children('.5').html();
        var tobranchid = $(thisid).parent().parent().children('.8').html();
        var frombranchid = $(thisid).parent().parent().children('.9').html();
        var empid = $(thisid).parent().parent().children('.1').html();
        var empcode = $(thisid).parent().parent().children('.4').html();
        var sno = $(thisid).parent().parent().children('.7').html();

        //Department = replaceHtmlEntites(Department);
        document.getElementById('txtsupid').value = empid
        document.getElementById('txt_date').value = date;
        document.getElementById('txt_Toid').value = tobranchid;
        document.getElementById('txt_fromid').value = frombranchid
        document.getElementById('txt_tobranch').value = tobranch;
        document.getElementById('txt_Frombranch').value = frombranch;
        document.getElementById('txtempcode').value = empcode;
        document.getElementById('selct_employe').value = fullname;
        document.getElementById('lbl_sno').innerHTML = sno;
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
    

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <section class="content-header">
        <h1>
            Employee Transfer<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Employee  Transfer Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info" id="emptrnasdiv">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Transfer Master
                </h3>
            </div>
            <div>
             <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/transfers.png" alt="your image" style="border-radius: 5px; width: 150px;
                                                                    height: 100px; border-radius: 50%;" />
                                                                    </div>
                <table id="tbl_leavemanagement" align="center">
                 
                    <tr>
                        <td style="height: 40px;">
                          Employee Name
                        </td>
                        
                                            <td>
                                                <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name"
                                                    onkeypress="return ValidateAlpha(event);" />
                                            </td>
                                            <td style="dispaly:none">
                                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            <td style="dispaly:none">
                                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                          <td style="height: 40px;">
                            Date <span style="color: red;">*</span>
                        </td>
                        <td>
                           <input type="Date" class="form-control" id="txt_date"/>
                        </td>
                    </tr>
                       <tr>
                             <td style="height: 40px;">
                            From Branch <span style="color: red;">*</span>
                        </td>
                        <td>
                           <input type="text" class="form-control" id="txt_Frombranch" placeholder="Enter FROM Branch"/>
                        </td>
                           <td style="dispaly:none">
                                                <input id="txt_fromid" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            <td style="height: 40px;">
                                            </td>
                                           
                   
                        <td style="height: 40px;">
                            To Branch <span style="color: red;">*</span>
                        </td>
                        <td>
                           <input type="text" class="form-control" id="txt_tobranch" placeholder="Enter TO Branch"/>
                        </td >
                           <td style="dispaly:none">
                                                <input id="txt_Toid" type="hidden" class="form-control" name="hiddenempid" />
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
                <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_employee_transfer()"></span><span id="btn_save"  onclick="save_employee_transfer()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="btn_close1" onclick="forclearall()"></span><span id="btn_close" onclick="forclearall()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
            </div>
            <div>
                <div id="div_bulentdata">
                </div>
            </div>
        </div>
    </section>
</asp:Content>


