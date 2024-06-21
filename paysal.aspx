<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="paysal.aspx.cs" Inherits="paysal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="css/fieldset.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Dept_details();
        });
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
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
        var employee_data = [];
        var employeedetails = [];
        function ddldepartmentchange() {
            get_Employeedetails();
        }
        function get_Employeedetails() {
            //document.getElementById('selct_employe').options.length = null;
            var deptid = document.getElementById('selct_department').value;
            var data = { 'op': 'get_deptemploye_details', 'deptid': deptid };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    employee_data = msg;
                    var availableTags = [];
                    for (i = 0; i < msg.length; i++) {
                        availableTags.push(msg[i].empname);
                    }
                    $("#selct_employe").autocomplete({
                        source: function (req, responseFn) {
                            var re = $.ui.autocomplete.escapeRegex(req.term);
                            var matcher = new RegExp("^" + re, "i");
                            var a = $.grep(availableTags, function (item, index) {
                                return matcher.test(item);
                            });
                            responseFn(a);
                        },
                        change: ravi,
                        // change: emplochenage,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function ravi() {
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                    get_salary_fill_Details();
                }
            }
        }
        function get_salary_fill_Details() {
            var empid = document.getElementById('txtsupid').value;
            var data = { 'op': 'get_paysalary_Details', 'empid': empid };
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
                document.getElementById('txtmobile').value = msg[i].mobilededuction;
                document.getElementById('txtsalad').value = msg[i].salaryadvance;
                
                document.getElementById('txtmedicliem').value = msg[i].mediclaimdeduction;
                document.getElementById('txtotherdeduction').value = msg[i].otherdeduction;
                document.getElementById('txttdsdeduction').value = msg[i].tdsdeduction;
                document.getElementById('txtloan').value = msg[i].loanamount;

                document.getElementById('spnot').innerHTML = msg[i].otdays;
                document.getElementById('Spnnoofworkingdays').innerHTML = msg[i].noofworkingdays;
                document.getElementById('txt_empeffectivedays').value = msg[i].effectivedays;
                document.getElementById('txt_daysinmonth').value = msg[i].daysinmonth;
                document.getElementById('txt_attendencedays').value = msg[i].noofdayspaid;
                document.getElementById('txt_empworkdays').value = msg[i].noofdayspaid;
                document.getElementById('txt_lop').value = msg[i].lop;
                document.getElementById('txt_cloff').value = msg[i].cloroff;
            }
            totalchange();
        }
        function totalchange() {
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
            var mobilededuct = document.getElementById('txtmobile').value;
            var saladvance = document.getElementById('txtsalad').value;

            var medicliem = document.getElementById('txtmedicliem').value;
            var otherdeduction = document.getElementById('txtotherdeduction').value;
            var tdsdeduction = document.getElementById('txttdsdeduction').value;
            var loandeduction = document.getElementById('txtloan').value;

            var salarymode = "";
            var pfno = "";
            var esino = "";
            for (var i = 0; i < employee_data.length; i++) {
                if (employeid == employee_data[i].empsno) {
                    salarymode = employee_data[i].salarymode;
                    pfno = employee_data[i].pfeligible;
                    esino = employee_data[i].esieligible;
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
                            document.getElementById('txt_ernbasic').value = Math.round(erbasic);
                            var erbasic = document.getElementById('txt_ernbasic').value;
                            if (pfno == "No") {
                                providentfound = 0;
                            }
                            else {
                                var pf = 12;
                                providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                            }
                            document.getElementById('txt_debBasic').value = providentfound;
                            var erbasic = document.getElementById('txt_ernbasic').value;
                            if (esino == "No") {
                                esi = 0;
                            }
                            else {
                                var esiper = 1.75;
                                esi = (parseFloat(totalsal) * parseFloat(esiper)) / 100;
                            }
                            document.getElementById('txt_Esi').value = esi;
                            var cantendeductin = cantin;
                            var salaryadvance = saladvance;
                            var mobilededuction = mobilededuct;
                            var incometax = tdsdeduction;
                            var medicliem = medicliem;
                            var loandeduction = loandeduction;
                            var otherdeduction = otherdeduction;
                            document.getElementById('txt_canteendeduction').value = cantendeductin;
                            document.getElementById('txt_Incometax').value = incometax;
                            document.getElementById('txt_mobilededuction').value = mobilededuction;
                            document.getElementById('txt_salaryadvance').value = salaryadvance;
                            document.getElementById('txt_medicliem').value = medicliem;
                            document.getElementById('txt_loan').value = loandeduction;
                            document.getElementById('txt_otherdeduction').value = otherdeduction;
                            var medical = 1250;
                            var grossmedicalallavance = 1250;
                            document.getElementById('txt_Medical').value = medical;
                            var conveyance = 1600;
                            var grossconveyanceallavance = conveyance;
                            document.getElementById('txt_Converance').value = conveyance;
                            var washing = 1000;
                            var grosswashingallowance = washing;
                            document.getElementById('txt_WashingAllowance').value = washing;
                            var tot = 0;
                            var conveyance = document.getElementById('txt_Converance').value;
                            var medical = document.getElementById('txt_Medical').value;
                            var washingallowance = document.getElementById('txt_WashingAllowance').value;
                            var erbasic = document.getElementById('txt_ernbasic').value;
                            tot = parseInt(medical) + parseInt(conveyance) + parseInt(washing) + parseInt(erbasic);
                            var ghtotal = parseInt(grossbasic) + parseInt(grossconveyanceallavance) + parseInt(grosswashingallowance) + parseInt(grossmedicalallavance);
                            var grosshra = parseInt(salary) - parseInt(ghtotal);
                            var hre = 0;
                            hre = parseInt(totalsal) - parseInt(tot);
                            if (hre > 0) {
                                document.getElementById('txt_HousingRent').value = hre;
                            }
                            else {
                                var hre1 = "0";
                                document.getElementById('txt_HousingRent').value = 0;
                            }
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
                                    document.getElementById('txt_professinaltax').value = professionaltax;
                                }
                                var totalernings = tot + hre;
                                var grosstotalernings = ghtotal + grosshra;
                                document.getElementById('txt_TotalEarnings').value = totalernings;
                                var totaldeduction = parseFloat(professionaltax) + parseFloat(providentfound) + parseFloat(esi) + parseFloat(cantendeductin) + parseFloat(incometax) + parseFloat(medicliem) + parseFloat(loandeduction) + parseFloat(otherdeduction) + parseFloat(mobilededuction) + parseFloat(salaryadvance);
                                document.getElementById('txt_Totaldeduction').value = Math.round(totaldeduction);
                                var netsal = totalernings - totaldeduction;
                                document.getElementById('txt_netsalary').value = Math.round(netsal);
                            }
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
                            document.getElementById('txt_ernbasic').value = Math.round(erbasic);
                            var erbasic = document.getElementById('txt_ernbasic').value;
                            if (pfno == "No") {
                                providentfound = 0;
                            }
                            else {
                                var pf = 12;
                                providentfound = (parseFloat(erbasic) * parseFloat(pf)) / 100;
                            }
                            document.getElementById('txt_debBasic').value = providentfound;
                            
                            if (esino == "No") {
                                esi = 0;
                            }
                            else {
                                var esif = 1.75;
                                esi = (parseFloat(totalsal) * parseFloat(esif)) / 100;
                            }
                            document.getElementById('txt_Esi').value = esi;
                            var cantendeductin = cantin;
                            var salaryadvance = saladvance;
                            var mobilededuction = mobilededuct;
                            var incometax = tdsdeduction;
                            var medicliem = medicliem;
                            var loandeduction = loandeduction;
                            var otherdeduction = otherdeduction;
                            document.getElementById('txt_canteendeduction').value = cantendeductin;
                            document.getElementById('txt_Incometax').value = incometax;
                            document.getElementById('txt_mobilededuction').value = mobilededuction;
                            document.getElementById('txt_salaryadvance').value = salaryadvance;
                            document.getElementById('txt_medicliem').value = medicliem;
                            document.getElementById('txt_loan').value = loandeduction;
                            document.getElementById('txt_otherdeduction').value = otherdeduction;
                            var medical = 1250;
                            var perdaymedical = 1250 / noofdays;
                            var lossofmedical = lop * perdaymedical;
                            var medicalallavance = medical - lossofmedical;
                            var grossmedicalallavance = 1250;
                            document.getElementById('txt_Medical').value = Math.round(medicalallavance);

                            var conveyance = 1600;
                            var perdayconveyance = 1600 / noofdays;
                            var lossofconveyance = lop * perdayconveyance;
                            var conveyanceallavance = conveyance - lossofconveyance;
                            var grossconveyanceallavance = 1600;
                            document.getElementById('txt_Converance').value = Math.round(conveyanceallavance);

                            var washing = 1000;
                            var perdaywashing = 1000 / noofdays;
                            var lossofwashing = lop * perdaywashing;
                            var washingallowance = washing - lossofwashing;
                            var grosswashingallowance = 1000;
                            document.getElementById('txt_WashingAllowance').value = Math.round(washingallowance);
                            var tot = 0;
                            tot = parseInt(medicalallavance) + parseInt(conveyanceallavance) + parseInt(washingallowance) + parseInt(erbasic);
                            var ghtotal = parseInt(grossbasic) + parseInt(grossconveyanceallavance) + parseInt(grosswashingallowance) + parseInt(grossmedicalallavance);
                            var grosshra = parseInt(salary) - parseInt(ghtotal);
                            var hre = 0;
                            hre = parseInt(totalsal) - parseInt(tot);
                            if (hre > 0) {
                                document.getElementById('txt_HousingRent').value = hre;
                            }
                            else {
                                var hre1 = "0";
                                document.getElementById('txt_HousingRent').value = 0;
                            }
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
                                    document.getElementById('txt_professinaltax').value = professionaltax;
                                }
                                var totalernings = tot + hre;
                                var grosstotalernings = ghtotal + grosshra;
                                document.getElementById('txt_TotalEarnings').value = totalernings;
                                var totaldeduction = parseFloat(professionaltax) + parseFloat(providentfound) + parseFloat(esi) + parseFloat(cantendeductin) + parseFloat(incometax) + parseFloat(medicliem) + parseFloat(loandeduction) + parseFloat(otherdeduction) + parseFloat(mobilededuction) + parseFloat(salaryadvance);
                                document.getElementById('txt_Totaldeduction').value = Math.round(totaldeduction);
                                var netsal = totalernings - totaldeduction;
                                document.getElementById('txt_netsalary').value = Math.round(netsal);
                            }
                        }
                    }
                    else {
                        var salary = monthsal;
                        var perdayamount = salary / noofdays;
                        var otvalue = ot * perdayamount;
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
                        var esi = "0";
                        document.getElementById('txt_Esi').value = esi;
                        var totalotval = salary + otvalue;
                        document.getElementById('txt_netsalary').value = Math.round(totalotval);
                        var cantendeductin = 0;

                    }
                }
                if (lop == "0") {
                    document.getElementById('spnempcodedetails').innerHTML = empcode;
                    document.getElementById('spnempnamedetails').innerHTML = empname;

                    document.getElementById('spnformonthdetails').innerHTML = monthname;
                    document.getElementById('spnfornoofdaysdetails').innerHTML = noofdays;

                    document.getElementById('spndayspaiddetails').innerHTML = noofdayspaid;
                    document.getElementById('spnlopdetails').innerHTML = lop;

                    document.getElementById('spnyeardetails').innerHTML = year;
                    document.getElementById('spnmonthdetails').innerHTML = monthname;

                    document.getElementById('lblactbasic').innerHTML = grossbasic;
                    document.getElementById('lblmonthbasic').innerHTML = erbasic;

                    document.getElementById('lblacthra').innerHTML = grosshra;
                    document.getElementById('lblmonthhra').innerHTML = hre;
                    document.getElementById('lblmonthpf').innerHTML = providentfound;
                    document.getElementById('lblmonthpt').innerHTML = professionaltax;
                    // document.getElementById('lblactpt').innerHTML = 0;

                    document.getElementById('lblactconveyance').innerHTML = grossconveyanceallavance;
                    document.getElementById('lblmonthconveyance').innerHTML = conveyance;
                    //document.getElementById('lblactesi').innerHTML = esi;
                    document.getElementById('lblmonthesi').innerHTML = esi;

                    document.getElementById('lblactmedical').innerHTML = grossmedicalallavance;
                    document.getElementById('lblmonthmedical').innerHTML = medical;

                    // document.getElementById('lblactincometax').innerHTML = incometax;
                    document.getElementById('lblmonthincometax').innerHTML = incometax;

                    document.getElementById('lblactwashing').innerHTML = grosswashingallowance;
                    document.getElementById('lblmonthwashing').innerHTML = washing;

                    //document.getElementById('lblactcanteen').innerHTML = cantendeductin;
                    document.getElementById('lblmonthcanteen').innerHTML = cantendeductin;

                    document.getElementById('lblacttotalearnings').innerHTML = grosstotalernings;
                    document.getElementById('lblmonthtotalearnings').innerHTML = totalernings;

                    // document.getElementById('lblacttotaldeduction').innerHTML = 0;
                    document.getElementById('lblmonthtotaldeduction').innerHTML = Math.round(totaldeduction);
                    var totalnetpay = totalernings - totaldeduction;
                    document.getElementById('lblnetpay').innerHTML = Math.round(totalnetpay);
                }
                else {
                    document.getElementById('spnempcodedetails').innerHTML = empcode;
                    document.getElementById('spnempnamedetails').innerHTML = empname;

                    document.getElementById('spnformonthdetails').innerHTML = monthname;
                    document.getElementById('spnfornoofdaysdetails').innerHTML = noofdays;

                    document.getElementById('spndayspaiddetails').innerHTML = noofdayspaid;
                    document.getElementById('spnlopdetails').innerHTML = lop;

                    document.getElementById('spnyeardetails').innerHTML = year;
                    document.getElementById('spnmonthdetails').innerHTML = monthname;

                    document.getElementById('lblactbasic').innerHTML = grossbasic;
                    document.getElementById('lblmonthbasic').innerHTML = erbasic;

                    document.getElementById('lblacthra').innerHTML = grosshra;
                    document.getElementById('lblmonthhra').innerHTML = hre;

                    document.getElementById('lblmonthpf').innerHTML = providentfound;
                    // document.getElementById('lblactpf').innerHTML = 0;

                    document.getElementById('lblmonthpt').innerHTML = professionaltax;
                    // document.getElementById('lblactpt').innerHTML = 0;

                    document.getElementById('lblactconveyance').innerHTML = grossconveyanceallavance;
                    document.getElementById('lblmonthconveyance').innerHTML = Math.round(conveyanceallavance);
                    //document.getElementById('lblactesi').innerHTML = esi;
                    document.getElementById('lblmonthesi').innerHTML = esi;

                    document.getElementById('lblactmedical').innerHTML = grossmedicalallavance;
                    document.getElementById('lblmonthmedical').innerHTML = Math.round(medicalallavance);

                    // document.getElementById('lblactincometax').innerHTML = incometax;
                    document.getElementById('lblmonthincometax').innerHTML = incometax;

                    document.getElementById('lblactwashing').innerHTML = grosswashingallowance;
                    document.getElementById('lblmonthwashing').innerHTML = Math.round(washingallowance);

                    //document.getElementById('lblactcanteen').innerHTML = cantendeductin;
                    document.getElementById('lblmonthcanteen').innerHTML = cantendeductin;

                    document.getElementById('lblacttotalearnings').innerHTML = grosstotalernings;
                    document.getElementById('lblmonthtotalearnings').innerHTML = totalernings;

                    // document.getElementById('lblacttotaldeduction').innerHTML = 0;
                    document.getElementById('lblmonthtotaldeduction').innerHTML = Math.round(totaldeduction);
                    var totalnetpay = totalernings - totaldeduction;
                    document.getElementById('lblnetpay').innerHTML = Math.round(totalnetpay);
                }
            }
        }

        function save_payrollhold_click() {
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                alert("Select Employee Name ");
                return false;
            }
            var deptid = document.getElementById('selct_department').value;
            var monthsal = document.getElementById('txtmonthsal').value;
            var basicsal = document.getElementById('txt_ernbasic').value;
            var hra = document.getElementById('txt_HousingRent').value;
            var conveyance = document.getElementById('txt_Converance').value;
            var medicalernings = document.getElementById('txt_Medical').value;
            var washingallavance = document.getElementById('txt_WashingAllowance').value;
            var totalEarnings = document.getElementById('txt_TotalEarnings').value;
            var pf = document.getElementById('txt_debBasic').value;
            var profitionaltax = document.getElementById('txt_professinaltax').value;
            var esi = document.getElementById('txt_Esi').value;
            var incometax = document.getElementById('txt_Incometax').value;
            var canteendeduction = document.getElementById('txt_canteendeduction').value;
            var mobilededuction = document.getElementById('txt_mobilededuction').value;
            var salaryadvance = document.getElementById('txt_salaryadvance').value;

            var medicliem = document.getElementById('txt_medicliem').value;
            var loandeduction = document.getElementById('txt_loan').value;
            var otherdeduction =  document.getElementById('txt_otherdeduction').value;

            var extradays = document.getElementById('txt_Extradays').value;
            var otdays = document.getElementById('txt_Otdays').value;
            var totaldeduction = document.getElementById('txt_Totaldeduction').value;
            var noofdays = document.getElementById('Spnnoofdays').innerHTML;
            var lop = document.getElementById('Spnlop').innerHTML;
            var presentdays = noofdays - lop;
            var month = document.getElementById('Spnmonth').innerHTML;
            var year = document.getElementById('txtyear').value;
            var btnval = document.getElementById('btn_hold').value;
            var data = { 'op': 'save_payrollhold_click', 'employeid': employeid, 'deptid': deptid, 'monthsal': monthsal, 'basicsal': basicsal, 'hra': hra, 'conveyance': conveyance, 'medicalernings': medicalernings, 'washingallavance': washingallavance, 'totalEarnings': totalEarnings, 'pf': pf, 'profitionaltax': profitionaltax, 'esi': esi, 'incometax': incometax, 'canteendeduction': canteendeduction, 'noofdays': noofdays, 'lop': lop, 'presentdays': presentdays, 'totaldeduction': totaldeduction, 'month': month, 'year': year, 'mobilededuction': mobilededuction, 'salaryadvance': salaryadvance, 'extradays': extradays, 'otdays': otdays, 'medicliem': medicliem, 'loandeduction': loandeduction, 'otherdeduction': otherdeduction, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert("Employee payroll details successfully added");
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


        function save_payrollSalary_click() {
            var employeid = document.getElementById('txtsupid').value;
            var deptid = document.getElementById('selct_department').value;
            var monthsal = document.getElementById('txtmonthsal').value;
            var basicsal = document.getElementById('txt_ernbasic').value;
            var hra = document.getElementById('txt_HousingRent').value;
            var conveyance = document.getElementById('txt_Converance').value;
            var medicalernings = document.getElementById('txt_Medical').value;f
            var washingallavance = document.getElementById('txt_WashingAllowance').value;
            var totalEarnings = document.getElementById('txt_TotalEarnings').value;
            var pf = document.getElementById('txt_debBasic').value;
            var profitionaltax = document.getElementById('txt_professinaltax').value;
            var esi = document.getElementById('txt_Esi').value;
            var incometax = document.getElementById('txt_Incometax').value;
            var canteendeduction = document.getElementById('txt_canteendeduction').value;
            var mobilededuction = document.getElementById('txt_mobilededuction').value;
            var mediclaimdeduction = document.getElementById('txt_Mediclaim').value;
            var salaryadvance = document.getElementById('txt_salaryadvance').value;
            var extradays = document.getElementById('txt_Extradays').value;
            var otdays = document.getElementById('txt_Otdays').value;
            var totaldeduction = document.getElementById('txt_Totaldeduction').value;
            var noofdays = document.getElementById('Spnnoofdays').innerHTML;
            var lop = document.getElementById('Spnlop').innerHTML;
            var presentdays = noofdays - lop;
            var month = document.getElementById('Spnmonth').innerHTML;
            var year = document.getElementById('txtyear').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_payrollSalary_click', 'employeid': employeid, 'deptid': deptid, 'monthsal': monthsal, 'basicsal': basicsal, 'hra': hra, 'conveyance': conveyance, 'medicalernings': medicalernings, 'washingallavance': washingallavance, 'totalEarnings': totalEarnings, 'pf': pf, 'profitionaltax': profitionaltax, 'esi': esi, 'incometax': incometax, 'canteendeduction': canteendeduction, 'noofdays': noofdays, 'lop': lop, 'presentdays': presentdays, 'totaldeduction': totaldeduction, 'month': month, 'year': year, 'mobilededuction': mobilededuction, 'salaryadvance': salaryadvance, 'mediclaimdeduction':mediclaimdeduction, 'extradays': extradays, 'otdays': otdays, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {

                        alert("Employee payroll details successfully added");
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

        function canceldetails() {
            document.getElementById('btn_save').value = "Save";
            document.getElementById('txtsupid').value = "";
            document.getElementById('selct_department').value = "";
            document.getElementById('txtmonthsal').value = "";
            document.getElementById('txt_ernbasic').value = "";
            document.getElementById('txt_HousingRent').value = "";
            document.getElementById('txt_Converance').value = "";
            document.getElementById('txt_Medical').value = "";
            document.getElementById('txt_WashingAllowance').value = "";
            document.getElementById('txt_TotalEarnings').value = "";
            document.getElementById('txt_debBasic').value = "";
            document.getElementById('txt_professinaltax').value = "";
            document.getElementById('txt_Esi').value = "";
            document.getElementById('txt_Incometax').value = "";
            document.getElementById('txt_canteendeduction').value = "";
            document.getElementById('txt_Totaldeduction').value = "";
            document.getElementById('txt_Mediclaim').value = "";
            document.getElementById('Spnnoofdays').innerHTML = "";
            document.getElementById('Spnlop').innerHTML = "";
            document.getElementById('Spnmonth').innerHTML = "";
            document.getElementById('txtyear').value = "";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;   class="fa fa-cog"></i>  Payroll Process
                </h3>
            </div>
    <div class="box-body" style="padding-left: 130px;">
        <table id="tbl_leavemanagement" class="inputstable">
            <tr>
                <td>
                    <label>
                        Department <span style="color: red;">*</span></label>
                </td>
                <td>
                    <select id="selct_department" class="form-control" onchange="ddldepartmentchange();"
                        style="width: 250px;">
                        <option selected disabled value="Select Department">Select Department</option>
                    </select>
                </td>
                <td style="width: 10px;">
                </td>
                <td>
                    <label>
                        Employee <span style="color: red;">*</span></label>
                </td>
                <td>
                    <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name " />
                </td>
                <td style="height: 40px;">
                    <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                </td>
                <td style="height: 40px;">
                    <input id="txtmonthsal" type="hidden" class="form-control" name="hiddenemployeid" />
                </td>
            </tr>
        </table>
    </div>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Payroll
                </h3>
            </div>
            <div class="box-body">
                <table id="tblDetails" runat="server" class="tablecenter" width="98%">
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
                    <tr style="display:none;">
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
                    <tr style="display:none;">
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
                            <span id="txtsalad" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtmobile" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtloan" style="color: Red;" /> 
                        </td>
                    </tr>
                     <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtmedicliem" style="color: Red;" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txtotherdeduction" style="color: Red;" />
                        </td>
                    </tr>
                     <tr style="display: none;">
                        <td style="width: 200px;">
                            <span id="txttdsdeduction" style="color: Red;" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </section>
    <section class="content" style="min-height: 131px !important;">
        <div class="col-md-6" style="width:33% !important; padding-left:0px !important;">
            <!-- AREA CHART -->
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Earning Details</h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="box-body no-padding">
                        <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info"
                            id="tbl_Cow_list">
                            <tr>
                                <td>
                                    Basic
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_ernbasic" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    House Rent Allowance
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_HousingRent" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Conveyance
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Converance" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Medical Earnings
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Medical" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Washing Allowance
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_WashingAllowance" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td style="display: none">
                                    <input type="text" class="inputBox" id="textsalarymode" />
                                </td>
                                <td style="height: 40px;">
                                    Total Earnings
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_TotalEarnings" readonly />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6" style="width:33% !important; padding-left:0px !important;">
            <!-- AREA CHART -->
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Deduction Details</h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="box-body no-padding">
                        <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info"
                            id="tbl_Buffalo_list">
                            <tr>
                                <td>
                                    Provident Fund
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_debBasic" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Professional Tax
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_professinaltax" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    ESI
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Esi" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Income Tax
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Incometax" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Canteen Deduction
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_canteendeduction" readonly />
                                </td>
                            </tr>
                            <tr>
                            <tr>
                                <td>
                                    Mobile Deduction
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_mobilededuction" readonly />
                                </td>
                            </tr>
                            <tr>
                            <tr>
                                <td>
                                    Salary Advance
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_salaryadvance" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    Mediclaim Deduction
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_medicliem" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    Other Deduction
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_otherdeduction" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 40px;">
                                    Loan Deduction
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_loan" readonly />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Total Deductions
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Totaldeduction" readonly />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6" style="width:33% !important; padding-left:0px !important;">
            <!-- AREA CHART -->
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Work days</h3>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="box-body no-padding">
                        <table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info"
                            id="Table1">
                            
                            <tr>
                                <td>
                                    Days in Month
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_daysinmonth"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Attendance Days
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_attendencedays"/>
                                </td>
                            </tr>

                            <tr>
                                <td style="display: none">
                                    <input type="text" class="inputBox" id="text8" />
                                </td>
                                <td>
                                    CL Holiday And Off
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_cloff"/>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    Emp Effective Workdays
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_empeffectivedays"/>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    Employee Work Days
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_empworkdays"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    LOP
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_lop"/>
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    OT Days
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Otdays"/>
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    Extra Days
                                </td>
                                <td>
                                    <input type="text" class="inputBox" id="txt_Extradays"/>
                                </td>
                            </tr>
                            
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div>
        <table align="center">
            <tr style="text-align: center; height:40px;">
                <td style="padding-left:20px;">
                    Net Salary
                </td>
                <td>
                    <input type="text" class="inputBox" id="txt_netsalary" readonly />
                </td>
            </tr>
            <tr style="text-align: center;">
                <td colspan="2" style="padding-left: 60px;">
                    <input type="button" class="btn btn-primary" id="btn_save" value="Procedd" onclick="save_payrollSalary_click();" />
                    <input type="button" class="btn btn-danger" id="btn_hold" value="Hold" onclick="save_payrollhold_click()" />
                    <input type="button" id="Button1" class="btn btn-primary" onclick="javascript:CallPrint('divPrint');"
                        value="Print" />
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
    <div id="divPrint" style="display: none;">
        <table>
            <tr>
                <td style="width: 60px;">
                </td>
                <td>
                    <table class="tablecenter">
                        <tr>
                            <td align="left" style="padding-top: 5px; width: 110px;">
                                <img src="Images/Vyshnavilogo.png" style="height: 40px;" />
                            </td>
                            <td align="left" style="padding-top: 5px; width: 30px;">
                            </td>
                            <td align="left" style="padding-top: 5px; font-size: 10px !important;">
                                <label id="lblvys" title="" style="font-size: large;">
                                    SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD</label>
                                </br>
                                <label id="Label8" title="">
                                    SURVEY NO.381-2, PUNABAKA (V), PELLAKUR (M), SPSR NELLORE DT - 524129.</label>
                            </td>
                        </tr>
                        <tr style="height: 2px;">
                        </tr>
                        <tr>
                            <td align="left">
                            </td>
                            <td align="left">
                            </td>
                            <td align="left" style="padding-left: 18%;">
                                <label id="Label9" title="">
                                    Payslip for the month of</label><span id="spnmonthdetails"></span> <span id="spnyeardetails">
                                    </span>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td style="width: 60px;">
                </td>
                <td>
                    <table class="tablecenter" width="110%">
                        <tr>
                            <td align="left" style="padding-top: 5px; width: 110px;">
                                <label id="Label10" title="">
                                    Employee Code:</label>
                            </td>
                            <td align="left" style="padding-top: 5px; width: 100px;">
                                <span id="spnempcodedetails" style="font-weight: bold;"></span>
                            </td>
                            <td align="left" style="padding-top: 5px; width: 120px;">
                                <label id="Label1" title="">
                                    Employee Name:</label>
                            </td>
                            <td align="left" style="padding-top: 5px; width: 110px;">
                                <span id="spnempnamedetails" style="font-weight: bold;"></span>
                            </td>
                            <td align="left" style="padding-top: 5px; width: 110px;">
                                <label id="Label7" title="">
                                    Bank Name:</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id="Span1" style="font-weight: bold;">SBI</span>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="padding-top: 5px;">
                                <label id="Label2" title="">
                                    For Month:</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id="spnformonthdetails" style="font-weight: bold;"></span>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <label id="Label3" title="">
                                    No. of Days:</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id="spnfornoofdaysdetails" style="font-weight: bold;"></span>
                            </td>
                            <td align="left" style="padding-top: 5px; width: 110px;">
                                <label id="Label12" title="">
                                    Bank Accoutno :</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id="Span2" style="font-weight: bold;">2266556655222</span>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="padding-top: 5px;">
                                <label id="Label4" title="">
                                    Days Paid:</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id="spndayspaiddetails" style="font-weight: bold;"></span>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <label id="Label5" title="">
                                    LOP:</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id="spnlopdetails" style="font-weight: bold;"></span>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td align="left" style="padding-top: 5px;">
                                <label id="Label13" title="">
                                    OT:</label>
                            </td>
                            <td align="left" style="padding-top: 5px;">
                                <span id=" spnot" style="font-weight: bold;"></span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6">
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
                                            border-color: Black; width: 200px; height: 30px; text-align: center;">
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
                                            border-color: Black; width: 180px; text-align: center;">
                                            <asp:Label ID="lblParticularD" runat="server" Text="Particular" Font-Bold="true"></asp:Label>
                                        </td>
                                        <%--<td valign="middle" align="center" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                            <asp:Label ID="lblGrossDeductions" runat="server" Text="Gross Deductions (Rs.)" Font-Bold="true"></asp:Label>
                                        </td>--%>
                                        <td valign="middle" align="center" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                            <asp:Label ID="lblDeductionsForMonth" runat="server" Text="Deductions For Month (Rs.)"
                                                Font-Bold="true"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; height: 30px; text-align: center;">
                                            <asp:Label ID="lblBasic" runat="server" Text="Basic" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblactbasic" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthbasic" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <asp:Label ID="lblPF" runat="server" Text="Provident Fund" Font-Bold="true"></asp:Label>
                                        </td>
                                        <%--<td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                             <span id="lblactpf" style="font-weight:bold;"></span>
                                        </td>--%>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthpf" style="font-weight: bold;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; height: 30px; text-align: center;">
                                            <asp:Label ID="lblHRA" runat="server" Text="House Rent Allowence" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblacthra" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthhra" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <asp:Label ID="lblPT" runat="server" Text="Professional Tax" Font-Bold="true"></asp:Label>
                                        </td>
                                        <%-- <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                             <span id="lblactpt" style="font-weight:bold;"></span>
                                        </td>--%>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthpt" style="font-weight: bold;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; height: 30px; text-align: center;">
                                            <asp:Label ID="lblConveyance" runat="server" Text="Conveyance" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblactconveyance" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthconveyance" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <asp:Label ID="lblESI" runat="server" Text="ESI" Font-Bold="true"></asp:Label>
                                        </td>
                                        <%--<td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                             <span id="lblactesi" style="font-weight:bold;"></span>
                                        </td>--%>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthesi" style="font-weight: bold;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; height: 30px; text-align: center;">
                                            <asp:Label ID="lblSplConveyance" runat="server" Text="Medical Allowance" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblactmedical" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthmedical" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <asp:Label ID="lblIncomeTax" runat="server" Text="Income Tax" Font-Bold="true"></asp:Label>
                                        </td>
                                        <%--<td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                            <span id="lblactincometax" style="font-weight:bold;"></span>
                                        </td>--%>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthincometax" style="font-weight: bold;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; height: 30px; text-align: center;">
                                            <asp:Label ID="Label6" runat="server" Text="Washing Allowance" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblactwashing" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthwashing" style="font-weight: bold;"></span>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <asp:Label ID="Label11" runat="server" Text="Canteen Deduction" Font-Bold="true"></asp:Label>
                                        </td>
                                        <%-- <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black;">
                                            <span id="lblactcanteen" style="font-weight:bold;"></span>
                                        </td>--%>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthcanteen" style="font-weight: bold;"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle" align="left" style="border-right: 1px solid Black; height: 30px;
                                            text-align: center;">
                                            <asp:Label ID="lblTotalE" runat="server" Text="Total" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-right: 1px solid Black; text-align: center;">
                                            <span id="lblacttotalearnings" style="font-weight: bold;"></span>
                                            <%--<asp:Label ID="lblActTotalEarnings" runat="server" Font-Bold="true"></asp:Label>--%>
                                        </td>
                                        <td valign="middle" align="left" style="border-right: 1px solid Black; text-align: center;">
                                            <span id="lblmonthtotalearnings" style="font-weight: bold;"></span>
                                            <%-- <asp:Label ID="lblMonthTotalEarnings" runat="server" Font-Bold="true"></asp:Label>--%>
                                        </td>
                                        <td valign="middle" style="border-right: 1px solid Black; text-align: center;">
                                            <asp:Label ID="lblTotalD" runat="server" Text="Total" Font-Bold="true"></asp:Label>
                                        </td>
                                        <td valign="middle" align="left" style="border-style: none solid solid none; border-width: 1px;
                                            border-color: Black; text-align: center;">
                                            <span id="lblmonthtotaldeduction" style="font-weight: bold;"></span>
                                            <%--<asp:Label ID="lblMonthTotalDeductions" runat="server" Font-Bold="true"></asp:Label>--%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" align="center" style="padding-top: 15px">
                                <label>
                                    Net Pay:</label>
                                <span id="lblnetpay" style="font-weight: bold;"></span>
                                <%--<asp:Label ID="lblNetPayAmount" runat="server" Font-Bold="true"></asp:Label>--%>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" align="center" style="padding-top: 15px">
                                <label>
                                    NOTE: This is computer generated payslip and needs no signature. If there is any
                                    discrepancy in your pay, you need to contact us within 3 days after payslip issue.</label>
                                <%--<asp:Label ID="lblNetPayAmount" runat="server" Font-Bold="true"></asp:Label>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
