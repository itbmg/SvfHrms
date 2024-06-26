﻿using System;
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

public partial class EmpdetailsImport : System.Web.UI.Page
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
    //private void bindemployeetype()
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
                ConStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path + ";Extended Properties=Excel 8.0;";
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
        Report.Columns.Add("fullname");
        Report.Columns.Add("employee_num");
        Report.Columns.Add("employee_type");
        Report.Columns.Add("gender");
        Report.Columns.Add("birthdate");
        Report.Columns.Add("joindate");
        Report.Columns.Add("branchname");
        Report.Columns.Add("employee_dept");
        Report.Columns.Add("designationiname");
        //Report.Columns.Add("Qualification");
        Report.Columns.Add("salarymode");
        Report.Columns.Add("status");
        //Report.Columns.Add("Marital Status");
        //Report.Columns.Add("Spouse Full Name");
        //Report.Columns.Add("date");
        Session["filename"] = "Employeedetails";
        Session["title"] = " Employeedetails ";
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
    //            }
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
                    string designationiname = dr["designationiname"].ToString();
                    string employee_dept = dr["employee_dept"].ToString();
                    // Department Check
                    cmd = new SqlCommand("Update departments set  status=@status,editedby=@editedby,  editedon=@editedon where department=@department");
                    cmd.Parameters.Add("@department", employee_dept);
                    cmd.Parameters.Add("@status", '1');
                    cmd.Parameters.Add("@editedby", User);
                    cmd.Parameters.Add("@editedon", DateTime.Now);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into departments (department,status,createdby, createdon,groupid) values (@department, @status,@createdby, @createdon,@groupid)");
                        cmd.Parameters.Add("@department", employee_dept);
                        cmd.Parameters.Add("@status", '1');
                        cmd.Parameters.Add("@createdby", User);
                        cmd.Parameters.Add("@createdon", DateTime.Now);
                        vdm.insert(cmd);
                    }
                    cmd = new SqlCommand("SELECT deptid FROM departments where(department=@department)");
                    cmd.Parameters.Add("@department", employee_dept);
                    DataTable dtdepartment = vdm.SelectQuery(cmd).Tables[0];
                    string deptid = dtdepartment.Rows[0]["deptid"].ToString();
                    // Designation Check
                   // string designationid = context.Request["designationid"];
                    cmd = new SqlCommand("Update designation set  status=@status, editedby=@editedby, editedon=@editedon where designationiname=@designationiname");
                    cmd.Parameters.Add("@designation", designationiname);
                    cmd.Parameters.Add("@status", '1');
                    cmd.Parameters.Add("@editedby", User);
                    cmd.Parameters.Add("@editedon", DateTime.Now);
                    //cmd.Parameters.Add("@reason", Reason);
                  //  cmd.Parameters.Add("@designationid", designationid);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into designation (designation,status,createdby, createdon) values (@designation,@status,@createdby,@createdon)");
                        cmd.Parameters.Add("@designation", designationiname);
                        cmd.Parameters.Add("@status", '1');
                        cmd.Parameters.Add("@createdby", User);
                        cmd.Parameters.Add("@createdon", DateTime.Now);
                        //cmd.Parameters.Add("@reason", Reason);
                        vdm.insert(cmd);
                    }
                    cmd = new SqlCommand("SELECT designationid FROM designation WHERE (designation= @designation)");
                    cmd.Parameters.Add("@designation", designationiname);
                    DataTable dtdesignation = vdm.SelectQuery(cmd).Tables[0];
                    string designationid = dtdesignation.Rows[0]["designationid"].ToString();
                    if (employee_num == "0" || employee_num == "")
                    {
                    }
                    else
                    {
                        string empcode = dr["employee_num"].ToString();
                        string fullname = dr["fullname"].ToString();
                        string joindate = dr["joindate"].ToString();
                        string gender = dr["gender"].ToString();
                        string birthdate = dr["birthdate"].ToString();
                        string branchname = dr["branchname"].ToString();
                        string status = dr["status"].ToString();
                        string pfeligible = dr["pfeligible"].ToString();
                        string esieligible = dr["esieligible"].ToString();
                        string email = dr["email"].ToString();
                        string pfdate = dr["pfjoindate"].ToString();
                        string salarymode = dr["salarymode"].ToString();
                        string employeetype = dr["employee_type"].ToString();
                        string entryby = Session["empid"].ToString(); 
                        string esiNo = Session["esino"].ToString();  
                        cmd = new SqlCommand("insert into employedetails (employee_num, joinDate, fullname, gender, dob, degree, status, employee_dept, designationid ,branchid, salarymode, doe,employee_type,pfeligible,esieligible,email,pfdate) values (@employee_num, @joinDate, @fullname, @gender, @dob, @status, @employee_dept, @designationid, @branchid, @salarymode,@employee_type,@pfeligible,@esieligible,@email,@pfdate)");
                        cmd.Parameters.Add("@employee_num", employee_num);
                        cmd.Parameters.Add("@joinDate", joindate);
                        cmd.Parameters.Add("@fullname", fullname);
                        cmd.Parameters.Add("@gender", gender);
                        cmd.Parameters.Add("@dob", birthdate);
                        cmd.Parameters.Add("@branchid", branchname);
                        cmd.Parameters.Add("@status", status);
                        cmd.Parameters.Add("@designationid", designationid);
                        cmd.Parameters.Add("@employee_dept", deptid);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@salarymode", salarymode);
                        cmd.Parameters.Add("@employee_type", employeetype);

                        cmd.Parameters.Add("@pfeligible", pfeligible);
                        cmd.Parameters.Add("@esieligible", esieligible);
                        cmd.Parameters.Add("@email", email);
                        cmd.Parameters.Add("@pfdate", pfdate);

                        vdm.insert(cmd);
                        cmd = new SqlCommand("Select  MAX(empid) as Employeid from employedetails");
                        DataTable dtemployes = vdm.SelectQuery(cmd).Tables[0];
                        int employeid = Convert.ToInt32(dtemployes.Rows[0]["Employeid"].ToString());
                        cmd = new SqlCommand("insert into emp_designation_logs (empid, designationid, doe,startingdate,entryby) values (@employee_sno, @designationid, @doe,@startingdate,@entryby)");
                        cmd.Parameters.Add("@employee_sno", employeid);
                        cmd.Parameters.Add("@designationid", designationid);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@startingdate", ServerDateCurrentdate);
                        cmd.Parameters.Add("@entryby", entryby);
                        vdm.insert(cmd);
                        cmd = new SqlCommand("insert into emp_dept_logs (empid, departmentid, doe,startingdate,entryby) values (@employee_sno,@departmentid, @doe,@startingdate,@entryby)");
                        cmd.Parameters.Add("@employee_sno", employeid);
                        cmd.Parameters.Add("@departmentid", deptid);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@startingdate", ServerDateCurrentdate);
                        cmd.Parameters.Add("@entryby", entryby);
                        vdm.insert(cmd);

                        //// Emplouyee Bank Details
                        //  string empcode = dr["employee_num"].ToString();
                        string bankname = dr["bankname"].ToString();
                        cmd = new SqlCommand("SELECT empid, employee_dept FROM employedetails where (employee_num=@empcode)");
                        cmd.Parameters.Add("@empcode", employee_num);
                        DataTable dtEmp = vdm.SelectQuery(cmd).Tables[0];
                        string empid = dtEmp.Rows[0]["empid"].ToString();
                        cmd = new SqlCommand("SELECT   bankname, sno FROM   bankmaster where (bankname=@bankname)");
                        cmd.Parameters.Add("@bankname", bankname);
                        DataTable DtBank = vdm.SelectQuery(cmd).Tables[0];
                        string bankid = DtBank.Rows[0]["sno"].ToString();
                        if (employee_num == "0" || employee_num == "")
                        {
                        }
                        else
                        {
                            string accountno = dr["accountno"].ToString();
                            string Ifsccode = dr["ifsccode"].ToString();
                            //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                            cmd = new SqlCommand("insert into employebankdetails (employeid,accountno,bankid,ifsccode, empcode) values (@employe,@accountno,@bankid, @ifsc,  @empcode)");
                            cmd.Parameters.Add("@employe", empid);
                            cmd.Parameters.Add("@accountno", accountno);
                            cmd.Parameters.Add("@bankid", bankid);
                            cmd.Parameters.Add("@ifsc", Ifsccode);
                            cmd.Parameters.Add("@empcode", empcode);
                            vdm.insert(cmd);
                        }


                        // Emplouyee PF 
                        string pfjoindate = dr["pfjoindate"].ToString();
                        string uannumber = dr["uannumber"].ToString();
                        string pfnumber = dr["pfnumber"].ToString();
                        string epfcontribution = dr["epfcontribution"].ToString();
                        string pfscheme = "";// dr["epfcontribution"].ToString();
                        string checkpfnumber = "";// dr["epfcontribution"].ToString();
                        string identity = "";// dr["epfcontribution"].ToString();
                        string epscontribution = "";// dr["epfcontribution"].ToString();
                        string estnumber = "";// dr["epfcontribution"].ToString();
                        string kycidentitynumber = "";// dr["epfcontribution"].ToString();

                        cmd = new SqlCommand("insert into employepfdetails (employeid,pfjoindate,pfscheme,uannumber,pfnumber,checkpfnumber,epfexcesscontribution,epsexcesscontribution,kycidentity,estnumber,identityno,entry_by,entry_date) values (@employee,@pfjoindate,@pfscheme, @uannumber,@pfnumber,@checkpfnumber,@epfcontribution,@identity,@epscontribution,@estnumber,@identityno,@entry_by,@entry_date)");
                        //cmd.Parameters.Add("@department", department);
                        cmd.Parameters.Add("@employee", employeid);
                        cmd.Parameters.Add("@pfjoindate", pfjoindate);
                        cmd.Parameters.Add("@pfscheme", pfscheme);
                        cmd.Parameters.Add("@uannumber", uannumber);
                        cmd.Parameters.Add("@pfnumber", pfnumber);
                        cmd.Parameters.Add("@checkpfnumber", checkpfnumber);
                        cmd.Parameters.Add("@epfcontribution", epfcontribution);
                        cmd.Parameters.Add("@identity", identity);
                        cmd.Parameters.Add("@epscontribution", epscontribution);
                        cmd.Parameters.Add("@estnumber", estnumber);
                        cmd.Parameters.Add("@identityno", kycidentitynumber);
                        cmd.Parameters.Add("@entry_by", User);
                        cmd.Parameters.Add("@entry_date", ServerDateCurrentdate);
                        vdm.insert(cmd);

                    }
                }

                catch (Exception ex)
                {
                    lblMessage.Text = ex.Message;
                    lblmsg.Text = ex.Message;
                }
            }

            lblMessage.Text = " Employee are successfully saved";
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
            lblmsg.Text = ex.Message;
        }
    }
}