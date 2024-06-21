<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="payslipdwld.aspx.cs" Inherits="payslipdwld" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
        
    </script>
    <script type="text/javascript">
        function exportfn() {
            window.location = "exporttoxl.aspx";
        }

        $(function () {
            get_Employeedetails();
            get_Branch_details();
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
        function sendmailldclick() {
            var email;
            var img_url;
            //var cellphone;
            //var mailid = "email";
            //var mailid = ID.value;
            //var mailid = document.getElementById("ak").innerHTML;
            var data = { 'op': 'sendmailldclick', 'email': email };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        alert(msg);
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        var employeedetails = [];
        var employee_data = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    employee_data = msg;
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
                    get_salary_fill_Details();
                }
            }
        }

        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                        //fillbranchname(msg);
                    }
                    else {
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch(msg) {
            var data = document.getElementById('ddlbranch');
            var length = data.options.length;
            document.getElementById('ddlbranch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branchname";
            //opt.value = "Select Branchname";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].branchid;
                    data.appendChild(option);
                }
            }
        }
        function get_salary_fill_Details() {
            var empid = document.getElementById('txtsupid').value;
            var noofmonths = document.getElementById('ddlmonths').value;
            var data = { 'op': 'get_paysalary_Details', 'empid': empid, 'noofmonths': noofmonths };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        emplochenage(msg);
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
        function emplochenage(msg) {
            for (var i = 0; i < msg.length; i++) {
                document.getElementById('txtEmployeeCode').innerHTML = msg[i].employeid;
                document.getElementById('Spnemployeename').innerHTML = msg[i].empname;
                document.getElementById('Spnmonth').innerHTML = msg[i].MonthName;
                document.getElementById('Spnnoofdays').innerHTML = msg[i].daysinmonth;
                document.getElementById('Spndayspaid').innerHTML = msg[i].noofdayspaid;
                document.getElementById('Spnlop').innerHTML = msg[i].lop;
                document.getElementById('txtmonthsal').value = msg[i].monthsal;
                document.getElementById('txtyear').value = msg[i].year;
                document.getElementById('txtcnten').value = msg[i].canteendeduction;
                document.getElementById('spnot').innerHTML = msg[i].otdays;
                document.getElementById('Spnnoofworkingdays').innerHTML = msg[i].noofworkingdays;
            }
            totalchange(msg);
        }

        function totalchange(msg) {
            var employeid = document.getElementById('txtsupid').value;
            var noofdays = document.getElementById('Spnnoofdays').innerHTML;
            var lop = document.getElementById('Spnlop').innerHTML;
            var monthsal = document.getElementById('txtmonthsal').value;
            var empname = document.getElementById('Spnemployeename').innerHTML;
            var monthname = document.getElementById('Spnmonth').innerHTML;
            var noofdayspaid = document.getElementById('Spndayspaid').innerHTML;
            var year = document.getElementById('txtyear').value;
            var empcode = document.getElementById('txtEmployeeCode').innerHTML;
            var ot = document.getElementById('spnot').innerHTML;
            var cantin = document.getElementById('txtcnten').value;
            var salarymode = "";
            var pfno = "";
            var esino = "";
            for (var i = 0; i < msg.length; i++) {
                if (employeid == msg[i].empsno) {
                    salarymode = msg[i].salarymode;
                    pfno = msg[i].pfeligible;
                    esino = msg[i].esieligible;
                    var Fixed = 0;
                    var Percentage = 0;
                    if (salarymode == Percentage) {
                        if (lop == "0") {
                            var salary = monthsal;
                            var perdayamount = salary / noofdays;
                            var lossofamount = lop * perdayamount;
                            var totalsal = salary - lossofamount;
                            var otvalue = ot * perdayamount;
                            var sal = 50;
                            var grossbasic = (parseFloat(salary) * parseFloat(sal)) / 100;
                            erbasic = (parseFloat(totalsal) * parseFloat(sal)) / 100;
                            if (pfno == "No") {
                                providentfound = 0;
                            }
                            else {
                                var pf = 12;
                                providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                            }
                            if (esino == "No") {
                                esi = 0;
                            }
                            else {
                                var esiper = 1.75;
                                esi = (parseFloat(totalsal) * parseFloat(esiper)) / 100;
                            }
                            var cantendeductin = cantin;
                            var incometax = 0;
                            var medical = 1250;
                            var grossmedicalallavance = 1250;
                            var conveyance = 1600;
                            var grossconveyanceallavance = conveyance;
                            var washing = 1000;
                            var grosswashingallowance = washing;
                            var tot = 0;
                            tot = parseInt(medical) + parseInt(conveyance) + parseInt(washing) + parseInt(erbasic);
                            var ghtotal = parseInt(grossbasic) + parseInt(grossconveyanceallavance) + parseInt(grosswashingallowance) + parseInt(grossmedicalallavance);
                            var grosshra = parseInt(salary) - parseInt(ghtotal);
                            var hre = 0;
                            hre = parseInt(totalsal) - parseInt(tot);
                            if (hre > 0) {
                            }
                            else {
                                var hre = "0";
                            }
                            var professionaltax = 0;
                            var employeid = document.getElementById('txtsupid').value;
                            var statename = "";
                            for (var i = 0; i < msg.length; i++) {
                                if (employeid == msg[i].empsno) {
                                    statename = msg[i].state;
                                    if (statename == "AndraPrdesh") {
                                        if (salary > 1000 && salary <= 15000) {
                                            professionaltax = "0";
                                        }
                                        else if (salary >= 15001 && salary <= 20000) {
                                            professionaltax = "150";
                                        }
                                        else if (salary >= 20001) {
                                            professionaltax = "200";
                                        }
                                    }
                                    if (statename == "Tamilnadu") {
                                        if (salary < 700) {
                                            professionaltax = "0";
                                        }
                                        else if (salary >= 7001 && salary <= 1000) {
                                            professionaltax = "115";
                                        }
                                        else if (salary >= 10001 && salary <= 11000) {
                                            professionaltax = "171";
                                        }
                                        else if (salary >= 11001 && salary <= 12000) {
                                            professionaltax = "171";
                                        }
                                        else if (salary >= 12001) {
                                            professionaltax = "208";
                                        }
                                    }
                                    if (statename == "karnataka") {
                                        if (salary <= 15000 && salary <= 15001) {
                                            professionaltax = "0";
                                        }
                                        else if (salary >= 15001) {
                                            professionaltax = "200";
                                        }
                                    }
                                }
                            }
                            var totalernings = tot + hre;
                            var grosstotalernings = ghtotal + grosshra;
                            var totaldeduction = parseFloat(professionaltax) + parseFloat(providentfound) + parseFloat(esi) + parseFloat(cantendeductin) + parseFloat(incometax);
                            var netsal = totalernings - totaldeduction;
                        }
                        else {
                            var salary = monthsal;
                            var perdayamount = salary / noofdays;
                            var lossofamount = lop * perdayamount;
                            var totalsal = salary - lossofamount;
                            var otvalue = ot * perdayamount;
                            var sal = 50;
                            var grossbasic = (parseFloat(salary) * parseFloat(sal)) / 100;
                            erbasic = (parseFloat(totalsal) * parseFloat(sal)) / 100;
                            if (pfno == "No") {
                                providentfound = 0;
                            }
                            else {
                                var pf = 12;
                                providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                            }

                            if (esino == "No") {
                                esi = 0;
                            }
                            else {
                                var esif = 1.75;
                                esi = (parseFloat(totalsal) * parseFloat(esif)) / 100;
                            }
                            var cantendeductin = cantin;
                            var incometax = 0;

                            var medical = 1250;
                            var perdaymedical = 1250 / noofdays;
                            var lossofmedical = lop * perdaymedical;
                            var medicalallavance = medical - lossofmedical;
                            var grossmedicalallavance = 1250;

                            var conveyance = 1600;
                            var perdayconveyance = 1600 / noofdays;
                            var lossofconveyance = lop * perdayconveyance;
                            var conveyanceallavance = conveyance - lossofconveyance;
                            var grossconveyanceallavance = 1600;

                            var washing = 1000;
                            var perdaywashing = 1000 / noofdays;
                            var lossofwashing = lop * perdaywashing;
                            var washingallowance = washing - lossofwashing;
                            var grosswashingallowance = 1000;
                            var tot = 0;
                            tot = parseInt(medicalallavance) + parseInt(conveyanceallavance) + parseInt(washingallowance) + parseInt(erbasic);
                            var ghtotal = parseInt(grossbasic) + parseInt(grossconveyanceallavance) + parseInt(grosswashingallowance) + parseInt(grossmedicalallavance);
                            var grosshra = parseInt(salary) - parseInt(ghtotal);
                            var hre = 0;
                            hre = parseInt(totalsal) - parseInt(tot);
                            if (hre > 0) {
                            }
                            else {
                                var hre = "0";
                            }
                            var professionaltax = 0;
                            var employeid = document.getElementById('txtsupid').value;
                            var statename = "";
                            for (var i = 0; i < msg.length; i++) {
                                if (employeid == msg[i].empsno) {
                                    statename = msg[i].statename;
                                    if (statename == "AndraPrdesh") {
                                        if (salary > 1000 && salary <= 15000) {
                                            professionaltax = "0";
                                        }
                                        else if (salary >= 15001 && salary <= 20000) {
                                            professionaltax = "150";
                                        }
                                        else if (salary >= 20001) {
                                            professionaltax = "200";
                                        }
                                    }
                                    if (statename == "Tamilnadu") {
                                        if (salary < 700) {
                                            professionaltax = "0";
                                        }
                                        else if (salary >= 7001 && salary <= 1000) {
                                            professionaltax = "115";
                                        }
                                        else if (salary >= 10001 && salary <= 11000) {
                                            professionaltax = "171";
                                        }
                                        else if (salary >= 11001 && salary <= 12000) {
                                            professionaltax = "171";
                                        }
                                        else if (salary >= 12001) {
                                            professionaltax = "208";
                                        }
                                    }
                                    if (statename == "karnataka") {
                                        if (salary <= 15000 && salary <= 15001) {
                                            professionaltax = "0";
                                        }
                                        else if (salary >= 15001) {
                                            professionaltax = "200";
                                        }
                                    }
                                }
                            }
                            var totalernings = tot + hre;
                            var grosstotalernings = ghtotal + grosshra;
                            var totaldeduction = parseFloat(professionaltax) + parseFloat(providentfound) + parseFloat(esi) + parseFloat(cantendeductin) + parseFloat(incometax);
                            var netsal = totalernings - totaldeduction;
                        }
                    }
                    else {
                        var salary = monthsal;
                        var perdayamount = salary / noofdays;
                        var otvalue = ot * perdayamount;
                        erbasic = "0";
                        var providentfound = "0";
                        var conveyance = "0";
                        var medical = "0";
                        var washingallowance = "0";
                        var professionaltax = "0";
                        var hre = "0";
                        var esi = "0";
                        var totalotval = salary + otvalue;
                        var cantendeductin = 0;

                    }
                    if (lop == "0") {
                        document.getElementById('<%=txtempcode.ClientID %>').value = empcode;
                        document.getElementById('<%=txtempname.ClientID %>').value = empname;

                        document.getElementById('<%=txtmonth.ClientID %>').value = monthname;
                        document.getElementById('<%=txtnoofdays.ClientID %>').value = noofdays;

                        document.getElementById('<%=txtdayspaid.ClientID %>').value = noofdayspaid;
                        document.getElementById('<%=txtlop.ClientID %>').value = lop;

                        document.getElementById('<%=txtotdays.ClientID %>').value = ot;


                        document.getElementById('<%=txtactbasic.ClientID %>').value = grossbasic;
                        document.getElementById('<%=txtmonthbasic.ClientID %>').value = erbasic;

                        document.getElementById('<%=txtacthra.ClientID %>').value = grosshra;
                        document.getElementById('<%=txtmonthhra.ClientID %>').value = hre;

                        document.getElementById('<%=txtmonthpf.ClientID %>').value = providentfound;
                        // document.getElementById('lblactpf').innerHTML = 0;

                        document.getElementById('<%=txtmonthpt.ClientID %>').value = professionaltax;
                        // document.getElementById('lblactpt').innerHTML = 0;

                        document.getElementById('<%=txtactconveyance.ClientID %>').value = grossconveyanceallavance;
                        document.getElementById('<%=txtmonthconveyance.ClientID %>').value = conveyance;
                        //document.getElementById('lblactesi').innerHTML = esi;
                        document.getElementById('<%=txtmonthesi.ClientID %>').value = esi;

                        document.getElementById('<%=txtactmedicalallowance.ClientID %>').value = grossmedicalallavance;
                        document.getElementById('<%=txtmonthmedicalallowance.ClientID %>').value = medical;

                        // document.getElementById('lblactincometax').innerHTML = incometax;
                        document.getElementById('<%=txtmonthincometax.ClientID %>').value = incometax;

                        document.getElementById('<%=txtactwashingallowance.ClientID %>').value = grosswashingallowance;
                        document.getElementById('<%=txtmonthwashingallowance.ClientID %>').value = washing;

                        //document.getElementById('lblactcanteen').innerHTML = cantendeductin;
                        document.getElementById('<%=txtmonthcanteendeduction.ClientID %>').value = cantendeductin;

                        document.getElementById('<%=txtActTotalEarnings.ClientID %>').value = grosstotalernings;
                        document.getElementById('<%=txtMonthTotalEarnings.ClientID %>').value = totalernings;

                        // document.getElementById('lblacttotaldeduction').innerHTML = 0;
                        document.getElementById('<%=txtMonthTotalDeductions.ClientID %>').value = Math.round(totaldeduction);
                        var totalnetpay = totalernings - totaldeduction;
                        document.getElementById('<%=txtNetPayAmount.ClientID %>').value = Math.round(totalnetpay);
                    }
                    else {
                        document.getElementById('<%=txtempcode.ClientID %>').value = empcode;
                        document.getElementById('<%=txtempname.ClientID %>').value = empname;

                        document.getElementById('<%=txtmonth.ClientID %>').value = monthname;
                        document.getElementById('<%=txtnoofdays.ClientID %>').value = noofdays;

                        document.getElementById('<%=txtdayspaid.ClientID %>').value = noofdayspaid;
                        document.getElementById('<%=txtlop.ClientID %>').value = lop;

                        document.getElementById('<%=txtotdays.ClientID %>').value = ot;
                        document.getElementById('<%=txtactbasic.ClientID %>').value = grossbasic;
                        document.getElementById('<%=txtmonthbasic.ClientID %>').value = erbasic;

                        document.getElementById('<%=txtacthra.ClientID %>').value = grosshra;
                        document.getElementById('<%=txtmonthhra.ClientID %>').value = hre;

                        document.getElementById('<%=txtmonthpf.ClientID %>').value = providentfound;
                        // document.getElementById('lblactpf').innerHTML = 0;

                        document.getElementById('<%=txtmonthpt.ClientID %>').value = professionaltax;
                        // document.getElementById('lblactpt').innerHTML = 0;

                        document.getElementById('<%=txtactconveyance.ClientID %>').value = grossconveyanceallavance;
                        document.getElementById('<%=txtmonthconveyance.ClientID %>').value = conveyance;
                        //document.getElementById('lblactesi').innerHTML = esi;
                        document.getElementById('<%=txtmonthesi.ClientID %>').value = esi;

                        document.getElementById('<%=txtactmedicalallowance.ClientID %>').value = grossmedicalallavance;
                        document.getElementById('<%=txtmonthmedicalallowance.ClientID %>').value = medical;

                        // document.getElementById('lblactincometax').innerHTML = incometax;
                        document.getElementById('<%=txtmonthincometax.ClientID %>').value = incometax;

                        document.getElementById('<%=txtactwashingallowance.ClientID %>').value = grosswashingallowance;
                        document.getElementById('<%=txtmonthwashingallowance.ClientID %>').value = washing;

                        //document.getElementById('lblactcanteen').innerHTML = cantendeductin;
                        document.getElementById('<%=txtmonthcanteendeduction.ClientID %>').value = cantendeductin;

                        document.getElementById('<%=txtActTotalEarnings.ClientID %>').value = grosstotalernings;
                        document.getElementById('<%=txtMonthTotalEarnings.ClientID %>').value = totalernings;

                        // document.getElementById('lblacttotaldeduction').innerHTML = 0;
                        document.getElementById('<%=txtMonthTotalDeductions.ClientID %>').value = Math.round(totaldeduction);
                        var totalnetpay = totalernings - totaldeduction;
                        document.getElementById('<%=txtNetPayAmount.ClientID %>').value = Math.round(totalnetpay);
                    }
                }
            }
        }


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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Payslip Generation<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Generation Management</a></li>
            <li><a href="#">Payslip</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Payslip Generation
                </h3>
            </div>
            <table id="tbl_leavemanagement" align="center">
                <tr>
                <td style="height: 40px;">
                        Branch Name<span style="color: red;">*</span>
                    </td>
                    <td>
                        <select class="form-control" id="ddlbranch">
                            <option selected disabled value="Select Branch">Select Branch</option>
                        </select>
                    </td>
                    <td style="height: 40px;">
                        Employe Name<span style="color: red;">*</span>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" />
                    </td>
                    <td style="height: 40px; display: none">
                        <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                    <td style="width: 5px;">
                        <input id="txtmonthsal" type="hidden" class="form-control" name="hiddenemployeid" />
                    </td>
                    <td>
                        Month
                    </td>
                    <td>
                        <select id="ddlmonths" class="form-control">
                            <option value="1">Month</option>
                            <option value="3">Last 3 Months</option>
                            <option value="6">Last 6 Months</option>
                        </select>
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td>
                        <asp:Button ID="btnemp" runat="server" CssClass="btn btn-primary" Text="Generate"
                            OnClick="btn_employee_click" />
                    </td>
                    <td>
                     <input id="Btnsend" type="button" class="btn btn-primary" name="Send" value='Send'
                                    onclick="sendmailldclick()" />
                    </td>
                </tr>
            </table>
            <div class="box-body" style="display: none;">
                <table id="Table1" runat="server" class="tablecenter" width="98%">
                    <tr>
                        <td style="height: 40px;">
                            <label>
                                Employee Code:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="txtEmployeeCode" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                Employee Name:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnemployeename" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                For Month:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnmonth" style="color: Red;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <label>
                                No. of Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnnoofdays" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                Effective Working Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnnoofworkingdays" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                Days paid:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spndayspaid" style="color: Red;" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <label>
                                LOP:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="Spnlop" style="color: Red;" />
                        </td>
                        <td style="height: 40px;">
                            <label>
                                OT Days:</label>
                        </td>
                        <td style="width: 6px;">
                        </td>
                        <td style="width: 200px;">
                            <span id="spnot" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtyear" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtcnten" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="Span4" style="color: Red;" />
                        </td>
                    </tr>
                </table>
                <table id="Table2" style="display: none;" runat="server" class="tablecenter" width="98%">
                    <tr>
                        <td style="width: 200px;">
                            <asp:TextBox ID="txtempcode" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtempname" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtmonth" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtnoofdays" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txteffectiveworkdays" runat="server"></asp:TextBox>
                        </td>
                        <td style="width: 200px;">
                            <asp:TextBox ID="txtdayspaid" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtlop" runat="server"></asp:TextBox>
                        </td>
                        <td style="height: 40px;">
                            <asp:TextBox ID="txtotdays" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <table id="tblDetails" style="display: none;" runat="server" class="tablecenter"
                width="100%">
                <tr>
                    <td>
                        <fieldset id="Fieldset1" class="fieldset_dashed" runat="server">
                            <legend class="legend_right" align="right">
                                <asp:Label ID="lblPayrollProcessDetails" runat="server" Text="Payroll Process Details"></asp:Label>
                            </legend>
                            <table class="tablecenter" width="95%">
                                <tr>
                                    <td colspan="4" style="padding-top: 25px">
                                        <table width="100%" style="border: 1Px Solid Black;">
                                            <tr>
                                                <td colspan="3" valign="middle" align="center" style="border-style: none solid solid none;
                                                    border-width: 1px; border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblEarnings" Text="Earnings" runat="server" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td colspan="3" valign="middle" align="center" style="border-bottom: 1px solid Black;
                                                    height: 30px;">
                                                    <asp:Label ID="lblDeductions" Text="Deductions" runat="server" Font-Bold="true"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; width: 160px; height: 30px;">
                                                    <asp:Label ID="lblParticularE" runat="server" Text="Particular" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; width: 120px;">
                                                    <asp:Label ID="lblGrossEarnings" runat="server" Text="Gross Earnings (Rs.)" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblEarningsForMonth" runat="server" Text="Earnings For Month (Rs.)"
                                                        Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; width: 120px;">
                                                    <asp:Label ID="lblParticularD" runat="server" Text="Particular" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center" style="border-bottom: 1px solid Black;">
                                                    <asp:Label ID="lblDeductionsForMonth" runat="server" Text="Deductions For Month (Rs.)"
                                                        Font-Bold="true"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblBasic" runat="server" Text="Basic" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactbasic" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthbasic" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblPF" runat="server" Text="Provident Fund" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthpf" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblHRA" runat="server" Text="House Rent Allowence" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtacthra" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthhra" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblPT" runat="server" Text="Professional Tax" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthpt" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblConveyance" runat="server" Text="Conveyance" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactconveyance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthconveyance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblESI" runat="server" Text="ESI" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthesi" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblSplConveyance" runat="server" Text="Medical Allowance" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactmedicalallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthmedicalallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblIncomeTax" runat="server" Text="Income Tax" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthincometax" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black; height: 30px;">
                                                    <asp:Label ID="lblwash" runat="server" Text="Washing Allowance" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtactwashingallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:TextBox ID="txtmonthwashingallowance" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                                    border-color: Black;">
                                                    <asp:Label ID="lblcanteen" runat="server" Text="Canteen Deduction" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-bottom: 1px solid Black;">
                                                    <asp:TextBox ID="txtmonthcanteendeduction" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="left" style="border-right: 1px solid Black; height: 30px;">
                                                    <asp:Label ID="lblTotalE" runat="server" Text="Total" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="border-right: 1px solid Black;">
                                                    <asp:TextBox ID="txtActTotalEarnings" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" align="left" style="border-right: 1px solid Black;">
                                                    <asp:TextBox ID="txtMonthTotalEarnings" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                                <td valign="middle" style="border-right: 1px solid Black;">
                                                    <asp:Label ID="lblTotalD" runat="server" Text="Total" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td valign="middle" align="left" style="">
                                                    <asp:TextBox ID="txtMonthTotalDeductions" runat="server" Font-Bold="true"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" align="center" style="padding-top: 15px">
                                        <asp:Label ID="Label7" runat="server" Text="Net Pay: " Font-Bold="true"></asp:Label>
                                        <asp:TextBox ID="txtNetPayAmount" runat="server" Font-Bold="true"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </div>
    </section>
</asp:Content>
