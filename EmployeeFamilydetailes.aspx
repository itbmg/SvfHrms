
<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="EmployeeFamilydetailes.aspx.cs" Inherits="EmployeeFamilydetailes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#add_Inward').click(function () {
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();
                get_Dept_details();
                get_Employeedetails();
                GetFixedrows();
                getfamilydetailes();
            });

            $('#close_id').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_inwardtable').show();
                forclearall();
                //compiledList = [];
            });
            getfamilydetailes();
            //compiledList = [];
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
                }
            }
        }
        function GetFixedrows() {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Relation</th><th scope="col">Date Of Brith</th><th scope="col">Age</th><th scope="col">Blood Group</th><th scope="col">Gender</th><th scope="col">Nationality</th><th scope="col">Profession</th></tr></thead></tbody>';
            for (var i = 1; i < 6; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txt_name" type="text" class="form-control"   placeholder= "Name"  style="text-transform:capitalize;" /></td>';
                results += '<td ><input id="txt_Relation" type="text" class="form-control" placeholder= "Relation"  style=""/></td>';
                results += '<td ><input id="txt_dateofbrith" type="date"  class="form-control"  class="form-control"  style=""/></td>';
                results += '<td ><input id="txt_age" type="text"  class="form-control"  placeholder= "Age" onkeypress="return isNumber(event)" class="form-control"  style=""/></td>';
                results += '<td ><input id="txt_bloodgrp" type="text"  class="form-control"  placeholder= "Blood  Group"   style=""/></td>';
                results += '<td data-title="Phosps"  ><select id="slct_gender" class="form-control" style="" ><option   value="Male">Male</option><option  value="Female">Female</option></select></td>';
                results += '<td ><input id="slct_country" type="text"  class="form-control"  placeholder= "Country"    style=""/></td>';
                results += '<td ><input id="txt_Proffision" type="text"  class="form-control" style="" placeholder= "Profession" class="form-control" onkeypress="return ValidateAlpha(event);"  style=""/></td>';
                results += '<td style="display:none"><input id="txt_sno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function insertrow() {
            DataTable = [];
            var txtsno = 0;
            name = 0;
            relation = 0;
            dateofbrith = 0;
            gender = 0;
            age = 0;
            bloodgroup = 0;
            profession = 0;
            nationalty = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txt_name').val() != "") {
                    txtsno = rowsno;
                    name = $(this).find('#txt_name').val();
                    relation = $(this).find('#txt_Relation').val();
                    dateofbrith = $(this).find('#txt_dateofbrith').val();
                    age = $(this).find('#txt_age').val();
                    bloodgroup = $(this).find('#txt_bloodgrp').val();
                    gender = $(this).find('#slct_gender').val();
                    nationalty = $(this).find('#slct_country').val();
                    profession = $(this).find('#txt_Proffision').val();
                    empcode = $(this).find('#txtempcode').val();
                    sno = $(this).find('#txt_sno').val();
                    DataTable.push({ Sno: txtsno, name: name, empcode: empcode, relation: relation, dateofbrith: dateofbrith, age: age, bloodgroup: bloodgroup, gender: gender, nationalty: nationalty, profession: profession, sno: sno });
                    rowsno++;
                }
            });
            name = 0;
            relation = 0;
            dateofbrith = 0;
            gender = 0;
            age = 0;
            bloodgroup = 0;
            profession = 0;
            nationalty = 0;
            sno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, name: name, relation: relation, dateofbrith: dateofbrith, age: age, bloodgroup: bloodgroup, gender: gender, nationalty: nationalty, profession: profession, sno: sno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Relation</th><th scope="col">Date Of Brith</th><th scope="col">Age</th><th scope="col">Blood Group</th><th scope="col">Gender</th><th scope="col">Nationality</th><th scope="col">Profession</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txt_name" type="text" class="form-control"  placeholder= "Name"  style="text-transform:capitalize;"  value="' + DataTable[i].name + '"/></td>';
                results += '<td ><input id="txt_Relation" type="text" class="form-control"  value="' + DataTable[i].relation + '"/></td>';
                results += '<td ><input id="txt_dateofbrith"  type="date" class="form-control"   style="" value="' + DataTable[i].dateofbrith + '"/></td>';
                results += '<td ><input id="txt_age" type="text" class="form-control"  style="" onkeypress="return isNumber(event)" value="' + DataTable[i].age + '"/></td>';
                results += '<td ><input id="txt_bloodgrp" type="text" class="form-control"  style="" value="' + DataTable[i].bloodgroup + '"/></td>';
                results += '<td data-title="Phosps"  ><select id="slct_gender" class="form-control" style="width:100% !important;" ><option selected disabled value="Select Type">Select Type</option><option   value="Male">Male</option><option  value="Female">Female</option></select></td>';
                results += '<td ><input id="slct_country" type="text" class="form-control"  style=""  value="' + DataTable[i].nationalty + '"/></td>';
                results += '<td ><input id="txt_Proffision" type="text" class="form-control" onkeypress="return ValidateAlpha(event);" style=""  value="' + DataTable[i].profession + '"/></td>';
                results += '<th data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + DataTable[i].sno + '" ></input>';
               // results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }


        function save_Employee_Family_click() {
            var DataTable = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                name = $(this).find('#txt_name').val();
                relation = $(this).find('#txt_Relation').val();
                dateofbrith = $(this).find('#txt_dateofbrith').val();
                gender = $(this).find('#slct_gender').val();
                nationalty = $(this).find('#slct_country').val();
                age = $(this).find('#txt_age').val();
                bloodgroup = $(this).find('#txt_bloodgrp').val();
                profession = $(this).find('#txt_Proffision').val();
                sno = $(this).find('#txt_sno').val();
                var abc = { name: name, sno: sno, relation: relation, dateofbrith: dateofbrith, age: age, bloodgroup: bloodgroup, nationalty: nationalty, gender: gender, profession: profession };
                if (name != "") {
                    DataTable.push(abc);
                }
            });
            var department = document.getElementById('selct_department').value;
            var employeid = document.getElementById('txtsupid').value;
            var empcode = document.getElementById('txtempcode').value;
            var name = document.getElementById('txt_name').value;
            if (name == "") {
                alert("Enter name ");
                return false;

            }
            var relation = document.getElementById('txt_Relation').value;
            if (relation == "") {
                alert("Enter relation ");
                return false;

            }
            var dateofbrith = document.getElementById('txt_dateofbrith').value;
