using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Net;
using System.Globalization;
using System.Threading;

public partial class mnthempattendance : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    ///string BranchID = "";
    DBManager vdm;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["userid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            userid = Session["userid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    DateTime dtfrom = DateTime.Now;
                    DateTime dtyear = DateTime.Now.AddYears(-1);
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    dtp_InoutTimeFrmDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    dtp_InoutTimeToDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    lblAddress1.Text = Session["Address"].ToString();
                    lblTitle1.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    bindemployeetype();
                }
            }
        }
    }
    private void bindbranchs()
    {

        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname,branchmaster.fromdate,branchmaster.todate, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranch.DataSource = dttrips;
        ddlbranch.DataTextField = "branchname";
        ddlbranch.DataValueField = "branchid";
        ddlbranch.DataBind();
        ddlbranch.ClearSelection();
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranch.SelectedValue = "0";
        //
        ddl_Branch_InOutTime.DataSource = dttrips;
        ddl_Branch_InOutTime.DataTextField = "branchname";
        ddl_Branch_InOutTime.DataValueField = "branchid";
        ddl_Branch_InOutTime.DataBind();
        ddl_Branch_InOutTime.ClearSelection();
        ddl_Branch_InOutTime.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddl_Branch_InOutTime.SelectedValue = "0";

    }
    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch where (employee_type<>'') AND (branchmapping.mainbranch = @bid) GROUP BY employee_type");
        cmd.Parameters.Add("@bid", Session["mainbranch"].ToString());
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "All", Selected = true });
        ddlemptype.SelectedValue = "0";
        //
        ddl_Emptype_InOutTime.DataSource = dttrips;
        ddl_Emptype_InOutTime.DataTextField = "employee_type";
        ddl_Emptype_InOutTime.DataValueField = "employee_type";
        ddl_Emptype_InOutTime.DataBind();
        ddl_Emptype_InOutTime.ClearSelection();
        ddl_Emptype_InOutTime.Items.Insert(0, new ListItem { Value = "0", Text = "All", Selected = true });
        ddl_Emptype_InOutTime.SelectedValue = "0";
    }
    //protected void ddlCustomers_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname,branchmaster.fromdate,branchmaster.todate, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
    //    cmd.Parameters.AddWithValue("@branchid", ddlbranch.SelectedItem.Value);
    //    cmd.CommandType = CommandType.Text;
    //    //cmd.CommandText = cmd;
    //    try
    //    {
    //        SqlDataReader sdr = cmd.ExecuteReader();
    //        while (sdr.Read())
    //        {
    //            dtp_Todate.Text = sdr["fromdate"].ToString();
    //            dtp_Todate.Text = sdr["todate"].ToString();
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }

    //}       


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
            lblbname.Text = ddlbranch.SelectedItem.Text + "  " + ddlemptype.SelectedItem.Text;
            DataTable dtbetweendates = new DataTable();
            //lblbname.Text = ddlemptype.SelectedItem.Text;
            dtbetweendates.Columns.Add("attendance_date").DataType = typeof(DateTime);
            for (var dt = fromdate; dt <= todate; dt = dt.AddDays(1))
            {
                DataRow newrow = dtbetweendates.NewRow();
                newrow["attendance_date"] = dt;
                dtbetweendates.Rows.Add(newrow);

            }
           
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employedetails.fullname, dailyattandancedetails.status, dailyattandancedetails.attendance_date, dailyattandancedetails.doe FROM employedetails INNER JOIN dailyattandancedetails ON employedetails.empid = dailyattandancedetails.empid WHERE (dailyattandancedetails.attendance_date BETWEEN @d1 AND @d2) AND (dailyattandancedetails.branchid = @branchid)");
            if (ddlemptype.SelectedItem.Value == "0")
            {
                cmd = new SqlCommand("SELECT Q1.empid, Q1.fullname, Q1.employee_num, Q2.sno, Q2.branchid, Q2.empid AS Expr1, ISNULL(Q2.status, 'A') AS status, Q2.doe, ISNULL(Q2.attendance_date, Q2.attendance_date) AS attendance_date FROM  (SELECT empid, fullname, employee_num FROM employedetails  WHERE  (branchid = @branchid)  AND (status = 'No')) AS Q1 LEFT OUTER JOIN(SELECT  sno, branchid, empid, status, doe, attendance_date, remarks FROM   dailyattandancedetails  WHERE  (attendance_date BETWEEN @d1 AND @d2)) AS Q2 ON Q1.empid = Q2.empid ORDER BY Q1.empid");
                cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            else
            {
                cmd = new SqlCommand("SELECT Q1.empid, Q1.fullname, Q1.employee_num, Q2.sno, Q2.branchid, Q2.empid AS Expr1, ISNULL(Q2.status, 'A') AS status, Q2.doe, ISNULL(Q2.attendance_date, Q2.attendance_date) AS attendance_date FROM  (SELECT empid, fullname, employee_num FROM employedetails  WHERE  (branchid = @branchid) AND (employee_type = @employee_type) AND (status = 'No')) AS Q1 LEFT OUTER JOIN(SELECT  sno, branchid, empid, status, doe, attendance_date, remarks FROM   dailyattandancedetails  WHERE  (attendance_date BETWEEN @d1 AND @d2)) AS Q2 ON Q1.empid = Q2.empid ORDER BY Q1.empid");
                cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@employee_type", ddlemptype.SelectedItem.Text);
            }
            DataTable dtPuff = vdm.SelectQuery(cmd).Tables[0];
            DataTable sum = new DataTable();
            sum = dtPuff.Copy();
            cmd = new SqlCommand("SELECT  la.leaveapplicationid, la.employee_no, la.remarks, la.leave_description, la.request_to, la.request_date, la.leave_from_dt, la.leave_to_dt, la.leave_satus, la.employee_no AS Expr1, la.aproved_by,la.operated_by, la.leave_type_id, la.mobile_number, la.leave_days, et.fullname AS approvedby, et.branchid FROM  leave_application AS la INNER JOIN employedetails AS et ON et.empid = la.request_to WHERE (et.status = 'No') AND (la.request_date BETWEEN @d1 AND @d2) AND (et.branchid = @branchid) ORDER BY la.leave_from_dt");
            cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable dtleave = vdm.SelectQuery(cmd).Tables[0];

            Report = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("empid");
            Report.Columns.Add("fullname");
            int count = 0;
            DateTime dtFrm = new DateTime();
            for (int j = 1; j < NoOfdays; j++)
            {
                if (j == 1)
                {
                    dtFrm = fromdate;
                }
                else
                {
                    dtFrm = dtFrm.AddDays(1);
                }
                string strdate = dtFrm.ToString("dd/MMM");
                Report.Columns.Add(strdate);
                count++;
            }
            Report.Columns.Add("Total", typeof(Double)).SetOrdinal(count + 3);
            DataView view = new DataView(sum);
            DataTable DriverData = view.ToTable(true, "fullname");
            int i = 1;
            string prvdate = "";
            DateTime PREVDATE = DateTime.Now;
            foreach (DataRow branch in DriverData.Rows)
            {
                DataRow newrow = Report.NewRow();
                newrow["Sno"] = i++.ToString();
                newrow["fullname"] = branch["fullname"].ToString();
                int total = 0;
                foreach (DataRow drDriver in sum.Rows)
                {

                    if (branch["fullname"].ToString() == drDriver["fullname"].ToString())
                    {
                        string empno = drDriver["empid"].ToString();
                        string fullname = drDriver["fullname"].ToString();
                        string attendance_date = drDriver["attendance_date"].ToString();
                        string status = drDriver["status"].ToString();
                        if (attendance_date != "")
                        {
                            prvdate = attendance_date;
                            DateTime dtDoe = Convert.ToDateTime(attendance_date);
                            PREVDATE = dtDoe;
                            string strdateTime = dtDoe.ToString("HH");
                            string strdate = dtDoe.ToString("dd/MMM");
                            if (status == "P")
                            {
                                newrow[strdate] = "P";
                                total++;
                            }
                        }
                        else
                        {
                            //DateTime dtDoe = Convert.ToDateTime(prvdate);
                            //DateTime dtPRVDoe = dtDoe.AddDays(1);
                            //string strdateTime = dtPRVDoe.ToString("HH");
                            //string strdate = dtPRVDoe.ToString("dd/MMM");
                            //cmd = new SqlCommand("SELECT leave_satus, leave_from_dt, leave_days, leave_to_dt FROM leave_application WHERE @ldte between leave_from_dt and leave_to_dt AND employee_no = @empid AND (leave_satus='A')");
                            //cmd.Parameters.Add("@empid", empno);
                            //cmd.Parameters.Add("@ldte", dtPRVDoe);
                            //DataTable dtleaves = vdm.SelectQuery(cmd).Tables[0];
                            //if (dtleaves.Rows.Count > 0)
                            //{
                            //    newrow[strdate] = "L";
                            //}
                        }
                        string empid = drDriver["empid"].ToString();
                        newrow["empid"] = drDriver["empid"].ToString();
                    }
                    else
                    {

                    }
                }
                newrow["Total"] = total;
                Report.Rows.Add(newrow);
            }
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            if (Report.Rows.Count > 0)
            {
                for (int k = 0; k < Report.Rows.Count; k++)
                {
                    int od = 0;
                    for (int j = 0; j < Report.Columns.Count; j++)
                    {
                        if (Report.Rows[k][j] != null && string.IsNullOrEmpty(Report.Rows[k][j].ToString()))
                        {
                            string COLNAME = Report.Columns[j].ToString();
                            string empid = Report.Rows[k][1].ToString();
                            DateTime dtDoe = Convert.ToDateTime(ServerDateCurrentdate);
                            string year = dtDoe.Year.ToString();
                            string date = COLNAME + "/" + year;
                            DateTime dtpr = Convert.ToDateTime(date);
                            date = dtpr.ToString("MM/dd/yyyy");
                            cmd = new SqlCommand("SELECT sno, empid, fromdate, todate, reportingto, noofdays, reason, doe, status, mobileno, hrremarks, appremarks  FROM  oddetails WHERE @ldte between fromdate and todate AND empid = @empid");
                            // cmd = new SqlCommand("SELECT leave_satus, leave_from_dt, leave_days, leave_to_dt FROM leave_application WHERE @ldte between leave_from_dt and leave_to_dt AND employee_no = @empid AND (leave_satus='A')");
                            cmd.Parameters.Add("@empid", empid);
                            cmd.Parameters.Add("@ldte", date);
                            DataTable dtleaves = vdm.SelectQuery(cmd).Tables[0];
                            if (dtleaves.Rows.Count > 0)
                            {
                                Report.Rows[k][j] = "OD";
                                od++;
                            }
                            else
                            {
                                Report.Rows[k][j] = "L";
                            }

                        }
                        else
                        {
                            string coltotal = Report.Columns[j].ToString();
                            if (coltotal == "Total")
                            {
                                string total = Report.Rows[k][j].ToString();
                                int tot = Convert.ToInt32(total);
                                tot = tot + od;
                                Report.Rows[k][j] = tot;
                            }
                        }
                    }
                }
            }

            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["adata"] = Report;
            hidepanel.Visible = true;
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }

    protected void btn_InOutTime_Click(object sender, EventArgs e)
    {
        try
        {
            Lbl_Error_InOutTime.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string[] datestrig = dtp_InoutTimeFrmDate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            datestrig = dtp_InoutTimeToDate.Text.Split(' ');
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
            lblFromDate1.Text = fromdate.ToString("dd/MMM/yyyy");
            lbltodate1.Text = todate.ToString("dd/MMM/yyyy");
            lblbname1.Text = ddl_Branch_InOutTime.SelectedItem.Text + "  " + ddl_Emptype_InOutTime.SelectedItem.Text;
            DataTable dtbetweendates = new DataTable();
            
            dtbetweendates.Columns.Add("attendance_date").DataType = typeof(DateTime);
            for (var dt = fromdate; dt <= todate; dt = dt.AddDays(1))
            {
                DataRow newrow = dtbetweendates.NewRow();
                newrow["attendance_date"] = dt;
                dtbetweendates.Rows.Add(newrow);
            }

            if (ddl_Emptype_InOutTime.SelectedItem.Value == "0")
            {
                cmd = new SqlCommand("SELECT t3.empid, t3.fullname, t3.employee_num, t3.SDate, t3.FD, t4.EDate, t4.D2 FROM  (SELECT t1.empid, t1.fullname, t1.employee_num, t2.SDate, t2.FD FROM (SELECT  empid, fullname, employee_num FROM  employedetails WHERE   (status = 'NO') AND (branchid = @BranchId)) AS t1 LEFT OUTER JOIN (SELECT MIN(LogDate) AS SDate, CONVERT(varchar, LogDate, 103) AS FD, EmpId AS Eid  FROM  AttendanceLogs WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t2 ON t1.empid = t2.Eid) AS t3 LEFT OUTER JOIN (SELECT MAX(LogDate) AS EDate, CONVERT(varchar, LogDate, 103) AS D2, EmpId AS Eid1 FROM AttendanceLogs AS AttendanceLogs_1 WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t4 ON t3.empid = t4.Eid1 ORDER BY t3.empid, t3.FD");
                cmd.Parameters.Add("@branchid", ddl_Branch_InOutTime.SelectedItem.Value);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
            }
            else
            {
                //cmd = new SqlCommand("SELECT Q1.empid, Q1.fullname, Q1.employee_num, Q2.sno, Q2.branchid, Q2.empid AS Expr1, ISNULL(Q2.status, 'A') AS status, Q2.doe, ISNULL(Q2.attendance_date, Q2.attendance_date) AS attendance_date FROM  (SELECT empid, fullname, employee_num FROM employedetails  WHERE  (branchid = @branchid) AND (employee_type = @employee_type) AND (status = 'No')) AS Q1 LEFT OUTER JOIN(SELECT  sno, branchid, empid, status, doe, attendance_date, remarks FROM   dailyattandancedetails  WHERE  (attendance_date BETWEEN @d1 AND @d2)) AS Q2 ON Q1.empid = Q2.empid ORDER BY Q1.empid");
                cmd = new SqlCommand("SELECT t3.empid, t3.fullname, t3.employee_num, t3.SDate, t3.FD, t4.EDate, t4.D2 FROM  (SELECT t1.empid, t1.fullname, t1.employee_num, t2.SDate, t2.FD FROM (SELECT  empid, fullname, employee_num FROM  employedetails WHERE   (status = 'NO') AND (employee_type = @employee_type) AND (branchid = @BranchId)) AS t1 LEFT OUTER JOIN (SELECT MIN(LogDate) AS SDate, CONVERT(varchar, LogDate, 103) AS FD, EmpId AS Eid  FROM  AttendanceLogs WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t2 ON t1.empid = t2.Eid) AS t3 LEFT OUTER JOIN (SELECT MAX(LogDate) AS EDate, CONVERT(varchar, LogDate, 103) AS D2, EmpId AS Eid1 FROM AttendanceLogs AS AttendanceLogs_1 WHERE (BranchId = @BranchId) AND (LogDate BETWEEN @d1 AND @d2) GROUP BY EmpId, CONVERT(varchar, LogDate, 103)) AS t4 ON t3.empid = t4.Eid1 AND t3.FD=t4.D2 ORDER BY t3.empid, t3.FD");
                cmd.Parameters.Add("@branchid", ddl_Branch_InOutTime.SelectedItem.Value);
                cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                cmd.Parameters.Add("@d2", GetHighDate(todate));
                cmd.Parameters.Add("@employee_type", ddl_Emptype_InOutTime.SelectedItem.Text);
            }
            DataTable dtPuff = vdm.SelectQuery(cmd).Tables[0];
            DataTable sum = new DataTable();
            sum = dtPuff.Copy();
            int count = 0;
            Report = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("Empid");
            Report.Columns.Add("FullName");
            DateTime dtFrm = new DateTime();
            for (int j = 1; j < NoOfdays; j++)
            {
                if (j == 1)
                {
                    dtFrm = fromdate;
                }
                else
                {
                    dtFrm = dtFrm.AddDays(1);
                }
                string strdate = dtFrm.ToString("dd/MMM");
                Report.Columns.Add(strdate);
                count++;
            }
           // Report.Columns.Add("Total", typeof(Double)).SetOrdinal(count + 3);
            DataView view = new DataView(sum);
            DataTable DTEmpname = view.ToTable(true, "FullName");
            int i = 1;
            string prvdate = "";
            DateTime PREVDATE = DateTime.Now;
            foreach (DataRow branch in DTEmpname.Rows)
            {
                DataRow newrow = Report.NewRow();
                newrow["Sno"] = i++.ToString();
                newrow["FullName"] = branch["FullName"].ToString();
                int total = 0;
                foreach (DataRow drEmpname in sum.Rows)
                {

                    if (branch["FullName"].ToString() == drEmpname["FullName"].ToString())
                    {
                        string empno = drEmpname["empid"].ToString();
                        newrow["Empid"] = empno.ToString();
                        string fullname = drEmpname["FullName"].ToString();
                        string attendance_date = drEmpname["SDate"].ToString();
                        string attendance_Todatedate = drEmpname["EDate"].ToString();
                        // string status = drEmpname["status"].ToString();
                        if (attendance_date != "")
                        {
                            prvdate = attendance_date;
                            DateTime dtDoe = Convert.ToDateTime(attendance_date);
                            DateTime dtDoe1 = Convert.ToDateTime(attendance_Todatedate);
                            PREVDATE = dtDoe;
                            string strdateTime = dtDoe.ToString("h:mm tt");
                            string strdate = dtDoe.ToString("dd/MMM");
                            string EnddateTime = dtDoe1.ToString("h:mm tt");
                            string Enddate = dtDoe1.ToString("dd/MMM");
                            newrow[strdate] = strdateTime + "_" + EnddateTime;                           
                        }
                        else
                        {
                           
                        }

                    }
                    else
                    {

                    }
                }
                Report.Rows.Add(newrow);
            }
            //
            gd_PerdayInOutTime.DataSource = Report;
            gd_PerdayInOutTime.DataBind();
            Session["adata"] = Report;

            hidepanelInOutTime.Visible = true;
        }
        catch (Exception ex)
        {
            Lbl_Error_InOutTime.Text = ex.Message;
            hidepanelInOutTime.Visible = false;
        }
    }

    protected void btnlogssave_click(object sender, EventArgs e)
    {
        DataTable dtattandance = (DataTable)Session["adata"];
        double Finalsalarydays = 0;
        double Numberofworkingdays = 0;
        double Lop = 0;
        double Extradays = 0;
        double ConfirmholidaysDays = 0;
        lblmsg.Text = "";
        DBManager SalesDB = new DBManager();
        DateTime fromdate = DateTime.Now;
        DateTime todate = DateTime.Now;
        string clorwo = txt_cl.Text;
        string[] datestrig = dtp_FromDate.Text.Split(' ');
        string[] dates1 = datestrig[0].Split('-');
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


        //Total Days
        TimeSpan dateSpan = todate.Subtract(fromdate);
        double monthdays = dateSpan.Days;
        double NoOfdays = dateSpan.Days;
        NoOfdays = NoOfdays + 2;
        double TempNoOfdays1 = NoOfdays - 1;
        //No of Holidays
        double holidaycount = 0;
        cmd = new SqlCommand("SELECT holidayyear, holidaydate, status FROM holiday WHERE (holidaydate BETWEEN @fromdate AND @todate)");
        cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
        cmd.Parameters.Add("@todate", GetHighDate(todate));
        DataTable holiday = vdm.SelectQuery(cmd).Tables[0];
        foreach (DataRow dholiday in holiday.Rows)
        {
            string holidaydate = dholiday["holidaydate"].ToString();
            DateTime dateofaffence = Convert.ToDateTime(holidaydate);
            string strdate = dateofaffence.ToString("dd/MM/yyyy");
            string[] str = strdate.Split('/');
            string holidayday = str[0];
            holidaycount++;
        }
        double numbrofholidays = Convert.ToDouble(holidaycount);
        //No of CL Day
        double casualleave = 1;


        //No of Sundays in month sundays++;
        lblFromDate.Text = fromdate.ToString("dd/MMM/yyyy");
        lbltodate.Text = todate.ToString("dd/MMM/yyyy");
        string[] datestrig1 = dtp_Todate.Text.Split(' ');
        string[] dates2 = datestrig1[0].Split('-');
        string month = dates2[1].ToString();
        string year = dates2[2].ToString();
        DateTime fdate = fromdate;
        //DateTime sdate = DateTime.Now.AddDays(-1);
        DateTime sdate = todate;
        TimeSpan ts = sdate - fdate;
        var sundays = ((ts.TotalDays / 7) + (sdate.DayOfWeek == DayOfWeek.Sunday || fdate.DayOfWeek == DayOfWeek.Sunday || fdate.DayOfWeek > sdate.DayOfWeek ? 1 : 0));
        sundays = Math.Round(sundays - .5, MidpointRounding.AwayFromZero);
        cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, pay_structure.gross FROM employedetails INNER JOIN  pay_structure ON  pay_structure.empid=employedetails.empid");
        DataTable EMPINFO = vdm.SelectQuery(cmd).Tables[0];
        double clor = sundays + numbrofholidays;
        if (dtattandance.Rows.Count > 0)
        {
            foreach (DataRow dr in dtattandance.Rows)
            {
                double tdays = 0;
                double clorr = 0;
                double noofworkingdays = 0;
                double lop = 0;
                double conformworkingdays = 0;
                Extradays = 0;
                string totaldays = dr["Total"].ToString();
                double gross = 0;
                string empid = dr["empid"].ToString();
                string empno = "";
                double sunday = 0;
                foreach (DataRow dra in EMPINFO.Select("empid='" + dr["empid"].ToString() + "'"))
                {
                    empno = dra["employee_num"].ToString();
                    gross = Convert.ToDouble(dra["gross"].ToString());
                }
                if (totaldays != "")
                {
                    tdays = Convert.ToDouble(totaldays);
                    clorr = clor + 1;
                    noofworkingdays = tdays - clorr;
                    conformworkingdays = TempNoOfdays1 - clorr;
                    if (tdays >= conformworkingdays)
                    {
                        if (gross < 20000)
                        {
                            Extradays = tdays - conformworkingdays;
                        }
                        else
                        {
                            Extradays = 0;
                        }
                        lop = 0;
                    }
                    else
                    {
                       // sunday = tdays / 7;
                        sunday = Math.Round(sundays);
                        clorr = sunday + 1;
                        double nd = TempNoOfdays1 - clorr;
                        double ttt = tdays + clorr;
                        lop = TempNoOfdays1 - ttt;
                        conformworkingdays = nd;
                    }
                }
                string sempid = Session["empid"].ToString();
                DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                cmd = new SqlCommand("UPDATE monthly_attendance SET employee_num=@empno, numberofworkingdays=@nworkingdays, month=@mnth, year=@yr, clorwo=@clor, lop=@lopy, extradays=@exdays, modify_by=@modify_by,modify_date=@modify_date WHERE empid=@empid AND month=@mnth AND year=@yr");
                cmd.Parameters.Add("@empno", empno);
                cmd.Parameters.Add("@empid", empid);
                cmd.Parameters.Add("@mnth", month);
                cmd.Parameters.Add("@yr", year);
                cmd.Parameters.Add("@nworkingdays", conformworkingdays);
                cmd.Parameters.Add("@clor", clorr);
                cmd.Parameters.Add("@lopy", lop);
                cmd.Parameters.Add("@exdays", Extradays);
                cmd.Parameters.Add("@modify_by", sempid);
                cmd.Parameters.Add("@modify_date", ServerDateCurrentdate);
                if (vdm.Update(cmd) == 0)
                {
                    cmd = new SqlCommand("insert into monthly_attendance (empid,employee_num,doe,numberofworkingdays,month,year,clorwo,lop,extradays,entry_by) values (@employee, @employeeno, @doe, @numberofworkingdays,@month,@year,@clorwo,@lop,@extradays,@entry_by)");
                    cmd.Parameters.Add("@employeeno", empno);
                    cmd.Parameters.Add("@employee", empid);
                    cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                    cmd.Parameters.Add("@month", month);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@numberofworkingdays", conformworkingdays);
                    cmd.Parameters.Add("@clorwo", clorr);
                    cmd.Parameters.Add("@lop", lop);
                    cmd.Parameters.Add("@extradays", Extradays);
                    cmd.Parameters.Add("@entry_by", sempid);
                    vdm.insert(cmd);
                }
                lblmsg.Text = "Employe attandance saved successfully";
            }
        }
    }
}