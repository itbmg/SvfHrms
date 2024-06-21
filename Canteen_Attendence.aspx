<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Canteen_Attendence.aspx.cs" Inherits="Canteen_Attendence" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .inputstable td
        {
            padding: 5px 5px 5px 5px;            
        }
        .col
        {
            border: 1px solid #d5d5d5;
            text-align: center;
        }
        
        .students-table
        {
            width: 100%;
            border-collapse: collapse;
        }
        .students-table th
        {
            font-weight: bold;
            vertical-align: middle;
        }
        .students-table td, .students-table th
        {
            padding: 5px;
            text-align: left;
            border: 1px solid #ddd;
        }
        
        .students-table tr:nth-child(odd)
        {
            background: #f9f9f9;
        }
        .students-table tr:nth-child(even)
        {
            background: #ffffff;
        }
    </style>
    <style>
        input[type=checkbox]
        {
            transform: scale(1.5);
        }
        input[type=checkbox]
        {
            width: 30px;
            height: 18px;
            margin-right: 8px;
            cursor: pointer;
            font-size: 10px;
            visibility: hidden;
        }
        input[type=checkbox]:after
        {
            content: " ";
            background-color: #fff;
            display: inline-block;
            margin-left: 10px;
            padding-bottom: 0px;
            color: #24b6dc;
            width: 16px;
            height: 16px;
            visibility: visible;
            border: 1px solid rgba(18, 18, 19, 0.12);
            padding-left: 3px;
            border-radius: 0px;
        }
        input[type="checkbox"]:not(:disabled):hover:after
        {
            border: 1px solid #24b6dc;
        }
        input[type=checkbox]:checked:after
        {
            content: "\2714";
            padding: -5px;
            font-weight: bold;
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
            branchdetails();
            get_canteen_details();
            $("#div_can_atten").css("display", "none");
            $("#div_canteen_attandancereport").css("display", "none");
            $("#div_canteen_details").css("display", "block");
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txtDOA').val(today);
        });
        function show_canteenDetails() {
            get_canteen_details();
            $("#div_can_atten").css("display", "none");
            $("#div_canteen_attandancereport").css("display", "none");
            $("#div_canteen_details").css("display", "block");
        }
        function show_canteenattdence() {
            $("#div_can_atten").css("display", "block");
            $("#div_canteen_attandancereport").css("display", "none");
            $("#div_canteen_details").css("display", "none");
        }
        function show_canattdncereprt() {
            $("#div_can_atten").css("display", "none");
            $("#div_canteen_attandancereport").css("display", "block");
            $("#div_canteen_details").css("display", "none");
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
        function branchdetails() {

            var data = { 'op': 'get_branchdetails' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranchdetails(msg);
                        fillbranchdetails1(msg);
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


        function fillbranchdetails(msg) {
            var data = document.getElementById('ddlbrnch');
            var length = data.options.length;
            document.getElementById('ddlbrnch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
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
        function fillbranchdetails1(msg) {
            var data = document.getElementById('ddl_brnch');
            var length = data.options.length;
            document.getElementById('ddl_brnch').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "ALL";
            opt.value = "ALL";
            opt.setAttribute("selected", "selected");
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

        function save_canteen_Details() {
            var branchid = document.getElementById("ddl_brnch").value;
            var type = document.getElementById("select_Type").value;
            var amount = document.getElementById("txt_amount").value;
            var btnval = document.getElementById('btn_save').value;
            var Sno = document.getElementById('lbl_cansno').innerHTML;
            var data = { 'op': 'save_canteen_Details', 'branchid': branchid, 'type': type, 'amount': amount, 'btnval': btnval, 'Sno': Sno };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_canteen_details();
                        forclearall();
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
            document.getElementById('ddl_brnch').value = "";
            document.getElementById('select_Type').value = "";
            document.getElementById('txt_amount').value = "";
            document.getElementById('btn_save').value = "Save";
            $("#get_canteendetais").show();
            
        }

        function get_canteen_details() {
            var data = { 'op': 'get_canteen_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillcanteendetails(msg);
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
        function fillcanteendetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#f3f5f7", "#cfe2e0", "", "#cfe2e0"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Branch Name</th></th><th  scope="col"><i class="fa fa-university"></i>Type</th><th scope="col" >Amount</th><th   scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {               
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td>' + k++ + '</td>';                
                results += '<th scope="row" class="1" ><span class="fa fa-university" style="color: cadetblue;"></span>  <span id="1" class="1"> ' + msg[i].branchname + '</span</th>';
                results += '<td data-title="type" class="2">' + msg[i].type + '</td>';
                results += '<td data-title="amount" class="3">' + msg[i].amount + '</td>';
                results += '<td style="display:none" class="5">' + msg[i].Sno + '</td>';
                results += '<td style="display:none" class="6">' + msg[i].branchid + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="canteengetme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#get_canteendetais").html(results);
        }
        function canteengetme(thisid) {
            var branchname = $(thisid).parent().parent().children('.6').html();
            var type = $(thisid).parent().parent().children('.2').html();
            if (type == "Breakfast") {
                b = "1";
            }
            if (type == "Lunch") {
                b = "2";
            }
            if (type == "Dinner") {
                b = "3";
            }
            var amount = $(thisid).parent().parent().children('.3').html();
            var Sno = $(thisid).parent().parent().children('.5').html();
            document.getElementById('ddl_brnch').value = branchname;
            document.getElementById('select_Type').value = b;
            document.getElementById('txt_amount').value = amount;
            document.getElementById('lbl_cansno').innerHTML = Sno;
            document.getElementById('btn_save').value = "Modify";
            $("#get_canteendetais").hide();            
        }
        
        function btn_canteen_click() {
            $("#div_imageattdance").css("display", "block");
            document.getElementById('div_employee').innerHTML = "";
            var DOA = document.getElementById("txtDOA").value;
            var branchid = document.getElementById("ddlbrnch").value;
            var Data = { 'op': 'get_canteenAttendence', 'DOA': DOA, 'branchid': branchid };
            var s = function (msg) {
                gradestudentsdata = msg;
                var status = "0";
                var divstudents = document.getElementById('div_employee');
                var tablestrctr = document.createElement('table');
                tablestrctr.id = "tabledetails";
                tablestrctr.setAttribute("class", "students-table");
                $(tablestrctr).append('<thead><tr><th>Sno</th><th><i class="fa fa-user" style="font-size:20px;padding-right: 5px;"></i>Employee Name</th><th>Employee Code</th><th>Breakfast</th><th>Lunch</th><th>Dinner</th></tr></thead><tbody></tbody>');
                var j = 0;
                for (var i = 0; i < gradestudentsdata.length; i++) {
                    j = i + 1;
                    var breakfast = gradestudentsdata[i].breakfast;
                    var lunch = gradestudentsdata[i].lunch;
                    var dinner = gradestudentsdata[i].dinner;
                    var dinnercount = gradestudentsdata[i].dinnercount;
                    var breakfastcount = gradestudentsdata[i].breakfastcount;
                    var lunchcount = gradestudentsdata[i].lunchcount;
                    var count = "Break Fast  : " + breakfastcount + ", Lunch : " + lunchcount + ", Dinner : " + dinnercount + "";
                    document.getElementById('spn_msg').innerHTML = count;
                    $(tablestrctr).append('<tr><td>' + j + '</td><td class="1">' + gradestudentsdata[i].employee_name + '</td>'
                            + '<td>' + gradestudentsdata[i].employee_num + '</td>'
                            + '<td name="idprevsmsstatus" style="display:none"><input name="hdnempsno"   id="hdnempsno" type="hidden" value="' + gradestudentsdata[i].empsno + '" /></td>'
                             + (breakfast == "" ? '<td><input type="checkbox" name="ckBreakfast" id="ckBreakfast" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="1" ></td>' : '<td><input name="ckBreakfast" id="ckBreakfast"  type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="1" checked="checked" ></td>')
                           + (lunch == "" ? '<td><input  name="cklunch" id="cklunch"  type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="2" ></td>' : '<td><input name="cklunch" id="cklunch" type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="2" checked="checked" ></td>')
                           + (dinner == "" ? '<td><input name="ckdinner" id="ckdinner" type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="3" ></td>' : '<td><input name="ckdinner" id="ckdinner" type="checkbox" class="myche" onclick="selectall_checks(this)"; id="ckBreakfast"  value="3" checked="checked" ></td>')
                           + '</tr>');

                    //                           +'<td><input type="checkbox" class="myche" onclick="selectall_checks(this);" name="ckBreakfast" id="ckBreakfast"  value="1"  ></td>'
                    //                           + '<td><input type="checkbox" class="myche" onclick="selectall_checks(this);" name="cklunch" id="cklunch"  value="2" ></td>'
                    //                           +'<td><input type="checkbox" class="myche" onclick="selectall_checks(this);" name="ckdinner" id="ckdinner"  value="3"  ></td>'
                    //                           + '</tr>');
                }
                $(tablestrctr).append('<br/>');
                $(tablestrctr).append('<br/>');
                $(tablestrctr).append('<br/>');
                divstudents.appendChild(tablestrctr);
                for (var i = 0; i < gradestudentsdata.length; i++) {
                    if (gradestudentsdata[i].status == "1") {
                        $('.students-table tr').each(function () {
                            var studentid = $(this).find(':checkbox');

                            if (studentid[0].value == gradestudentsdata[i].studentsno) {
                                studentid[0].checked = true;
                            }

                        });
                    }
                }
                document.getElementById("btn_Finalize").style.background = 'Green';
                document.getElementById("btn_Finalize").value = 'Finalize Attendance';
            };
            var e = function (x, h, e) {
            };
            callHandler(Data, s, e);
        }
        function selectall_checks(thisid) {
            if ($(thisid).is(':checked')) {
                $(this).find(':checkbox').prop('checked', true);
            }
            else {
                $(this).find(':checkbox').prop('checked', true);
            }
        }
        function btn_Finalize_Attendence() {
            var studentslist = [];
            var Absentlist = [];
            var count = 0;
            var rows = $("#tabledetails tr:gt(0)");
            var rowsno = 1;
            var remarks = "";

            var matches = [];
//            $(".myche:checked").each(function () {
//                var empid = $(this).find('[name="empid"]').val();
//                var abc = this.value.toString();
//                var ss = abc.split("_");
//                var empid = ss[0];
//                var type = ss[1];
//                var value = { employee: empid, status: type };
//                matches.push(value);
            //            });
            $('#tabledetails > tbody > tr').each(function () {
                var empsno = $(this).find('[name="hdnempsno"]').val();
                var Breakfast = 0;
                var lunch = 0;
                var dinner = 0;
                var ckBreakfast = $(this).find('[name="ckBreakfast"]:checked').val();
                if (typeof ckBreakfast === "undefined") {
                    Breakfast = 0;
                }
                else {
                    Breakfast = 1;
                }
                var cklunch = $(this).find('[name="cklunch"]:checked').val();
                if (typeof cklunch === "undefined") {
                    lunch = 0;
                }
                else {
                    lunch = 2;
                }
                var ckdinner = $(this).find('[name="ckdinner"]:checked').val();
                if (typeof ckdinner === "undefined") {
                    dinner = 0;
                }
                else {
                    dinner = 3;
                }
                if (Breakfast == "0" && lunch == "0" && dinner == "0") {
                }
                else {
                    matches.push({ employee: empsno, Breakfast: Breakfast, lunch: lunch, dinner: dinner });
                }
            });
            var branchid = document.getElementById("ddlbrnch").value;
            var DOA = document.getElementById("txtDOA").value;
            if (DOA == null || DOA == "") {
                document.getElementById("txtDOA").focus();
                alert("please Select Attendance Date");
                return false;
            }
            var Data = { 'op': 'save_Finalize_Attendence', 'DOA': DOA, 'branchid': branchid, 'employeeslist': matches };
            var s = function (msg) {
                if (msg && msg != 'false') {
                    alert(msg);
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson_POST(Data, s, e);
        }
        function CallHandlerUsingJson_POST(d, s, e) {
            d = JSON.stringify(d);
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content" style="overflow:inherit !important;">

<div class="box box-info">
<div>
                <ul class="nav nav-tabs">
                <li id="id_tab_Personal" class="active"><a data-toggle="tab" href="#" onclick="show_canteenDetails()">
                        <i class="fa fa-street-view"></i>&nbsp;&nbsp; Canteen Details</a></li>
                    <li id="Li1" class=""><a data-toggle="tab" href="#" onclick="show_canteenattdence()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp;Canteen Attendence</a></li>
                         <li id="Li2" class=""><a data-toggle="tab" href="#" onclick="show_canattdncereprt()">
                        <i class="fa fa-file-text"></i>&nbsp;&nbsp; Canteen Attendence Report</a></li>
                        </ul>
                        </div>
                        
                 <div id="div_canteen_details">
                 <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Details
                    </h3>
                </div>
               
                <table align="center">
                <tr style="display:none;"><td>
                            <label id="lbl_cansno"></label>
                            </td>
                            </tr>
                <tr>
                <td style="height: 40px;">
                         <label class="control-label" >
                        Branch Name
                        </label>
                        </td>
                        <td>
                            <select id="ddl_brnch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch" onchange="btn_canteen_click();">Select Branch</option>
                            </select>
                        </td>
                        </tr>
                        <tr>
                        <td>
                        <label class="control-label" for="txt_type">
                          Type</label>
                          </td>
                         <td>
                    <select name="month" id="select_Type" onchange="" size="1" class="form-control" style="width: 250px;">
                        <option value="1">Breakfast</option>
                        <option value="2">Lunch</option>
                        <option value="3">Dinner</option>
                    </select>
                        </td>                        
                        </tr>                        
                        <tr>     
                    <td style="height: 40px;">
                        <label class="control-label" >
                            Amount:
                            </label>
                        </td>
                        <td>
                        <input type="text" class="form-control" id="txt_amount" placeholder="Enter Amount " />
                    </td>
                    </tr>
                    <tr >

                    <td style="height: 40px;" >
                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value="Save"
                            onclick="save_canteen_Details();">
                        <input id="btn_close" type="button" class="btn btn-danger" name="submit" value="Cancel"
                            onclick="forclearall();" >
                    </td>                   
                </tr>
                </table>
                <div id="get_canteendetais"></div>
                 </div>  
               
                <div class="box-header with-border">
                <div id="div_can_atten" >
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Attendence
                    </h3>
                </div>
             <table id="txtdate" align="center">
                    <tr>
                        <td style="height: 40px;">
                            Date <span style="color: red;">*</span>
                        </td>
                        <td>
                            <input type="date" class="form-control" id="txtDOA" class="form-control" />
                        </td>
                        <td style="width: 5px;">
                        </td>
                        <td style="height: 40px;">
                            Branch Name
                        </td>
                        <td>
                            <select id="ddlbrnch" class="form-control" style="width: 250px;">
                                <option selected disabled value="Select Branch" onchange="btn_canteen_click();">Select Branch</option>
                            </select>
                        </td>                        
                        <td style="width: 5px;">
                        </td>
                        <td>
                            <input id="btn_canteen" type="button" class="btn btn-primary" name="submit" value="GENERATE"
                                onclick="btn_canteen_click();" style="width: 100px;">
                        </td>
                        </tr>
                        </table>
                        <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Select Employee(s)
                        </h3>
                    </div>
                    <div align="center">
                    <div id="div_imageattdance" style="float:left; padding-left:20px; display:none;">
          
                                                                    </div>
                                                                    <div>
                                                                    <span style="font-size:20px;font-weight:700; color:Green;" id="spn_msg"></span>
                                                                    </div >
                        <div id="div_employee" style="padding: 0px 0px 5px 5px; font-family: 'Open Sans';
                            font-size: 13px; margin-top: 10px; margin-bottom: 10px; display: inline-block;">
                        </div>
                    </div>
                </div>
                                <div style="width: 200px; position: fixed; left: 50%; top: 95%; margin-left: -100px;">
                    <table class="inputstable">
                        <tr>
                            <td>
                            </td>
                            <td>
                                <input id="btn_Finalize" type="button" class="btn btn-primary" name="submit" value="Finalize Attendance"
                                    onclick="btn_Finalize_Attendence();" style="width: 180px;" />
                                     </td>
                        </tr>
                    </table>
                </div>
                </div>
                </div>
                <div id="div_canteen_attandancereport" >
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
    <asp:UpdatePanel ID="updPanel" runat="server">
        <ContentTemplate>
            
            <section class="content" style="padding: 0px !important;" >
                    <div class="box-header with-border" >
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-cog"></i>Canteen Attendence Details
                        </h3>
                    </div>
                    <div class="box-body">
                        <div align="center">
                            <table>
                                <tr>                                 
                                <td>
                                            <asp:Label ID="Label1" runat="server" Text="Label">Branch</asp:Label>&nbsp;
                                            <asp:DropDownList ID="ddlbranch" runat="server" CssClass="form-control">
                                            </asp:DropDownList>
                                        </td>
                                         <td style="width: 6px;">
                            </td>
                            <td>                            
                               <asp:Label ID="Label2" runat="server" Text="Label">Type</asp:Label>&nbsp;
                                 <asp:DropDownList ID="txt_type" runat="server" CssClass="form-control">
                                 <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                 <asp:ListItem Value="1">Breakfast</asp:ListItem>
                                 <asp:ListItem Value="2">Lunch</asp:ListItem>
                                 <asp:ListItem Value="3">Dinner</asp:ListItem>
                                   </asp:DropDownList>                                
                                  </td>
                                    <td style="overflow:inherit" >
                                        <asp:Label ID="Label4" runat="server" Text="Label">From Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_FromDate" runat="server" CssClass="form-control"></asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="dtp_FromDate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Label">To Date</asp:Label>&nbsp;
                                        <asp:TextBox ID="dtp_Todate" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:CalendarExtender ID="enddate_CalendarExtender2" runat="server" Enabled="True"
                                            TargetControlID="dtp_Todate" Format="dd-MM-yyyy HH:mm">
                                        </asp:CalendarExtender>
                                    </td>
                                     <td style="width: 6px;">
                            </td>
                                    <td>
                                        <asp:Button ID="Button1" runat="server" Text="GENERATE" CssClass="btn btn-primary" OnClick="btn_Generate_Click" /><br />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="hidepanel" runat="server" Visible='false'>
                                <div id="divPrint">
                                    <div style="width: 100%;">
                                        <div style="width: 13%; float: left;">
                                            <img src="Images/Vyshnavilogo.png" alt="Vyshnavi" width="120px" height="82px" />
                                        </div>
                                        <div align="center">
                                            <asp:Label ID="lblTitle" runat="server" Font-Bold="true" Font-Size="20px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                            <asp:Label ID="lblAddress" runat="server" Font-Bold="true" Font-Size="12px" ForeColor="#0252aa"
                                                Text=""></asp:Label>
                                            <br />
                                             <asp:Label ID="lblbname" runat="server" Font-Bold="true" Font-Size="18px" ForeColor="#0252aa"
                                                Text=""></asp:Label><span style="font-size: 18px; font-weight: bold; color: #0252aa;">&nbsp Canteen Attendence Register</span><br />
                                        </div>
                                        <table style="width: 80%">
                                            <tr>
                                                <td>
                                                    from Date
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblFromDate" runat="server" ForeColor="Red"></asp:Label>
                                                </td>
                                                <td>
                                                    To date:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbltodate" runat="server"  ForeColor="Red"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                        <div>
                                            <asp:GridView ID="grdReports" runat="server" ForeColor="White" Width="100%" CssClass="gridcls"
                                                GridLines="Both" Font-Bold="true">
                                                <EditRowStyle BackColor="#999999" />
                                                <FooterStyle BackColor="Gray" Font-Bold="False" ForeColor="White" />
                                                <HeaderStyle BackColor="#f4f4f4" Font-Bold="False" ForeColor="Black" Font-Italic="False"
                                                    Font-Names="Raavi" Font-Size="Small" />
                                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                                <RowStyle BackColor="#ffffff" ForeColor="#333333" HorizontalAlign="Center" />
                                                <AlternatingRowStyle HorizontalAlign="Center" />
                                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            </asp:GridView>
                                        </div>
                                        <br />
                                        <table style="width: 100%;">

                                            <tr>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">INCHARGE SIGNATURE</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">ACCOUNTS DEPARTMENT</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">AUTHORISED SIGNATURE</span>
                                                </td>
                                                <td style="width: 25%;">
                                                    <span style="font-weight: bold; font-size: 12px;">PREPARED BY</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <br />
                                <br />
                                <asp:Button ID="btnsave" runat="Server" CssClass="btn btn-success" OnClick="btnlogssave_click" Text="Finalize Canteen Attendance" />
                                <asp:Button ID="btnPrint" runat="Server" CssClass="btn btn-primary" OnClientClick="javascript:CallPrint('divPrint');"
                                    Text="Print" />
                            </asp:Panel>
                            <asp:Label ID="lblmsg" runat="server" Text="" ForeColor="Red" Font-Size="20px"></asp:Label>
                        </div>
                    </div>
                </div>
            </section>
        </ContentTemplate>
    </asp:UpdatePanel>
        </div>
            
</div>
</section>
</asp:Content>
