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

public partial class OrganaisetionFlowImport : System.Web.UI.Page
{
    DBManager vdm;
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Visible = false;
        if (!Page.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                bindemployeenames();
                getexcelnames();
               
            }
        }
    }

    private void bindemployeenames()
    {

        vdm = new DBManager();
        cmd = new SqlCommand("SELECT   designation.designation, employedetails.fullname ,employedetails.empid FROM   employedetails INNER JOIN  designation ON employedetails.designationid = designation.designationid WHERE  (designation.designation = 'Manager' OR designation.designation = 'C E O' OR  designation.designation = 'Chairman') AND (employedetails.status = 'No')");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemployee.DataSource = dttrips;
        ddlemployee.DataTextField = "fullname";
        ddlemployee.DataValueField = "empid";
        ddlemployee.DataBind();
        ddlemployee.ClearSelection();
        ddlemployee.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlemployee.SelectedValue = "0";
    }


    //protected void btnImport_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string FilePath = ConfigurationManager.AppSettings["FilePath"].ToString();
    //        string filename = string.Empty;
    //        //To check whether file is selected or not to uplaod
    //        if (FileUploadToServer.HasFile)
    //        {
    //            try
    //            {
    //                string[] allowdFile = { ".xls", ".xlsx" };
    //                //Here we are allowing only excel file so verifying selected file pdf or not
    //                string FileExt = System.IO.Path.GetExtension(FileUploadToServer.PostedFile.FileName);
    //                //Check whether selected file is valid extension or not
    //                bool isValidFile = allowdFile.Contains(FileExt);
    //                if (!isValidFile)
    //                {
    //                    lblMessage.ForeColor = System.Drawing.Color.Red;
    //                    lblMessage.Text = "Please upload only Excel";
    //                }
    //                else
    //                {
    //                    // Get size of uploaded file, here restricting size of file
    //                    int FileSize = FileUploadToServer.PostedFile.ContentLength;
    //                    if (FileSize <= 1048576)//1048576 byte = 1MB
    //                    {
    //                        //Get file name of selected file
    //                        filename = Path.GetFileName(Server.MapPath(FileUploadToServer.FileName));

    //                        //Save selected file into server location
    //                        FileUploadToServer.SaveAs(Server.MapPath(FilePath) + filename);
    //                        //Get file path
    //                        string filePath = Server.MapPath(FilePath) + filename;
    //                        //Open the connection with excel file based on excel version
    //                        OleDbConnection con = null;
    //                        if (FileExt == ".xls")
    //                        {
    //                            con = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=Excel 8.0;");

    //                        }
    //                        else if (FileExt == ".xlsx")
    //                        {
    //                            con = new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=Excel 12.0;");
    //                        }

    //                        con.Close(); con.Open();
    //                        //Get the list of sheet available in excel sheet
    //                        DataTable dt = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
    //                        //Get first sheet name
    //                        string getExcelSheetName = dt.Rows[0]["Table_Name"].ToString();
    //                        //Select rows from first sheet in excel sheet and fill into dataset "SELECT * FROM [Sheet1$]";  
    //                        OleDbCommand ExcelCommand = new OleDbCommand(@"SELECT * FROM [" + getExcelSheetName + @"]", con);
    //                        OleDbDataAdapter ExcelAdapter = new OleDbDataAdapter(ExcelCommand);
    //                        DataSet ExcelDataSet = new DataSet();
    //                        ExcelAdapter.Fill(ExcelDataSet);
    //                        for (int i = dt.Rows.Count - 1; i >= 0; i--)
    //                        {
    //                            if (dt.Rows[i][1] == DBNull.Value)
    //                                dt.Rows[i].Delete();
    //                        }
    //                        //Bind the dataset into gridview to display excel contents
    //                        grvExcelData.DataSource = ExcelDataSet;
    //                        grvExcelData.DataBind();
    //                        Session["dtImport"] = ExcelDataSet.Tables[0];
    //                        btnsave.Visible = true;

    //                    }
    //                    else
    //                    {
    //                        lblMessage.Text = "Attachment file size should not be greater then 1 MB!";
    //                    }
    //                }
    //            }
    //            catch (Exception ex)
    //            {
    //                lblMessage.Text = "Error occurred while uploading a file: " + ex.Message;
    //            }
    //        }
    //        else
    //        {
    //            lblMessage.Text = "Please select a file to upload.";
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        lblMessage.Text = ex.ToString();
    //        lblMessage.Visible = true;
    //    }
    //}
    protected void btnImport_Click(object sender, EventArgs e)
    {
        try
        {
            string ConStr = "";
            //Extantion of the file upload control saving into ext because   
            //there are two types of extation .xls and .xlsx of Excel   
            string ext = Path.GetExtension(FileUploadToServer.FileName).ToLower();
            //getting the path of the file   
            string path = Server.MapPath("~/Userfiles/" + FileUploadToServer.FileName);
            //saving the file inside the MyFolder of the server  
            FileUploadToServer.SaveAs(path);
            //lblmsg.Text = FileUploadToServer.FileName + "\'s Data showing into the GridView";
            //checking that extantion is .xls or .xlsx  
            if (ext.Trim() == ".xls")
            {
                //connection string for that file which extantion is .xls  
                ConStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
            }
            else if (ext.Trim() == ".xlsx")
            {
                //connection string for that file which extantion is .xlsx  
                ConStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
            }
            //making query  
            OleDbConnection con = null;
            con = new OleDbConnection(ConStr);
            con.Close(); con.Open();
            DataTable dtquery = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
            //Get first sheet name
            string getExcelSheetName = dtquery.Rows[0]["Table_Name"].ToString();
            //string query = "SELECT * FROM [Total Deduction$]";
            //Providing connection  
            OleDbConnection conn = new OleDbConnection(ConStr);
            //checking that connection state is closed or not if closed the   
            //open the connection  
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
            //create command object  
            OleDbCommand cmd = new OleDbCommand(@"SELECT * FROM [" + getExcelSheetName + @"]", conn);
            // create a data adapter and get the data into dataadapter  
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            //DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            //fill the Excel data to data set  
            da.Fill(dt);
            //set data source of the grid view  
            for (int i = dt.Rows.Count - 1; i >= 0; i--)
            {
                if (dt.Rows[i][1] == DBNull.Value)
                    dt.Rows[i].Delete();
            }
            dt.AcceptChanges();
            grvExcelData.DataSource = dt;
            //binding the gridview  
            grvExcelData.DataBind();
            Session["dtImport"] = dt;
            //close the connection  
            conn.Close();
        }

        catch (Exception ex)
        {
            //lblmsg.Text = ex.Message.ToString();

        }
    }
    DataTable Report = new DataTable();
    
    void getexcelnames()
    {
        Report.Columns.Add("SNO");
        Report.Columns.Add("empid");
        Report.Columns.Add("fullname");
        Session["filename"] = "Organisetionflowdetails";
        Session["title"] = " Organisetionflowdetails ";
        for (int i = 0; i < 300; i++)
        {
            DataRow newrow = Report.NewRow();
            newrow["SNO"] = i + 1;
            Report.Rows.Add(newrow);
        }
        Session["xportdata"] = Report;

    }
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
                string empcode = dr["empid"].ToString();
                string name = dr["fullname"].ToString();
                if (empcode == "")
                {
                }
                else
                {
                    cmd = new SqlCommand("insert into  organisationtree(empid,subempid) values(@empid,@subempid)");
                    cmd.Parameters.Add("@empid", ddlemployee.SelectedValue);
                    cmd.Parameters.Add("@subempid", empcode);
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