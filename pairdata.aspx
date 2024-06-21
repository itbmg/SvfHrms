<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="pairdata.aspx.cs" Inherits="pairdata" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            get_Employeedetails();
            get_pairdata_details();
            get_onlinedata_details();
            $("#divonline").css("display", "block");
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
        function show_onlinedata() {
            $("#mobiledata").css("display", "none");
            $("#divonline").css("display", "block");
        }

        function show_mobiledata() {
            $("#mobiledata").css("display", "block");
            $("#divonline").css("display", "none");
        }
        
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

        var empname_data = [];
        function get_Employeedetails() {
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
        function save_edit_paireddatadetails() {
            var employeid = document.getElementById('txtempid').value;
            var empcode = document.getElementById('txtempcode').value;
            if (employeid == "") {
                alert("Select employeid ");
                return false;
            }
            var phno = document.getElementById('txtphno').value;
            var imeino = document.getElementById('txtimeino').value;
            var devicetype = document.getElementById('txtdevicetype').value;
            var devicevertion = document.getElementById('txtdevicevartion').value;
            var sno = document.getElementById('lbl_sno').innerHTML;
            var btnval = document.getElementById('btn_save').value;
            var data = { 'op': 'save_edit_paireddatadetails', 'employeid': employeid, 'phno': phno, 'imeino': imeino, 'devicetype': devicetype, 'devicevertion': devicevertion, 'empcode': empcode, 'btnval': btnval, 'sno': sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        forclearall();
                        get_pairdata_details();
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
            //document.getElementById('selct_department').selectedIndex = 0;
            document.getElementById('selct_employe').value = "";
            document.getElementById('txtempid').value = "";
            document.getElementById('txtphno').value = "";
            document.getElementById('txtimeino').value = "";
            document.getElementById('txtdevicetype').value = "";
            document.getElementById('txtdevicevartion').value = "";
            document.getElementById('btn_save').value = "Save";
            get_pairdata_details();
        }
        function get_pairdata_details() {
            var data = { 'op': 'get_pairdata_details' };
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >EmployeeCode</th><th scope="col"><i class="fa fa-user"></i>Employee Name</th><th scope="col">IMEI NO</th><th scope="col">Phone NO</th><th scope="col">Device type</th><th scope="col"></th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].employee_num + '</th>';
                results += '<td data-title="Code" class="11">' + msg[i].fullname + '</td>';
                results += '<td  class="3">' + msg[i].imeino + '</td>';
                results += '<td  class="15">' + msg[i].phoneno + '</td>';
                results += '<td  class="6">' + msg[i].devicetype + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                results += '<td></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_Deptdata").html(results);
        }

        function get_onlinedata_details() {
            var data = { 'op': 'get_onlinedata_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillonlinedetails(msg);
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
        function fillonlinedetails(msg) {
            var k = 1;
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" >IMEI NO</th><th scope="col"><i class="fa fa-user"></i>LATITUDE</th><th scope="col">LONGITUDE</th><th scope="col">USERNAME</th><th scope="col">Date</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
                results += '<th scope="row"  class="1">' + msg[i].imeino + '</th>';
                results += '<td data-title="Code" class="11">' + msg[i].latitude + '</td>';
                results += '<td  class="3">' + msg[i].longitude + '</td>';
                results += '<td  class="15">' + msg[i].username + '</td>';
                results += '<td  class="6">' + msg[i].doe + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].sno + '</td>';
                results += '<td></td></tr>';
            }
            results += '</table></div>';
            $("#divonlinedata").html(results);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Employee Mobile Details<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Basic Information</a></li>
            <li><a href="#">Employee Pairedata Master</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div>
                <ul class="nav nav-tabs">
                    <li id="id_tab_Personal" class=""><a data-toggle="tab" href="#" onclick="show_mobiledata()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp;Employe Mobile Details</a></li>
                    <li id="id_tab_documents" class="active"><a data-toggle="tab" href="#" onclick="show_onlinedata()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Online Details</a></li>
                </ul>
            </div>
            <div id="mobiledata" style="display: none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Employee Mobile Info Details
                    </h3>
                </div>
                <div>
                    <table id="tbl_leavemanagement" align="center">
                        <tr>
                            <td>
                                Employe Name
                            </td>
                            <td>
                                <input type="text" class="form-control" id="selct_employe" placeholder="Enter Employe Name"
                                    onkeypress="return ValidateAlpha(event);" />
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
                                Contact No
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txtphno" placeholder="Enter Contact No" />
                            </td>
                            <td>
                                IMEI No
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txtimeino" placeholder="Enter Imei No" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Device Type
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txtdevicetype" placeholder="Enter Device Type" />
                            </td>
                            <td>
                                Device Vertion
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txtdevicevartion" placeholder="Enter Device Vertion" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td style="height: 40px;">
                                <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                                    onclick="save_edit_paireddatadetails();">
                                <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                                    onclick="forclearall();">
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
                <div>
                    <div id="div_Deptdata">
                    </div>
                    <br />
                </div>
            </div>

            <div id="divonline">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Online Details
                    </h3>
                </div>
                <div>
                    <div id="divonlinedata">
                    </div>
                    <br />
                </div>
            </div>
        </div>
    </section>
</asp:Content>
