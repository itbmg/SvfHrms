using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
public partial class SalaryAdvanceReport : System.Web.UI.Page
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
                DateTime dtyear = DateTime.Now.AddMonths(0);
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                FillBranches();
                PopulateYear();
            }
        }
    }

    private void PopulateYear()
    {

        ddlyear.Items.Clear();
        ListItem lt = new ListItem();
        lt.Text = "YYYY";
        lt.Value = "0";
        ddlyear.Items.Add(lt);
        for (int i = DateTime.Now.Year; i >= 1970; i--)
        {
            lt = new ListItem();
            lt.Text = i.ToString();
            lt.Value = i.ToString();
            ddlyear.Items.Add(lt);
        }
        ddlyear.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
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
            DateTime mydate = DateTime.Now;
            //string[] datestrig = dtp_FromDate.Text.Split(' ');
            //    if (datestrig.Length > 1)
            //    {
            //        if (datestrig[0].Split('-').Length > 0)
            //        {
            //            string[] dates = datestrig[0].Split('-');
            //            string[] times = datestrig[1].Split(':');
            //            fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
            //        }
            //    }
            //    datestrig = dtp_Todate.Text.Split(' ');
            //    if (datestrig.Length > 1)
            //    {
            //        if (datestrig[0].Split('-').Length > 0)
            //        {
            //            string[] dates = datestrig[0].Split('-');
            //            string[] times = datestrig[1].Split(':');
            //            todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
            //        }
            //    }
                TimeSpan dateSpan = todate.Subtract(fromdate);
                int NoOfdays = dateSpan.Days;
                NoOfdays = NoOfdays + 2;
                lblFromDate.Text = fromdate.ToString("dd/MMM/yyyy");
                lbltodate.Text = todate.ToString("dd/MMM/yyyy");
                Label.Text = ddlbranches.SelectedItem.Text;
            
            lblHeading.Text = ddlbranches.SelectedItem.Text + " Salary Advance Report " ;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');            
            Session["filename"] = ddlbranches.SelectedItem.Text + "Salary Advance Report " ;
            Session["title"] = ddlbranches.SelectedItem.Text + " Salary Advance Report "  ;
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Amount").DataType = typeof(double);
            //Report.Columns.Add("REMARKS");
            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, salaryadvance.amount, employebankdetails.paymenttype, employebankdetails.employeid, pay_structure.profitionaltax, pay_structure.gross, pay_structure.salaryperyear FROM  employedetails INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN  pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN salaryadvance ON employedetails.empid = salaryadvance.empid WHERE (employedetails.branchid = @BranchID) AND (salaryadvance.amount <>'0') AND (salaryadvance.month=@month) AND (salaryadvance.year=@year)");
            cmd.Parameters.Add("@BranchID",ddlbranches.SelectedValue);
            cmd.Parameters.Add("@month", ddlmonth.SelectedItem.Value);
            cmd.Parameters.Add("@year", ddlyear.SelectedItem.Value);
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Amount"] = dr["amount"].ToString();
                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Name"] = "Total Amount";
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
                    lblmsg.Text = "No data  found";
                    hidepanel.Visible = false;
                }
            }

            else
            {
                lblmsg.Text = "No data were found";
                hidepanel.Visible = false;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[2].Text == "Total Amount")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
            //if (e.Row.Cells[3].Text == "Grand Total")
            //{
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }

}