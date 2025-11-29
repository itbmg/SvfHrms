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


public partial class EditTotalDeduction : System.Web.UI.Page
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
                    bindemployeetype();
                    if (mainbranch == "6")
                    {
                        getexcelnames();


                    }
                    else
                    {
                        getsvffexcelnames();
                    }
                }
            }
        }
    }
    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails where (employee_type<>'')  GROUP BY employee_type");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemployee.DataSource = dttrips;
        ddlemployee.DataTextField = "employee_type";
        ddlemployee.DataValueField = "employee_type";
        ddlemployee.DataBind();
        ddlemployee.ClearSelection();
        ddlemployee.Items.Insert(0, new ListItem { Value = "ALL", Text = "ALL", Selected = true });
        ddlemployee.SelectedValue = "ALL";
    }



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
        Report.Columns.Add("CL HOLIDAY AND OFF");
        Report.Columns.Add("LOP");
        Report.Columns.Add("OTHours");
        Report.Columns.Add("ExtraDays");
        Report.Columns.Add("SALARY ADVANCE");
        Report.Columns.Add("MOBILE DEDUCTION");
        //Report.Columns.Add("Mediclaim Deduction");
        Report.Columns.Add("OTHER LOAN");
        Report.Columns.Add("CANTEEN DEDUCTION");
        Report.Columns.Add("NIGHT ALLOWENCE Days");
        Report.Columns.Add("OTHER DEDUCTION");
        //Report.Columns.Add("TDS DEDUCTION");
        Report.Columns.Add("date");
        Session["filename"] = "Total Deduction";
        Session["title"] = " Total Deduction ";
        for (int i = 0; i < 300; i++)
        {
            DataRow newrow = Report.NewRow();
            newrow["SNO"] = i + 1;
            Report.Rows.Add(newrow);
        }
        Session["xportdata"] = Report;

    }

    void getsvffexcelnames()
    {
        Report.Columns.Add("SNO");
        Report.Columns.Add("employee_num");
        Report.Columns.Add("EmpName");
        Report.Columns.Add("branchname");
        Report.Columns.Add("LOP");
        Report.Columns.Add("OTHours");
        Report.Columns.Add("ExtraDays");
        Report.Columns.Add("SALARY ADVANCE");
        Report.Columns.Add("OTHER LOAN");
        Report.Columns.Add("OTHER DEDUCTION");
        //Report.Columns.Add("TDS DEDUCTION");
        Report.Columns.Add("date");
        Session["filename"] = "Total Deduction";
        Session["title"] = " Total Deduction ";
        //bindemployeetype();
        string mainbranch = Session["mainbranch"].ToString();
        if (ddlemployee.SelectedItem.Value == "ALL")
        {
            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.employee_type, branchmaster.branchname FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE(branchmapping.mainbranch = @m) and employedetails.status='No'  ORDER BY branchmaster.branchname DESC");
            //cmd.Parameters.Add("@type", ddlemptype.SelectedItem.Value);
        }
        else
        {
            cmd = new SqlCommand("SELECT  employedetails.employee_num, employedetails.fullname, branchmaster.branchname, employedetails.employee_type, employedetails.pfeligible FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @type) ORDER BY branchmaster.branchname DESC");
            cmd.Parameters.Add("@type", ddlemployee.SelectedItem.Value);
        }
        //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, branchmaster.branchname FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE(branchmapping.mainbranch = @m) and employedetails.status='No' ORDER BY branchmaster.branchname DESC");
        //cmd.Parameters.Add("@branchid", sbranchid);
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
        if (dtroutes.Rows.Count > 0)
        {
            var i = 1;
            foreach (DataRow dr in dtroutes.Rows)
            {
                string employee_num = dr["employee_num"].ToString();
                string empname = dr["fullname"].ToString();
                string branchname = dr["branchname"].ToString();
                DataRow newrow = Report.NewRow();
                newrow["SNO"] = i++.ToString();
                newrow["employee_num"] = employee_num;
                newrow["branchname"] = branchname;
                newrow["EmpName"] = empname;
                Report.Rows.Add(newrow);
            }
        }
        Session["xportdata"] = Report;
        //Session["xportdata"] = Report;
    }


    protected void ddlemployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Report.Columns.Add("SNO");
            Report.Columns.Add("employee_num");
            Report.Columns.Add("EmpName");
            Report.Columns.Add("branchname");
            Report.Columns.Add("LOP");
            Report.Columns.Add("OTHours");
            Report.Columns.Add("ExtraDays");
            Report.Columns.Add("SALARY ADVANCE");
            Report.Columns.Add("OTHER LOAN");
            Report.Columns.Add("OTHER DEDUCTION");
            //Report.Columns.Add("TDS DEDUCTION");
            Report.Columns.Add("date");
            Session["filename"] = "Total Deduction";
            Session["title"] = " Total Deduction ";
            //bindemployeetype();
            string mainbranch = Session["mainbranch"].ToString();
            if (ddlemployee.SelectedItem.Value == "ALL")
            {
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.employee_type, branchmaster.branchname FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE(branchmapping.mainbranch = @m) and employedetails.status='No'  ORDER BY branchmaster.branchname DESC");
                //cmd.Parameters.Add("@type", ddlemptype.SelectedItem.Value);
            }
            else
            {
                cmd = new SqlCommand("SELECT  employedetails.employee_num, employedetails.fullname, branchmaster.branchname, employedetails.employee_type, employedetails.pfeligible FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') AND (employedetails.employee_type = @type) ORDER BY branchmaster.branchname DESC");
                cmd.Parameters.Add("@type", ddlemployee.SelectedItem.Value);
            }
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, branchmaster.branchname FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN branchmaster ON branchmapping.subbranch = branchmaster.branchid WHERE(branchmapping.mainbranch = @m) and employedetails.status='No' ORDER BY branchmaster.branchname DESC");
            //cmd.Parameters.Add("@branchid", sbranchid);
            cmd.Parameters.Add("@m", mainbranch);
            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
            if (dtroutes.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtroutes.Rows)
                {
                    string employee_num = dr["employee_num"].ToString();
                    string empname = dr["fullname"].ToString();
                    string branchname = dr["branchname"].ToString();
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["employee_num"] = employee_num;
                    newrow["branchname"] = branchname;
                    newrow["EmpName"] = empname;
                    Report.Rows.Add(newrow);
                }
            }
            Session["xportdata"] = Report;
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.Message;
            lblmsg.Text = ex.Message;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DataTable dt = (DataTable)Session["dtImport"];
            string mainbranch = Session["mainbranch"].ToString();
            vdm = new DBManager();
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            if (mainbranch == "42")
            {
                foreach (DataRow dr in dt.Rows)
                {
                    try
                    {
                        string employee_num = dr["employee_num"].ToString();
                        if (employee_num == "0" || employee_num == "")
                        {
                        }
                        else
                        {
                            string frmdate = dr["date"].ToString();
                            //DateTime dtPrevmonth = Convert.ToDateTime(frmdate).AddMonths(-1);
                            DateTime dtfrom = Convert.ToDateTime(frmdate);
                            //string strPrevdate = dtPrevmonth.ToString("dd/MM/yyyy");
                            string strdate = dtfrom.ToString("dd/MM/yyyy");
                            string[] str = strdate.Split('/');
                            //string[] strprev = strPrevdate.Split('/');
                            string bid = "";
                            //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                            cmd = new SqlCommand("SELECT employedetails.empid, employedetails.branchid, branchmaster.fromdate, branchmaster.todate FROM employedetails INNER JOIN  branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (employedetails.employee_num = @employee_num)");
                            cmd.Parameters.Add("@employee_num", employee_num);
                            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
                            if (dtroutes.Rows.Count > 0)
                            {
                                int empid = 0;
                                int.TryParse(dtroutes.Rows[0]["empid"].ToString(), out empid);
                                int month = 0;
                                string year = str[2];
                                //int yr = 0;
                                int.TryParse(str[1].ToString(), out month);
                                double daysinmonth = 0;
                                string from = dtroutes.Rows[0]["fromdate"].ToString();
                                string to = dtroutes.Rows[0]["todate"].ToString();
                                int mnth = month;
                                int newmonth = month;
                                //month = month - 1;
                                int prevyear = 0;
                                int presyear = 0;
                                int.TryParse(str[2].ToString(), out prevyear);
                                //if (month == 0)
                                //{
                                //    month = 12;
                                //    prevyear = prevyear - 1;
                                //}
                                presyear = prevyear;
                                if (from == "1" || to == "1")
                                {
                                    //month = month + 1;
                                    if (month == 12)
                                    {
                                        newmonth = 1;
                                        presyear = prevyear + 1;
                                    }
                                    else
                                    {
                                        if (month ==1)
                                        {
                                            month = 1;
                                        }
                                        newmonth = month + 1;
                                        if (month == 12)
                                        {
                                            newmonth = 1;
                                            presyear = prevyear + 1;
                                        }
                                    }

                                }
                                string strfromdate = month + "/" + from + "/" + prevyear;
                                string strtodate = newmonth + "/" + to + "/" + presyear;
                                DateTime dtfromdate = Convert.ToDateTime(strfromdate);
                                DateTime dttodate = Convert.ToDateTime(strtodate);
                                TimeSpan days;
                                days = dttodate - dtfromdate;
                                daysinmonth = Convert.ToInt32(days.TotalDays);
                                daysinmonth = Math.Abs(daysinmonth);
                                double clorwo = 0;
                                double numberofworkingdays = 0;
                                numberofworkingdays = daysinmonth - clorwo;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dr["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double PayableDays = 0;
                                PayableDays = paydays + clorwo;
                                double othours = 0;
                                double.TryParse(dr["OTHours"].ToString(), out othours);
                                double otdays = 0;
                                otdays = othours / 8;
                                otdays = Math.Round(otdays, 2);
                                string ExtraDays = dr["ExtraDays"].ToString();

                                if (ExtraDays == "")
                                {
                                    ExtraDays = "0";
                                }
                                else
                                {
                                    ExtraDays = dr["ExtraDays"].ToString();
                                }
                                string salaryadvance = dr["SALARY ADVANCE"].ToString();
                                double saladv = 0;
                                double.TryParse(dr["SALARY ADVANCE"].ToString(), out saladv);
                                string otherdeduction = dr["OTHER DEDUCTION"].ToString();
                                double deduction = 0;
                                double.TryParse(dr["OTHER DEDUCTION"].ToString(), out deduction);

                                string loanamount = dr["OTHER LOAN"].ToString();
                                double loan = 0;
                                double.TryParse(dr["OTHER LOAN"].ToString(), out loan);
                                string presentmonth = "" ;
                                if (month <= 9)
                                {
                                    presentmonth = "0" + month;
                                }
                                else
                                {
                                    presentmonth = month.ToString();
                                }
                                cmd = new SqlCommand("Select lop, otdays, clorwo, ExtraDays, numberofworkingdays from monthly_attendance where empid=@eid and month=@month and year=@year");
                                cmd.Parameters.Add("@eid", empid);
                                cmd.Parameters.Add("@month", presentmonth);
                                cmd.Parameters.Add("@year", year);
                                DataTable dtattandance = vdm.SelectQuery(cmd).Tables[0];
                                if (dtattandance.Rows.Count > 0)
                                {
                                    string lossofpay = dtattandance.Rows[0]["lop"].ToString();
                                    if (lossofpay == "")
                                    {
                                    }
                                    else
                                    {
                                        if (lop == 0)
                                        {
                                            lop = Convert.ToDouble(dtattandance.Rows[0]["lop"].ToString());
                                        }
                                    }
                                    string ot = dtattandance.Rows[0]["otdays"].ToString();
                                    if (ot == "")
                                    {
                                    }
                                    else
                                    {
                                        if (otdays == 0)
                                        {
                                            otdays = Convert.ToDouble(dtattandance.Rows[0]["otdays"].ToString());
                                        }
                                    }
                                    string ed = dtattandance.Rows[0]["ExtraDays"].ToString();
                                    if (ed == "")
                                    {
                                    }
                                    else
                                    {
                                        if (ExtraDays == "0")
                                        {
                                            ExtraDays = dtattandance.Rows[0]["ExtraDays"].ToString();
                                        }
                                    }
                                    
                                    string noofda = dtattandance.Rows[0]["numberofworkingdays"].ToString();
                                    if (noofda != "")
                                    {
                                        numberofworkingdays = Convert.ToDouble(noofda);
                                    }
                                    string nightdays = "0";
                                    cmd = new SqlCommand("update monthly_attendance set extradays=@extradays, numberofworkingdays=@numberofworkingdays,lop=@lop,clorwo=@clorwo,otdays=@otdays,night_days=@night_days where month=@month and year=@year and empid=@empid and employee_num=@employee_num");
                                    cmd.Parameters.Add("@employee_num", employee_num);
                                    cmd.Parameters.Add("@empid", empid);
                                    cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                    cmd.Parameters.Add("@clorwo", clorwo);
                                    cmd.Parameters.Add("@doe", frmdate);
                                    cmd.Parameters.Add("@lop", lop);
                                    cmd.Parameters.Add("@otdays", otdays);
                                    cmd.Parameters.Add("@extradays", ExtraDays);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    cmd.Parameters.Add("@night_days", nightdays);
                                    if (vdm.Update(cmd) == 0)
                                    {
                                        cmd = new SqlCommand("insert into monthly_attendance (empid, employee_num, clorwo, lop, numberofworkingdays, doe, otdays, month, year,night_days,extradays) values (@empid,@employee_num,@clorwo,@lop,@numberofworkingdays,@doe, @otdays, @month, @year,@night_days,@extradays)");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@clorwo", clorwo);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@lop", lop);
                                        cmd.Parameters.Add("@otdays", otdays);
                                        cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                        cmd.Parameters.Add("@month", presentmonth);
                                        cmd.Parameters.Add("@year", year);
                                        cmd.Parameters.Add("@night_days", nightdays);
                                        cmd.Parameters.Add("@extradays", ExtraDays);
                                        vdm.insert(cmd);
                                    }
                                }
                                else
                                {
                                    //string ExtraDays = "0";
                                    string nightdays = "0";
                                    cmd = new SqlCommand("update monthly_attendance set extradays=@extradays, numberofworkingdays=@numberofworkingdays,lop=@lop,clorwo=@clorwo,otdays=@otdays,night_days=@night_days where month=@month and year=@year and empid=@empid and employee_num=@employee_num");
                                    cmd.Parameters.Add("@employee_num", employee_num);
                                    cmd.Parameters.Add("@empid", empid);
                                    cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                    cmd.Parameters.Add("@clorwo", clorwo);
                                    cmd.Parameters.Add("@doe", frmdate);
                                    cmd.Parameters.Add("@lop", lop);
                                    cmd.Parameters.Add("@otdays", otdays);
                                    cmd.Parameters.Add("@extradays", ExtraDays);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    cmd.Parameters.Add("@night_days", nightdays);
                                    if (vdm.Update(cmd) == 0)
                                    {
                                        cmd = new SqlCommand("insert into monthly_attendance (empid, employee_num, clorwo, lop, numberofworkingdays, doe, otdays, month, year,night_days,extradays) values (@empid,@employee_num,@clorwo,@lop,@numberofworkingdays,@doe, @otdays, @month, @year,@night_days,@extradays)");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@clorwo", clorwo);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@lop", lop);
                                        cmd.Parameters.Add("@otdays", otdays);
                                        cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                        cmd.Parameters.Add("@month", presentmonth);
                                        cmd.Parameters.Add("@year", year);
                                        cmd.Parameters.Add("@night_days", nightdays);
                                        cmd.Parameters.Add("@extradays", ExtraDays);
                                        vdm.insert(cmd);
                                    }
                                }
                                if (saladv > 0)
                                {
                                    cmd = new SqlCommand("Select amount from salaryadvance where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtsal = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtsal.Rows.Count > 0)
                                    {
                                        if (salaryadvance != "0")
                                        {
                                            cmd = new SqlCommand("update  salaryadvance set amount=@amount, doe=@doe where month=@smonth and year=@syear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", salaryadvance);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@smonth", presentmonth);
                                            cmd.Parameters.Add("@syear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into salaryadvance (empid,employee_num,amount,doe, month, year,status) values (@empid,@employee_num,@amount,@doe,@smonth,@syear,'A')");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@amount", salaryadvance);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@smonth", presentmonth);
                                                cmd.Parameters.Add("@syear", year);
                                                vdm.insert(cmd);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  salaryadvance set amount=@amount, doe=@doe where month=@smonth and year=@syear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@amount", salaryadvance);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@smonth", presentmonth);
                                        cmd.Parameters.Add("@syear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into salaryadvance (empid,employee_num,amount,doe, month, year,status) values (@empid,@employee_num,@amount,@doe,@smonth,@syear,'A')");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", salaryadvance);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@smonth", presentmonth);
                                            cmd.Parameters.Add("@syear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }
                                if (deduction > 0)
                                {
                                    cmd = new SqlCommand("Select otherdeductionamount from otherdeduction where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtsal = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtsal.Rows.Count > 0)
                                    {
                                        cmd = new SqlCommand("update  otherdeduction set otherdeductionamount=@amount, doe=@doe where month=@omonth and year=@oyear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@amount", otherdeduction);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@omonth", presentmonth);
                                        cmd.Parameters.Add("@oyear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into otherdeduction (empid,employee_num,otherdeductionamount,doe, month, year) values (@empid,@employee_num,@amount,@doe,@omonth,@oyear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", otherdeduction);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@omonth", presentmonth);
                                            cmd.Parameters.Add("@oyear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  otherdeduction set otherdeductionamount=@amount, doe=@doe where month=@omonth and year=@oyear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@amount", otherdeduction);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@omonth", presentmonth);
                                        cmd.Parameters.Add("@oyear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into otherdeduction (empid,employee_num,otherdeductionamount,doe, month, year) values (@empid,@employee_num,@amount,@doe,@omonth,@oyear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", otherdeduction);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@omonth", presentmonth);
                                            cmd.Parameters.Add("@oyear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }
                                if (loan > 0)
                                {
                                    cmd = new SqlCommand("Select loanemimonth from loan_request where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtloan.Rows.Count > 0)
                                    {
                                        if (loanamount != "0")
                                        {
                                            cmd = new SqlCommand("update  loan_request set loanemimonth=@loanemimonth,doe=@doe where month=@lmonth and year=@lyear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@loanemimonth", loan);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@lmonth", presentmonth);
                                            cmd.Parameters.Add("@lyear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into loan_request (empid, employee_num, loanemimonth, doe, month, year) values (@empid,@employee_num,@loanemimonth,@doe,@lmonth,@lyear)");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@loanemimonth", loan);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@lmonth", presentmonth);
                                                cmd.Parameters.Add("@lyear", year);
                                                vdm.insert(cmd);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  loan_request set loanemimonth=@loanemimonth,doe=@doe where month=@lmonth and year=@lyear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@loanemimonth", loan);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@lmonth", presentmonth);
                                        cmd.Parameters.Add("@lyear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into loan_request (empid, employee_num, loanemimonth, doe, month, year) values (@empid,@employee_num,@loanemimonth,@doe,@lmonth,@lyear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@loanemimonth", loan);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@lmonth", presentmonth);
                                            cmd.Parameters.Add("@lyear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = ex.Message;
                        lblmsg.Text = ex.Message;
                    }
                }
            }
            else
            {
                foreach (DataRow dr in dt.Rows)
                {
                    try
                    {
                        string employee_num = dr["employee_num"].ToString();
                        if (employee_num == "0" || employee_num == "")
                        {
                        }
                        else
                        {
                           //// ------ Other dates calculation-----/////

                            //////string frmdate = dr["date"].ToString();
                            //////DateTime dtPrevmonth = Convert.ToDateTime(frmdate).AddMonths(-1);
                            //////DateTime dtfrom = Convert.ToDateTime(frmdate);
                            //////string strdate = dtfrom.ToString("dd/MM/yyyy");
                            //////string strPrevdate = dtPrevmonth.ToString("dd/MM/yyyy");
                            //////string[] str = strdate.Split('/');
                            //////string[] strprev = strPrevdate.Split('/');
                            //////string bid = "";
                            //////cmd = new SqlCommand("SELECT employedetails.empid,branchmaster.fromdate, branchmaster.todate FROM employedetails INNER JOIN  branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (employedetails.employee_num = @employee_num)");
                            //////cmd.Parameters.Add("@employee_num", employee_num);
                            //////DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
                            //////if (dtroutes.Rows.Count > 0)
                            //////{
                            //////    int empid = 0;
                            //////    int.TryParse(dtroutes.Rows[0]["empid"].ToString(), out empid);
                            //////    int month = 0;
                            //////    string year = str[2];
                            //////    //int yr = 0;
                            //////    int.TryParse(str[1].ToString(), out month);
                            //////    double daysinmonth = 0;
                            //////    string from = dtroutes.Rows[0]["fromdate"].ToString();
                            //////    string to = dtroutes.Rows[0]["todate"].ToString();
                            //////    int mnth = month;
                            //////    int newmonth = month;
                            //////    month = month - 1;
                            //////    int prevyear = 0;
                            //////    int presyear = 0;
                            //////    int.TryParse(str[2].ToString(), out prevyear);
                            //////    if (month == 0)
                            //////    {
                            //////        month = 12;
                            //////    }
                            //////    if (from == "1" || to == "1")
                            //////    {
                            //////        month = month + 1;

                            //////        if (month == 12)
                            //////        {
                            //////            newmonth = 1;
                            //////            presyear = prevyear + 1;
                            //////        }
                            //////        else
                            //////        {
                            //////            if (month == 1)
                            //////            {
                            //////                month = 1;
                            //////            }
                            //////            newmonth = month + 1;
                            //////            if (month == 12)
                            //////            {
                            //////                newmonth = 1;
                            //////                presyear = prevyear + 1;
                            //////            }
                            //////        }
                            //////    }
                            //////    string strfromdate = month + "/" + from + "/" + strprev[2];
                            //////    string strtodate = newmonth + "/" + to + "/" + str[2];
                            //////    DateTime dtfromdate = Convert.ToDateTime(strfromdate);
                            //////    DateTime dttodate = Convert.ToDateTime(strtodate);
                            //////    TimeSpan days;
                            //////    days = dttodate - dtfromdate;
                            //////    daysinmonth = Convert.ToInt32(days.TotalDays);
                            //////    daysinmonth = Math.Abs(daysinmonth);
                            //////    double clorwo = 0;
                            //////    string cl = dr["CL HOLIDAY AND OFF"].ToString();
                            //////    double nightdays = 0;
                            //////    double.TryParse(dr["NIGHT ALLOWENCE Days"].ToString(), out nightdays);
                            //////    if (cl == "")
                            //////    {
                            //////        clorwo = 0;
                            //////    }
                            //////    else
                            //////    {
                            //////        double.TryParse(dr["CL HOLIDAY AND OFF"].ToString(), out clorwo);
                            //////    }
                            //////    double numberofworkingdays = 0;
                            //////    numberofworkingdays = daysinmonth - clorwo;
                            //////    double paydays = 0;
                            //////    double lop = 0;
                            //////    double.TryParse(dr["lop"].ToString(), out lop);
                            //////    paydays = numberofworkingdays - lop;
                            //////    double PayableDays = 0;
                            //////    PayableDays = paydays + clorwo;
                            //////    double othours = 0;
                            //////    double.TryParse(dr["OTHours"].ToString(), out othours);
                            //////    double otdays = 0;
                            //////    otdays = othours / 8;
                            //////    otdays = Math.Round(otdays, 2);
                            //////    string ExtraDays = dr["ExtraDays"].ToString();

                            //////    if (ExtraDays == "")
                            //////    {
                            //////        ExtraDays = "0";
                            //////    }
                            //////    else
                            //////    {
                            //////        ExtraDays = dr["ExtraDays"].ToString();
                            //////    }
                            //////    string salaryadvance = dr["SALARY ADVANCE"].ToString();
                            //////    double saladv = 0;
                            //////    double.TryParse(dr["SALARY ADVANCE"].ToString(), out saladv);
                            //////    string mobileamount = dr["MOBILE DEDUCTION"].ToString();
                            //////    double mobile = 0;
                            //////    double.TryParse(dr["MOBILE DEDUCTION"].ToString(), out mobile);
                            //////    string otherdeduction = dr["OTHER DEDUCTION"].ToString();
                            //////    double deduction = 0;
                            //////    double.TryParse(dr["OTHER DEDUCTION"].ToString(), out deduction);
                            //////    string canteenamount = dr["CANTEEN DEDUCTION"].ToString();
                            //////    double canteen = 0;
                            //////    double.TryParse(dr["CANTEEN DEDUCTION"].ToString(), out canteen);
                            //////    string loanamount = dr["OTHER LOAN"].ToString();
                            //////    double loan = 0;
                            //////    double.TryParse(dr["OTHER LOAN"].ToString(), out loan);
                            //////    string presentmonth = "";
                            //////    if (newmonth <= 9)
                            //////    {
                            //////        if (from == "1" || to == "1")
                            //////        {

                            //////            presentmonth = "0" + month;
                            //////        }
                            //////        else
                            //////        {
                            //////            presentmonth = "0" + newmonth;

                            //////        }
                            //////    }
                            //////    else
                            //////    {
                            //////        presentmonth = newmonth.ToString();
                            //////    }
                            

                            /////////--------Begin  one to one date salary statement calculation------------


                            string frmdate = dr["date"].ToString();
                            DateTime dtPrevmonth = Convert.ToDateTime(frmdate).AddMonths(-1);
                            DateTime dtfrom = Convert.ToDateTime(frmdate);
                            string strdate = dtfrom.ToString("dd/MM/yyyy");
                            string strPrevdate = dtPrevmonth.ToString("dd/MM/yyyy");
                            string[] str = strdate.Split('/');
                            string[] strprev = strPrevdate.Split('/');
                            string bid = "";
                            cmd = new SqlCommand("SELECT employedetails.empid,branchmaster.fromdate, branchmaster.todate FROM employedetails INNER JOIN  branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (employedetails.employee_num = @employee_num)");
                            cmd.Parameters.Add("@employee_num", employee_num);
                            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
                            if (dtroutes.Rows.Count > 0)
                            {
                                int empid = 0;
                                int.TryParse(dtroutes.Rows[0]["empid"].ToString(), out empid);
                                int presentmonth = 0;
                                string year = str[2];
                                //int yr = 0;
                                int.TryParse(str[1].ToString(), out presentmonth);
                                double daysinmonth = 0;
                                int presyear = 0;
                                int.TryParse(str[2].ToString(), out presyear);
                                int days = DateTime.DaysInMonth(presyear, presentmonth);
                                daysinmonth = Math.Abs(days);
                                double clorwo = 0;
                                string cl = dr["CL HOLIDAY AND OFF"].ToString();
                                double nightdays = 0;
                                double.TryParse(dr["NIGHT ALLOWENCE Days"].ToString(), out nightdays);
                                if (cl == "")
                                {
                                    clorwo = 0;
                                }
                                else
                                {
                                    double.TryParse(dr["CL HOLIDAY AND OFF"].ToString(), out clorwo);
                                }
                                double numberofworkingdays = 0;
                                numberofworkingdays = daysinmonth - clorwo;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dr["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double PayableDays = 0;
                                PayableDays = paydays + clorwo;
                                double othours = 0;
                                double.TryParse(dr["OTHours"].ToString(), out othours);
                                double otdays = 0;
                                otdays = othours / 8;
                                otdays = Math.Round(otdays, 2);
                                string ExtraDays = dr["ExtraDays"].ToString();

                                if (ExtraDays == "")
                                {
                                    ExtraDays = "0";
                                }
                                else
                                {
                                    ExtraDays = dr["ExtraDays"].ToString();
                                }
                                string salaryadvance = dr["SALARY ADVANCE"].ToString();
                                double saladv = 0;
                                double.TryParse(dr["SALARY ADVANCE"].ToString(), out saladv);
                                string mobileamount = dr["MOBILE DEDUCTION"].ToString();
                                double mobile = 0;
                                double.TryParse(dr["MOBILE DEDUCTION"].ToString(), out mobile);
                                string otherdeduction = dr["OTHER DEDUCTION"].ToString();
                                double deduction = 0;
                                double.TryParse(dr["OTHER DEDUCTION"].ToString(), out deduction);
                                string canteenamount = dr["CANTEEN DEDUCTION"].ToString();
                                double canteen = 0;
                                double.TryParse(dr["CANTEEN DEDUCTION"].ToString(), out canteen);
                                string loanamount = dr["OTHER LOAN"].ToString();
                                double loan = 0;
                                double.TryParse(dr["OTHER LOAN"].ToString(), out loan);

                                /////////--------End  one to one date salary statement calculation------------

                                cmd = new SqlCommand("Select lop, otdays, clorwo, ExtraDays, numberofworkingdays from monthly_attendance where empid=@eid and month=@month and year=@year");
                                cmd.Parameters.Add("@eid", empid);
                                cmd.Parameters.Add("@month", presentmonth);
                                cmd.Parameters.Add("@year", year);
                                DataTable dtattandance = vdm.SelectQuery(cmd).Tables[0];
                                if (dtattandance.Rows.Count > 0)
                                {
                                    string lossofpay = dtattandance.Rows[0]["lop"].ToString();
                                    if (lossofpay == "")
                                    {
                                    }
                                    else
                                    {
                                        if (lop == 0)
                                        {
                                            lop = Convert.ToDouble(dtattandance.Rows[0]["lop"].ToString());
                                        }
                                    }
                                    string ot = dtattandance.Rows[0]["otdays"].ToString();
                                    if (ot == "")
                                    {
                                    }
                                    else
                                    {
                                        if (otdays == 0)
                                        {
                                            otdays = Convert.ToDouble(dtattandance.Rows[0]["otdays"].ToString());
                                        }
                                    }
                                    string ed = dtattandance.Rows[0]["ExtraDays"].ToString();
                                    if (ed == "")
                                    {
                                    }
                                    else
                                    {
                                        if (ExtraDays == "0")
                                        {
                                            ExtraDays = dtattandance.Rows[0]["ExtraDays"].ToString();
                                        }
                                    }
                                    string clor = dtattandance.Rows[0]["clorwo"].ToString();
                                    if (clor == "")
                                    {
                                    }
                                    else
                                    {
                                        if (clorwo == 0)
                                        {
                                            clorwo = Convert.ToDouble(dtattandance.Rows[0]["clorwo"].ToString());
                                        }
                                    }
                                    string noofda = dtattandance.Rows[0]["numberofworkingdays"].ToString();
                                    if (noofda != "")
                                    {
                                        numberofworkingdays = Convert.ToDouble(noofda);
                                    }
                                    cmd = new SqlCommand("update monthly_attendance set extradays=@extradays, numberofworkingdays=@numberofworkingdays,lop=@lop,clorwo=@clorwo,otdays=@otdays,night_days=@night_days where month=@month and year=@year and empid=@empid and employee_num=@employee_num");
                                    cmd.Parameters.Add("@employee_num", employee_num);
                                    cmd.Parameters.Add("@empid", empid);
                                    cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                    cmd.Parameters.Add("@clorwo", clorwo);
                                    cmd.Parameters.Add("@doe", frmdate);
                                    cmd.Parameters.Add("@lop", lop);
                                    cmd.Parameters.Add("@otdays", otdays);
                                    cmd.Parameters.Add("@extradays", ExtraDays);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    cmd.Parameters.Add("@night_days", nightdays);
                                    if (vdm.Update(cmd) == 0)
                                    {
                                        cmd = new SqlCommand("insert into monthly_attendance (empid, employee_num, clorwo, lop, numberofworkingdays, doe, otdays, month, year,night_days,extradays) values (@empid,@employee_num,@clorwo,@lop,@numberofworkingdays,@doe, @otdays, @month, @year,@night_days,@extradays)");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@clorwo", clorwo);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@lop", lop);
                                        cmd.Parameters.Add("@otdays", otdays);
                                        cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                        cmd.Parameters.Add("@month", presentmonth);
                                        cmd.Parameters.Add("@year", year);
                                        cmd.Parameters.Add("@night_days", nightdays);
                                        cmd.Parameters.Add("@extradays", ExtraDays);
                                        vdm.insert(cmd);
                                    }
                                }
                                else
                                {
                                    cmd = new SqlCommand("update monthly_attendance set extradays=@extradays, numberofworkingdays=@numberofworkingdays,lop=@lop,clorwo=@clorwo,otdays=@otdays,night_days=@night_days where month=@month and year=@year and empid=@empid and employee_num=@employee_num");
                                    cmd.Parameters.Add("@employee_num", employee_num);
                                    cmd.Parameters.Add("@empid", empid);
                                    cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                    cmd.Parameters.Add("@clorwo", clorwo);
                                    cmd.Parameters.Add("@doe", frmdate);
                                    cmd.Parameters.Add("@lop", lop);
                                    cmd.Parameters.Add("@otdays", otdays);
                                    cmd.Parameters.Add("@extradays", ExtraDays);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    cmd.Parameters.Add("@night_days", nightdays);
                                    if (vdm.Update(cmd) == 0)
                                    {
                                        cmd = new SqlCommand("insert into monthly_attendance (empid, employee_num, clorwo, lop, numberofworkingdays, doe, otdays, month, year,night_days,extradays) values (@empid,@employee_num,@clorwo,@lop,@numberofworkingdays,@doe, @otdays, @month, @year,@night_days,@extradays)");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@clorwo", clorwo);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@lop", lop);
                                        cmd.Parameters.Add("@otdays", otdays);
                                        cmd.Parameters.Add("@numberofworkingdays", numberofworkingdays);
                                        cmd.Parameters.Add("@month", presentmonth);
                                        cmd.Parameters.Add("@year", year);
                                        cmd.Parameters.Add("@night_days", nightdays);
                                        cmd.Parameters.Add("@extradays", ExtraDays);
                                        vdm.insert(cmd);
                                    }
                                }
                                if (saladv > 0)
                                {
                                    cmd = new SqlCommand("Select amount from salaryadvance where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtsal = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtsal.Rows.Count > 0)
                                    {
                                        if (salaryadvance != "0")
                                        {
                                            cmd = new SqlCommand("update  salaryadvance set amount=@amount, doe=@doe where month=@smonth and year=@syear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", salaryadvance);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@smonth", presentmonth);
                                            cmd.Parameters.Add("@syear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into salaryadvance (empid,employee_num,amount,doe, month, year) values (@empid,@employee_num,@amount,@doe,@smonth,@syear)");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@amount", salaryadvance);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@smonth", presentmonth);
                                                cmd.Parameters.Add("@syear", year);
                                                vdm.insert(cmd);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  salaryadvance set amount=@amount, doe=@doe where month=@smonth and year=@syear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@amount", salaryadvance);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@smonth", presentmonth);
                                        cmd.Parameters.Add("@syear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into salaryadvance (empid,employee_num,amount,doe, month, year) values (@empid,@employee_num,@amount,@doe,@smonth,@syear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", salaryadvance);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@smonth", presentmonth);
                                            cmd.Parameters.Add("@syear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }

                                if (canteen > 0)
                                {
                                    cmd = new SqlCommand("Select amount from canteendeductions where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtcanteen.Rows.Count > 0)
                                    {
                                        if (canteenamount != "0")
                                        {
                                            cmd = new SqlCommand("update canteendeductions set amount=@amount,date=@doe where month=@cmonth and year=@cyear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", canteen);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@cmonth", presentmonth);
                                            cmd.Parameters.Add("@cyear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into canteendeductions (empid,employee_num,amount,date, month, year) values (@empid,@employee_num,@amount,@doe,@cmonth,@cyear)");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@amount", canteen);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@cmonth", presentmonth);
                                                cmd.Parameters.Add("@cyear", year);
                                                vdm.insert(cmd);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update canteendeductions set amount=@amount,date=@doe where month=@cmonth and year=@cyear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@amount", canteen);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@cmonth", presentmonth);
                                        cmd.Parameters.Add("@cyear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into canteendeductions (empid,employee_num,amount,date, month, year) values (@empid,@employee_num,@amount,@doe,@cmonth,@cyear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", canteen);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@cmonth", presentmonth);
                                            cmd.Parameters.Add("@cyear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }

                                if (mobile > 0)
                                {
                                    cmd = new SqlCommand("Select deductionamount from mobile_deduction where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtmobile.Rows.Count > 0)
                                    {
                                        if (mobileamount != "0")
                                        {
                                            cmd = new SqlCommand("update  mobile_deduction set deductionamount=@deductionamount,date=@doe where month=@mmonth and year=@myear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@deductionamount", mobile);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@mmonth", presentmonth);
                                            cmd.Parameters.Add("@myear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into mobile_deduction (empid, employee_num, deductionamount, doe, month, year) values (@empid,@employee_num,@deductionamount,@doe, @mmonth, @myear)");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@deductionamount", mobile);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@mmonth", presentmonth);
                                                cmd.Parameters.Add("@myear", year);
                                                vdm.insert(cmd);

                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  mobile_deduction set deductionamount=@deductionamount,date=@doe where month=@mmonth and year=@myear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@deductionamount", mobile);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@mmonth", presentmonth);
                                        cmd.Parameters.Add("@myear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into mobile_deduction (empid, employee_num, deductionamount, doe, month, year) values (@empid,@employee_num,@deductionamount,@doe, @mmonth, @myear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@deductionamount", mobile);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@mmonth", presentmonth);
                                            cmd.Parameters.Add("@myear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }
                                if (deduction > 0)
                                {
                                    cmd = new SqlCommand("Select otherdeductionamount from otherdeduction where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtsal = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtsal.Rows.Count > 0)
                                    {
                                        if (otherdeduction != "0")
                                        {
                                            cmd = new SqlCommand("update  otherdeduction set otherdeductionamount=@amount, doe=@doe where month=@omonth and year=@oyear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", otherdeduction);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@omonth", presentmonth);
                                            cmd.Parameters.Add("@oyear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into otherdeduction (empid,employee_num,otherdeductionamount,doe, month, year) values (@empid,@employee_num,@amount,@doe,@omonth,@oyear)");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@amount", otherdeduction);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@omonth", presentmonth);
                                                cmd.Parameters.Add("@oyear", year);
                                                vdm.insert(cmd);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  otherdeduction set otherdeductionamount=@amount, doe=@doe where month=@omonth and year=@oyear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@amount", otherdeduction);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@omonth", presentmonth);
                                        cmd.Parameters.Add("@oyear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into otherdeduction (empid,employee_num,otherdeductionamount,doe, month, year) values (@empid,@employee_num,@amount,@doe,@omonth,@oyear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@amount", otherdeduction);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@omonth", presentmonth);
                                            cmd.Parameters.Add("@oyear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }
                                if (loan > 0)
                                {
                                    cmd = new SqlCommand("Select loanemimonth from loan_request where empid=@eid and month=@month and year=@year");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@month", presentmonth);
                                    cmd.Parameters.Add("@year", year);
                                    DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtloan.Rows.Count > 0)
                                    {
                                        if (loanamount != "0")
                                        {
                                            cmd = new SqlCommand("update  loan_request set loanemimonth=@loanemimonth,doe=@doe where month=@lmonth and year=@lyear and empid=@empid and employee_num=@employee_num");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@loanemimonth", loan);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@lmonth", presentmonth);
                                            cmd.Parameters.Add("@lyear", year);
                                            if (vdm.Update(cmd) == 0)
                                            {
                                                cmd = new SqlCommand("insert into loan_request (empid, employee_num, loanemimonth, doe, month, year) values (@empid,@employee_num,@loanemimonth,@doe,@lmonth,@lyear)");
                                                cmd.Parameters.Add("@employee_num", employee_num);
                                                cmd.Parameters.Add("@empid", empid);
                                                cmd.Parameters.Add("@loanemimonth", loan);
                                                cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                                cmd.Parameters.Add("@lmonth", presentmonth);
                                                cmd.Parameters.Add("@lyear", year);
                                                vdm.insert(cmd);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        cmd = new SqlCommand("update  loan_request set loanemimonth=@loanemimonth,doe=@doe where month=@lmonth and year=@lyear and empid=@empid and employee_num=@employee_num");
                                        cmd.Parameters.Add("@employee_num", employee_num);
                                        cmd.Parameters.Add("@empid", empid);
                                        cmd.Parameters.Add("@loanemimonth", loan);
                                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                        cmd.Parameters.Add("@lmonth", presentmonth);
                                        cmd.Parameters.Add("@lyear", year);
                                        if (vdm.Update(cmd) == 0)
                                        {
                                            cmd = new SqlCommand("insert into loan_request (empid, employee_num, loanemimonth, doe, month, year) values (@empid,@employee_num,@loanemimonth,@doe,@lmonth,@lyear)");
                                            cmd.Parameters.Add("@employee_num", employee_num);
                                            cmd.Parameters.Add("@empid", empid);
                                            cmd.Parameters.Add("@loanemimonth", loan);
                                            cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                                            cmd.Parameters.Add("@lmonth", presentmonth);
                                            cmd.Parameters.Add("@lyear", year);
                                            vdm.insert(cmd);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = ex.Message;
                        lblmsg.Text = ex.Message;
                    }
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
