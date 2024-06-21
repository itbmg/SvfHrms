using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class tallyconveyance : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["branchid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            BranchID = Session["branchid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {
                    DateTime dtfrom = DateTime.Now.AddMonths(0);
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    FillBranches();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
                }
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
            hidepanel.Visible = true;
            hidepanel.Visible = true;
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            // lblmsg.Text = "";
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = "";
            if (mymonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (mydate.Day).ToString();
            }
            //string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            DateTime dt = Convert.ToDateTime(date);
            DateTime txttdate = DateTime.Now;
            string[] datestrig = dtp_FromDate.Text.Split(' ');
            if (datestrig.Length > 1)
            {
                if (datestrig[0].Split('-').Length > 0)
                {
                    string[] dates = datestrig[0].Split('-');
                    string[] times = datestrig[1].Split(':');
                    txttdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                }
            }
            string talydate = txttdate.ToString("dd-MMM-yy");
            string namonth = dt.ToString("MMM-yy");
            lblHeading.Text = ddlbranches.SelectedItem.Text + " Tally Conveyance Statement Report" + " " + ddlmonth.SelectedItem.Text + year;
            lblFromDate.Text = mymonth;
            DateTime dtfrom = fromdate;
            Session["xporttype"] = "TallyOTSalarys";
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            Session["filename"] = ddlbranches.SelectedItem.Text + "Tally Conveyance Statement " + " " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranches.SelectedItem.Text + " Tally Conveyance Statement " + " " + ddlmonth.SelectedItem.Text + year;
            string invoivebranch = "";
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname, branchmaster.branchcode FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
            if (dtcompany.Rows.Count > 0)
            {
                lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
                invoivebranch = dtcompany.Rows[0]["branchcode"].ToString();
            }
            else
            {
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
            }
            string invoice = "" + invoivebranch + "CJV" + mymonth + "";
            string[] str = frmdate.Split('/');
            if (mymonth == "12")
            {
                cmd = new SqlCommand("select * from monthly_attendance where year=@year");
                cmd.Parameters.Add("@year", str[2]);
                DataTable dtyear = vdm.SelectQuery(cmd).Tables[0];
                if (dtyear.Rows.Count > 0)
                {

                }
                else
                {
                    string preyear = str[2];
                    int salyear = Convert.ToInt32(preyear);
                    int currentyear = salyear - 1;
                    str[2] = currentyear.ToString();
                }
            }
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("Fixed Conveyance").DataType = typeof(double);
            //Report.Columns.Add("Attendance Days").DataType = typeof(double);
            Report.Columns.Add("CONVEYANCE").DataType = typeof(double);
            Report.Columns.Add("Bank Acc NO");
            Report.Columns.Add("IFSC Code");

            cmd = new SqlCommand("SELECT employedetails.employee_num, monthly_attendance.convenancedays, employedetails.fullname, employedetails.employee_type, designation.designation, employebankdetails.accountno,  employebankdetails.ifsccode, monthly_attendance.numberofworkingdays, monthly_attendance.clorwo, monthly_attendance.lop, monthly_attendance.month, monthly_attendance.year, salaryappraisals.travelconveyance, departments.department  FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid WHERE  (employedetails.status = 'NO') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchID) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) AND (salaryappraisals.travelconveyance > 0) OR (employedetails.status = 'NO') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchID)  AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) AND (salaryappraisals.travelconveyance > 0)");
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, pay_structure.travelconveyance, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.numberofworkingdays, monthly_attendance.clorwo, monthly_attendance.lop, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid WHERE (employedetails.branchid = @branchID) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (pay_structure.travelconveyance > 0) and (employedetails.status='NO')");
            cmd.Parameters.Add("@branchID", ddlbranches.SelectedValue);
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@d1", date);
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Designation"] = dr["designation"].ToString();
                    //newrow["CONVEYANCE"] = dr["travelconveyance"].ToString();
                    newrow["Bank Acc NO"] = dr["accountno"].ToString();
                    newrow["IFSC Code"] = dr["ifsccode"].ToString();
                    //newrow["REMARKS"] = dr["remarks"].ToString();
                    Report.Rows.Add(newrow);
                    foreach (DataRow dra in dtAdvance.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                    {

                        double numberofworkingdays = 0;
                        double.TryParse(dr["numberofworkingdays"].ToString(), out numberofworkingdays);
                        double clorwo = 0;
                        double.TryParse(dr["clorwo"].ToString(), out clorwo);
                        double totldays = 0;
                        double travelconveyance = 0;
                        double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
                        double lop = 0;
                        double.TryParse(dra["lop"].ToString(), out lop);
                        double days = 0;
                        days = numberofworkingdays + clorwo;
                        totldays = days - lop;
                        //totamount = Math.Ceiling(totamount);
                        //newrow["Attendance Days"] = totldays.ToString();
                        newrow["Fixed Conveyance"] = travelconveyance.ToString();
                        double totamount = 0;
                        double perdaycost = 0;
                        perdaycost = travelconveyance / days;
                        double convenancedays = 0;
                        double.TryParse(dr["convenancedays"].ToString(), out convenancedays);
                      //  convenancedays
                        totamount = convenancedays * perdaycost;
                        //double convency = 0;
                        //convency = travelconveyance - lop;
                        newrow["CONVEYANCE"] = Math.Round(totamount);
                    }
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

                DataTable dtnew = new DataTable();
                dtnew.Columns.Add("Invoice");
                dtnew.Columns.Add("JV Date");
                dtnew.Columns.Add("Ledger Name");
                dtnew.Columns.Add("Amount");
                dtnew.Columns.Add("Narration");
                string designation = "Total";
                var k = 1;
                string narration = "";
                cmd = new SqlCommand("SELECT groupledgername.ledgername, groupledgername.ledgercode, groupledgername.glcodesno, glgroup.glname,glgroup.sno FROM glgroup INNER JOIN groupledgername ON glgroup.sno = groupledgername.glcodesno  WHERE (groupledgername.branchid = @BranchID)");
                cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
                DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
                DataRow nr_sp = dtnew.NewRow();
                nr_sp["Invoice"] = invoice;
                nr_sp["JV Date"] = talydate;
                string connvencepayble = "11";
                string conv_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + connvencepayble + "'"))
                {
                    conv_ledgr = dr["ledgername"].ToString();
                }
                nr_sp["Ledger Name"] = conv_ledgr;
                //nr_sp["Ledger Name"] = "Conveyance Payble - " + ddlbranches.SelectedItem.Text + "";
                string amt = val.ToString();
                string amount = "-" + amt + "";
                nr_sp["Amount"] = amount;
                narration = "Being The SVDS " + ddlbranches.SelectedItem.Text + " Conveyance For the Month Of " + namonth + ", Total Amount=" + amt + "/-";
                nr_sp["Narration"] = narration;
                dtnew.Rows.Add(nr_sp);
                DataRow nd_sp = dtnew.NewRow();
                nd_sp["Invoice"] = invoice;
                nd_sp["JV Date"] = talydate;
                string connvencefixced = "12";
                string convfix_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + connvencefixced + "'"))
                {
                    convfix_ledgr = dr["ledgername"].ToString();
                }
                nd_sp["Ledger Name"] = convfix_ledgr;
                //nd_sp["Ledger Name"] = "Conveyance Fixed  - " + ddlbranches.SelectedItem.Text + "";
                string damt = val.ToString();
                nd_sp["Amount"] = damt;
                narration = "Being The SVDS " + ddlbranches.SelectedItem.Text + " Conveyance For the Month Of " + namonth + ", Total Amount=" + damt + "/-";
                nd_sp["Narration"] = narration;
                dtnew.Rows.Add(nd_sp);

                grdReports.DataSource = dtnew;
                grdReports.DataBind();
                Session["xportdata"] = dtnew;
                hidepanel.Visible = true;
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
            if (e.Row.Cells[3].Text == "Total")
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