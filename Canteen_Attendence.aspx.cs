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

public partial class Canteen_Attendence : System.Web.UI.Page
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
                lblbname.Text = ddlbranch.SelectedItem.Text;
                DataTable dtbetweendates = new DataTable();
                dtbetweendates.Columns.Add("attendance_date").DataType = typeof(DateTime);
                for (var dt = fromdate; dt <= todate; dt = dt.AddDays(1))
                {
                    DataRow newrow = dtbetweendates.NewRow();
                    newrow["attendance_date"] = dt;
                    dtbetweendates.Rows.Add(newrow);
                }
                string type = "";

                string t1 = txt_type.SelectedItem.Value;
               
                DataTable dtPuff = new DataTable();
                cmd = new SqlCommand("SELECT Sno, branchid,type,amount FROM  Canteen_Master WHERE (branchid = @BranchID)");
                cmd.Parameters.Add("@BranchID", ddlbranch.SelectedItem.Value);
                DataTable dtCanteen = vdm.SelectQuery(cmd).Tables[0];
                if (t1 == "ALL")
                {
                    cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, canteen_attendence.breakfast, canteen_attendence.lunch, canteen_attendence.dinner, canteen_attendence.doe  FROM  canteen_attendence INNER JOIN employedetails ON canteen_attendence.empid = employedetails.empid WHERE (canteen_attendence.doe BETWEEN @d1 AND @d2) and (canteen_attendence.branchid = @branchid) ");
                    cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(todate));
                    dtPuff = vdm.SelectQuery(cmd).Tables[0];
                }
                else
                {
                    if (t1 == "1")
                    {
                        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, canteen_attendence.status, canteen_attendence.breakfast, canteen_attendence.doe  FROM  canteen_attendence INNER JOIN employedetails ON canteen_attendence.empid = employedetails.empid WHERE (canteen_attendence.doe BETWEEN @d1 AND @d2) and (canteen_attendence.branchid = @branchid) and canteen_attendence.breakfast=@type");
                    }
                    if (t1 == "2")
                    {
                        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, canteen_attendence.status, canteen_attendence.lunch, canteen_attendence.doe  FROM  canteen_attendence INNER JOIN employedetails ON canteen_attendence.empid = employedetails.empid WHERE (canteen_attendence.doe BETWEEN @d1 AND @d2) and (canteen_attendence.branchid = @branchid) and canteen_attendence.lunch=@type");
                    }
                    if (t1 == "3")
                    {
                        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, canteen_attendence.dinner, canteen_attendence.status, canteen_attendence.doe  FROM  canteen_attendence INNER JOIN employedetails ON canteen_attendence.empid = employedetails.empid WHERE (canteen_attendence.doe BETWEEN @d1 AND @d2) and (canteen_attendence.branchid = @branchid) and canteen_attendence.dinner=@type");
                    }
                    cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
                    cmd.Parameters.Add("@type", t1);
                    cmd.Parameters.Add("@d1", GetLowDate(fromdate));
                    cmd.Parameters.Add("@d2", GetHighDate(todate));
                    dtPuff = vdm.SelectQuery(cmd).Tables[0];
                }
                double Breakfast = 0;
                double lunch = 0;
                double dinner = 0;
                if (dtCanteen.Rows.Count > 0)
                {
                    double.TryParse(dtCanteen.Rows[0]["amount"].ToString(), out Breakfast);
                    double.TryParse(dtCanteen.Rows[1]["amount"].ToString(), out lunch);
                    double.TryParse(dtCanteen.Rows[2]["amount"].ToString(), out dinner);
                }
                DataTable sum = new DataTable();
                sum = dtPuff.Copy();
                Report = new DataTable();
                Report.Columns.Add("Sno");
                Report.Columns.Add("empid");
                Report.Columns.Add("empcode");
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
                Report.Columns.Add("Total", typeof(Double)).SetOrdinal(count + 4);
                Report.Columns.Add("Total Amount", typeof(Double)).SetOrdinal(count + 5);
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
                    double totalamount = 0;
                    foreach (DataRow drDriver in sum.Rows)
                    {
                        if (branch["fullname"].ToString() == drDriver["fullname"].ToString())
                        {
                            string fullname = drDriver["fullname"].ToString();
                            string attendance_date = drDriver["doe"].ToString();
                            string status = "P";
                            string breakfasttype = "";
                            string lunchtype = "";
                            string dinnertype = "";
                            if (t1 == "ALL")
                            {
                                breakfasttype = drDriver["breakfast"].ToString();
                                lunchtype = drDriver["lunch"].ToString();
                                dinnertype = drDriver["dinner"].ToString();
                            }
                            else
                            {
                                if (t1 == "1")
                                {
                                    breakfasttype = drDriver["breakfast"].ToString();
                                }
                                if (t1 == "2")
                                {
                                    lunchtype = drDriver["lunch"].ToString();
                                }
                                if (t1 == "3")
                                {
                                    dinnertype = drDriver["dinner"].ToString();
                                }
                            }
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

                                if (breakfasttype == "1")
                                {
                                    if (ddlbranch.SelectedItem.Value == "1")
                                    {

                                    }
                                    else
                                    {
                                        totalamount += Breakfast;
                                    }
                                }
                                if (lunchtype == "2")
                                {
                                    totalamount += lunch;
                                }
                                if (dinnertype == "3")
                                {
                                    if (ddlbranch.SelectedItem.Value == "1")
                                    {

                                    }
                                    else
                                    {
                                        totalamount += dinner;
                                    }
                                }

                            }
                            else
                            {

                                //DateTime dtDoe = PREVDATE.AddDays(1);
                                //string strdateTime = dtDoe.ToString("HH");
                                //string strdate = dtDoe.ToString("dd/MMM");
                                //if (status == "A")
                                //{
                                //    newrow[strdate] = "A";
                                //}
                                //else
                                //{
                                //    newrow[strdate] = "L";
                                //}
                            }
                            string empid = drDriver["empid"].ToString();
                            newrow["empid"] = drDriver["empid"].ToString();
                            newrow["empcode"] = drDriver["employee_num"].ToString();
                        }
                    }
                    newrow["Total"] = total;
                    newrow["Total Amount"] = totalamount;
                    Report.Rows.Add(newrow);
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
    }
    protected void btnlogssave_click(object sender, EventArgs e)
    {
        DataTable dtattandance = (DataTable)Session["adata"];
        DBManager SalesDB = new DBManager();
        DateTime fromdate = DateTime.Now;
        DateTime todate = DateTime.Now;
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
        string[] datestrig1 = dtp_Todate.Text.Split(' ');
        string[] dates2 = datestrig1[0].Split('-');
        string month = dates2[1].ToString();
        string year = dates2[2].ToString();
        DateTime fdate = fromdate;
        DateTime sdate = todate;
        TimeSpan ts = sdate - fdate;
        cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, pay_structure.gross FROM employedetails INNER JOIN  pay_structure ON  pay_structure.empid=employedetails.empid");
        DataTable EMPINFO = vdm.SelectQuery(cmd).Tables[0];
        if (dtattandance.Rows.Count > 0)
        {
            foreach (DataRow dr in dtattandance.Rows)
            {
                string totalamt = dr["Total Amount"].ToString();
                double gross = 0;
                string empid = dr["empid"].ToString();
                string empno = dr["empcode"].ToString();
                foreach (DataRow dra in EMPINFO.Select("empid='" + dr["empid"].ToString() + "'"))
                {
                    gross = Convert.ToDouble(dra["gross"].ToString());
                }
                DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                if (gross > 10000)
                {
                    cmd = new SqlCommand("UPDATE canteendeductions SET employee_num=@empno, amount=@totalamt, month=@mnth, year=@yr WHERE empid=@empid AND month=@mnth AND year=@yr");
                    cmd.Parameters.Add("@empno", empno);
                    cmd.Parameters.Add("@empid", empid);
                    cmd.Parameters.Add("@mnth", month);
                    cmd.Parameters.Add("@yr", year);
                    cmd.Parameters.Add("@totalamt", totalamt);
                    if (vdm.Update(cmd) == 0)
                    {
                        cmd = new SqlCommand("insert into canteendeductions (empid, employee_num, date, amount, month, year) values (@employee, @employeeno, @doe, @amount, @month, @year)");
                        cmd.Parameters.Add("@employeeno", empno);
                        cmd.Parameters.Add("@employee", empid);
                        cmd.Parameters.Add("@doe", ServerDateCurrentdate);
                        cmd.Parameters.Add("@amount", totalamt);
                        cmd.Parameters.Add("@month", month);
                        cmd.Parameters.Add("@year", year);
                        vdm.insert(cmd);
                    }
                }
                lblmsg.Text = "Employe Canteen Deductions saved successfully";
            }
        }
    }
}