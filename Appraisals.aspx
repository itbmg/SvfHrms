<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Appraisals.aspx.cs" Inherits="Appraisals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 <link href="css/fieldset.css" rel="stylesheet" type="text/css" />
  <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript">
     $(function () {
         get_Dept_details();
         get_Appraisals_fill_Details();
         get_Desgnation_details();
         get_Employeedetails();
         get_paystructured_details();
         var date = new Date();
         var day = date.getDate();
         var month = date.getMonth() + 1;
         var year = date.getFullYear();
         if (month < 10) month = "0" + month;
         if (day < 10) day = "0" + day;
         today = year + "-" + month + "-" + day;
         $('#txt_Effctivedate').val(today);
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


    function get_Desgnation_details() {
        var data = { 'op': 'get_Desgnation_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillroles(msg);
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
    function fillroles(msg) {
        var data = document.getElementById('selct_designation');
        var length = data.options.length;
        document.getElementById('selct_designation').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select Designation";
        opt.value = "Select Designation";
        opt.setAttribute("selected", "selected");
        opt.setAttribute("disabled", "disabled");
        opt.setAttribute("class", "dispalynone");
        data.appendChild(opt);
        for (var i = 0; i < msg.length; i++) {
            if (msg[i].designation != null) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].designation;
                option.value = msg[i].designationid;
                data.appendChild(option);
            }
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
    function emplochenage(msg) {
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
                // document.getElementById('txt_grosspay').value = msg[i].monthsarl;
                document.getElementById('txtChangedpackage').value = msg[i].salary;
                //document.getElementById('textsalarymode').value = salrdata[i].salarymode;
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
        if (canteendeduction == "") {
            canteendeduction = 0;
        }
        var Totaldeduction = 0;
        Totaldeduction = parseFloat(debBasic) + parseFloat(professinaltax) + Incometax + parseFloat(Esi) + parseFloat(canteendeduction);
        document.getElementById('txt_Totaldeduction').value = Totaldeduction;
        var netpay = 0;
        netpay = TotalEarnings - Totaldeduction;
        netpay = parseFloat(TotalEarnings) - parseFloat(Totaldeduction);
        document.getElementById('txt_netsalary').value = netpay;
    }
    function aprisalchange() {
        var employeid = document.getElementById('txtsupid').value;
        var salarymode = "";
        var pfeligible = " ";
        var esieligible = "";
        for (var i = 0; i < employee_data.length; i++) {
            if (employeid == employee_data[i].empsno) {
                salarymode = employee_data[i].salarymode;
                var Fixed = 0;
                var Percentage = 0;
                if (salarymode == Percentage) {
                    var presalary = document.getElementById('txtChangedpackage').value;
                    var appraisal = document.getElementById('txt_Appraisal').value;
                    var salary = parseInt(presalary) + parseInt(appraisal);
                    var sal = 50;
                    erbasic = (parseFloat(salary) * parseFloat(sal)) / 100;
                    document.getElementById('txt_ernbasic').value = erbasic;
                    var erbasic = document.getElementById('txt_ernbasic').value;
                    //                    var pf = 12;
                    //                    providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                    var erbasic = document.getElementById('txt_ernbasic').value;
                    if (employee_data[i].pfeligible == "No") {
                        document.getElementById('txt_debBasic').value = 0;
                    }
                    else {
                        var pf = 12;
                        providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                        if (providentfound > 1800) {
                            document.getElementById('txt_debBasic').value = 1800;
                        }
                        else {
                            document.getElementById('txt_debBasic').value = providentfound;
                        }                        
                    }

                    //document.getElementById('txt_debBasic').value = providentfound;
                    if (employee_data[i].esieligible == "No") {
                        document.getElementById('txt_Esi').value = 0;
                    }
                    else {
                        var esiper = 1.75;
                        esi = (parseFloat(erbasic) * parseFloat(esiper)) / 100;

                    }
                  
                    //                    var erbasic = document.getElementById('txt_ernbasic').value;
                    //                    var pf = 1.75;
                    //                    esi = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                    //                    document.getElementById('txt_Esi').value = esi;
                    var medical = 1250;
                    document.getElementById('txt_Medical').value = medical;
                    var conveyance = 1600;
                    document.getElementById('txt_Converance').value = conveyance;
                    var washingallowance = 1000;
                    document.getElementById('txt_WashingAllowance').value = washingallowance;
                    var tot = 0;
                    var conveyance = document.getElementById('txt_Converance').value;
                    var medical = document.getElementById('txt_Medical').value;
                    var washingallowance = document.getElementById('txt_WashingAllowance').value;
                    var erbasic = document.getElementById('txt_ernbasic').value;
                    tot = parseInt(medical) + parseInt(conveyance) + parseInt(washingallowance) + parseInt(erbasic);
                    var hre = 0;
                    hre = parseInt(salary) - parseInt(tot);
                    document.getElementById('txt_HousingRent').value = hre;
//                    var TotalEarnings = "0";
//                    document.getElementById('txt_TotalEarnings').value = TotalEarnings;
//                    var Totaldeduction = "0";
//                    document.getElementById('txt_Totaldeduction').value = Totaldeduction;
                    var professionaltax = 0;
                    var employeid = document.getElementById('txtsupid').value;
                    var statename = "";
                    for (var i = 0; i < employee_data.length; i++) {
                        if (employeid == employee_data[i].empsno) {
                            statename = employee_data[i].statename;
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
                                if (salary < 7000) {
                                    professionaltax = "0";
                                }
                                else if (salary >= 7001 && salary <= 10000) {
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
                                if (salary <= 15001) {
                                    professionaltax = "0";
                                }
                                else if (salary >= 15001) {
                                    professionaltax = "200";
                                }
                            }
                            document.getElementById('txt_professinaltax').value = professionaltax;
                            totalchange();
                        }
                    }
                }
              
            }

            else {
                salarymode == "Fixed";
                erbasic = "0";
                document.getElementById('txt_ernbasic').value = erbasic;
                var providentfound = "0";
                document.getElementById('txt_debBasic').value = providentfound;
                var conveyance = "0";
                document.getElementById('txt_Converance').value = conveyance;
                var medical = "0";
                document.getElementById('txt_Medical').value = medical;
                var washingallowance = "0";
                document.getElementById('txt_WashingAllowance').value = washingallowance;
                var professionaltax = "0";
                document.getElementById('txt_professinaltax').value = professionaltax;
                var hre = "0";
                document.getElementById('txt_HousingRent').value = hre;
                var incometax = "0";
                document.getElementById('txt_Incometax').value = incometax;
                var canteendeduction = "0";
                document.getElementById('txt_canteendeduction').value = canteendeduction;
                var washingallowance = "0";
                document.getElementById('txt_WashingAllowance').value = washingallowance;
                var esi = "0";
                document.getElementById('txt_Esi').value = esi;
                var TotalEarnings = "0";
                var Totaldeduction = "0";
                document.getElementById('txt_Totaldeduction').value = Totaldeduction;
                var presalary = document.getElementById('txtChangedpackage').value;
                var appraisal = document.getElementById('txt_Appraisal').value;
                //var salary = parseInt(presalary) + parseInt(appraisal);
               
                var netsalary = 0;
                var netsalary = parseInt(presalary) + parseInt(appraisal);
                netpay = netsalary / 12;
                var netpay = netpay.toFixed(2);
                document.getElementById('txt_netsalary').value = netsalary;
                document.getElementById('txt_grosspay').value = netsalary;
                document.getElementById('txt_TotalEarnings').value = netsalary;
            }
        }
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

    function save_Apprasial_Salary_click() {
        var department = document.getElementById('selct_department').value;
        var employeid = document.getElementById('txtsupid').value;
        if (employeid == "Select Employee Name") {
            alert("Please Employee Name");
            return;
        }
        var empcode1 = document.getElementById('txtempcode1').value;
        var effectivedate = document.getElementById('txt_Effctivedate').value;
        if (effectivedate == "") {
            alert("Enter Date");
            return false;
        }
        var designation = document.getElementById('selct_designation').value;
        if (designation == "Select designation") {
            alert("Please Select designation");
            return;
        }
        var changedpackage = document.getElementById('txtChangedpackage').value;
        var appraisal = document.getElementById('txt_Appraisal').value;
        if (appraisal == "") {
            alert("Select Employee appraisal ");
            return false;
        }
        var erbasic = document.getElementById('txt_ernbasic').value;
        var hre = document.getElementById('txt_HousingRent').value;
        var conveyance = document.getElementById('txt_Converance').value;
        var medical = document.getElementById('txt_Medical').value;
        var providentfound = document.getElementById('txt_debBasic').value;
        var professionaltax = document.getElementById('txt_professinaltax').value;
        var esi = document.getElementById('txt_Esi').value;
        var incometax = document.getElementById('txt_Incometax').value;
        var grosspay = document.getElementById('txt_grosspay').value;
        var totalEarnings = document.getElementById('txt_TotalEarnings').value;
        var totaldeduction = document.getElementById('txt_Totaldeduction').value;
        var netpay = document.getElementById('txt_netsalary').value;
        var washingallowance = document.getElementById('txt_WashingAllowance').value;
        //var canteendeduction = document.getElementById('txt_canteendeduction').value;
        var btnval = document.getElementById('btn_save').value;
        var data = { 'op': 'save_Apprasial_Salary_click', 'employeid': employeid, 'empcode1': empcode1, 'department': department, 'designation': designation, 'changedpackage': changedpackage, 'appraisal': appraisal, 'erbasic': erbasic, 'hre': hre, 'conveyance': conveyance, 'medical': medical, 'providentfound': providentfound, 'professionaltax': professionaltax, 'esi': esi, 'incometax': incometax, 'totalEarnings': totalEarnings, 'grosspay': grosspay, 'totaldeduction': totaldeduction, 'netpay': netpay, 'washingallowance': washingallowance, 'effectivedate': effectivedate, 'btnval': btnval };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert("Employee Apprasial details successfully added");
                    //forclearall();
                    canceldetails();
                    //get_paystructured_details();
                }
            }
            else {
            }
        };
        var e = function (x, h, e) {
        }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        callHandler(data, s, e);
    }

    function canceldetails() {
        document.getElementById('selct_department').selectedIndex = 0;
        document.getElementById('txtsupid').value = "";
        document.getElementById('selct_designation').selectedIndex = 0;
        document.getElementById('txtChangedpackage').value = "";
        document.getElementById('txt_Appraisal').value = "";
        document.getElementById('txt_ernbasic').value = "";
        document.getElementById('txt_HousingRent').value = "";
        document.getElementById('txt_Converance').value = "";
        document.getElementById('txt_Medical').value = "";
        document.getElementById('txt_professinaltax').value = "";
        document.getElementById('txt_debBasic').value = "";
        document.getElementById('txt_Esi').value = "";
        document.getElementById('txt_Incometax').value = "";
        document.getElementById('txt_grosspay').value = "";
        document.getElementById('txt_netsalary').value = "";
        document.getElementById('txt_WashingAllowance').value = "";
        document.getElementById('txt_TotalEarnings').value = "";
        document.getElementById('txt_Totaldeduction').value = "";
        document.getElementById('txtEmployeeCode').innerHTML = "";
        document.getElementById('Spnemployeename').innerHTML = "";
        document.getElementById('SpanDesigination').innerHTML = "";
        document.getElementById('Spndepartment').innerHTML = "";
        document.getElementById('Spndoj').innerHTML = "";
        document.getElementById('SpnPresentpackage').innerHTML = "";
        document.getElementById('Spnnetpay').innerHTML = "";
        document.getElementById('selct_employe').value = "";
        document.getElementById('txt_grosspay').value = "";
        document.getElementById('btn_save').value = "Save";
    }


    function get_paystructured_details() {
        var data = { 'op': 'get_emppaystructure_details' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    get_Dept_details();
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
        get_Dept_details();
        var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
        results += '<thead><tr><th scope="col">Sno</th><th scope="col">Emp Code</th><th scope="col">Name</th><th scope="col">Department</th><th scope="col">Gross</th><th scope="col">EarningBasic</th></tr></thead></tbody>';
        var l = 0;
        var k = 1;
        var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td>' + k++ + '</td>';
            results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode1 + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].fullname + '</td>';
            results += '<td data-title="status" class="3">' + msg[i].department + '</td>';
            results += '<td data-title="status" class="4">' + msg[i].gross + '</td>';
            results += '<td data-title="status" class="5">' + msg[i].erningbasic + '</td>';
            results += '<td data-title="status" style="display:none" class="6">' + msg[i].profitionaltax + '</td>';
            results += '<td data-title="status" style="display:none" class="7">' + msg[i].esi + '</td>';
            results += '<td data-title="status" style="display:none" class="8">' + msg[i].incometax + '</td>';
            results += '<td data-title="status" style="display:none" class="9">' + msg[i].hra + '</td>';
            results += '<td data-title="status" style="display:none" class="10">' + msg[i].conveyance + '</td>';
            results += '<td data-title="status" style="display:none" class="11">' + msg[i].medicalearning + '</td>';
            results += '<td data-title="status" style="display:none" class="12">' + msg[i].pf + '</td>';
            results += '<td data-title="status" style="display:none" class="13">' + msg[i].washingallowance + '</td>';
            results += '<td data-title="status" style="display:none" class="14">' + msg[i].mediclaimdeduction + '</td>';
            results += '<td data-title="status" style="display:none" class="15">' + msg[i].tdsdeduction + '</td>';
            results += '<td data-title="status" style="display:none" class="16">' + msg[i].salaryperyear + '</td>';
            results += '<td data-title="status" style="display:none" class="17">' + msg[i].travelconveyance + '</td>';
            results += '<td data-title="status" style="display:none" class="18">' + msg[i].departmentid + '</td>';
            //                results += '<td data-title="status" style="display:none" class="21">' + msg[i].departmentid + '</td>';
            //                results += '<td data-title="status" style="display:none" class="22">' + msg[i].department + '</td>';
            results += '<td data-title="status" style="display:none" class="19">' + msg[i].employeid + '</td>';
            results += '<td style="display:none" class="20">' + msg[i].sno + '</td></tr>';
            //results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td></tr>';
            l = l + 1;
            if (l == 4) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#divbinddata").html(results);
    }


//    function getme(thisid) {
//        $('#divpanel').css('display', 'block');
//        $('#divaddemp').css('display', 'none');
//        $('#divbinddata').hide();
//        totalchange();
//        var empcode = $(thisid).parent().parent().children('.1').html();
//        var fullname = $(thisid).parent().parent().children('.2').html();
//        var department = $(thisid).parent().parent().children('.3').html();
//        var gross = $(thisid).parent().parent().children('.4').html();
//        var erningbasic = $(thisid).parent().parent().children('.5').html();
//        var profitionaltax = $(thisid).parent().parent().children('.6').html();
//        var esi = $(thisid).parent().parent().children('.7').html();
//        var incometax = $(thisid).parent().parent().children('.8').html();
//        var hra = $(thisid).parent().parent().children('.9').html();
//        var conveyance = $(thisid).parent().parent().children('.10').html();
//        var medicalearning = $(thisid).parent().parent().children('.11').html();
//        var pf = $(thisid).parent().parent().children('.12').html();
//        var washingallowance = $(thisid).parent().parent().children('.13').html();
//        var mediclaimdeduction = $(thisid).parent().parent().children('.14').html();
//        var tdsdeduction = $(thisid).parent().parent().children('.15').html();
//        var salaryperyear = $(thisid).parent().parent().children('.16').html();
//        var travelconveyance = $(thisid).parent().parent().children('.17').html();
//        var departmentid = $(thisid).parent().parent().children('.18').html();
//        var employeid = $(thisid).parent().parent().children('.19').html();
//        var sno = $(thisid).parent().parent().children('.20').html();
//        //            var department = $(thisid).parent().parent().children('.22').html();
//        //            var departmentid = $(thisid).parent().parent().children('.21').html();


//        //            document.getElementById('selct_department').value = departmentid;
//        document.getElementById('selct_department').value = departmentid;
//        //document.getElementById('selct_department').value = department;
//        //            document.getElementById('selct_department').value = department;
//        document.getElementById('selct_employe').value = fullname;
//        document.getElementById('txt_Gross').value = gross;
//        document.getElementById('txt_ernbasic').value = erningbasic;
//        document.getElementById('txt_HousingRent').value = hra;
//        document.getElementById('txt_Converance').value = conveyance;
//        document.getElementById('txt_Medical').value = medicalearning;
//        document.getElementById('txt_professinaltax').value = profitionaltax;
//        document.getElementById('txt_PF').value = pf;
//        document.getElementById('txt_Esi').value = esi;
//        document.getElementById('txt_Incometax').value = incometax;
//        document.getElementById('txt_TravelConveyance').value = travelconveyance;
//        document.getElementById('txt_WashingAllowance').value = washingallowance;
//        document.getElementById('txt_Tds').value = tdsdeduction;
//        document.getElementById('txt_sal').value = salaryperyear;
//        document.getElementById('txtsupid').value = employeid;
//        document.getElementById('txt_Mediclaim').value = mediclaimdeduction;
//        document.getElementById('lbl_sno').innerHTML = sno;
//        document.getElementById('txtempcode1').value = empcode;
//        document.getElementById('btn_save').value = "Modify";
//    }



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
    function empnamechange() {
        //get_Dept_details
        //totalchange();
        document.getElementById('txtempCode').value = "";
        var name = document.getElementById('txt_empname1').value;
        var msg = empdata;
        if (name == "") {
            var l = 0;
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Emp Code</th><th scope="col">Name</th><th scope="col">Department</th><th scope="col">Gross</th><th scope="col">EarningBasic</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode1 + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="status" class="3">' + msg[i].department + '</td>';
                results += '<td data-title="status" class="4">' + msg[i].gross + '</td>';
                results += '<td data-title="status" class="5">' + msg[i].erningbasic + '</td>';
                results += '<td data-title="status" style="display:none" class="6">' + msg[i].profitionaltax + '</td>';
                results += '<td data-title="status" style="display:none" class="7">' + msg[i].esi + '</td>';
                results += '<td data-title="status" style="display:none" class="8">' + msg[i].incometax + '</td>';
                results += '<td data-title="status" style="display:none" class="9">' + msg[i].hra + '</td>';
                results += '<td data-title="status" style="display:none" class="10">' + msg[i].conveyance + '</td>';
                results += '<td data-title="status" style="display:none" class="11">' + msg[i].medicalearning + '</td>';
                results += '<td data-title="status" style="display:none" class="12">' + msg[i].pf + '</td>';
                results += '<td data-title="status" style="display:none" class="13">' + msg[i].washingallowance + '</td>';
                results += '<td data-title="status" style="display:none" class="14">' + msg[i].mediclaimdeduction + '</td>';
                results += '<td data-title="status" style="display:none" class="15">' + msg[i].tdsdeduction + '</td>';
                results += '<td data-title="status" style="display:none" class="16">' + msg[i].salaryperyear + '</td>';
                results += '<td data-title="status" style="display:none" class="17">' + msg[i].travelconveyance + '</td>';
                results += '<td data-title="status" style="display:none" class="18">' + msg[i].departmentid + '</td>';
                results += '<td data-title="status" style="display:none" class="19">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="20">' + msg[i].sno + '</td></tr>';
                //results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }

            $("#divbinddata").html(results);
        }
        else {
            //totalchange();
            var l = 0;
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Emp Code</th><th scope="col">Name</th><th scope="col">Department</th><th scope="col">Gross</th><th scope="col">EarningBasic</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (name == msg[i].fullname) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<td>' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode1 + '</th>';
                    results += '<td data-title="code" class="2">' + msg[i].fullname + '</td>';
                    results += '<td data-title="status" class="3">' + msg[i].department + '</td>';
                    results += '<td data-title="status" class="4">' + msg[i].gross + '</td>';
                    results += '<td data-title="status" class="5">' + msg[i].erningbasic + '</td>';
                    results += '<td data-title="status" style="display:none" class="6">' + msg[i].profitionaltax + '</td>';
                    results += '<td data-title="status" style="display:none" class="7">' + msg[i].esi + '</td>';
                    results += '<td data-title="status" style="display:none" class="8">' + msg[i].incometax + '</td>';
                    results += '<td data-title="status" style="display:none" class="9">' + msg[i].hra + '</td>';
                    results += '<td data-title="status" style="display:none" class="10">' + msg[i].conveyance + '</td>';
                    results += '<td data-title="status" style="display:none" class="11">' + msg[i].medicalearning + '</td>';
                    results += '<td data-title="status" style="display:none" class="12">' + msg[i].pf + '</td>';
                    results += '<td data-title="status" style="display:none" class="13">' + msg[i].washingallowance + '</td>';
                    results += '<td data-title="status" style="display:none" class="14">' + msg[i].mediclaimdeduction + '</td>';
                    results += '<td data-title="status" style="display:none" class="15">' + msg[i].tdsdeduction + '</td>';
                    results += '<td data-title="status" style="display:none" class="16">' + msg[i].salaryperyear + '</td>';
                    results += '<td data-title="status" style="display:none" class="17">' + msg[i].travelconveyance + '</td>';
                    results += '<td data-title="status" style="display:none" class="18">' + msg[i].departmentid + '</td>';
                    results += '<td data-title="status" style="display:none" class="19">' + msg[i].employeid + '</td>';
                    results += '<td style="display:none" class="20">' + msg[i].sno + '</td></tr>';
                    // results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            $("#divbinddata").html(results);
        }
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
    function empnamecode() {
        //totalchange();
        //get_Dept_details
        document.getElementById('txt_empname1').value = "";
        var empcode1 = document.getElementById('txtempCode').value;
        var msg = empdata;
        if (empcode1 == "") {
            var l = 0;
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Emp Code</th><th scope="col">Name</th><th scope="col">Department</th><th scope="col">Gross</th><th scope="col">EarningBasic</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode1 + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="status" class="3">' + msg[i].department + '</td>';
                results += '<td data-title="status" class="4">' + msg[i].gross + '</td>';
                results += '<td data-title="status" class="5">' + msg[i].erningbasic + '</td>';
                results += '<td data-title="status" style="display:none" class="6">' + msg[i].profitionaltax + '</td>';
                results += '<td data-title="status" style="display:none" class="7">' + msg[i].esi + '</td>';
                results += '<td data-title="status" style="display:none" class="8">' + msg[i].incometax + '</td>';
                results += '<td data-title="status" style="display:none" class="9">' + msg[i].hra + '</td>';
                results += '<td data-title="status" style="display:none" class="10">' + msg[i].conveyance + '</td>';
                results += '<td data-title="status" style="display:none" class="11">' + msg[i].medicalearning + '</td>';
                results += '<td data-title="status" style="display:none" class="12">' + msg[i].pf + '</td>';
                results += '<td data-title="status" style="display:none" class="13">' + msg[i].washingallowance + '</td>';
                results += '<td data-title="status" style="display:none" class="14">' + msg[i].mediclaimdeduction + '</td>';
                results += '<td data-title="status" style="display:none" class="15">' + msg[i].tdsdeduction + '</td>';
                results += '<td data-title="status" style="display:none" class="16">' + msg[i].salaryperyear + '</td>';
                results += '<td data-title="status" style="display:none" class="17">' + msg[i].travelconveyance + '</td>';
                results += '<td data-title="status" style="display:none" class="18">' + msg[i].departmentid + '</td>';
                results += '<td data-title="status" style="display:none" class="19">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="20">' + msg[i].sno + '</td></tr>';
                // results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td></tr>';
                //totalchange();
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }

            results += '</table></div>';
            $("#divbinddata").html(results);
        }

        else {
            //totalchange();
            var l = 0;
            var k = 1;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Emp Code</th><th scope="col">Name</th><th scope="col">Department</th><th scope="col">Gross</th><th scope="col">EarningBasic</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                if (empcode1 == msg[i].empcode1) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<td>' + k++ + '</td>';
                    results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode1 + '</th>';
                    results += '<td data-title="code" class="2">' + msg[i].fullname + '</td>';
                    results += '<td data-title="status" class="3">' + msg[i].department + '</td>';
                    results += '<td data-title="status" class="4">' + msg[i].gross + '</td>';
                    results += '<td data-title="status" class="5">' + msg[i].erningbasic + '</td>';
                    results += '<td data-title="status" style="display:none" class="6">' + msg[i].profitionaltax + '</td>';
                    results += '<td data-title="status" style="display:none" class="7">' + msg[i].esi + '</td>';
                    results += '<td data-title="status" style="display:none" class="8">' + msg[i].incometax + '</td>';
                    results += '<td data-title="status" style="display:none" class="9">' + msg[i].hra + '</td>';
                    results += '<td data-title="status" style="display:none" class="10">' + msg[i].conveyance + '</td>';
                    results += '<td data-title="status" style="display:none" class="11">' + msg[i].medicalearning + '</td>';
                    results += '<td data-title="status" style="display:none" class="12">' + msg[i].pf + '</td>';
                    results += '<td data-title="status" style="display:none" class="13">' + msg[i].washingallowance + '</td>';
                    results += '<td data-title="status" style="display:none" class="14">' + msg[i].mediclaimdeduction + '</td>';
                    results += '<td data-title="status" style="display:none" class="15">' + msg[i].tdsdeduction + '</td>';
                    results += '<td data-title="status" style="display:none" class="16">' + msg[i].salaryperyear + '</td>';
                    results += '<td data-title="status" style="display:none" class="17">' + msg[i].travelconveyance + '</td>';
                    results += '<td data-title="status" style="display:none" class="18">' + msg[i].departmentid + '</td>';
                    results += '<td data-title="status" style="display:none" class="19">' + msg[i].employeid + '</td>';
                    results += '<td style="display:none" class="20">' + msg[i].sno + '</td></tr>';
                    //results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" /></td></tr>';
                    //totalchange();
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }

            $("#divbinddata").html(results);
        }
    }

 </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <section class="content-header">
        <h1>
            Employee Appraisal<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Employee Appraisal</a></li>
        </ol>
    </section>
    <div>
         <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Appraisal
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
                        <select id="selct_department" class="form-control" <%--onchange="ddldepartmentchange();"--%> style="width:250px;">
                            <option selected disabled value="Select Department">Select Department</option>
                        </select>
                    </td>
                    <td style="width:10px;"></td>
                    <td>
                        <label>
                            Employee <span style="color: red;">*</span></label>
                    </td>
                    <td>
                     <input type="text" class="form-control" id="selct_employe"  placeholder="Enter Employee Name"/>
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
                      <td>
                        <label>
                            Effective Date <span style="color: red;">*</span></label>
                    </td>
                    <td>
                     <input type="date" class="form-control" id="txt_Effctivedate"  placeholder="Enter date " />
                     </td>
                </tr>
            </table>
            </div>
       <%-- </div>--%>
        <div>
         <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Appraisal
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
            
        <div>
            <table>
                <tr>
                    <td>
                        <input type="checkbox" id="chk_add_login" name="add_change" value="add_change">
                        <label for="chk_add_login" id="add_change" title="Check">
                            Designation Change</label>
                    </td>
                    <td>
                        <label for="chk_add_login" id="change_des" title="Check" style="display: none">
                            Changed Designation</label>
                    </td>
                    <td>
                        <select id="selct_designation" class="inputBox" style="display: none" >
                            <option selected disabled value="Select Designation"  >Select Designation</option>
                        </select>
                    </td>
                </tr>
                <tr>
                <td>
                     <input type="checkbox" id="chk_packgechange" name="add_change" value="add_change">
                        <label for="chk_packgechange" id="chk_packgechang" title="Check">
                            Package Change</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="chk_add_login" id="packge_change" title="Check">
                            Changed Package</label>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td>
                        <input id="txtChangedpackage" type="text" name="Notice" class="form-control"  disabled="disabled" />
                    </td>
                    <td>
                        <label for="chk_add_login" id="gross_paymonth" title="Check">
                           Gross Pay/Month	</label>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td>
                        <input id="txt_grosspay" type="text" name="Notice" class="form-control"  disabled="disabled" />
                    </td>
                    <td>
                        <label for="chk_add_login" id="Label1" title="Check">
                           Appraisal</label>
                    </td>
                    <td style="width: 6px;">
                    </td>
                    <td>
                        <input id="txt_Appraisal" onchange="aprisalchange();" type="text" name="Notice" placeholder="Enter Appraisal" class="form-control" />
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <table class="tablecenter" width="98%">
                <tr>
                    <td colspan="2" style="padding-left: 18px;" width="40%">
                     <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Earnings/Month
                </h3>
            </div>
            <div class="box-body">

                                <table align="left" width="65%">
                                    <tr>
                                        <td style="height: 40px;">
                                           Basic
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_ernbasic" readonly  />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            House Rent Allowance
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_HousingRent"  readonly />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            Conveyance
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control" id="txt_Converance"  readonly  />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            Medical Earnings
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_Medical" readonly  />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                           Washing Allowance
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control" id="txt_WashingAllowance" readonly  />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                    <td style="height: 40px; display:none">
                                            Salarymode
                                        </td>
                                        <td style="display:none">
                                            <input type="text"  class="form-control" id="textsalarymode"   />
                                             
                                        </td>
                                        <td style="height: 40px;">
                                            Total Earnings
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control"  id="txt_TotalEarnings"  readonly />
                                             
                                        </td>
                                    </tr>
                                </table>
                                </div>
                                </div>
                                </section>
                           
                        </td>
                        
                        <td colspan="2" width="50%" style="padding-left:18px;">
                            <section class="content">
    <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Deduction/Month
                </h3>
            </div>
            <div class="box-body">

                                <table width="60%" align="left">
                                    <tr>
                                        <td style="height: 40px;">
                                            Provident Fund
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control" id="txt_debBasic" readonly  />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                              Professional Tax
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control" id="txt_professinaltax" readonly />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            ESI
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control" id="txt_Esi" readonly  />
                                             
                                        </td>
                                    </tr>
                                   <tr>
                                        <td style="height: 40px;">
                                            Income Tax
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_Incometax" readonly  />
                                             
                                        </td>
                                    </tr>
                                    <tr>
                                    <td style="height: 40px;">
                                             Canteen Deduction
                                        </td>
                                        <td>
                                            <input type="text"  class="form-control" id="txt_canteendeduction" readonly  />
                                             
                                        </td>
                                        </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            Total Deductions
                                        </td >
                                        <td>
                                            <input type="text"  class="form-control" id="txt_Totaldeduction" readonly  />
                                             
                                        </td>
                                    </tr>
                                </table>
                                </div>
                          </div>
                          </section>
                        </td>
                    </tr>
                </table>
                    <table align="center">
                        <tr>
                            <td style="height: 40px;">
                                Net Salary
                            </td>
                            <td>
                                <input type="text"  class="form-control" id="txt_netsalary" readonly />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="save_Apprasial_Salary_click();" />
                                <input type="button" class="btn btn-danger" id="close_id" value="Close" onclick="canceldetails()"  />
                            </td>
                        </tr>
            </table>
            <table class="tablecenter" width="98%">
                <tr>
                    <td align="center" style="padding-top: 10px; height: 15px;">
                        <asp:Label ID="lblMsg" runat="server" Font-Bold="True"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
        </div>
        </div>
        </section>
    </div>
     <div id="divaddemp" style="text-align: center;">
                <table align="center">
                    <tr>
                        <td>
                            <input id="txt_empname1" type="text" class="form-control"
                                class="form-control" name="vendorcode" placeholder="Search Employee Name" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            OR
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <input id="txtempCode" type="text" class="form-control"
                                class="form-control" name="vendorcode" placeholder="Search Employee Code" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <i class="fa fa-search" aria-hidden="true">Search</i>
                        </td>
                        <td style="width: 300px">
                        </td>
                        <%--<td>
                            <input id="add_employee" type="button" class="btn btn-primary" name="submit" value="Add Employee Paystructure">
                        </td>--%>
                    </tr>
                </table>
            </div>
            <div id="divbinddata">
    </div>
    </section>
    </div>


</asp:Content>
