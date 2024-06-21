<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="esimaster.aspx.cs" Inherits="esimaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css"
        rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js"
        type="text/javascript"></script>
    <script src="plugins/jQuery/jquery.searchabledropdown.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            get_Branch_details();
            get_esiform_details();
            forclearall();
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
        function save_esiform_details() {
            var branchid = document.getElementById("Slect_Name").value;
            if (branchid == "") {
                $("#Slect_Name").focus();
                alert("Select Branch");
                return false;
            }
            var employe = document.getElementById("txt_employe").value;
            if (employe == "") {
                $("#txt_employe").focus();
                alert("Enter employe esi percentage");
                return false;
            }
            var employer = document.getElementById("txt_employer").value;
            if (employer == "") {
                $("#txt_employer").focus();
                alert("Enter employer esi percentage");
                return false;
            }
            var sno = document.getElementById("txt_sno").value;
            var btnval = document.getElementById("btn_save").innerHTML;
            var Data = new FormData();
            Data.append("op", "save_esiform_details");
            Data.append("branchid", branchid);
            Data.append("employe", employe);
            Data.append("employer", employer);
            Data.append("btnval", btnval);
            Data.append("sno", sno);
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    get_esiform_details();
                    forclearall();
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            callHandler_nojson_post(Data, s, e);
        }

        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                type: "POST",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }

        function get_esiform_details() {
            var data = { 'op': 'get_esiform_details' };
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
            var results = '<div  style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Branch Name</th><th scope="col">Employe(%)</th><th scope="col">Employer(%)</th><th scope="col"></th></tr></thead></tbody>';
            for (var i = 0; i < msg.length; i++) {
                results += '<tr style="background-color:' + COLOR[l] + '">';
                results += '<td style="display:none">' + k++ + '</td>';
                results += '<th scope="row" class="1" >' + msg[i].branchname + '</th>';
                results += '<td data-title="code" class="2">' + msg[i].employe + '</td>';
                results += '<td data-title="code" class="3">' + msg[i].employer + '</td>';
                results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td style="display:none" data-title="code" class="11">' + msg[i].branchid + '</td>';
                results += '<td><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"   onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
                l = l + 1;
                if (l == 3) {
                    l = 0;
                }
            }
            results += '</table></div>';
            $("#div_contactform").html(results);
        }
        function getme(thisid) {
            var branchid = $(thisid).parent().parent().children('.11').html();
            var employe = $(thisid).parent().parent().children('.2').html();
            var employer = $(thisid).parent().parent().children('.3').html();
            var sno = $(thisid).parent().parent().children('.7').html();
            document.getElementById('Slect_Name').value = branchid;
            document.getElementById('txt_employe').value = employe;
            document.getElementById('txt_employer').value = employer;
            document.getElementById('btn_save').innerHTML = "Modify";
            document.getElementById('txt_sno').value = sno;
        }

        function forclearall() {
            document.getElementById('Slect_Name').selectedIndex = 0;
            document.getElementById('txt_employer').value = "";
            document.getElementById('txt_employe').value = "";
            document.getElementById('btn_save').innerHTML = "Save";
        }

        function hasExtension(fileName, exts) {
            return (new RegExp('(' + exts.join('|').replace(/\./g, '\\.') + ')$')).test(fileName);
        }

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#main_img,#img_1').attr('src', e.target.result).width(200).height(200);
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
        function upload_profile_pic() {
            var dataURL = document.getElementById('main_img').src;
            var div_text = $('#yourBtn').text().trim();
            var blob = dataURItoBlob(dataURL);
            var sno = document.getElementById('txt_sno').value;
            var empid = document.getElementById('ddlempname').value;
            var Data = new FormData();
            Data.append("op", "profile_pic_files");
            Data.append("sno", sno);
            Data.append("empid", empid);
            Data.append("canvasImage", blob);
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    document.getElementById('btn_upload_profilepic').disabled = true;
                }
                else {
                    document.location = "Default.aspx";
                }
            };
            var e = function (x, h, e) {
            };
            callHandler_nojson_post(Data, s, e);
        }

        function callHandler_nojson_post(d, s, e) {
            $.ajax({
                url: 'EmployeeManagementHandler.axd',
                type: "POST",
                contentType: false,
                processData: false,
                data: d,
                success: s,
                error: e
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Esi Form<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Esi Form</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Esi Details
                </h3>
            </div>
            <div class="box-body">
                <div id='div_Contactform'>
                    <div id='fillform'>
                        <table align="center">
                            <tr>
                                <td>
                                    <label>
                                        Branch Name</label>
                                </td>
                                <td style="height: 40px;">
                                    <select id="Slect_Name" type="text" class="form-control" placeholder="Enter Type" />
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <label>
                                        Employee(%)
                                    </label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_employe" class="form-control" type="text" placeholder="Enter Employee(%)" />
                                </td>
                                <td style="width: 5px;">
                                </td>
                                <td>
                                    <label>
                                        Employer(%)</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_employer" class="form-control" type="text" placeholder="Enter  Employer(%)" />
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>
                                    <label id="txt_sno">
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
                                            <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_esiform_details()">
                                            </span><span id="btn_save" onclick="save_esiform_details()">save</span>
                                        </div>
                                </td>
                                <td width="2%">
                                </td>
                                <td>
                                    <div class="input-group">
                                        <div class="input-group-close">
                                            <span class="glyphicon glyphicon-remove" id='btn_clear1' onclick="forclearall()">
                                            </span><span id='btn_clear' onclick="forclearall()">Close</span>
                                        </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <i style="padding-right: 5px;" class="fa fa-th-list"></i>Contacts list
                        </h3>
                    </div>
                    <div id="div_contactform">
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
