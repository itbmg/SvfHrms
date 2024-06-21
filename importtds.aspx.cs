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

public partial class importtds : System.Web.UI.Page
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
        int i = 280247;
        foreach (DataRow dr in dt.Rows)
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                string empid = dr["empid"].ToString();
                string PT = dr["PT"].ToString();
                string Gross = dr["Gross"].ToString();
                //string empname = dr["Empname"].ToString();
                //string username = dr["username"].ToString();
                //string pwd = dr["pwd"].ToString();
                //string empno = "";
                cmd = new SqlCommand("update salaryappraisals set profitionaltax=@profitionaltax  where empid=@empmid and gross=@gross");
                cmd.Parameters.Add("@profitionaltax", PT);
                cmd.Parameters.Add("@empmid", empid);
                cmd.Parameters.Add("@gross", Gross);
                if (vdm.Update(cmd) == 0)
                {
                    //cmd = new SqlCommand("insert into modulassign_details(empid, moduleid) values (@sno, @mdid)");
                    //cmd.Parameters.Add("@sno", snpp);
                    //cmd.Parameters.Add("@mdid", "9");
                    //vdm.insert(cmd);
                }

            }
            catch (Exception EX)
            {

            }
        }
        lblMessage.Text = "Saved";
    }
}