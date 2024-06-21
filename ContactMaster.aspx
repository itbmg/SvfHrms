<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="ContactMaster.aspx.cs" Inherits="ContactMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="autocomplete/jquery-ui.css" rel="stylesheet" type="text/css" />
 <script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
		<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/css/select2.min.css" rel="stylesheet" />
		<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.1/js/select2.min.js" type="text/javascript"></script>
        <script src="plugins/jQuery/jquery.searchabledropdown.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        get_contact_type();
       // get_Employeedetails();
        get_contactform_type();
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
    function checkLength(txt_phno) {
        var phoneno = document.getElementById('txt_phno').value;
        if (phoneno != 10) {
            alert("Mobile Number Must be of 10digits")
        }
    }
    function save_contactform_details() {
        var dataURL = document.getElementById('main_img').src;
        var contacttype = document.getElementById("ddlctype").value;
        if (contacttype == "") {
            $("#ddlctype").focus();
            alert("Select Contact Type");
            return false;
        }
        var nameofcontact = document.getElementById("txt_cname").value;
        if (nameofcontact == "") {
            $("#txt_cname").focus();
            alert("Select Name");
            return false;
        }
        var phoneno = document.getElementById("txt_phno").value;
        if (phoneno == "") {
            $("#txt_phno").focus();
            alert("Select Number");
            return false;
        }
        var emailid = document.getElementById("txt_email").value;
        var address = document.getElementById("txt_address").value;
        var sno = document.getElementById("txt_sno").value;
        var photo = document.getElementById("yourBtn").value;
        var btnval = document.getElementById("btn_save").innerHTML;
        var div_text = $('#yourBtn').text().trim();
        var blob = dataURItoBlob(dataURL);
        var Data = new FormData();
        Data.append("op", "save_contactform_details");
        Data.append("contacttype", contacttype);
        Data.append("nameofcontact", nameofcontact);
        Data.append("phoneno", phoneno);
        Data.append("emailid", emailid);
        Data.append("address", address);
        Data.append("btnval", btnval);
        Data.append("sno", sno);
        Data.append("canvasImage", blob);
        var s = function (msg) {
            if (msg) {
                alert(msg);
                get_contactform_type();
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

    function get_contact_type() {
        var data = { 'op': 'get_contact_type' };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    fillcontacttypedetails(msg);
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
    function fillcontacttypedetails(msg) {
        var data = document.getElementById('ddlctype');
        var length = data.options.length;
        document.getElementById('ddlctype').options.length = null;
        var opt = document.createElement('option');
        opt.innerHTML = "Select ContactType";
        opt.value = "Select ContactType";
        opt.setAttribute("selected", "selected");
        opt.setAttribute("disabled", "disabled");
        opt.setAttribute("class", "dispalynone");
        data.appendChild(opt);
        for (var i = 0; i < msg.length; i++) {
            if (msg[i].ContactType != null) {
                var option = document.createElement('option');
                option.innerHTML = msg[i].ContactType;
                option.value = msg[i].sno;
                data.appendChild(option);
            }
        }
    }
    function get_contactform_type() {
        var data = { 'op': 'get_contactform_type' };
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
        results += '<thead><tr><th scope="col">Employee Name</th><th scope="col">Contact Type</th><th scope="col">Name Of Contact</th><th scope="col">Phone No</th><th scope="col">Email Id</th><th scope="col">Address</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td style="display:none">' + k++ + '</td>';
            results += '<th scope="row" class="1" >' + msg[i].fullname + '</th>';
            results += '<td data-title="code" class="2">' + msg[i].contact + '</td>';
            results += '<td data-title="code" class="3">' + msg[i].nameofcontact + '</td>';
            results += '<td data-title="code" class="4">' + msg[i].phoneno + '</td>';
            results += '<td data-title="code" class="5">' + msg[i].emailid + '</td>';
            results += '<td data-title="code" class="6">' + msg[i].address + '</td>';
            results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
            results += '<td style="display:none" data-title="code" class="10">' + msg[i].contacttype + '</td>';
            results += '<td style="display:none" data-title="code" class="11">' + msg[i].empid + '</td>';
            results += '<td style="display:none" class="9">' + msg[i].ftplocation + '</td>';
            results += '<td style="display:none" class="8">' + msg[i].photo + '</td>';
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
        var contacttype = $(thisid).parent().parent().children('.10').html();
        var nameofcontact = $(thisid).parent().parent().children('.3').html();
        var phoneno = $(thisid).parent().parent().children('.4').html();
        var emailid = $(thisid).parent().parent().children('.5').html();
        var address = $(thisid).parent().parent().children('.6').html();
        var sno = $(thisid).parent().parent().children('.7').html();
        var photo = $(thisid).parent().parent().children('.8').html();
        var ftplocation = $(thisid).parent().parent().children('.9').html();
        var empid = $(thisid).parent().parent().children('.11').html();
        document.getElementById('ddlctype').value = contacttype;
        document.getElementById('txt_cname').value = nameofcontact;
        document.getElementById('txt_phno').value = phoneno;
        document.getElementById('txt_email').value = emailid;
        document.getElementById('txt_address').value = address;
        document.getElementById('btn_save').innerHTML = "Modify";
        document.getElementById('txt_sno').value = sno;
        var rndmnum = Math.floor((Math.random() * 10) + 1);
        img_url = ftplocation + photo + '?v=' + rndmnum;
        if (photo != "") {
            $('#main_img').attr('src', img_url).width(200).height(200);
        }
        else {
            $('#main_img').attr('src', 'Images/Employeeimg.jpg').width(200).height(200);
        }
        document.getElementById('btn_upload_profilepic').disabled = false;
    }
    function validate_email(txt_email) {
        var emailid = document.getElementById(txt_email);
        with (emailid) {
            apos = value.indexOf("@");
            dotpos = value.lastIndexOf(".");
            if (value == '') {
                alert('field can not be blank');
            }
            else if (apos < 1 || dotpos - apos < 2) {
                alert('please enter correct email');
                return false;
            }
        }
    }
    function forclearall() {
        document.getElementById('ddlctype').selectedIndex = 0;
        document.getElementById('txt_cname').value = "";
        document.getElementById('txt_phno').value = "";
        document.getElementById('txt_email').value = "";
        document.getElementById('txt_address').value = '';
        document.getElementById('btn_save').innerHTML = "Save";
        $('#main_img').attr('src', 'Images/Employeeimg.jpg').width(200).height(200);
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
           Contact Form<small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#"> Contact Form</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>ContactForm Details
                </h3>
            </div>
            <div class="box-body">
             <div id ='div_Contactform'>
             <div class="col-xs-12 col-sm-3 text-center">
       <div class="pictureArea1">
                <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="main_img"
                       src="Images/Employeeimg.jpg" alt="your image" style="border-radius: 5px; width: 200px; height: 200px; border-radius: 50%;" />
          <div class="photo-edit-admin">
               <a onclick="getFile();" class="photo-edit-icon-admin" href="/employee/emp-master/emp-photo?eid=3"
                      title="Change Profile Picture" data-toggle="modal" data-target="#photoup"><i class="fa fa-pencil">
           </i></a>
           </div>
           <div id="yourBtn" class="img_btn" onclick="getFile();" style="margin-top: 5px; display: none;">
                  Click to Choose Image
            </div>
          <div style="height: 0px; width: 0px; overflow: hidden;">
                <input id="file" type="file" name="files[]" onchange="readURL(this);">
             </div>
            <div>
                  <input type="button" id="btn_upload_profilepic" class="btn btn-primary" onclick="upload_profile_pic();"
                                                                        style="margin-top: 5px;" value="Upload Profile Pic">
            </div>
          </div>
      </div>
      
    <div id='fillform' >
                        <table align="center">
                            <tr>
                                <td>
                                    <label>
                                         Contact Type</label>
                                           </td>
                                 <td style="height: 40px;">
                                    <select id="ddlctype" type="text" class="form-control" placeholder="Enter Type" />
                                  </td>
                            </tr>
                            <tr>
                                 <td>
                                       <label>
                                        Name of Contact
                                             </label>
                                 </td>
                                 <td style="height: 40px;">
                                         <input id="txt_cname" class="form-control" type="text" placeholder="Enter Name Of Contact" />
                                         </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>
                                            Phone Number</label>
                                              </td>
                                 <td style="height: 40px;">
                                     <input id="txt_phno" class="form-control" type="text" placeholder="Enter Phone Number"  onblur="checkLength()" onkeypress="return isNumber(event)"/>
                                </td>
                                </tr>
                               <tr>
                                <td>
                                    <label>
                                           Email ID</label>
                                              </td>
                                 <td style="height: 40px;">
                                     <input id="txt_email" class="form-control" type="text"  placeholder="Enter Email" onblur="return validate_email('txt_email')" />
                                </td>
                                </tr>
                               <tr>
                                <td>
                                    <label>
                                            Address</label>
                                              </td>
                                 <td colspan="2">
                                   <textarea rows="5" cols="45" id="txt_address" class="form-control" maxlength="2000"
                                placeholder="Enter Address"></textarea>
                                </td>
                               </tr>
                            
                               <tr style="display:none;"><td>
                            <label id="txt_sno"></label>
                            </td>
                           </tr>
                              </table>
                          <br />
                    <table align="center">
                            <tr>
                              <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_contactform_details()"></span> <span id="btn_save" onclick="save_contactform_details()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                 <span class="glyphicon glyphicon-remove" id='btn_clear1' onclick="forclearall()"></span> <span id='btn_clear' onclick="forclearall()">Close</span>
                          </div>
                    </td>
                            </tr>
                  
                    </table>
                    
              </div>
           </div> 
       
       <div class="box box-primary">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-th-list"></i>Contacts  list
                </h3>
            </div>
       <div id ="div_contactform"></div>
                </div>
                </div> 
       </div>
  </section>
</asp:Content>

