using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Drawing;
using ClosedXML.Excel;
using System.Configuration;

public partial class EmpPayStructureImport : System.Web.UI.Page
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
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dt = (DataTable)Session["dtImport"];
            vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            foreach (DataRow dr in dt.Rows)
            {
                string employee_num = dr["employee_num"].ToString();
                if (employee_num == "0" || employee_num == "")
                {
                }
                else
                {

                   // string employee_num = dr["EmployeeNo"].ToString();
                    cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.joindate, employedetails.fullname, employedetails.initials, employedetails.title, employedetails.gender, employedetails.dob, employedetails.marital_status, employedetails.spouse_fullname, employedetails.nationality, employedetails.idproof, employedetails.home_address, employedetails.home_phone, employedetails.cellphone, employedetails.email, employedetails.city, employedetails.state, employedetails.zipcode, employedetails.degree, employedetails.specification, employedetails.experience, employedetails.experience_details, employedetails.photos, employedetails.employee_type, employedetails.employee_dept, employedetails.aboutus, employedetails.aadhaar_id, employedetails.voter_id, employedetails.spouse_details, employedetails.status, employedetails.presentaddress, employedetails.durationofcourse, employedetails.institute, employedetails.university, employedetails.grades, employedetails.remarks, employedetails.nameasforaadhar, employedetails.aadarenrollnumber, employedetails.pancard, employedetails.bloodgroup, employedetails.physicalchallange, employedetails.confirmdate, employedetails.doe, employedetails.designationid, employedetails.roleid, employedetails.branchid, employedetails.salarymode, employedetails.fathername, employedetails.marriagedate, employedetails.age, employedetails.currentlocationsince, employedetails.currentdesignationsince, employedetails.currentdepartmentsince, employedetails.currentemployeesince, employedetails.pfeligible, employedetails.esieligible, branchmaster.statename FROM employedetails INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (employedetails.employee_num = @employee_num)");
                    cmd.Parameters.Add("@employee_num", employee_num);
                    DataTable dtemp = vdm.SelectQuery(cmd).Tables[0];
                    int empid = 0; int branchid = 0; int departmentid = 0;
                    string pfeligible = "";
                    string esieligible = "";
                    string statename = "";
                    string salarymode = "";
                    if (dtemp.Rows.Count > 0)
                    {
                        int.TryParse(dtemp.Rows[0]["empid"].ToString(), out empid);
                        int.TryParse(dtemp.Rows[0]["branchid"].ToString(), out branchid);
                        int.TryParse(dtemp.Rows[0]["employee_dept"].ToString(), out departmentid);
                        pfeligible = dtemp.Rows[0]["pfeligible"].ToString();
                        esieligible = dtemp.Rows[0]["esieligible"].ToString();
                        statename = dtemp.Rows[0]["statename"].ToString();
                        salarymode = dtemp.Rows[0]["salarymode"].ToString();
                    }
                    double conveyance = 0;
                    double washingallowance = 0;
                    double medicalerning = 0;
                    string professionaltax = "0";
                    double providentfound = 0;
                    double esi = 0;
                    double hra = 0;
                    double gross = 0;
                    double travelconveyance = 0;
                    double incometax = 0;
                    double erbasic = 0;
                    double peryear = 0;
                    //double monthsal = 0;
                    if (salarymode == "0")
                    {
                        double.TryParse(dr["GROSS"].ToString(), out gross);
                        peryear = gross * 12;
                        erbasic = gross / 2;
                        conveyance = 1600;
                        if (pfeligible == "NO")
                        {
                            providentfound = 0;
                        }
                        else
                        {
                            var pf = 12;
                            providentfound = ((erbasic) * (pf)) / 100;
                        }
                        if (esieligible == "NO")
                        {
                            esi = 0;
                        }
                        else
                        {
                            var esiper = 1.75;
                            esi = ((peryear) * (esiper)) / 100;
                        }
                        washingallowance = 1000;
                        medicalerning = 1250;
                        double tot = (medicalerning) + (conveyance) + (washingallowance) + (erbasic);
                        hra = (gross) - (tot);
                        if (hra > 0)
                        {
                        }
                        else
                        {
                            hra = 0;
                        }
                        professionaltax = "0";
                        if (statename == "AndraPrdesh")
                        {
                            if (gross > 1000 && gross <= 15000)
                            {
                                professionaltax = "0";
                            }
                            else if (gross >= 15001 && gross <= 20000)
                            {
                                professionaltax = "150";
                            }
                            else if (gross >= 20001)
                            {
                                professionaltax = "200";
                            }
                        }
                        if (statename == "Tamilnadu")
                        {
                            if (gross < 7000)
                            {
                                professionaltax = "0";
                            }
                            else if (gross >= 7001 && gross <= 10000)
                            {
                                professionaltax = "115";
                            }
                            else if (gross >= 10001 && gross <= 11000)
                            {
                                professionaltax = "171";
                            }
                            else if (gross >= 11001 && gross <= 1200)
                            {
                                professionaltax = "171";
                            }
                            else if (gross >= 12001)
                            {
                                professionaltax = "208";
                            }
                        }
                        if (statename == "karnataka")
                        {
                            if (gross <= 15000 && gross <= 15001)
                            {
                                professionaltax = "0";
                            }
                            else if (gross >= 15001)
                            {
                                professionaltax = "200";
                            }
                        }
                    }
                    else
                    {
                        double.TryParse(dr["GROSS"].ToString(), out gross);
                        peryear = gross * 12;
                    }
                    cmd = new SqlCommand("update pay_structure set  empid=@empid,departmentid=@departmentid,gross=@gross,profitionaltax=@profitionaltax,esi=@esi,incometax=@incometax,erningbasic=@erningbasic,hra=@hra,conveyance=@conveyance,medicalerning=@medicalerning,providentfund=@providentfund,washingallowance=@washingallowance,travelconveyance=@travelconveyance,salaryperyear=@salaryperyear where empid=@empid");
                    cmd.Parameters.Add("@departmentid", departmentid);
                    cmd.Parameters.Add("@empid", empid);
                    cmd.Parameters.Add("@gross", gross);
                    cmd.Parameters.Add("@profitionaltax", professionaltax);
                    cmd.Parameters.Add("@esi", esi);
                    cmd.Parameters.Add("@incometax", incometax);
                    cmd.Parameters.Add("@erningbasic", erbasic);
                    cmd.Parameters.Add("@hra", hra);
                    cmd.Parameters.Add("@conveyance", conveyance);
                    cmd.Parameters.Add("@medicalerning", medicalerning);
                    cmd.Parameters.Add("@providentfund", providentfound);
                    cmd.Parameters.Add("@washingallowance", washingallowance);
                    cmd.Parameters.Add("@travelconveyance", travelconveyance);
                    cmd.Parameters.Add("@salaryperyear", peryear);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into pay_structure (empid,departmentid,gross,profitionaltax,esi,incometax,erningbasic,hra,conveyance,medicalerning,providentfund,washingallowance,travelconveyance,salaryperyear) values (@empid,@departmentid,@gross,@profitionaltax,@esi,@incometax,@erningbasic,@hra,@conveyance,@medicalerning,@providentfund,@washingallowance,@travelconveyance,@salaryperyear)");
                        cmd.Parameters.Add("@departmentid", departmentid);
                        cmd.Parameters.Add("@empid", empid);
                        cmd.Parameters.Add("@gross", gross);
                        cmd.Parameters.Add("@profitionaltax", professionaltax);
                        cmd.Parameters.Add("@esi", esi);
                        cmd.Parameters.Add("@incometax", incometax);
                        cmd.Parameters.Add("@erningbasic", erbasic);
                        cmd.Parameters.Add("@hra", hra);
                        cmd.Parameters.Add("@conveyance", conveyance);
                        cmd.Parameters.Add("@medicalerning", medicalerning);
                        cmd.Parameters.Add("@providentfund", providentfound);
                        cmd.Parameters.Add("@washingallowance", washingallowance);
                        cmd.Parameters.Add("@travelconveyance", travelconveyance);
                        cmd.Parameters.Add("@salaryperyear", peryear);
                        vdm.insert(cmd);
                    }
                }
            }
                string msg = " Employee Paystructure are successfully saved";
                lblMessage.Text = msg;
                lblmsg.Text = " Employee Paystructure are successfully saved";
            }
        
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            lblMessage.Text = ex.Message;
        }
    }
}