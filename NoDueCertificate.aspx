<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="NoDueCertificate.aspx.cs" Inherits="NoDueCertificate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link href="css/fieldset.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript">
     function CallPrint(strid) {
         var divToPrint = document.getElementById(strid);
         var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
         newWin.document.open();
         newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
         newWin.document.close();
     }
        
    </script>
  <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript">
     $(function () {
         get_Dept_details();
         get_Appraisals_fill_Details();
//         get_Desgnation_details();
         get_Employeedetails();
//         get_paystructured_details();
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


     function validateEmail(email) {
         var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
         if (reg.test(email)) {
             return true;
         }
         else {
             return false;
         }
     }



     function get_Dept_details() {
         var data = { 'op': 'get_Dept_details' };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     filldepdetails(msg);
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
     function filldepdetails(msg) {
         var data = document.getElementById('selct_department');
         var length = data.options.length;
         document.getElementById('selct_department').options.length = null;
         var opt = document.createElement('option');
         opt.innerHTML = "Select Department";
         opt.value = "Select deptid";
         opt.setAttribute("selected", "selected");
         opt.setAttribute("disabled", "disabled");
         opt.setAttribute("class", "dispalynone");
         data.appendChild(opt);
         for (var i = 0; i < msg.length; i++) {
             if (msg[i].Department != null) {
                 var option = document.createElement('option');
                 option.innerHTML = msg[i].Department;
                 option.value = msg[i].Deptid;
                 data.appendChild(option);
             }
         }
     }
     var employee_data = [];
     var employeedetails = [];
     function get_Employeedetails() {
         //document.getElementById('selct_employe').options.length = null;
         var deptid = document.getElementById('selct_department').value;
         var data = { 'op': 'get_deptwiseemploye_details', 'deptid': deptid };
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
         //alert('hi')
         var empname = document.getElementById('selct_employe').value;
         for (var i = 0; i < employeedetails.length; i++) {
             if (empname == employeedetails[i].empname) {
                 document.getElementById('txtsupid').value = employeedetails[i].empsno;
                 document.getElementById('txtempcode1').value = employeedetails[i].empnum;
                 get_Appraisals_fill_Details();
             }
         }
         var empid = document.getElementById('txtsupid').value;
         var data = { 'op': 'get_employewise_deptdetails', 'empid': empid };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     for (var i = 0; i < msg.length; i++) {
                         document.getElementById('selct_department').value = msg[i].Deptid;
                     }
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

     function get_Appraisals_fill_Details() {
         var empid = document.getElementById('txtsupid').value;
         //var empcode1 = document.getElementById('txtempcode1').value;
         var data = { 'op': 'get_Appraisals_fill_Details', 'empid': empid };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     emplochenage(msg);
                     get_departmentmanagers_fill_Details(msg);
                     //get_Dept_details();
                     // get_paystructured_details();
                     get_branchdepartmentmanagers_fill_Details(msg);
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
     var array = [];
     var array1 = [];
     var array2 = [];
     function emplochenage(msg) {
       array = [];
       array1 = [];
       array2 = [];
         //canceldetails();
         var fullname = document.getElementById('selct_employe').value;
         for (var i = 0; i < msg.length; i++) {
             if (fullname == msg[i].fullname) {
                 document.getElementById('txtEmployeeCode').innerHTML = msg[i].employee_num;
                 document.getElementById('Spnemployeename').innerHTML = msg[i].fullname;
                 document.getElementById('SpanDesigination').innerHTML = msg[i].designation;
                 document.getElementById('Spndepartment').innerHTML = msg[i].department;
                 document.getElementById('Spndoj').innerHTML = msg[i].joindate;
                 document.getElementById('SpnPresentpackage').innerHTML = msg[i].salary;
                 document.getElementById('Spnnetpay').innerHTML = msg[i].netpay;
                 document.getElementById('Spanlocation').innerHTML = msg[i].branchname;
                 // document.getElementById('txt_grosspay').value = msg[i].monthsarl;
//                 document.getElementById('txtChangedpackage').value = msg[i].salary;
                 //document.getElementById('textsalarymode').value = salrdata[i].salarymode;
                 array.push(msg[i].branchname);
                 array1.push(msg[i].department);
                 array2.push(msg[i].designation);
                
             }
         }
     }
     function get_departmentmanagers_fill_Details() {
         var branchid = array[0];
         var dep = array1[0]; 
         //var empcode1 = document.getElementById('txtempcode1').value;
         var data = { 'op': 'get_departmentmanagers_fill_Details', 'dep': dep, 'branchid': branchid };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     emplochenagemanager(msg);
                     //get_Dept_details();
                     // get_paystructured_details();
                 }
                 else {
                     document.getElementById('SpanReportingHead').innerHTML = "SRI RAJESH KUMAR CHAVDA";
                     document.getElementById('Spandesignetion1').innerHTML = "Chairman";

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
     function emplochenagemanager(msg) {
         branchid = array[0];
         dep = array1[0];
         desig = array2[0]; 
         var fullname = document.getElementById('selct_employe').value;
         for (var i = 0; i < msg.length; i++) {
             if (dep == msg[i].department && branchid == msg[i].branchname && desig != "Manager") {
                 document.getElementById('SpanReportingHead').innerHTML = msg[i].fullname;
                 document.getElementById('Spandesignetion1').innerHTML = msg[i].designation;
                 document.getElementById('Spndepartment1').innerHTML = msg[i].department;
             }
             else {
                 document.getElementById('SpanReportingHead').innerHTML = "SRI RAJESH KUMAR CHAVDA";
                 document.getElementById('Spandesignetion1').innerHTML = "Chairman";
//                 document.getElementById('Spndepartment1').innerHTML = msg[i].department;
             }
                 // document.getElementById('txt_grosspay').value = msg[i].monthsarl;
                 //                 document.getElementById('txtChangedpackage').value = msg[i].salary;
                 //document.getElementById('textsalarymode').value = salrdata[i].salarymode;
             
         }
         }
         function get_branchdepartmentmanagers_fill_Details() {
             var branchid = array[0];
             //var empcode1 = document.getElementById('txtempcode1').value;
             var data = { 'op': 'get_branchdepartmentmanagers_fill_Details', 'branchid': branchid };
             var s = function (msg) {
                 if (msg) {
                     if (msg.length > 0) {
                         emplochenagemanagers(msg);
                         //get_Dept_details();
                         // get_paystructured_details();
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
         function emplochenagemanagers(msg) {
             //canceldetails();
             var fullname = document.getElementById('selct_employe').value;
              branchid = array[0];

              for (var i = 0; i < msg.length; i++) {

                 document.getElementById('spantitle').innerHTML = msg[i].Title
                 document.getElementById('spanaddress').innerHTML = msg[i].Address;
                 if (msg[i].department == "Accounts" && branchid == msg[i].branchname) {
                     document.getElementById('Spanaccounts').innerHTML = msg[i].fullname;
                     document.getElementById('Spanaccountsdesignetion').innerHTML = msg[i].designation;
                     document.getElementById('Spndepartmeaccount1').innerHTML = msg[i].department;
                 }
                 else if (msg[i].department == "Finance") {
                     document.getElementById('Spanfinance').innerHTML = msg[i].fullname;
                     document.getElementById('Spanfinancedesignetion').innerHTML = msg[i].designation;
                     document.getElementById('Spndepartafindep').innerHTML = msg[i].department;
                 }
                 else if (msg[i].department == "HR" && branchid == msg[i].branchname) {
                  document.getElementById('Spanhrdepartment').innerHTML = msg[i].fullname;
                     document.getElementById('Spanhrdesignetion').innerHTML = msg[i].designation;
                     document.getElementById('Spanhr').innerHTML = msg[i].fullname;
                     document.getElementById('Spanhrdep').innerHTML = msg[i].department;

                 }
                 else if (msg[i].department == "Administration") {
                     document.getElementById('Spansystemadministration').innerHTML = msg[i].fullname;
                     document.getElementById('Spansystem').innerHTML = msg[i].designation;
                     document.getElementById('Spansystemdep').innerHTML = msg[i].department;

                 }
             }
         }
     function totalchange() {
         var grosspay = document.getElementById('txt_grosspay').value;
         var salpackage = document.getElementById('txtChangedpackage').value;

         var appraisal = document.getElementById('txt_Appraisal').value;

         var erbasic = document.getElementById('txt_ernbasic').value;
         var hre = document.getElementById('txt_HousingRent').value;
         var Medical = document.getElementById('txt_Medical').value;
         var Converance = document.getElementById('txt_Converance').value;
         var washingallowance = document.getElementById('txt_WashingAllowance').value;
         var apprisesalary = 0;
         var apprisesalary = parseFloat(salpackage) + parseFloat(appraisal);
         document.getElementById('txt_grosspay').value = apprisesalary;
         var TotalEarnings = 0;
         TotalEarnings = parseFloat(erbasic) + parseFloat(hre) + parseFloat(Medical) + parseFloat(Converance) + parseFloat(washingallowance);
         document.getElementById('txt_TotalEarnings').value = TotalEarnings;
         var debBasic = document.getElementById('txt_debBasic').value;
         var professinaltax = 0;
         professinaltax = document.getElementById('txt_professinaltax').value;
         var Incometax = 0;
         Incometax = document.getElementById('txt_Incometax').value;
         if (Incometax == "") {
             Incometax = 0;
         }
         Incometax = parseFloat(Incometax);
         var Esi = document.getElementById('txt_Esi').value;
         var canteendeduction = 0;
         canteendeduction = document.getElementById('txt_canteendeduction').value;
         //        canteendeduction = document.getElementById('txt_canteendeduction').value;
         //        if (canteendeduction == "") {
         //            canteendeduction = 0;
         //        }
         //        canteendeduction = parseFloat(canteendeduction);
         var Totaldeduction = 0;
         Totaldeduction = parseFloat(debBasic) + parseFloat(professinaltax) + Incometax + parseFloat(Esi) + parseFloat(canteendeduction);
         document.getElementById('txt_Totaldeduction').value = Totaldeduction;
         var netpay = 0;
         netpay = TotalEarnings - Totaldeduction;
         netpay = parseFloat(TotalEarnings) - parseFloat(Totaldeduction);
         document.getElementById('txt_netsalary').value = netpay;
     }
    
     $(function () {
         $("#chk_add_login").click(function () {
             if ($(this).is(":checked")) {
                 $("#selct_designation").show();
                 $("#change_des").show();
             } else {
                 $("#change_des").hide();
                 $("#selct_designation").hide();

             }
         });
     });
     $(function () {
         $("#chk_packgechange").click(function () {
             if ($(this).is(":checked")) {
                 $("#txtChangedpackage").removeAttr("disabled");
                 $("#txtChangedpackage").focus();
                 $("#txt_grosspay").removeAttr("disabled");
                 $("#txt_grosspay").focus();

             } else {
                 $("#txtChangedpackage").attr("disabled", "disabled");
                 $("#txt_grosspay").attr("disabled", "disabled");
             }
         });
     });

     

     


    


     


     var compiledList = [];
     function filldata(msg) {
         //var compiledList = [];
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
    


     var compiledList1 = [];
     function filldata1(msg) {
         for (var i = 0; i < msg.length; i++) {
             var empcode1 = msg[i].empcode1;
             compiledList1.push(empcode1);
         }
         $('#txtempCode').autocomplete({
             source: compiledList1,
             change: empnamecode,
             autoFocus: true
         });
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




     function savenoduecertificetreamrks() {
         var employeename = document.getElementById('selct_employe').value;
         var employeecode = document.getElementById('txtEmployeeCode').innerHTML;
         var department = document.getElementById('Spndepartment').innerHTML;
         var location = document.getElementById('Spanlocation').innerHTML;
         var lastworkingdaydate = document.getElementById('txtlastdate').value;
         var Reportinghead = document.getElementById('SpanReportingHead').innerHTML;
         var Reportingheadremarks = document.getElementById('txtrepoheadremarks').value;
         var Accountsdepartment = document.getElementById('Spanaccounts').innerHTML;
         var accountsdepremarks = document.getElementById('txtaccountremarks').value;
         var Financedepartment = document.getElementById('Spanfinance').innerHTML;
         var Financedepremarks = document.getElementById('txtfinanceremarks').value;
         var systemadmin = document.getElementById('Spansystemadministration').innerHTML;
         var systemadminremarks = document.getElementById('txtsystemremarks').value;
         var Hrdepartment = document.getElementById('Spanhrdepartment').innerHTML;
         var hrremarks = document.getElementById('txthrremarks').value;
         var btnval = document.getElementById('btn_save').value;
         var data = { 'op': 'save_noduecertificate_click', 'employeename': employeename, 'employeecode': employeecode, 'department': department, 'location': location, 'lastworkingdaydate': lastworkingdaydate, 'Reportinghead': Reportinghead, 'btnval': btnval, 'Reportingheadremarks': Reportingheadremarks, 'Accountsdepartment': Accountsdepartment, 'accountsdepremarks': accountsdepremarks, 'Financedepartment': Financedepartment, 'Financedepremarks': Financedepremarks, 'systemadmin': systemadmin, 'systemadminremarks': systemadminremarks, 'Hrdepartment': Hrdepartment, 'hrremarks': hrremarks };
         var s = function (msg) {
             if (msg) {
                 if (msg.length > 0) {
                     alert("New leave type Successfully Created");
//                     get_leavetype_details();
//                     forclearall();
                 }

             }
             else {
             }
         };
         var e = function (x, h, e) {
         }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
         callHandler(data, s, e);
     }
 </script>
 <style>
     hr {
    display: block;
    height: 1px;
    border: 0;
    border-top: 1px solid #ccc;
    margin: 1em 0;
    padding: 0;
}
 </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <section class="content-header">
        <h1>
            Employee NoDueCertificate<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Employee NoDueCertificate</a></li>
        </ol>
    </section>
    
         <section class="content">
         <div>
    <div class="box box-info">
            <div class="box-header with-border" >
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>NoDueCertificate
                </h3>
            </div>
            <div class="box-body" style="padding-left:130px;">
            <table id="tbl_leavemanagement" class="inputstable">
                <tr>
                    <td>
                        <label>
                            Department <span style="color: red;">*</span></label>
                    </td>
                    <td>
                        <select id="selct_department" class="inputBox"  <%--onchange="ddldepartmentchange();"--%> style="width:250px;">
                            <option selected disabled value="Select Department">Select Department</option>
                        </select>
                    </td>
                    <td style="width:10px;"></td>
                    <td>
                        <label>
                            Employee <span style="color: red;">*</span></label>
                    </td>
                    <td>
                     <input type="text" class="inputBox" id="selct_employe"  placeholder="Enter Employee Name"/>
                     </td>
                        <td style="height: 40px;">
                                <input id="txtsupid" type="hidden"  class="form-control" name="hiddenempid" />
                           <input id="txtempcode1" type="hidden" class="form-control" name="hiddenempid" />
                      <%--<select id="selct_employe" class="inputBox" onchange="emplochenage();" style="width:250px;">
                            <option selected disabled value="Select Employee">Select Employee</option>
                        </select>--%>
                     </td>
                    <td style="width:10px;">
                    </td>
                      <%--<td>
                        <label>
                            Effective Date <span style="color: red;">*</span></label>
                    </td>
                    <td>
                     <input type="date" class="inputBox" id="txt_Effctivedate"  placeholder="Enter date " />
                     </td>--%>
                </tr>
            </table>
            </div>
       <%-- </div>--%>
       <div id="divPrint">
        
        <div>
         <section class="content">
    <div class="box box-info">
     <div style="width: 13%; float: left;">
                        <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="100px" height="72px" />
                        <br />
                    </div>
    <table align="center">
    <tr>
    <td style="font-size:21px;">
    <b><span id="spantitle"></span></b>
    </td>
    </tr>
     <tr>
    <td style="font-size:19px;">
    <b><span id="spanaddress"></span></b>
    </td>
    </tr>
    </table>
            <div class="box-header with-border" align="center" style="padding-right: 32%;">
                <h3 class="box-title">
                    <i  class="fa fa-cog"></i>NoDueCertificate
                </h3>
            </div>
            <div class="box-body">
            <table id="tblDetails" runat="server" class="tablecenter" width="98%">
                <tr>
                    <td style="height: 40px;">
                        <label1>
                                Employee Code:</label1>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td style="width: 200px;">
                        <span id="txtEmployeeCode" />
                    </td>
                    <td style="height: 40px;">
                                <label1>
                                Employee Name:</label1>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="Spnemployeename" />
                            </td>
                     <td style="height: 40px;">
                                <label1>
                                Department:</label1>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="Spndepartment" /> 
                            </td>
                               


                </tr>
                <tr>
                     <td style="height: 40px;">
                                <label1>
                                Designation:</label1>
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td style="width: 200px;">
                                <span id="SpanDesigination" />
                            </td>
                    <td style="height: 40px;">
                        <label1>
                                DOJ:</label1>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td style="width: 200px;">
                        <span id="Spndoj" />
                    </td>
                    <td style="height: 40px;">
                        <label1>
                                Location:</label1>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td style="width: 200px;">
                        <span id="Spanlocation" />
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                        <label1>
                                Present Package:</label1>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td style="width: 200px;">
                        <span id="SpnPresentpackage" />
                    </td>
                    <td style="height: 40px;">
                        <label1>
                                Present Net Pay:</label1>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td style="width: 200px;">
                        <span id="Spnnetpay" />
                    </td>
                </tr>
            </table>
            </br>
            <hr/>
            <p>
            <b>H.R Manager:</b>  <span id="Spanhr" />
                </br>

        <p>  The Above Employee has resigned from our organisation and his/her H.O.D has accepted his/her resignation her last date of working is 
            <td>
            <input type="date" id="txtlastdate" />
            </td>.
            </br>
            You are requested you to kindly let us know if any outstanding/pending from his/her part</p>
            </p>
      <hr/>
      <p><b>Reporting Head</b></p>
      <table>
      <tr>
      <td>
       <label1>
        Name:</label1>
      </td>
      <td>
      <b><span id="SpanReportingHead" /></b>
      </td>
      </tr>
      <tr>
       <td style="height: 40px;">
                                <label1>
                                Designation:</label1>
                            </td>
                           
                            <td >
                             <b> <span id="Spndepartment1"></span></b>
                            </td>
                            <td>
                               <b> <span id="Spandesignetion1"  style="margin-left: 0px;"/></b>
                            </td>

                             
      </tr>
     
      </table>
      <p>
      Pls Comments if any due is there regarding documents or any other related to the department or else mention no due

      </br>
      </br>
      <table>
       <tr>
       <td>
                            <textarea cols="35" rows="3" id="txtrepoheadremarks"  class="form-control" placeholder="Enter Remarks" style="border: solid 1px orange;width: 958px;"></textarea>
                        </td>
      </tr>
      </table>
        <b>Signature:</b>  
                                       
            <b style="float:right">Date:</b>
      </p>

      <hr/>
      <p><b>Accounts Department</b></p>
      <table>
      <tr>
      <td>
       <label1>
        Name:</label1>
      </td>
      <td>
     <b><span id="Spanaccounts" /></b> 
      </td>
      </tr>
      <tr>
       <td style="height: 40px;">
                                <label1>
                                Designation:</label1>
                            </td>
                           
                            <td>
                            <b><span id="Spndepartmeaccount1"></span></b>
                            </td>
                            <td>
                               <b> <span id="Spanaccountsdesignetion" style="margin-left: 4px;" /></b>
                            </td>
      </tr>
      </table>
      <p>
      Pls Comments if any due is there  related to your department or else mention no due
      </br>
      </br>
        <table>
       <tr>
       <td>
                            <textarea cols="35" rows="3" id="txtaccountremarks"  class="form-control" placeholder="Enter Remarks" style="border: solid 1px orange;width: 958px;"></textarea>
                        </td>
      </tr>
      </table>
        <b>Signature:</b>                                     <b style="float:right">Date:</b>
      </p>
      <hr/>
      <p><b>Finance Department</b></p>
      <table>
      <tr>
      <td>
       <label1>
        Name:</label1>
      </td>
      <td>
      <b><span id="Spanfinance" /></b>
      </td>
      </tr>
      <tr>
       <td style="height: 40px;">
                                <label1>
                                Designation:</label1>
                            </td>
                         
                            <td>
                            <b><span id="Spndepartafindep"></span></b>
                            </td>
                            <td >
                                <b><span id="Spanfinancedesignetion" style="margin-left: -88px;" /></b>
                            </td>
      </tr>
      </table>
      <p>
      Pls Comments if any due is there  related to your department or else mention no due
        </br>
      </br>
        <table>
       <tr>
       <td>
                            <textarea cols="35" rows="3" id="txtfinanceremarks"  class="form-control" placeholder="Enter Remarks" style="border: solid 1px orange;width: 958px;"></textarea>
                        </td>
      </tr>
      </table>
        <b>Signature:</b>                                     <b style="float:right">Date:</b>
      </p>
     
      <hr/>
      <p><b>System Administration</b></p>
      <table>
      <tr>
      <td>
       <label1>
        Name:</label1>
      </td>
      <td>
      <b><span id="Spansystemadministration" /></b>
      </td>
      </tr>
      <tr>
       <td style="height: 40px;">
                                <label1>
                                Designation:</label1>
                            </td>
                          
                            <td >
                               <b> <span id="Spansystem" /></b>
                            </td>
                            <td>
                               <b> <span id="Spansystemdep"  style="margin-left:0px;"/></b>
                            </td>
      </tr>
      </table>
      <p>
      Pls Comments if any due is there  related to your department or else mention no due
        </br>
      </br>
        <table>
       <tr>
       <td>
                            <textarea cols="35" rows="3" id="txtsystemremarks"  class="form-control" placeholder="Enter Remarks" style="border: solid 1px orange;width: 958px;"></textarea>
                        </td>
      </tr>
      </table>
        <b>Signature:</b>                                     <b style="float:right">Date:</b>
      </p>
       <hr/>
      <p><b>HR Department</b></p>
      <table>
      <tr>
      <td>
       <label1>
        Name:</label1>
      </td>
      <td>
      <b><span id="Spanhrdepartment" /></b>
      </td>
      </tr>
      <tr>
       <td style="height: 40px;">
                                <label1>
                                Designation:</label1>
                            </td>
                          
                            <td>
                            <b><span id="Spanhrdep"></span></b>
                            </td>
                            <td>
                               <b> <span id="Spanhrdesignetion"  style="margin-left: -59px;"/></b>
                            </td>
      </tr>
      </table>
      <p>
      Pls Comments if any due is there  related to your department or else mention no due
        </br>
      </br>
        <table>
       <tr>
       <td>
                            <textarea cols="35" rows="3" id="txthrremarks"  class="form-control" placeholder="Enter Remarks" style="border: solid 1px orange;width: 958px;"></textarea>
                        </td>
      </tr>
      </table>
        <b>Signature:</b>                                    
         <b style="float:right">Date:</b>
      </p>
        </div>
        </div>
        </section>
    </div>
     </div>
       </div>
       </div>
    <div align="center" id="printbtn" >
                                        <table>
                                        <tr>
                                         <td>
                                         <button type="button" id="btn_save" class="btn btn-success"  value="Save" onclick ="savenoduecertificetreamrks();"><i class="fa fa-check"></i> Save</button>
                                        </td>
                                        <td>
                                         <button type="button" id="Button1" class="btn btn-success"   onclick ="javascript:CallPrint('divPrint');"><i class="fa fa-print"></i> Print</button>
                                        </td>
                                        <td>
                                        <input type="button" class="btntogglecls" style="height: 28px; opacity: 1.0; width: 100px;
                                        background-color: #d5d5d5; color: Blue;" onclick="tableToExcel('divPrint', 'W3C Example Table')"
                                        value="Export to Excel" />
                                        </td>
                                        </tr>
                                        </table>
                                         </div>
                                       
    </section>
   
    
      

</asp:Content>

