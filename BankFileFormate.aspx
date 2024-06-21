<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="BankFileFormate.aspx.cs" Inherits="BankFileFormate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <style>
        .h1, .h2, .h3, h1, h2, h3
        {
            margin-top: 5px;
            margin-bottom: 10px;
        }
        .menuclass
        {
            height: 59px !important;
        }
        .divselectedclass
        {
            border: 1px solid gray;
            padding-top: 2px;
            padding-bottom: 2px;
        }
        .back-red
        {
            background-color: #ffffcc;
        }
        .back-white
        {
            background-color: #ffffff;
        }
        
        .unitline
        {
            font: inherit;
            width: 120px;
        }
        .iconminus
        {
            float: right;
            width: 20px;
            height: 20px;
            margin: 2px 0 0 0;
            background: url("Images/minus.png") no-repeat;
            border-radius: 2px 2px 2px 2px;
        }
        .titledivcls
        {
            height: 30px;
        }
        .divcategory
        {
            border-bottom-style: dashed;
            border-bottom-color: #D6D6D6;
            border-bottom-width: 1px;
        }
        .activeanchor
        {
            text-decoration: none;
            color: #000000;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            var hrs = today.getHours();
            var mnts = today.getMinutes();
            $('#ddlmonth').val(mm);
            var myselect = document.getElementById('year1'), year = new Date().getFullYear();
            var gen = function (max) { do { myselect.add(new Option(year++, max--), null); } while (max > 0); } ();
            var year = 1980;
            var min = new Date().getFullYear(),
                        max = min + 9
            for (i = 0; i < 100; i++) {
                $("#year1").get(0).options[$("#year1").get(0).options.length] = new Option(year, year);
                year = year + 1;
            }
            $('#year1').val(yyyy);
            get_Branch_details();
            get_Employeedetails();

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
        function CallHandlerUsingJson_POST(d, s, e) {
            d = JSON.stringify(d);
            //    d = d.replace(/&/g, '\uFF06');
            //    d = d.replace(/#/g, '\uFF03');
            //    d = d.replace(/\+/g, '\uFF0B');
            //    d = d.replace(/\=/g, '\uFF1D');
            d = encodeURIComponent(d);
            $.ajax({
                type: "POST",
                url: "EmployeeManagementHandler.axd",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: d,
                async: true,
                cache: true,
                success: s,
                error: e
            });
        }
        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
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
            var data = document.getElementById('Slect_Name');
            var length = data.options.length;
            document.getElementById('Slect_Name').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branchname";
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
        function FillBanknames() {
            var branchname = document.getElementById("Slect_Name").value;
            var month = document.getElementById("ddlmonth").value;
            var year = document.getElementById("year1").value;
            var Employeetype = document.getElementById("Slc_emptype").value;
            var data = { 'op': 'get_brancwisebankdetails', 'branchname': branchname, 'month': month, 'year': year, 'Employeetype': Employeetype };
            var s = function (msg) {
                if (msg) {
                    fillbank_divchklist(msg);
                    BranchNamewisebankname(msg);
                    allbanksdata = msg;
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);

            callHandler(data, s, e);
        }
        var allbanksdata;
        function fillbank_divchklist(msg) {
            allbanksdata = [];
            allbanksdata = msg;
            var branchname = [];
            var sel = document.getElementById('Slect_Name');
            var opt = document.createElement('option');
            opt.innerHTML = "Select branch";
            opt.value = "Select branch";
            sel.appendChild(opt);
            for (var i = 0; i < allbanksdata.length; i++) {
                if (typeof allbanksdata[i] === "undefined" || allbanksdata[i].branchname == "" || allbanksdata[i].branchname == null) {
                }
                else {
                    if (branchname.indexOf(allbanksdata[i].branchname) == -1) {
                        var branchname1 = allbanksdata[i].branchname;
                        var branchid = allbanksdata[i].branchid;
                        branchname.push(branchname1);
                        var opt = document.createElement('option');
                        opt.innerHTML = branchname;
                        opt.value = branchid;
                        sel.appendChild(opt);
                    }
                }
            }
            var opt = document.createElement('option');
            opt.innerHTML = "Select All";
            opt.value = "Select All";
            sel.appendChild(opt);
        }

        function BranchNamewisebankname() {
            var selectedbranch = document.getElementById('Slect_Name').value
            if (selectedbranch == "") {
                selectedbranch = "Select All";
            }
            document.getElementById('divchblroutes').innerHTML = "";
            var branch = [];
            for (var i = 0; i < allbanksdata.length; i++) {
                if (typeof allbanksdata[i] === "undefined" || allbanksdata[i].branchname == "" || allbanksdata[i].branchname == null) {
                }
                else {
                    var tbranchname = allbanksdata[i].branchname;
                    var tbranchid = allbanksdata[i].branchid;

                    if (selectedbranch != "Select All") {
                        if (tbranchid == selectedbranch) {
                            tbranchname = tbranchname.replace(/[^a-zA-Z0-9]/g, '');
                            var exists = branch.indexOf(tbranchname);
                            if (exists == -1) {
                                var branchname = allbanksdata[i].branchname;
                                branchname = branchname.replace(/[^a-zA-Z0-9]/g, '');
                                branch.push(branchname);
                                $("#divchblroutes").append("<div id='div" + branchname + "' class='divcategory'>");
                            }
                        }
                    }
                    else {
                        tbranchname = tbranchname.replace(/[^a-zA-Z0-9]/g, '');
                        var exists = branch.indexOf(tbranchname);
                        if (exists == -1) {
                            var branchname = allbanksdata[i].branchname;
                            branchname = branchname.replace(/[^a-zA-Z0-9]/g, '');
                            branch.push(branchname);
                            $("#divchblroutes").append("<div id='div" + branchname + "' class='divcategory'>");
                        }
                    }
                }
            }
            for (var p = 0; p < branch.length; p++) {
                $("#div" + branch[p] + "").append("<div class='titledivcls'><table id='banktable' style='width:100%;'><tr><td style='width: 120px;'><h2 class='unitline'>" + branch[p] + "</h2></td><td></td><td style='padding-right: 20px;vertical-align: middle;'><span class='iconminus' title='Hide' onclick='minusclick(this);'></span></td></tr></table></div>");
                $("#div" + branch[p] + "").append("<ul id='ul" + branch[p] + "' class='ulclass'>");
                for (var i = 0; i < allbanksdata.length; i++) {
                    var tbranchname = allbanksdata[i].branchname;
                    tbranchname = tbranchname.replace(/[^a-zA-Z0-9]/g, '');
                    if (typeof allbanksdata[i] === "undefined" || allbanksdata[i].Bankname == "" || allbanksdata[i].Bankname == null) {
                    }
                    else {
                        if (branch[p] == tbranchname) {
                            var label = document.createElement("span");
                            var hidden = document.createElement("input");
                            hidden.type = "hidden";
                            hidden.Bankname = "hidden";
                            hidden.value = allbanksdata[i].bankid;

                            var checkbox = document.createElement("input");
                            checkbox.type = "checkbox";
                            checkbox.Bankname = "checkbox";
                            checkbox.value = allbanksdata[i].bankid;
                            checkbox.id = "checkbox";
                            checkbox.className = 'chkclass';
                            document.getElementById('ul' + branch[p]).appendChild(checkbox);
                            label.innerHTML = allbanksdata[i].Bankname;
                            document.getElementById('ul' + branch[p]).appendChild(label);
                            document.getElementById('ul' + branch[p]).appendChild(hidden);
                            document.getElementById('ul' + branch[p]).appendChild(document.createElement("br"));
                        }
                    }
                }
                checkbox.onclick = TabclassClick();
            }

        }

        var array = [];
        function TabclassClick() {
            $("input[type='checkbox']").click(function () {
                document.getElementById('divselected').innerHTML = "";
                var bankarry = [];
                $('input.chkclass:checkbox:checked').each(function () {
                    var sThisVal = $(this).val();
                    bankarry.push({ 'bankarrysid': sThisVal });
                });
                var branchname = document.getElementById("Slect_Name").value;
                var month = document.getElementById("ddlmonth").value;
                var year = document.getElementById("year1").value;
                var Selected = $(this).next().text();
                var Selectedid = $(this).next().next().val();
                var data = { 'op': 'get_bankwiseemployeedetails', 'branchname': branchname, 'month': month, 'year': year, 'Selectedid': Selectedid, 'bankarry': bankarry };
                var s = function (msg) {
                    if (msg) {
                        array = msg;
                        var k = 1;
                        var l = 0;
                        //                        var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                        var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" id="tb_empbank">';
                        results += '<thead><tr><th scope="col"></th><th></th><th scope="col">Employee name</th><th scope="col">Employee code</th><th scope="col">Netpay</th><th scope="col">Partial Amount</th></tr></thead></tbody>';
                        for (var i = 0; i < msg.length; i++) {
                            results += '<tr><td>' + k++ + '</td><td><input type="checkbox" class="checkbox"  name="sno" id="txt_sno" onclick="getme(this)" value="sno"></td>';
                            results += '<td data-title="Employeename" id="txt_emp" class="2">' + msg[i].Employeename + '</td>';
                            results += '<td data-title="brandstatus" id="txt_empcode" class="3">' + msg[i].Employeecode + '</td>';
                            results += '<td data-title="brandstatus" id="txt_netpay" class="4">' + msg[i].Netpay + '</td>';
                            results += '<td data-title="brandstatus" id="txt_partialqty" class="20"><input id="txt_partialpay" type="text" class="quantity" style="width:90px;" value="' + msg[i].Netpay + '"/></td>';
                            results += '<td data-title="brandstatus" style="display:none" id="txt_code" class="5">' + msg[i].ifsc + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none"id="txt_bankid" class="6">' + msg[i].bankid + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="7">' + msg[i].designation + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="8">' + msg[i].salary + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none"class="9">' + msg[i].gross + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="10">' + msg[i].basic + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="11">' + msg[i].emptype + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="12">' + msg[i].deptid + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="13">' + msg[i].bankaccountno + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="14">' + msg[i].empid + '</td>';
                            results += '<td data-title="brandstatus"  style="display:none" class="16">' + msg[i].empphonnum + '</td>';
                            results += '<td data-title="brandstatus" style="display:none"  class="15">' + msg[i].branchid + '</td></tr>';

                        }
                        results += '</table></div>';
                        $("#divselected").append(results);
                    }
                    else {
                    }
                };
                var e = function (x, h, e) {
                };
                $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
                CallHandlerUsingJson(data, s, e);

            });
        }
        var emparry = [];
        function getme(thisid) {

            var empname = $(thisid).parent().parent().children('.2').html();
            var empcode = $(thisid).parent().parent().children('.3').html();
            var netpay = $(thisid).parent().parent().children('.4').html();
            var partialpay = $(thisid).parent().parent().find('#txt_partialpay').val();
            var ifsccode = $(thisid).parent().parent().children('.5').html();
            var bankid = $(thisid).parent().parent().children('.6').html();
            var designation = $(thisid).parent().parent().children('.7').html();
            var salary = $(thisid).parent().parent().children('.8').html();
            var gross = $(thisid).parent().parent().children('.9').html();
            var basic = $(thisid).parent().parent().children('.10').html();
            var emptype = $(thisid).parent().parent().children('.11').html();
            var deptid = $(thisid).parent().parent().children('.12').html();
            var bankaccountno = $(thisid).parent().parent().children('.13').html();
            var empid = $(thisid).parent().parent().children('.14').html();
            var branchid = $(thisid).parent().parent().children('.15').html();
            var empphonnum = $(thisid).parent().parent().children('.16').html();
            emparry.push({ 'empname': empname, 'empcode': empcode, 'netpay': partialpay, 'ifsccode': ifsccode, 'bankid': bankid, 'designation': designation, 'salary': salary, 'gross': gross, 'basic': basic, 'emptype': emptype, 'deptid': deptid, 'bankaccountno': bankaccountno, 'empid': empid, 'branchid': branchid, 'empphonnum': empphonnum });
        }

        function save_empdetails() {
            if (emparry == 0) {
                alert("You must select at least one checkbox!");
                return false;
            }
            var month = document.getElementById("ddlmonth").value;
            var filename = document.getElementById("txt_filenames").value;
            if (filename == "") {
                alert("You must enter filename");
                return false;
            }
            var year = document.getElementById("year1").value;
            var btnval = document.getElementById('btn_save').value;
            var branchid = document.getElementById("Slect_Name").value;
            var data = { 'op': 'save_emp_bankformatedetails', 'btnval': btnval, 'filename': filename, 'branchid': branchid, 'emparry': emparry, 'month': month, 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        emparry = [];
                        alert(msg);
                        TabclassClick();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };

            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson_POST(data, s, e);
        }

        function get_filenames_details() {
            var branchname = document.getElementById("Slect_Name").value;
            var month = document.getElementById("ddlmonth").value;
            var year = document.getElementById("year1").value;
            var data = { 'op': 'get_filenames_details', 'branchname': branchname, 'month': month, 'year': year };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillfiledetails(msg);

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
        function fillfiledetails(msg) {
            for (var i = 0; i < msg.length; i++) {
                document.getElementById("ddl_filename").value = msg[i].filename;
            }
        }
        function validate_filename() {
            var thisfilename = document.getElementById("txt_filenames").value;
        }

        var routedata = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        //                        fillempcode(msg);
                        fillemployeetype(msg);
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
        function fillemployeetype(msg) {
            var data = document.getElementById('Slc_emptype');
            var length = data.options.length;
            document.getElementById('Slc_emptype').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Employeetype";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].employeetype != null) {
                    if (routedata.indexOf(msg[i].employeetype) == -1) {
                        var option = document.createElement('option');
                        option.innerHTML = msg[i].employeetype;
                        option.value = msg[i].employeetype;
                        data.appendChild(option);
                        routedata.push(msg[i].employeetype);
                    }
                }
            }
        }

     
    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Bank File Format<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-pie-chart"></i>Bank File Format Reports</a></li>
            <li><a href="#">Pie Chart</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank File Format
                </h3>
            </div>
            <div class="box-body">
                <div style="width: 100%;padding-bottom: 2%;" align="center">
                    <table>
                        <tr>
                            <td>
                                <label id="bname">Branch Name</label>
                                <select id="Slect_Name" class="form-control">
                                </select>
                            </td>
                             <td>
                                <label id="Label1">Employee Type</label>
                                <select id="Slc_emptype" class="form-control">
                                </select>
                            </td>
                           <td>
                             <label> Month  </label>
                             <select  id="ddlmonth" class="form-control">
                                 <option value="00">Select Month</option>
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
                            <td>
                                <label> Year</label>
                              <select  id="year1" class="form-control"></select>
                            </td>
                            <td style="padding-top: 4%;">
                                <input type="button" id="submit" value="Generate" class="btn btn-primary" onclick="FillBanknames()" />
                            </td>
                             <td>
                                <label id="Span1">File Name</label>
                                        <input id="txt_filenames"  class="form-control" placeholder="Enter File Name" />
                                         <input id="ddl_filename" type="hidden";/>
                                        </td>
                                        <td  style="padding-top: 4%;">
                                      <input type="button" id="btn_save" value="Save" class="btn btn-primary" onclick="save_empdetails();" />
                                        </td>
                        </tr>
                    </table>
                </div>
               <div style="width: 30%; float: left; height: 100%;">
                            <div class="box box-info" style="float: left; width: 240px; height: 330px; overflow: auto;">
                                <div class="box-header with-border">
                                    <h3 class="box-title">
                                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Bank Details
                                    </h3>
                                </div>
                                <div class="box-body">
                                    <div id="divchblroutes">
                                    </div>
                                </div>
                            </div>
                        </div>
                         <div class="box box-info" style="float: left; width: 70%; height: 777px; overflow: auto;">
                                            <div class="box-header with-border">
                                                <h3 class="box-title">
                                                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Selected Location Employees(s)
                                                </h3>
                                            </div>
                                            <div class="box-body">
                                                <div id="divselected">
                                                </div>
                                            </div>
                                        </div>
                                       
            </div>
            </section>
</asp:content>
