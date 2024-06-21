<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="Meeting_Conduct.aspx.cs" Inherits="Meeting_Conduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="js/main/Flow%20Player%20flowplayer-3.2.12.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            get_meeting_conduct_details();
            get_Employeedetails();
            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_Meetingdate').val(today);
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
            $('#txtStarttime').val(hrs + ':' + mnts);
            $('#txtEndtime').val(hrs + ':' + mnts);
        });
        function showdesign() {
            $("#div_MeetingData").hide();
            $("#div_CategoryData").hide();
            $("#fillform").show();
            $('#showlogs').hide();
            $('#divvideo').hide();
            $("#divaudiodata").hide();
            $('#newrow').css('display', 'block');
            insertrow();
            GetFixedrows();
            forclearall();
            get_meeting_conduct_details();
            get_Dept_details();
        }

        var employeedetails = [];
        function get_Employeedetails() {
            var data = { 'op': 'get_allwiseEmployee_details' };
            var s = function (msg) {
                if (msg) {
                    employeedetails = msg;
                    var empnameList = [];
                    for (var i = 0; i < msg.length; i++) {
                        var employee_name = msg[i].employee_name;
                        empnameList.push(employee_name);
                    }
                    $('#txt_participants').autocomplete({
                        source: empnameList,
                        change: departmentsnmechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function departmentsnmechange() {
            var employee_name = document.getElementById('txt_participants').value;
            for (var i = 0; i < employeedetails.length; i++) {
                if (employee_name == employeedetails[i].employee_name) {
                    document.getElementById('txt_patid').value = employeedetails[i].empsno;
                }
            }
        }

        var departmentnames = [];
        function get_Dept_details() {
            var data = { 'op': 'get_Dept_details' };
            var s = function (msg) {
                if (msg) {
                    departmentnames = msg;
                    var availableTags = [];
                    for (var i = 0; i < msg.length; i++) {
                        var departmentsnme = msg[i].Department;
                        availableTags.push(departmentsnme);
                    }
                    $('#txt_Department').autocomplete({
                        source: availableTags,
                        change: empnamechange,
                        autoFocus: true
                    });
                }
            }
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler(data, s, e);
        }
        function empnamechange() {
            var name = document.getElementById('txt_Department').value;
            for (var i = 0; i < departmentnames.length; i++) {
                if (name == departmentnames[i].Department) {
                    document.getElementById('txt_Departmentid').value = departmentnames[i].Deptid;
                }
            }
        }


        var gridBinding = [];
        function AddTogridClick() {
            $("#div_Deptdata").hide();
            var employe_name = document.getElementById('txt_participants').value;
            if (employe_name == "") {
                alert("Please select sub emp name");
                return false;
            }
            var Checkexist = false;
            $('.empname').each(function (i, obj) {
                var IName = $(this).text();
                if (IName == employe_name) {
                    alert("sub emp name Already Added");
                    Checkexist = true;
                }
            });
            if (Checkexist == true) {
                return;
            }
            gridBinding.push({ 'employe_name': employe_name });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Emp Name</th></tr></thead></tbody>';
            for (var i = 0; i < gridBinding.length; i++) {
                results += '<td scope="row"  class="empname">' + gridBinding[i].employe_name + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_vendordata").html(results);
        }
        var meetingdetails = [];
        function get_meeting_conduct_details() {
            var formtype = "Meetingconduct";
            var data = { 'op': 'get_meeting_conduct_details', 'formtype': formtype };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillMeetingdetails(msg);
                        meetingdetails = msg;
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
        function fillMeetingdetails(msg) {
            var k = 1;
            var l = 0;
            var COLOR = ["#b3ffe6", "AntiqueWhite", "#daffff", "MistyRose", "Bisque"];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Date</th><th scope="col" >Starttime</th><th scope="col">Endtime</th><th scope="col">Subject</th><th scope="col">Conducted By</th><th scope="col">Path</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '"><td>' + k++ + '</td>';
                results += '<td class="1">' + msg[i].doe + '</td>';
                results += '<th scope="row" class="2" >' + msg[i].starttime + '</th>';
                results += '<td data-title="brandstatus" class="3">' + msg[i].endtime + '</td>';
                results += '<td  class="4">' + msg[i].subject + '</td>';
                results += '<td  class="5">' + msg[i].conducted_by + '</td>';
                results += '<td  class="6">' + msg[i].videopath + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].participants + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].department + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].meeting_no + '</td>';
                results += '<td><input id="btn_poplate" type="button"  onclick="getme(this)" name="submit" class="btn btn-primary" value="View" /></td></tr>';
                l = l + 1;
                if (l == 4) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_MeetingData").html(results);
        }
        var meeting_no = 0;
        var conducted_by = 0;
        function getme(thisid) {
            $('#divvideo').show();
            $("#divaudiodata").show();
            var doe = $(thisid).parent().parent().children('.1').html();
            var starttime = $(thisid).parent().parent().children('.2').html();
            var endtime = $(thisid).parent().parent().children('.3').html();
            var subject = $(thisid).parent().parent().children('.4').html();
            conducted_by = $(thisid).parent().parent().children('.5').html();
            var videopath = $(thisid).parent().parent().children('.6').html();
            var participants = $(thisid).parent().parent().children('.7').html();
            var department = $(thisid).parent().parent().children('.9').html();
            meeting_no = $(thisid).parent().parent().children('.8').html();

            document.getElementById('txtStarttime').value = starttime;
            document.getElementById('txtEndtime').value = endtime;
            document.getElementById('txt_participants').value = participants;
            document.getElementById('txt_subject').value = subject;
            document.getElementById('txt_conductby').value = conducted_by;
            document.getElementById('txt_Department').value = department;
            document.getElementById('btn_save').value = "View";
            var hide = document.getElementById('btn_save').value;
            if (hide = "view") {
                $("#btn_save").hide();
            }
            else {
                $("#btn_save").show();
            }
            var audiourl = 'ftp://223.196.32.30/videos/test12.mp3';
            var audiotag = document.getElementById('objaudio');
            audiotag.data = 'dewplayer-vol.swf?mp3=' + audiourl + '';

            var videourl = 'ftp://223.196.32.30/videos/vyshnavi11.mp4';
            var atag = document.getElementById('player');
            atag.href = videourl;
            flowplayer("player", "FlowPlayer/flowplayer-3.2.16.swf", {
                plugins: {
                    pseudo: { url: "FlowPlayer/flowplayer.pseudostreaming-3.2.12.swf" }
                },
                clip: {
                    provider: 'pseudo',
                    autoPlay: false,
                    autoBuffering: true,
                    url: videourl
                }
            });
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Conclusion</th></tr></thead></tbody>';
            for (var i = 0; i < meetingdetails.length; i++) {
                var sub_meeting_list = meetingdetails[i].sub_meeting_list;
                var j = 1;
                for (var k = 0; k < sub_meeting_list.length; k++) {
                    if (meeting_no == sub_meeting_list[k].meeting_no) {
                        results += '<tr><td>' + j++ + '</td>';
                        results += '<td class="1">' + sub_meeting_list[k].conclusion + '</td></tr>';
                    }
                }
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
            $("#fillform").show();
            $('#showlogs').hide();
            $('#div_MeetingData').hide();
            $('#newrow').css('display', 'block');

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

        var name = "";
        function SaveMeeting_conduct_Details() {
            var meetingdate = document.getElementById('txt_Meetingdate').value;
            if (meetingdate == "") {
                alert("Enter Meeting Date");
                $("#txt_Meetingdate").show();
                return false;
            }
            var starttime = document.getElementById('txtStarttime').value;
            var endtime = document.getElementById('txtEndtime').value;
//            var participants = document.getElementById('txt_participants').value;
            for (var i = 0; i < gridBinding.length; i++) {
                name += gridBinding[i].employe_name + ",";
            }
            var subject = document.getElementById('txt_subject').value;
            var conducted_by = document.getElementById('txt_conductby').value;
            var department = document.getElementById('txt_Department').value;
            var btnval = document.getElementById('btn_save').value;
            if (btnval = "Save") {
                $("#btn_save").show();
            }
            
            if (endtime == "") {
                alert("Enter endtime");
                return false;
            }
            if (starttime == "") {
                alert("Enter  starttime");
                return false;
            }
            var videopath = document.getElementById('txt_Videopath').value;
            if (videopath == "") {
                alert("Enter video Path");
                $("#txt_Videopath").show();
                return false;
            }

            var fillitems = [];
            $('#tabledetails> tbody > tr').each(function () {
                var txtsno = $(this).find('#txtSno').text();
                var conclusion = $(this).find('#txtCode').val();
                fillitems.push({ 'txtsno': txtsno, 'conclusion': conclusion
                });
            });
            if (fillitems.length == 0) {
                alert("Please enter conclusion");
                return false;
            }

            var data = { 'op': 'SaveMeeting_conduct_Details', 'meetingdate': meetingdate, 'starttime': starttime, 'endtime': endtime, 'participants': name, 'subject': subject, 'conducted_by': conducted_by, 'videopath': videopath, 'btnVal': btnval, 'department': department, 'fillitems': fillitems };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        alert(msg);
                        get_meeting_conduct_details();
                        forclearall();
                        $('#div_MeetingData').show();
                        $('#fillform').css('display', 'none');
                        $('#showlogs').css('display', 'block');
                    }
                }
                else {
                }
            };
            var e = function (x, h, e) {
            };
            CallHandlerUsingJson(data, s, e);
        }
        function forclearall() {
            document.getElementById('txtStarttime').value = "";
            document.getElementById('txt_Meetingdate').value = "";
            document.getElementById('txt_participants').value = "";
            document.getElementById('txt_subject').value = "";
            document.getElementById('txt_conductby').value = "";
            document.getElementById('txt_Department').value = "";
            document.getElementById('txt_Videopath').value = "";
            document.getElementById('btn_save').value = "Save";
            gridBinding = [];
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="responsive-table">';
            results += '<thead><tr><th scope="col">Emp Name</th></tr></thead></tbody>';
            for (var i = 0; i < gridBinding.length; i++) {
                results += '<td scope="row"  class="empname">' + gridBinding[i].employe_name + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_vendordata").html(results);
        }
        function canceldetails() {
            $("#div_MeetingData").show();
            var btnval = document.getElementById('btn_save').value;
            if (btnval = "Save") {
                $("#btn_save").show();
            }
            $("#fillform").hide();
            $('#showlogs').show();
            $('#divvideo').hide();
            $("#divaudiodata").hide();
            forclearall();
        }
        function GetFixedrows() {

            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer" role="grid" aria-describedby="example2_info" ID="tabledetails">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Conclusion</th></tr></thead></tbody>';
            for (var i = 1; i < 6; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + i + '</td>';
                results += '<td ><input id="txtCode" class="codecls"   placeholder= "Conclusion" style="width:920px;height:50px;" /></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
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
            results += '<thead><tr><th scope="col">Sno</th><th scope="col">Code</th></tr></thead></tbody>';
            for (var i = 0; i < DataTable.length; i++) {
                results += '<tr><td scope="row" class="1" style="text-align:center;" id="txtsno">' + DataTable[i].Sno + '</td>';
                results += '<td ><input id="txtCode" type="text" class="codecls"  style="width:920px;height:50px;" value="' + DataTable[i].code + '"/></td>';
                results += '<td data-title="Minus"><span><img src="images/minus.png" onclick="removerow(this)" style="cursor:pointer"/></span></td>';
                results += '<td style="display:none" class="4">' + i + '</td></tr>';
            }
            results += '</table></div>';
            $("#div_SectionData").html(results);
        }


        var DataTable;
        function removerow(thisid) {
            $(thisid).parents('tr').remove();
        }

        //-------------> allow only required extention
        function hasExtension(fileName, exts) {
            return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$')).test(fileName);
        }

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('.prw_img,#img_1').attr('src', e.target.result).width(200).height(200);
                    //                    $('#img_1').css('display', 'inline');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function getFile() {
            document.getElementById("file").click();
        }
        //----------------> convert base 64 to file
        function dataURItoBlob(dataURI) {
            // convert base64/URLEncoded data component to raw binary data held in a string
            var byteString;
            if (dataURI.split(',')[0].indexOf('base64') >= 0)
                byteString = atob(dataURI.split(',')[1]);
            else
                byteString = unescape(dataURI.split(',')[1]);
            // separate out the mime component
            var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
            // write the bytes of the string to a typed array
            var ia = new Uint8Array(byteString.length);
            for (var i = 0; i < byteString.length; i++) {
                ia[i] = byteString.charCodeAt(i);
            }
            return new Blob([ia], { type: 'image/jpeg' });
        }
        function upload_Meeting_conduct_Info() {
            var documentid = document.getElementById('ddl_documenttype').value;
            var documentname = document.getElementById('ddl_documenttype').selectedOptions[0].innerText;
            if (documentid == null || documentid == "" || documentid == "Select Document Type") {
                document.getElementById("ddl_documenttype").focus();
                alert("Please select Document Type");
                return false;
            }
            var Data = new FormData();
            Data.append("op", "upload_Meeting_conduct_Info");
            Data.append("meeting_no", meeting_no);
            Data.append("conducted_by", conducted_by);
            Data.append("documentname", documentname);
            Data.append("documentid", documentid);
            var fileUpload = $("#FileUpload1").get(0);
            var files = fileUpload.files;
            for (var i = 0; i < files.length; i++) {
                Data.append(files[i].name, files[i]);
            }

            var s = function (msg) {
                if (msg) {
                    alert(msg);
                }
            };
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler_nojson_post(Data, s, e);
        }
        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                type: "POST",
                // dataType: "json",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }
        function readURL_doc(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                document.getElementById("FileUpload_div").innerHTML = input.files[0].name;
            }
        }
        function getFile_doc() {
            document.getElementById("FileUpload1").click();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Meeting Conduct Master
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Meeting Conduct Management</a></li>
            <li><a href="#">Meeting Conduct</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Meeting Conduct Details
                </h3>
            </div>
            <div class="box-body">
                <div id="showlogs" align="center">
                    <input id="btn_addCategory" type="button" name="submit" value='AddMeeting Details'
                        class="btn btn-primary" onclick="showdesign()" />
                </div>
                <div id="div_MeetingData">
                </div>
                <div id='fillform' style="display: none;">
                    <table align="center">
                        <tr>
                         <td>
                                <label>
                                    Date</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txt_Meetingdate" type="date"    class="form-control"  placeholder="Enter Name" />
                            </td>
                            </tr>
                            <tr>
                            <td>
                                <label>
                                    StartTime</label>
                            </td>
                            <td style="height: 40px;">
                                <input id="txtStarttime" type="time"   class="form-control"  placeholder="Enter Name"/>
                            </td>
                            <td>
                            </td>
                            <td>
                                <label>
                                    End Time</label>
                            </td>
                            <td>
                                <input id="txtEndtime" type="time" placeholder="Enter Name"
                                    class="form-control" />
                            </td>
                        </tr>
                         <tr>
                        </tr>
                        <tr>
                        <td>
                                <label>
                                    Department</label>
                            </td>
                            <td>
                                <input id="txt_Department" type="text" name="CustomerFName" placeholder="Enter Department" onchange="empnamechange();"
                                    class="form-control " />
                            </td>
                             <td style="height: 40px; display:none">
                                <input id="txt_Departmentid" type="hidden" class="form-control" name="hiddenempid" />
                            </td>
                            </tr>
                       <tr style="height: 5px;">
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    Subject</label>
                            </td>
                            <td colspan="4">
                                <input id="txt_subject" type="text" name="CMobileNumber" placeholder="Enter Subject"
                                    class="form-control"  />
                            </td>
                        </tr>
                        <tr style="height: 5px;">
                        </tr>
                        <tr>
                            <td>
                                <label>
                                   participants</label>
                            </td>
                            <td colspan="4">
                            <input id="txt_participants" type="text" name="participants" placeholder="Enter participants"
                                    class="form-control" />
                            <%-- <select id="txt_participants" class="form-control"></select>--%>
                             </td>
                             <td style="height: 40px; display: none">
                            <input id="txt_patid" type="hidden" class="form-control" name="hiddenempid" />
                        </td>
                        <td style="height: 40px;">
                        <input type="button" class="btn btn-success" name="submit" class="btn btn-primary"
                                id="Button1" value='Add' onclick="AddTogridClick()" />
                        </td>
                        </tr>
                        <tr>
                        <td colspan="4" style="height: 60px;">
                         <div id="div_vendordata" style="background: #ffffff"></div>
                         </td>
                         </tr>
                        <tr style="height: 5px;">
                        </tr>
                        <tr>
                            <td>
                                <label>
                                    conducted_by</label>
                            </td>
                            <td>
                                <input id="txt_conductby" type="text" name="CMobileNumber" placeholder="Enter conducted_by"
                                    class="form-control" onkeypress="return ValidateAlpha(event);" />
                            </td>
                            <td>
                            </td>
                            <td>
                                <label>
                                    video Path</label>
                            </td>
                            <td>
                                <input id="txt_Videopath" type="text" name="CMobileNumber" placeholder="Enter video"
                                    class="form-control" />
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                    </table>
                   <%-- <object width="425" height="350">
                        <param name="movie" value="http://www.youtube.com/v/tIBxavsiHzM" />
                        <embed src="http://www.youtube.com/v/tIBxavsiHzM" type="application/x-shockwave-flash"
                            width="425" height="350" />
                    </object>--%>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-4">
                                <label class="control-label">
                                    Document Type</label>
                                <select id="ddl_documenttype" class="form-control">
                                    <option>Select Document Type</option>
                                    <option value="1">DrivingLicence</option>
                                    <option value="2">Adarcard</option>
                                    <option value="3">voterid</option>
                                </select>
                            </div>
                            <div class="col-sm-4">
                                <table class="table table-bordered table-striped">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div id="FileUpload_div" class="img_btn" onclick="getFile_doc()" style="height: 50px;
                                                    width: 100%">
                                                    Choose Document To Upload
                                                </div>
                                                <div style="height: 0px; width: 0px; overflow: hidden;">
                                                    <input id="FileUpload1" type="file" name="files[]" onchange="readURL_doc(this);">
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-sm-4">
                                <input id="btn_upload_document" type="button" class="btn btn-primary" name="submit"
                                    value="UPLOAD" onclick="upload_Meeting_conduct_Info();" style="width: 120px;
                                    margin-top: 25px;">
                            </div>
                        </div>
                    </div>
                    <div id="divaudiodata" style="text-align: center; padding-left: 53px;">
                    <object id="objaudio" type="application/x-shockwave-flash"
                        width="240" height="20" id="dewplayer">
                        <param name="wmode" value="transparent" />
                        <param name="movie" value="dewplayer-vol.swf?mp3=mp3/test1.mp3" />
                    </object>
                    </div>
                    </br>
                    </br>
                    <div id="divvideo" style="text-align:center; padding-left:218px;">
                    <a id="player" class="player" style="height: 300px; width: 600px; display: block" href="#"></a>
                    </div>
                    <div id="div_SectionData">
                    </div>
                    <p id="newrow">
                        <input type="button" onclick="insertrow();" class="btn btn-default" value="Insert row" /></p>
                    <div id="">
                        <div>
                            <table align="center">
                                <tr>
                                    <td colspan="2" align="center" style="height: 40px;">
                                        <input id="btn_save" type="button" class="btn btn-primary" name="submit" value='Save'
                                            onclick="SaveMeeting_conduct_Details()" />
                                        <input id='btn_close' type="button" class="btn btn-danger" name="Close" value='Close'
                                            onclick="canceldetails()" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
    </section>
</asp:Content>
