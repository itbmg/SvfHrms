using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Common;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Drawing;
using ClosedXML.Excel;
using System.Configuration;

public partial class ImportEmployeeDetailes : System.Web.UI.Page
{
    DBManager vdm;
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Visible = false;
    }
    protected void btnImport_Click(object sender, EventArgs e)
    {
        try
        {
            string FilePath = ConfigurationManager.AppSettings["FilePath"].ToString();
            string filename = string.Empty;
            //To check whether file is selected or not to uplaod
            if (FileUploadToServer.HasFile)
            {
                try
                {
                    string[] allowdFile = { ".xls", ".xlsx" };
                    //Here we are allowing only excel file so verifying selected file pdf or not
                    string FileExt = System.IO.Path.GetExtension(FileUploadToServer.PostedFile.FileName);
                    //Check whether selected file is valid extension or not
                    bool isValidFile = allowdFile.Contains(FileExt);
                    if (!isValidFile)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "Please upload only Excel";
                    }
                    else
                    {
                        // Get size of uploaded file, here restricting size of file
                        int FileSize = FileUploadToServer.PostedFile.ContentLength;
                        if (FileSize <= 1048576)//1048576 byte = 1MB
                        {
                            //Get file name of selected file
                            filename = Path.GetFileName(Server.MapPath(FileUploadToServer.FileName));

                            //Save selected file into server location
                            FileUploadToServer.SaveAs(Server.MapPath(FilePath) + filename);
                            //Get file path
                            string filePath = Server.MapPath(FilePath) + filename;
                            //Open the connection with excel file based on excel version
                            OleDbConnection con = null;
                            if (FileExt == ".xls")
                            {
                                con = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=Excel 8.0;");

                            }
                            else if (FileExt == ".xlsx")
                            {
                                con = new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=Excel 12.0;");
                            }

                            con.Close(); con.Open();
                            //Get the list of sheet available in excel sheet
                            DataTable dt = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            //Get first sheet name
                            string getExcelSheetName = dt.Rows[0]["Table_Name"].ToString();
                            //Select rows from first sheet in excel sheet and fill into dataset "SELECT * FROM [Sheet1$]";  
                            OleDbCommand ExcelCommand = new OleDbCommand(@"SELECT * FROM [" + getExcelSheetName + @"]", con);
                            OleDbDataAdapter ExcelAdapter = new OleDbDataAdapter(ExcelCommand);
                            DataSet ExcelDataSet = new DataSet();
                            ExcelAdapter.Fill(ExcelDataSet);
                            //Bind the dataset into gridview to display excel contents
                            grvExcelData.DataSource = ExcelDataSet;
                            grvExcelData.DataBind();
                            Session["dtImport"] = ExcelDataSet.Tables[0];
                            btnsave.Visible = true;

                        }
                        else
                        {
                            lblMessage.Text = "Attachment file size should not be greater then 1 MB!";
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error occurred while uploading a file: " + ex.Message;
                }
            }
            else
            {
                lblMessage.Text = "Please select a file to upload.";
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
            lblMessage.Visible = true;
        }
    }

    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        vdm = new DBManager();
    //        DataTable dt = (DataTable)Session["dtImport"];
    //        foreach (DataRow dr in dt.Rows)
    //        {
    //            try
    //            {
    //                string employee_num = dr["employee_num"].ToString();
    //                if (employee_num == "")
    //                {
    //                }
    //                else
    //                {
    //                    string fullname = dr["fullname"].ToString();
    //                    //string presentaddress = dr["presentaddress"].ToString();
    //                    string marital_status = dr["marital_status"].ToString();
    //                    string spouse_fullname = dr["spouse_fullname"].ToString();
    //                    // string joindate = dr["joindate"].ToString();

    //                    string strjondate = dr["joindate"].ToString();
    //                    string joindate = "";
    //                    if (strjondate == null || strjondate == "")
    //                    {
    //                        DateTime dtjoindate = DateTime.Now;
    //                        joindate = dtjoindate.ToString("dd/mm/yyyy");
    //                    }
    //                    else
    //                    {
    //                        DateTime dtjoindate = Convert.ToDateTime(strjondate);
    //                        joindate = dtjoindate.ToString("dd/MMM/yyyy");
    //                    }


    //                    string strdob = dr["dob"].ToString();
    //                    string dob = "";
    //                    if (strdob == null || strdob == "")
    //                    {

    //                        dob = "";
    //                    }
    //                    else
    //                    {
    //                        DateTime dtdob = Convert.ToDateTime(strdob);
    //                        dob = dtdob.ToString("dd/MMM/yyyy");
    //                    }

    //                    string cellphone = dr["cellphone"].ToString();

    //                    SqlCommand cmd = new SqlCommand();
    //                    string branchname = dr["branchname"].ToString();
    //                    cmd = new SqlCommand("SELECT branchid FROM branchmaster where branchname=@branchname");
    //                    cmd.Parameters.Add("@branchname", branchname);
    //                    DataTable dtbranch = vdm.SelectQuery(cmd).Tables[0];
    //                    int branchid = 0;
    //                    if (dtbranch.Rows.Count > 0)
    //                    {
    //                        int.TryParse(dtbranch.Rows[0]["branchid"].ToString(), out branchid);
    //                    }
    //                    else
    //                    {
    //                        cmd = new SqlCommand("insert into branchmaster (branchname) values(@branchname)");
    //                        cmd.Parameters.Add("@branchname", branchname);
    //                        vdm.insert(cmd);
    //                        cmd = new SqlCommand("SELECT branchid FROM branchmaster where branchname=@branchname");
    //                        cmd.Parameters.Add("@branchname", branchname);
    //                        dtbranch = vdm.SelectQuery(cmd).Tables[0];
    //                        if (dtbranch.Rows.Count > 0)
    //                        {
    //                            int.TryParse(dtbranch.Rows[0]["branchid"].ToString(), out branchid);
    //                        }
    //                    }
    //                    string designation = dr["designation"].ToString();
    //                    cmd = new SqlCommand("SELECT designationid FROM designation where designation=@designation");
    //                    cmd.Parameters.Add("@designation", designation);
    //                    DataTable dtdesignation = vdm.SelectQuery(cmd).Tables[0];
    //                    int designationid = 0;
    //                    if (dtdesignation.Rows.Count > 0)
    //                    {
    //                        int.TryParse(dtdesignation.Rows[0]["designationid"].ToString(), out designationid);
    //                    }
    //                    else
    //                    {
    //                        cmd = new SqlCommand("insert into designation (designation,status) values(@designation,@status)");
    //                        cmd.Parameters.Add("@designation", designation);
    //                        cmd.Parameters.Add("@status", 1);
    //                        vdm.insert(cmd);
    //                        cmd = new SqlCommand("SELECT designationid FROM designation where designation=@designation");
    //                        cmd.Parameters.Add("@designation", designation);
    //                        dtdesignation = vdm.SelectQuery(cmd).Tables[0];
    //                        if (dtdesignation.Rows.Count > 0)
    //                        {
    //                            int.TryParse(dtdesignation.Rows[0]["designationid"].ToString(), out designationid);
    //                        }
    //                    }
    //                    string nameasforaadhar = dr["nameasforaadhar"].ToString();
    //                    string aadhaar_id = dr["aadhaar_id"].ToString();
    //                    string degree = dr["degree"].ToString();
    //                    string email = dr["email"].ToString();
    //                    string fathername = dr["fathername"].ToString();
    //                    string gender = dr["gender"].ToString();
    //                    string pancard = dr["pancard"].ToString();
    //                    string experience_details = dr["experience_details"].ToString();
    //                    string initials = dr["initials"].ToString();
    //                    string home_phone = dr["home_phone"].ToString();
    //                    string pfeligible = dr["pfeligible"].ToString();
    //                    string esieligible = dr["esieligible"].ToString();
    //                    string status = "No";
    //                    string physicalchallange = "No";
    //                    string aadarenrollnumber = dr["aadarenrollnumber"].ToString();
    //                    string strcurrentlocation = dr["currentlocationsince"].ToString();
    //                    string currentlocationsince = "";
    //                    if (strcurrentlocation == null || strcurrentlocation == "")
    //                    {
    //                        DateTime dtcurrentloaction = DateTime.Now;
    //                        currentlocationsince = dtcurrentloaction.ToString("dd/MMM/yyyy");
    //                    }
    //                    else
    //                    {
    //                        DateTime dtcurrentloaction = Convert.ToDateTime(strcurrentlocation);
    //                        currentlocationsince = dtcurrentloaction.ToString("dd/MMM/yyyy");

    //                    }
    //                    string employee_type = dr["employee_type"].ToString();
    //                    //string currentemployeesince = dr["currentemployeesince"].ToString();
    //                    string strcurrentemployee = dr["currentemployeesince"].ToString();
    //                    string currentemployeesince = "";
    //                    if (strcurrentemployee == null || strcurrentemployee == "")
    //                    {
    //                        DateTime dtcurrentemployee = DateTime.Now;
    //                        currentemployeesince = dtcurrentemployee.ToString("dd/MMM/yyyy");
    //                    }
    //                    else
    //                    {
    //                        DateTime dtcurrentemployee = Convert.ToDateTime(strcurrentemployee);
    //                        currentemployeesince = dtcurrentemployee.ToString("dd/MMM/yyyy");
    //                    }


    //                    //string employee_dept = dr["employee_dept"].ToString();
    //                    string department = dr["department"].ToString();
    //                    int deptid = 0;
    //                    if (department == "")
    //                    {
    //                    }
    //                    else
    //                    {
    //                        cmd = new SqlCommand("SELECT deptid FROM departments where department=@department");
    //                        cmd.Parameters.Add("@department", department);
    //                        DataTable dtdept = vdm.SelectQuery(cmd).Tables[0];
    //                        if (dtdept.Rows.Count > 0)
    //                        {
    //                            int.TryParse(dtdept.Rows[0]["deptid"].ToString(), out deptid);
    //                        }
    //                        else
    //                        {
    //                            cmd = new SqlCommand("insert into departments (department,status) values(@department,@status)");
    //                            cmd.Parameters.Add("@department", department);
    //                            cmd.Parameters.Add("@status", 1);
    //                            vdm.insert(cmd);
    //                            cmd = new SqlCommand("SELECT deptid FROM departments where department=@department");
    //                            cmd.Parameters.Add("@department", department);
    //                            dtdept = vdm.SelectQuery(cmd).Tables[0];
    //                            if (dtdept.Rows.Count > 0)
    //                            {
    //                                int.TryParse(dtdept.Rows[0]["deptid"].ToString(), out deptid);
    //                            }
    //                        }
    //                    }

    //                    //string currentdepartmentsince = dr["currentdepartmentsince"].ToString();
    //                    string strcurrentdepartment = dr["currentdepartmentsince"].ToString();
    //                    string currentdepartmentsince = "";
    //                    if (strcurrentdepartment == null || strcurrentdepartment == "")
    //                    {

    //                        currentdepartmentsince = "";
    //                    }
    //                    else
    //                    {
    //                        DateTime dtcurrentdepartment = Convert.ToDateTime(strcurrentdepartment);
    //                        currentdepartmentsince = dtcurrentdepartment.ToString("dd/MMM/yyyy");
    //                        //DateTime currentdepartmentsince = Convert.ToString();
    //                    }


    //                    //string currentdesignationsince = dr["currentdesignationsince"].ToString();
    //                    string strcurrentdesignation = dr["currentdesignationsince"].ToString();
    //                    string currentdesignationsince = "";
    //                    if (strcurrentdesignation == null || strcurrentdesignation == "")
    //                    {

    //                        DateTime dtjoindate = DateTime.Now;
    //                        currentdesignationsince = dtjoindate.ToString("dd/MMM/yyyy");
    //                    }
    //                    else
    //                    {
    //                        DateTime dtcurrentdesignation = Convert.ToDateTime(strcurrentdesignation);
    //                        currentdesignationsince = dtcurrentdesignation.ToString("dd/MMM/yyyy");
    //                    }

    //                    string home_address = dr["home_address"].ToString();
    //                    string home_address1 = dr["home_address1"].ToString();
    //                    string home_address2 = dr["home_address2"].ToString();
    //                    string address = home_address + "," + home_address1 + "," + home_address2;

    //                    string presentaddress = dr["presentaddress"].ToString();
    //                    string presentaddress1 = dr["presentaddress1"].ToString();
    //                    string presentaddress2 = dr["presentaddress1"].ToString();
    //                    string presntaddress = presentaddress + "," + presentaddress1 + "," + presentaddress2;

    //                    //string home_address = dr["home_address"].ToString();
    //                    //string home_address1 = dr["home_address1"].ToString();
    //                    //string home_address2 = dr["home_address2"].ToString();
    //                    string city = dr["city"].ToString();

    //                    string institute = "";// dr["institute"].ToString();
    //                    string durationofcourse = "";// dr["durationofcourse"].ToString();
    //                    string marriagedate = dr["marriagedate"].ToString();


    //                    string nationality = dr["nationality"].ToString();
    //                    string zipcode = dr["zipcode"].ToString();
    //                    string state = dr["state"].ToString();
    //                    //string confirmdate = dr["confirmdate"].ToString();
    //                    //string strconfirmdate = dr["confirmdate"].ToString();
    //                    //string confirmdate = "";
    //                    //if (strconfirmdate == null || strconfirmdate == "")
    //                    //{
    //                    //    DateTime dtconfrmdate = DateTime.Now;
    //                    //    confirmdate = dtconfrmdate.ToString("dd/mm/yyyy");
    //                    //}
    //                    //else
    //                    //{
    //                    //    DateTime dtconfrmdate = Convert.ToDateTime(strconfirmdate);
    //                    //    confirmdate = dtconfrmdate.ToString("dd/MMM/yyyy");
    //                    //}
    //                    string estnumber = ""; //dr["estnumber"].ToString();
    //                    string pfnumber = dr["pfnumber"].ToString();
    //                    string strpfjoindate = dr["pfjoindate"].ToString();
    //                    string pfjoindate = "";
    //                    if (strpfjoindate == null || strpfjoindate == "")
    //                    {
    //                        pfjoindate = "";
    //                    }
    //                    else
    //                    {
    //                        DateTime dtpfjoindate = Convert.ToDateTime(strpfjoindate);
    //                        pfjoindate = dtpfjoindate.ToString("dd/MMM/yyyy");
    //                    }

    //                    string uannumber = dr["uannumber"].ToString();
    //                    string kycidentity = "NO"; //dr["kycidentity"].ToString();

    //                    string bankname = dr["bankid"].ToString();
    //                    int bankid = 0;
    //                    if (branchname != null)
    //                    {
    //                        cmd = new SqlCommand("SELECT sno FROM bankmaster where bankname=@bankname");
    //                        cmd.Parameters.Add("@bankname", bankname);
    //                        DataTable dtbank = vdm.SelectQuery(cmd).Tables[0];
    //                        bankid = 0;
    //                        if (dtbank.Rows.Count > 0)
    //                        {
    //                            int.TryParse(dtbank.Rows[0]["sno"].ToString(), out bankid);
    //                        }
    //                        else
    //                        {
    //                            cmd = new SqlCommand("insert into bankmaster (bankname,status) values(@bankname,@status)");
    //                            cmd.Parameters.Add("@bankname", bankname);
    //                            cmd.Parameters.Add("@status", 1);
    //                            vdm.insert(cmd);
    //                            cmd = new SqlCommand("SELECT sno FROM bankmaster where bankname=@bankname");
    //                            cmd.Parameters.Add("@bankname", bankname);
    //                            dtbank = vdm.SelectQuery(cmd).Tables[0];
    //                            if (dtbank.Rows.Count > 0)
    //                            {
    //                                int.TryParse(dtbank.Rows[0]["sno"].ToString(), out bankid);
    //                            }
    //                        }
    //                    }
    //                    string accountno = dr["accountno"].ToString();
    //                    string ifsccode = dr["ifsccode"].ToString();
    //                    string nameasforbankrecord = "";// dr["nameasforbankrecord"].ToString();
    //                    string paymenttype = dr["paymenttype"].ToString();

    //                    string genderr = dr["gender"].ToString();
    //                    string nationalityy = dr["nationality"].ToString();
    //                    string profession = "";// dr["profession"].ToString();
    //                    string relation = "";// dr["relation"].ToString();
    //                    cmd = new SqlCommand("update employedetails set  joindate=@joindate,pancard=@pancard, fullname=@fullname, initials=@initials,  gender=@gender, dob=@dob, marital_status=@marital_status, spouse_fullname=@spouse_fullname, nationality=@nationality,  home_address=@home_address,home_phone=@home_phone, cellphone=@cellphone, email=@email, fathername=@fathername, state=@state, zipcode=@zipcode, degree=@degree, experience_details=@experience_details, status=@status, employee_dept=@employee_dept, designationid=@designationid, branchid=@branchid, aadhaar_id=@aadhaar_id, nameasforaadhar=@nameasforaadhar,aadarenrollnumber=@aadarenrollnumber, physicalchallange=@physicalchallange,  currentlocationsince=@currentlocationsince, marriagedate=@marriagedate, currentdesignationsince=@currentdesignationsince, currentdepartmentsince=@currentdepartmentsince, currentemployeesince=@currentemployeesince, pfeligible=@pfeligible, esieligible=@esieligible, institute=@institute, durationofcourse=@durationofcourse, presentaddress=@presentaddress, employee_type=@employee_type where employee_num=@employee_num ");
    //                    cmd.Parameters.Add("@employee_num", employee_num);
    //                    cmd.Parameters.Add("@fullname", fullname);
    //                    cmd.Parameters.Add("@marital_status", marital_status);
    //                    cmd.Parameters.Add("@spouse_fullname", spouse_fullname);
    //                    cmd.Parameters.Add("@cellphone", cellphone);
    //                    cmd.Parameters.Add("@branchid", branchid);
    //                    cmd.Parameters.Add("@designationid", designationid);
    //                    cmd.Parameters.Add("@nameasforaadhar", nameasforaadhar);
    //                    cmd.Parameters.Add("@aadhaar_id", aadhaar_id);
    //                    cmd.Parameters.Add("@degree", degree);
    //                    cmd.Parameters.Add("@fathername", fathername);
    //                    cmd.Parameters.Add("@email", email);
    //                    cmd.Parameters.Add("@gender", gender);
    //                    cmd.Parameters.Add("@experience_details", experience_details);
    //                    cmd.Parameters.Add("@home_phone", home_phone);
    //                    cmd.Parameters.Add("@initials", initials);
    //                    cmd.Parameters.Add("@pfeligible", pfeligible);
    //                    cmd.Parameters.Add("@esieligible", esieligible);
    //                    cmd.Parameters.Add("@status", status);
    //                    cmd.Parameters.Add("@physicalchallange", physicalchallange);
    //                    cmd.Parameters.Add("@joindate", joindate);
    //                    cmd.Parameters.Add("@dob", dob);
    //                    cmd.Parameters.Add("@aadarenrollnumber", aadarenrollnumber);
    //                    cmd.Parameters.Add("@employee_type", employee_type);
    //                    cmd.Parameters.Add("@currentlocationsince", currentlocationsince);
    //                    cmd.Parameters.Add("@currentemployeesince", currentemployeesince);
    //                    cmd.Parameters.Add("@employee_dept", deptid);
    //                    cmd.Parameters.Add("@currentdepartmentsince", currentdepartmentsince);
    //                    cmd.Parameters.Add("@currentdesignationsince", currentdesignationsince);
    //                    cmd.Parameters.Add("@home_address", home_address);
    //                    cmd.Parameters.Add("@nationality", nationality);
    //                    cmd.Parameters.Add("@zipcode", zipcode);
    //                    cmd.Parameters.Add("@state", state);
    //                    //cmd.Parameters.Add("@confirmdate", confirmdate);
    //                    cmd.Parameters.Add("@presentaddress", presentaddress);
    //                    cmd.Parameters.Add("@institute", institute);
    //                    cmd.Parameters.Add("@durationofcourse", durationofcourse);
    //                    cmd.Parameters.Add("@marriagedate", marriagedate);
    //                    cmd.Parameters.Add("@pancard", pancard);
    //                    if (vdm.Update(cmd) == 0)
    //                    {
    //                        cmd = new SqlCommand("insert into employedetails (pancard,joindate,dob,employee_num,fullname,marital_status,spouse_fullname,cellphone,nameasforaadhar,aadhaar_id,degree,branchid,designationid,email,fathername,gender,experience_details,initials,home_phone,pfeligible,esieligible,status,physicalchallange,aadarenrollnumber,currentlocationsince,employee_type,currentemployeesince,employee_dept,currentdepartmentsince,currentdesignationsince,home_address,nationality,zipcode,state,durationofcourse,presentaddress,institute) values (@pancard,@joindate,@dob,@employee_num,@fullname,@marital_status,@spouse_fullname,@cellphone,@nameasforaadhar,@aadhaar_id,@degree,@branchid,@designationid,@email,@fathername,@gender,@experience_details,@initials,@home_phone,@pfeligible,@esieligible,@status,@physicalchallange,@aadarenrollnumber,@currentlocationsince,@employee_type,@currentemployeesince,@employee_dept,@currentdepartmentsince,@currentdesignationsince,@home_address,@nationality,@zipcode,@state,@durationofcourse,@presentaddress,@institute)");
    //                        cmd.Parameters.Add("@employee_num", employee_num);
    //                        cmd.Parameters.Add("@fullname", fullname);
    //                        cmd.Parameters.Add("@marital_status", marital_status);
    //                        cmd.Parameters.Add("@spouse_fullname", spouse_fullname);
    //                        cmd.Parameters.Add("@cellphone", cellphone);
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        cmd.Parameters.Add("@designationid", designationid);
    //                        cmd.Parameters.Add("@nameasforaadhar", nameasforaadhar);
    //                        cmd.Parameters.Add("@aadhaar_id", aadhaar_id);
    //                        cmd.Parameters.Add("@degree", degree);
    //                        cmd.Parameters.Add("@fathername", fathername);
    //                        cmd.Parameters.Add("@email", email);
    //                        cmd.Parameters.Add("@gender", gender);
    //                        cmd.Parameters.Add("@experience_details", experience_details);
    //                        cmd.Parameters.Add("@home_phone", home_phone);
    //                        cmd.Parameters.Add("@initials", initials);
    //                        cmd.Parameters.Add("@pfeligible", pfeligible);
    //                        cmd.Parameters.Add("@esieligible", esieligible);
    //                        cmd.Parameters.Add("@status", status);
    //                        cmd.Parameters.Add("@physicalchallange", physicalchallange);
    //                        cmd.Parameters.Add("@joindate", joindate);
    //                        cmd.Parameters.Add("@aadarenrollnumber", aadarenrollnumber);
    //                        cmd.Parameters.Add("@employee_type", employee_type);
    //                        cmd.Parameters.Add("@currentlocationsince", currentlocationsince);
    //                        cmd.Parameters.Add("@currentemployeesince", currentemployeesince);
    //                        cmd.Parameters.Add("@employee_dept", deptid);
    //                        cmd.Parameters.Add("@currentdepartmentsince", currentdepartmentsince);
    //                        cmd.Parameters.Add("@currentdesignationsince", currentdesignationsince);
    //                        cmd.Parameters.Add("@home_address", home_address);
    //                        cmd.Parameters.Add("@nationality", nationality);
    //                        cmd.Parameters.Add("@zipcode", zipcode);
    //                        cmd.Parameters.Add("@state", state);
    //                        cmd.Parameters.Add("@dob", dob);
    //                        //cmd.Parameters.Add("@confirmdate", confirmdate);
    //                        cmd.Parameters.Add("@pancard", pancard);
    //                        cmd.Parameters.Add("@presentaddress", presentaddress);
    //                        cmd.Parameters.Add("@institute", institute);
    //                        cmd.Parameters.Add("@durationofcourse", durationofcourse);
    //                        cmd.Parameters.Add("@marriagedate", marriagedate);
    //                        vdm.insert(cmd);
    //                        //string msg = " employedetails are successfully saved";

    //                    }
    //                    cmd = new SqlCommand("SELECT empid FROM employedetails where employee_num=@employee_num");
    //                    cmd.Parameters.Add("@employee_num", employee_num);
    //                    DataTable dtempid = vdm.SelectQuery(cmd).Tables[0];
    //                    int empid = 0;
    //                    if (dtempid.Rows.Count > 0)
    //                    {
    //                        int.TryParse(dtempid.Rows[0]["empid"].ToString(), out empid);
    //                    }
    //                    //cmd = new SqlCommand("update  employeefamilydetailes set empid=@empid, remarks=@remarks, relation=@relation, bloodgroup=@bloodgroup, gender=@gender, nationality=@nationality, profession=@profession, relationdob=@relationdob where empcode=@empcode AND relationname=@relationname");
    //                    //cmd.Parameters.Add("@relationname", relationname);
    //                    //cmd.Parameters.Add("@relation", relation);
    //                    //cmd.Parameters.Add("@bloodgroup", bloodgroup);
    //                    //cmd.Parameters.Add("@gender", genderr);
    //                    //cmd.Parameters.Add("@nationality", nationalityy);
    //                    //cmd.Parameters.Add("@profession", profession);
    //                    //cmd.Parameters.Add("@relationdob", relationdob);
    //                    //cmd.Parameters.Add("@remarks", remarks);
    //                    //cmd.Parameters.Add("@empcode", employee_num);
    //                    //cmd.Parameters.Add("@empid", empid);
    //                    //if (vdm.Update(cmd) == 0)
    //                    //{
    //                    //    cmd = new SqlCommand("insert into employeefamilydetailes (relationname,remarks,relation,bloodgroup,gender,nationality,profession,relationdob,empcode,empid) values (@relationname,@remarks,@relation,@bloodgroup,@gender,@nationality,@profession,@relationdob,@empcode,@empid)");
    //                    //    cmd.Parameters.Add("@relationname", relationname);
    //                    //    cmd.Parameters.Add("@empcode", employee_num);
    //                    //    cmd.Parameters.Add("@relation", relation);
    //                    //    cmd.Parameters.Add("@bloodgroup", bloodgroup);
    //                    //    cmd.Parameters.Add("@gender", genderr);
    //                    //    cmd.Parameters.Add("@nationality", nationalityy);
    //                    //    cmd.Parameters.Add("@profession", profession);
    //                    //    cmd.Parameters.Add("@relationdob", relationdob);
    //                    //    cmd.Parameters.Add("@empid", empid);
    //                    //    cmd.Parameters.Add("@remarks", remarks);
    //                    //    vdm.insert(cmd);
    //                    //}
    //                    //string msg = " employeefamilydetailes are successfully saved";

    //                    cmd = new SqlCommand("update  employebankdetails set employeid=@employeid, paymenttype=@paymenttype, bankid=@bankid, accountno=@accountno, ifsccode=@ifsccode, nameasforbankrecord=@nameasforbankrecord where empcode=@empcode");
    //                    cmd.Parameters.Add("@empcode", employee_num);
    //                    cmd.Parameters.Add("@bankid", bankid);
    //                    cmd.Parameters.Add("@accountno", accountno);
    //                    cmd.Parameters.Add("@ifsccode", ifsccode);
    //                    cmd.Parameters.Add("@paymenttype", paymenttype);
    //                    cmd.Parameters.Add("@nameasforbankrecord", nameasforbankrecord);
    //                    cmd.Parameters.Add("@employeid", empid);
    //                    if (vdm.Update(cmd) == 0)
    //                    {
    //                        cmd = new SqlCommand("insert into employebankdetails (bankid,paymenttype,accountno,ifsccode,nameasforbankrecord,empcode,employeid) values (@bankid,@paymenttype,@accountno,@ifsccode,@nameasforbankrecord,@empcode,@employeid)");
    //                        cmd.Parameters.Add("@bankid", bankid);
    //                        cmd.Parameters.Add("@accountno", accountno);
    //                        cmd.Parameters.Add("@ifsccode", ifsccode);
    //                        cmd.Parameters.Add("@nameasforbankrecord", nameasforbankrecord);
    //                        cmd.Parameters.Add("@empcode", employee_num);
    //                        cmd.Parameters.Add("@paymenttype", paymenttype);
    //                        cmd.Parameters.Add("@employeid", empid);
    //                        vdm.insert(cmd);
    //                    }

    //                    cmd = new SqlCommand("update employepfdetails set employeid=@employeid,pfnumber=@pfnumber,estnumber=@estnumber, pfjoindate=@pfjoindate, uannumber=@uannumber, kycidentity=@kycidentity where empcode=@empcode");
    //                    cmd.Parameters.Add("@estnumber", estnumber);
    //                    cmd.Parameters.Add("@empcode", employee_num);
    //                    cmd.Parameters.Add("@pfnumber", pfnumber);
    //                    cmd.Parameters.Add("@pfjoindate", pfjoindate);
    //                    cmd.Parameters.Add("@uannumber", uannumber);
    //                    cmd.Parameters.Add("@kycidentity", kycidentity);
    //                    cmd.Parameters.Add("@employeid", empid);

    //                    if (vdm.Update(cmd) == 0)
    //                    {
    //                        cmd = new SqlCommand("insert into employepfdetails (estnumber,pfnumber,pfjoindate,uannumber,kycidentity,empcode,employeid) values (@estnumber,@pfnumber,@pfjoindate,@uannumber,@kycidentity,@empcode,@employeid)");
    //                        cmd.Parameters.Add("@estnumber", estnumber);
    //                        cmd.Parameters.Add("@pfnumber", pfnumber);
    //                        cmd.Parameters.Add("@pfjoindate", pfjoindate);
    //                        cmd.Parameters.Add("@uannumber", uannumber);
    //                        cmd.Parameters.Add("@kycidentity", kycidentity);
    //                        cmd.Parameters.Add("@empcode", employee_num);
    //                        cmd.Parameters.Add("@employeid", empid);
    //                        vdm.insert(cmd);

    //                    }
    //                    //string msg = " employepfdetails are successfully saved";

    //                    //cmd.ExecuteNonQuery();
    //                    //Response.Write("<script>alert('  saved Successfully')</script>");
    //                    //MessageBox.Show("Data inserted successfully");
    //                    //cmd.ExecuteNonQuery();

    //                }
    //            }
    //            catch
    //            {
    //            }
    //        }
    //        lblMessage.Text = "Records inserted successfully";
    //        // Label1.Text = "Records inserted successfully";
    //    }
    //    catch (Exception ex)
    //    {
    //        lblMessage.Text = ex.Message;
    //    }
    //}

    //employee logins

    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    vdm = new DBManager();
    //    DataTable dt = (DataTable)Session["dtImport"];
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        try
    //        {
    //            SqlCommand cmd = new SqlCommand();
    //            //string empid = dr["branchname"].ToString();
    //            //cmd = new SqlCommand("SELECT empid,employee_num FROM employedetails where empid=@empid");
    //            //cmd.Parameters.Add("@branchname", empid);

    //            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
    //            string employee_num = dr["employee_num"].ToString();
    //            //string employee_num = dr["employee_num"].ToString();
    //            if (employee_num == "")
    //            {
    //            }
    //            else
    //            {
    //                cmd = new SqlCommand("SELECT empid,designationid,branchid FROM employedetails where employee_num=@employee_num");
    //                cmd.Parameters.Add("@employee_num", employee_num);
    //                //cmd.Parameters.Add("@empid", empid);
    //                DataTable dtempid = vdm.SelectQuery(cmd).Tables[0];
    //                int empid = 0;
    //                int designationid = 0;
    //                int branchid = 0;
    //                if (dtempid.Rows.Count > 0)
    //                {
    //                    int.TryParse(dtempid.Rows[0]["empid"].ToString(), out empid);
    //                    int.TryParse(dtempid.Rows[0]["designationid"].ToString(), out designationid);
    //                    int.TryParse(dtempid.Rows[0]["branchid"].ToString(), out branchid);
    //                }
    //                string username = dr["username"].ToString();
    //                //string presentaddress = dr["presentaddress"].ToString();
    //                string password = dr["password"].ToString();
    //                string leveltype = dr["leveltype"].ToString();
    //                cmd = new SqlCommand("update employe_logins set username=@username, password=@password,leveltype=@leveltype,designationid=@designationid,branchid=@branchid,empcode=@empcode,doe=@doe where empid=@empid");
    //                cmd.Parameters.Add("@empcode", employee_num);
    //                cmd.Parameters.Add("@username", username);
    //                cmd.Parameters.Add("@password", password);
    //                cmd.Parameters.Add("@leveltype", leveltype);
    //                cmd.Parameters.Add("@empid", empid);
    //                cmd.Parameters.Add("@designationid", designationid);
    //                cmd.Parameters.Add("@branchid", branchid);
    //                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //                if (vdm.Update(cmd) == 0)
    //                {
    //                    cmd = new SqlCommand("insert into employe_logins (username,password,empcode,empid,leveltype,designationid,branchid,doe) values (@username,@password,@empcode,@empid,@leveltype,@designationid,@branchid,@doe)");
    //                    cmd.Parameters.Add("@username", username);
    //                    cmd.Parameters.Add("@password", password);
    //                    cmd.Parameters.Add("@leveltype", leveltype);
    //                    cmd.Parameters.Add("@empcode", employee_num);
    //                    cmd.Parameters.Add("@empid", empid);
    //                    cmd.Parameters.Add("@designationid", designationid);
    //                    cmd.Parameters.Add("@branchid", branchid);
    //                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //                    vdm.insert(cmd);
    //                }

    //                //cmd = new SqlCommand("UPDATE employedetails SET pfdate=@pfdate, esidate=@esidate, pfeligible=@pfeligible, esieligible=@esieligible WHERE employee_num=@empno");
    //                //cmd.Parameters.Add("@pfdate", pfnumber);
    //                //cmd.Parameters.Add("@esidate", uannumber);
    //                //cmd.Parameters.Add("@empno", employee_num);
    //                //vdm.Update(cmd);
    //            }
    //        }
    //        catch (Exception EX)
    //        {

    //        }
    //    }
    //}

    //employee ledgerimport
    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    vdm = new DBManager();
    //    DataTable dt = (DataTable)Session["dtImport"];
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        try
    //        {
    //            SqlCommand cmd = new SqlCommand();
    //            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
    //            string ledgername = dr["Ledger Name"].ToString();
    //            string ledgercode = dr["Ledger Code"].ToString();
    //            string Employeeid = dr["Employee id"].ToString();
    //            if (ledgername == "")
    //            {
    //            }
    //            else
    //            {
    //                cmd = new SqlCommand("update employedetails set ledgercode=@ledgercode, ledgername=@ledgername where empid=@empid");
    //                cmd.Parameters.Add("@ledgercode", ledgercode);
    //                cmd.Parameters.Add("@ledgername", ledgername);
    //                cmd.Parameters.Add("@empid", Employeeid);
    //                vdm.Update(cmd);
    //            }
    //        }
    //        catch (Exception EX)
    //        {

    //        }
    //    }
    //}


    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    vdm = new DBManager();
    //    DataTable dt = (DataTable)Session["dtImport"];
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        try
    //        {
    //            SqlCommand cmd = new SqlCommand();
    //            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
    //            string empcode = dr["Employee Code"].ToString();
    //            string name = dr["Name"].ToString();
    //            string email = dr["EMAIL ID"].ToString();
    //            string Employeeid = dr["Employee id"].ToString();
    //            string moblienumber = dr["mobile number"].ToString();
    //            string address = dr["address"].ToString();
    //            if (empcode == "")
    //            {
    //            }
    //            else
    //            {
    //                cmd = new SqlCommand("update employedetails set home_address=@home_address, presentaddress=@presentaddress,cellphone=@cellphone,email=@email where empid=@empid");
    //                cmd.Parameters.Add("@home_address", address);
    //                cmd.Parameters.Add("@email", email);
    //                cmd.Parameters.Add("@cellphone", moblienumber);
    //                cmd.Parameters.Add("@empid", Employeeid);
    //                //vdm.Update(cmd);
    //            }
    //        }
    //        catch (Exception EX)
    //        {

    //        }
    //    }
    //}


    //esi eligible

    protected void btnSave_Click(object sender, EventArgs e)
    {
        vdm = new DBManager();
        DataTable dt = (DataTable)Session["dtImport"];
        foreach (DataRow dr in dt.Rows)
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                string empcode = dr["employee_num"].ToString();
                string name = dr["fullname"].ToString();
                string esieligible = dr["esieligible"].ToString();
                //string Employeeid = dr["Employee id"].ToString();
                //string moblienumber = dr["mobile number"].ToString();
                //string address = dr["address"].ToString();
                if (empcode == "")
                {
                }
                else
                {
                    cmd = new SqlCommand("update employedetails set fullname=@fullname, esieligible=@esieligible where employee_num=@employee_num");
                    cmd.Parameters.Add("@esieligible", esieligible);
                    // cmd.Parameters.Add("@email", email);
                    cmd.Parameters.Add("@fullname", name);
                    cmd.Parameters.Add("@employee_num", empcode);
                    vdm.Update(cmd);
                }
            }
            catch (Exception EX)
            {

            }
        }
        lblMessage.Text = "Saved";
    }


    //Bank detailes


     //sim detailes
    //protected void btnSave_Click(object sender, EventArgs e)
    //{
    //    vdm = new DBManager();
    //    DataTable dt = (DataTable)Session["dtImport"];
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        try
    //        {
    //            SqlCommand cmd = new SqlCommand();
    //            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
    //            string empid = dr["branchname"].ToString();
    //            cmd = new SqlCommand("SELECT empid,employee_num FROM employedetails where empid=@empid");
    //            cmd.Parameters.Add("@branchname", empid);

    //             DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
    //             string employee_num = dr["employee_num"].ToString();
    //            string employee_num = dr["employee_num"].ToString();
    //            //if (employee_num == "")
    //            //{
    //            //}
    //            //else
    //            //{
    //            cmd = new SqlCommand("SELECT empid,designationid,branchid FROM employedetails where employee_num=@employee_num");
    //            cmd.Parameters.Add("@employee_num", employee_num);
    //            //cmd.Parameters.Add("@empid", empid);
    //            DataTable dtempid = vdm.SelectQuery(cmd).Tables[0];
    //            int empid = 0;
    //            //int designationid = 0;
    //            //int branchid = 0;
    //            if (dtempid.Rows.Count > 0)
    //            {
    //                int.TryParse(dtempid.Rows[0]["empid"].ToString(), out empid);
    //                //int.TryParse(dtempid.Rows[0]["designationid"].ToString(), out designationid);
    //                //int.TryParse(dtempid.Rows[0]["branchid"].ToString(), out branchid);
    //            }
    //            }
    //            string glcode = dr["glcode"].ToString();
    //            string glname = dr["glname"].ToString();
    //            string empid = dr["empid"].ToString();
    //            //string simno = dr["simno"].ToString();
    //            string employeecode = dr["employeecode"].ToString();
    //            string ledgername = dr["ledgername"].ToString();
    //            string ledgercode = dr["ledgercode"].ToString();
    //            string usedby = dr["usedby"].ToString();
    //            string typeofsim = dr["typeofsim"].ToString();
    //            cmd = new SqlCommand("update employe_logins set username=@username, password=@password,leveltype=@leveltype,designationid=@designationid,branchid=@branchid,empcode=@empcode,doe=@doe where empid=@empid");
    //            cmd.Parameters.Add("@empcode", employee_num);
    //            cmd.Parameters.Add("@username", username);
    //            cmd.Parameters.Add("@password", password);
    //            cmd.Parameters.Add("@leveltype", leveltype);


    //            cmd = new SqlCommand("update employe_logins set username=@username, password=@password,leveltype=@leveltype,designationid=@designationid,branchid=@branchid,empcode=@empcode,doe=@doe where empid=@empid");
    //            cmd.Parameters.Add("@empcode", employee_num);
    //            cmd.Parameters.Add("@username", username);
    //            cmd.Parameters.Add("@password", password);
    //            cmd.Parameters.Add("@leveltype", leveltype);
    //            cmd.Parameters.Add("@empid", empid);
    //            cmd.Parameters.Add("@designationid", designationid);
    //            cmd.Parameters.Add("@branchid", branchid);
    //            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //            if (vdm.Update(cmd) == 0)
    //            {

    //            simdetaile

    //            cmd = new SqlCommand("insert into glgroup (glcode,glname) values (@glcode,@glname)");
    //            //cmd.Parameters.Add("@branchid", branchid);
    //            //cmd.Parameters.Add("@simno", simno);
    //            cmd.Parameters.Add("@glcode", glcode);
    //            cmd.Parameters.Add("@glname", glname);
    //            vdm.insert(cmd);

    //            cmd = new SqlCommand("insert into groupledgername (branchid,glcodesno,ledgername,ledgercode) values (@branchid,@glcodesno,@ledgername,@ledgercode)");
    //            cmd.Parameters.Add("@branchid", branchid);
    //            //cmd.Parameters.Add("@simno", simno);
    //            cmd.Parameters.Add("@glcodesno", glcodesno);
    //            cmd.Parameters.Add("@ledgername", ledgername);
    //            cmd.Parameters.Add("@ledgercode", ledgercode);
    //            vdm.insert(cmd);


    //             issue detailes
    //            cmd = new SqlCommand("insert into issue_simcarddetails (networktype,phoneno,usedby,doe,remarks,empid,empcode) values (@networktype,@phoneno,@usedby,@doe,@remarks,@empid,@empcode)");
    //            cmd.Parameters.Add("@networktype", networktype);
    //            //cmd.Parameters.Add("@simno", simno);
    //            cmd.Parameters.Add("@phoneno", phoneno);
    //            cmd.Parameters.Add("@empid", empid);
    //            cmd.Parameters.Add("@usedby", usedby);
    //            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
    //            cmd.Parameters.Add("@remarks", remarks);
    //            cmd.Parameters.Add("@empcode", employee_num);
    //            vdm.insert(cmd);
    //        }
    //        }

    //            cmd = new SqlCommand("UPDATE employedetails SET pfdate=@pfdate, esidate=@esidate, pfeligible=@pfeligible, esieligible=@esieligible WHERE employee_num=@empno");
    //        cmd.Parameters.Add("@pfdate", pfnumber);
    //        cmd.Parameters.Add("@esidate", uannumber);
    //        cmd.Parameters.Add("@empno", employee_num);
    //        vdm.Update(cmd);


    //        catch (Exception EX)
    //        {

    //        }
    //    }

    //}
}

