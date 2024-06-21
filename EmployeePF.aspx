<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="EmployeePF.aspx.cs" Inherits="EmployeePFaspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
     <script type="text/javascript">
         $(function () {
             $('#btn_addBrand').click(function () {
                 $('#fillform').css('display', 'block');
                 $('#showlogs').css('display', 'none');
                 $('#div_BrandData').hide();
                 // get_Dept_details();
                 get_Employeedetails();
                 get_pf_details();
                 //forclearall();
             });

             $('#btn_close').click(function () {
                 $('#fillform').css('display', 'none');
                 $('#showlogs').css('display', 'block');
                 $('#div_BrandData').show();
                 forclearall();
             });
             get_pf_details();
         });


//   
//        $(function () {
//            get_Dept_details();
//            get_Employeedetails();
//            get_pf_details();
////            get_Name();

//        });
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

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

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
                }
            }
        }
        function for_save_edit_emppfdetails() {
//            var Department = document.getElementById('selct_department').value;
//            if (Department == "") {
//                alert("Select Department ");
//                return false;
//            }
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                alert("Select EmployeeName ");
                return false;

            }
            var pfjoindate = document.getElementById('txtJoinDate').value;
//            if (pfjoindate == "") {
//                alert("Enter pfjoindate ");
//                return false;

//            }
            var pfscheme = document.getElementById('ddlscheme').value;
//            if (pfscheme == "") {
//                alert("Select pfscheme ");
//                return false;

//            }
            var uannumber = document.getElementById('txtUannumber').value;
            if (uannumber == "") {
                alert("Select uan number ");
                return false;

            }
            var pfnumber = document.getElementById('txtpfnumber').value;
            if (pfnumber == "") {
                alert("Enter pfnumber ");
                return false;

            }
            var estnumber = document.getElementById('txestnumber').value;            

            
            var checkpfnumber = document.getElementById('chk_packgechange').value;
            var identity = document.getElementById('ddlidentity').value;
            var epfcontribution = document.getElementById('ddlepf').value;
            var epscontribution = document.getElementById('ddleps').value;
            var kycidentitynumber = document.getElementById('ddlkycidentitynumber').value;

            var btnval = document.getElementById('btn_save').innerHTML;
//            var flag = false;
//            if (Department == "") {
//                $("#lbl_code_error_msg").show();
//                flag = true;
//            }

