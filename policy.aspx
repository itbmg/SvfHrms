<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="policy.aspx.cs" Inherits="policies" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(function () {
        getpolicy_Uploaded_Documents();
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

    function upload_Employee_Document_Info() {
        var documentid = document.getElementById('ddl_documenttype').value;
        var documentname = document.getElementById('ddl_documenttype').selectedOptions[0].innerText;
        if (documentid == null || documentid == "" || documentid == "Select Document Type") {
            document.getElementById("ddl_documenttype").focus();
            alert("Please select Document Type");
            return false;
        }
        var documentExists = 0;
        $('#tbl_documents tr').each(function () {
            var selectedrow = $(this);
            var document_manager_id = selectedrow[0].cells[0].innerHTML;
            if (document_manager_id == documentid) {
                alert(documentname + "  Already Exist For This Employee");
                documentExists = 1;
                return false;
            }

        });
        if (documentExists == 1) {
            return false;
        }
        var Data = new FormData();
        Data.append("op", "save_policieDocument");
//        Data.append("empsno", empsno);
//        Data.append("empcode", empcode);
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
                getpolicy_Uploaded_Documents();
            }
        };
        var e = function (x, h, e) {
            alert(e.toString());
        };
        callHandler_nojson_post(Data, s, e);
    }


    function getpolicy_Uploaded_Documents() {
        var data = { 'op': 'getpolicy_Uploaded_Documents' };
            var s = function (msg) {
                if (msg) {
                    fillemployee_Uploaded_Documents(msg);
                }
                else {
                }
            };
            var e = function (x, h, e) {
            }; $(document).ajaxStart($.blockUI).ajaxStop($.unblockUI);
            callHandler(data, s, e);
        }
        function fillemployee_Uploaded_Documents(msg) {
        
            var results = '<div class="divcontainer" style="overflow:auto;"><table class="table table-bordered table-hover dataTable no-footer">';
            results += '<thead><tr><th scope="col">Sno</th><th scope="col" style="text-align:center">Document Name</th><th scope="col">Photo</th><th scope="col">Download</th></tr></thead></tbody>';
            var k = 1;
            for (var i = 0; i < msg.length; i++) {
                results += '<tr><td>' + k++ + '</td>';
//                var ftplocation = msg[i].ftplocation;
                var documentpath = msg[i].documentpath;
                var path = msg[i].ftplocation + msg[i].documentpath;
                var documentid = msg[i].documentid;
                var documentname = "";
                if (documentid == "1") {
                    documentname = "Medicalpolicy";
                }
                if (documentid == "2") {
                    documentname = "Loanpolicy";
                }
                if (documentid == "3") {
                    documentname = "TDSpolicy";
                }
                if (documentid == "4") {
                    documentname = "Pfpolicy";
                }
                
                results += '<th scope="row" class="1" style="text-align:center;">' + documentname + '</th>';
                //results += '<td data-title="Code" class="2">' + msg[i].Status + '</td>';
//                if (documentname == "Insurance") {
                results += '<td data-title="brandstatus" class="2"><iframe src=' + path + ' style="width:400px; height:400px;" frameborder="0"></iframe></td>';
//                }
//                else {
//                    results += '<td data-title="brandstatus" class="2"><img src=' + path + '  style="cursor:pointer;height:400px;width:400px;border-radius: 5px;"/></td>';
//                }
                results += '<th scope="row" class="1" ><a  target="_blank" href=' + path + '><i class="fa fa-download" aria-hidden="true"></i> Download</a></th>';
                //results += '<td style="display:none" class="4">' + msg[i].Reason + '</td>';
                results += '</tr>';
            }
            results += '</table></div>';
            $("#div_documents_table").html(results);
        }
      
    
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="div_Documents" class="box box-danger">
        <div class="box-header with-border">
            <h3 class="box-title">
                <i style="padding-right: 5px;" class="fa fa-cog"></i>Policy Upload</h3>
        </div>
        <div class="box-body">
            <div class="row">
                <div>
                    <br>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-4">
                                <label class="control-label">
                                    policy Type</label>
                                <select id="ddl_documenttype" class="form-control">
                                    <option>Select policy Type</option>
                                    <option value="1">Medicalpolicy</option>
                                    <option value="2">Loanpolicy</option>
                                    <option value="3">TDSpolicy</option>
                                    <option value="4">Pfpolicy</option>
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
                                    value="UPLOAD" onclick="upload_Employee_Document_Info();" style="width: 120px;
                                    margin-top: 25px;">
                            </div>
                        </div>
                    </div>
                    <div class="box-body">
                        <div id="div_documents_table">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

