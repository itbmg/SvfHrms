<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="AddBankDetails.aspx.cs" Inherits="AddBankDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
  
<script type="text/javascript">
    $(function () {
        get_bank_details();
        get_Employeedetails();
        get_empbank_details();
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
    function only_no() {
        $("#txtaccountno").keydown(function (event) {
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
    }
    function ValidateAlpha(evt) {
        var keyCode = (evt.which) ? evt.which : evt.keyCode
        if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

            return false;
        return true;
    }

    function get_bank_details() {
        var data = { 'op': 'get_bank_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillbankdetails(msg);
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
    function fillbankdetails(msg) {
        var data = document.getElementById('slct_bank');
        var length = data.options.length;
        document.getElementById('slct_bank').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select bank";
        opt.value = "Select bank";
        opt.setAttribute("selected", "selected");
        opt.setAttribute("disabled", "disabled");
        opt.setAttribute("class", "dispalynone");
        data.appendChild(opt);
        for (var i = 0; i < msg.length; i++) {
            if (msg[i].name != null) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].name;
                option.value = msg[i].sno;
                data.appendChild(option);
            }
        }
    }

    var empname_data = [];
    function get_Employeedetails() {
        var data = { 'op': 'get_Employeedetails' };
        var s = function (msg) {
            if (msg) {
                empname_data = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].empname;
                    empnameList.push(empname);
                }
                $('#selct_employe').autocomplete({
                    source: empnameList,
                    change: empchange,
                    autoFocus: true
                });
            }
        }
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler(data, s, e);
    }
    function empchange() {
        var empname = document.getElementById('selct_employe').value;
        for (var i = 0; i < empname_data.length; i++) {
            if (empname == empname_data[i].empname) {
                document.getElementById('txtempid').value = empname_data[i].empsno;
                document.getElementById('txtempcode').value = empname_data[i].empnum;
            }
        }
    }
    function for_save_edit_empbankdetails() {
        var employeid = document.getElementById('txtempid').value;
        var empcode = document.getElementById('txtempcode').value;
        if (employeid == "") {
            $("#selct_employe").focus();
            alert("Select Employee Name ");
            return false;
        }
        var paymenttype = document.getElementById('slct_payment').value;
        if (paymenttype == "" || paymenttype == "Select payment type") {
            alert("Please Select payment type");
            return false;
        }
        else if (paymenttype == "Cash") {
        }
        else {
            var AccountNo = document.getElementById('txtaccountno').value;
            if (AccountNo == "") {
                alert("Please enter Account No");
                return false;
            }
            var bankid = document.getElementById('slct_bank').value;
            if (bankid == "") {
                alert("please Select Bank Details");
                return false;
            }
            var Branch = document.getElementById('txtbranch').value;
            if (Branch == "") {
                alert("Please Enter Branch Details");
                return false;
            }
            var IFSC = document.getElementById('txtifsc').value;
            if (IFSC == "") {
                alert("Please Enter IFSC Code");
                return false;
            }
            var Caddress = document.getElementById('txtcaddress').value;
            if (Caddress == "") {
                alert("Please Enter Address");
                return false;
            }
            var nameasforbank = document.getElementById('txt_nmaebank').value;
            if (nameasforbank == "") {
                alert("Please Enter Name As For Bank Record");
                return false;
            }
        }
       
        var sno = document.getElementById('lbl_sno').innerHTML;
        var btnval = document.getElementById('btn_save').innerHTML;
        var data = { 'op': 'save_edit_empbankdetails', 'employeid': employeid, 'AccountNo': AccountNo, 'bankid': bankid, 'Branch': Branch, 'IFSC': IFSC, 'Caddress': Caddress,  'paymenttype': paymenttype, 'nameasforbank': nameasforbank, 'empcode':empcode, 'btnval': btnval, 'sno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    forclearall();
                    get_empbank_details();
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
        document.getElementById('selct_employe').value = "";
        document.getElementById('txtempid').value = "";
        document.getElementById('txtaccountno').value = "";
        document.getElementById('slct_bank').selectedIndex = 0;
        document.getElementById('txtbranch').value = "";
        document.getElementById('txtifsc').value = "";
        document.getElementById('txtcaddress').value = "";
        document.getElementById('txt_nmaebank').value = "";
        document.getElementById('slct_payment').selectedIndex = 0;
        document.getElementById('btn_save').innerHTML = "Save";
           get_empbank_details();
       }
      var empdata = [];
    function get_empbank_details() {
        var data = { 'op': 'get_empbank_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    filldetails(msg);
                    empdata = msg;
                    filldata(msg);
                    filldata1(msg);
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
        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Payment Type</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
        var l = 0;
        var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
            results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
            results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
            results += '<td  class="12">' + msg[i].paymenttype + '</td>';
            results += '<td  class="15">' + msg[i].bankname + '</td>';
            results += '<td  class="3">' + msg[i].accountno + '</td>';
            results += '<td  class="6">' + msg[i].ifsc + '</td>';
            results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
            results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
            results += '<td  style="display:none" class="5">'+ msg[i].branch + '</td>';
            results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
            results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
            results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
            results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_Deptdata").html(results);
    }
    function getme(thisid) {
        var fullname = $(thisid).parent().parent().children('.11').html();
        var employeid = $(thisid).parent().parent().children('.2').html();
        var AccountNo = $(thisid).parent().parent().children('.3').html();
        var bankid = $(thisid).parent().parent().children('.4').html();
        var Branch = $(thisid).parent().parent().children('.5').html();
        var IFSC = $(thisid).parent().parent().children('.6').html();
        var Caddress = $(thisid).parent().parent().children('.7').html();
        var sno = $(thisid).parent().parent().children('.9').html();
        var paymenttype = $(thisid).parent().parent().children('.12').html();
        var nameasforbank = $(thisid).parent().parent().children('.13').html();
        var empcode = $(thisid).parent().parent().children('.1').html();
        var bankname = $(thisid).parent().parent().children('.15').html();

        document.getElementById('selct_employe').value = fullname;
        document.getElementById('txtempid').value = employeid;
        document.getElementById('txtaccountno').value = AccountNo;
        document.getElementById('slct_bank').value = bankid;
        document.getElementById('txtbranch').value = Branch;
        document.getElementById('txtifsc').value = IFSC;
        document.getElementById('txtcaddress').value = Caddress;
        document.getElementById('txtempcode').value = empcode;
        document.getElementById('slct_payment').value = paymenttype
        document.getElementById('txt_nmaebank').value = nameasforbank;
        document.getElementById('lbl_sno').innerHTML = sno;
        document.getElementById('btn_save').innerHTML = "Modify";
    }


    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }

    function filldata(msg) {
        var compiledList = [];
        for (var i = 0; i < msg.length; i++) {
            var empname = msg[i].fullname;
            compiledList.push(empname);
        }

        $('#txt_empname1').autocomplete({
            source: compiledList,
            change: empnamechange,
            autoFocus: true
        });
    }
    function empnamechange() {
        document.getElementById('txtempCode').value = "";
        var k = 1;
        var name = document.getElementById('txt_empname1').value;
        var msg = empdata;
        if (name == "") {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Payment Type</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                results += '<td  class="12">' + msg[i].paymenttype + '</td>';
                results += '<td  class="15">' + msg[i].bankname + '</td>';
                results += '<td  class="3">' + msg[i].accountno + '</td>';
                results += '<td  class="6">' + msg[i].ifsc + '</td>';
                results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }
        else {
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Payment Type</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (name == msg[i].fullname) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                    results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                    results += '<td  class="12">' + msg[i].paymenttype + '</td>';
                    results += '<td  class="15">' + msg[i].bankname + '</td>';
                    results += '<td  class="3">' + msg[i].accountno + '</td>';
                    results += '<td  class="6">' + msg[i].ifsc + '</td>';
                    results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                    results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                    results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                    results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                    results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }
    }

    function filldata1(msg) {
        var compiledList1 = [];
        for (var i = 0; i < msg.length; i++) {
            var empcode = msg[i].empcode;
            compiledList1.push(empcode);
        }

        $('#txtempCode').autocomplete({
            source: compiledList1,
            change: empnamecode,
            autoFocus: true
        });
    }
    function empnamecode() {
        document.getElementById('txt_empname1').value = "";
        var empcode = document.getElementById('txtempCode').value;
        var k = 1;
        var msg = empdata;
        if (empcode == "") {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                results += '<td  class="15">' + msg[i].bankname + '</td>';
                results += '<td  class="3">' + msg[i].accountno + '</td>';
                results += '<td  class="6">' + msg[i].ifsc + '</td>';
                results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="12">' + msg[i].paymenttype + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                //results += '<td><a class="btn icon-btn btn-primary" id="btn_poplate" onclick="getme(this)" style=" padding: 6px 6px 4px 3px; border-radius:50px;" href="#"><span id="btn_poplate" onclick="getme(this)" name="submit" class="glyphicon btn-glyphicon glyphicon-pencil img-circle text-muted"></span>Edit</a></td></tr>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }

        else {
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (empcode == msg[i].empcode) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                    results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                    results += '<td  class="15">' + msg[i].bankname + '</td>';
                    results += '<td  class="3">' + msg[i].accountno + '</td>';
                    results += '<td  class="6">' + msg[i].ifsc + '</td>';
                    results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                    results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                    results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                    results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                    results += '<td style="display:none" class="12">' + msg[i].paymenttype + '</td>';
                    results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                    //results += '<td><a class="btn icon-btn btn-primary" id="btn_poplate" onclick="getme(this)" style=" padding: 6px 6px 4px 3px; border-radius:50px;" href="#"><span id="btn_poplate" onclick="getme(this)" name="submit" class="glyphicon btn-glyphicon glyphicon-pencil img-circle text-muted"></span>Edit</a></td></tr>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            $("#div_Deptdata").html(results);
        }
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   <section class="content-header">
        <h1>
            Employee Bank Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">Employee Bank Master</a></li>
        </ol>
    </section>
    <section class="content">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Bank Details
            </h3>
        </div>
        <div>
        <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Iconimages/bank.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                                                                    <div style="padding-right:auto">
            <table id="tbl_leavemanagement" align="center">
                <tr>
                    <td>
                     <label class="control-label" >
                        Employee Name 
                        </label>
                    </td>
                    <td>
                     <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name" onkeypress="return ValidateAlpha(event);" />
                     </td>
                        <td style="height: 40px;">
                                <input id="txtempid" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                             <td style="height: 40px;">
                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label" >
                        Account No 
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtaccountno" placeholder="EnterAccount" />
                    </td>
                    <td>
                     <label class="control-label" >
                        Bank Name  
                        </label>
                    </td>
                       <td>
                         <select id="slct_bank" class="form-control">
                         <option selected disabled value="Select bank">Select Bank</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label" >
                        Branch Name
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtbranch"  placeholder="EnterBranch" onkeypress="return ValidateAlpha(event);"/>
                    </td>
                    <td>
                     <label class="control-label" >
                       IFSC Code 
                       </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtifsc" placeholder="Enter IFSC Code"/>
                    </td>
                </tr>
              
                <tr>
                    <td>
                     <label class="control-label" >
                        payment type
                        </label>
                    </td>
                    <td style="height: 40px;">
                        <select id="slct_payment" class="form-control">
                            <option value="Select payment type" disabled selected>Select payment Type</option>
                            <option value="Cash">Cash</option>
                            <option value="Credit">Credit</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="CheckPaid">CheckPaid</option>
                            <option value="FOC">FOC</option>
                            <option value="Refurbished">Refurbished</option>
                            <option value="Warranty">Warranty</option>
                            <option value="Transported">Transported</option>
                            <option value="Returnble">Returnble</option>
                            <option value="AgainstLoan">AgainstLoan</option>
                            <option value="Repair">Repair</option>
                            <option value="AuditCorrrection">AuditCorrrection</option>
                        </select>
                    </td>
                    <td>
                     <label class="control-label" >
                        Name as for bank record
                        </label>
                    </td>
                    <td>
                        <input name="comments" class="form-control" id="txt_nmaebank" placeholder="Enter Name bank record" onkeypress="return ValidateAlpha(event);"/>
                    </td>
                </tr>
                  <tr>
                    <td style="height: 40px;">
                     <label class="control-label" >
                        Bank Address 
                        </label>
                    </td>
                    <td colspan="3">
                        <textarea name="comments" class="form-control" id="txtcaddress" placeholder="Enter Bank address"></textarea>
                    </td>
                </tr>
                <%--<tr>
                    <td>
                    </td>
                    <td></td>
                    <td style="height: 40px;">
                     
                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="for_save_edit_empbankdetails();">
                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="forclearall();" >
                    </td>
                </tr>--%>
                <tr hidden>
                    <td>
                        <label id="lbl_sno">
                        </label>
                    </td>
                </tr>
            </table>
            <div style="padding-left: 47%;padding-top: 2%;padding-bottom: 2%;">
            <table>
            <tbody><tr>
            <td>
                <div class="input-group">
                    <div class="input-group-addon">
                    <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="for_save_edit_empbankdetails()"></span><span id="btn_save" onclick="for_save_edit_empbankdetails()">Save</span>
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
                </tbody></table>
            </div>
        </div>
        </div>
        <div>
         <table align="center">
                        <tr>
                            <td>
                                <input id="txt_empname1" type="text"style="height: 38px;opacity: 1.0;width: 202px;"
                                    class="form-control" name="vendorcode" placeholder="Search Employee Name" />
                            </td>
                                    <td ><span class="input-group-btn">
                                            <button type="button" class="btn btn-info btn-flat" style="height: 38px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                            </span>
                                        </td>
                             <td style="width:5px;"></td>
                            <td >
                                OR
                            </td>
                            <td style="width:5px;"></td>
                            <td>
                                <input id="txtempCode" type="text" style="height: 38px;opacity: 1.0;width: 202px;"
                                    class="form-control" name="vendorcode" placeholder="Search Employee Code" />
                                    
                            </td>
                              <td>
                              <span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 38px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                                </td>
                        </tr>
                        </table>
            <div id="div_Deptdata">
            </div>
            <br />
        </div>
    </div>
    </section>

</asp:Content>
