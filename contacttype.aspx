<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="contacttype.aspx.cs" Inherits="contacttype" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        get_contact_type();
        clearall();
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
    function save_contact_details() {
        var ContactType = document.getElementById('txt_cntct').value;
        if (ContactType == "") {
            alert("Enter ContactType");
            $("#txt_cntct").focus();
            return false;
        }
        var sno = document.getElementById('lbl_sno').innerHTML;
        var btnval = document.getElementById('btn_save').innerHTML;
        var data = { 'op': 'save_contact_details', 'ContactType': ContactType, 'btnVal': btnval, 'sno': sno };
        var s = function (msg) {
            if (msg) {
                if (msg.length > 0) {
                    alert(msg);
                    get_contact_type();
                    $('#div_contact').show();
                    $("#fillform").show();
                    clearall();
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
    function clearall() {
        document.getElementById('txt_cntct').value = "";
        document.getElementById('btn_save').innerHTML = "Save";
    }
    function get_contact_type() {
        var data = { 'op': 'get_contact_type' };
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
        results += '<thead><tr><th scope="col">Contact Type</th><th scope="col"></th></tr></thead></tbody>';
        for (var i = 0; i < msg.length; i++) {
            results += '<tr style="background-color:' + COLOR[l] + '">';
            results += '<td style="display:none" >' + k++ + '</td>';
            results += '<th scope="row" class="1" >' + msg[i].ContactType + '</th>';
            results += '<td style="display:none" class="2">' + msg[i].sno + '</td>';
            results += '<td ><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></tr>';
            l = l + 1;
            if (l == 3) {
                l = 0;
            }
        }
        results += '</table></div>';
        $("#div_cont").html(results);

    }
    function getme(thisid) {
        var ContactType = $(thisid).parent().parent().children('.1').html();
        var sno = $(thisid).parent().parent().children('.2').html();
        document.getElementById('txt_cntct').value = ContactType;
        document.getElementById('btn_save').innerHTML = "Modify";
        document.getElementById('lbl_sno').value = sno;
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="content-header">
        <h1>
           Contact Type <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Operations</a></li>
            <li><a href="#">Contact Type</a></li>
        </ol>
    </section>
    <section class="content">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-cog"></i>Contact Details
                </h3>
            </div>
            <div class="box-body">
             <div id="div_contact">
             <div style="float:left; padding-left:20px">
              <img class="center-block img-circle img-thumbnail img-responsive profile-img" id="Img1"
                                                                    src="Iconimages/contact.png" alt="your image" style="border-radius: 5px; width: 100px;
                                                                    height: 100px; border-radius: 50%;" />
                                                                    </div>
            
                   <div id='fillform' >
                      <table align="center">
                            <tr>
                                <td>
                                    <label>
                                         Contact Type</label>
                                </td>
                                <td style="height: 40px;">
                                    <input id="txt_cntct" class="form-control" type="text" placeholder="Enter Contact Type" />
                               </td>
                             </tr>
                              <tr style="display:none;"><td>
                            <label id="lbl_sno"></label>
                            </td>
                            </tr>
                           </table>
                            <table align="center">
                            <tr>
                               
                       </tr>                  
                 </table>
                 <br />
                 <table align="center">
                            <tr>
                              <td>
                    <div class="input-group">
                                <div class="input-group-addon" >
                                <span class="glyphicon glyphicon-ok" id="btn_save1" onclick="save_contact_details()"></span> <span id="btn_save" onclick="save_contact_details()">save</span>
                             </div>
                    </td>
                    <td width="2%"></td>
                    <td>
                      <div class="input-group">
                                <div class="input-group-close" >
                                 <span class="glyphicon glyphicon-remove" id='btn_clear1' onclick="clearall()"></span> <span id='btn_clear' onclick="clearall()">Close</span>
                          </div>
                    </td>
                            </tr>
                  
                    </table>
        </div>
        </div>
</div>
<div class="box box-primary">
          <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="ion ion-clipboard"></i>Contact Types list
                </h3>
            </div>
       <div id ="div_cont"></div>
                </div>
                 </div>
    </section>
</asp:Content>

