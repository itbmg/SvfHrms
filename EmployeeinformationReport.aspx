<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="EmployeeinformationReport.aspx.cs" Inherits="EmployeeinformationReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css?v=3002" rel="stylesheet" type="text/css" />
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
    $(function () {
        get_Branch();
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
    function get_Branch() {
        var data = { 'op': 'get_Branch_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillbranchnames(msg);
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
    function fillbranchnames(msg) {
        var data = document.getElementById('slct_location');
        var length = data.options.length;
        document.getElementById('slct_location').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "All";
        opt.value = "All";
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

    function get_emp_names() {
        var emptype = document.getElementById('slct_emptype').value;
        if (emptype == "All") {
            $('#emp_row').css('display', 'none');
        }
        else {
            get_emp_name_list();
            $('#emp_row').css('display', 'block');
        }
    }
    function get_emp_name_list() {
        var data = { 'op': 'get_Employeedetails' };
        var s = function (msg) {
            if (msg) {
                employeedetails = msg;
                var empnameList = [];
                for (var i = 0; i < msg.length; i++) {
                    var empname = msg[i].empname;
                    empnameList.push(empname);
                }
                $('#selct_employe1').autocomplete({
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
//        var empname = document.getElementById('selct_employe').value;
        var empname = document.getElementById('selct_employe1').value;
        for (var i = 0; i < employeedetails.length; i++) {
            if (empname == employeedetails[i].empname) {
                document.getElementById('selct_employe').value = employeedetails[i].empsno;
            }
        }
        }
        
    
    function get_Employee_information() {
        var type = document.getElementById('slct_type').value;
        var empfilter = document.getElementById('slct_empfilter').value;
        var emptype = document.getElementById('slct_emptype').value;
        var location = document.getElementById('slct_location').value;
        var empname = document.getElementById('selct_employe').value;
        var data = { 'op': 'get_Employee_information', 'type': type, 'empfilter': empfilter, 'emptype': emptype, 'empname': empname, 'location': location };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillinfodetails(msg);
                    $('#divPrint').css('display', 'block');
                    $('#div_empinform').css('display', 'block');
                    $('#printbtn').css('display', 'block');
                    
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
    var totalemployeeinform = [];
    var totalfamildetailes = [];
    var totalbankdetailes = [];
    var totalqulifactiondetailes = [];
    var totalpfdetailes = [];
    function fillinfodetails(msg) {
//        document.getElementById('lblTitle').innerHTML = msg[0].title;
//        document.getElementById('lblAddress').innerHTML = msg[0].titleaddress;
        var type = document.getElementById('slct_type').value;
        totalemployeeinform = msg[0].emplinform;
        totalfamildetailes = msg[0].empfamdet;
        totalbankdetailes = msg[0].empbankdet;
        totalqulifactiondetailes = msg[0].empqualification;
        totalpfdetailes = msg[0].emppfdet;
        var k = 1;
        var l = 0;
        var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
        if (type == "Employee Details") {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + totalemployeeinform[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + totalemployeeinform[0].titleaddress + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + totalemployeeinform[0].branchname + '' + " Employee Information Report" + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">	Employee ID</th><th scope="col">Employee Code</th><th scope="col">Name</th><th scope="col">Employee Status</th><th scope="col">Employee Type</th><th scope="col">Department</th><th scope="col">Designation</th><th scope="col">Join Date</th><th scope="col">Birthday Date</th><th scope="col">EmailId</th><th scope="col">PHno</th><th scope="col">Address</th></tr></thead></tbody>';
            for (var i = 0; i < totalemployeeinform.length; i++) {
                document.getElementById('lblTitle').innerHTML = totalemployeeinform[0].title;
                document.getElementById('lblAddress').innerHTML = totalemployeeinform[0].titleaddress;
                document.getElementById('lblHeading').innerHTML = totalemployeeinform[0].branchname + ' ' + type;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<td scope="row" class="9">' + totalemployeeinform[i].branchname + '</td>';
                results += '<th scope="row" class="1">' + totalemployeeinform[i].empid + '</th>';
                results += '<th scope="row" class="2">' + totalemployeeinform[i].empcode + '</th>';
                results += '<th scope="row" class="3">' + totalemployeeinform[i].Name + '</th>';
                results += '<td scope="row" class="4">' + totalemployeeinform[i].status + '</td>';
                results += '<td scope="row" class="5">' + totalemployeeinform[i].emptype + '</td>';
                results += '<td scope="row" class="5">' + totalemployeeinform[i].dept + '</td>';
                results += '<td scope="row" class="6">' + totalemployeeinform[i].desig + '</td>';
                results += '<td  scope="row" class="8">' + totalemployeeinform[i].joindate + '</td>';
                results += '<td scope="row" class="9">' + totalemployeeinform[i].birthdate + '</td>';
                results += '<td scope="row" class="9">' + totalemployeeinform[i].email + '</td>';
                results += '<td scope="row" class="9">' + totalemployeeinform[i].phoneno + '</td>';
                results += '<td scope="row" class="9">' + totalemployeeinform[i].address + '</td></tr>';
                //results += '<td scope="row" class="9">' + msg[i].titleaddress + '</td>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        else if (type == "Bank Details") {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + totalbankdetailes[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + totalbankdetailes[0].titleaddress + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + totalbankdetailes[0].branchname + ' ' + type + " Report" + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">Employee Code</th><th scope="col">EmployeeName</th><th scope="col">Bank Name</th><th scope="col">Account Number</th><th scope="col">Ifsc Code</th><th scope="col">Payment Mode</th></tr></thead></tbody>';
            for (var i = 0; i < totalbankdetailes.length; i++) {
                document.getElementById('lblTitle').innerHTML = totalbankdetailes[0].title;
                document.getElementById('lblAddress').innerHTML = totalbankdetailes[0].titleaddress;
                document.getElementById('lblHeading').innerHTML = totalbankdetailes[0].branchname + ' '  + type;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<td  class="8">' + totalbankdetailes[i].branchname + '</td>'
                results += '<th scope="row" class="1">' + totalbankdetailes[i].empcode + '</th>';
                results += '<th scope="row" class="2">' + totalbankdetailes[i].Name + '</th>';
                results += '<th scope="row" class="3">' + totalbankdetailes[i].bankname + '</th>';
                results += '<td scope="row" class="4">' + totalbankdetailes[i].accountno + '</td>';
                results += '<td scope="row" class="5">' + totalbankdetailes[i].ifsccode + '</td>';
                results += '<td scope="row" class="6">' + totalbankdetailes[i].paymenttype + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        else if (type == "Family Details") {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + totalfamildetailes[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + totalfamildetailes[0].titleaddress + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + totalfamildetailes[0].branchname + ' ' + type + " Report" + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">EmployeeNumber</th><th scope="col">EmployeeName</th><th scope="col">Joined On</th><th scope="col">Member Name</th><th scope="col">Relation</th><th scope="col">Date Of Birth</th><th scope="col">Gender</th><th scope="col">Bloodgroup</th><th scope="col">Nationality</th><th scope="col">Profession</th></tr></thead></tbody>';
            for (var i = 0; i < totalfamildetailes.length; i++) {
                document.getElementById('lblTitle').innerHTML = totalfamildetailes[0].title;
                document.getElementById('lblAddress').innerHTML = totalfamildetailes[0].titleaddress;
                document.getElementById('lblHeading').innerHTML = totalfamildetailes[0].branchname + ' ' + type;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<td scope="row" class="8">' + totalfamildetailes[i].branchname + '</td>';
                results += '<th scope="row" class="1">' + totalfamildetailes[i].empcode + '</th>';
                results += '<th scope="row" class="2">' + totalfamildetailes[i].Name + '</th>';
                results += '<th scope="row" class="3">' + totalfamildetailes[i].joindate + '</th>';
                results += '<td scope="row" class="4">' + totalfamildetailes[i].relationname + '</td>';
                results += '<td scope="row" class="5">' + totalfamildetailes[i].relation + '</td>';
                results += '<td scope="row" class="6">' + totalfamildetailes[i].dob + '</td>';
                results += '<td scope="row" class="7">' + totalfamildetailes[i].gender + '</td>';
                results += '<td scope="row" class="9">' + totalfamildetailes[i].bloodgroup + '</td>';
                results += '<td scope="row" class="7">' + totalfamildetailes[i].nationality + '</td>';
                results += '<td scope="row" class="9">' + totalfamildetailes[i].profession + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        else if (type == "Qualification Details") {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + totalqulifactiondetailes[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + totalqulifactiondetailes[0].titleaddress + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + totalqulifactiondetailes[0].branchname + ' ' + type + " Report" + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">EmployeeNumber</th><th scope="col">EmployeeName</th><th scope="col">Qualification</th><th scope="col">Institute</th><th scope="col">University</th><th scope="col">Duration Of Course</th><th scope="col">Grade</th></tr></thead></tbody>';
            for (var i = 0; i < totalqulifactiondetailes.length; i++) {
                document.getElementById('lblTitle').innerHTML = totalqulifactiondetailes[0].title;
                document.getElementById('lblAddress').innerHTML = totalqulifactiondetailes[0].titleaddress;
                document.getElementById('lblHeading').innerHTML = totalqulifactiondetailes[0].branchname + ' ' + type;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<td scope="row" class="1">' + totalqulifactiondetailes[i].branchname + '</td>';
                results += '<td scope="row" class="1">' + totalqulifactiondetailes[i].empcode + '</td>';
                results += '<td scope="row" class="2">' + totalqulifactiondetailes[i].Name + '</td>';
                results += '<td scope="row" class="3">' + totalqulifactiondetailes[i].qualification + '</td>';
                results += '<td scope="row" class="5">' + totalqulifactiondetailes[i].institute + '</td>';
                results += '<td scope="row" class="4">' + totalqulifactiondetailes[i].university + '</td>';
                results += '<td scope="row" class="6">' + totalqulifactiondetailes[i].courseduration + '</td>';
                results += '<td scope="row" class="7">' + totalqulifactiondetailes[i].grades + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        else if (type == "PF Details") {
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 20px;font-weight: bold;">' + totalpfdetailes[0].title + '</th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 12px;font-weight: bold;">' + totalpfdetailes[0].titleaddress + ' </th></tr></thead></tbody>';
//            results += '<thead><tr><th scope="col" colspan="10" style="padding-left: 20%;color: #0252AA;font-size: 18px;font-weight: bold;">' + totalpfdetailes[0].branchname +  ' ' + type + " Report" + '</th></tr></thead></tbody>';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th><th scope="col">EmployeeNumber</th><th scope="col">EmployeeName</th><th scope="col">PF Eligible</th><th scope="col">PF Number</th><th scope="col">Uan Number</th><th scope="col">Esi Number</th></tr></thead></tbody>';
            for (var i = 0; i < totalpfdetailes.length; i++) {
                document.getElementById('lblTitle').innerHTML = totalpfdetailes[0].title;
                document.getElementById('lblAddress').innerHTML = totalpfdetailes[0].titleaddress;
                document.getElementById('lblHeading').innerHTML = totalpfdetailes[0].branchname + ' ' + type;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>'
                results += '<td scope="row" class="7">' + totalpfdetailes[i].branchname + '</td>';
                results += '<th scope="row" class="1">' + totalpfdetailes[i].empcode + '</th>';
                results += '<th scope="row" class="2">' + totalpfdetailes[i].Name + '</th>';
                results += '<th scope="row" class="3">' + totalpfdetailes[i].pfeligible + '</th>';
                results += '<td scope="row" class="4">' + totalpfdetailes[i].pfnumber + '</td>';
                results += '<td scope="row" class="5">' + totalpfdetailes[i].uannumber + '</td>';
                results += '<td scope="row" class="6">' + totalpfdetailes[i].estnumber + '</td></tr>';
                //results += '<td scope="row" class="9">' + msg[i].cutoff + '</td>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
        }
        results += '</table></div>';
        $("#div_empinform").html(results);
    }
    var tableToExcel = (function () {
        var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
        return function (table, name) {
            if (!table.nodeType) table = document.getElementById(table)
            var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
            window.location.href = uri + base64(format(template, ctx))
        }
    })()
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<section class="content-header">
        <h1>
       Employee Information Report
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Reports</a></li>
            <li><a href="#">  Employee Information Report</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i> Employee Information Report
                </h3>
            </div>
            <div class="box-body" style="font-size:12px;">
             <div id="div_empinfor">
                   <div id='fillform' >
                      <table>
                            <tr>
                            <td>
                                <td>
                                    <label>
                                       Location</label>
                                    <select id="slct_location" class="form-control"></select>
                               </td>
                               <td>
                                    <label>
                                      Type</label>
                                    <select id="slct_type" class="form-control">
                                    <option value="Employee Details">Employee Details</option>
                                    <option value="Bank Details">Bank Details</option>
                                    <option value="Family Details">Family Details</option>
                                    <option value="Qualification Details">Qualification Details</option>
                                    <option value="PF Details">PF Details</option>
                                    </select>
                               </td>
                               <td>
                                    <label>
                                      Employee Filter</label>
                                <select id="slct_empfilter" class="form-control">
                                <option value="Current Employees">Current Employees</option>
                                <option value="Resigned Employees">Resigned Employees</option>
                                </select>
                               </td>
                                <td>
                                    <label>
                                      Employee Type</label>
                                    <select id="slct_emptype" class="form-control" onchange="get_emp_names()">
                                    <option value="All">All</option>
                                <option value="Employee Wise">Employee Wise</option>
                                    </select>
                               </td>
                               <td id="emp_row" style="display:none">
                                    <label>
                                      Employee Name</label>
                                    <input type="text" class="form-control" id="selct_employe1" placeholder="Enter employee name" />
                                    <input type="hidden" class="form-control" id="selct_employe" name="hiddenempid"  / >
                               </td>
                               <td style="padding-left: 2%;padding-top: 3%;">
                              <input id="btn_monthjoin" type="button" class="btn btn-primary" name="Generate" value='Generate' onclick="get_Employee_information()" />
                            </td> 
                             </tr>
                              <tr style="display:none;">
                              <td>
                            <label id="lbl_joinsno"></label>
                            </td>
                            </tr>
                           </table>
                        </div>
                        </div>
                        </div>
                            <div id="divPrint" style="display:none">
                             <div align="center" style="color:#0252AA;font-size:20px;font-weight:bold;">
                                 
                                    <label id="lblTitle"  Font-Bold="true" Font-Size="20px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                <label id="lblAddress"  Font-Bold="true" Font-Size="12px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                <br />
                                                 <label id="lblHeading"  Font-Bold="true" Font-Size="15px" ForeColor="#0252aa" style="color:#0252AA !important;font-size:16px!important;font-weight: bold!important";
                                                    ></label>
                                                    <br />
                                                    </div>
                                                    <div id ="div_empinform"></div>
                                        <table style="width: 100%;">
                                        <tr>
                                        </tr>
                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Prepared By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Audit By</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">A.O</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">GM</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 15px;">Director</span>
                                                </td>
                                            </tr>
                                        </table>
                                        </div>
                                          <br />
                                          <div align="center" id="printbtn" style="display:none">
                                        <table>
                                        <tr>
                                        <td>
                                         <button type="button" id="Button2" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                         <td style="width: 10px">
                                        <td>
                                        <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('div_empinform', 'W3C Example Table')"
                                        value="Export to Excel" />
                                        </td>
                                        </tr>
                                        </table>
                                  
                                    
                                         </div>
</div>
    </section>

</asp:Content>

