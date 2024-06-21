<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="EmployeeInfo.aspx.cs" Inherits="EmployeeInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            //---Bank details---//
            showBankdetails();
            get_bank_details();
            get_Employe_bankdetails();
            get_empbank_details();

            //---Family details---//
            get_familydetailes();
            get_Employeedetailsadd();
            //---Asset details---//
            get_Assets_details();

            //---transfer details---//
            get_transfer_branch_details();
            get_from_Branch_details();
            get_To_Branch_details();
            get_Employee_transferdetails();

            //---Organisation flow---//
            get_Employee_orgdetails();
            get_organisation_tree_details();

            //---Family details---//
            $('#add_Inward').click(function () {
                $('#vehmaster_fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_inwardtable').hide();

                get_Dept_details();
                Get_Fixedrows();
            });
            $('#close_id1').click(function () {
                $('#vehmaster_fillform').css('display', 'none');
                //                $('#div_Familydetails').css('display', 'block'); 
                $('#div_inwardtable').show();
                $('#showlogs').show();
            });

            //---Asset details---//
            $('#btn_addasset').click(function () {
                $('#fillform').css('display', 'block');
                $('#showlogs').css('display', 'none');
                $('#div_banktdata').hide();
                $('#div_assetdata').hide();
                get_addasset_Employeedetails();
                get_Assets_details();
                get_Assetsreturn_details();
                GetFixedrows();
            });

            $('#close_id2').click(function () {
                $('#fillform').css('display', 'none');
                $('#showlogs').css('display', 'block');
                $('#div_banktdata').show();
                $('#div_assetdata').show();
            });
        });

        function showBankdetails() {
            $("#Div_Bankdetails").show();
            $("#div_Familydetails").hide();
            $("#div_Bankdetails").hide();
            $("#div_assetdetails").hide();
            $("#div_transferdetails").hide();
            $("#div_orgflowdetails").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            $('#div_banktdata').show()
            //            forclearalldepart();
        }
        function showFamilydetails() {
            $("#Div_Bankdetails").hide();
            $("#div_Familydetails").show();
            $("#div_Bankdetails").hide();
            $("#div_assetdetails").hide();
            $("#div_transferdetails").hide();
            $("#div_orgflowdetails").hide();
            $('#showlogs').show()
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            $('#div_inwardtable').show();
            //            forclearalldesign();
        }
        function showAssetDetails() {
            $("#Div_Bankdetails").hide();
            $("#div_Familydetails").hide();
            $("#div_Bankdetails").hide();
            $("#div_assetdetails").show();
            $("#div_transferdetails").hide();
            $("#div_orgflowdetails").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            $('#div_asset').show()
            $('#div_assetdata').show()
            $("#div_firstasset").css("display", "block");

        }
        function showTransferDetails() {
            $("#Div_Bankdetails").hide();
            $("#div_Familydetails").hide();
            $("#div_Bankdetails").hide();
            $("#div_assetdetails").hide(); ;
            $("#div_transferdetails").show();
            $("#div_orgflowdetails").hide();
            $('#div_holiday').hide()
            $('#div_shiftData').hide()
            $('#div_bullten').hide()
            //            forclearallid();
        }
        function showOrgDetails() {
            $('#Div_Bankdetails').hide()
            $("#div_Familydetails").hide();
            $("#div_Bankdetails").hide();
            $("#div_assetdetails").hide();
            $("#div_transferdetails").hide();
            $("#div_orgflowdetails").show();

            $('#div_holiday').hide();
            $('#div_shiftData').hide();
            $('#div_bullten').hide();
            //            companycanceldetails();
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

        //---------------Employe bank details-----------------//

        //Function for only no
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
        function get_bank_details() {
            var data = { 'op': 'get_bank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbank_details(msg);
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
        function fillbank_details(msg) {
            var data = document.getElementById('slct_bank');
            var length = data.options.length;
            document.getElementById('slct_bank').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select bank";
            opt.value = "Select bank";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].name != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].name;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }
        var empname_data = [];
        function get_Employe_bankdetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    empname_data = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_employe').autocomplete({
                        source: empnameList,
                        change: empchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function empchange() {
            var empname = document.getElementById('selct_employe').value;
            for (var i = 0; i < empname_data.length; i++) {
                if (empname == empname_data[i].empname) {
                    document.getElementById('txtempid').value = empname_data[i].empsno;
                    document.getElementById('txtempcode').value = empname_data[i].empnum;
                }
            }
        }
        function for_save_edit_empbankdetails() {
            var employeid = document.getElementById('txtempid').value;
            var empcode = document.getElementById('txtempcode').value;
            if (employeid == "") {
                $("#selct_employe").focus();
                alert("Select Employee Name ");
                return false;
            }
            var paymenttype = document.getElementById('slct_payment').value;
            if (paymenttype == "" || paymenttype == "Select payment type") {
                alert("Please Select payment type");
                return false;
            }
            else if (paymenttype == "Cash") {
            }
            else {
                var AccountNo = document.getElementById('txtaccountno').value;
                if (AccountNo == "") {
                    alert("Please enter Account No");
                    return false;
                }
                var bankid = document.getElementById('slct_bank').value;
                if (bankid == "") {
                    alert("please Select Bank Details");
                    return false;
                }
                var Branch = document.getElementById('txtbranch').value;
                if (Branch == "") {
                    alert("Please Enter Branch Details");
                    return false;
                }
                var IFSC = document.getElementById('txtifsc').value;
                if (IFSC == "") {
                    alert("Please Enter IFSC Code");
                    return false;
                }
                var Caddress = document.getElementById('txtcaddress').value;
                if (Caddress == "") {
                    alert("Please Enter Address");
                    return false;
                }
                var nameasforbank = document.getElementById('txt_nmaebank').value;
                if (nameasforbank == "") {
                    alert("Please Enter Name As For Bank Record");
                    return false;
                }
            }

            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').innerHTML;
            var data = { 'op': 'save_edit_empbankdetails', 'employeid': employeid, 'AccountNo': AccountNo, 'bankid': bankid, 'Branch': Branch, 'IFSC': IFSC, 'Caddress': Caddress, 'paymenttype': paymenttype, 'nameasforbank': nameasforbank, 'empcode': empcode, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_empbank_details();
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function empbank_forclearall() {
            document.getElementById('txtaccountno').value = "";
            document.getElementById('selct_employe').value = "";
            document.getElementById('slct_bank').value = "";
            document.getElementById('txtbranch').value = "";
            document.getElementById('slct_payment').value = "";
            document.getElementById('txtifsc').value = "";
            document.getElementById('txt_nmaebank').value = "";
            document.getElementById('btn_save').value = "Save";
            GetFixedrows();
        }
        var empdata = [];
        function get_empbank_details() {
            var data = { 'op': 'get_empbank_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbankdetails(msg);
                        empdata = msg;
                        fillbankdata(msg);
                        fillbankdata1(msg);
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
        function fillbankdetails(msg) {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Payment Type</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                results += '<td  class="12">' + msg[i].paymenttype + '</td>';
                results += '<td  class="15">' + msg[i].bankname + '</td>';
                results += '<td  class="3">' + msg[i].accountno + '</td>';
                results += '<td  class="6">' + msg[i].ifsc + '</td>';
                results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_banktdata").html(results);
        }
        function getme(thisid) {
            var fullname = $(thisid).parent().parent().children('.11').html();
            var employeid = $(thisid).parent().parent().children('.2').html();
            var AccountNo = $(thisid).parent().parent().children('.3').html();
            var bankid = $(thisid).parent().parent().children('.4').html();
            var Branch = $(thisid).parent().parent().children('.5').html();
            var IFSC = $(thisid).parent().parent().children('.6').html();
            var Caddress = $(thisid).parent().parent().children('.7').html();
            var sno = $(thisid).parent().parent().children('.9').html();
            var paymenttype = $(thisid).parent().parent().children('.12').html();
            var nameasforbank = $(thisid).parent().parent().children('.13').html();
            var empcode = $(thisid).parent().parent().children('.1').html();
            var bankname = $(thisid).parent().parent().children('.15').html();

            document.getElementById('selct_employe').value = fullname;
            document.getElementById('txtempid').value = employeid;
            document.getElementById('txtaccountno').value = AccountNo;
            document.getElementById('slct_bank').value = bankid;
            document.getElementById('txtbranch').value = Branch;
            document.getElementById('txtifsc').value = IFSC;
            document.getElementById('txtcaddress').value = Caddress;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('slct_payment').value = paymenttype
            document.getElementById('txt_nmaebank').value = nameasforbank;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
        }


        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        function fillbankdata(msg) {
            var compiledList = [];
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
            document.getElementById('txtempCode').value = "";
            var k = 1;
            var name = document.getElementById('txt_empname1').value;
            var msg = empdata;
            if (name == "") {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Payment Type</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                    results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                    results += '<td  class="12">' + msg[i].paymenttype + '</td>';
                    results += '<td  class="15">' + msg[i].bankname + '</td>';
                    results += '<td  class="3">' + msg[i].accountno + '</td>';
                    results += '<td  class="6">' + msg[i].ifsc + '</td>';
                    results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                    results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                    results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                    results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                    results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_banktdata").html(results);
            }
            else {
                var l = 0;
                var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Payment Type</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    if (name == msg[i].fullname) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                        results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                        results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                        results += '<td  class="12">' + msg[i].paymenttype + '</td>';
                        results += '<td  class="15">' + msg[i].bankname + '</td>';
                        results += '<td  class="3">' + msg[i].accountno + '</td>';
                        results += '<td  class="6">' + msg[i].ifsc + '</td>';
                        results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                        results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                        results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                        results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                        results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                        results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                        results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                results += '</table></div>';
                $("#div_banktdata").html(results);
            }
        }

        function fillbankdata1(msg) {
            var compiledList1 = [];
            for (var i = 0; i < msg.length; i++) {
                var empcode = msg[i].empcode;
                compiledList1.push(empcode);
            }

            $('#txtempCode').autocomplete({
                source: compiledList1,
                change: empnamecode,
                autoFocus: true
            });
        }
        function empnamecode() {
            document.getElementById('txt_empname1').value = "";
            var empcode = document.getElementById('txtempCode').value;
            var k = 1;
            var msg = empdata;
            if (empcode == "") {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col" >Employee Code</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                    results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                    results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                    results += '<td  class="15">' + msg[i].bankname + '</td>';
                    results += '<td  class="3">' + msg[i].accountno + '</td>';
                    results += '<td  class="6">' + msg[i].ifsc + '</td>';
                    results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                    results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                    results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                    results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                    results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                    results += '<td style="display:none" class="12">' + msg[i].paymenttype + '</td>';
                    results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                    //results += '<td><a class="btn icon-btn btn-primary" id="btn_poplate" onclick="getme(this)" style=" padding: 6px 6px 4px 3px; border-radius:50px;" href="#"><span id="btn_poplate" onclick="getme(this)" name="submit" class="glyphicon btn-glyphicon glyphicon-pencil img-circle text-muted"></span>Edit</a></td></tr>';
                    results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';

                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
                results += '</table></div>';
                $("#div_banktdata").html(results);
            }

            else {
                var l = 0;
                var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
                var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
                results += '<thead><tr><th scope="col">Sno</th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">Bank Name</th><th scope="col">Account NO</th><th scope="col">IfscCode</th><th scope="col"></th></tr></thead></tbody>';
                for (var i = 0; i < msg.length; i++) {
                    if (empcode == msg[i].empcode) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                        results += '<th scope="row"  class="1">' + msg[i].empcode + '</th>';
                        results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                        results += '<td  class="15">' + msg[i].bankname + '</td>';
                        results += '<td  class="3">' + msg[i].accountno + '</td>';
                        results += '<td  class="6">' + msg[i].ifsc + '</td>';
                        results += '<td  style="display:none" class="2">' + msg[i].employeid + '</td>';
                        results += '<td style="display:none" class="4">' + msg[i].bankid + '</td>';
                        results += '<td  style="display:none" class="5">' + msg[i].branch + '</td>';
                        results += '<td style="display:none" class="7">' + msg[i].caddress + '</td>';
                        results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                        results += '<td style="display:none" class="12">' + msg[i].paymenttype + '</td>';
                        results += '<td style="display:none" class="13">' + msg[i].nameasforbank + '</td>';
                        //results += '<td><a class="btn icon-btn btn-primary" id="btn_poplate" onclick="getme(this)" style=" padding: 6px 6px 4px 3px; border-radius:50px;" href="#"><span id="btn_poplate" onclick="getme(this)" name="submit" class="glyphicon btn-glyphicon glyphicon-pencil img-circle text-muted"></span>Edit</a></td></tr>';
                        results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                        l = l + 1;
                        if (l == 4) {
                            l = 0;
                        }
                    }
                }
                $("#div_banktdata").html(results);
            }
        }

        //-----------------Employe Family Details----------//

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
        function get_Employeedetailsadd() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;

                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#slct_employeadd').autocomplete({
                        source: empnameList,
                        change: employeenamechangeadd,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function employeenamechangeadd() {
            var empname = document.getElementById('slct_employeadd').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                    document.getElementById('txtempcode').value = employeedetails[i].empnum;
                }
            }
        }
        function Get_Fixedrows() {
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
            $("#div_empfamilyData").html(results);
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
                results += '<td data-title="Phosps"  ><select id="slct_gender" class="form-control" style="" ><option   value="Male">Male</option><option  value="Female">Female</option></select></td>';
                results += '<td ><input id="slct_country" type="text" class="form-control"  style=""  value="' + DataTable[i].nationalty + '"/></td>';
                results += '<td ><input id="txt_Proffision" type="text" class="form-control" onkeypress="return ValidateAlpha(event);" style=""  value="' + DataTable[i].profession + '"/></td>';
                results += '<th data-title="From"><input class="form-control" type="hidden"  id="txt_sno"  name="nationalty" value="' + DataTable[i].sno + '" ></input>';
                // results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_empfamilyData").html(results);
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
            var data = { 'op': 'save_Employee_Family_click', 'employeid': employeid, 'empcode': empcode, 'department': department, 'DataTable': DataTable, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
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
            Get_Fixedrows();
            //compiledList = [];
        }
        var empdata = [];
        function get_familydetailes() {
            var data = { 'op': 'getfamilydetailes' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fill_foreground_tbl(msg);
                        empdata = msg;
                        fillfamilydata(msg);
                        fillfamilydata1(msg);
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
            $("#div_empfamilyData").html(results);
        }

        //var compiledList = [];
        function fillfamilydata(msg) {
            var compiledList = [];
            var employee = msg[0].familyedetailes
            for (var i = 0; i < employee.length; i++) {
                var empname = employee[i].fullname;
                compiledList.push(empname);
            }

            $('#text_empfamilyname').autocomplete({
                source: compiledList,
                change: familyempnamechange,
                autoFocus: true
            });
        }

        function familyempnamechange() {
            document.getElementById('txt_empcode1').value = "";
            var name = document.getElementById('text_empfamilyname').value;
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
        function fillfamilydata1(msg) {
            var compiledList1 = [];
            var employee = msg[0].familyedetailes
            for (var i = 0; i < employee.length; i++) {
                var empcode = employee[i].empcode;
                compiledList1.push(empcode);
            }

            $('#txt_empcode1').autocomplete({
                source: compiledList1,
                change: familyempnamecode,
                autoFocus: true
            });
        }
        function familyempnamecode() {
            document.getElementById('text_empfamilyname').value = "";
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

        //----------employe asset details-------------//

        var employeedetails = [];
        function get_addasset_Employeedetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#selct_asset_employee').autocomplete({
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
            var empname = document.getElementById('selct_asset_employee').value;
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
        function asset_insertrow() {
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
                $('#selct_employee').focus();
                alert("Select Employee Name ");
                return false;
            }
            var sno = document.getElementById('lbl_sno').value;
            var empcode = document.getElementById('txtempcode').value;
            var btnval = document.getElementById('btn_savee').value;
            var data = { 'op': 'save_edit_empassetdetails', 'employeid': employeid, 'empcode': empcode, 'DataTable': DataTable, 'sno': sno, 'btnval': btnval };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    get_Assets_details();
                    $('#fillform').css('display', 'none');
                    $('#showlogs').css('display', 'block');
                    $('#div_assetdata').show();
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
                        fillassetdetails(msg);
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
        function fillassetdetails(msg) {
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
            $("#div_assetdata").html(results);
        }
        var empcode = "";
        function getme(thisid) {
            $('#fillform').css('display', 'block');
            $('#showlogs').css('display', 'none');
            $('#div_assetdata').hide();
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
            document.getElementById('selct_employee').value = "";
            document.getElementById('txtAssetName').value = "";
            document.getElementById('txtRecievedDate').value = "";
            document.getElementById('txtAssetValue').value = "";
            document.getElementById('txtAssetDetails').value = "";
            document.getElementById('txtRemarks').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            GetFixedrows();
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
        function show_asset() {
            $("#div_firstasset").css("display", "block");
            $("#div_returnasset").css("display", "none");
            //ODrequestDetails();
        }

        function show_assetreturn() {
            $("#div_firstasset").css("display", "none");
            $("#div_returnasset").css("display", "block");
        }


        //----------------Employee Transfer Details------------//


        var employeedetails = [];
        function get_Employee_transferdetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;

                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#slct_transeremploye').autocomplete({
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
            var empname = document.getElementById('slct_transeremploye').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txtsupid').value = employeedetails[i].empsno;
                    document.getElementById('txtempcode').value = employeedetails[i].empnum;
                    document.getElementById('txt_Frombranch').value = employeedetails[i].branchname;
                    document.getElementById('txt_fromid').value = employeedetails[i].branchid;
                }
            }
        }


        var branchdetails = [];
        function get_from_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    branchdetails = msg;
                    var branchList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var branchname = msg[i].branchname;
                        branchList.push(branchname);
                    }
                    $('#txt_Frombranch').autocomplete({
                        source: branchList,
                        change: branchfromchange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function branchfromchange() {
            var branchname = document.getElementById('txt_Frombranch').value;
            for (var i = 0; i < branchdetails.length; i++) {
                if (branchname == branchdetails[i].branchname) {
                    document.getElementById('txt_fromid').value = branchdetails[i].branchid;
                }
            }
        }


        var branchdetails = [];
        function get_To_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    branchdetails = msg;
                    var branchList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var branchname = msg[i].branchname;
                        branchList.push(branchname);
                    }
                    $('#txt_tobranch').autocomplete({
                        source: branchList,
                        change: branchTochange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function branchTochange() {
            var branchname = document.getElementById('txt_tobranch').value;
            for (var i = 0; i < branchdetails.length; i++) {
                if (branchname == branchdetails[i].branchname) {
                    document.getElementById('txt_Toid').value = branchdetails[i].branchid;
                }
            }
        }

        function employeefillbranch() {
            var employeid = document.getElementById('txtsupid').value;
            document.getElementById('txt_Frombranch').value = branchid;
        }


        function save_employee_transfer() {
            var employeid = document.getElementById('txtsupid').value;
            if (employeid == "") {
                alert("Select Employee Name ");
                $('#slct_transeremploye').focus();
                return false;
            }
            var empcode = document.getElementById('txtempcode').value;
            var tobranch = document.getElementById('txt_Toid').value;
            if (tobranch == "") {
                alert("Select to branch");
                $('#txt_Toid').focus();
                return false;
            }
            var frombranch = document.getElementById('txt_fromid').value;
            var date = document.getElementById('txt_date').value;
            if (date == "") {
                alert("select date");
                $('#txt_date').focus();
                return false;
            }
            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').innerHTML;
            var flag = false;
            var data = { 'op': 'save_employee_transfer', 'employeid': employeid, 'empcode': empcode, 'tobranch': tobranch, 'frombranch': frombranch, 'date': date, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_transfer_branch_details();
                    }

                }

                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }

        function forclearall() {
            document.getElementById('txtsupid').value = "";
            document.getElementById('txt_tobranch').value = "";
            document.getElementById('txt_Frombranch').value = "";
            document.getElementById('txtempcode').value = "";
            document.getElementById('slct_transeremploye').value = "";
            document.getElementById('txt_Toid').value = "";
            document.getElementById('txt_fromid').value = "";
            document.getElementById('txt_date').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            $("#lbl_code_error_msg").hide();
            $("#lbl_name_error_msg").hide();
            get_transfer_branch_details();
        }

        function get_transfer_branch_details() {
            var data = { 'op': 'get_transfer_branch_details' };
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
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">EmpName</th><th scope="col">FromBranch</th><th scope="col">ToBranch</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<td data-title="brandstatus" class="2">' + msg[i].fullname + '</td>';
                results += '<td data-title="brandstatus" class="5">' + msg[i].frombranch + '</td>';
                results += '<td data-title="brandstatus"  class="6">' + msg[i].tobranch + '</td>';
                results += '<th scope="row" class="1" style="display:none">' + msg[i].empid + '</th>';
                results += '<td data-title="brandstatus" style="display:none" class="3">' + msg[i].date + '</td>';
                results += '<td data-title="brandstatus"   style="display:none" class="4">' + msg[i].empcode + '</td>';
                results += '<td data-title="brandstatus" style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td data-title="brandstatus"   style="display:none" class="8">' + msg[i].frombranchid + '</td>';
                results += '<td data-title="brandstatus" style="display:none" class="9">' + msg[i].tobranchid + '</td>';
                results += ' <td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_transferdata").html(results);
        }
        function getme(thisid) {
            $('html, body').animate({
                scrollTop: $("#emptrnasdiv").offset().top
            }, 2000);
            var fullname = $(thisid).parent().parent().children('.2').html();
            var date = $(thisid).parent().parent().children('.3').html();
            var tobranch = $(thisid).parent().parent().children('.6').html();
            var frombranch = $(thisid).parent().parent().children('.5').html();
            var tobranchid = $(thisid).parent().parent().children('.8').html();
            var frombranchid = $(thisid).parent().parent().children('.9').html();
            var empid = $(thisid).parent().parent().children('.1').html();
            var empcode = $(thisid).parent().parent().children('.4').html();
            var sno = $(thisid).parent().parent().children('.7').html();

            //Department = replaceHtmlEntites(Department);
            document.getElementById('txtsupid').value = empid
            document.getElementById('txt_date').value = date;
            document.getElementById('txt_Toid').value = tobranchid;
            document.getElementById('txt_fromid').value = frombranchid
            document.getElementById('txt_tobranch').value = tobranch;
            document.getElementById('txt_Frombranch').value = frombranch;
            document.getElementById('txtempcode').value = empcode;
            document.getElementById('slct_transeremploye').value = fullname;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_save').innerHTML = "Modify";
        }

        var replaceHtmlEntites = (function () {
            var translate_re = /&(nbsp|amp|quot|lt|gt);/g;
            var translate = {
                "nbsp": " ",
                "amp": "&",
                "quot": "\"",
                "lt": "<",
                "gt": ">"
            };
            return function (s) {
                return (s.replace(translate_re, function (match, entity) {
                    return translate[entity];
                }));
            }
        })();

//-------------Organisation flow--------------//

        var employeedetails = [];
        function get_Employee_orgdetails() {
            var data = { 'op': 'get_Employeedetails' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var empname = msg[i].empname;
                        empnameList.push(empname);
                    }
                    $('#slct_orgemploye').autocomplete({
                        source: empnameList,
                        change: employeenamechange,
                        autoFocus: true
                    });
                    $('#selct_sub_employe').autocomplete({
                        source: empnameList,
                        change: subemployeenamechange,
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
            var empname = document.getElementById('slct_orgemploye').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_empid').value = employeedetails[i].empsno;
                }
            }
        }
        function subemployeenamechange() {
            var empname = document.getElementById('selct_sub_employe').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (empname == employeedetails[i].empname) {
                    document.getElementById('txt_sub_empid').value = employeedetails[i].empsno;
                }
            }
        }
        var gridBinding = [];
        function AddTogridClick() {
            $("#div_Deptdata").hide();
            var txt_sub_empid = document.getElementById('txt_sub_empid').value;
            var sub_employe_name = document.getElementById('selct_sub_employe').value;
            if (txt_sub_empid == "") {
                alert("Please select sub emp name");
                return false;
            }
            var Checkexist = false;
            $('.empid').each(function (i, obj) {
                var IName = $(this).text();
                if (IName == txt_sub_empid) {
                    alert("sub emp name Already Added");
                    Checkexist = true;
                }
            });
            if (Checkexist == true) {
                return;
            }
            gridBinding.push({ 'empid': txt_sub_empid, 'sub_employe_name': sub_employe_name });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Empid</th><th scope="col">Emp Name</th></tr></thead></tbody>';
            for (var i = 0; i < gridBinding.length; i++) {
                results += '<td scope="row"  class="empid">' + gridBinding[i].empid + '</td>';
                results += '<td scope="row"  class="empname">' + gridBinding[i].sub_employe_name + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_vendordata").html(results);
        }
        function save_organisation_tree_save_click() {
            var empname = document.getElementById('slct_orgemploye').value;
            if (empname == "") {
                $("#slct_orgemploye").focus();
                alert("Select Employee Name ");
                return false;
            }
            var btnsave = document.getElementById('btnSave').value;
            var Data = { 'op': 'save_organisation_tree_save_click', 'gridBinding': gridBinding, 'empid': empname };
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    RefreshClick();
                    get_organisation_tree_details();
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            CallHandlerUsingJson(Data, s, e);
        }
        function RefreshClick() {
            document.getElementById('txt_empid').value = "";
            gridBinding = [];
            $("#div_vendordata").hide();
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table"><caption></casption>';
            results += '<thead><tr><th scope="col">Employee Id</th><th scope="col">Employee Name</th></tr></thead></tbody>';
            for (var i = 0; i < gridBinding.length; i++) {
                results += '<td scope="row"  class="empid">' + gridBinding[i].empid + '</td>';
                results += '<td scope="row"  class="empname">' + gridBinding[i].sub_employe_name + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_vendordata").html(results);
        }


        function get_organisation_tree_details() {
            var data = { 'op': 'get_organisation_tree_details' };
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
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div  style="overflow:auto; text-align: center;padding:1%"><table style="text-align: center;" class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr ><th scope="col" style="text-align: center;">Sno</th><th scope="col" style="text-align: center;">Employee Code</th><th scope="col" style="text-align: center;"><i class="fa fa-user"></i>Employee Name</th><th scope="col"style="text-align: center;" >Sub Employee Code</th><th scope="col" style="text-align: center;"><i class="fa fa-user"></i>Sub Employee Name</th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                //k++;
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row" class="1" style="text-align:center;">' + msg[i].empcode + '</th>';
                results += '<td  class="11">' + msg[i].fullname + '</td>';
                results += '<td data-title="Code" class="2">' + msg[i].empcode1 + '</td>';
                results += '<td class="5">' + msg[i].fullname1 + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].employeid1 + '</td>';
                results += '<td style="display:none" class="12">' + msg[i].employeid + '</td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_orignaizedata").html(results);
        }

        function showdivform() {
            $("#div_Import").css("display", "none");
            $("#div_OFTForm").css("display", "block");
        }
        function showdivimport() {
            $("#div_Import").css("display", "block");
            $("#div_OFTForm").css("display", "none");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content">
        <div class="row">
            <section class="content-header">
                <h1>
                   Employe Basic Information
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
                    <li><a href="#">Information</a></li>
                </ol>
            </section>
            </div>
                <div class="box box-info">
                    <div class="box-header with-border">
                    </div>
                    <div class="box-body">
                        <div>
                            <ul class="nav nav-tabs">
                                <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="showBankdetails()">
                                    <i class="fa fa-building-o" aria-hidden="true"></i>&nbsp;&nbsp;Employee Bank Details</a></li>
                                <li id="id_tab_documents" class=""><a data-toggle="tab" href="#" onclick="showFamilydetails()">
                                    <i class="fa fa-user" aria-hidden="true"></i>&nbsp;&nbsp;Employee Family Details</a></li>
                                <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showAssetDetails()"><i
                                    class="fa fa-university"></i>&nbsp;&nbsp;Employee Asset Details</a></li>
                                <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="showTransferDetails()"><i
                                    class="icon-money"></i>&nbsp;&nbsp;Employee Transfer Details</a></li>
                                <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="showOrgDetails()"><i
                                    class="fa fa-bar-chart"></i>&nbsp;&nbsp;Organisation Flow</a></li>
                            </ul>
                        </div>

                       <%-- --------Employe Bank Details-----------%>

                        <div id="Div_Bankdetails" style="display: none;">
                            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Bank Details
                </h3>
            </div>
            <section class="content">
         <div class="box box-info">
            <div style="float:left; padding-left:20px">
          <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                    src="Iconimages/bank.png" alt="your image" style="border-radius: 5px; width: 200px;
                    height: 200px; border-radius: 50%;" />
                    </div>
                 <div style="padding-right:auto">
            <table id="tbl_leavemanagement" align="center">
                <tr>
                    <td>
                     <label class="control-label" >
                        Employee Name 
                        </label>
                    </td>
                    <td>
                     <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employee Name" onkeypress="return ValidateAlpha(event);" />
                     </td>
                        <td style="height: 40px;">
                                <input id="txtempid" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                             <td style="height: 40px;">
                                <input id="txtempcode" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label" >
                        Account No 
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtaccountno" placeholder="EnterAccount" />
                    </td>
                    <td>
                     <label class="control-label" >
                        Bank Name  
                        </label>
                    </td>
                       <td>
                         <select id="slct_bank" class="form-control">
                         <option selected disabled value="Select bank">Select Bank</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="height: 40px;">
                     <label class="control-label" >
                        Branch Name
                        </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtbranch"  placeholder="EnterBranch" onkeypress="return ValidateAlpha(event);"/>
                    </td>
                    <td>
                     <label class="control-label" >
                       IFSC Code 
                       </label>
                    </td>
                    <td>
                        <input type="text" class="form-control" id="txtifsc" placeholder="Enter IFSC Code"/>
                    </td>
                </tr>
              
                <tr>
                    <td>
                     <label class="control-label" >
                        payment type
                        </label>
                    </td>
                    <td style="height: 40px;">
                        <select id="slct_payment" class="form-control">
                            <option value="Select payment type" disabled selected>Select payment Type</option>
                            <option value="Cash">Cash</option>
                            <option value="Credit">Credit</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="CheckPaid">CheckPaid</option>
                            <option value="FOC">FOC</option>
                            <option value="Refurbished">Refurbished</option>
                            <option value="Warranty">Warranty</option>
                            <option value="Transported">Transported</option>
                            <option value="Returnble">Returnble</option>
                            <option value="AgainstLoan">AgainstLoan</option>
                            <option value="Repair">Repair</option>
                            <option value="AuditCorrrection">AuditCorrrection</option>
                        </select>
                    </td>
                    <td>
                     <label class="control-label" >
                        Name as for bank record
                        </label>
                    </td>
                    <td>
                        <input name="comments" class="form-control" id="txt_nmaebank" placeholder="Enter Name bank record" onkeypress="return ValidateAlpha(event);"/>
                    </td>
                </tr>
                  <tr>
                    <td style="height: 40px;">
                     <label class="control-label" >
                        Bank Address 
                        </label>
                    </td>
                    <td colspan="3">
                        <textarea name="comments" class="form-control" id="txtcaddress" placeholder="Enter Bank address"></textarea>
                    </td>
                </tr>
                <tr hidden>
                    <td>
                        <label id="lbl_sno">
                        </label>
                    </td>
                </tr>
            </table>
            <div style="padding-left: 47%;padding-top: 2%;padding-bottom: 2%;">
            <table>
            <tbody><tr>
            <td>
                <div class="input-group">
                    <div class="input-group-addon">
                    <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="for_save_edit_empbankdetails()"></span><span id="btn_save" onclick="for_save_edit_empbankdetails()">Save</span>
                </div>
                </div>
                </td>
                <td style="width:10px;"></td>
                <td>
                    <div class="input-group">
                    <div class="input-group-close">
                    <span class="glyphicon glyphicon-remove" id="btn_close1" onclick="empbank_forclearall()"></span><span id="btn_close" onclick="empbank_forclearall()">Close</span>
                </div>
                </div>
                </td>
                </tr>
                </tbody></table>
                    </div>
                </div>
                <div>
                 <table align="center">
                        <tr>
                            <td>
                                <input id="txt_empname1" type="text"style="height: 38px;opacity: 1.0;width: 202px;"
                                    class="form-control" name="vendorcode" placeholder="Search Employee Name" />
                            </td>
                                    <td ><span class="input-group-btn">
                                            <button type="button" class="btn btn-info btn-flat" style="height: 38px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                            </span>
                                        </td>
                             <td style="width:5px;"></td>
                            <td >
                                OR
                            </td>
                            <td style="width:5px;"></td>
                            <td>
                                <input id="txtempCode" type="text" style="height: 38px;opacity: 1.0;width: 202px;"
                                    class="form-control" name="vendorcode" placeholder="Search Employee Code" />
                                    
                            </td>
                              <td>
                              <span class="input-group-btn">
                                    <button type="button" class="btn btn-info btn-flat" style="height: 38px;"><i class="fa fa-search" aria-hidden="true"></i></button>
                                  </span>
                                </td>
                              </tr>
                         </table>
                       <div id="div_banktdata" style="display:none;">
                     </div>
                   <br />
                 </div>
              </div>
            </section>
          </div>

<%-------------Employe Family Detailes-----------%>

     <div class="box-body" id="div_Familydetails" style="display:none;">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Family Details
                </h3>
            </div>
            <section class="content">
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
                                <input id="text_empfamilyname" type="text" style="height: 28px; opacity: 1.0; width: 150px;"
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
                                            <span class="glyphicon glyphicon-plus-sign" ></span> <span >Add Family</span>
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
                                    <table id="Table1" align="center">
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
                                                <input type="text" class="form-control" id="slct_employeadd" placeholder="Enter Employe Name"
                                                    onkeypress="return ValidateAlpha(event);" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                            </td>
                                            <td style="height: 40px;">
                                                <input id="Hidden1" type="hidden" class="form-control" name="hiddenempid" />
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
                                        <div id="div_empfamilyData">
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
                                <span class="glyphicon glyphicon-ok" id="Span1" onclick="save_Employee_Family_click()"></span> <span id="Span2" onclick="save_Employee_Family_click()">save</span>
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
                </section>
            </div>

 <%------------Employe asset Details-------------%>

 <div class="box-body" id="div_assetdetails" style="display:none;">
 <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Asset Details
                </h3>
            </div>
     <div id="div_asset" style="display: none;">
 <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="Li4" class="active"><a data-toggle="tab" href="#" onclick="show_asset()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Asset Master</a></li>
                    <li id="Li5" class=""><a data-toggle="tab" href="#" onclick="show_assetreturn()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Asset Return Details</a></li>
                </ul>
                </div>
               <div id="div_firstasset" style="display: none;">
            
            <div>
                <div class="box-body">
                    <div id="add_empasset" style="padding-left: 79%;" >
                    <div class="input-group" id="btn_addasset">
                                        <div class="input-group-addon" style="width: 124px;">
                                            <span class="glyphicon glyphicon-plus-sign"  ></span> <span id="btn_addasset" ">Add Employee Asset</span>
                    </div>
                </div>
                    </div>
                    <div id='fillform' style="display: none;">
                       <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img2"
                src="Iconimages/assets.png" alt="your image" style="border-radius: 5px; width: 50px;
                height: 40px; border-radius: 50%;" />
                 </div>
                      <table id="Table2" align="center">
                            <tr>
                                <td style="height: 40px;">
                                    <span style="color: red;">*</span> Employee Name
                                </td>
                                <td>
                                    <input type="text" class="form-control" id="selct_asset_employee" onkeypress="return ValidateAlpha(event);"
                                        placeholder="Enter Employee Name" />
                                </td>
                                <td style="height: 40px; display:none">
                                    <input id="Hidden2" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                                <td style="height: 40px;"  display:none">
                                    <input id="Hidden3" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                                </tr>
                               <tr hidden>
                                <td>
                                <label id="Label1">
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
                                            <span class="glyphicon glyphicon-ok" id="btn_savee" onclick="for_save_edit_empassetdetails()"></span><span id="btn_savee" onclick="for_save_edit_empassetdetails()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group" id="close_id2">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="close_id2" ></span><span id="Span7" >Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                            <div class="input-group" style="width: 30px;">
                        <div class="input-group-addon">
                            <span class="glyphicon glyphicon-plus-sign" onclick="asset_insertrow()"></span> <span onclick="asset_insertrow()">ADD NEW ROW</span>
                        </div>
                    </div>
                    </div>
                    <div>
                    <div>
                </div>
                    <div id="div_assetdata" style="display:none;">
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
                  <input id="Button1" type="button" style="display:none;" class="btn btn-danger" name="submit" value="Clear" />
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
              </div>
            </div>

<%------------Employee Transfer Details-------------%>

<div class="box-body" id="div_transferdetails" style="display:none;">
<div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Transfer Details
                </h3>
            </div>
<section class="content">
        <div class="box box-info" id="emptrnasdiv">
            <div>
             <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img3"
                src="Iconimages/transfers.png" alt="your image" style="border-radius: 5px; width: 150px;
                height: 100px; border-radius: 50%;" />
                </div>
                <table id="Table3" align="center">
                    <tr>
                        <td style="height: 40px;">
                          Employee Name
                        </td>
                    <td>
                        <input type="text" class="form-control" id="slct_transeremploye" placeholder="Enter employee name"
                            onkeypress="return ValidateAlpha(event);" />
                    </td>
                    <td style="dispaly:none">
                        <input id="Hidden4" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                    <td style="dispaly:none">
                        <input id="Hidden5" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                    <td style="height: 40px;">
                            Date <span style="color: red;">*</span>
                        </td>
                        <td>
                           <input type="Date" class="form-control" id="txt_date"/>
                        </td>
                    </tr>
                       <tr>
                             <td style="height: 40px;">
                            From Branch <span style="color: red;">*</span>
                        </td>
                        <td>
                           <input type="text" class="form-control" id="txt_Frombranch" placeholder="Enter FROM Branch"/>
                        </td>
                           <td style="dispaly:none">
                            <input id="txt_fromid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                        <td style="height: 40px;">
                        </td>
                                           
                        <td style="height: 40px;">
                            To Branch <span style="color: red;">*</span>
                        </td>
                        <td>
                           <input type="text" class="form-control" id="txt_tobranch" placeholder="Enter TO Branch"/>
                        </td >
                           <td style="dispaly:none">
                        <input id="txt_Toid" type="hidden" class="form-control" name="hiddenempid" />
                    </td>
                   </tr>
                <tr>
                <td>
                  </td>
                    </tr>
                    <tr hidden>
                        <td>
                            <label id="Label2">
                            </label>
                        </td>
                    </tr>
                </table>
                <br />
                <table align="center">
                <tr>
                    <td>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <span class="glyphicon glyphicon-ok" id="Span4" onclick="save_employee_transfer()"></span><span id="Span5"  onclick="save_employee_transfer()">Save</span>
                            </div>
                        </div>
                    </td>
                    <td style="width:10px;"></td>
                    <td>
                        <div class="input-group">
                            <div class="input-group-close">
                                <span class="glyphicon glyphicon-remove" id="Span8" onclick="forclearall()"></span><span id="Span9" onclick="forclearall()">Close</span>
                            </div>
                            </div>
                        </td>
                       </tr>
                      </table>
                    </div>
                    <div>
                <div id="div_transferdata">
                </div>
            </div>
        </div>
    </section>
    </div>

    <%------------Organisation Flow-------------%>
<div class="box-body" id="div_orgflowdetails" style="display:none;">
<div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Organisation Tree Details
                </h3>
            </div>
    <section class="content">
     <div style="background-color: aliceblue;">
                    <ul class="nav nav-tabs">
                        <li id="id_tab_Form" ><a data-toggle="tab" href="#" onclick="showdivform()">
                            <i class="fa fa-street-view"></i>&nbsp;&nbsp;Organisation Tree</a></li>
                        <li id="id_tab_Import" class=""><a data-toggle="tab" href="#" onclick="showdivimport()">
                            <i class="fa fa-file-text"></i>&nbsp;&nbsp;Organisation Tree Import</a></li>
                    </ul>
                </div>
                <div id="div_OFTForm">
        <div class="box box-info">
            
            <div class="box-body">
                <table>
                    <tr>
                        <td style="height: 40px;">
                        <label class="control-label" >
                            Employee Name<span style="color: red;">*</span>
                            </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="slct_orgemploye" placeholder="Enter Employee Name" />
                        </td>
                        <td style="height: 40px; display: none">
                            <input id="txt_empid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                        <td style="height: 40px;">
                        <label class="control-label" >
                            Sub Employee Name<span style="color: red;">*</span>
                            </label>
                        </td>
                        <td>
                            <input type="text" class="form-control" id="selct_sub_employe" placeholder="Enter Sub Employee Name" />
                        </td>
                        <td style="height: 40px; display: none">
                            <input id="txt_sub_empid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                        <td style="height: 40px;">
                            <div class="btn btn-success" style="width: 56px;">
                                <span class="glyphicon glyphicon-plus-sign" onclick="AddTogridClick()"></span> <span onclick="AddTogridClick()">Add</span>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <div id="div_vendordata" style="background: #ffffff">
                </div>
                <br />
            </div>
             <table align="center">
            <tr>
            <td>
                <div class="input-group">
                    <div class="input-group-addon">
                    <span class="glyphicon glyphicon-ok" id="btnSave1" onclick="save_organisation_tree_save_click()"></span><span id="btnSave" onclick="save_organisation_tree_save_click()">Save</span>
                </div>
                </div>
                </td>
                </table>
            <div id="div_orignaizedata">
            </div>
        </div>
        </div>
        <div id="div_Import" style="display: none;">
         <asp:UpdateProgress ID="updateProgress1" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                right: 0; left: 0; z-index: 9999999; background-color: #FFFFFF; opacity: 0.7;">
                <br />
                <asp:Image ID="imgUpdateProgress" runat="server" ImageUrl="thumbnails/loading.gif"
                    AlternateText="Loading ..." ToolTip="Loading ..." Style="padding: 10px; position: absolute;
                    top: 35%; left: 40%;" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div>
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Organisation Employee Import Details
                </h3>
            </div>
            <div class="box-body">
                <table>
                    <tr>
                    <td> 
                        <label class="control-label" >
                        <asp:Label ID="Label3" runat="server"  Text="Label">Employee Name</asp:Label>&nbsp;
                        </label>
                        <td>
                        <asp:DropDownList ID="ddlemployee" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </td>
                        <td>
                            <asp:FileUpload ID="FileUploadToServer" runat="server"  />
                        </td>
                        <td style="width: 5px;">
                        </td>
                            <label class="control-label" >
                        </label>
                        <td>
                            <asp:Button ID="btnImport" runat="server" Text="Import" class="btn btn-primary" OnClick="btnImport_Click" />
                        </td>
                    </tr>
                </table>
                <br />
                <asp:UpdatePanel ID="updPanel" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="grvExcelData" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                            GridLines="Both" Font-Bold="true" Font-Size="Smaller">
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                            <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                Font-Names="Raavi" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                            <AlternatingRowStyle HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#E2DED6" ForeColor="#333333" />
                        </asp:GridView>
                        </dr>
                        <asp:Button ID="Button2" runat="server" Text="Save" class="btn btn-primary" OnClick="btnSave_Click" />
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/exporttoxl.aspx">Export to XL</asp:HyperLink>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                           <div>
                        <asp:Label ID="lblMessage" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label><br />
                     </div>
                   </ContentTemplate>
                 </asp:UpdatePanel>
               </div>
             </div>
           </div>
            </div>
        </section>
        </div>
         </div>
   </section>
</asp:Content>
