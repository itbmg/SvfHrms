using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;


public partial class Employeewiseattadance : System.Web.UI.Page
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
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                }
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
            cmd = new SqlCommand("SELECT employedetails.fullname, dailyattandancedetails.status, dailyattandancedetails.attendance_date, dailyattandancedetails.doe FROM employedetails INNER JOIN dailyattandancedetails ON employedetails.empid = dailyattandancedetails.empid INNER JOIN employe_logins ON employedetails.empid = employe_logins.empid WHERE (dailyattandancedetails.attendance_date BETWEEN @fromdate AND @todate) AND (employe_logins.empid = @empid)");
            cmd.Parameters.Add("@fromdate", GetLowDate(fromdate));
            cmd.Parameters.Add("@todate", GetHighDate(todate));
            cmd.Parameters.Add("@empid", Context.Session["empid"].ToString());
            DataTable dtPuff = vdm.SelectQuery(cmd).Tables[0];
            DataTable sum = new DataTable();
            sum = dtPuff.Copy();
            //  sum.Merge(dtPuff);
            Report = new DataTable();
            Report.Columns.Add("Sno");
            Report.Columns.Add("FullName");
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
                newrow["FullName"] = branch["fullname"].ToString();
                int total = 0;
                foreach (DataRow drDriver in sum.Rows)
                {
                    if (branch["fullname"].ToString() == drDriver["fullname"].ToString())
                    {
                        string fullname = drDriver["fullname"].ToString();
                        string attendance_date = drDriver["attendance_date"].ToString();
                        string status = drDriver["status"].ToString();
                        if (attendance_date != "")
                        {
                            DateTime dtDoe = Convert.ToDateTime(attendance_date);
                            string strdateTime = dtDoe.ToString("HH");
                            string strdate = dtDoe.ToString("dd/MMM");
                            if (status == "P")
                            {
                                newrow[strdate] = "P";
                                total++;
                            }
                            else
                            {
                                newrow[strdate] = " ";
                            }

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