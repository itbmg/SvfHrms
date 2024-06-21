using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class monthlywiseresignationreport : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
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
                    DateTime dtfrom = DateTime.Now.AddMonths(-1);
                    DateTime dtfrom1 = DateTime.Now.AddMonths(-2);
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    //string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    //string frmdate1 = dtfrom1.ToString("dd/MM/yyyy");
                    //string[] str = frmdate.Split('/');
                    //string[] str1 = frmdate1.Split('/');
                    //ddlmonth.SelectedValue = str[1];
                    //ddlmonth1.SelectedValue = str1[1];
                    txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
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

    private void bindbranchs()
    {
        DBManager SalesDB = new DBManager();
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

    DataTable Report = new DataTable();
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
            lbl_selfromdate.Text = fromdate.ToString("dd/MM/yyyy");
            lbl_selttodate.Text = todate.ToString("dd/MM/yyyy");
            Report.Columns.Add("SNO");
            Report.Columns.Add("Location");
            //Report.Columns.Add("Employeeid");

            int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            cmd = new SqlCommand("SELECT  COUNT(empresignationdetails.empid) AS Count, branchmaster.branchname, UPPER(LEFT(DATENAME(MONTH, empresignationdetails.resignationdate), 3)) AS Month, " +
                       "  YEAR(empresignationdetails.resignationdate) AS year, MONTH(empresignationdetails.resignationdate) AS mon " +
" FROM            branchmaster INNER JOIN " +
                         " employedetails ON branchmaster.branchid = employedetails.branchid INNER JOIN "+
                        " branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN "+
                         " empresignationdetails ON employedetails.empid = empresignationdetails.empid " +
" WHERE        (employedetails.status = 'YES') AND (branchmaster.branchid = @branchid) AND (empresignationdetails.resignationdate BETWEEN @d1 AND @d2) " +
"GROUP BY branchmaster.branchname, MONTH(empresignationdetails.resignationdate), DATENAME(MONTH, empresignationdetails.resignationdate), "+
                          " YEAR(empresignationdetails.resignationdate) " +
" ORDER BY year, mon"); 
            //cmd = new SqlCommand("SELECT COUNT(empresignationdetails.empid) AS Count, branchmaster.branchname, UPPER(LEFT(DATENAME(MONTH, empresignationdetails.resignationdate), 3)) AS Month, YEAR(empresignationdetails.resignationdate) AS year FROM  branchmaster INNER JOIN employedetails ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN empresignationdetails ON employedetails.empid = empresignationdetails.empid WHERE (employedetails.status = 'YES') AND (branchmapping.mainbranch = @m) AND (empresignationdetails.resignationdate BETWEEN @d1 AND @d2)GROUP BY branchmaster.branchname, MONTH(empresignationdetails.resignationdate), DATENAME(MONTH, empresignationdetails.resignationdate), YEAR(empresignationdetails.resignationdate)ORDER BY month, year");
            cmd.Parameters.Add("@d1", GetLowDate(fromdate));
            cmd.Parameters.Add("@d2", GetHighDate(todate));
            cmd.Parameters.Add("@branchid", ddlbranch.SelectedItem.Value);
            DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            DataView view = new DataView(dtsalary);
            DataTable emptbl = view.ToTable(true, "Month", "year");
            DataTable branchtbl = view.ToTable(true, "branchname");
            foreach (DataRow dr in emptbl.Rows)
            {
                // string branchname = dr["branchname"].ToString();
                string month = dr["Month"].ToString();
                string year = dr["year"].ToString();
                Report.Columns.Add(month + "-" + year).DataType = typeof(Double);

                // Report.Columns.Add(dr["Month"].ToString());
            }
            if (branchtbl.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in branchtbl.Rows)
                {

                    //foreach (DataRow dra in dtsalary.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                    //{
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["Location"] = dr["branchname"].ToString();
                    //newrow["count"] = dr["Count"].ToString();
                    Report.Rows.Add(newrow);
                }
            }
            foreach (DataRow dr in Report.Rows)
            {
                foreach (DataRow dra in dtsalary.Select("branchname='" + dr["Location"].ToString() + "'"))
                {
                    string month = dra["Month"].ToString();
                    string year = dra["year"].ToString();
                    string monthyear = (month + "-" + year);
                    //Report.DefaultView.Sort = "monthyear";
                    dr[monthyear] = dra["Count"].ToString();
                }
            }
            // }
            //}
            DataRow newTotal = Report.NewRow();
            newTotal["Location"] = "Total";
            double val = 0.0;
            foreach (DataColumn dc in Report.Columns)
            {
                if (dc.DataType == typeof(Double))
                {
                    val = 0.0;
                    double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                    newTotal[dc.ToString()] = val;
                }
            }
            Report.Rows.Add(newTotal);
            grdReports.DataSource = Report;
            if (Report.Rows.Count > 1)
            {
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else
            {
                hidepanel.Visible = false;
                lblmsg.Text = "No Data Found";
            }
        }
        catch
        {
        }

    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[1].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}