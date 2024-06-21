using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class Rpt_EmployeeAttendance : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    ///string BranchID = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["userid"] == null)
        {
            Response.Redirect("Login.aspx");
        }
        else
        {
            userid = Session["userid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {                   
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    bindemployeetype();
                    bindEmployee();
                }
            }
        }
    }


    private void bindbranchs()
    {
        try
        {
            DBManager SalesDB = new DBManager();
            //branchwise
            //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
            string mainbranch = Session["mainbranch"].ToString();
            //branch mapping
            cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname,branchmaster.fromdate,branchmaster.todate, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
            cmd.Parameters.Add("@m", mainbranch);
            DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
            ddl_Branch.DataSource = dttrips;
            ddl_Branch.DataTextField = "branchname";
            ddl_Branch.DataValueField = "branchid";
            ddl_Branch.DataBind();
            ddl_Branch.ClearSelection();
            ddl_Branch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
            ddl_Branch.SelectedValue = "0";
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    private void bindemployeetype()
    {
        try
        {
            DBManager SalesDB = new DBManager();
            cmd = new SqlCommand("SELECT employee_type FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch where (employee_type<>'') AND (branchmapping.mainbranch = @bid) GROUP BY employee_type");
            cmd.Parameters.Add("@bid", Session["mainbranch"].ToString());
            DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
            ddl_Emptype.DataSource = dttrips;
            ddl_Emptype.DataTextField = "employee_type";
            ddl_Emptype.DataValueField = "employee_type";
            ddl_Emptype.DataBind();
            ddl_Emptype.ClearSelection();
            ddl_Emptype.Items.Insert(0, new ListItem { Value = "0", Text = "All", Selected = true });
            ddl_Emptype.SelectedValue = "0";
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    private void bindEmployee()
    {
        try
        {
            ddl_EmpId.Items.Clear();
            DBManager SalesDB = new DBManager();
            cmd = new SqlCommand("SELECT fullname, empid, branchid, employee_type FROM employedetails WHERE  (status='No') AND (employee_type <> '') AND (employee_type = @emptype) AND (branchid = @bid) Order by empid ");
            cmd.Parameters.Add("@bid", ddl_Branch.SelectedItem.Value);
            cmd.Parameters.Add("@emptype", ddl_Emptype.SelectedItem.Value);
            DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
            ddl_EmpId.DataSource = dttrips;
            ddl_EmpId.DataTextField = "fullname";
            ddl_EmpId.DataValueField = "empid";
            ddl_EmpId.DataBind();
            ddl_EmpId.ClearSelection();
            ddl_EmpId.Items.Insert(0, new ListItem { Value = "0", Text = "All", Selected = true });
            ddl_EmpId.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
    }
    private DateTime GetLowDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        DT = dt;
        Hour = -dt.Hour;
        Min = -dt.Minute;
        Sec = -dt.Second;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    private DateTime GetHighDate(DateTime dt)
    {
        double Hour, Min, Sec;
        DateTime DT = DateTime.Now;
        Hour = 23 - dt.Hour;
        Min = 59 - dt.Minute;
        Sec = 59 - dt.Second;
        DT = dt;
        DT = DT.AddHours(Hour);
        DT = DT.AddMinutes(Min);
        DT = DT.AddSeconds(Sec);
        return DT;
    }
    DataTable Report = new DataTable();

    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            int flag = 0;
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string[] datestrig = dtp_FromDate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            datestrig = dtp_Todate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }

            TimeSpan dateSpan = todate.Subtract(fromdate);
            int NoOfdays = dateSpan.Days;
            NoOfdays = NoOfdays + 2;
            lblFromDate.Text = fromdate.ToString("dd/MMM/yyyy");
            lbltodate.Text = todate.ToString("dd/MMM/yyyy");
            lblHeading.Text = ddl_Branch.SelectedItem.Text + "  " + ddl_Emptype.SelectedItem.Text + " " + ddl_EmpId.SelectedItem.Text;
            if (ddl_Emptype.SelectedItem.Value == "0")
            {
                cmd = new SqlCommand("SELECT t3.empid, t3.fullname, t3.employee_num, t3.SDate, t3.FD, t4.EDate, t4.D2 FROM  (SELECT t1.empid, t1.fullname, t1.employee_num, t2.SDate, t2.FD FROM (SELECT  empid, fullname, employee_num FROM  employedetails WHERE   (status = 'NO') AND (branchid = @BranchId) AND (empid=@empid) ) AS t1 LEFT OUTER JOIN (SELECT MIN(LogDate) AS SDate, CONVERT(varchar, LogDate, 103) AS FD, EmpId AS Eid  FROM  AttendanceLogs WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t2 ON t1.empid = t2.Eid) AS t3 LEFT OUTER JOIN (SELECT MAX(LogDate) AS EDate, CONVERT(varchar, LogDate, 103) AS D2, EmpId AS Eid1 FROM AttendanceLogs AS AttendanceLogs_1 WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t4 ON t3.empid = t4.Eid1 ORDER BY t3.empid, t3.FD");
                cmd.Parameters.Add("@BranchId", ddl_Branch.SelectedItem.Value);
                cmd.Parameters.Add("@employee_type", ddl_Emptype.SelectedItem.Value);
                cmd.Parameters.Add("@empid", ddl_EmpId.SelectedItem.Value);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            else
            {
                //cmd = new SqlCommand("SELECT Q1.empid, Q1.fullname, Q1.employee_num, Q2.sno, Q2.branchid, Q2.empid AS Expr1, ISNULL(Q2.status, 'A') AS status, Q2.doe, ISNULL(Q2.attendance_date, Q2.attendance_date) AS attendance_date FROM  (SELECT empid, fullname, employee_num FROM employedetails  WHERE  (branchid = @branchid) AND (employee_type = @employee_type) AND (status = 'No')) AS Q1 LEFT OUTER JOIN(SELECT  sno, branchid, empid, status, doe, attendance_date, remarks FROM   dailyattandancedetails  WHERE  (attendance_date BETWEEN @d1 AND @d2)) AS Q2 ON Q1.empid = Q2.empid ORDER BY Q1.empid");
                cmd = new SqlCommand("SELECT t3.empid, t3.fullname, t3.employee_num, t3.SDate, t3.FD, t4.EDate, t4.D2 FROM  (SELECT t1.empid, t1.fullname, t1.employee_num, t2.SDate, t2.FD FROM (SELECT  empid, fullname, employee_num FROM  employedetails WHERE   (status = 'NO') AND (employee_type = @employee_type) AND (branchid = @BranchId) AND (empid=@empid) ) AS t1 LEFT OUTER JOIN (SELECT MIN(LogDate) AS SDate, CONVERT(varchar, LogDate, 103) AS FD, EmpId AS Eid  FROM  AttendanceLogs WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t2 ON t1.empid = t2.Eid) AS t3 LEFT OUTER JOIN (SELECT MAX(LogDate) AS EDate, CONVERT(varchar, LogDate, 103) AS D2, EmpId AS Eid1 FROM AttendanceLogs AS AttendanceLogs_1 WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t4 ON t3.empid = t4.Eid1 AND t3.FD=t4.D2 ORDER BY t3.empid, t3.FD");
                cmd.Parameters.Add("@BranchId", ddl_Branch.SelectedItem.Value);
                cmd.Parameters.Add("@employee_type", ddl_Emptype.SelectedItem.Value);
                cmd.Parameters.Add("@empid", ddl_EmpId.SelectedItem.Value);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }


            DataTable dtPuff = vdm.SelectQuery(cmd).Tables[0];
            DataTable sum = new DataTable();
            sum = dtPuff.Copy();
            int count = 0;

            Report = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("Attendance Date");
            Report.Columns.Add("In&OutTime");

            string[] datarr = new string[NoOfdays];

            DateTime dtFrm = new DateTime();
            for (int j = 1; j < NoOfdays; j++)
            {
                if (j == 1)
                {
                    dtFrm = fromdate;
                    datarr[j] = dtFrm.ToString("dd/MM/yyyy");

                }
                else
                {
                    dtFrm = dtFrm.AddDays(1);
                    datarr[j] = dtFrm.ToString("dd/MM/yyyy");

                }
                count++;
            }

            DataView view = new DataView(sum);
            DataTable DTEmpname = view.ToTable(true, "FullName");
            DataRow newrow = null;
            int i = 1;
            string prvdate = "";
            DateTime PREVDATE = DateTime.Now;
            DateTime dtDoe = System.DateTime.Now;
            DateTime dtDoe1 = System.DateTime.Now;

            foreach (DataRow drEmpname in sum.Rows)
            {
                flag = 1;
                newrow = Report.NewRow();
                newrow["Sno"] = i++.ToString();

                string attendance_date = drEmpname["SDate"].ToString();
                string attendance_Todatedate = drEmpname["EDate"].ToString();
                string adate = drEmpname["FD"].ToString();

                if (datarr[i - 1].ToString().Trim() == adate.ToString().Trim())
                {
                    if (attendance_date != "")
                    {
                        prvdate = attendance_date;
                        dtDoe = Convert.ToDateTime(attendance_date);
                        dtDoe1 = Convert.ToDateTime(attendance_Todatedate);
                        PREVDATE = dtDoe;
                        string strdateTime = dtDoe.ToString("h:mm tt");
                        string strdate = dtDoe.ToString("dd/MMM");
                        string EnddateTime = dtDoe1.ToString("h:mm tt");
                        string Enddate = dtDoe1.ToString("dd/MMM");
                        newrow["Attendance Date"] = adate;
                        newrow["In&OutTime"] = strdateTime + "_" + EnddateTime;
                        Report.Rows.Add(newrow);
                    }
                }
                else
                {
                    string d1 = string.Empty;
                    string d2 = string.Empty;

                    DateTime sdt = new DateTime();
                    DateTime edt = new DateTime();
                    edt = Convert.ToDateTime(attendance_date);
                    d1 = edt.Month + "/" + edt.Day + "/" + edt.Year;
                    edt = Convert.ToDateTime(d1);

                    try
                    {
                        sdt = Convert.ToDateTime(datarr[i - 1].ToString().Trim());
                        d2 = sdt.Day + "/" + sdt.Month + "/" + sdt.Year;
                        sdt = Convert.ToDateTime(d2);
                    }
                    catch (Exception ex)
                    {
                        string d = datarr[i - 1].ToString().Trim();
                        string[] newarr = new string[5];
                        newarr = d.Split('/');
                        d2 = newarr[1] + "/" + newarr[0] + "/" + newarr[2];
                        sdt = Convert.ToDateTime(d2);
                    }



                    TimeSpan rounddate = edt.Subtract(sdt);
                    int NoOfdayss = rounddate.Days;
                    for (int ks = 1; ks <= NoOfdayss; ks++)
                    {
                        if (ks > 1)
                        {
                            newrow = Report.NewRow();
                            newrow["Sno"] = i++.ToString();
                        }
                        newrow["Attendance Date"] = edt.AddDays(-(NoOfdayss - (ks - 1))).ToString("dd/MM/yyyy"); ;
                        newrow["In&OutTime"] = "0" + "_" + "0";
                        Report.Rows.Add(newrow);
                    }


                    if (attendance_date != "")
                    {
                        newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        prvdate = attendance_date;
                        dtDoe = Convert.ToDateTime(attendance_date);
                        dtDoe1 = Convert.ToDateTime(attendance_Todatedate);
                        PREVDATE = dtDoe;
                        string strdateTime = dtDoe.ToString("h:mm tt");
                        string strdate = dtDoe.ToString("dd/MMM");
                        string EnddateTime = dtDoe1.ToString("h:mm tt");
                        string Enddate = dtDoe1.ToString("dd/MMM");
                        newrow["Attendance Date"] = adate;
                        newrow["In&OutTime"] = strdateTime + "_" + EnddateTime;
                        Report.Rows.Add(newrow);
                    }
                }
            }
            //
            if (i >= count)
            {
            }
            else
            {
                if (flag == 0)
                {
                }
                else
                {
                    count = count - (i-1);
                }
                
                for (int ks = 1; ks <= (count); ks++)
                {
                    newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();

                    newrow["Attendance Date"] = datarr[i-1];
                    newrow["In&OutTime"] = "0" + "_" + "0";
                    Report.Rows.Add(newrow);
                }

            }
            //


            //
            if (Report.Rows.Count > 0)
            {
                dg_EmployeeAttendance.DataSource = Report;
                dg_EmployeeAttendance.DataBind();
                Session["adata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                DataTable dt = new DataTable();
                dg_EmployeeAttendance.DataSource = dt;
                dg_EmployeeAttendance.DataBind();
                Session["adata"] = Report;
                hidepanel.Visible = true;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }

    protected void ddl_Branch_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindEmployee();
    }

    protected void ddl_Emptype_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindEmployee();
    }

}