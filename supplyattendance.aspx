<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="supplyattendance.aspx.cs" Inherits="supplyattendance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Employeedetails();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth();
            if (month < 9) {
                month = parseFloat(month);
                month = month + 1;
                month = "0" + month;
            }
            document.getElementById('selct_month').value = month;
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

        function show_importdeduction() {
            $("#div_importdeduction").css("display", "block");
            $("#div_editdeduction").css("display", "none");

        }
        function show_deduction() {
            $("#div_editdeduction").css("display", "block");
            $("#div_importdeduction").css("display", "none");
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
                    var empcodeList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empnum = msg[i].empnum;
                        empcodeList.push(empnum);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                    $('#txt_Empcode').autocomplete({
                        source: empcodeList,
                        change: employeecodechange,
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
                    document.getElementById('txt_Empcode').value = employeedetails[i].empnum;
                }
            }
        }
        function employeecodechange() {
            var empnum = document.getElementById('txt_Empcode').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empnum == employeedetails[i].empnum) {
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                    document.getElementById('selct_employe').value = employeedetails[i].empname;
                }
            }
        }
        function btn_employee_click() {
            var empid = document.getElementById('txtsupid').value;
            if (empid == "") {
                alert("Please enter Employee Name");
                return false;
            }
            var month = document.getElementById('selct_month').value;
            var year = document.getElementById('selct_Year').value;
            var data = { 'op': 'get_Deductiondetailes_details', 'empid': empid, 'month': month, 'year': year };
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col"></th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Numberofworkingdays</th><th scope="col">CLHolidays</th><th scope="col">LOP</th><th scope="col">EXtradays</th><th scope="col">Salary Advance</th><th scope="col">Mobile Deduction</th><th scope="col">Loan</th><th scope="col">Canteen</th><th scope="col">Other Deductions</th><th scope="col">Night Days</th><th scope="col">Ot Hours</th><th scope="col">Days IN Month</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Save" /></td>';
                //k++;
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].employee_num + '</th>';
                results += '<td>' + msg[i].fullname + '</td>';
                results += '<td><input id="txt_numbrofdays" data-title="Code" style="width:65px;" class="2"  value="' + msg[i].numberofworkingdays + '"/></td>';
                results += '<td><input id="txt_cl" data-title="Code" style="width:65px;" onkeyup="CLChange(this);" class="2"  value="' + msg[i].clhoildays + '"/></td>';
                results += '<td><input  id="txt_lop" class="3" style="width:65px;" value="' + msg[i].lop + '"/></td>';
                results += '<td><input id="txt_extradays" class="4" style="width:65px;" value="' + msg[i].extradays + '"/></td>';
                results += '<td><input  id="txt_salaryadvance" class="6" style="width:65px;" value="' + msg[i].salaryadvance + '"/></td>';
                results += '<td><input id="txt_mobilededuction" class="5" style="width:65px;" value="' + msg[i].mobilededuction + '"/></td>';
                results += '<td><input  id="txt_loan" class="7"  style="width:65px;" value="' + msg[i].loan + '"/></td>';
                results += '<td><input  id="txt_canteenamount" style="width:65px;" class="8" value="' + msg[i].canteenamount + '"/></td>';

                results += '<td><input  id="txt_Otherdeduction" style="width:65px;" class="9" value="' + msg[i].otherdeduction + '"/></td>';
                results += '<td><input  id="txt_nightdays" style="width:65px;" class="11" value="' + msg[i].night_days + '"/></td>';
                results += '<td><input  id="txt_othours" style="width:65px;" class="11" value="' + msg[i].othours + '"/></td>';
                results += '<td><input  id="txt_monthdays" style="width:65px;" class="11" value="' + msg[i].monthdays + '"/></td>';
                results += '<td><input  id="txt_txtempcode" style="width:65px;display:none;" class="10" value="' + msg[i].employee_num + '"/></td></tr>';
            }
            results += '</table></div>';
            $("#div_BrandData").html(results);

        }
        function getme(thisid) {

            var employeid = document.getElementById('txtsupid').value;
            var clhoildays = document.getElementById('txt_cl').value;
            var night_days = document.getElementById('txt_nightdays').value;
            var othours = document.getElementById('txt_othours').value;
            var lop = document.getElementById('txt_lop').value;
            var extradays = document.getElementById('txt_extradays').value;
            var mobilededuction = document.getElementById('txt_mobilededuction').value;
            var salaryadvance = document.getElementById('txt_salaryadvance').value;
            var loan = document.getElementById('txt_loan').value;
            var canteenamount = document.getElementById('txt_canteenamount').value;
            var fullname = document.getElementById('selct_employe').value;

            var otherdeduction = document.getElementById('txt_Otherdeduction').value;
            var employee_num = document.getElementById('txt_txtempcode').value;
            var month = document.getElementById('selct_month').value;
            var year = document.getElementById('selct_Year').value;
            var numberofworkingdays = document.getElementById('txt_numbrofdays').value;
            var btnval = document.getElementById('btn_poplate').value;
            var data = { 'op': 'save_edit_supply_details', 'employeid': employeid, 'night_days': night_days, 'clhoildays': clhoildays, 'lop': lop, 'mobilededuction': mobilededuction, 'extradays': extradays, 'salaryadvance': salaryadvance, 'loan': loan, 'canteenamount': canteenamount, 'employee_num': employee_num, 'month': month, 'year': year, 'othours': othours, 'numberofworkingdays': numberofworkingdays, 'otherdeduction': otherdeduction, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        btn_employee_click();
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

        function CLChange(clh) {
            if (clh.value != "") {

                var noofworkingdays = 0;
                noofworkingdays = $(clh).closest("tr").find('#txt_monthdays').val();
                var total = noofworkingdays - clh.value;
                $(clh).closest("tr").find('#txt_numbrofdays').val(total);
            }
        }
    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Edit Total Deduction<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Deduction Management</a></li>
            <li><a href="#">Deduction</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
         <div>
                    <ul class="nav nav-tabs">
                        
                             <li id="id_tab_Personal" class=""><a data-toggle="tab" href="#" onclick="show_deduction()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;supplementary  Master</a></li>
                           
                    </ul>
              </div>
          <div id="div_editdeduction" >
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Edit Total Deduction
                </h3>
            </div>
            <table id="tbl_leavemanagement" align="center">
                <tr>
                <td style="height: 40px;">
                  <label class="control-label" >
                        Employee Code<span style="color: red;">*</span>
                        </label>
                    </td>
                     <td>
                        <input type="text" class="form-control" id="txt_Empcode" placeholder="Enter employee Code" />
                    </td>
                    <td style="height: 40px;">
                      <label class="control-label" >
                        Employee Name<span style="color: red;">*</span>
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="selct_employe" placeholder="Enter employee name" />
                    </td>
                    <td style="height: 40px; display: none">
                        <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                    <td style="width: 5px;">
                    </td>
                    <td>
                      <label class="control-label" >
                        Month
                        </label>
                    </td>
                    <td>
                        <select name="month" id="selct_month" onchange="" style="width: 100px;" class="form-control" size="1">
                            <option value="01">January</option>
                            <option value="02">February</option>
                            <option value="03">March</option>
                            <option value="04">April</option>
                            <option value="05">May</option>
                            <option value="06">June</option>
                            <option value="07">July</option>
                            <option value="08">August</option>
                            <option value="09">September</option>
                            <option value="10">October</option>
                            <option value="11">November</option>
                            <option value="12">December</option>
                        </select>
                    </td>
                       <td style="width: 5px;">
                    </td>
                    <td>
                      <label class="control-label" >
                        Year
                        </label>
                    </td>
                    <td style="width: 100px;">
                        <select name="year" id="selct_Year" class="form-control" onchange="" size="1">
                            <option>2016</option>
                            <option>2017</option>
                            <option>2018</option>
                            <option>2019</option>
                            <option>2020</option>
                            <option>2021</option>
                            <option>2022</option>
                            <option>2023</option>
                            <option>2024</option>
                            <option>2025</option>
                            <option>2026</option>
                            <option>2027</option>
                        </select>
                    </td>
                       <td style="width: 5px;">
                    </td>
                    <td>
                        <input id="Button1" type="button" class="btn btn-primary" name="submit" value='Generate'
                            onclick="btn_employee_click()" />
                    </td>
                </tr>
            </table>
            <div id="div_BrandData">
            </div>
        </div>
       
       </div>
        
    </section>
</asp:content>
