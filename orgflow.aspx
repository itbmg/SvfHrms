<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="orgflow.aspx.cs" Inherits="orgflow" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css?v=3002" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .container
        {
            max-width: 100%;
        }
        th
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function CallPrint(strid) {
            var divToPrint = document.getElementById(strid);
            var newWin = window.open('', 'Print-Window', 'width=400,height=400,top=100,left=100');
            newWin.document.open();
            newWin.document.write('<html><body   onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
        }
    </script>
    <script type="text/javascript">

        $(function () {
            get_CompanyMaster_details();
            get_orgmainbranch_details();
            GetFixedrows();
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

        function showdailyactivity() {
            $("#dialyactive").show();
            $("#div_dalyactvereport").hide();
            $("#divbranchdetails").hide();
        }

        function showoperations() {
            $("#dialyactive").hide();
            $("#div_dalyactvereport").show();
            $("#divbranchdetails").hide();
            GetFixedrows1();
        }
        function showdailyactivityreport() {
            $("#dialyactive").hide();
            $("#div_dalyactvereport").hide();
            $("#divbranchdetails").show();
            GetFixedrows2();
            get_orgmainbranch_details();
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
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].CompanyName != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].CompanyName;
                    option.value = msg[i].CompanyCode;
                    data.appendChild(option);
                }
            }
        }

        function get_orgmainbranch_details() {
            var data = { 'op': 'get_orgmainbranch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillorginfo(msg);
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
        function fillorginfo(msg) {
            var data = document.getElementById('slct_mainbranch');
            var length = data.options.length;
            document.getElementById('slct_mainbranch').options.length = null;
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].branchname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].branchname;
                    option.value = msg[i].Sno;
                    data.appendChild(option);
                }
            }
        }

        function GetFixedrows() {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Center Name</th><th scope="col">Branch Type</th></tr></thead></tbody>';
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtCode" class="form-control" style="width:100% !important;"  placeholder= "Branch Name"/></td>';
                results += '<td ><select id="selct_type" class="form-control"  style="border-radius: 0px; width:100% !important;"><option selected disabled value="Select Type">Select Type</option><option value="Markating Office">Markating Office</option><option value="CC">Chilling Center</option><option value="Processing Plant">Processing Plant</option><option value="Admin Office">Admin Office</option></select></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }

        function GetFixedrows2() {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tablebranchdetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Center Name</th></tr></thead></tbody>';
            for (var i = 1; i < 15; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtbranchname" class="form-control" style="width:100% !important;"  placeholder= "Branch Name"/></td>';
                results += '<td ><select id="selct_btype" class="form-control"  style="border-radius: 0px; width:100% !important;"><option selected disabled value="Select Type">Select Type</option><option value="Markating Office">Markating Office</option><option value="CC">Chilling Center</option><option value="Processing Plant">Processing Plant</option><option value="Admin Office">Admin Office</option></select></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#divmianbranch").html(results);
        }

        function Save_orgbranchinfo_Details() {
            var cmpid = document.getElementById('slct_mainbranch').value;
            var btnval = document.getElementById('btn_bsave').value;
            if (btnval = "Save") {
                $("#btn_bsave").show();
            }
            if (cmpid == "") {
                alert("Select  Branch Name ");
                $("#slct_mainbranch").focus();
                return false;
            }
            var fillBRANCHitems = [];
            $('#tablebranchdetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var branchname = $(this).find('#txtbranchname').val();
                var branchtype = $(this).find('#selct_btype').val();
                fillBRANCHitems.push({ 'txtsno': txtsno, 'branchname': branchname, 'branchtype': branchtype
                });
            });
            if (fillBRANCHitems.length == 0) {
                alert("Please enter conclusion");
                return false;
            }
            var data = { 'op': 'Save_orgbranchinfo_Details', 'cmpid': cmpid, 'btnVal': btnval, 'fillBRANCHitems': fillBRANCHitems };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }

        function Save_DailyActivity_Details() {
            var cmpid = document.getElementById('selct_Cmpny').value;
            var btnval = document.getElementById('btn_save').value;
            if (btnval = "Save") {
                $("#btn_save").show();
            }

            if (cmpid == "") {
                alert("Enter  Employee Name ");
                $("#txt_empname1").focus();
                return false;
            }
            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var branchname = $(this).find('#txtCode').val();
                var branchtype = $(this).find('#selct_type').val();
                fillitems.push({ 'txtsno': txtsno, 'branchname': branchname, 'branchtype': branchtype
                });
            });
            if (fillitems.length == 0) {
                alert("Please enter conclusion");
                return false;
            }
            var data = { 'op': 'Save_cmporginfo_Details', 'cmpid': cmpid, 'btnVal': btnval, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }

        var DataTable;
        function insertrow() {
            DataTable = [];
            var txtsno = 0;
            var code = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtCode').val() != "") {
                    txtsno = rowsno;
                    code = $(this).find('#txtCode').val();
                    DataTable.push({ Sno: txtsno, code: code });
                    rowsno++;

                }
            });
            code = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, code: code });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Center Name</th><th scope="col">Branch Type</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtCode" type="text" style="width:100% !important;" class="form-control"  value="' + DataTable[i].code + '"/></td>';
                results += '<td ><select id="selct_type" class="form-control"  style="border-radius: 0px; width:100% !important;"><option selected disabled value="Select Type">Select Type</option><option value="Markating Office">Markating Office</option><option value="CC">Chilling Center</option><option value="Processing Plant">Processing Plant</option><option value="Admin Office">Admin Office</option></select></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }
        function canceldetails() {
            document.getElementById('btn_save').innerHTML = "Save";
        }


        function GetFixedrows1() {
            var results = '<div class="divcontainer1" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tableactdetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Operation Type</th></tr></thead></tbody>';
            for (var i = 1; i < 10; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtop" class="form-control" style="width:100% !important;"  placeholder= "Operation Name"/></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow1(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#divactivitydata").html(results);
        }

        function Save_DailyOPERATION_Details() {
            var cmpid = document.getElementById('selct_OPtype').value;
            var btnval = document.getElementById('btn_opsave').value;
            if (btnval = "Save") {
                $("#btn_opsave").show();
            }

            if (cmpid == "") {
                alert("Enter  Type");
                $("#selct_type").focus();
                return false;
            }
            var fillOPitems = [];
            $('#tableactdetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var operationname = $(this).find('#txtop').val();
                fillOPitems.push({ 'txtsno': txtsno, 'operationname': operationname 
                });
            });
            if (fillOPitems.length == 0) {
                alert("Please enter conclusion");
                return false;
            }
            var data = { 'op': 'Save_DailyOPERATION_Details', 'cmpid': cmpid, 'btnVal': btnval, 'fillOPitems': fillOPitems };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }



        function removerow1(thisid) {
            $(thisid).parents('tr').remove();
        }

        function insertrow1() {
            DataTable = [];
            var txtsno = 0;
            var code = 0;
            var rows = $("#tableactdetails tr:gt(0)");
            var rowsno = 1;
            $(rows).each(function (i, obj) {
                if ($(this).find('#txtop').val() != "") {
                    txtsno = rowsno;
                    code = $(this).find('#txtop').val();
                    DataTable.push({ Sno: txtsno, code: code });
                    rowsno++;
                }
            });
            code = 0;
            var Sno = parseInt(txtsno) + 1;
            DataTable.push({ Sno: Sno, code: code });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tableactdetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Center Name</th><th scope="col">Branch Type</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtop" type="text" style="width:100% !important;" class="form-control"  value="' + DataTable[i].code + '"/></td>';
                results += '<td data-title="minus"><span><img src="images/minus.png" onclick="removerow1(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#divactivitydata").html(results);
        }


        function btn_Dailyactiviy_generate_click() {
            var activityrefno = document.getElementById('txt_activityrefno').value;
            var data = { 'op': 'get_dailyactivity_Reports', 'activityrefno': activityrefno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        $('#divPrint').css('display', 'block');
                        fillactivitydetails(msg);
                        activitydetails = msg;
                        document.getElementById('spnaactivityrefno').innerHTML = activitydetails[0].activity_no;
                        document.getElementById('spnstartdate').innerHTML = activitydetails[0].starttime;

                        document.getElementById('spndate').innerHTML = activitydetails[0].doe;
                        document.getElementById('SpnEndtime').innerHTML = activitydetails[0].endtime;
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
        function fillactivitydetails(msg) {
            var activityrefno = document.getElementById('txt_activityrefno').value;
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" border="2">';
            results += '<thead><tr style="background:#cbc6dd;"><th scope="col">Sno</th><th scope="col">Activity</th></tr></thead></tbody>';
            var l = 0;
            var COLOR = ["AntiqueWhite", "#b3ffe6", "#daffff", "MistyRose", "Bisque"];
            for (var i = 0; i < msg.length; i++) {
                var subactivitylist = msg[i].fillitems;
                var j = 1;
                for (k = 0; k < subactivitylist.length; k++) {
                    if (activityrefno == subactivitylist[k].activity_no) {
                        results += '<tr style="background-color:' + COLOR[l] + '"><td>' + j++ + '</td>';
                        results += '<td class="1">' + subactivitylist[k].conclusion + '</td></tr>';
                    }
                    l = l + 1;
                    if (l == 4) {
                        l = 0;
                    }
                }
            }
            results += '</table></div>';
            $("#div_activityData").html(results);

        }        
    </script>
</asp:Content>
<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           Org Flow Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Company Master</a></li>
            <li><a href="#">Branch Details</a></li>
            <li><a href="#">Operation Details</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Daily Activities Details
                </h3>
            </div>
            <div class="box-body">
            <div>
                            <ul class="nav nav-tabs">
                                <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="showdailyactivity()"><i
                                    class="fa fa-university"></i>&nbsp;&nbsp;Company Master</a></li>
                                <li id="Li3" class=""><a data-toggle="tab" href="#" onclick="showdailyactivityreport()"><i
                                    class="fa fa-bar-chart"></i>&nbsp;&nbsp;Branch Details</a></li>
                                 <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="showoperations()"><i
                                    class="fa fa-bar-chart"></i>&nbsp;&nbsp;Operation Details</a></li>
                                    </ul>
                           
                        </div>
               
              
                <div id='dialyactive' >
                    <table align="center">
                    <tr>
                    <td>
                   <label class="control-label" >
                                    Company Name</label>
                                <select id="selct_Cmpny" class="form-control"  style="border-radius: 0px; width:100% !important;">
                                    <option selected disabled value="Select state">Select company</option>
                                </select></td>
                    </tr>
                       
                    </table>
                   <br />
                    <div id="div_SectionData">
                    </div>
                          <table>
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-plus-sign" id="newrow1"  onclick="insertrow()"></span><span id="newrow" onclick="insertrow()">Insert row</span>
                                        </div>
                                    </div>
                                </td>
                                </tr>
                                </table>
                    <div id="">
                        <div>
                            <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_save1"  onclick="Save_DailyActivity_Details()"></span><span id="btn_save" onclick="Save_DailyActivity_Details()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="btn_close1" onclick="canceldetails()"></span><span id="btn_close" onclick="canceldetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>
                <br />
                <div id='div_dalyactvereport' style="display: none;">
                <div runat="server" id="d">
                    <table align="center">
                        <tr>
                            <td>
                             <label class="control-label" > 
                                   BranchType:</label>
                            </td>
                            <td>
                                <select id="selct_OPtype" class="form-control"  style="border-radius: 0px; width:100% !important;"><option selected disabled value="Select Type">Select Type</option><option value="Markating Office">Markating Office</option><option value="CC">Chilling Center</option><option value="Processing Plant">Processing Plant</option><option value="Admin Office">Admin Office</option></select>
                            </td>
                        </tr>
                    </table>
                    <div id="divactivitydata">
                    </div>
                    <table>
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-plus-sign" id="Span2"  onclick="insertrow1()"></span><span id="Span3" onclick="insertrow1()">Insert row</span>
                                        </div>
                                    </div>
                                </td>
                                </tr>
                                </table>

                                 <div id="Div1">
                        <div>
                            <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_opsave1"  onclick="Save_DailyOPERATION_Details()"></span><span id="btn_opsave" onclick="Save_DailyOPERATION_Details()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="spncan1" onclick="canceldetails()"></span><span id="spncan2" onclick="canceldetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>
                <br />
                <br />
                
                
                
                <asp:Label ID="lblmsg" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
                </div>


                <div id='divbranchdetails' style="display: none;">
                <div runat="server" id="Div3">
                    <table align="center">
                        <tr>
                            <td>
                             <label class="control-label" > 
                                   Main Branch :</label>
                            </td>
                            <td>
                                <select id="slct_mainbranch" class="form-control"  style="border-radius: 0px; width:100% !important;"></select>
                            </td>
                        </tr>
                    </table>
                    <div id="divmianbranch">
                    </div>
                    <table>
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-plus-sign" id="Span1"  onclick="insertrow1()"></span><span id="Span4" onclick="insertrow1()">Insert row</span>
                                        </div>
                                    </div>
                                </td>
                                </tr>
                                </table>

                                 <div id="Div5">
                        <div>
                            <table align="center">
                            <tr>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <span class="glyphicon glyphicon-ok" id="btn_bsave1"  onclick="Save_orgbranchinfo_Details()"></span><span id="btn_bsave" onclick="Save_orgbranchinfo_Details()">Save</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="width:10px;"></td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id="Span7" onclick="canceldetails()"></span><span id="Span8" onclick="canceldetails()">Close</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        </div>
                    </div>
                </div>
                <br />
                <br />
                
                
                
                <asp:Label ID="lblmsg1" runat="server" Font-Size="20px" ForeColor="Red" Text=""></asp:Label>
                </div>
            </div>
    </section>
</asp:content>
