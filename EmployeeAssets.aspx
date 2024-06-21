<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="EmployeeAssets.aspx.cs" Inherits="EmployeeAssets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $('#btn_addBrand').click(function () {
                $('#fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_Deptdata').hide();
                // get_Dept_details();
                get_Employeedetails();
                get_Assets_details();
                get_Assetsreturn_details();
                GetFixedrows();
            });

            $('#btn_close').click(function () {
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_Deptdata').show();
                forclearall();
            });
            $('#close_id').click(function () {
                $('#fillGrid').css('display', 'block');
                $('#datareturn').css('display', 'none');
                $('#close_id').css('display', 'none');
            });
            get_Assets_details();
            // get_Dept_details();
            get_Employeedetails();
            get_Assetsreturn_details();
            $("#div_asset").css("display", "block");
        });


        function show_asset() {
            $("#div_asset").css("display", "block");
            $("#div_returnasset").css("display", "none");
            //ODrequestDetails();
        }

        function show_assetreturn() {
            $("#div_asset").css("display", "none");
            $("#div_returnasset").css("display", "block");
        }



        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
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
                    document.getElementById('txtempcode').value = employeedetails[i].empnum;
                }
            }
        }

        function GetFixedrows() {
            var j = 0;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Value</th><th scope="col">Recieved Date</th><th scope="col">Asset Details</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 1; i < 4; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtAssetName" type="text" class="form-control"   placeholder= "Asset Name"   /></td>';
                results += '<td ><input id="txtAssetValue" type="text" class="form-control" placeholder= "Asset Value"  /></td>';
                results += '<td ><input id="txtRecievedDate" type="date"  class="form-control" /></td>';
                results += '<td ><input id="txtAssetDetails" type="text"  class="form-control"  placeholder= "Asset Detailes"  class="form-control"  /></td>';
                results += '<td ><input id="txtRemarks" type="text"  class="form-control"  placeholder= "Remarks"   /></td>';
                results += '<td  style="display:none"><input id="txt_sno" type="hidden" /></td></tr>';
            }
            results += '</table></div>';
            $("#div_Griddata").html(results);
        }
        var DataTable;
        function insertrow() 
        {
            DataTable = [];
            var txtsno = 0;
            assetname = 0;
            assetvalue = 0;
            receiveddate = 0;
            assetdetailes = 0;
            remarks = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtAssetName').val() != "") {
                    txtsno = rowsno;
                    assetname = $(this).find('#txtAssetName').val();
                    assetvalue = $(this).find('#txtAssetValue').val();
                    receiveddate = $(this).find('#txtRecievedDate').val();
                    assetdetailes = $(this).find('#txtAssetDetails').val();
                    remarks = $(this).find('#txtRemarks').val();
                    empcode = $(this).find('#txtempcode').val();
                    sno = $(this).find('#txt_sno').val();
                    DataTable.push({ Sno: txtsno, assetname: assetname, empcode: empcode, assetvalue: assetvalue, receiveddate: receiveddate, assetdetailes: assetdetailes, remarks: remarks, sno: sno });
                    rowsno++;
                }

            });
            assetname = 0;
            assetvalue = 0;
            receiveddate = 0;
            assetdetailes = 0;
            remarks = 0;
            bloodgroup = 0;
            profession = 0;
            nationalty = 0;
            sno = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, assetname: assetname, assetvalue: assetvalue, receiveddate: receiveddate, assetdetailes: assetdetailes, remarks: remarks, sno: sno });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Value</th><th scope="col">Recieved Date</th><th scope="col">Asset Details</th><th scope="col">Remarks</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;"   id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtAssetName" type="text" class="form-control"    value="' + DataTable[i].assetname + '"/></td>';
                results += '<td ><input id="txtAssetValue" type="text" class="form-control"   value="' + DataTable[i].assetvalue + '"/></td>';
                results += '<td ><input id="txtRecievedDate"  type="date" class="form-control"    value="' + DataTable[i].receiveddate + '"/></td>';
                results += '<td ><input id="txtAssetDetails" type="text" class="form-control"     value="' + DataTable[i].assetdetailes + '"/></td>';
                results += '<td ><input id="txtRemarks" type="text" class="form-control"   value="' + DataTable[i].remarks + '"/></td>';
                results += '<th data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + DataTable[i].sno + '" ></input>';
                //results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_Griddata").html(results);
        }

        function for_save_edit_empassetdetails() {
            var DataTable = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                assetname = $(this).find('#txtAssetName').val();
                assetvalue = $(this).find('#txtAssetValue').val();
                receiveddate = $(this).find('#txtRecievedDate').val();
                assetdetailes = $(this).find('#txtAssetDetails').val();
                remarks = $(this).find('#txtRemarks').val();
                //empcode = $(this).find('#txtempcode').val();
                sno = $(this).find('#txt_sno').val();
                var abc = { 'sno': sno, 'assetname': assetname, 'receiveddate': receiveddate, 'assetvalue': assetvalue, 'remarks': remarks, 'assetdetailes': assetdetailes };
                if (assetname != "") {
                    DataTable.push(abc);
                }
            });
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                $('#selct_employe').focus();
                alert("Select Employee Name ");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var empcode = document.getElementById('txtempcode').value;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_edit_empassetdetails', 'employeid': employeid, 'empcode': empcode, 'DataTable': DataTable, 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_Assets_details();
                    $('#fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_Deptdata').show();
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }

        //var empdata = [];
        function get_Assets_details() {
            var data = { 'op': 'get_Assets_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        filldetails(msg);
                        fillreturndetailes(msg);
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
        var employee_subdassetetails = [];
        function filldetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col"></th></tr></thead></tbody>';
            employee_subdassetetails = msg[0].employeeassetclass;
            var employee = msg[0].assetdetailes;
            for (var i = 0; i < employee.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                //k++;
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + employee[i].empcode + '</th>';
                results += '<td  class="2">' + employee[i].fullname + '</td>';
                results += '<td  style="display:none" class="4">' + employee[i].sno + '</td>';
                results += '<td style="display:none" class="3">' + employee[i].employeid + '</td>';
                results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);

        }
        var empcode = "";
        function getme(thisid) {
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_Deptdata').hide();
            var empcode = $(thisid).parent().parent().children('.1').html();
            var sno = $(thisid).parent().parent().children('.4').html();
            var fullname = $(thisid).parent().parent().children('.2').html();
            var employeid = $(thisid).parent().parent().children('.3').html();
            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('lbl_sno').value = sno;
            document.getElementById('txtsupid').value = employeid;
            document.getElementById('btn_save').value = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Value</th><th scope="col">Received Date</th><th scope="col">Asset Details</th><th scope="col">Remarks</th></tr></thead></tbody>';
            //results += '<thead><tr><th scope="col"></th><th scope="col">Sno</th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">assetname</th><th scope="col">receiveddate</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < employee_subdassetetails.length; i++) {
                if (empcode == employee_subdassetetails[i].empcode) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input id="txtAssetName"  class="form-control"  name="assetname" value="' + employee_subdassetetails[i].assetname + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txtAssetValue" name="assetvalue"  value="' + employee_subdassetetails[i].assetvalue + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txtRecievedDate" type="receiveddate "name="dateofbrith" value="' + employee_subdassetetails[i].receiveddate + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txtAssetDetails"  name="assetdetailes" value="' + employee_subdassetetails[i].assetdetailes + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txtRemarks"  name="remarks" value="' + employee_subdassetetails[i].remarks + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + employee_subdassetetails[i].sno + '" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td></tr>';
                    k++;
                }
            }

            results += '</table></div>';
            $("#div_Griddata").html(results);
        }


        function forclearall() {
            document.getElementById('selct_employe').value = "";
            document.getElementById('txtAssetName').value = "";
            document.getElementById('txtRecievedDate').value = "";
            document.getElementById('txtAssetValue').value = "";
            document.getElementById('txtAssetDetails').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            GetFixedrows();
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



        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function get_Assetsreturn_details() {
            var data = { 'op': 'get_Assets_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillreturndetailes(msg);
                       
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
        var employee_subdassetetails1 = [];
        function fillreturndetailes(msg) {
            $('#close_id').css('display', 'none');

            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col"></th></tr></thead></tbody>';
            employee_subdassetetails1 = msg[0].employeeassetclass;
            var employee1 = msg[0].assetdetailes;
            for (var i = 0; i < employee1.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                //k++;
                results += '<td>' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + employee1[i].empcode + '</th>';
                results += '<td  class="2">' + employee1[i].fullname + '</td>';
                results += '<td style="display:none" class="3">' + employee1[i].employeid + '</td>';
                results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getreturn(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                // results += '<td><input id="btn_poplate" type="button" name="submit" class="btn btn-primary" onclick="save_rejoining_approve_click(this);" value="Apporval" /></td><td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-danger" value="Reject" /></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#fillGrid").html(results);
        }
        function getreturn(thisid) {
            $('#fillGrid').hide();
            $('#datareturn').show();
            $('#close_id').css('display', 'show');
            //sno = sno;
            var empcode = $(thisid).parent().parent().children('.1').html();
            // var sno = $(thisid).parent().parent().children('.4').html();
            var fullname = $(thisid).parent().parent().children('.2').html();
            var employeid = $(thisid).parent().parent().children('.3').html();
            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('txtsupid').value = employeid;
            //document.getElementById('lbl_sno').value = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
            var table = document.getElementById("tabledetails");
            var results = '<div  style="overflow:auto;"><table ID="tabledetails" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Asset Name</th><th scope="col">Asset Value</th><th scope="col">Received Date</th><th scope="col">Asset Details</th><th scope="col">Remarks</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < employee_subdassetetails1.length; i++) {
                if (empcode == employee_subdassetetails1[i].empcode) {
                    results += '<tr><td data-title="Sno" class="1">' + k + '</td>';
                    results += '<th data-title="From"><input id="txtAssetName"  class="form-control" readonly name="assetname" value="' + employee_subdassetetails1[i].assetname + '" style="width:80%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txtAssetValue" readonly name="assetvalue"  value="' + employee_subdassetetails1[i].assetvalue + '" style="width:80%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txtRecievedDate" readonly type="receiveddate "name="dateofbrith" value="' + employee_subdassetetails1[i].receiveddate + '" style="width:80%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control"  id="txtAssetDetails" readonly name="assetdetailes" value="' + employee_subdassetetails1[i].assetdetailes + '" style="width:80%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="form-control" id="txtRemarks" readonly name="remarks" value="' + employee_subdassetetails1[i].remarks + '" style="width:80%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    //  results += '<td data-title="From"><input class="form-control" type="hidden"  id="txt_sno" value="'+ employee_subdassetetails1[i].sno + '"name="nationalty" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;"></input></td>';
                    results += '<td data-title="From"><input class="btn btn-primary" type="button"  id="btn_poplate"  name="Return" style="width:100%; font-size:12px;padding: 0px 5px;height:30px;" value="Return" onclick="btnsno(\'' + employee_subdassetetails1[i].sno + '\');"></input></td></tr>';
                    // results += '<td><input  type="button" name="submit"    /></td></tr>';
                    // results += '<td><input id="close_id" type="button" name="submit" class="btn btn-danger" onclick="closeclick(this);" value="Close" /></td></tr>';
                    k++
                }
            }
            results += '</table></div>';
            $("#datareturn").html(results);

        }
        

        function btnsno(sno) {
            sno;
            var DataTable1 = [];
            var count = 0;
            var employeid = document.getElementById('txtsupid').value;
            // var sno = document.getElementById('lbl_sno').value;
            var empcode = document.getElementById('txtempcode').value;
            if (employeid == "") {
                alert("Select employeid ");
                return false;
            }
            var btnval = document.getElementById('btn_poplate').value;
            var data = { 'op': 'save_appovereturn_click', 'sno': sno, 'employeid': employeid, 'empcode': empcode, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    $('#datareturn').hide();
                    $('#fillGrid').show();
                    get_Assetsreturn_details();

                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        //        function save_appovereturn_click() {
        //            var sno = document.getElementById('txt_sno').value;
        //            var data = { 'op': 'save_appovereturn_click', 'sno': sno };
        //            var s = function (msg) {
        //                if (msg) {
        //                    if (msg.length > 0) {
        //                        get_Assetsreturn_details();
        //                        alert(msg);
        //                       // $('#divMainAddNewRow').css('display', 'none');

        //                    }
        //                }
        //                else {
        //                }
        //            };
        //            var e = function (x, h, e) {
        //            };
        //            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //            callHandler(data, s, e);
        //        }


        //        //var sno = 0;
        //        function save_return_asset_click() {
        //        var DataTable = [];
        //            var count = 0;
        //            var rows = $("#tabledetails tr:gt(0)");
        //            var rowsno = 1;
        //            $(rows).each(function (i, obj) {
        //            sno = $(this).find('#txt_sno').val();
        //            var data = { 'op': 'save_return_asset_click', 'sno': sno,'employeid': employeid,'DataTable':DataTable };
        //            var s = function (msg) {
        //                if (msg) {
        //                    if (msg.length > 0) {
        //                        alert(msg);
        //                       // $('#divMainAddNewRow').css('display', 'none');
        //                        get_Assetsreturn_details();
        //                        $('#fillGrid').show();
        //                    }
        //                }
        //                
        //               
        //                else {
        //                }
        //            };
        //            var e = function (x, h, e) {
        //            };
        //            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
        //            callHandler(data, s, e);
        //        }



        
        
        

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Asset Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">Employee Asset Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
        <div>
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_asset()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Asset Master</a></li>
                        <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="show_assetreturn()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp; Asset Return Details</a></li>
                             <%--<li id="Li1" class=""><a data-toggle="tab" href="#" onclick="show_myleaverequest()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;My Leave request Details</a></li>--%>
                    </ul>
              </div>
              <div id="div_asset" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Asset Details
                </h3>
            </div>
            <div>
                <div class="box-body">
                    <div id="showlogs" style="padding-left: 79%;" >
                    <div class="input-group" id="btn_addBrand">
                                        <div class="input-group-addon" style="width: 124px;">
                                            <span class="glyphicon glyphicon-plus-sign"  ></span> <span id="Span1" ">Add Employee Asset</span>
                                        </div>
                                    </div>
                    </div>

                    <div id='fillform' style="display: none;">
                       <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/assets.png" alt="your image" style="border-radius: 5px; width: 50px;
                                                                    height: 40px; border-radius: 50%;" />
                                                                    </div>
                        <table id="tbl_leavemanagement" align="center">
                            <tr>
                                <%-- <td style="height: 40px;">
                                    <span style="color: red;">*</span> Department
                                </td>
                                <td>
                                    <select id="selct_department" class="form-control" style="width: 250px;">
                                        <option selected disabled value="Select Department">Select Department</option>
                                    </select>
                                </td>--%>
                                <td style="height: 40px;">
                                    <span style="color: red;">*</span> Employee Name
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="selct_employe" onkeypress="return ValidateAlpha(event);"
                                        placeholder="Enter Employee Name" />
                                </td>
                                <td style="height: 40px; display:none">
                                    <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                                <td style="height: 40px;"  display:none">
                                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            </tr>
                              
                            <tr hidden>
                                <td>
                                    <label id="lbl_sno">
                                    </label>
                                </td>
                            </tr>
                        </table>
                         <div  id="div_Griddata">
                        </div>
                        <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="for_save_edit_empassetdetails()"></span><span id="btn_save" onclick="for_save_edit_empassetdetails()">Save</span>
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
                                     <div class="input-group" style="width: 30px;">
                                    <div class="input-group-addon">
                                        <span class="glyphicon glyphicon-plus-sign" onclick="insertrow()"></span> <span onclick="insertrow()">ADD NEW ROW</span>
                                    </div>
                                </div>
                    </div>
                    <div>
                    <div>
                    
                        </div>
                        
                         <div id="div_Deptdata">
                        </div>
                        
                        </div>
                </div>
                </div>
                </div>
                <div id="div_returnasset" style="display: none;">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Return Details
                </h3>
            </div>
            <div class='divcontainer' style="overflow: auto;padding: 1%;">
                <div id="fillGrid">
                </div>
                <div id="datareturn">
                </div>
                  <input id="close_id" type="button" style="display:none;" class="btn btn-danger" name="submit" value="Clear" />
            </div>
            <div id="divMainAddNewRow" class="pickupclass" style="text-align: center; height: 100%;
                width: 100%; position: absolute; display: none; left: 0%; top: 0%; z-index: 99999;
                background: rgba(192, 192, 192, 0.7);">
                <div id="divAddNewRow" style="border: 5px solid #A0A0A0; position: absolute; top: 8%;
                    background-color: White; left: 10%; right: 10%; width: 80%; height: 100%; -webkit-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    -moz-box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65); box-shadow: 1px 1px 10px rgba(50, 50, 50, 0.65);
                    border-radius: 10px 10px 10px 10px;">
                    <table align="left" cellpadding="0" cellspacing="0" style="float: left; width: 100%;"
                        id="tableCollectionDetails" class="mainText2" border="1">
                        <tr>
                            <td>
                                <label>
                                    Remarks</label>
                            </td>
                            <td style="height: 40px;">
                                <textarea id="txt_remarks" type="text" class="form-control" name="Remarks" placeholder="Enter Remarmks"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <%--<td>
                            <input type="button" class="btn btn-primary" id="btn_save" value="Approve" onclick="save_resignation_approve_click();" />
                        </td>--%>
                            <td>
                                <input type="button" class="btn btn-danger" id="btn_cancel" value="Reject" onclick="save_rejoining_reject_click();" />
                            </td>
                        </tr>
                    </table>


                </div>
                <div id="divclose" style="width: 35px; top: 7.5%; right: 8%; position: absolute;
                    z-index: 99999; cursor: pointer;">
                    <img src="Images/Close.png" alt="close" onclick="CloseClick();" />
                </div>
            </div>
            </div>
                </div>
    </section>
</asp:Content>
