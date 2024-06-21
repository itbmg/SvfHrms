using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class extradayswork : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        vdm = new DBManager();
        if (Session["fullname"] == null)
        {
            Response.Redirect("login.aspx");
        }
        if (!IsPostBack)
        {
            if (!Page.IsCallback)
            {
                DateTime dtfrom = DateTime.Now.AddMonths(0);
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                FillBranches();
                bindemployeetype();
                txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
            }
        }
    }
    void FillBranches()
    {
        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) ");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlbranches.DataSource = dttrips;
        ddlbranches.DataTextField = "branchname";
        ddlbranches.DataValueField = "branchid";
        ddlbranches.DataBind();
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
    DataTable dtsundays = new DataTable();
    protected void btn_Generate_Click(object sender, EventArgs e)
    {
        try
        {
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            //DateTime fromdate = DateTime.Now;
            string mainbranch = Session["mainbranch"].ToString();
            DateTime fromdate = DateTime.Now;
            DateTime todate = DateTime.Now;
            string[] dateFromstrig = txtFromdate.Text.Split(' ');
            if (dateFromstrig.Length > 1)
            {
                if (dateFromstrig[0].Split('-').Length > 0)
                {
                    string[] dates = dateFromstrig[0].Split('-');
                    string[] times = dateFromstrig[1].Split(':');
                    fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            string[] datetostrig = txtTodate.Text.Split(' ');
            if (datetostrig.Length > 1)
            {
                if (datetostrig[0].Split('-').Length > 0)
                {
                    string[] dates = datetostrig[0].Split('-');
                    string[] times = datetostrig[1].Split(':');
                    todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            lblFromDate.Text = fromdate.ToString("dd/MM/yyyy");
            lbltodate.Text = todate.ToString("dd/MM/yyyy");
            dtsundays.Columns.Add("Date");
            DateTime fdate = fromdate;
            DateTime sdate = todate;
            TimeSpan DateDiff = sdate.Subtract(fdate);
            for (int i = 0; i <= DateDiff.Days; i++)
            {
                if (fdate.Date.AddDays(i).DayOfWeek == DayOfWeek.Sunday)
                {
                    DataRow newrow = dtsundays.NewRow();
                    newrow["Date"] = fdate.Date.AddDays(i).ToShortDateString();
                    dtsundays.Rows.Add(newrow);
                }
            }

            cmd = new SqlCommand("SELECT holidayyear, holidaydate, status FROM holiday WHERE (holidaydate BETWEEN @fromdate AND @todate)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            DataTable holiday = vdm.SelectQuery(cmd).Tables[0];
            foreach (DataRow dholiday in holiday.Rows)
            {
                string holidaydate = dholiday["holidaydate"].ToString();
                DataRow newrow = dtsundays.NewRow();
                newrow["Date"] = dholiday["holidaydate"].ToString();
                dtsundays.Rows.Add(newrow);
            }
            Report.Columns.Add("Date");
            Report.Columns.Add("SNO");
            Report.Columns.Add("Full Name");
            Report.Columns.Add("Employee_num");
            //Report.Columns.Add("Employeeid");
            int branchid = Convert.ToInt32(ddlbranches.SelectedItem.Value);
            cmd = new SqlCommand("SELECT Q1.empid, Q1.fullname, Q1.employee_num, Q2.sno, Q2.branchid, Q2.empid AS Expr1, ISNULL(Q2.status, 'A') AS status, Q2.doe, ISNULL(Q2.attendance_date, Q2.attendance_date) AS attendance_date FROM  (SELECT empid, fullname, employee_num FROM employedetails  WHERE  (branchid = @branchid) AND (employee_type = @employee_type) AND (status = 'No')) AS Q1 LEFT OUTER JOIN(SELECT  sno, branchid, empid, status, doe, attendance_date, remarks FROM   dailyattandancedetails  WHERE  (attendance_date BETWEEN @d1 AND @d2)) AS Q2 ON Q1.empid = Q2.empid ORDER BY Q1.empid");
            cmd.Parameters.Add("@branchid", ddlbranches.SelectedItem.Value);
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@employee_type", ddlemptype.SelectedItem.Text);
            DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            int k = 1;
            foreach (DataRow dr in dtsundays.Rows)
            {
                foreach (DataRow dra in dtsalary.Select("attendance_date='" + dr["Date"].ToString() + "' AND status='P'"))
                {
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = k++;
                    newrow["Full Name"] = dra["fullname"].ToString();
                    newrow["Employee_num"] = dra["employee_num"].ToString();
                    newrow["Date"] = dra["attendance_date"].ToString();
                    Report.Rows.Add(newrow);
                }
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            hidepanel.Visible = true;
        }
        catch
        {
        }
    }
    

    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Date");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}