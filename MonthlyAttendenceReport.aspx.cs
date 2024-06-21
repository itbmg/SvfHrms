using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class MonthlyAttendenceReport : System.Web.UI.Page
{
    SqlCommand cmd;
    ///string BranchID = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        vdm = new DBManager();
        if (!Page.IsPostBack)
        {
            if (!Page.IsCallback)
            {
                dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
            }
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
            cmd = new SqlCommand("SELECT employedetails.fullname, monthly_attendance.month, monthly_attendance.doe, monthly_attendance.numberofworkingdays FROM employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid WHERE (monthly_attendance.month BETWEEN @fromdate AND @todate)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            DataTable dtPuff = vdm.SelectQuery(cmd).Tables[0];
            DataTable sum = new DataTable();
            sum = dtPuff.Copy();
            Report = new DataTable();
            Report.Columns.Add("Sno");
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
            Report.Columns.Add("Total", typeof(Double)).SetOrdinal(count + 2);
            DataView view = new DataView(sum);
            DataTable DriverData = view.ToTable(true, "fullname");
            int i = 1;
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
                        string fullname = drDriver["fullname"].ToString();
                        string month = drDriver["month"].ToString();
                        if (month != "")
                        {
                            DateTime dtDoe = Convert.ToDateTime(month);
                            string strdateTime = dtDoe.ToString("HH");
                            string strdate = dtDoe.ToString("dd/MMM");
                        }
                    }
                }
                newrow["Total"] = total;
                Report.Rows.Add(newrow);
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
}