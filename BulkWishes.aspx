<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="BulkWishes.aspx.cs" Inherits="BulkWishes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $(function () {
                //get_Dept_details();
                //get_Employeedetails();
                get_Branch_details();
                get_All_Holiday_details();
                forclearall();
                //getdataemployeechange();
            });
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


        function get_All_Holiday_details() {
            var data = { 'op': 'get_All_Holiday_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillholiday(msg);
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

        function fillholiday(msg) {
            var data = document.getElementById('slct_Fstvlname');
            var length = data.options.length;
            document.getElementById('slct_Fstvlname').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Holiday";
            opt.value = "";
            opt.setAttribute("selected", "selected");
            opt.setAttribute("disabled", "disabled");
            opt.setAttribute("class", "dispalynone");
            data.appendChild(opt);
            for (var i = 0; i < msg.length; i++) {
                if (msg[i].Holidayname != null) {
                    var option = document.createElement('option');
                    option.innerHTML = msg[i].Holidayname;
                    option.value = msg[i].sno;
                    data.appendChild(option);
                }
            }
        }

        function get_Branch_details() {
            var data = { 'op': 'get_Branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
                        //fillbranchname(msg);
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
            opt.value = "";
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

        //Function for only no
        $(document).ready(function () {
            $("#txt_phoneno").keydown(function (event) {
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
        });

        //------------>Prevent Backspace<--------------------//
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD'))
            || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                } else {
                    doPrevent = true;
                }
            }

            if (doPrevent) {
                event.preventDefault();
            }
        });
        function ValidateAlpha(evt) {
            var keyCode = (evt.which) ? evt.which : evt.keyCode
            if ((keyCode < 65 || keyCode > 90) && (keyCode < 97 || keyCode > 123) && keyCode != 32)

                return false;
            return true;
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


        function get_wishes_branch_details() {
            var branchid = document.getElementById('Slect_Name').value;
            var holidayid = document.getElementById('slct_Fstvlname').value;
            var data = { 'op': 'get_wishes_branch_details', 'branchid': branchid, 'holidayid': holidayid};
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        //filldetails(msg);
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

        function sendwishclick() {
            var title = document.getElementById('txt_Subject').value;
           
            var branchid = document.getElementById('Slect_Name').value;
            if (branchid == "") {
                alert("Select Branch Name");
                $("#Slect_Name").focus();
                return false;
            }
            var holidayid = document.getElementById('slct_Fstvlname').value;
            if (holidayid == "") {
                $("#slct_Fstvlname").focus();
                alert("Select Festival Name");
                return false;
            }
            var content = document.getElementById('txt_Content').value;
            if (content == "") {
                $("#txt_Content").focus();
                alert("Select Content");
                return false;
            }
            var email = document.getElementById('txt_email').value;
            var ftplocation = "http://49.50.65.160/HRMS/Wishes/";
            var data = { 'op': 'send_Bulk_wishs_click', 'branchid': branchid, 'holidayid': holidayid, 'title': title, 'content': content, 'email': email, 'ftplocation': ftplocation };
            var s = function (msg) {
                if (msg) {
                    if (msg) {
                        alert("Message send Successfully");
                    }
                    else {
                    }
                }
            };
            var e = function (x, h, e) {
            };
            $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function forclearall() {
            document.getElementById('txt_Subject').value = "";
            document.getElementById('txt_Content').value = "";
            document.getElementById('Slect_Name').selectedIndex = 0;
            document.getElementById('slct_Fstvlname').selectedIndex = 0;
            document.getElementById('btn_send').innerHTML = "Send";
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

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#main_img,#img_1').attr('src', e.target.result).width(200).height(200);
                    //                    $('#img_1').css('display', 'inline');
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function getFile() {
            document.getElementById("file1").click();
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
     

        function readURL_doc(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                document.getElementById("FileUpload_div").innerHTML = input.files[0].name;
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
            Bulk Wishes<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Bulk Wishes</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Bulk Wishes Details
                </h3>
            </div>
            <div class="row">
                <div class="box-body">
                    <table id="tbl_leavemanagement" align="center">
                        <tr>
                            <td style="height: 40px;">
                             <label class="control-label" >
                                Branch Name<span style="color: red;">*</span>
                                </label>
                            </td>
                            <td>
                                <select type="text" class="form-control" id="Slect_Name" />
                                     
                            </td>
                            <td style="height: 40px; display: none">
                                <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                            </td>
                              <td style="height: 40px; display: none">
                                <input type="text" ID="txt_email" ></input>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                             <label class="control-label" >
                                Subject
                                </label>
                            </td>
                            <td>
                                <input type="text" class="form-control" id="txt_Subject" placeholder="Enter Title" />
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                             <label class="control-label" >
                                Festivals Name
                                </label>
                            </td>
                            <td>
                                 <select type="text" class="form-control" id="slct_Fstvlname" />
                            </td>
                             <td style="height: 40px; display:none">
                                    <input id="txtsupid" type="hidden" class="form-control" name="hiddenempid" />
                                </td>
                        </tr>
                        <tr>
                            <td style="height: 40px;">
                             <label class="control-label" >
                                Content <span style="color: red;">*</span>
                                </label>
                            </td>
                            <td>
                                <textarea cols="35" rows="3" id="txt_Content" class="form-control" placeholder="Enter Content" ></textarea>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr hidden>
                            <td>
                                <label id="lbl_sno">
                                </label>
                            </td>
                        </tr>
                 </table>
                 <br />
               <table align="center">
                            <tr>
                              <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_send1" onclick="sendwishclick()"></span> <span id="btn_send" onclick="sendwishclick()">save</span>
                             </div>
                    </td>
                    <td  style="width:2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                <span class="glyphicon glyphicon-remove" id='btn_close1' onclick="forclearall()"></span> <span id='btn_close' onclick="forclearall()">Close</span>
                          </div>
                    </td>
                            </tr>
                  
                    </table>
              </div>
         <div class="box box-primary">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-list"></i>Bulk Wishes List
                </h3>
            </div>
                <div id="div_bulentdata">
                </div>
            </div>
              </div>
        </div>
    </section>
</asp:Content>
