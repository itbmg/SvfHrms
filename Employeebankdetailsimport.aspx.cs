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
public partial class Employeebankdetailsimport : System.Web.UI.Page
{
    DBManager vdm;
    SqlCommand cmd;
    string userid = "";
    string mainbranch = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["userid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            userid = Session["userid"].ToString();
            string mainbranch = Session["mainbranch"].ToString();
            //DateTime dtyear = DateTime.Now.AddYears(1);
            //string fryear = dtyear.ToString("dd/MM/yyyy");
            //string[] str1 = fryear.Split('/');
            //selct_Year.SelectedValue = str1[2];
            //string employee_type = ddlemptype.SelectedItem.Value;
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    //bindemployeetype();
                     getexcelnames();


                    
                }
            }
        }

    }

    //  private void bindemployeetype()
    //{
    //    DBManager SalesDB = new DBManager();
    //    cmd = new SqlCommand("SELECT employee_type FROM employedetails where (employee_type<>'')  GROUP BY employee_type");
    //    DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
    //    ddlemployee.DataSource = dttrips;
    //    ddlemployee.DataTextField = "employee_type";
    //    ddlemployee.DataValueField = "employee_type";
    //    ddlemployee.DataBind();
    //    ddlemployee.ClearSelection();
    //    ddlemployee.Items.Insert(0, new ListItem { Value = "ALL", Text = "ALL", Selected = true });
    //    ddlemployee.SelectedValue = "ALL";
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
            lblmsg.Text = FileUploadToServer.FileName + "\'s Data showing into the GridView";
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
            lblmsg.Text = ex.Message.ToString();

        }
    }
  
    DataTable Report = new DataTable();
    void getexcelnames()
    {
        Report.Columns.Add("SNO");
        Report.Columns.Add("employee_num");
        Report.Columns.Add("bankname");
        Report.Columns.Add("bankaccountnumber");
        Report.Columns.Add("Ifsccode");
        Session["filename"] = "Employeebankdetails";
        Session["title"] = " Employeebankdetails ";
        for (int i = 0; i < 300; i++)
        {
            DataRow newrow = Report.NewRow();
            newrow["SNO"] = i + 1;
            Report.Rows.Add(newrow);
        }
        Session["xportdata"] = Report;

    }

 


    //protected void ddlemployee_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        Report.Columns.Add("SNO");
    //        Report.Columns.Add("fullname");
    //        Report.Columns.Add("empid");
    //        Report.Columns.Add("employee_num");
    //        Report.Columns.Add("employee_type");
    //        Report.Columns.Add("gender");
    //        Report.Columns.Add("dob");
    //        Report.Columns.Add("joindate");
    //        Report.Columns.Add("branchname");
    //        Report.Columns.Add("employee_dept");
    //        Report.Columns.Add("designationiname");
    //        //Report.Columns.Add("Qualification");
    //        Report.Columns.Add("salarymode");
    //        Report.Columns.Add("status");
    //        //Report.Columns.Add("Marital Status");
    //        //Report.Columns.Add("Spouse Full Name");
    //        //Report.Columns.Add("date");
    //        Session["filename"] = "Employeedetails";
    //        Session["title"] = " Employeedetails ";
    //        string mainbranch = Session["mainbranch"].ToString();
    //        if (ddlemployee.SelectedItem.Value == "ALL")
    //        {
    //            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.employee_type, branchmaster.branchname FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE(branchmapping.mainbranch = @m) and employedetails.status='No'  ORDER BY branchmaster.branchname DESC");
    //        }
    //        else
    //        {
    //            cmd = new SqlCommand("SELECT  employedetails.employee_num, employedetails.fullname, branchmaster.branchname, employedetails.employee_type, employedetails.pfeligible FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @type) ORDER BY branchmaster.branchname DESC");
    //            cmd.Parameters.Add("@type", ddlemployee.SelectedItem.Value);
    //        }
    //        cmd.Parameters.Add("@m", mainbranch);
    //        DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
    //        if (dtroutes.Rows.Count > 0)
    //        {
    //            var i = 1;
    //            foreach (DataRow dr in dtroutes.Rows)
    //            {
    //                string employee_num = dr["employee_num"].ToString();
    //                string empname = dr["fullname"].ToString();
    //                string branchname = dr["branchname"].ToString();
    //                DataRow newrow = Report.NewRow();
    //                newrow["SNO"] = i++.ToString();
    //                newrow["Employeecode"] = employee_num;
    //                newrow["Branchname"] = branchname;
    //                newrow["Employeename"] = empname;
    //                Report.Rows.Add(newrow);
    //            }b
    //        }
    //        Session["xportdata"] = Report;
    //    }
    //    catch (Exception ex)
    //    {
    //        lblMessage.Text = ex.Message;
    //        lblmsg.Text = ex.Message;
    //    }
    //}
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dt = (DataTable)Session["dtImport"];
            string mainbranch = Session["mainbranch"].ToString();
            vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            foreach (DataRow dr in dt.Rows)
            {
                try
                {
                    string employee_num = dr["employee_num"].ToString();
                    string bankname = dr["bankname"].ToString();
                    cmd = new SqlCommand("SELECT empid, employee_dept FROM employedetails where (employee_num=@empcode)");
                    cmd.Parameters.Add("@empcode", employee_num);
                    DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                    string deptid = routes.Rows[0]["employee_dept"].ToString();
                    string empid = routes.Rows[0]["empid"].ToString();
                    cmd = new SqlCommand("SELECT   bankname, sno FROM   bankmaster where (bankname=@bankname)");
                    cmd.Parameters.Add("@bankname",bankname);
                    DataTable routes1 = vdm.SelectQuery(cmd).Tables[0];
                    string bankid = routes1.Rows[0]["sno"].ToString();
                    if (employee_num == "0" || employee_num == "")
                    {
                    }
                    else
                    {
                        string empcode = dr["employee_num"].ToString();
                        string accountno = dr["bankaccountnumber"].ToString();
                        string Ifsccode = dr["Ifsccode"].ToString();
                        //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                        cmd = new SqlCommand("insert into employebankdetails (employeid,accountno,bankid,ifsccode, empcode) values (@employe,@accountno,@bankid, @ifsc,  @empcode)");
                        cmd.Parameters.Add("@employe", empid);
                      cmd.Parameters.Add("@accountno", accountno);
                  cmd.Parameters.Add("@bankid", bankid);
                cmd.Parameters.Add("@ifsc", Ifsccode);
                cmd.Parameters.Add("@empcode", empcode);
                        //vdm.insert(cmd);
                        
                    }
                }

                catch (Exception ex)
                {
                    lblMessage.Text = ex.Message;
                    lblmsg.Text = ex.Message;
                }
            }

            lblMessage.Text = " Employeebankdetails are successfully saved";
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
            lblmsg.Text = ex.Message;
        }
    }
}