//            if (flag) {
//                return;
//            }
            var data = { 'op': 'save_edit_emppfdetails', 'kycidentitynumber': kycidentitynumber, 'employeid': employeid, 'pfjoindate': pfjoindate, 'pfscheme': pfscheme, 'uannumber': uannumber, 'pfnumber': pfnumber, 'checkpfnumber': checkpfnumber, 'epfcontribution': epfcontribution, 'identity': identity, 'epscontribution': epscontribution, 'estnumber': estnumber, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("Employee PF Details successfully added");
                        forclearall();
                        get_pf_details();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                        $('#div_BrandData').show();
                        document.getElementById('txtempCode').value = "";
                        document.getElementById('txt_empname1').value = "";
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
            // document.getElementById('selct_department').selectedIndex = 0;
            document.getElementById('selct_employe').value = "";
            document.getElementById('ddlscheme').value = "";
            document.getElementById('txtsupid').value = "";
            document.getElementById('txtJoinDate').value = "";
            document.getElementById('txtpfnumber').value = "";
            document.getElementById('txtUannumber').value = "";
            document.getElementById('chk_packgechange').value = "";
            document.getElementById('ddlidentity').selectedIndex = 0;
            document.getElementById('txestnumber').value = "";
            document.getElementById('ddlepf').selectedIndex = 0;
            document.getElementById('ddleps').selectedIndex = 0;
            document.getElementById('ddlkycidentitynumber').selectedIndex = 0;
            document.getElementById('btn_save').InnerHTML = "Save";
           // get_pf_details();
        }
        var empdata = [];
        function get_pf_details() {
            var data = { 'op': 'get_pf_details' };
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
        function check_pfnumber() {
            var exist = 0;
            var name = document.getElementById('txtpfnumber').value;
            for (var i = 0; i < empdata.length; i++) {
                var empdatas = "";
                empdatas = empdata[i].pfnumber;
                if (name == empdatas.trim()) {
                    exist = 1;
                }
            }
            if (exist == 1) {
                alert("Employee PF Number already Exist");
              //  document.getElementById('txtpfnumber').value = "";
                document.getElementById('txtpfnumber').focus();
                //exist = 0;
                //return false;
            }
        }
        function filldetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">PFJoindate</th><th scope="col">UANnumber</th><th scope="col">PFNumber</th><th scope="col">Bank Name</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                //k++;
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                results += '<td  class="11">' + msg[i].fullname + '</td>';
                results += '<td data-title="Code" class="2">' + msg[i].pfjoindate + '</td>';
                results += '<td style="display:none" class="3">' + msg[i].pfscheme + '</td>';
                results += '<td  class="4">' + msg[i].uannumber + '</td>';
                results += '<td class="5">' + msg[i].pfnumber + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].checkpfnumber + '</td>';
                results += '<td  class="7">' + msg[i].kycidentitynumber + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].identity + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].epfcontribution + '</td>';
                results += '<td style="display:none" class="10">' + msg[i].estnumber + '</td>';
                results += '<td  style="display:none" class="13">' + msg[i].epscontribution + '</td>';
                results += '<td style="display:none" class="12">' + msg[i].employeid + '</td>';
                 results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;  
                }
            }
            results += '</table></div>';
            $("#div_BrandData").html(results);
        
        }
        function getme(thisid) {
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_BrandData').hide();
            var empcode = $(thisid).parent().parent().children('.1').html();
            var pfjoindate = $(thisid).parent().parent().children('.2').html();
            var pfscheme = $(thisid).parent().parent().children('.3').html();
            var uannumber = $(thisid).parent().parent().children('.4').html();
            var pfnumber = $(thisid).parent().parent().children('.5').html();
            var checkpfnumber = $(thisid).parent().parent().children('.6').html();
            var kycidentitynumber = $(thisid).parent().parent().children('.7').html();
            var identity = $(thisid).parent().parent().children('.8').html();
            var epfcontribution = $(thisid).parent().parent().children('.9').html();
            var estnumber = $(thisid).parent().parent().children('.10').html();
            var fullname = $(thisid).parent().parent().children('.11').html();
            var employeid = $(thisid).parent().parent().children('.12').html();
           var epscontribution = $(thisid).parent().parent().children('.13').html();

            document.getElementById('selct_employe').value = fullname;
            document.getElementById('ddlscheme').value = pfscheme;
            document.getElementById('txtUannumber').value = uannumber;
            document.getElementById('txtpfnumber').value = pfnumber;
            document.getElementById('txestnumber').value = estnumber;
            document.getElementById('txtJoinDate').value = pfjoindate;
            document.getElementById('chk_packgechange').value = checkpfnumber;
            document.getElementById('ddlidentity').value = identity;
            document.getElementById('ddlepf').value = epfcontribution;
            document.getElementById('txestnumber').value = estnumber;
            document.getElementById('ddleps').value = epscontribution;
            document.getElementById('txtsupid').value = employeid;
           // document.getElementById('selct_department').value = departmentid;
            document.getElementById('ddlkycidentitynumber').value = kycidentitynumber;
            document.getElementById('btn_save').innerHTML = "Modify";
            // get_pf_details();
//            $("#div_BrandData").hide();
//            $("#fillform").show();
//            $('#showlogs').hide();
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
        //var compiledList = [];
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
            var name = document.getElementById('txt_empname1').value;
            var msg = empdata;
            if (name == "") {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">PFJoindate</th><th scope="col">PFNumber</th><th scope="col">UANnumber</th><th scope="col">Bank Name</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                    results += '<td  class="11">' + msg[i].fullname + '</td>';
                    results += '<td data-title="Code" class="2">' + msg[i].pfjoindate + '</td>';
                    results += '<td style="display:none" class="3">' + msg[i].pfscheme + '</td>';
                    results += '<td  class="4">' + msg[i].pfnumber + '</td>';
                    results += '<td class="5">' + msg[i].uannumber + '</td>';
                    results += '<td style="display:none" class="6">' + msg[i].checkpfnumber + '</td>';
                    results += '<td  class="7">' + msg[i].kycidentitynumber + '</td>';
                    results += '<td style="display:none" class="8">' + msg[i].identity + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].epfcontribution + '</td>';
                    results += '<td style="display:none" class="10">' + msg[i].estnumber + '</td>';
                    results += '<td  style="display:none" class="13">' + msg[i].epscontribution + '</td>';
                    results += '<td style="display:none" class="12">' + msg[i].employeid + '</td>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                    //results += '<td  class="13">' + msg[i].empcode + '</td>';
                }
                results += '</table></div>';
                $("#div_BrandData").html(results);
            }
            else {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col"></th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">PFJoindate</th><th scope="col">UANnumber</th><th scope="col">PFNumber</th><th scope="col">Bank Name</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    if (name == msg[i].fullname) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td  class="s1">1</td>';
                        results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                        results += '<td  class="11">' + msg[i].fullname + '</td>';
                        results += '<td data-title="Code" class="2">' + msg[i].pfjoindate + '</td>';
                        results += '<td style="display:none" class="3">' + msg[i].pfscheme + '</td>';
                        results += '<td  class="5">' + msg[i].pfnumber + '</td>';
                        results += '<td class="4">' + msg[i].uannumber + '</td>';
                        results += '<td style="display:none" class="6">' + msg[i].checkpfnumber + '</td>';
                        results += '<td  class="7">' + msg[i].kycidentitynumber + '</td>';
                        results += '<td style="display:none" class="8">' + msg[i].identity + '</td>';
                        results += '<td style="display:none" class="9">' + msg[i].epfcontribution + '</td>';
                        results += '<td style="display:none" class="10">' + msg[i].estnumber + '</td>';
                        results += '<td  style="display:none" class="13">' + msg[i].epscontribution + '</td>';
                        results += '<td style="display:none" class="12">' + msg[i].employeid + '</td>';
                        results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                $("#div_BrandData").html(results);
            }
        }
        var compiledList1 = [];
        function filldata1(msg) {
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
            var msg = empdata;
            if (empcode == "") {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">PFJoindate</th><th scope="col">PFNumber</th><th scope="col">UANnumber</th><th scope="col"><th scope="col">Bank Name</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                    results += '<td  class="11">' + msg[i].fullname + '</td>';
                    results += '<td data-title="Code" class="2">' + msg[i].pfjoindate + '</td>';
                    results += '<td style="display:none" class="3">' + msg[i].pfscheme + '</td>';
                    results += '<td  class="4">' + msg[i].pfnumber + '</td>';
                    results += '<td class="5">' + msg[i].uannumber + '</td>';
                    results += '<td style="display:none" class="6">' + msg[i].checkpfnumber + '</td>';
                    results += '<td  class="7">' + msg[i].kycidentitynumber + '</td>';
                    results += '<td style="display:none" class="8">' + msg[i].identity + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].epfcontribution + '</td>';
                    results += '<td style="display:none" class="10">' + msg[i].estnumber + '</td>';
                    results += '<td  style="display:none" class="13">' + msg[i].epscontribution + '</td>';
                    results += '<td style="display:none" class="12">' + msg[i].employeid + '</td>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                    //results += '<td  class="13">' + msg[i].empcode + '</td>';
                }
                results += '</table></div>';
                $("#div_BrandData").html(results);
            }
            else {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">PFJoindate</th><th scope="col">PFNumber</th><th scope="col">UANnumber</th><th scope="col"></th><th scope="col">Bank Name</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    if (empcode == msg[i].empcode) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                        results += '<td  class="11">' + msg[i].fullname + '</td>';
                        results += '<td data-title="Code" class="2">' + msg[i].pfjoindate + '</td>';
                        results += '<td style="display:none" class="3">' + msg[i].pfscheme + '</td>';
                        results += '<td  class="4">' + msg[i].pfnumber + '</td>';
                        results += '<td class="5">' + msg[i].uannumber + '</td>';
                        results += '<td style="display:none" class="6">' + msg[i].checkpfnumber + '</td>';
                        results += '<td  class="7">' + msg[i].kycidentitynumber + '</td>';
                        results += '<td style="display:none" class="8">' + msg[i].identity + '</td>';
                        results += '<td style="display:none" class="9">' + msg[i].epfcontribution + '</td>';
                        results += '<td style="display:none" class="10">' + msg[i].estnumber + '</td>';
                        results += '<td  style="display:none" class="13">' + msg[i].epscontribution + '</td>';
                        results += '<td style="display:none" class="12">' + msg[i].employeid + '</td>';
                        results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                $("#div_BrandData").html(results);
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee PF Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">Employee PF Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee PF Details
                </h3>
            </div>
            <div>
                <div class="box-body">
                    <div id="showlogs" align="center">
                        <table align="center">
                            <tr>
                                <td>
                                    <input id="txt_empname1" type="text" style="height: 28px; opacity: 1.0; width: 200px;"
                                        class="form-control" name="vendorcode" placeholder="Search Employee Name" />
                                </td>
                                <td ><span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 28px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                             </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    OR
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <input id="txtempCode" type="text" style="height: 28px; opacity: 1.0; width: 180px;"
                                        class="form-control" name="vendorcode" placeholder="Search Employee Code" />
                                </td>
                                <td ><span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 28px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                             </td>
                            <td style="width: 300px">
                            </td>
                                 <td>
                                    <div class="input-group">
                                        <div class="input-group-addon" >
                                            <span class="glyphicon glyphicon-plus-sign"  ></span> <span id="btn_addBrand" ">Add Employee PF</span>
                                        </div>
                                    </div>
                                   <%-- <input id="btn_addBrand"  type="button" name="submit" value='Add Employee PF' class="btn btn-primary" />--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="div_BrandData" style="padding-top: 24px;">
                    </div>
                    <div id='fillform' style="display: none;">
                                <div style="float:left; padding-left:20px">
                                            <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                                                                    src="Iconimages/employeepf.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                 </div>
                        <table id="tbl_leavemanagement" align="center">
                            <tr>
                            <%--<td style="height: 40px;">
                                Department<span style="color: red;">*</span>
                            </td>
                            <td>
                                <select id="selct_department" class="form-control" style="width: 250px;">
                                    <option selected disabled value="Select Department">Select Department</option>
                                </select>
                            </td>--%>
                            <td style="height: 40px;">
                                Employee Name<span style="color: red;">*</span>
                            </td>
                            <td>
                                <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name"
                                    onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td style="height: 40px; display:none">
                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                            <td style="height: 40px;">
                                    KYC Identity Number<span style="color: red;">*</span>
                                </td>
                                <td>
                                    <select id="ddlkycidentitynumber" class="form-control">
                                        <option value="Bank Account">Bank Account</option>
                                        <option value="Permanent Account Number">Permanent Account Number</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    PF Join Date<span style="color: red;">*</span>
                                </td>
                                <td>
                                    <input type="date" class="form-control" id="txtJoinDate" placeholder="Enter Join Date" />
                                </td>
                                <td style="height: 40px;">
                                    PF Scheme<span style="color: red;">*</span>
                                </td>
                                <td>
                                    <select id="ddlscheme" class="form-control">
                                        <option value="GOVT SCHEME">GOVT SCHEME</option>
                                        <option value="COMPANY SCHEME">COMPANY SCHEME</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    PF Number<span style="color: red;">*</span>
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txtpfnumber" placeholder="Enter PF Number" onchange="check_pfnumber()" />
                                </td>
                                <td>
                                    UAN Number
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txtUannumber" placeholder="Enter UAN Number" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Check If Existing Number Of PF
                                </td>
                                <td>
                                    <input type="checkbox" id="chk_packgechange" name="add_change" value="checked pf number">
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    KYC Identity<span style="color: red;">*</span>
                                </td>
                                <td>
                                    <select id="ddlidentity" class="form-control">
                                        <option>Yes</option>
                                        <option>No</option>
                                    </select>
                                </td>
                                <td>
                                    ESI Number
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="txestnumber" placeholder="Enter ESI Number" />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    EPF Excess Contribution
                                </td>
                                <td>
                                    <select id="ddlepf" class="form-control">
                                        <option value="YES">YES</option>
                                        <option value="NO">NO</option>
                                    </select>
                                </td>
                                <td style="height: 40px;">
                                    EPF Excess Contribution
                                </td>
                                <td>
                                    <select id="ddleps" class="form-control">
                                        <option value="YES">YES</option>
                                        <option value="NO">NO</option>
                                    </select>
                                </td>
                            </tr>
                            <%--<tr>
                                <td>
                                </td>
                                <td style="height: 40px;">
                                    <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                        onclick="for_save_edit_emppfdetails();">
                                    <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                       >
                                </td>
                            </tr>--%>
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
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="for_save_edit_emppfdetails()"></span><span id="btn_save" onclick="for_save_edit_emppfdetails()">Save</span>
                            </div>
                            </div>
                            </td>
                            <td style="width:10px;"></td>
                            <td>
                                <div class="input-group">
                                <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id="btn_close1" ></span><span id="btn_close" >Close</span>
                            </div>
                            </div>
                            </td>
                            </tr>
                            </table>
                    </div>
                   <%-- <div  id="div_Griddata">--%>
                    <br />
                        <div id="div_Deptdata">
                        </div>
                   <%-- </div>--%>
                </div>
            </div>
            </div>
    </section>
</asp:Content>
