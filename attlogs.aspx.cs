using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class attlogs : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;
    double netpay = 0;
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
                    DateTime dtfrom = DateTime.Now.AddMonths(0);
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
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
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranch.DataSource = dttrips;
        ddlbranch.DataTextField = "branchname";
        ddlbranch.DataValueField = "branchid";
        ddlbranch.DataBind();
        ddlbranch.ClearSelection();
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Branch--", Selected = true });
        ddlbranch.SelectedValue = "0";
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

            string lbfrmdate = lblFromDate.Text + " 12:55";
            string lbtodate = lblFromDate.Text + " 13:40";

            string lbfrmdateE = lblFromDate.Text + " 13:30";
            string lbtodateE = lblFromDate.Text + " 15:30";


            string lbmtodate = lblFromDate.Text + " 10:40";
            DateTime lmtodate = Convert.ToDateTime(lbmtodate);



            DateTime lfromdate = Convert.ToDateTime(lbfrmdate);
            DateTime ltodate = Convert.ToDateTime(lbtodate);

            DateTime lfromdateE = Convert.ToDateTime(lbfrmdateE);
            DateTime ltodateE = Convert.ToDateTime(lbtodateE);

            DataTable Report = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("empname");
            Report.Columns.Add("Intime_M");
            Report.Columns.Add("Outtime_M");
            Report.Columns.Add("Outtime_A");
            Report.Columns.Add("Intime_A");
            cmd = new SqlCommand("SELECT  empid, fullname  FROM  employedetails  WHERE (status = 'NO') AND (branchid = @branch)  ORDER BY empid");
            cmd.Parameters.Add("@branch", ddlbranch.SelectedItem.Value);
            DataTable emplogs = vdm.SelectQuery(cmd).Tables[0];
            

            cmd = new SqlCommand("SELECT  AttendanceLogs.LogDate, AttendanceLogs.EmpId, AttendanceLogs.Direction, branchmaster.branchname FROM    AttendanceLogs INNER JOIN branchmaster ON AttendanceLogs.BranchId = branchmaster.branchid WHERE AttendanceLogs.DeviceId='1' AND (AttendanceLogs.LogDate BETWEEN @d1 AND @d2) GROUP BY AttendanceLogs.LogDate, AttendanceLogs.Direction, branchmaster.branchname, AttendanceLogs.EmpId ORDER BY AttendanceLogs.LogDate");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            DataTable logs = vdm.SelectQuery(cmd).Tables[0];

            if (emplogs.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in emplogs.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    string empid = dr["empid"].ToString();
                    string empname = dr["fullname"].ToString();
                    newrow["empname"] = empname;
                    newrow["Sno"] = i++;

                    DateTime mlogdt = GetLowDate(fromdate);
                    cmd = new SqlCommand("SELECT TOP (1) AttendanceLogs.LogDate, AttendanceLogs.EmpId, AttendanceLogs.Direction  FROM  AttendanceLogs INNER JOIN  branchmaster ON AttendanceLogs.BranchId = branchmaster.branchid  WHERE        (AttendanceLogs.LogDate BETWEEN @d1 AND @d2) AND (AttendanceLogs.EmpId = @empid)  GROUP BY AttendanceLogs.LogDate, AttendanceLogs.Direction, AttendanceLogs.EmpId  ORDER BY AttendanceLogs.LogDate");
                    cmd.Parameters.Add("@empid", empid);
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2",lmtodate);
                    DataTable logs1 = vdm.SelectQuery(cmd).Tables[0];
                    if (logs1.Rows.Count > 0)
                    {
                        string logd = logs1.Rows[0]["LogDate"].ToString();
                        mlogdt = Convert.ToDateTime(logd).AddMinutes(1);
                    }


                    cmd = new SqlCommand("SELECT TOP (1) AttendanceLogs.LogDate, AttendanceLogs.EmpId, AttendanceLogs.Direction  FROM  AttendanceLogs INNER JOIN  branchmaster ON AttendanceLogs.BranchId = branchmaster.branchid  WHERE        (AttendanceLogs.LogDate BETWEEN @d1 AND @d2) AND (AttendanceLogs.EmpId = @empid) GROUP BY AttendanceLogs.LogDate, AttendanceLogs.Direction, AttendanceLogs.EmpId  ORDER BY AttendanceLogs.LogDate");
                    cmd.Parameters.Add("@empid", empid);
                    cmd.Parameters.Add("@d1", mlogdt);
                    cmd.Parameters.Add("@d2", lmtodate);
                    DataTable logs2 = vdm.SelectQuery(cmd).Tables[0];

                    cmd = new SqlCommand("SELECT TOP (1) AttendanceLogs.LogDate, AttendanceLogs.EmpId, AttendanceLogs.Direction  FROM  AttendanceLogs INNER JOIN  branchmaster ON AttendanceLogs.BranchId = branchmaster.branchid  WHERE        (AttendanceLogs.LogDate BETWEEN @d1 AND @d2) AND (AttendanceLogs.EmpId = @empid) GROUP BY AttendanceLogs.LogDate, AttendanceLogs.Direction, AttendanceLogs.EmpId  ORDER BY AttendanceLogs.LogDate");
                    cmd.Parameters.Add("@empid", empid);
                    cmd.Parameters.Add("@d1", lfromdate);
                    cmd.Parameters.Add("@d2",ltodate);
                    DataTable logs3 = vdm.SelectQuery(cmd).Tables[0];

                    cmd = new SqlCommand("SELECT TOP (1) AttendanceLogs.LogDate, AttendanceLogs.EmpId, AttendanceLogs.Direction  FROM  AttendanceLogs INNER JOIN  branchmaster ON AttendanceLogs.BranchId = branchmaster.branchid  WHERE        (AttendanceLogs.LogDate BETWEEN @d1 AND @d2) AND (AttendanceLogs.EmpId = @empid) GROUP BY AttendanceLogs.LogDate, AttendanceLogs.Direction, AttendanceLogs.EmpId  ORDER BY AttendanceLogs.LogDate");
                    cmd.Parameters.Add("@empid", empid);
                    cmd.Parameters.Add("@d1", lfromdateE);
                    cmd.Parameters.Add("@d2", ltodateE);
                    DataTable logs4 = vdm.SelectQuery(cmd).Tables[0];
                    if (logs1.Rows.Count > 0)
                    {
                        foreach (DataRow dr1 in logs1.Rows)
                        {
                            string mindate = dr1["LogDate"].ToString();
                            if (mindate != "")
                            {
                                DateTime dtDoE1 = Convert.ToDateTime(mindate);
                                string starttime = dtDoE1.ToString("HH:mm");
                                string Direction = dr1["Direction"].ToString();
                                newrow["Intime_M"] = starttime;
                            }
                        }
                    }
                    if (logs2.Rows.Count > 0)
                    {
                        foreach (DataRow dr2 in logs2.Rows)
                        {
                            string mindate = dr2["LogDate"].ToString();
                            if (mindate != "")
                            {
                                DateTime dtDoE1 = Convert.ToDateTime(mindate);
                                string starttime = dtDoE1.ToString("HH:mm");
                                string Direction = dr2["Direction"].ToString();
                                newrow["Outtime_M"] = starttime;
                            }
                        }
                    }
                    if (logs3.Rows.Count > 0)
                    {
                        foreach (DataRow dr3 in logs3.Rows)
                        {
                            string mindate = dr3["LogDate"].ToString();
                            if (mindate != "")
                            {
                                DateTime dtDoE1 = Convert.ToDateTime(mindate);
                                string starttime = dtDoE1.ToString("HH:mm");
                                string Direction = dr3["Direction"].ToString();
                                newrow["Outtime_A"] = starttime;
                            }
                        }
                    }
                    if (logs4.Rows.Count > 0)
                    {
                        foreach (DataRow dr4 in logs4.Rows)
                        {
                            string mindate = dr4["LogDate"].ToString();
                            if (mindate != "")
                            {
                                DateTime dtDoE1 = Convert.ToDateTime(mindate);
                                string starttime = dtDoE1.ToString("HH:mm");
                                string Direction = dr4["Direction"].ToString();
                                newrow["Intime_A"] = starttime;
                            }
                        }
                    }
                    Report.Rows.Add(newrow);
                }
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            hidepanel.Visible = true;
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }

    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "empname");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}