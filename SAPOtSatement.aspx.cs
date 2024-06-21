using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class SAPOtSatement : System.Web.UI.Page
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
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    fillbranch();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
                }
            }
        }

    }
    void fillbranch()
    {
        //if (BranchID == "1")
        // {
        //branchwise
        // cmd = new SqlCommand("SELECT  branchid, branchname, address, phone, emailid, statename FROM  branchmaster where branchmaster.company_code='1' and ((branchtype='SalesOffice')or(branchtype='plant'))");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) and ((branchtype='SalesOffice')or(branchtype='plant'))");
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
            string talydate = dt.ToString("dd-MMM-yy");
            string namonth = dt.ToString("MMM-yy");
            lblHeading.Text = ddlbranches.SelectedItem.Text + " SAP OT Statement Report" + " " + ddlmonth.SelectedItem.Text + year;
            lblFromDate.Text = mymonth;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            Session["xporttype"] = "Tally Conveyance";
            Session["filename"] = ddlbranches.SelectedItem.Text + " SAP OT Statement " + " " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranches.SelectedItem.Text + " SAP OT Statement " + " " + ddlmonth.SelectedItem.Text + year;
            string invoivebranch = "";
            string sapcode = "";
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname, branchmaster.sapcode,branchmaster.branchcode FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
            if (dtcompany.Rows.Count > 0)
            {
                lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
                invoivebranch = dtcompany.Rows[0]["branchcode"].ToString();
                sapcode = dtcompany.Rows[0]["sapcode"].ToString();
            }
            else
            {
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
            }
            string invoice = "" + invoivebranch + "EXJV" + mymonth + "";
            Report.Columns.Add("SNO");
            Report.Columns.Add("EmployeeCode");
            Report.Columns.Add("Name");
            Report.Columns.Add("Designation");
            Report.Columns.Add("GROSS").DataType = typeof(double);
            Report.Columns.Add("EXTRADAYS").DataType = typeof(double);
            Report.Columns.Add("EXTRADAYS Pay").DataType = typeof(double);
            Report.Columns.Add("BankAccNo");
            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.fromdate, branchmaster.todate, monthly_attendance.extradays, monthly_attendance.clorwo, designation.designation, monthly_attendance.numberofworkingdays, monthly_attendance.lop, departments.department, salaryappraisals.gross, salaryappraisals.salaryperyear FROM departments INNER JOIN monthly_attendance INNER JOIN designation INNER JOIN employedetails ON designation.designationid = employedetails.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid ON monthly_attendance.empid = employedetails.empid ON  departments.deptid = employedetails.employee_dept INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON monthly_attendance.empid = employebankdetails.employeid WHERE (monthly_attendance.extradays <> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type <> 'Driver') AND (employedetails.employee_type <> 'Cleaner') AND (employedetails.employee_type <> 'Canteen') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) AND (employedetails.status = 'No') OR (monthly_attendance.extradays <> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)  AND (employedetails.employee_type <> 'Driver') AND (employedetails.employee_type <> 'Cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) AND (employedetails.status = 'No') ORDER BY departments.department");
            //cmd = new SqlCommand("SELECT employebankdetails.accountno, designation.designation, monthly_attendance.clorwo,monthly_attendance.numberofworkingdays, monthly_attendance.lop,employebankdetails.ifsccode, employedetails.employee_num, employedetails.fullname, pay_structure.gross, monthly_attendance.extradays, monthly_attendance.otdays, branchmaster.branchname, branchmaster.fromdate, branchmaster.todate FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND  (monthly_attendance.extradays <> 0)");
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employebankdetails.accountno, branchmaster.fromdate, branchmaster.todate, designation.designation, monthly_attendance.numberofworkingdays, monthly_attendance.lop, pay_structure.gross, departments.department, monthly_attendance.extradays FROM departments INNER JOIN monthly_attendance INNER JOIN designation INNER JOIN employedetails ON designation.designationid = employedetails.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid ON monthly_attendance.empid = employedetails.empid ON departments.deptid = employedetails.employee_dept LEFT OUTER JOIN employebankdetails ON monthly_attendance.empid = employebankdetails.employeid WHERE  (monthly_attendance.extradays<> 0) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@d1", date);
            cmd.Parameters.Add("@branchid", ddlbranches.SelectedItem.Value);
            DataTable dtAdvance = SalesDB.SelectQuery(cmd).Tables[0];
            if (dtAdvance.Rows.Count > 0)
            {
                var i = 1;
                foreach (DataRow dr in dtAdvance.Rows)
                {
                    string from = dr["fromdate"].ToString();
                    string to = dr["todate"].ToString();
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["EmployeeCode"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Designation"] = dr["designation"].ToString();
                    newrow["BankAccNo"] = dr["accountno"].ToString();
                    string ot = dr["extradays"].ToString();
                    double numberofworkingdays = 0;
                    double daysinmonth = 0;
                    double.TryParse(dr["numberofworkingdays"].ToString(), out numberofworkingdays);
                    double clorwo = 0;
                    double.TryParse(dr["clorwo"].ToString(), out clorwo);
                    daysinmonth = numberofworkingdays + clorwo;
                    double otdays = 0;
                    // int noofdays = 0;
                    if (numberofworkingdays == 0.0)
                    {
                        numberofworkingdays = 1;
                    }
                    if (ot == null || ot == "")
                    {
                        otdays = 0;
                    }
                    else
                    {
                        if (ddlbranches.SelectedItem.Text == "Chennai SO")
                        {
                            otdays = Convert.ToDouble(dr["extradays"].ToString());
                        }
                        else
                        {
                            otdays = Convert.ToDouble(dr["extradays"].ToString());
                        }
                    }
                    double monthsal = Convert.ToDouble(dr["gross"].ToString());
                    double perdayamt = monthsal / daysinmonth;
                    double otvalue = perdayamt * otdays;
                    newrow["EXTRADAYS"] = otdays;
                    newrow["EXTRADAYS Pay"] = Math.Round(otvalue, 0);
                    newrow["GROSS"] = dr["gross"].ToString();

                    Report.Rows.Add(newrow);
                }
                DataRow newTotal = Report.NewRow();
                newTotal["DESIGNATION"] = "Total";
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
                dtnew.Columns.Add("WH Code");
                dtnew.Columns.Add("Ledger Code");
                dtnew.Columns.Add("Ledger Name");
                dtnew.Columns.Add("Amount");
                dtnew.Columns.Add("Narration");
                string designation = "Total";
                var k = 1;
                string narration = "";
                cmd = new SqlCommand("SELECT groupledgername.ledgername, groupledgername.ledgercode,groupledgername.glcodesno, glgroup.glname,glgroup.sno FROM glgroup INNER JOIN groupledgername ON glgroup.sno = groupledgername.glcodesno WHERE (groupledgername.branchid = @BranchID)");
                cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
                DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
                DataRow nr_sp = dtnew.NewRow();
                nr_sp["Invoice"] = invoice;
                nr_sp["JV Date"] = talydate;
                string salaryot = "9";
                string salot_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + salaryot + "'"))
                {
                    salot_ledgr = dr["ledgername"].ToString();
                    nr_sp["Ledger Code"] = dr["ledgercode"].ToString();
                    
                }
                nr_sp["WH Code"] = sapcode;
                nr_sp["Ledger Name"] = salot_ledgr;

                //nr_sp["Ledger Name"] = "Salary OT - " + ddlbranches.SelectedItem.Text + "";
                string amt = val.ToString();
                string amount = "-" + amt + "";
                nr_sp["Amount"] = amount;
                narration = "Being The SVDS " + ddlbranches.SelectedItem.Text + " salaries For the Month Of " + namonth + ", Total Amount=" + amt + "/-";
                nr_sp["Narration"] = narration;
                dtnew.Rows.Add(nr_sp);

                DataRow nd_sp = dtnew.NewRow();
                nd_sp["Invoice"] = invoice;
                nd_sp["JV Date"] = talydate;
                string otpayble = "10";
                string ot_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + otpayble + "'"))
                {
                    ot_ledgr = dr["ledgername"].ToString();
                    nd_sp["Ledger Code"] = dr["ledgercode"].ToString();
                }
                nd_sp["WH Code"] = sapcode;
                nd_sp["Ledger Name"] = ot_ledgr;
                // nd_sp["Ledger Name"] = "Salary OT Payble - " + ddlbranches.SelectedItem.Text + "";
                string damt = val.ToString();
                nd_sp["Amount"] = damt;
                narration = "Being The SVDS " + ddlbranches.SelectedItem.Text + " salaries For the Month Of " + namonth + ", Total Amount=" + damt + "/-";
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
        }
    }
    SqlCommand sqlcmd;
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        try
        {
            DBManager SalesDB = new DBManager();
            DateTime CreateDate = DBManager.GetTime(vdm.conn);
            SAPdbmanger SAPvdm = new SAPdbmanger();

            DateTime fromdate = DateTime.Now;
            DataTable dt = (DataTable)Session["xportdata"];
            foreach (DataRow dr in dt.Rows)
            {
                string AcctCode = dr["Ledger Code"].ToString();
                string whcode = dr["WH Code"].ToString();

                if (AcctCode == "" && whcode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OCRCODE, Series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OCRCODE, @Series)");
                    sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@Ref1", dr["Invoice"].ToString());
                    sqlcmd.Parameters.Add("@OCRCODE", dr["WH Code"].ToString());
                   // int TransNo = 1;
                    sqlcmd.Parameters.Add("@Series", "17");
                    sqlcmd.Parameters.Add("@TransNo", dr["Invoice"].ToString());
                    sqlcmd.Parameters.Add("@AcctCode", dr["Ledger Code"].ToString());
                    sqlcmd.Parameters.Add("@AcctName", dr["Ledger Name"].ToString());
                    double amount = 0;
                    double.TryParse(dr["Amount"].ToString(), out amount);
                    if (amount < 0)
                    {
                        amount = Math.Abs(amount);
                        double Debit = 0;
                        sqlcmd.Parameters.Add("@Debit", Debit);
                        sqlcmd.Parameters.Add("@Credit", amount);
                    }
                    else
                    {
                        amount = Math.Abs(amount);
                        double Credit = 0;
                        sqlcmd.Parameters.Add("@Debit", amount);
                        sqlcmd.Parameters.Add("@Credit", Credit);
                    }
                    string B1Upload = "N";
                    string Processed = "N";
                    sqlcmd.Parameters.Add("@B1Upload", B1Upload);
                    sqlcmd.Parameters.Add("@Processed", Processed);
                    SAPvdm.insert(sqlcmd);
                }
            }
            DataTable dtempty = new DataTable();
            grdReports.DataSource = dtempty;
            grdReports.DataBind();
            lblmsg.Text = "Successfully Saved";
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.ToString();
        }
    }
}