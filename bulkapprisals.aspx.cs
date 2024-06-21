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

public partial class bulkapprisals : System.Web.UI.Page
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
        vdm = new DBManager();
        DataTable dt = (DataTable)Session["dtImport"];
        SqlCommand cmd = new SqlCommand();
        string createdby = Session["empid"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid, branchmaster.statename, employedetails.employee_num, employedetails.employee_dept, employedetails.joindate,employedetails.fullname, employedetails.pfeligible, employedetails.esieligible, employedetails.salarymode FROM employedetails INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid");
        DataTable dtempdetails = vdm.SelectQuery(cmd).Tables[0];
        foreach (DataRow dr in dt.Rows)
        {
            try
            {
                string statename = "";
                string pfeligible = "";
                string esieligible = "";
                double providentfound = 0;
                double esi = 0;
                double professionaltax = 0;
                string salarymode = "";
                string employee_dept = "";
                DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                string empid = dr["empid"].ToString();
                string empcode = dr["empcode"].ToString();
                string amount = dr["appraisal"].ToString();
                string effectivedate = dr["effectivedate"].ToString();
                foreach (DataRow dra in dtempdetails.Select("empid='" + empid + "'"))
                {
                    statename = dra["statename"].ToString();
                    pfeligible = dra["pfeligible"].ToString();
                    esieligible = dra["esieligible"].ToString();
                    salarymode = dra["salarymode"].ToString();
                    employee_dept = dra["employee_dept"].ToString();
                }

                if (salarymode == "0")
                {
                    string prevaspackage = dr["changedpackage"].ToString();
                    string presentpackage = dr["gross"].ToString();
                    double basic = 50;
                    double presentsal = Convert.ToDouble(presentpackage);
                    double erbasic = presentsal * basic;
                    erbasic = erbasic / 100;
                    double medical = 1250;
                    double conveyance = 1600;
                    double washingallowance = 1000;
                    double tot = medical + conveyance + washingallowance + erbasic;
                    double hra = presentsal - tot;

                    if (pfeligible == "Yes")
                    {
                        double pf = 12;
                        providentfound = (erbasic * pf) / 100;
                    }
                    else
                    {
                        providentfound = 0;
                    }

                    if (esieligible == "Yes")
                    {
                        double esiper = 1.75;
                        esi = (erbasic * esiper) / 100;
                    }
                    else
                    {
                        esi = 0;
                    }
                    if (statename == "AndraPrdesh")
                    {
                        if (presentsal > 1000 && presentsal <= 15000)
                        {
                            professionaltax = 0;
                        }
                        else if (presentsal >= 15001 && presentsal <= 20000)
                        {
                            professionaltax = 150;
                        }
                        else if (presentsal >= 20001)
                        {
                            professionaltax = 200;
                        }
                    }
                    if (statename == "Tamilnadu")
                    {
                        if (presentsal < 7000)
                        {
                            professionaltax = 0;
                        }
                        else if (presentsal >= 7001 && presentsal <= 10000)
                        {
                            professionaltax = 115;
                        }
                        else if (presentsal >= 10001 && presentsal <= 11000)
                        {
                            professionaltax = 171;
                        }
                        else if (presentsal >= 11001 && presentsal <= 12000)
                        {
                            professionaltax = 171;
                        }
                        else if (presentsal >= 12001)
                        {
                            professionaltax = 208;
                        }
                    }
                    if (statename == "karnataka")
                    {
                        if (presentsal <= 15000 && presentsal <= 15001)
                        {
                            professionaltax = 0;
                        }
                        else if (presentsal >= 15001)
                        {
                            professionaltax = 200;
                        }
                    }
                    double TotalEarnings = 0;
                    TotalEarnings = erbasic + hra + medical + conveyance + washingallowance;
                    double Totaldeduction = 0;
                    Totaldeduction = providentfound + professionaltax + esi;
                    double netpay = TotalEarnings - Totaldeduction;

                    double salaryperyear = presentsal * 12;
                    double prvsalary = Convert.ToDouble(prevaspackage);
                    double appraisal = presentsal - prvsalary;

                    cmd = new SqlCommand("update pay_structure set gross=@monthlygrosspay, profitionaltax=@profitionaltax, esi=@esi,incometax=@incometax,erningbasic=@erningbasic,hra=@hra,conveyance=@conveyance,medicalerning=@medicalerning,providentfund=@providentfund,salaryperyear=@salaryperyear,washingallowance=@washingallowance where empid=@empid");
                    cmd.Parameters.Add("@erningbasic", erbasic);
                    cmd.Parameters.Add("@hra", hra);
                    cmd.Parameters.Add("@esi", esi);
                    cmd.Parameters.Add("@conveyance", conveyance);
                    cmd.Parameters.Add("@medicalerning", medical);
                    cmd.Parameters.Add("@providentfund", providentfound);
                    cmd.Parameters.Add("@salaryperyear", salaryperyear);
                    cmd.Parameters.Add("@profitionaltax", professionaltax);
                    cmd.Parameters.Add("@incometax", "0");
                    cmd.Parameters.Add("@monthlygrosspay", TotalEarnings);
                    cmd.Parameters.Add("@netpay", netpay);
                    cmd.Parameters.Add("@washingallowance", washingallowance);
                    cmd.Parameters.Add("@empid", empid);
                    vdm.Update(cmd);
                    cmd = new SqlCommand("update salaryappraisals set  endingdate=@endingdate where empid=@empid and endingdate IS NUll");
                    cmd.Parameters.Add("@endingdate", effectivedate);
                    cmd.Parameters.Add("@empid", empid);
                    vdm.Update(cmd);
                    cmd = new SqlCommand("insert into salaryappraisals (departmentid, empid, changedpackage, gross, appraisal, profitionaltax, esi,incometax, erningbasic,hra,conveyance,medicalerning,providentfund,totalearnings,totaldeduction,netpay,doe,createdon,createdby,washingallowance,empcode,salaryperyear,startingdate) values (@department,@employe, @changedpackage, @monthlygrosspay, @appraisal,@profitionaltax,@esi,@incometax,@erningbasic,@hra,@conveyance,@medicalerning,@providentfund,@totalearnings,@totaldeduction,@netpay,@doe,@createdon,@createdby,@washingallowance,@empcode,@salaryperyear,@startingdate)");
                    cmd.Parameters.Add("@department", employee_dept);
                    cmd.Parameters.Add("@employe", empid);
                    cmd.Parameters.Add("@empcode", empcode);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdon", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@changedpackage", prevaspackage);
                    cmd.Parameters.Add("@appraisal", appraisal);
                    cmd.Parameters.Add("@erningbasic", erbasic);
                    cmd.Parameters.Add("@hra", hra);
                    cmd.Parameters.Add("@esi", esi);
                    cmd.Parameters.Add("@conveyance", conveyance);
                    cmd.Parameters.Add("@medicalerning", medical);
                    cmd.Parameters.Add("@providentfund", providentfound);
                    cmd.Parameters.Add("@profitionaltax", professionaltax);
                    cmd.Parameters.Add("@incometax", "0");
                    cmd.Parameters.Add("@monthlygrosspay", presentsal);
                    cmd.Parameters.Add("@totalearnings", TotalEarnings);
                    cmd.Parameters.Add("@totaldeduction", Totaldeduction);
                    cmd.Parameters.Add("@netpay", netpay);
                    cmd.Parameters.Add("@washingallowance", washingallowance);
                    cmd.Parameters.Add("@salaryperyear", salaryperyear);
                    cmd.Parameters.Add("@startingdate", effectivedate);
                    vdm.insert(cmd);
                }
                else
                {
                    double erbasic = 0;
                    providentfound = 0;
                    double conveyance = 0;
                    double medical = 0;
                    double washingallowance = 0;
                    professionaltax = 0;
                    double hra = 0;
                    double incometax = 0;
                    double canteendeduction = 0;
                    washingallowance = 0;
                    esi = 0;
                    double TotalEarnings = 0;
                    double Totaldeduction = 0;
                   
                    double prevsalary = 0;
                    double presentsalary = 0;
                    //var salary = parseInt(presalary) + parseInt(appraisal);
                    double netsalary = 0;
                    netsalary = presentsalary;
                    double netpay = netsalary / 12;
                    double appraisal = presentsalary - prevsalary;
                    double salaryperyear = presentsalary * 12;

                    cmd = new SqlCommand("update pay_structure set gross=@monthlygrosspay, profitionaltax=@profitionaltax, esi=@esi,incometax=@incometax,erningbasic=@erningbasic,hra=@hra,conveyance=@conveyance,medicalerning=@medicalerning,providentfund=@providentfund,salaryperyear=@salaryperyear,washingallowance=@washingallowance where empid=@empid");
                    cmd.Parameters.Add("@erningbasic", erbasic);
                    cmd.Parameters.Add("@hra", hra);
                    cmd.Parameters.Add("@esi", esi);
                    cmd.Parameters.Add("@conveyance", conveyance);
                    cmd.Parameters.Add("@medicalerning", medical);
                    cmd.Parameters.Add("@providentfund", providentfound);
                    cmd.Parameters.Add("@salaryperyear", salaryperyear);
                    cmd.Parameters.Add("@profitionaltax", professionaltax);
                    cmd.Parameters.Add("@incometax", "0");
                    cmd.Parameters.Add("@monthlygrosspay", TotalEarnings);
                    cmd.Parameters.Add("@netpay", netpay);
                    cmd.Parameters.Add("@washingallowance", washingallowance);
                    cmd.Parameters.Add("@empid", empid);
                    vdm.Update(cmd);
                    cmd = new SqlCommand("update salaryappraisals set  endingdate=@endingdate where empid=@empid and endingdate IS NUll");
                    cmd.Parameters.Add("@endingdate", effectivedate);
                    cmd.Parameters.Add("@empid", empid);
                    vdm.Update(cmd);
                    cmd = new SqlCommand("insert into salaryappraisals (departmentid, empid, changedpackage, gross, appraisal, profitionaltax, esi,incometax, erningbasic,hra,conveyance,medicalerning,providentfund,totalearnings,totaldeduction,netpay,doe,createdon,createdby,washingallowance,empcode,salaryperyear,startingdate) values (@department,@employe, @changedpackage, @monthlygrosspay, @appraisal,@profitionaltax,@esi,@incometax,@erningbasic,@hra,@conveyance,@medicalerning,@providentfund,@totalearnings,@totaldeduction,@netpay,@doe,@createdon,@createdby,@washingallowance,@empcode,@salaryperyear,@startingdate)");
                    cmd.Parameters.Add("@department", employee_dept);
                    cmd.Parameters.Add("@employe", empid);
                    cmd.Parameters.Add("@empcode", empcode);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdon", ServerDateCurrentdate);
                    cmd.Parameters.Add("@createdby", createdby);
                    cmd.Parameters.Add("@changedpackage", prevsalary);
                    cmd.Parameters.Add("@appraisal", appraisal);
                    cmd.Parameters.Add("@erningbasic", erbasic);
                    cmd.Parameters.Add("@hra", hra);
                    cmd.Parameters.Add("@esi", esi);
                    cmd.Parameters.Add("@conveyance", conveyance);
                    cmd.Parameters.Add("@medicalerning", medical);
                    cmd.Parameters.Add("@providentfund", providentfound);
                    cmd.Parameters.Add("@profitionaltax", professionaltax);
                    cmd.Parameters.Add("@incometax", "0");
                    cmd.Parameters.Add("@monthlygrosspay", presentsalary);
                    cmd.Parameters.Add("@totalearnings", TotalEarnings);
                    cmd.Parameters.Add("@totaldeduction", Totaldeduction);
                    cmd.Parameters.Add("@netpay", netpay);
                    cmd.Parameters.Add("@washingallowance", washingallowance);
                    cmd.Parameters.Add("@salaryperyear", salaryperyear);
                    cmd.Parameters.Add("@startingdate", effectivedate);
                    vdm.insert(cmd);

                }
            }
            catch (Exception EX)
            {

            }
        }
        lblMessage.Text = "Saved";
    }
}