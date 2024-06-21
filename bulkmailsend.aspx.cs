using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using iTextSharp.text.pdf;
using iTextSharp.text;
using System.IO;
using System.Net;
using System.Net.Mail;

public partial class bulkmailsend : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;
    string joindate = "";
    string desigiation = "";
    string depatment = "";
    string accountno = "";
    string bank = "";
    string pfn = "";
    string uan = "";
    string esin = "";
    string branch = "";
    string titlename = "";
    string payyearsal = "";
    byte[] data;
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
                binddepartments();
                if (!Page.IsCallback)
                {
                    string mainbranch = Session["mainbranch"].ToString();
                    if (mainbranch == "42")
                    {
                        btngenerate.Visible = true;
                        btnmnthgenerate.Visible = false;
                    }
                    else
                    {
                        btngenerate.Visible = false;
                        btnmnthgenerate.Visible = true;
                    }
                }
            }
        }
    }

    public void binddepartments()
    {
        cmd = new SqlCommand("SELECT deptid, department, status FROM departments  order by department");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddldepartment.DataSource = dttrips;
        ddldepartment.DataTextField = "department";
        ddldepartment.DataValueField = "deptid";
        ddldepartment.DataBind();
    }


    public void bindemployedetails()
    {
        //bramchmapping
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.email, departments.deptid, branchmaster.branchid, employedetails.employee_num, employedetails.fullname, branchmaster.branchname, departments.department FROM employedetails INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.employee_dept = @empdept) AND (branchmapping.mainbranch = @m) AND (employedetails.status = 'No')");
        cmd.Parameters.Add("@m", mainbranch);
        //branchwise
        //cmd = new SqlCommand("SELECT employedetails.empid, employedetails.email, departments.deptid,branchmaster.branchid,employedetails.employee_num,employedetails.fullname,branchmaster.branchname,departments.department FROM employedetails INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (employedetails.employee_dept = @empdept)");
        cmd.Parameters.Add("@empdept", ddldepartment.SelectedItem.Value);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        GridView2.DataSource = dttrips;
        GridView2.DataBind();
    }

    protected void ddldepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindemployedetails();
    }

    protected void RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Attributes.Add("onmouseover", "MouseEvents(this, event)");
            e.Row.Attributes.Add("onmouseout", "MouseEvents(this, event)");
        }
    }

    protected void btn_generate_click(object sender, EventArgs e)
    {
        try
        {
            foreach (GridViewRow row in GridView2.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    CheckBox ChkBoxHeader = (CheckBox)GridView2.HeaderRow.FindControl("checkAll");
                    //CheckBox chkRow = (CheckBox)row.FindControl("checkAll"); 
                    CheckBox cc = (CheckBox)row.FindControl("CheckBox1");
                    Label lblid = (Label)row.FindControl("lblempid");
                    if (cc.Checked == true)
                    {
                        //do calculation with other controls in the row
                        try
                        {
                            vdm = new DBManager();
                            string empid = lblid.Text;
                            string emptype = "";
                            string mainbranch = Session["mainbranch"].ToString();
                            string noofmonths = ddlmonth.SelectedItem.Value;
                            string branchid = Session["branchid"].ToString();
                            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                            DateTime dtfromdate = ServerDateCurrentdate;
                            DateTime dttodate = ServerDateCurrentdate;
                            string amonth = "";
                            string ayear = "";
                            string otdays = "";
                            string bid = "";
                            //string statename = "";
                            double canteendeduction = 0;
                            double mobilededuction = 0;
                            double salaryadvance = 0;
                            double msal = 0;
                            double otvalue = 0;
                            double loan = 0;
                            double sal = 0;
                            double grossbasic = 0;
                            double erbasic = 0;
                            double providentfound = 0;
                            double professionaltax = 0;
                            double esi = 0;
                            double canten = 0;
                            double incometax = 0;
                            double medical = 0;
                            double medicalallavance = 0;
                            double conveyanceallavance = 0;
                            double washingallowance = 0;
                            double grossmedicalallavance = 0;
                            double conveyance = 0;
                            double grossconveyanceallavance = 0;
                            double washing = 0;
                            double grosswashingallowance = 0;
                            double grosshra = 0;
                            double hre = 0;
                            double totalernings = 0;
                            double grosstotalernings = 0;
                            double totaldeduction = 0;
                            double netsal = 0;
                            double losofprofitionaltax = 0;
                            double pt = 0;
                            double medicalcilam = 0;
                            double otherdeduction = 0;
                            double tdsdeduction = 0;
                            cmd = new SqlCommand("SELECT branchid From employedetails where empid=@eid");
                            cmd.Parameters.Add("@eid", empid);
                            DataTable dtbranches = vdm.SelectQuery(cmd).Tables[0];
                            if (dtbranches.Rows.Count > 0)
                            {
                                bid = dtbranches.Rows[0]["branchid"].ToString();
                            }
                            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE branchmaster.branchid= @branchid");
                            cmd.Parameters.Add("@branchid", mainbranch);
                            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
                            if (dtcompany.Rows.Count > 0)
                            {
                                Session["TitleName"] = dtcompany.Rows[0]["companyname"].ToString();
                                Session["Address"] = dtcompany.Rows[0]["address"].ToString();
                            }
                            cmd = new SqlCommand("SELECT fromdate, todate FROM branchmaster where branchid=@branchid");
                            cmd.Parameters.Add("@branchid", bid);
                            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
                            int noofmnts = Convert.ToInt32(noofmonths);
                            int i = 0;
                            for (i = 1; i <= noofmnts; i++)
                            {
                                if (dtroutes.Rows.Count > 0)
                                {
                                    DateTime fromdate = ServerDateCurrentdate;
                                    //DateTime todate = DateTime.Now;
                                    if (i == 1)
                                    {
                                        DateTime dtfrom = fromdate.AddMonths(-1);
                                        string frmdate = dtfrom.ToString("MM/dd/yyyy");
                                        string[] str = frmdate.Split('/');
                                        int lastmonth = Convert.ToInt32(dtroutes.Rows[0]["fromdate"].ToString());
                                        int years = Convert.ToInt32(str[2]);
                                        int months = Convert.ToInt32(str[0]);
                                        dtfromdate = new DateTime(years, months, lastmonth);
                                        amonth = str[0];
                                        ayear = str[2];
                                        DateTime dtto = DateTime.Now;
                                        // if(branchid==""
                                        if (mainbranch == "42")
                                        {
                                            dtto = dtfromdate.AddMonths(1);
                                        }
                                        else
                                        {
                                            dtto = dtfromdate.AddMonths(-1);
                                            dtfromdate = dtto;
                                            dtfromdate = dtto.AddMonths(1);
                                        }

                                        string todate = dtto.ToString("MM/dd/yyyy");
                                        string[] strto = todate.Split('/');
                                        int prasentdate = Convert.ToInt32(dtroutes.Rows[0]["todate"].ToString());
                                        int prasentyears = Convert.ToInt32(strto[2]);
                                        int prasentmonths = Convert.ToInt32(strto[0]);
                                        dttodate = new DateTime(prasentyears, prasentmonths, prasentdate);
                                    }
                                    else
                                    {
                                        DateTime dtfrom = fromdate.AddMonths(-i);
                                        string frmdate = dtfrom.ToString("MM/dd/yyyy");
                                        string[] str = frmdate.Split('/');
                                        int lastmonth = Convert.ToInt32(dtroutes.Rows[0]["fromdate"].ToString());
                                        int years = Convert.ToInt32(str[2]);
                                        int months = Convert.ToInt32(str[0]);
                                        dtfromdate = new DateTime(years, months, lastmonth);
                                        amonth = str[0];
                                        ayear = str[2];
                                        int k = i - 1;
                                        DateTime dtto = fromdate.AddMonths(-k);
                                        string todate = dtto.ToString("MM/dd/yyyy");
                                        string[] strto = todate.Split('/');
                                        int prasentdate = Convert.ToInt32(dtroutes.Rows[0]["todate"].ToString());
                                        int prasentyears = Convert.ToInt32(strto[2]);
                                        int prasentmonths = Convert.ToInt32(strto[0]);
                                        dttodate = new DateTime(prasentyears, prasentmonths, prasentdate);
                                    }
                                }
                                DateTime dtstartingmontm = dtfromdate.AddMonths(i);
                                //paystrure
                                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.pancard,employedetails.email, employedetails.empid, employepfdetails.estnumber, employedetails.salarymode, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, pay_structure.salaryperyear, employedetails.joindate, branchmaster.branchname, employepfdetails.pfnumber, employepfdetails.uannumber, employedetails.pancard, employebankdetails.accountno, designation.designation, departments.department, bankmaster.bankname  FROM employebankdetails LEFT OUTER JOIN bankmaster ON employebankdetails.bankid = bankmaster.sno INNER JOIN employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid ON employebankdetails.employeid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (employedetails.empid = @empid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                                cmd = new SqlCommand("SELECT  employedetails.employee_num, employedetails.employee_type, employedetails.pancard, employedetails.email, employedetails.empid, employepfdetails.estnumber, employedetails.salarymode, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, employedetails.joindate, branchmaster.branchname, employepfdetails.pfnumber, employepfdetails.uannumber, employedetails.pancard AS Expr1, employebankdetails.accountno, designation.designation, departments.department, bankmaster.bankname, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM  employebankdetails LEFT OUTER JOIN  bankmaster ON employebankdetails.bankid = bankmaster.sno INNER JOIN employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN  departments ON employedetails.employee_dept = departments.deptid ON employebankdetails.employeid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (employedetails.empid = @empid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.empid = @empid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                                cmd.Parameters.Add("@empid", empid);
                                cmd.Parameters.Add("@month", amonth);
                                cmd.Parameters.Add("@year", ayear);
                                cmd.Parameters.Add("@d1", dtstartingmontm);
                                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                                foreach (DataRow dr in routes.Rows)
                                {
                                    emptype = dr["employee_type"].ToString();
                                    cmd = new SqlCommand("SELECT deductionamount from mobile_deduction where empid=@eempid AND month = @emonth AND year= @eyear");
                                    cmd.Parameters.Add("@eempid", empid);
                                    cmd.Parameters.Add("@emonth", amonth);
                                    cmd.Parameters.Add("@eyear", ayear);
                                    DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtmobile.Rows.Count > 0)
                                    {
                                        foreach (DataRow drmobile in dtmobile.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drmobile["deductionamount"].ToString(), out amount);
                                            mobilededuction = Convert.ToDouble(amount);
                                            mobilededuction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        mobilededuction = 0;
                                    }
                                    cmd = new SqlCommand("SELECT amount from canteendeductions where empid=@cempid AND month = @cmonth AND year= @cyear");
                                    cmd.Parameters.Add("@cempid", empid);
                                    cmd.Parameters.Add("@cmonth", amonth);
                                    cmd.Parameters.Add("@cyear", ayear);
                                    DataTable dtcantenn = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtcantenn.Rows.Count > 0)
                                    {
                                        foreach (DataRow drcanteen in dtcantenn.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drcanteen["amount"].ToString(), out amount);
                                            canteendeduction = Convert.ToDouble(amount);
                                            canteendeduction = Math.Round(amount, 0);

                                        }
                                    }
                                    else
                                    {
                                        canteendeduction = 0;
                                    }

                                    cmd = new SqlCommand("SELECT amount from salaryadvance where empid=@Sempid AND month = @Smonth AND year= @Syear");
                                    cmd.Parameters.Add("@Sempid", empid);
                                    cmd.Parameters.Add("@Smonth", amonth);
                                    cmd.Parameters.Add("@Syear", ayear);
                                    DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtsalary.Rows.Count > 0)
                                    {
                                        foreach (DataRow drsa in dtsalary.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drsa["amount"].ToString(), out amount);
                                            salaryadvance = Convert.ToDouble(amount);
                                            salaryadvance = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        salaryadvance = 0;
                                    }


                                    cmd = new SqlCommand("Select loanemimonth from loan_request where empid=@eid and month=@lmonth and year=@lyear");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@lmonth", amonth);
                                    cmd.Parameters.Add("@lyear", ayear);
                                    DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtloan.Rows.Count > 0)
                                    {
                                        foreach (DataRow drloan in dtloan.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drloan["loanemimonth"].ToString(), out amount);
                                            loan = Convert.ToDouble(amount);
                                            loan = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        loan = 0;
                                    }

                                    cmd = new SqlCommand("Select medicliamamount from mediclaimdeduction where empid=@eid and flag='1' ");
                                    //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid) AND (mediclaimdeduction.month = @month) AND (mediclaimdeduction.year = @year)");
                                    cmd.Parameters.Add("@eid", empid);
                                    //cmd.Parameters.Add("@mmonth", amonth);
                                    //cmd.Parameters.Add("@myear", ayear);
                                    DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtmedicliam.Rows.Count > 0)
                                    {
                                        foreach (DataRow drmediclm in dtmedicliam.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drmediclm["medicliamamount"].ToString(), out amount);
                                            medicalcilam = Convert.ToDouble(amount);
                                            medicalcilam = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        medicalcilam = 0;
                                    }


                                    cmd = new SqlCommand("SELECT  otherdeductionamount from otherdeduction where empid=@eid and month=@omonth and year=@oyear");
                                    //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid) AND (mediclaimdeduction.month = @month) AND (mediclaimdeduction.year = @year)");
                                    cmd.Parameters.Add("@eid", empid);
                                    cmd.Parameters.Add("@omonth", amonth);
                                    cmd.Parameters.Add("@oyear", ayear);
                                    DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtotherdeduction.Rows.Count > 0)
                                    {
                                        foreach (DataRow drodeduction in dtotherdeduction.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drodeduction["otherdeductionamount"].ToString(), out amount);
                                            otherdeduction = Convert.ToDouble(amount);
                                            otherdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        otherdeduction = 0;
                                    }

                                    cmd = new SqlCommand("SELECT sno, employecode, tdsdeduction, month, year FROM monthlysalarystatement WHERE month=@prmonth and year=@pryear and empid=@etdsid");
                                    cmd.Parameters.Add("@prmonth", amonth);
                                    cmd.Parameters.Add("@pryear", ayear);
                                    cmd.Parameters.Add("@etdsid", empid);
                                    DataTable dtprevtds = vdm.SelectQuery(cmd).Tables[0];
                                    if (dtprevtds.Rows.Count > 0)
                                    {
                                        foreach (DataRow drtddeduction in dtprevtds.Rows)
                                        {
                                            double amount = 0;
                                            double.TryParse(drtddeduction["tdsdeduction"].ToString(), out amount);
                                            tdsdeduction = Convert.ToDouble(amount);
                                            tdsdeduction = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {

                                        cmd = new SqlCommand("SELECT  tdsamount from tds_deduction where empid=@eid");
                                        //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid) AND (mediclaimdeduction.month = @month) AND (mediclaimdeduction.year = @year)");
                                        cmd.Parameters.Add("@eid", empid);
                                        //cmd.Parameters.Add("@tmonth", amonth);
                                        //cmd.Parameters.Add("@tyear", ayear);
                                        DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];
                                        if (dttdsdeduction.Rows.Count > 0)
                                        {
                                            foreach (DataRow drtddeduction in dttdsdeduction.Rows)
                                            {
                                                double amount = 0;
                                                double.TryParse(drtddeduction["tdsamount"].ToString(), out amount);
                                                tdsdeduction = Convert.ToDouble(amount);
                                                tdsdeduction = Math.Round(amount, 0);
                                            }
                                        }
                                        else
                                        {
                                            tdsdeduction = 0;
                                        }
                                    }

                                    //getsaldetails.salaryadvance = "3000";
                                    string empsno = empid;
                                    string emalid = dr["email"].ToString();
                                    string empname = dr["fullname"].ToString();
                                    string statename = dr["statename"].ToString();
                                    string joidate = dr["joindate"].ToString();
                                    string pannumbr = dr["pancard"].ToString();
                                    string desigination = dr["designation"].ToString();
                                    string department = dr["department"].ToString();
                                    string bankname = dr["bankname"].ToString();
                                    string accountnumber = dr["accountno"].ToString();
                                    string Location = dr["branchname"].ToString();
                                    string PFNO = dr["pfnumber"].ToString();
                                    string PFUAN = dr["uannumber"].ToString();
                                    string ESINo = dr["estnumber"].ToString();
                                    string pfeligible = dr["pfeligible"].ToString();
                                    string esieligible = dr["esieligible"].ToString();
                                    string salarymode = dr["salarymode"].ToString();
                                    string employeid = dr["employee_num"].ToString();
                                    //getsaldetails.month = dr["month"].ToString();
                                    int year = Convert.ToInt32(dr["year"].ToString());
                                    int month = Convert.ToInt32(dr["month"].ToString());
                                    string strMonthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(month);
                                    string MonthName = strMonthName;
                                    double days = Convert.ToDouble(dr["lop"].ToString());
                                    //int daysInmonth = DateTime.DaysInMonth(year, month);
                                    //string year = dr["year"].ToString();
                                    double NrOfDays = 0;
                                    if (mainbranch == "42")
                                    {
                                        TimeSpan t = dttodate - dtfromdate;
                                        NrOfDays = t.TotalDays;
                                    }
                                    else
                                    {
                                        TimeSpan t = dtfromdate - dttodate;
                                        NrOfDays = t.TotalDays;
                                    }

                                    //double NrOfDays = Convert.ToDouble(t);
                                    string daysinmonth = NrOfDays.ToString();
                                    List<DateTime> dates = new List<DateTime>();
                                    int countsundays = 0;
                                    countsundays = Convert.ToInt32(dr["clorwo"].ToString());
                                    double noofsundays = countsundays;
                                    double effectiveworkingdays = NrOfDays - noofsundays;
                                    double noofdays = Convert.ToDouble(days);
                                    double totaldays = NrOfDays;
                                    string cloroff = countsundays.ToString();
                                    string noofworkingdays = effectiveworkingdays.ToString();
                                    string noofdayspaid = (effectiveworkingdays - noofdays).ToString();
                                    double dayspaid = effectiveworkingdays - noofdays;
                                    double effectiveworkdays = dayspaid + countsundays;
                                    string effectivedays = effectiveworkdays.ToString();
                                    string lop = days.ToString();
                                    double lossofpay = Convert.ToDouble(lop);
                                    string salary = dr["salaryperyear"].ToString();
                                    double grosssal = Convert.ToDouble(dr["salaryperyear"].ToString());
                                    double monthsalary = grosssal / 12;
                                    monthsalary = Math.Round(monthsalary, 2);
                                    string monthsal = monthsalary.ToString();
                                    msal = monthsalary;
                                    // getsaldetails.attandancedays = monthsalary.ToString();
                                    double otval = Convert.ToDouble(20000);
                                    double paydays = totaldays - days;
                                    if (monthsalary < otval)
                                    {
                                        otdays = dr["otdays"].ToString();
                                    }
                                    else
                                    {
                                        otdays = "0";
                                    }
                                    if (salarymode == "0")
                                    {
                                        if (lop == "0")
                                        {
                                            msal = Convert.ToDouble(monthsal);
                                            double perdayamount = msal / NrOfDays;
                                            double lossofamount = lossofpay * perdayamount;
                                            double totalsal = msal - lossofamount;
                                            otvalue = Convert.ToDouble(otdays) * perdayamount;
                                            sal = 50;
                                            grossbasic = (msal * sal) / 100;
                                            erbasic = Math.Round(totalsal * sal) / 100;
                                            providentfound = 0;
                                            esi = 0;
                                            if (pfeligible == "No")
                                            {
                                                providentfound = 0;
                                            }
                                            else
                                            {
                                                double pf = 6;
                                                providentfound = Math.Round(totalsal * pf) / 100;
                                                if (providentfound > 1800)
                                                {
                                                    providentfound = 1800;
                                                }
                                                //double pf = 12;
                                                //providentfound = Math.Round(erbasic * pf) / 100;
                                            }
                                            if (esieligible == "No")
                                            {
                                                esi = 0;
                                            }
                                            else
                                            {

                                                if (mainbranch == "42")
                                                {
                                                    if (bid == "1043" || bid == "1055" || bid == "1049" || bid == "1048" || bid == "1047")
                                                    {
                                                        if (esieligible == "Yes")
                                                        {

                                                            if (bid == "1043" || bid == "1055")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        // double esiamount = perdaysal * 5;
                                                                        //double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1.75) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    //double esiamount = rate * 5;
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1.75) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                                //newrow["ESI"] = esi;
                                                            }
                                                            if (bid == "1049" || bid == "1047")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        //double esiamount = perdaysal * 5;
                                                                        //double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1.75) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    //double esiamount = rate * 5;
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1.75) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                            }
                                                            if (bid == "1048")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        // double esiamount = perdaysal * 5;
                                                                        //double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1.75) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1.75) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                                //newrow["ESI"] = esi;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            esi = 0;
                                                            //newrow["ESI"] = esi;
                                                        }
                                                    }
                                                    else
                                                    {

                                                        if (esieligible == "Yes")
                                                        {
                                                            if (bid == "1044")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        // double esiamount = perdaysal * 4;
                                                                        // double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    // double esiamount = rate * 4;
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1) / 100;
                                                                    esi = Math.Round(esi, 0);

                                                                }
                                                                //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                                // esi = (totalearnings * 1) / 100;

                                                                //newrow["ESI"] = esi;
                                                            }
                                                            if (bid == "43" || bid == "1046")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        //double esiamount = perdaysal * 12;
                                                                        esi = (msal * 1) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                                //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                                // esi = (totalearnings * 1) / 100;

                                                                //newrow["ESI"] = esi;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            esi = 0;
                                                            //newrow["ESI"] = esi;
                                                        }

                                                    }
                                                }
                                                else
                                                {
                                                    double esiper = 1.75;
                                                    esi = Math.Round(totalsal * esiper) / 100;
                                                }
                                            }
                                            canten = Convert.ToDouble(canteendeduction);
                                            incometax = 0;
                                            medical = 1250;
                                            medicalallavance = 1250;
                                            grossmedicalallavance = 1250;

                                            conveyanceallavance = 1600;
                                            conveyance = 1600;
                                            grossconveyanceallavance = conveyance;

                                            washing = 1000;
                                            washingallowance = 1000;
                                            grosswashingallowance = washing;

                                            double tot = 0;
                                            tot = Math.Round(medical + conveyance + washing + erbasic);
                                            double ghtotal = Math.Round(grossbasic + grossconveyanceallavance + grosswashingallowance + grossmedicalallavance);
                                            grosshra = Math.Round(msal - ghtotal);
                                            hre = 0;
                                            hre = Math.Round(totalsal - tot);
                                            if (hre > 0)
                                            {
                                            }
                                            else
                                            {
                                                hre = 0;
                                            }
                                            // professionaltax = 0;
                                            if (statename == "AndraPrdesh")
                                            {
                                                if (msal > 1000 && msal <= 15000)
                                                {
                                                    professionaltax = 0;
                                                }
                                                else if (msal >= 15001 && msal <= 20000)
                                                {
                                                    professionaltax = 150;
                                                }
                                                else if (msal >= 20001)
                                                {
                                                    professionaltax = 200;
                                                }
                                            }
                                            if (statename == "Tamilnadu")
                                            {
                                                if (msal < 7000)
                                                {
                                                    professionaltax = 0;
                                                }
                                                else if (msal >= 7001 && msal <= 10000)
                                                {
                                                    professionaltax = 115;
                                                }
                                                else if (msal >= 10001 && msal <= 11000)
                                                {
                                                    professionaltax = 171;
                                                }
                                                else if (msal >= 11001 && msal <= 12000)
                                                {
                                                    professionaltax = 171;
                                                }
                                                else if (msal >= 12001)
                                                {
                                                    professionaltax = 208;
                                                }
                                            }
                                            if (statename == "karnataka")
                                            {
                                                if (msal <= 15000 && msal <= 15001)
                                                {
                                                    professionaltax = 0;
                                                }
                                                else if (msal >= 15001)
                                                {
                                                    professionaltax = 200;
                                                }
                                            }
                                            pt = professionaltax;
                                            totalernings = tot + hre;
                                            grosstotalernings = Math.Round(ghtotal + grosshra);
                                            totaldeduction = Math.Round(professionaltax + providentfound + esi + canten + salaryadvance + incometax + loan + medicalcilam + otherdeduction + tdsdeduction);
                                            netsal = Math.Round(totalernings - totaldeduction);
                                        }
                                        else
                                        {
                                            msal = Convert.ToDouble(monthsal);
                                            double perdayamount = msal / NrOfDays;
                                            double lossofamount = lossofpay * perdayamount;
                                            double totalsal = Math.Round(msal - lossofamount);
                                            otvalue = Convert.ToDouble(otdays) * perdayamount;
                                            sal = 50;
                                            grossbasic = (msal * sal) / 100;
                                            erbasic = (totalsal * sal) / 100;
                                            providentfound = 0;
                                            esi = 0;
                                            if (pfeligible == "No")
                                            {
                                                providentfound = 0;
                                            }
                                            else
                                            {
                                                double pf = 6;
                                                providentfound = Math.Round(totalsal * pf) / 100;
                                                if (providentfound > 1800)
                                                {
                                                    providentfound = 1800;
                                                }
                                                //double pf = 12;
                                                //providentfound = Math.Round(erbasic * pf) / 100;
                                            }
                                            if (esieligible == "No")
                                            {
                                                esi = 0;
                                            }
                                            else
                                            {
                                                if (mainbranch == "42")
                                                {
                                                    if (bid == "1043" || bid == "1055" || bid == "1049" || bid == "1048" || bid == "1047")
                                                    {
                                                        if (esieligible == "Yes")
                                                        {

                                                            if (bid == "1043" || bid == "1055")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        // double esiamount = perdaysal * 5;
                                                                        //double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1.75) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    //double esiamount = rate * 5;
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1.75) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                                //newrow["ESI"] = esi;
                                                            }
                                                            if (bid == "1049" || bid == "1047")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        //double esiamount = perdaysal * 5;
                                                                        //double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1.75) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    //double esiamount = rate * 5;
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1.75) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                            }
                                                            if (bid == "1048")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        // double esiamount = perdaysal * 5;
                                                                        //double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1.75) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1.75) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                                //newrow["ESI"] = esi;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            esi = 0;
                                                            //newrow["ESI"] = esi;
                                                        }
                                                    }
                                                    else
                                                    {

                                                        if (esieligible == "Yes")
                                                        {
                                                            if (bid == "1044")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        // double esiamount = perdaysal * 4;
                                                                        // double esiamount = totalearnings / 10;
                                                                        esi = (msal * 1) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    // double esiamount = rate * 4;
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1) / 100;
                                                                    esi = Math.Round(esi, 0);

                                                                }
                                                                //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                                // esi = (totalearnings * 1) / 100;

                                                                //newrow["ESI"] = esi;
                                                            }
                                                            if (bid == "43" || bid == "1046")
                                                            {
                                                                if (emptype == "Permanent" || emptype == "Staff")
                                                                {
                                                                    if (msal < 21001)
                                                                    {
                                                                        //double esiamount = perdaysal * 12;
                                                                        esi = (msal * 1) / 100;
                                                                        esi = Math.Round(esi, 0);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    double esiamount = perdayamount * paydays;
                                                                    esi = (esiamount * 1) / 100;
                                                                    esi = Math.Round(esi, 0);
                                                                }
                                                                //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                                // esi = (totalearnings * 1) / 100;

                                                                //newrow["ESI"] = esi;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            esi = 0;
                                                            //newrow["ESI"] = esi;
                                                        }

                                                    }
                                                }
                                                else
                                                {
                                                    double esiper = 1.75;
                                                    esi = Math.Round(totalsal * esiper) / 100;
                                                }
                                            }
                                            canten = Convert.ToDouble(canteendeduction);
                                            incometax = 0;

                                            medical = 1250;
                                            double perdaymedical = 1250 / NrOfDays;
                                            double lossofmedical = lossofpay * perdaymedical;
                                            medicalallavance = Math.Round(medical - lossofmedical);
                                            grossmedicalallavance = 1250;

                                            conveyance = 1600;
                                            double perdayconveyance = 1600 / NrOfDays;
                                            double lossofconveyance = lossofpay * perdayconveyance;
                                            conveyanceallavance = Math.Round(conveyance - lossofconveyance);
                                            grossconveyanceallavance = 1600;

                                            washing = 1000;
                                            double perdaywashing = 1000 / NrOfDays;
                                            double lossofwashing = lossofpay * perdaywashing;
                                            washingallowance = Math.Round(washing - lossofwashing);
                                            grosswashingallowance = 1000;


                                            double tot = 0;
                                            tot = medicalallavance + conveyanceallavance + washingallowance + erbasic;
                                            double ghtotal = grossbasic + grossconveyanceallavance + grosswashingallowance + grossmedicalallavance;
                                            grosshra = Math.Round(msal - ghtotal);
                                            hre = 0;
                                            hre = totalsal - tot;
                                            if (hre > 0)
                                            {
                                            }
                                            else
                                            {
                                                hre = 0;
                                            }
                                            professionaltax = 0;
                                            if (statename == "AndraPrdesh")
                                            {
                                                if (msal > 1000 && msal <= 15000)
                                                {
                                                    professionaltax = 0;
                                                }
                                                else if (msal >= 15001 && msal <= 20000)
                                                {
                                                    professionaltax = 150;
                                                }
                                                else if (msal >= 20001)
                                                {
                                                    professionaltax = 200;
                                                }
                                            }
                                            if (statename == "Tamilnadu")
                                            {
                                                if (msal < 7000)
                                                {
                                                    professionaltax = 0;
                                                }
                                                else if (msal >= 7001 && msal <= 10000)
                                                {
                                                    professionaltax = 115;
                                                }
                                                else if (msal >= 10001 && msal <= 11000)
                                                {
                                                    professionaltax = 171;
                                                }
                                                else if (msal >= 11001 && msal <= 12000)
                                                {
                                                    professionaltax = 171;
                                                }
                                                else if (msal >= 12001)
                                                {
                                                    professionaltax = 208;
                                                }
                                            }
                                            if (statename == "karnataka")
                                            {
                                                if (msal <= 15000 && msal <= 15001)
                                                {
                                                    professionaltax = 0;
                                                }
                                                else if (msal >= 15001)
                                                {
                                                    professionaltax = 200;
                                                }
                                            }
                                            double perdaprofitionaltax = professionaltax / NrOfDays;
                                            losofprofitionaltax = lossofpay * perdaprofitionaltax;
                                            pt = Math.Round(professionaltax - losofprofitionaltax);
                                            totalernings = Math.Round(tot + hre);
                                            grosstotalernings = ghtotal + grosshra;
                                            totaldeduction = Math.Round(professionaltax + providentfound + esi + canten + incometax + salaryadvance + loan + medicalcilam + otherdeduction + tdsdeduction);
                                            netsal = Math.Round(totalernings - totaldeduction);
                                        }
                                    }
                                    else
                                    {
                                        sal = Convert.ToDouble(monthsal);
                                        double perdayamount = sal / noofdays;
                                        otvalue = Convert.ToDouble(otdays) * perdayamount;
                                        erbasic = 0;
                                        providentfound = 0;
                                        conveyanceallavance = 0;
                                        medicalallavance = 0;
                                        washingallowance = 0;
                                        professionaltax = 0;
                                        hre = 0;
                                        esi = 0;
                                        double totalotval = sal + otvalue;
                                        double cantendeductin = 0;
                                    }
                                    txtemail.Text = emalid;
                                    txtempcode.Text = employeid;
                                    txtempname.Text = empname;
                                    joindate = joidate;
                                    desigiation = desigination;
                                    depatment = department;
                                    branch = Location;
                                    payyearsal = ayear;
                                    pfn = PFNO;
                                    uan = PFUAN;
                                    bank = bankname;
                                    accountno = accountnumber;
                                    esin = ESINo;
                                    txtmonth.Text = MonthName;
                                    txtnoofdays.Text = NrOfDays.ToString();
                                    txtdayspaid.Text = effectivedays.ToString();
                                    txtlop.Text = lop;
                                    txtpan.Text = pannumbr;
                                    txtactbasic.Text = grossbasic.ToString();
                                    txtmonthbasic.Text = erbasic.ToString();
                                    txtacthra.Text = grosshra.ToString();
                                    txtmonthhra.Text = hre.ToString();
                                    txtactconveyance.Text = grossconveyanceallavance.ToString();
                                    txtmonthconveyance.Text = conveyanceallavance.ToString(); ;
                                    txtactmedicalallowance.Text = grossmedicalallavance.ToString();
                                    txtmonthmedicalallowance.Text = medicalallavance.ToString();
                                    txtmonthcanteendeduction.Text = canteendeduction.ToString();
                                    txtactwashingallowance.Text = grosswashingallowance.ToString();
                                    txtmonthwashingallowance.Text = washingallowance.ToString();
                                    txtmonthpf.Text = providentfound.ToString();
                                    txtmonthpt.Text = professionaltax.ToString();
                                    txtmonthesi.Text = esi.ToString();
                                    txtmonthincometax.Text = salaryadvance.ToString();
                                    txtActTotalEarnings.Text = grosstotalernings.ToString();
                                    txtMonthTotalEarnings.Text = totalernings.ToString();
                                    txtMonthTotalDeductions.Text = totaldeduction.ToString();
                                    txtNetPayAmount.Text = netsal.ToString();
                                    txtloan.Text = loan.ToString();
                                    txtMobile.Text = mobilededuction.ToString();
                                    txt_Otherdeduction.Text = otherdeduction.ToString();
                                    txt_Mediclaim.Text = medicalcilam.ToString();
                                    txt_TdsDeduction.Text = tdsdeduction.ToString();

                                }
                                PaySlipPDFGeneration();
                            }
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void btn_mnthgenarate_click(object sender, EventArgs e)
    {
        try
        {
            foreach (GridViewRow row in GridView2.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    CheckBox ChkBoxHeader = (CheckBox)GridView2.HeaderRow.FindControl("checkAll");
                    //CheckBox chkRow = (CheckBox)row.FindControl("checkAll"); 
                    CheckBox cc = (CheckBox)row.FindControl("CheckBox1");
                    Label lblid = (Label)row.FindControl("lblempid");
                    if (cc.Checked == true)
                    {
                        //do calculation with other controls in the row
                        try
                        {
                            DateTime mydate = DateTime.Now;
                            string empid = lblid.Text;
                            string mainbranch = Session["mainbranch"].ToString();
                            string noofmonths = ddlmonth.SelectedItem.Value;
                            string mymonth = ddlmonth.SelectedItem.Value;
                            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                            DateTime dtfromdate = ServerDateCurrentdate;
                            DateTime dttodate = ServerDateCurrentdate;
                            string amonth = "";
                            string cmonth = "";
                            string ayear = "";
                            string otdays = "";
                            string bid = "";
                            string emptype = "";
                            double canteendeduction = 0;
                            double mobilededuction = 0;
                            double salaryadvance = 0;
                            double msal = 0;
                            double otvalue = 0;
                            double loan = 0;
                            double medicalcilam = 0;
                            double sal = 0;
                            double grossbasic = 0;
                            double erbasic = 0;
                            double providentfound = 0;
                            double professionaltax = 0;
                            double esi = 0;
                            double canten = 0;
                            double incometax = 0;
                            double medical = 0;
                            double medicalallavance = 0;
                            double conveyanceallavance = 0;
                            double washingallowance = 0;
                            double grossmedicalallavance = 0;
                            double conveyance = 0;
                            double grossconveyanceallavance = 0;
                            double washing = 0;
                            double grosswashingallowance = 0;
                            double grosshra = 0;
                            double hre = 0;
                            double totalernings = 0;
                            double grosstotalernings = 0;
                            double totaldeduction = 0;
                            double netsal = 0;
                            double losofprofitionaltax = 0;
                            double pt = 0;
                            double losofhre = 0;
                            double hre1 = 0;
                            double otherdeduction = 0;
                            double tdsdeduction = 0;
                            cmd = new SqlCommand("SELECT branchid From employedetails where empid=@eid");
                            cmd.Parameters.Add("@eid", empid);
                            DataTable dtbranches = vdm.SelectQuery(cmd).Tables[0];
                            if (dtbranches.Rows.Count > 0)
                            {
                                bid = dtbranches.Rows[0]["branchid"].ToString();
                            }
                            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE branchmaster.branchid= @branchid");
                            cmd.Parameters.Add("@branchid", bid);
                            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
                            if (dtcompany.Rows.Count > 0)
                            {
                                Session["TitleName"] = dtcompany.Rows[0]["companyname"].ToString();
                                Session["Address"] = dtcompany.Rows[0]["address"].ToString();
                            }
                            cmd = new SqlCommand("SELECT fromdate, todate FROM branchmaster where branchid=@branchid");
                            cmd.Parameters.Add("@branchid", bid);
                            DataTable dtroutes = vdm.SelectQuery(cmd).Tables[0];
                            int noofmnts = Convert.ToInt32(noofmonths);
                            int i = 0;
                            DateTime fromdate = ServerDateCurrentdate;
                            for (i = 1; i <= noofmnts; i++)
                            {
                                if (dtroutes.Rows.Count > 0)
                                {
                                    if (ddlmonth.SelectedItem.Value == "1")
                                    {
                                        DateTime dtfrom = fromdate.AddMonths(-1);
                                        string frmdate = dtfrom.ToString("MM/dd/yyyy");
                                        string[] str = frmdate.Split('/');
                                        int lastmonth = Convert.ToInt32(dtroutes.Rows[0]["fromdate"].ToString());
                                        int years = Convert.ToInt32(str[2]);
                                        int months = Convert.ToInt32(str[0]);
                                        dtfromdate = new DateTime(years, months, lastmonth);
                                        amonth = str[0];
                                        ayear = str[2];
                                        string cdate = dtfrom.ToString("MMM/dd/yyyy");
                                        string[] strmnth = cdate.Split('/');
                                        cmonth = strmnth[0];
                                        DateTime dtto = DateTime.Now;

                                        if (mainbranch == "42")
                                        {
                                            dtto = dtfromdate.AddMonths(1);
                                        }
                                        else
                                        {
                                            dtto = dtfromdate.AddMonths(-1);
                                            dtfromdate = dtto;
                                            dtfromdate = dtto.AddMonths(1);
                                        }
                                        string todate = dtto.ToString("MM/dd/yyyy");
                                        string[] strto = todate.Split('/');
                                        int prasentdate = Convert.ToInt32(dtroutes.Rows[0]["todate"].ToString());
                                        int prasentyears = Convert.ToInt32(strto[2]);
                                        int prasentmonths = Convert.ToInt32(strto[0]);
                                        dttodate = new DateTime(prasentyears, prasentmonths, prasentdate);
                                    }
                                    else if (ddlmonth.SelectedItem.Value == "3" || ddlmonth.SelectedItem.Value == "6")
                                    {
                                        DateTime dtfrom = fromdate.AddMonths(-i);
                                        string frmdate = dtfrom.ToString("MM/dd/yyyy");
                                       // string cdate = dtfrom.ToString("MMM/dd/yyyy");
                                        string[] str = frmdate.Split('/');
                                        
                                       
                                        int lastmonth = Convert.ToInt32(dtroutes.Rows[0]["fromdate"].ToString());
                                        int years = Convert.ToInt32(str[2]);
                                        int months = Convert.ToInt32(str[0]);
                                        dtfromdate = new DateTime(years, months, lastmonth);
                                        
                                        amonth = str[0];
                                        ayear = str[2];
                                        DateTime dtto = fromdate.AddMonths(-i);
                                        // i cahnge dtto = dtfromdate;
                                        if (mainbranch == "42")
                                        {
                                            dtto = dtfromdate.AddMonths(1);
                                        }
                                        else
                                        {
                                            dtto = dtfromdate.AddMonths(-1);
                                            //dtfromdate = dtto;
                                            dtfromdate = dtto.AddMonths(1);
                                            //fromdate = dtfromdate;
                                        }
                                        string todate = dtto.ToString("MM/dd/yyyy");
                                        string[] strto = todate.Split('/');
                                        int prasentdate = Convert.ToInt32(dtroutes.Rows[0]["todate"].ToString());
                                        int prasentyears = Convert.ToInt32(strto[2]);
                                        int prasentmonths = Convert.ToInt32(strto[0]);
                                        dttodate = new DateTime(prasentyears, prasentmonths, prasentdate);
                                    }
                                }
                                DateTime dtstartingmontm = fromdate.AddMonths(-i);

                                cmd = new SqlCommand("SELECT employedetails.joindate, employedetails.empid, branchmaster.branchname, departments.department, designation.designation, employepfdetails.uannumber, employepfdetails.pfnumber, employedetails.email, employepfdetails.estnumber, employedetails.pancard,employedetails.esidate FROM employedetails INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (employedetails.empid = @employeid)");
                                cmd.Parameters.Add("@employeid", empid);
                                DataTable dtempdetails = vdm.SelectQuery(cmd).Tables[0];

                                cmd = new SqlCommand("SELECT  employebankdetails.employeid, employebankdetails.sno, employebankdetails.accountno, employebankdetails.bankid, employebankdetails.branchname, employebankdetails.ifsccode, bankmaster.bankname FROM  employebankdetails INNER JOIN bankmaster ON employebankdetails.bankid = bankmaster.sno");
                                cmd.Parameters.Add("@eempid", empid);
                                DataTable dtempbankdetails = vdm.SelectQuery(cmd).Tables[0];


                                cmd = new SqlCommand("SELECT sno, employecode, empname, designation, daysmonth, attandancedays, clandholidayoff, payabledays, salary, basic, hra, conveyance, medical, washing, gross, pt, pf, esi, salaryadvance, loan, canteendeduction, mobilededuction, mediclim, otherdeduction, totaldeduction, netpay, bankaccountno, ifsccode, emptype, branchid, month, dateofclosing, closedby, year, deptid, tdsdeduction, betaperday, attendancebonus, type, empid, extrapay, extradays  FROM  monthlysalarystatement WHERE year=@year and month=@month  and empid=@empid");
                                cmd.Parameters.Add("@empid", empid);
                                cmd.Parameters.Add("@month", amonth);
                                cmd.Parameters.Add("@year", ayear);
                                DataTable routes = vdm.SelectQuery(cmd).Tables[0];

                                foreach (DataRow dr in routes.Rows)
                                {
                                    string employeid = dr["empid"].ToString();
                                    foreach (DataRow drb in dtempbankdetails.Select("employeid='" + employeid + "'"))
                                    {
                                        bank = drb["bankname"].ToString();
                                    }
                                    foreach (DataRow dre in dtempdetails.Select("empid='" + employeid + "'"))
                                    {
                                        txtemail.Text = dre["email"].ToString();
                                        joindate = dre["joindate"].ToString();
                                        desigiation = dre["designation"].ToString();
                                        depatment = dre["department"].ToString();
                                        branch = dre["branchname"].ToString();
                                        pfn = dre["pfnumber"].ToString();
                                        uan = dre["uannumber"].ToString();
                                        esin = dre["estnumber"].ToString();
                                        txtpan.Text = dre["pancard"].ToString();
                                    }
                                    txtempcode.Text = dr["employecode"].ToString();
                                    txtempname.Text = dr["empname"].ToString(); ;
                                    accountno = dr["bankaccountno"].ToString();

                                    payyearsal = ayear;
                                    txtmonth.Text = cmonth;
                                    txtnoofdays.Text = dr["daysmonth"].ToString();
                                    txtdayspaid.Text = dr["payabledays"].ToString();
                                    double daysinmonth = Convert.ToDouble(dr["daysmonth"].ToString());
                                    double paybledays = Convert.ToDouble(dr["payabledays"].ToString());
                                    txtlop.Text = (daysinmonth - paybledays).ToString();
                                    double salary = Convert.ToDouble(dr["salary"].ToString());
                                    grossbasic = (salary * 50) / 100;
                                    grossconveyanceallavance = 1600;
                                    grossmedicalallavance = 1250;
                                    grosswashingallowance = 1000;
                                    double tot = grossconveyanceallavance + grossmedicalallavance + grosswashingallowance + grossbasic;
                                    grosshra = salary - tot;
                                    txtactbasic.Text = grossbasic.ToString();
                                    txtmonthbasic.Text = dr["basic"].ToString();
                                    txtacthra.Text = grosshra.ToString();
                                    txtmonthhra.Text = dr["hra"].ToString();
                                    txtactconveyance.Text = grossconveyanceallavance.ToString();
                                    txtmonthconveyance.Text = dr["conveyance"].ToString();
                                    txtactmedicalallowance.Text = grossmedicalallavance.ToString();
                                    txtmonthmedicalallowance.Text = dr["medical"].ToString();
                                    txtactwashingallowance.Text = grosswashingallowance.ToString();
                                    txtmonthwashingallowance.Text = dr["washing"].ToString();
                                    txtmonthpf.Text = dr["pf"].ToString();
                                    txtmonthpt.Text = dr["pt"].ToString();
                                    txtmonthesi.Text = dr["esi"].ToString();

                                    string salded = dr["salaryadvance"].ToString();
                                    if (salded != "")
                                    {
                                        txtmonthincometax.Text = dr["salaryadvance"].ToString();
                                    }
                                    else
                                    {
                                        txtmonthincometax.Text = "0";
                                    }
                                    string canteen = dr["canteendeduction"].ToString();
                                    if (canteen != "")
                                    {
                                        txtmonthcanteendeduction.Text = dr["canteendeduction"].ToString();
                                    }
                                    else
                                    {
                                        txtmonthcanteendeduction.Text = "0";
                                    }
                                    string mobiled = dr["mobilededuction"].ToString();
                                    if (mobiled != "")
                                    {
                                        txtMobile.Text = dr["mobilededuction"].ToString();
                                    }
                                    else
                                    {
                                        txtMobile.Text = "0";
                                    }


                                    string loanded = dr["loan"].ToString();
                                    if (loanded != "")
                                    {
                                        txtloan.Text = dr["loan"].ToString();
                                    }
                                    else
                                    {
                                        txtloan.Text = "0";
                                    }

                                    string mediclimded = dr["mediclim"].ToString();
                                    if (mediclimded != "")
                                    {
                                        txt_Mediclaim.Text = dr["mediclim"].ToString();
                                    }
                                    else
                                    {
                                        txt_Mediclaim.Text = "0";
                                    }

                                    string otherded = dr["otherdeduction"].ToString();
                                    if (otherded != "")
                                    {
                                        txt_Otherdeduction.Text = dr["otherdeduction"].ToString();
                                    }
                                    else
                                    {
                                        txt_Otherdeduction.Text = "0";
                                    }


                                    string tdsded = dr["tdsdeduction"].ToString();
                                    if (tdsded != "")
                                    {
                                        txt_TdsDeduction.Text = dr["tdsdeduction"].ToString();
                                    }
                                    else
                                    {
                                        txt_TdsDeduction.Text = "0";
                                    }
                                    double TotalEarnings = grossconveyanceallavance + grossmedicalallavance + grosswashingallowance + grosshra + grossbasic;
                                    txtActTotalEarnings.Text = TotalEarnings.ToString();
                                    txtMonthTotalEarnings.Text = dr["gross"].ToString();
                                    txtMonthTotalDeductions.Text = dr["totaldeduction"].ToString();
                                    txtNetPayAmount.Text = dr["netpay"].ToString();
                                }
                                PaySlipPDFGeneration();
                            }
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void PaySlipPDFGeneration()
    {
        string EmployeeCode = txtempcode.Text;
        string email = txtemail.Text;
        string EmpName = txtempname.Text;
        string ForMonth = txtmonth.Text;
        string NoofDays = txtnoofdays.Text;
        string DaysPaid = txtdayspaid.Text;
        string LOP = txtlop.Text;
        string pannumber = txtpan.Text;
        string ActBasic = txtactbasic.Text;
        string MonthBasic = txtmonthbasic.Text;
        string ActHRA = txtacthra.Text;
        string MonthHRA = txtmonthhra.Text;
        string ActConveyance = txtactconveyance.Text;
        string MonthConveyance = txtmonthconveyance.Text;
        string ActmedicalConveyance = txtactmedicalallowance.Text;
        string MonthmedicalConveyance = txtmonthmedicalallowance.Text;
        string canteendeduction = txtmonthcanteendeduction.Text;
        string ActwashingConveyance = txtactwashingallowance.Text;
        string MonthwashingConveyance = txtmonthwashingallowance.Text;
        string MonthPF = txtmonthpf.Text;
        string MonthPT = txtmonthpt.Text;
        string MonthESI = txtmonthesi.Text;
        string salaryadvance = txtmonthincometax.Text;
        string ActTotalEarnings = txtActTotalEarnings.Text;
        string MonthTotalEarnings = txtMonthTotalEarnings.Text;
        string MonthTotalDeductions = txtMonthTotalDeductions.Text;
        string NetPay = txtNetPayAmount.Text;
        string loan = txtloan.Text;
        string mobile = txtMobile.Text;
        string Mediclaim = txt_Mediclaim.Text;
        string Otherdeduction = txt_Otherdeduction.Text;
        string TDsdeduction = txt_TdsDeduction.Text;
        string title = titlename;
        string strdate = joindate;
        DateTime dtjoin = Convert.ToDateTime(strdate);
        string newstrdate = dtjoin.ToString("dd/MMM/yyyy");
        string jdate = newstrdate;
        string desg = desigiation;
        string dep = depatment;
        string loc = branch;
        string bankna = bank;
        string account = accountno;
        string PNo = pfn;
        string uanno = uan;
        string esino = esin;
        string payyear = payyearsal;

        DateTime dt = DateTime.Now;

        string year = payyear;
        //string paymonth = ForMonth "'++'";
        string paymonth = "" + ForMonth + "-" + year + "";
        string empcm = "" + EmployeeCode + "" + ForMonth + "";
        // string strNetPayinWords = NumberToWords(Convert.ToInt32(lblNetPayAmount.Text));

        string FilePath = "~/" + "Drawings/PaySlip.pdf";
        RandomAccessFileOrArray ramFile = new RandomAccessFileOrArray(Server.MapPath(FilePath));
        PdfReader reader1 = new PdfReader(ramFile, null);

        string PaySlipPath = FilePath.Substring(0, FilePath.Length - 11) + "" + empcm + "PaySlip.pdf";
        reader1.Close();

        Document doc = new Document(PageSize.A4);
        PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(Server.MapPath(PaySlipPath), FileMode.Create));
        writer.Open();
        doc.Open();
        PdfContentByte cb = writer.DirectContent;

        // Pdf Page
        PdfPTable table = new PdfPTable(5);
        table.TotalWidth = 550f;
        table.LockedWidth = true;
        //float[] widths = new float[] { 100f, 75f, 75f, 100f, 80f};
        //table.SetWidths(widths);
        Font BoldFont = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.BOLD);
        Font NormalFont = new Font(Font.FontFamily.TIMES_ROMAN, 7, Font.NORMAL);
        Font SmallFont = new Font(Font.FontFamily.TIMES_ROMAN, 6, Font.NORMAL);


        string imagepath = Server.MapPath("~/Images/Vyshnavilogo.png");
        PdfPCell cell = new PdfPCell();
        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 15.0f;
        cell.Colspan = 0;
        cell.Border = Rectangle.NO_BORDER;
        cell.Rowspan = 3;
        iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(imagepath);
        cell.AddElement(img);
        table.AddCell(cell);
        cell = new PdfPCell();
        cell.FixedHeight = 15.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_LEFT;
        cell.Border = Rectangle.NO_BORDER;
        cell.Rowspan = 3;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(Session["TitleName"].ToString(), BoldFont));
        cell.FixedHeight = 20.0f;
        cell.Colspan = 4;
        cell.Border = Rectangle.NO_BORDER;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_LEFT;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(Session["Address"].ToString(), NormalFont));
        cell.FixedHeight = 15.0f;
        cell.Colspan = 4;
        cell.Border = Rectangle.NO_BORDER;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_LEFT;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Salary for the Month of " + paymonth, BoldFont));
        cell.FixedHeight = 15.0f;
        cell.Colspan = 4;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_LEFT;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Employee Code:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(EmployeeCode, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Employee Name:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(EmpName, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Join Date:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(jdate, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Bank Name:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(bank, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Designation:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(desg, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Bank Account NO:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(account, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Department:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(dep, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("PF No:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(PNo, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Location:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(loc, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("PF UAN:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(uanno, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Effective Work Days:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(NoofDays, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("ESI No:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(esino, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Days Paid:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(DaysPaid, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("LOP:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(LOP, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("PanNumber:", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(pannumber, BoldFont));
        cell.Colspan = 0;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Earnings", BoldFont));
        cell.Colspan = 3;
        cell.FixedHeight = 15.0f;
        cell.HorizontalAlignment = Element.ALIGN_CENTER;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Deductions", BoldFont));
        cell.Colspan = 2;
        cell.FixedHeight = 15.0f;
        cell.HorizontalAlignment = Element.ALIGN_CENTER;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Gross Earnings", BoldFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Full", BoldFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Actual", BoldFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Deductions", BoldFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Actual", BoldFont));
        cell.FixedHeight = 10.0f;
        cell.Colspan = 1;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Basic", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(ActBasic, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = 0;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthBasic, NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Provident Fund", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthPF, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);


        cell = new PdfPCell(new Phrase("House Rent Allowence", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(ActHRA, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthHRA, NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Professional Tax", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthPT, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Conveyance", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(ActConveyance, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthConveyance, NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("ESI", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthESI, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Medical Allowance", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(ActmedicalConveyance, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthmedicalConveyance, NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Salary Adavance", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(salaryadvance, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Washing Allowance", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(ActwashingConveyance, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthwashingConveyance, NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Canteen Deduction", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(canteendeduction, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("MobileDeduction", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(mobile, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);


        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Other Loan", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(loan, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);


        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Mediclaim Deduction", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(Mediclaim, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Other Deduction", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(Otherdeduction, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(""));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        cell.Border = Rectangle.NO_BORDER;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("TDS Deduction", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(TDsdeduction, NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);


        cell = new PdfPCell(new Phrase("Total", NormalFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(ActTotalEarnings, BoldFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthTotalEarnings, BoldFont));
        cell.FixedHeight = 10.0f;
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("Total", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(MonthTotalDeductions, BoldFont));
        cell.HorizontalAlignment = Element.ALIGN_RIGHT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);


        cell = new PdfPCell(new Phrase("Net Pay : " + NetPay, BoldFont));
        cell.Colspan = 5;
        cell.FixedHeight = 15.0f;
        cell.HorizontalAlignment = Element.ALIGN_CENTER;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("NOTE: This is computer generated payslip Does Not Require  Any signature...", NormalFont));
        cell.FixedHeight = 15.0f;
        cell.Colspan = 5;
        cell.HorizontalAlignment = Element.ALIGN_CENTER;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);
        doc.Add(table);


        //cell = new PdfPCell(new Phrase(""));
        //cell.FixedHeight = 75.0f;
        //cell.Colspan = 6;
        //cell.Border = Rectangle.NO_BORDER;
        //table.AddCell(cell);

        //cell = new PdfPCell(new Phrase("NOTE: This is computer generated payslip Does Not Recovery  Any signature..", NormalFont));
        //cell.FixedHeight = 15.0f;
        //cell.Colspan = 5;
        //cell.HorizontalAlignment = Element.ALIGN_LEFT;
        //cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        //table.AddCell(cell);
        //doc.Add(table);


        //cell = new PdfPCell(new Phrase("Phone: +91 90870 22244, Email; hr@vyshnavi.in, www.vyshnavidairy.com", NormalFont));
        //cell.FixedHeight = 15.0f;
        //cell.Colspan = 5;
        //cell.Border = Rectangle.NO_BORDER;
        //cell.HorizontalAlignment = Element.ALIGN_CENTER;
        //cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        //table.AddCell(cell);


        BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
        Font font = new Font(bf, 11, Font.NORMAL);
        // output src document: 
        int i = 1;
        while (i < reader1.NumberOfPages)
        {
            i++;
            // add next page from source PDF:
            doc.NewPage();
            PdfImportedPage page = writer.GetImportedPage(reader1, i);
            //cb.AddTemplate(page, 0, 0);
            writer.DirectContentUnder.AddTemplate(page, 0, 0);
            // use something like this to flush the current page to the browser:
            writer.Flush();
            //Response.Flush();
        }
        doc.Close();
        writer.Close();
        string FileName = "PaySlip.pdf";
        WebClient req = new WebClient();
        HttpResponse response = HttpContext.Current.Response;

        response.Clear();
        response.ClearContent();
        response.ClearHeaders();
        response.BufferOutput = true;
        response.AddHeader("Content-Disposition", "attachment;filename=\"" + FileName + "\"");
        data = req.DownloadData(Server.MapPath(PaySlipPath));
        response.BinaryWrite(data);

        //Thread.Sleep(1000);
        //Response.Flush();
        //string msgto = txtemail.Text;
        string msgTo = email;
        string msgSubject = "PaySlip";
        string msgcontent = EmpName;
        string msgcontent1 = paymonth;
        string msgBody = PaySlipPath;
        SendMail(msgTo, msgSubject, msgBody, msgcontent, msgcontent1);
        // File.Delete(FilePath);
        //System.IO.File.Delete(Server.MapPath(PaySlipPath));
        //response.End();[;'
    }

    protected void SendMail(string msgTo, string msgSubject, string msgBody, string msgcontent, string msgcontent1)
    {
        try
        {
            string email = msgTo;
            //string cellphone = "9490003933";
            string toAddress = email;
            //string toAddress = "sknaseema11@gmail.com";
            string subject = "Payslip";
            string content1 = "Dear " + msgcontent + " ,";
            string content2 = "We are sending your payslip for the month " + msgcontent1 + " as an attachment with this mail.";
            string content3 = "Note:This is an auto-generated mail. Please do not reply";
            //string content = "Dear SK. Naseema Begam, We are sending your payslip for the month Jun 2016 as an attachment with this mail.Note: This is an auto-generated mail. Please do not reply";
            string result = "Payslip";
            string senderID = "no-reply@vyshnavi.in";// use sender's email id here..
            const string senderPassword = "Vyshnavi@123"; // sender password here...
            SmtpClient smtp = new SmtpClient
            {
                Host = "czismtp.logix.in", // smtp server address here...
                Port = 587,
                //security type=tsl;
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Credentials = new System.Net.NetworkCredential(senderID, senderPassword),
                Timeout = 30000,
            };
            // MailMessage message = new MailMessage(senderID, toAddress, subject, "<html><body><img src=" + msgBody + " /><br></body></html>");
            MailMessage message = new MailMessage(senderID, toAddress, subject, "<html><body><p>" + content1 + "</p><p>" + content2 + "</p><p>" + content3 + "</p><iframe src=" + msgBody + "></iframe></body></html>");
            //message.Body = "<html><body>" + content + "</body></html> ";
            message.Attachments.Add(new Attachment(new MemoryStream(data), msgBody));
            message.IsBodyHtml = true;
            smtp.Send(message);
            Response.Write("send successfully");
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
            //Handle the exception that, mail does not sent                
        }
    }
}