//            if (dateofbrith == "") {
//                alert("Enter dateofbrith ");
//                return false;

//            }
            var gender = document.getElementById('slct_gender').value;
            var nationalty = document.getElementById('slct_country').value;
            var profession = document.getElementById('txt_Proffision').value;
            if (profession == "") {
                alert("Enter profession ");
                return false;
            }
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_Employee_Family_click', 'employeid': employeid, 'empcode':empcode,'department': department, 'DataTable': DataTable, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    getfamilydetailes();
                    $('#vehmaster_fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_inwardtable').show();
                    document.getElementById('txt_empcode1').value = "";
                    document.getElementById('txt_empname1').value = "";
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function forclearall() {
            document.getElementById('selct_department').selectedIndex = 0;
            document.getElementById('selct_employe').value = "";
            document.getElementById('btn_save').value = "Save";
            GetFixedrows();
            //compiledList = [];
        }
        var empdata = [];
        function getfamilydetailes() {
            var data = { 'op': 'getfamilydetailes' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_foreground_tbl(msg);
                        empdata = msg;
                        filldata(msg);
                        filldata1(msg);
                        get_Dept_details();
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

        var employee_subdetails = [];
        function fill_foreground_tbl(msg) {
            get_Dept_details();
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
            results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Designation</th><th scope="col"></th></tr></thead></tbody>';
            employee_subdetails = msg[0].employeefamilyclass;
            var employee = msg[0].familyedetailes;
            for (var i = 0; i < employee.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td data-title="invoicedate" class="4" >' + employee[i].fullname + '</td>';
                results += '<td data-title="inwardno" style="display:none;" class="1">' + employee[i].employeid + '</td>';
                results += '<td data-title="invoiceno" class="2">' + employee[i].empcode + '</td>';
                results += '<td data-title="inwarddate" class="3">' + employee[i].desigination + '</td>';
                results += '<td data-title="dcno" class="6" style="display:none;">' + employee[i].designationid + '</td>';
                results += '<td data-title="dcno" class="5" style="display:none;" >' + employee[i].department + '</td>';
                results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                //results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddensupplyid + '</td>
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_inwardtable").html(results);
        }
        var empcode = "";
        function update(thisid) {
            $('#vehmaster_fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_inwardtable').hide();
            var employeid = $(thisid).parent().parent().children('.1').html();
            empcode = $(thisid).parent().parent().children('.2').html();
            var desigination = $(thisid).parent().parent().children('.3').html();
            var fullname = $(thisid).parent().parent().children('.4').html();
            var department = $(thisid).parent().parent().children('.5').html();
            var designationid = $(thisid).parent().parent().children('.6').html();
            document.getElementById('txtsupid').value = employeid;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('selct_department').value = department;
            document.getElementById('selct_employe').value = fullname;
            //document.getElementById('txt_dcno').value = desigination;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div class="divcontainer" style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" >';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Name</th><th scope="col">Relation</th><th scope="col">Date Of Brith</th><th scope="col">Age</th><th scope="col">Blood Group</th><th scope="col">Gender</th><th scope="col">Nationality</th><th scope="col">Profession</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < employee_subdetails.length; i++) {
                if (empcode == employee_subdetails[i].empcode) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input id="txt_name"  class="form-control"  name="name" value="' + employee_subdetails[i].name + '" style="text-transform:capitalize;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txt_Relation" name="relation"  value="' + employee_subdetails[i].relation + '" style=""></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txt_dateofbrith" type="date" name="dateofbrith" value="' + employee_subdetails[i].dateofbrith + '" style=""></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txt_age"  name="age" value="' + employee_subdetails[i].age + '" style="onkeypress="return isNumber(event)" "></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txt_bloodgrp"  name="profession" value="' + employee_subdetails[i].bloodgroup + '" style=""></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="slct_gender" name="gender" value="' + employee_subdetails[i].gender + '" style=""></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="slct_country"  name="nationalty" value="' + employee_subdetails[i].nationalty + '" style=""></input></td>';
                    results += '<td data-title="From" ><input class="7" id="txt_Proffision"  name="bloodgroup" value="' + employee_subdetails[i].profession + '"style=""></input></td>';
                    results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + employee_subdetails[i].sno + '" style=""></input></td></tr>';
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }



        //var compiledList = [];
        function filldata(msg) {
            var compiledList = [];
            var employee = msg[0].familyedetailes
            for (var i = 0; i < employee.length; i++) {
                var empname = employee[i].fullname;
                compiledList.push(empname);
            }

            $('#txt_empname1').autocomplete({
                source: compiledList,
                change: empnamechange,
                autoFocus: true
            });
        }

        function empnamechange() {
            document.getElementById('txt_empcode1').value = "";
            var name = document.getElementById('txt_empname1').value;
            var msg = empdata;
            if (name == "") {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Designation</th><th scope="col"></th></tr></thead></tbody>';
                employee_subdetails = msg[0].employeefamilyclass;
                var employee = msg[0].familyedetailes;
                for (var i = 0; i < employee.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<td data-title="invoicedate" class="4" >' + employee[i].fullname + '</td>';
                    results += '<td data-title="inwardno" style="display:none;" class="1">' + employee[i].employeid + '</td>';
                    results += '<td data-title="invoiceno" class="2">' + employee[i].empcode + '</td>';
                    results += '<td data-title="inwarddate" class="3">' + employee[i].desigination + '</td>';
                    results += '<td data-title="dcno" class="6" style="display:none;">' + employee[i].designationid + '</td>';
                    results += '<td data-title="dcno" class="5" style="display:none;" >' + employee[i].department + '</td>';
                    results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                    //results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddensupplyid + '</td>
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_inwardtable").html(results);
            }
            else {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Designation</th><th scope="col"></th></tr></thead></tbody>';
                employee = msg[0].familyedetailes;
                for (var i = 0; i < employee.length; i++) {
                    if (name == employee[i].fullname) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td data-title="invoicedate" class="4" >' + employee[i].fullname + '</td>';
                        results += '<td data-title="inwardno" style="display:none;" class="1">' + employee[i].employeid + '</td>';
                        results += '<td data-title="invoiceno" class="2">' + employee[i].empcode + '</td>';
                        results += '<td data-title="inwarddate" class="3">' + employee[i].desigination + '</td>';
                        results += '<td data-title="dcno" class="6" style="display:none;">' + employee[i].designationid + '</td>';
                        results += '<td data-title="dcno" class="5" style="display:none;" >' + employee[i].department + '</td>';
                        results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                        //results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddensupplyid + '</td>
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                $("#div_inwardtable").html(results);
            }
        }
        function filldata1(msg) {
            var compiledList1 = [];
            var employee = msg[0].familyedetailes
            for (var i = 0; i < employee.length; i++) {
                var empcode = employee[i].empcode;
                compiledList1.push(empcode);
            }

            $('#txt_empcode1').autocomplete({
                source: compiledList1,
                change: empnamecode,
                autoFocus: true
            });
        }
        function empnamecode() {
            document.getElementById('txt_empname1').value = "";
            var empcode = document.getElementById('txt_empcode1').value;
            var msg = empdata;
            if (empcode == "") {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Designation</th><th scope="col"></th></tr></thead></tbody>';
                employee_subdetails = msg[0].employeefamilyclass;
                var employee = msg[0].familyedetailes;
                for (var i = 0; i < employee.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '">';
                    results += '<td data-title="invoicedate" class="4" >' + employee[i].fullname + '</td>';
                    results += '<td data-title="inwardno" style="display:none;" class="1">' + employee[i].employeid + '</td>';
                    results += '<td data-title="invoiceno" class="2">' + employee[i].empcode + '</td>';
                    results += '<td data-title="inwarddate" class="3">' + employee[i].desigination + '</td>';
                    results += '<td data-title="dcno" class="6" style="display:none;">' + employee[i].designationid + '</td>';
                    results += '<td data-title="dcno" class="5" style="display:none;" >' + employee[i].department + '</td>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                    //results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddensupplyid + '</td>
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_inwardtable").html(results);
            }
            else {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info">';
                results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Employee Code</th><th scope="col">Designation</th><th scope="col"></th></tr></thead></tbody>';
                employee = msg[0].familyedetailes;
                for (var i = 0; i < employee.length; i++) {
                    if (empcode == employee[i].empcode) {
                        results += '<tr style="background-color:' + COLOR[l] + '">';
                        results += '<td data-title="invoicedate" class="4" >' + employee[i].fullname + '</td>';
                        results += '<td data-title="inwardno" style="display:none;" class="1">' + employee[i].employeid + '</td>';
                        results += '<td data-title="invoiceno" class="2">' + employee[i].empcode + '</td>';
                        results += '<td data-title="inwarddate" class="3">' + employee[i].desigination + '</td>';
                        results += '<td data-title="dcno" class="6" style="display:none;">' + employee[i].designationid + '</td>';
                        results += '<td data-title="dcno" class="5" style="display:none;" >' + employee[i].department + '</td>';
                        results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="update(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                        //results += '<td data-title="hiddensupplyid" class="14" style="display:none;">' + inward[i].hiddensupplyid + '</td>
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                $("#div_inwardtable").html(results);
            }
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

        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
        }

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Family Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">Employee Family Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Family Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <table>
                        <tr>
                            <td>
                                <input id="txt_empcode1" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                    class="form-control" placeholder="Search EMP Code" />
                            </td>
                            <td ><span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 28px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                             </td>
                             <td style="width:5px;"></td>
                            <td style="width: 35px">

                                OR
                            </td>
                            <td>
                                <input id="txt_empname1" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
                                    class="form-control" placeholder="Search EMP Name" />
                            </td>
                            <td ><span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 28px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                             </td>
                              <td style="width:5px;"></td>
                             
                            <td style="width: 500px">
                            </td>
                            <td>
                                 <div class="input-group">
                                    <div class="input-group-addon"  id="add_Inward"  >
                                            <span class="glyphicon glyphicon-plus-sign" ></span> <span  onclick="showdesign()">Add Family</span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="div_inwardtable">
                </div>
                <div id='vehmaster_fillform' style="display: none;">
                 <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/family.png" alt="your image" style="border-radius: 5px; width: 70px;
                                                                    height: 70px; border-radius: 50%;" />
                                                                    </div>
                    <asp:UpdatePanel ID="Up1" runat="server">
                        <ContentTemplate>
                            <div class="row-fluid">
                                <div style="padding-left: 150px;">
                                    <table id="tbl_leavemanagement" align="center">
                                        <tr>
                                            <td>
                                                Department : 
                                            </td>
                                            <td>
                                                <select id="selct_department" class="form-control" style="width: 183px;">
                                                    <option selected disabled value="Select Department">Select Department</option>
                                                </select>
                                            </td>
                                            <td>
                                                Employe Name : 
                                            </td>
                                            <td>
                                                <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employe Name"
                                                    onkeypress="return ValidateAlpha(event);" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <br />
                                <div class="box box-info">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">
                                            <i style="padding-right: 5px;" class="fa fa-list"></i>Select Name(s)
                                        </h3>
                                    </div>
                                    <div class="box-body">
                                        <div id="div_SectionData">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div class="input-group" style="width: 30px;">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-plus-sign" onclick="insertrow()"></span> <span onclick="insertrow()">Add New Row</span>
                                    </div>
                                </div>
                                <div id="">
                                </div>
                            </div>
                            <table style="margin-left: 42%;">
                    <td  >
                    <div class="input-group" >
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_Employee_Family_click()"></span> <span id="btn_save" onclick="save_Employee_Family_click()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='close_id1' ></span> <span id='close_id'>Close</span>
                          </div>
                    </td>
                    </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
    </section>
</asp:Content>
