<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Emppaystructure.aspx.cs" Inherits="EmpSalaryDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#add_employee').click(function () {
                $('#divpanel').css('display', 'block');
                $('#divbinddata').css('display', 'none');
                $('#divaddemp').css('display', 'none');
                get_Dept_details();
                get_Employeedetails();
            });
            $('#close_id').click(function () {
                $('#divpanel').css('display', 'none');
                $('#divbinddata').css('display', 'block');
                $('#divaddemp').css('display', 'block');
            });
            get_paystructured_details();
        });
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
        function isFloat(evt) {
            var charCode = (event.which) ? event.which : event.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            else {
                //if dot sign entered more than once then don't allow to enter dot sign again. 46 is the code for dot sign
                var parts = evt.srcElement.value.split('.');
                if (parts.length > 1 && charCode == 46)
                    return false;
                return true;
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
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
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
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                    document.getElementById('txtempcode1').value = employeedetails[i].empnum;
                }
            }
            var empid = document.getElementById('txtsupid').value;
            var empcode1 = document.getElementById('txtempcode1').value;
            var data = { 'op': 'get_employewise_deptdetails', 'empid': empid, 'empcode1': empcode1 };
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

        function totalchange() {
            var employeid = document.getElementById('txtsupid').value;
            var empcode1 = document.getElementById('txtempcode1').value;
            var salarymode = "";
            var pfeligible = " ";
            var esieligible = "";
            var salary = 0;
            for (var i = 0; i < employee_data.length; i++) {
                if (employeid == employee_data[i].empsno) {
                    salarymode = employee_data[i].salarymode;
                    var Fixed = 0;
                    var Percentage = 0;
                    if (salarymode == 0) {
                        var gross = document.getElementById('txt_Gross').value;
                        var sal = 50;
                        erbasic = (parseFloat(gross) * parseFloat(sal)) / 100;
                        document.getElementById('txt_ernbasic').value = erbasic;
                        var erbasic = document.getElementById('txt_ernbasic').value;
                        if (employee_data[i].pfeligible == "No") {
                            document.getElementById('txt_PF').value = 0;
                        }
                        else {
                            var pf = 12;
                            providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                            if (providentfound > 1800) {
                                document.getElementById('txt_PF').value = 1800;
                            }
                            else {
                                document.getElementById('txt_PF').value = providentfound;
                            }
                        }
                        var mediclaimdeduction = document.getElementById('txt_Mediclaim').value;
                        var tdsdeduction = document.getElementById('txt_Tds').value;
                        var erbasic = document.getElementById('txt_ernbasic').value;
                        //document.getElementById('txt_PF').value = providentfound;
                        if (employee_data[i].esieligible == "No") {
                            document.getElementById('txt_Esi').value = 0;
                        }
                        else {
                            var esiper = 1.75;
                            esi = (parseFloat(gross) * parseFloat(esiper)) / 100;
                        }
                        document.getElementById('txt_Esi').value = esi;

                        if (gross > 7500) {
                            var medical = 1250;
                            document.getElementById('txt_Medical').value = medical;
                            var conveyance = 1600;
                            document.getElementById('txt_Converance').value = conveyance;
                            var washingallowance = 1000;
                            document.getElementById('txt_WashingAllowance').value = washingallowance;
                        }
                        else {
                            var medil = 10;
                            var medical = (parseFloat(gross) * parseFloat(medil)) / 100;
                            document.getElementById('txt_Medical').value = medical;
                            var convi = 20;
                            var conveyance = (parseFloat(gross) * parseFloat(convi)) / 100;
                            document.getElementById('txt_Converance').value = conveyance;
                            var wash = 10;
                            var washingallowance = (parseFloat(gross) * parseFloat(wash)) / 100;
                            document.getElementById('txt_WashingAllowance').value = washingallowance;
                        }
                        var tot = 0;
                        var conveyance = document.getElementById('txt_Converance').value;
                        var medical = document.getElementById('txt_Medical').value;
                        var washingallowance = document.getElementById('txt_WashingAllowance').value;
                        var erbasic = document.getElementById('txt_ernbasic').value;
                        tot = parseInt(medical) + parseInt(conveyance) + parseInt(washingallowance) + parseInt(erbasic);
                        var hre = 0;
                        hre = parseInt(gross) - parseInt(tot);
                        if (hre > 0) {
                            document.getElementById('txt_HousingRent').value = hre;
                        }
                        else {
                            var hre1 = "0";
                            document.getElementById('txt_HousingRent').value = 0;
                        }

                        var gross = document.getElementById('txt_Gross').value;
                        var sal = (parseFloat(gross) * 12);
                        document.getElementById('txt_sal').value = sal;

                        var professionaltax = 0;
                        var employeid = document.getElementById('txtsupid').value;
                        var statename = "";
                        for (var i = 0; i < employee_data.length; i++) {
                            if (employeid == employee_data[i].empsno) {
                                statename = employee_data[i].statename;
                                if (statename == "AndraPrdesh") {
                                    if (gross > 1000 && gross <= 15000) {
                                        professionaltax = "0";
                                    }
                                    else if (gross >= 15001 && gross <= 20000) {
                                        professionaltax = "150";
                                    }
                                    else if (gross >= 20001) {
                                        professionaltax = "200";
                                    }
                                }
                                if (statename == "Tamilnadu") {
                                    if (gross < 7000) {
                                        professionaltax = "0";
                                    }
                                    else if (gross >= 7001 && gross <= 10000) {
                                        professionaltax = "115";
                                    }
                                    else if (gross >= 10001 && gross <= 11000) {
                                        professionaltax = "171";
                                    }
                                    else if (gross >= 11001 && gross <= 1200) {
                                        professionaltax = "171";
                                    }
                                    else if (gross >= 12001) {
                                        professionaltax = "208";
                                    }
                                }
                                if (statename == "karnataka") {
                                    if (gross <= 15000 && gross <= 15001) {
                                        professionaltax = "0";
                                    }
                                    else if (gross >= 15001) {
                                        professionaltax = "200";
                                    }
                                }
                                document.getElementById('txt_professinaltax').value = professionaltax;
                            }
                        }
                    }
                }
                else {
                    salarymode == "1";
                    var gross = document.getElementById('txt_Gross').value;
                    var sal = (parseFloat(gross) * 12);
                    document.getElementById('txt_sal').value = sal;
                    erbasic = "0";
                    document.getElementById('txt_ernbasic').value = erbasic;
                    var providentfound = "0";
                    document.getElementById('txt_PF').value = providentfound;
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
                    var esi = "0";
                    document.getElementById('txt_Esi').value = esi;
                    var mediclaimdeduction = "0";
                    document.getElementById('txt_Mediclaim').value = mediclaimdeduction;
                    var tdsdeduction = "0";
                    document.getElementById('txt_Tds').value = tdsdeduction;
                }
            }
        }
        function save_edit_Salary_click() {
            var department = document.getElementById('selct_department').value;
            if (department == "") {
                alert("Select department ");
                return false;
            }
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                alert("Select Employee Name ");
                return false;
            }
            var empcode1 = document.getElementById('txtempcode1').value;
            var gross = document.getElementById('txt_Gross').value;
            if (gross == "") {
                alert("Enter salary ");
                return false;
            }
            var erbasic = document.getElementById('txt_ernbasic').value;
            var hre = document.getElementById('txt_HousingRent').value;
            var conveyance = document.getElementById('txt_Converance').value;
            var medical = document.getElementById('txt_Medical').value;
            var providentfound = document.getElementById('txt_PF').value;
            var professionaltax = document.getElementById('txt_professinaltax').value;
            var esi = document.getElementById('txt_Esi').value;
            var incometax = document.getElementById('txt_Incometax').value;
            var travelconveyance = document.getElementById('txt_TravelConveyance').value;
            var mediclaimdeduction = document.getElementById('txt_Mediclaim').value;
            var washingallowance = document.getElementById('txt_WashingAllowance').value;
            var tdsdeduction = document.getElementById('txt_Tds').value;
            var salaryPer = document.getElementById('txt_sal').value;
            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_edit_Salary_click', 'department': department, 'employeid': employeid, 'empcode1': empcode1, 'gross': gross, 'erbasic': erbasic, 'hre': hre, 'conveyance': conveyance, 'medical': medical, 'providentfound': providentfound, 'professionaltax': professionaltax, 'esi': esi, 'incometax': incometax, 'washingallowance': washingallowance, 'mediclaimdeduction': mediclaimdeduction, 'travelconveyance': travelconveyance, 'tdsdeduction': tdsdeduction, 'salaryPer': salaryPer, 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        //forclearall();
                        get_paystructured_details();
                        $('#divpanel').css('display', 'none');
                        $('#divaddemp').css('display', 'block');
                        $('#divbinddata').show();
                        canceldetails();
                    }

                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
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
                        totalchange();
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
                results += '<td data-title="status" style="display:none" class="19">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="20">' + msg[i].sno + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#divbinddata").html(results);
        }


        function getme(thisid) {
            $('#divpanel').css('display', 'block');
            $('#divaddemp').css('display', 'none');
            $('#divbinddata').hide();
            totalchange();
            var empcode1 = $(thisid).parent().parent().children('.1').html();
            var fullname = $(thisid).parent().parent().children('.2').html();
            var department = $(thisid).parent().parent().children('.3').html();
            var gross = $(thisid).parent().parent().children('.4').html();
            var erningbasic = $(thisid).parent().parent().children('.5').html();
            var profitionaltax = $(thisid).parent().parent().children('.6').html();
            var esi = $(thisid).parent().parent().children('.7').html();
            var incometax = $(thisid).parent().parent().children('.8').html();
            var hra = $(thisid).parent().parent().children('.9').html();
            var conveyance = $(thisid).parent().parent().children('.10').html();
            var medicalearning = $(thisid).parent().parent().children('.11').html();
            var pf = $(thisid).parent().parent().children('.12').html();
            var washingallowance = $(thisid).parent().parent().children('.13').html();
            var mediclaimdeduction = $(thisid).parent().parent().children('.14').html();
            var tdsdeduction = $(thisid).parent().parent().children('.15').html();
            var salaryperyear = $(thisid).parent().parent().children('.16').html();
            var travelconveyance = $(thisid).parent().parent().children('.17').html();
            var departmentid = $(thisid).parent().parent().children('.18').html();
            var employeid = $(thisid).parent().parent().children('.19').html();
            var sno = $(thisid).parent().parent().children('.20').html();
            document.getElementById('selct_department').value = departmentid;
            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txt_Gross').value = gross;
            document.getElementById('txt_ernbasic').value = erningbasic;
            document.getElementById('txt_HousingRent').value = hra;
            document.getElementById('txt_Converance').value = conveyance;
            document.getElementById('txt_Medical').value = medicalearning;
            document.getElementById('txt_professinaltax').value = profitionaltax;
            document.getElementById('txt_PF').value = pf;
            document.getElementById('txt_Esi').value = esi;
            document.getElementById('txt_Incometax').value = incometax;
            document.getElementById('txt_TravelConveyance').value = travelconveyance;
            document.getElementById('txt_WashingAllowance').value = washingallowance;
            document.getElementById('txt_Tds').value = tdsdeduction;
            document.getElementById('txt_sal').value = salaryperyear;
            document.getElementById('txtsupid').value = employeid;
            document.getElementById('txt_Mediclaim').value = mediclaimdeduction;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('txtempcode1').value = empcode1;
            document.getElementById('btn_save').value = "Modify";
        }
        var compiledList = [];
        function filldata(msg) {
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
            totalchange();
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
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }

                $("#divbinddata").html(results);
            }
            else {
                totalchange();
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
            totalchange();
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
                    totalchange();
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }

                results += '</table></div>';
                $("#divbinddata").html(results);
            }

            else {
                totalchange();
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
                        totalchange();
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }

                $("#divbinddata").html(results);
            }
        }

        function canceldetails() {
            document.getElementById('selct_department').selectedIndex = 0;
            document.getElementById('selct_employe').value = "";
            document.getElementById('txt_Gross').value = "";
            document.getElementById('txt_ernbasic').value = "";
            document.getElementById('txt_HousingRent').value = "";
            document.getElementById('txt_Converance').value = "";
            document.getElementById('txt_Medical').value = "";
            document.getElementById('txt_professinaltax').value = "";
            document.getElementById('txt_PF').value = "";
            document.getElementById('txt_Esi').value = "";
            document.getElementById('txt_Incometax').value = "";
            document.getElementById('txt_TravelConveyance').value = "";
            document.getElementById('txt_WashingAllowance').value = "";
            document.getElementById('txt_Tds').value = "";
            document.getElementById('txt_sal').value = "";
            document.getElementById('btn_save').value = "Save";
            totalchange();
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Paystructure Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Employee Paystructure Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Paystructure Details
                </h3>
            </div>
            <div id="divaddemp" style="text-align: center;">
                <table align="center">
                    <tr>
                        <td>
                            <input id="txt_empname1" type="text" style="height: 28px; opacity: 1.0; width: 200px;"
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
                            <input id="txtempCode" type="text" style="height: 28px; opacity: 1.0; width: 180px;"
                                class="form-control" name="vendorcode" placeholder="Search Employee Code" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <i class="fa fa-search" aria-hidden="true">Search</i>
                        </td>
                        <td style="width: 300px">
                        </td>
                        <td>
                            <input id="add_employee" type="button" class="btn btn-primary" name="submit" value="Add Employee Paystructure">
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divbinddata">
            </div>
            <div class="box-body" id="divpanel" style="display: none;">
                <asp:UpdatePanel ID="Up1" runat="server">
                    <ContentTemplate>
                        <div class="row-fluid">
                            <div style="padding-left: 150px;">
                                <table id="tblAppraisals" runat="server" class="tablecenter" width="98%">
                                    <tr>
                                        <td>
                                            Department
                                        </td>
                                        <td>
                                            <select id="selct_department" class="form-control">
                                                <option selected disabled value="Select Department">Select Department</option>
                                            </select>
                                        </td>
                                        <td style="width: 6px;">
                                        </td>
                                        <td>
                                            Employee Name
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name"/>
                                        </td>
                                        <td style="height: 40px;">
                                            <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                        </td>
                                         <td style="height: 40px;">
                                <input id="txtempcode1" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 40px;">
                                            Salary(pa)
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_sal" placeholder="Enter salary" onkeypress="return isNumber(event)"/>
                                        </td>
                                        <td style="width: 6px;">
                                        </td>
                                        <td style="height: 40px;">
                                            Gross salary(per Month)/Day Amount
                                        </td>
                                        <td>
                                            <input type="text" class="form-control" id="txt_Gross" onchange="totalchange();"
                                                placeholder="Enter Month Salary" onkeypress="return isNumber(event)" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div id="divappraisalls" runat="server">
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
                                                                <input type="text" class="form-control" id="txt_ernbasic" placeholder="Enter Basic" onkeypress="return isNumber(event)" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                HRA
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_HousingRent" placeholder="Enter House Rent Allowance" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                Conveyance
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_Converance" placeholder="Enter Conveyance" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                Medical Earnings
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_Medical" placeholder="Enter Special Conveyance" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                Washing Allowance
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_WashingAllowance" placeholder="Enter Washing Allowance" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </section>
                                    </td>
                                    <td colspan="2" width="50%" style="padding-left: 18px;">
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
                                                                <input type="text" class="form-control" id="txt_PF" placeholder="Enter Basic" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                Professional Tax
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_professinaltax" placeholder="Enter Professional Tax" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                ESI
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_Esi" placeholder="Enter ESI" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                                Income Tax
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_Incometax" placeholder="Enter Income Tax" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                               Travel Conveyance
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_TravelConveyance" placeholder="Enter Travel Conveyance" onkeypress="return isNumber(event)" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                               Mediclaim Deduction
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_Mediclaim" placeholder="Enter  Mediclaim Deduction" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="height: 40px;">
                                                              TDS Deduction
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control" id="txt_Tds" placeholder="Enter  TDS Deduction" onkeypress="return isNumber(event)"/>
                                                            </td>
                                                        </tr>
                                                        <tr hidden>
                                                             <td>
                                                                <label id="lbl_sno">
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </section>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div>
                            <table align="center">
                                <tr>
                                    <td>
                                        <input type="button" class="btn btn-primary" id="btn_save" value="Save" onclick="save_edit_Salary_click();" />
                                        <input type="button" class="btn btn-danger" id="close_id" value="Close" onclick="canceldetails();" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </section>
</asp:Content>
