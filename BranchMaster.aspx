<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="BranchMaster.aspx.cs" Inherits="BranchMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            get_Branch_details();
            get_CompanyMaster_details();
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
                Error: e
            });
        }
        function canceldetails() {
            $("#div_CategoryData").show();
            $("#fillform").hide();
            $('#showlogs').show();
            forclearall();
        }

        function get_CompanyMaster_details() {
            var data = { 'op': 'get_CompanyMaster_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcompany(msg);
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
        function fillcompany(msg) {
            var data = document.getElementById('selct_Cmpny');
            var length = data.options.length;
            document.getElementById('selct_Cmpny').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Company";
            opt.value = "Select Company";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].CompanyName != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].CompanyName;
                    option.value = msg[i].CompanyCode;
                    data.appendChild(option);
                }
            }
        }

        function saveBranchDetails() {
            var CompanyName = document.getElementById('selct_Cmpny').value;
            var branchname = document.getElementById('txtBrcName').value;
            var statename = document.getElementById('txtStatename').value;
            var Phone = document.getElementById('txtPhnNO').value;
            var emailid = document.getElementById('txtMail').value;
            var address = document.getElementById('txtAdrs').value;
            var fromdate = document.getElementById('txt_Fromdate').value;
            var todate = document.getElementById('txt_Todate').value;
            var nightallowance = document.getElementById('txt_Nytrate').value;
            var branchcode = document.getElementById('txt_bcode').value;
            var branchtype = document.getElementById('slct_Type').value;
            var sapcode = document.getElementById('txt_sapcode').value;
            var branchid = document.getElementById('lbl_sno').value;
            var btnval = document.getElementById('btn_save').innerHTML;
            if (CompanyName == "") {
                $("#selct_Cmpny").focus();
                alert("Select CompanyName ");
                return false;
            }
            if (sapcode == "") {
                $("#txt_sapcode").focus();
                alert("Enter Branch Code");
                return false;
            }
            if (branchname == "") {
                $("#txtBrcName").focus();
                alert("Enter Branchname ");
                return false;
            }
            if (statename == "") {
                $("#txtStatename").focus();
                alert("Enter  Statename");
                return false;
            }
            if (emailid == "") {
                $("#txtMail").focus();
                alert("Enter Section emailid");
                return false;
            }
            if (address == "") {
                $("#txtAdrs").focus();
                alert("Enter address");
                return false;
            }
           
            if (fromdate == "") {
                $("#txt_Fromdate").focus();
                alert("Enter From Date");
                return false;
            }
            if (todate == "") {
                $("#txt_Todate").focus();
                alert("Enter To Date");
                return false;
            }
            if (branchcode == "") {
                $("#txt_bcode").focus();
                alert("Enter Sub Code");
                return false;
            }
            var data = { 'op': 'saveBranchDetails', 'CompanyName': CompanyName, 'sapcode':sapcode,'branchname': branchname, 'branchid': branchid, 'statename': statename, 'Phone': Phone, 'emailid': emailid, 'address': address, 'fromdate': fromdate, 'nightallowance': nightallowance, 'branchtype': branchtype, 'branchcode': branchcode, 'todate': todate, 'btnVal': btnval };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_Branch_details();
                        $('#div_CategoryData').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
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
        function forclearall() {

            document.getElementById('selct_Cmpny').selectedIndex = 0;
            document.getElementById('txtBrcName').value = "";
            document.getElementById('txtStatename').selectedIndex = 0;
            document.getElementById('slct_Type').selectedIndex = 0;
            document.getElementById('txtPhnNO').value = "";
            document.getElementById('txtMail').value = "";
            document.getElementById('txtAdrs').value = "";
            document.getElementById('txt_Nytrate').value = "";
            document.getElementById('txt_sapcode').value = "";
            document.getElementById('txt_Fromdate').value = "";
            document.getElementById('txt_Todate').value = "";

            document.getElementById('txt_bcode').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
            get_Branch_details();
        }
        function showdesign() {
            $("#div_CategoryData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            forclearall();
        }

        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
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
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th></th><th scope="col">Branch Name</th><th scope="col">State Name</th><th scope="col">Emai Id</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">'; //<input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="Edit" />
                results += '<td>' + k++ + '</td>';
                results += '<th style="display:none"  scope="row" class="1" >' + msg[i].branchname + '</th>';
                results += '<th data-title="brandstatus" class="1"><span class="glyphicon glyphicon-triangle-right" style="color: cadetblue;"></span>  <span id="1" class="1">  ' + msg[i].branchname + ' </span></th>';
                results += '<td data-title="brandstatus" style="display:none"class="2">' + msg[i].branchid + '</td>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].statename + '</td>';
                results += '<td data-title="brandstatus"style="display:none" class="4">' + msg[i].Phone + '</td>';
                results += '<td data-title="brandstatus" class="5"><span class="fa fa-envelope" style="color: cadetblue;"></span><span class="5" id="5">' + msg[i].emailid + '</span></td>';
                results += '<td data-title="brandstatus"  style="display:none" class="7">' + msg[i].fromdate + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="8">' + msg[i].todate + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="9">' + msg[i].nightallowance + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="10">' + msg[i].branchtype + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="11">' + msg[i].CompanyName + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="12">' + msg[i].company_code + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="13">' + msg[i].branchcode + '</td>';
                results += '<td data-title="brandstatus"  style="display:none" class="14">' + msg[i].sapcode + '</td>';
                results += '<td data-title="brandstatus" style="display:none"class="6">' + msg[i].address + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_CategoryData").html(results);
        }

        function getme(thisid) {
            var branchname = $(thisid).parent().parent().children('.1').html();
            var branchid = $(thisid).parent().parent().children('.2').html();
            var statename = $(thisid).parent().parent().children('.3').html();
            var Phone = $(thisid).parent().parent().children('.4').html();
            var emailid = $(thisid).parent().parent().find('#5').html();
            var address = $(thisid).parent().parent().children('.6').html();
            var fromdate = $(thisid).parent().parent().children('.7').html();
            var todate = $(thisid).parent().parent().children('.8').html();
            var branchtype = $(thisid).parent().parent().children('.10').html();
            var nightallowance = $(thisid).parent().parent().children('.9').html();
            var CompanyName = $(thisid).parent().parent().children('.11').html();
            var company_code = $(thisid).parent().parent().children('.12').html();
            var branchcode = $(thisid).parent().parent().children('.13').html();
            var sapcode = $(thisid).parent().parent().children('.14').html();
            document.getElementById('txtBrcName').value = branchname;
            document.getElementById('slct_Type').value = branchtype;
            document.getElementById('txtStatename').value = statename;
            document.getElementById('txtPhnNO').value = Phone;
            document.getElementById('txtMail').value = emailid;
            document.getElementById('txtAdrs').value = address;
            document.getElementById('txt_Todate').value = todate;
            document.getElementById('txt_Fromdate').value = fromdate;
            document.getElementById('txt_Nytrate').value = nightallowance;
            document.getElementById('selct_Cmpny').value = company_code;
            document.getElementById('txt_bcode').value = branchcode;
            document.getElementById('txt_sapcode').value = sapcode;
            document.getElementById('lbl_sno').value = branchid;
            document.getElementById('btn_save').innerHTML = "Modify";
            $("#div_CategoryData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
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

        function checkLength(txtPhnNO) {
            var phone = document.getElementById('txtPhnNO').value;
            if (phone != 10) {
                alert("Mobile Number Must be of 10digits")
            }
        }
        function validationemail() {
            var x = document.getElementById("txtMail").value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= x.length) {
                alert("Not a valid e-mail address");

            }
        }

    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Branch Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operation</a></li>
            <li><a href="#">BranchMaster</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-home"></i>Branch Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                <table>
                <tr>
                 <td style="width:89%">
                            </td>
                <td>
                      <div class="input-group">
                           <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-plus-sign"  onclick="showdesign()"></span> <span  onclick="showdesign()">Add Branch</span>
                          </div>
                          </div>
               
                </td>
                </tr>
                </table>
                   
                </div>
                <div id="div_CategoryData">
                </div>
                <div id='fillform' style="display: none;">
                <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/branch.png" alt="your image" style="border-radius: 5px; width: 200px;
                                                                    height: 200px; border-radius: 50%;" />
                                                                    </div>
                    <table align="center">
                        <tr>
                            <td>
                             <label class="control-label" >
                                    Company Name</label>
                                <select id="selct_Cmpny" class="form-control">
                                    <option selected disabled value="Select state">Select company</option>
                                </select>
                            </td>
                             <td style="width: 6px;">
                            </td>
                            <td>
                             <label class="control-label" >
                                    Branch Code<span style="color: Red;font-weight:bold">*</span></label>
                                <input id="txt_sapcode" style="width: 213px;" type="text" name="sapcode" placeholder="Enter Branchcode" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            
                               
                            
                            <td style="height: 40px;">
                             <label class="control-label" >
                                    Branch Name<span style="color: Red;font-weight:bold">*</span></label>
                                <input id="txtBrcName" type="text" name="CustomerFName" placeholder="Enter Name"
                                    class="form-control" onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                           
                              
                            
                            <td>
                             <label class="control-label" >
                                    State Name<span style="color: Red;font-weight:bold">*</span></label>
                                <select id="txtStatename" style="width: 213px;" class="form-control">
                                    <option selected disabled value="Select state">Select state</option>
                                    <option id="Option1">AndraPrdesh</option>
                                    <option id="Option2">Tamilnadu</option>
                                    <option id="Option8">karnataka</option>
                                    <option id="Option3">Maharashtra</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                            <label class="control-label" >
                                    Phone NO</label>
                                <input id="txtPhnNO" type="text" name="CCName" placeholder="Enter  Phone Number" class="form-control"
                                   onblur="checkLength()" onkeypress="return isNumber(event)" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                           
                               
                            
                            <td>
                            <label class="control-label" >
                                   Mail Id<span style="color: Red;font-weight:bold">*</span></label>
                                <input id="txtMail" type="text"  style="width: 213px;" name="CMobileNumber" placeholder="E_Mail" class="form-control" onchange="validationemail();" />
                            </td>
                        </tr>
                        <tr>
                            
                            
                           
                            <td style="height: 40px;">
                             <label class="control-label" >
                                    From Date</label>
                                <input id="txt_Fromdate" type="text" name="CCName" placeholder="Enter Fromdate" class="form-control"
                                    onkeypress="return isNumber(event)" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                            
                                <label class="control-label"  >
                                    To Date</label>
                                <input id="txt_Todate" type="text" style="width: 213px;" name="CMobileNumber" placeholder="Enter Todate"
                                    onkeypress="return isNumber(event)"   class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                               <label class="control-label" >
                                    Night Allowance</label>
                                <input id="txt_Nytrate" type="text" name="CMobileNumber" placeholder="Enter Rate"
                                    class="form-control" onkeypress="return isNumber(event)" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                             <label class="control-label"  >
                                    Branch Type</label>
                                <select id="slct_Type"  style="width: 213px;" class="form-control">
                                    <option selected disabled value="Select state">Select Type</option>
                                    <option id="Option4">SalesOffice</option>
                                    <option id="Option5">CC</option>
                                    <option id="Option6">Plant</option>
                                    <option id="Option7">IFD Plant</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                               <label class="control-label" >
                                    Short Code</label>
                                <input id="txt_bcode" type="text" name="CMobileNumber" placeholder="Short Code"
                                    class="form-control" />
                            </td>
                            <td style="width: 6px;">
                            </td>
                            <td>
                             <label class="control-label" >
                                    Address</label>
                                <textarea id="txtAdrs" style="width: 213px;" type="text" name="CMobileNumber" placeholder="Address" class="form-control"></textarea>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" style="height: 40px;">
                            </td>
                        </tr>
                    </table>
                    <table style="margin-left: 54%;">
                    <td  >
                    <div class="input-group" >
                                <div class="input-group-addon">
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="saveBranchDetails()"></span> <span id="btn_save" onclick="saveBranchDetails()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="canceldetails()"></span> <span id='btn_close' onclick="canceldetails()">Close</span>
                          </div>
                    </td>
                    </table>
                    
                          
                            
                </div>
            </div>
        </div>
    </section>
</asp:Content>
