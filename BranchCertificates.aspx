<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true"
    CodeFile="BranchCertificates.aspx.cs" Inherits="BranchCertificates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">

        $(function () {
            getfile_Uploaded_Documents();
            get_branch_details();

            var date = new Date();
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();
            if (month < 10) month = "0" + month;
            if (day < 10) day = "0" + day;
            today = year + "-" + month + "-" + day;
            $('#txt_issuedate').val(today);
            $('#txt_expdate').val(today);
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
        function get_branch_details() {
            var data = { 'op': 'get_branch_details' };
            var s = function (msg) {
                if (msg) {
                    if (msg.length > 0) {
                        fillbranch(msg);
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
        function fillbranch(msg) {
            var data = document.getElementById('selct_branchid');
            var length = data.options.length;
            document.getElementById('selct_branchid').options.length = null;
            var opt = document.createElement('option');
            opt.innerHTML = "Select Branch";
            opt.value = "Select Branch";
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
        function document_type() {
            var doctype = document.getElementById("ddl_documenttype").value;
            if (doctype == "1") {
                $('#div_insurance_type').css('display', 'block');
                $('#selct_insutype').focus();
            }
            else {
                $('#div_insurance_type').css('display', 'none');

            }
        }
        function getFile_doc() {
            document.getElementById("FileUpload1").click();
        }
        function readURL_doc(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.readAsDataURL(input.files[0]);
                document.getElementById("FileUpload_div").innerHTML = input.files[0].name;
            }
        }
        function upload_branch_Document_Info() {
            var branchid = document.getElementById('selct_branchid').value;
            if (branchid == null || branchid == "" || branchid == "Select Branch") {
                document.getElementById("selct_branchid").focus();
                alert("Please select Branch Name");
                return false;
            }
            var branchtype = document.getElementById('slct_btype').value;
            if (branchtype == "0" || branchtype == null || branchtype == "" || branchtype == "Select Branch Type") {
                document.getElementById("slct_btype").focus();
                alert("Please select Branch Type");
                return false;
            }
            var documentname = document.getElementById('ddl_documenttype').selectedOptions[0].innerText;
            var documentid = document.getElementById('ddl_documenttype').value;
            if (documentid == "0" || documentid == null || documentid == "" || documentid == "Select Document Type") {
                document.getElementById("ddl_documenttype").focus();
                alert("Please select Document Type");
                return false;
            }
            var issuedate = document.getElementById('txt_issuedate').value;
            if (issuedate == null || issuedate == "") {
                document.getElementById("txt_issuedate").focus();
                alert("Please select Issue Date");
                return false;
            }
            var expairydate = document.getElementById('txt_expdate').value;
            if (expairydate == null || expairydate == "") {
                document.getElementById("txt_expdate").focus();
                alert("Please select Expairy Date");
                return false;
            }
            var validity = document.getElementById('txt_validity').value;
            var insurancetype = "";
            var insurancetypeid = "";
            if (documentid == "1") {
                insurancetype = document.getElementById('selct_insutype').selectedOptions[0].innerText;
                insurancetypeid = document.getElementById('selct_insutype').value;
                if (insurancetypeid == "0" || insurancetypeid == null || insurancetypeid == "" || insurancetypeid == "Select Insurance Type") {
                    document.getElementById("selct_insutype").focus();
                    alert("Please select Insurance Type");
                    return false;
                }
            }
            else {
                insurancetype = "";
                insurancetypeid = "0";
            }
            var btnvalue = document.getElementById('btn_upload_document').value;
            var documentExists = 0;
            var sno = document.getElementById('lbl_sno').innerHTML;
            $('#BranchCertificates tr').each(function () {
                var selectedrow = $(this);
                var document_manager_id = selectedrow[0].cells[0].innerHTML;
                if (document_manager_id == documentid) {
                    alert(documentname + "Already Exist For This Branch");
                    documentExists = 1;
                    return false;
                }

            });
            if (documentExists == 1) {
                return false;
            }
            var Data = new FormData();
            Data.append("op", "save_branchDocument_data");
            Data.append("branchid", branchid);
            Data.append("branchtype", branchtype);
            Data.append("issuedate", issuedate);
            Data.append("expairydate", expairydate);
            Data.append("validity", validity);
            Data.append("documentname", documentname);
            Data.append("documentid", documentid);
            Data.append("insuranceid", insurancetypeid);
            Data.append("insurancename", insurancetype);
            Data.append("sno", sno);

            Data.append("btnvalue", btnvalue);
            var fileUpload = $("#FileUpload1").get(0);
            var files = fileUpload.files;
            for (var i = 0; i < files.length; i++) {
                Data.append(files[i].name, files[i]);
            }
            var s = function (msg) {
                if (msg) {
                    alert(msg);
                    forclearall();
                    getfile_Uploaded_Documents();
                }
            };
            var e = function (x, h, e) {
                alert(e.toString());
            };
            callHandler_nojson_post(Data, s, e);
        }
        function getfile_Uploaded_Documents() {
            var data = { 'op': 'getfile_Uploaded_Documents' };
            var s = function (msg) {
                if (msg) {
                    fillbranch_Uploaded_Documents(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillbranch_Uploaded_Documents(msg) {
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col" style="text-align:center;">Sno</th><th scope="col" style="text-align:center">Branch Name</th><th scope="col" style="text-align:center">Branch Type</th><th scope="col" style="text-align:center">Document Name</th><th scope="col" style="text-align:center;width: 1%;">Photo</th><th scope="col" style="text-align:center;">Open</th><th scope="col"></th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td style="text-align: center;padding-top: 5%;">' + k++ + '</td>';
                var branchname = msg[i].branchname;
                var documentpath = msg[i].documentpath;
                var path = msg[i].ftplocation + msg[i].documentpath;
                var documentpath = msg[i].documentpath;
                var documentid = msg[i].documentid;
                var documentname = msg[i].documentname;
                var insurancename = msg[i].insurancename;
                var branchtype = msg[i].branchtype;
                var sno = msg[i].sno;

                results += '<th scope="row" class="1" style="text-align: center;padding-top: 5%;">' + branchname + '</th>';
                results += '<th scope="row" class="2" style="text-align: center;padding-top: 5%;">' + branchtype + '</th>';
                results += '<td scope="row" class="4" style="text-align: center;padding-top: 5%;"><span>' + documentname + '</span><br/><span>' + insurancename + '</span></td>';
                results += '<td data-title="brandstatus" class="5" style="text-align: center;"><iframe src=' + path + ' style="width:400px;" frameborder="0"></iframe></td>';
                results += '<th scope="row" class="6" style="text-align: center;padding-top: 5%;"><a  target="_blank" href=' + path + '>Open</a></th>';
                results += '<td style="display:none" class="7">' + msg[i].sno + '</td>';
                results += '<td style="display:none" class="8">' + msg[i].issuedate + '</td>';
                results += '<td style="display:none" class="9">' + msg[i].expairydate + '</td>';
                results += '<td style="display:none" class="10">' + msg[i].Validity + '</td>';
                results += '<td style="display:none" class="11">' + msg[i].insuranceid + '</td>';
                results += '<td style="display:none" class="12">' + msg[i].documentid + '</td>';
                results += '<td style="display:none" class="13">' + msg[i].branchid + '</td>';
                results += '<td style="display:none" class="14">' + msg[i].isdate + '</td>';
                results += '<td style="display:none" class="15">' + msg[i].expdate + '</td>';
                results += '<td style="display:none" class="16">' + msg[i].insurancename + '</td>';
                results += '<td style="display:none" class="17">' + msg[i].documentpath + '</td>';
                results += '<td style="text-align: center;padding-top: 5%;"><button type="button" title="Click Here To Edit!" class="btn btn-info btn-outline btn-circle btn-lg m-r-5 editcls"  onclick="getme(this)"><span class="glyphicon glyphicon-edit" style="top: 0px !important;"></span></button></td></td></tr>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_documents_table").html(results);
        }
        function getme(thisid) {
            var branchname = $(thisid).parent().parent().children('.1').html();
            var branchtype = $(thisid).parent().parent().children('.2').html();
            var path2 = $(thisid).parent().parent().children('.17').html();
            var documentid = $(thisid).parent().parent().children('.12').html();
            var issuedate = $(thisid).parent().parent().children('.14').html();
            var expairydate = $(thisid).parent().parent().children('.15').html();
            var Validity = $(thisid).parent().parent().children('.10').html();
            var insuranceid = $(thisid).parent().parent().children('.11').html();
            var branchid = $(thisid).parent().parent().children('.13').html();
            var insurancename = $(thisid).parent().parent().children('.16').html();
            var sno = $(thisid).parent().parent().children('.7').html();
            document.getElementById('selct_branchid').value = branchid;
            document.getElementById('slct_btype').value = branchtype;
            document.getElementById('ddl_documenttype').value = documentid;
            if (documentid == "1") {
                document_type();
            }
            else {
                $('#div_insurance_type').css('display', 'none');
            }
            document.getElementById('selct_insutype').value = insuranceid;
            document.getElementById('txt_issuedate').value = issuedate;
            document.getElementById('txt_expdate').value = expairydate;
            document.getElementById('txt_validity').value = Validity;
            document.getElementById('selct_insutype').value = insuranceid;
            document.getElementById('lbl_sno').innerHTML = sno;
            document.getElementById('btn_upload_document').value = "Modify";
            $('#btn_upload_document').focus();
        }
        function compareDates() {
            var issuedate = document.getElementById('txt_issuedate').value;
            var expdate = document.getElementById('txt_expdate').value;
            var oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
            var firstDate = new Date(issuedate);
            var secondDate = new Date(expdate);
            var diffDays = Math.round(Math.abs((firstDate.getTime() - secondDate.getTime()) / (oneDay)));
            document.getElementById('txt_validity').value = diffDays + " Days";
        }
        function forclearall() {
            document.getElementById('selct_branchid').selectedIndex = 0;
            document.getElementById('slct_btype').selectedIndex = 0;
            document.getElementById('ddl_documenttype').selectedIndex = 0;
            document.getElementById('selct_insutype').selectedIndex = 0;
//            document.getElementById('txt_issuedate').value = "";
//            document.getElementById('txt_expdate').value = "";
            document.getElementById('txt_validity').value = "0";
            document.getElementById('btn_upload_document').value = "UPLOAD";
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <section class="content-header">
        <h1>
           Certificates <small>Preview</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i>Masters</a></li>
            <li><a href="#">Certificates master</a></li>
        </ol>
    </section>
    <section class="content">
    <div id="div_Documents" class="box box-danger">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i style="padding-right: 5px;" class="fa fa-user-plus"></i>Certificate Details
                </h3>
                 </div>
                    <div class="box-body">
                        <div class="row">
                        <div class="col-sm-2">
                                <label class="control-label">
                                    Branch Name</label>
                                    </div>
                        <div class="col-sm-3">
                                <select id="selct_branchid" class="form-control"></select>
                            </div>
                            <div class="col-sm-2">
                                <label class="control-label">
                                    Branch Type</label>
                                    </div>
                            <div class="col-sm-3">
                                <select id="slct_btype" class="form-control">
                                <option selected disabled value="0">Select Branch Type</option>
                                    <option value="1">Plant</option>
                                    <option value="2">CC</option>
                                    <option value="3">Salesoffice</option>
                                </select>
                            </div>
                        </div>
                            <br/>
                        <div class="row">
                            <div class="col-sm-2">
                                <label class="control-label">
                                    Document Type</label>
                                    </div>
                            <div class="col-sm-3">
                                <select id="ddl_documenttype" class="form-control" onchange="document_type();">
                                    <option selected disabled value="0">Select Document Type</option>
                                    <option value="1">Insurance</option>
                                    <option value="2">Licence</option>
                                    <option value="3">PetroBunk Licence</option>
                                    <option value="4">Polution Control Board</option>
                                    <option value="5">PCB</option>
                                    <option value="6">Boiler Certificate</option>
                                    <option value="7">ISO Certificate</option>
                                    <option value="8">AG Mark</option>
                                    <option value="9">Rental Aggriment</option>
                                    <option value="10">Fire Service Notice</option>
                                    <option value="11">GramPanchayat Tax Notice</option>
                                </select>
                            </div>
                            <br/>
                            <div id="div_insurance_type"  style="display:none;">
                                <div class="col-sm-2">
                                <label class="control-label">
                                    Insurance Type</label>
                                    </div>
                            <div class="col-sm-4">
                                <select id="selct_insutype" class="form-control">
                                    <option selected disabled value="0">Select Insurance Type</option>
                                    <option value="1">fire Policy Insurance</option>
                                    <option value="2">Medical Indemnity Insurance</option>
                                    <option value="3">Professional liability Insurance</option>
                                    <option value="4">Property Insurance</option>
                                    <option value="5">Vehicle Insurance</option>
                                    <option value="6">Landlord and renters Insurance</option>
                                    <option value="7">Farm Insurance</option>
                                    <option value="8">Lenders Mortgage Insurance</option>
                                    <option value="9">Consumer Credit Insurance</option>
                            </select>
                            </div>
                            </div>
                            <div class="col-sm-2">
                                <label class="control-label">
                                    Issue Date</label>
                                    </div>
                            <div class="col-sm-3">
                                <input type="date" id="txt_issuedate" class="form-control" onchange="compareDates();"/>
                            </div>
                            </div>
                            <br/>
                        <div class="row">
                        <div class="col-sm-2">
                                <label class="control-label">
                                    Expairy Date</label>
                                    </div>
                        <div class="col-sm-3">
                                <input type="date" id="txt_expdate" class="form-control" onchange="compareDates();" />
                            </div>
                            <div class="col-sm-2">
                                <label class="control-label">
                                    Validity</label>
                                    </div>
                            <div class="col-sm-3">
                                <input type="text" id="txt_validity" class="form-control" readonly style="text-align: center;" />
                            </div>
                            </div>
                            <br/>
                        <div class="row">
                        <div class="col-sm-2">
                                <label class="control-label">
                                    Choose File</label>
                                    </div>
                            <div class="col-sm-4">
                                <table class="table table-bordered table-striped">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div id="FileUpload_div" class="img_btn" onclick="getFile_doc()" style="height: 20px;
                                                    width: 100%">
                                                    Choose Document To Upload
                                                </div>
                                                <div style="height: 0px; width: 0px; overflow: hidden;">
                                                    <input id="FileUpload1" type="file" name="files[]" onchange="readURL_doc(this);">
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tr hidden>
                                    <td>
                                        <label id="lbl_sno">
                                        </label>
                                    </td>
                                </tr>
                                </table>
                                </div>

                            <div class="col-sm-3">
                                <input id="btn_upload_document" type="button" class="btn btn-primary" name="submit"
                                    value="UPLOAD" onclick="upload_branch_Document_Info();" style="width: 120px;
                                    margin-top: 7px;">
                            </div>
                            <div class="col-sm-3">
                                <input id="btn_close1" type="button" class="btn btn-remove" name="submit"
                                    value="Clear" onclick="forclearall();" style="margin-left: -101px;width: 120px;margin-top: 7px;background-color:  indianred;">
                               </div>
                            </div>
                        </div>
                     <div class="box-body">
                  <div id="div_documents_table">
              </div>
          </div>
      </div>
   </section>
</asp:Content>
