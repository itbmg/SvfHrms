using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class EmployeeCashReport : System.Web.UI.Page
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
                DateTime dtyear = DateTime.Now.AddYears(0);
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
                bindcompany();
                bindemployeetype();
                PopulateYear();
                string frmdate = dtfrom.ToString("dd/MM/yyyy");
                string[] str = frmdate.Split('/');
                ddlmonth.SelectedValue = str[1];
                string fryear = dtyear.ToString("dd/MM/yyyy");
                string[] str1 = fryear.Split('/');
                ddlyear.SelectedValue = str1[2];
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

    private void bindcompany()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT sno, companyname FROM company_master");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlCompanytype.DataSource = dttrips;
        ddlCompanytype.DataTextField = "companyname";
        ddlCompanytype.DataValueField = "sno";
        ddlCompanytype.DataBind();
        ddlCompanytype.ClearSelection();
        ddlCompanytype.Items.Insert(0, new ListItem { Value = "0", Text = "Select Branch", Selected = true });
        ddlCompanytype.SelectedValue = "0";
    }

    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails  where (employee_type<>'') GROUP BY employedetails.employee_type");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
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
    protected void btn_Generate_Click(object sender, EventArgs e)
    {

        try
        {
            lblmsg.Text = "";
            string mainbranch = Session["mainbranch"].ToString();
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string currentyear = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            int month = Convert.ToInt32(mymonth);
            int years = Convert.ToInt32(year);
            string day = "";
            if (mymonth == "02")
            {
                day = "28";
            }
            else
            {
                day = (mydate.Day).ToString();
                int days = DateTime.DaysInMonth(years, month);
                int cmdays = Convert.ToInt32(day);
                if (cmdays > days)
                {
                    day = days.ToString();
                }

            }
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            if (ddlbranchtype.SelectedItem.Text == "Plant" && (ddlemptype.SelectedItem.Text == "Driver" || ddlemptype.SelectedItem.Text == "Cleaner"))
            {
                cmd = new SqlCommand("SELECT  branchmaster.branchid, branchmaster.branchname, branchmaster.company_code, branchmaster.branchtype FROM     branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch INNER JOIN employedetails ON branchmaster.branchid = employedetails.branchid WHERE        (branchmapping.mainbranch = @m) AND (branchmaster.branchtype = @branchtype) AND (employedetails.employee_type = @emptype) GROUP BY branchmaster.branchid, branchmaster.branchname, branchmaster.company_code, branchmaster.branchtype");
                cmd.Parameters.Add("@m", mainbranch);
                cmd.Parameters.Add("@branchtype", ddlbranchtype.SelectedItem.Text);
                cmd.Parameters.Add("@emptype ", ddlemptype.SelectedItem.Text);
                DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
                string branchname = dttrips.Rows[0]["branchname"].ToString();
                Session["filename"] = ddlemptype.SelectedItem.Text + "Cash Statement " + ddlmonth.SelectedItem.Text + " " + year;
                Session["title"] = ddlemptype.SelectedItem.Text + " Cash Statement " + ddlmonth.SelectedItem.Text + " " + year;
                lblHeading.Text = branchname + " " + ddlemptype.SelectedItem.Text + " Cash Statement " + ddlmonth.SelectedItem.Text + " " + year;
            }
            else
            {
                Session["filename"] = ddlemptype.SelectedItem.Text + "Cash Statement " + ddlmonth.SelectedItem.Text + " " + year;
                Session["title"] = ddlemptype.SelectedItem.Text + " Cash Statement " + ddlmonth.SelectedItem.Text + " " + year;
                lblHeading.Text = ddlemptype.SelectedItem.Text + " Cash Statement " + ddlmonth.SelectedItem.Text + " " + year;
            }
            if (ddlbranchtype.SelectedItem.Text == "Plant" & ddlemptype.SelectedItem.Text == "Driver")
            {
                Report.Columns.Add("Location");
                Report.Columns.Add("Sno");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Employee Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("Net Pay").DataType = typeof(double);
                Report.Columns.Add("Emp Signature");
                int branchid = Convert.ToInt32(mainbranch);
                string branchtype = ddlbranchtype.SelectedItem.Text;
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, branchmaster.branchname, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible,monthly_attendance.month, monthly_attendance.year, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, branchmaster.statename, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE(employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type = 'Driver' OR employedetails.employee_type = 'Cleaner') AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type = 'Driver' OR employedetails.employee_type = 'Cleaner') AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrure
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, branchmaster.branchname, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year,employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, branchmaster.statename FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid Left Outer Join branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @branchid) AND (employedetails.status = 'No') AND (employebankdetails.paymenttype = 'Cash') AND ((employedetails.employee_type ='Driver') OR (employedetails.employee_type ='Cleaner')) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code)");
                cmd.Parameters.Add("@branchtype", branchtype);
                cmd.Parameters.Add("@company_code", ddlCompanytype.SelectedValue);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                //cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where  (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];

                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double totalpresentdays = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double numberofworkingdays = 0;
                        double totalearnings = 0;
                        double daysinmonth = 0;
                        string statename = "";
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["Location"] = dr["branchname"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Employee Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        statename = dr["statename"].ToString();
                        //newrow["PT"] = dr["profitionaltax"].ToString();
                        double rateper = Convert.ToDouble(dr["gross"].ToString());
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                totalpresentdays = holidays + paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                double batta = 80;
                                string empnumber = dr["employee_num"].ToString();
                                if (empnumber == "SVDS080135")
                                {
                                    // newrow["Batta/Day"] = "0";
                                    batta = 0;
                                }
                                else
                                {
                                    // newrow["Batta/Day"] = batta;
                                }
                                double rateperday = rate + batta;
                                totalearnings = rateperday * paydays;
                                double totalpdays = numberofworkingdays - lop;
                                totalearnings = Math.Round(totalearnings);
                                newrow["GROSS Earnings"] = totalearnings;
                                if (statename == "AndraPrdesh")
                                {
                                    if (totalearnings > 1000 && totalearnings <= 15000)
                                    {
                                        profitionaltax = 0;
                                    }
                                    else if (totalearnings >= 15001 && totalearnings <= 20000)
                                    {
                                        profitionaltax = 150;
                                    }
                                    else if (totalearnings >= 20001)
                                    {
                                        profitionaltax = 200;
                                    }
                                }
                                if (statename == "Tamilnadu")
                                {
                                    if (totalearnings < 7000)
                                    {
                                        profitionaltax = 0;
                                    }
                                    else if (totalearnings >= 7001 && totalearnings <= 10000)
                                    {
                                        profitionaltax = 115;
                                    }
                                    else if (totalearnings >= 10001 && totalearnings <= 11000)
                                    {
                                        profitionaltax = 171;
                                    }
                                    else if (totalearnings >= 11001 && totalearnings <= 12000)
                                    {
                                        profitionaltax = 171;
                                    }
                                    else if (totalearnings >= 12001)
                                    {
                                        profitionaltax = 208;
                                    }
                                }
                                if (statename == "karnataka")
                                {
                                    if (totalearnings <= 15000 && totalearnings <= 15001)
                                    {
                                        profitionaltax = 0;
                                    }
                                    else if (totalearnings >= 15001)
                                    {
                                        profitionaltax = 200;
                                    }
                                }
                                //newrow["PT"] = profitionaltax;
                            }
                        }



                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                //newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            //newrow["SALARY ADVANCE"] = salaryadvance;
                        }
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    //newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
                                //newrow["Loan"] = loan;
                            }
                        }
                        mobilededuction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                    //newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;

                                    }
                                    else
                                    {
                                        mobilededuction = Convert.ToDouble(deductionamount);
                                        mobilededuction = Math.Round(deductionamount, 0);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        canteendeduction = 0;
                        if (dtcanteen.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount, 0);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        // newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 0);
                        string stramount = "";
                        stramount = netpay.ToString();
                        if (stramount == "NaN" || stramount == "" || numberofworkingdays == 0)
                        {
                        }
                        else
                        {
                            newrow["Net Pay"] = Math.Round(netpay, 0);
                            Report.Rows.Add(newrow);
                        }
                        //newrow["Net Pay"] = Math.Ceiling(netpay);
                    }
                }
                DataRow newTotal1 = Report.NewRow();
                newTotal1["Employee Name"] = "Total";
                double valt = 0.0;
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        valt = 0.0;
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out valt);
                        if (valt == 0)
                        {
                        }
                        else
                        {
                            newTotal1[dc.ToString()] = valt;
                        }
                    }
                }
                Report.Rows.Add(newTotal1);
                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }
            else if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC" || ddlbranchtype.SelectedItem.Text == "Plant")
            {
                Report.Columns.Add("Location");
                Report.Columns.Add("Sno");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("paymenttype");
                Report.Columns.Add("Gross").DataType = typeof(double);
                Report.Columns.Add("Net Pay").DataType = typeof(double);
                //svds 
                if (mainbranch == "6")
                {
                    if (ddlCompanytype.SelectedValue == "1")
                    {
                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Extra Pay").DataType = typeof(double);
                            Report.Columns.Add("Conveyance").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Conveyance").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                        }

                        if (ddlbranchtype.SelectedItem.Text == "Plant" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Extra Pay").DataType = typeof(double);
                        }
                    }


                //svd start
                    //svd 
                    else
                    {
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                            Report.Columns.Add("Conveyance").DataType = typeof(double);
                        }
                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                        {
                            Report.Columns.Add("Shift Allowance").DataType = typeof(double);
                            //Report.Columns.Add("Conveyance").DataType = typeof(double);
                        }
                    }
                }
                //svd end

                else
                {
                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                    {
                        Report.Columns.Add("Extra Pay").DataType = typeof(double);

                    }
                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                    {
                        Report.Columns.Add("OT Amount").DataType = typeof(double);

                    }

                }
                Report.Columns.Add("Net Amount").DataType = typeof(double);
                Report.Columns.Add("Employee Signature");
                string branchtype = ddlbranchtype.SelectedItem.Text;
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.gender, employedetails.esieligible, branchmaster.branchname, employedetails.empid, employedetails.employee_num, employedetails.employee_type, monthly_attendance.month, monthly_attendance.year, employedetails.fullname, designation.designation, salaryappraisals.gross,salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear, employebankdetails.paymenttype FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid)  AND (employebankdetails.paymenttype = 'cash') AND (employedetails.employee_type = @emptype) AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'cash') AND (employedetails.employee_type = @emptype) AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrute
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.gender,employedetails.esieligible, branchmaster.branchname, pay_structure.travelconveyance,employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi,pay_structure. gross,employedetails.employee_type,pay_structure.providentfund, monthly_attendance.month, monthly_attendance.year, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.paymenttype FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.status='No') and (employedetails.employee_type =@emptype) and (employebankdetails.paymenttype = 'cash') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code)");
                cmd.Parameters.Add("@branchtype", branchtype);
                cmd.Parameters.Add("@company_code", ddlCompanytype.SelectedValue);
                cmd.Parameters.Add("@branchid", mainbranch);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, branchmaster.night_allowance,monthly_attendance.clorwo, monthly_attendance.night_days, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, monthly_attendance.extradays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                // cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.extradays, employedetails.employee_num, employedetails.fullname, monthly_attendance.empid, monthly_attendance.doe,  monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays, pay_structure.gross, employebankdetails.employeid, employebankdetails.accountno,  designation.designation FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtOT = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid ");
                DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE  (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid");
                DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];

                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double nightduty = 0;
                        double nightallowance = 0;
                        double nightamount = 0;
                        double otherdeduction = 0;
                        double tdsdeduction = 0;
                        double totalpresentdays = 0;
                        double losofprofitionaltax = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double medicliamdeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double totalearnings;
                        double providentfund = 0;
                        double medicalerning = 0;
                        double washingallowance = 0;
                        double convenyance = 0;
                        double esi = 0;
                        double daysinmonth = 0;
                        double loseamount = 0;
                        double loseofconviyance = 0;
                        double loseofwashing = 0;
                        double loseofmedical = 0;
                        double otamount = 0;
                        double otvalue = 0;
                        double extravalue = 0;
                        double paydays = 0;
                        double paybledays = 0;
                        //double extrdays=0;
                        //double shiftamount=0;
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        string location = dr["branchname"].ToString();
                        newrow["Location"] = dr["branchname"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                        double permonth = 0;
                        //newrow["DESIGNATION"] = dr["designation"].ToString();
                        if (location == "Arani CC")
                        {
                            permonth = Convert.ToDouble(dr["gross"].ToString());
                            newrow["GROSS"] = permonth;
                        }
                        else
                        {
                            //newrow["Gross"]=dr["gross"].ToString();
                            newrow["Gross"] = peryanam / 12;
                            permonth = peryanam / 12;
                        }
                        double HRA = Convert.ToDouble(dr["hra"].ToString());
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                        //newrow["PT"] = dr["profitionaltax"].ToString();
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                        washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                        newrow["paymenttype"] = dr["paymenttype"].ToString();
                        //Report.Rows.Add(newrow);
                        double travelconveyance = 0;
                        double shiftamount = 0;
                        double travaltotamount = 0;
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                daysinmonth = Math.Abs(daysinmonth);
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                paybledays = numberofworkingdays + clorwo;
                                totalpresentdays = holidays + paydays;
                                double totalpdays = permonth / daysinmonth;
                                loseamount = lop * totalpdays;
                                double perdayconveyance = convenyance / daysinmonth;
                                loseofconviyance = lop * perdayconveyance;
                                double perdaywashing = washingallowance / daysinmonth;
                                loseofwashing = lop * perdaywashing;
                                double perdaymedical = medicalerning / daysinmonth;
                                loseofmedical = lop * perdaymedical;
                                double perdaybasic = BASIC / daysinmonth;
                                string extrdays = dra["extradays"].ToString();
                                double perdayamt = permonth / daysinmonth;
                                double perdayextr = permonth / daysinmonth;
                                string ot = dra["otdays"].ToString();
                                //double perdayot = permonth / daysinmonth;
                                double perdaprofitionaltax = profitionaltax / daysinmonth;
                                losofprofitionaltax = lop * perdaprofitionaltax;
                                //naseema
                                //svds1 start
                                double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
                                double perdaycost = 0;
                                double nightdays = 0;
                                double.TryParse(dra["night_days"].ToString(), out nightdays);
                                double.TryParse(dra["night_allowance"].ToString(), out perdaycost);
                                double extradays = 0;
                                if (mainbranch == "6")
                                {
                                    if (ddlCompanytype.SelectedValue == "1")
                                    {
                                        //if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC" || ddlbranchtype.SelectedItem.Text == "Plant")
                                        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Staff")
                                        {


                                            if (extrdays == "" || extrdays == "0")
                                            {
                                                extradays = 0;
                                            }
                                            else
                                            {
                                                extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                extravalue = perdayextr * extradays;
                                                newrow["Extra Pay"] = Math.Round(extravalue);

                                            }
                                            perdaycost = travelconveyance / daysinmonth;
                                            travaltotamount = totalpresentdays * perdaycost;
                                            newrow["Conveyance"] = Math.Round(travaltotamount);

                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                        {
                                            perdaycost = travelconveyance / daysinmonth;
                                            travaltotamount = totalpresentdays * perdaycost;
                                            newrow["Conveyance"] = Math.Round(travaltotamount);

                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                        {
                                            shiftamount = nightdays * perdaycost;
                                            shiftamount = Math.Round(shiftamount);
                                            newrow["Shift Allowance"] = shiftamount;
                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "Plant" & ddlemptype.SelectedItem.Text == "Staff")
                                        {
                                            if (extrdays == "" || extrdays == "0")
                                            {
                                                extradays = 0;
                                            }
                                            else
                                            {
                                                extradays = Convert.ToDouble(dra["extradays"].ToString());
                                                extravalue = perdayamt * extradays;
                                                newrow["Extra Pay"] = Math.Round(extravalue);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Staff")
                                        {

                                            perdaycost = travelconveyance / daysinmonth;
                                            travaltotamount = totalpresentdays * perdaycost;
                                            newrow["Conveyance"] = Math.Round(travaltotamount);

                                            shiftamount = nightdays * perdaycost;
                                            shiftamount = Math.Round(shiftamount);
                                            newrow["Shift Allowance"] = shiftamount;

                                        }
                                        if (ddlbranchtype.SelectedItem.Text == "CC" & ddlemptype.SelectedItem.Text == "Casuals")
                                        {
                                            shiftamount = nightdays * perdaycost;
                                            shiftamount = Math.Round(shiftamount);
                                            newrow["Shift Allowance"] = shiftamount;

                                        }

                                    }
                                }
                                //svds1 end
                                //svf start
                                else
                                {
                                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Permanent")
                                    {
                                        if (extrdays == "" || extrdays == "0")
                                        {
                                            extradays = 0;
                                        }
                                        else
                                        {
                                            extradays = Convert.ToDouble(dra["extradays"].ToString());
                                            extravalue = perdayextr * extradays;
                                            newrow["Extra Pay"] = Math.Round(extravalue);
                                        }

                                    }
                                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" & ddlemptype.SelectedItem.Text == "Casual worker")
                                    {
                                        double otdays = 0;
                                        double othours = 0;
                                        if (ot == "" || ot == "0")
                                        {
                                            otdays = 0;
                                        }
                                        else
                                        {
                                            permonth = Convert.ToDouble(dr["gross"].ToString());
                                            otdays = Convert.ToDouble(dra["otdays"].ToString());
                                            otvalue = permonth * otdays;
                                            othours = otdays * 8;
                                            newrow["OT Amount"] = Math.Round(otvalue);
                                        }
                                    }

                                }
                                //svf end

                            }
                        }
                        double totalpfdays = 0;
                        double rate = 0;
                        double bonusamount = 0;
                        double perdaysal = permonth / daysinmonth;
                        double basic = 50;
                        double basicsalary = (permonth * 50) / 100;
                        double basicpermonth = basicsalary / daysinmonth;
                        double bs = basicpermonth * totalpresentdays;
                        double basicsal = Math.Round(basicsalary - loseamount);
                        double conve = Math.Round(convenyance - loseofconviyance);
                        double medical = Math.Round(medicalerning - loseofmedical);
                        double washing = Math.Round(washingallowance - loseofwashing);
                        double tt = Math.Round(bs + conve + medical + washing);
                        // double thra = Math.Round(permonth - loseamount);
                        //double hra = thra - tt;
                        double pay = 0;

                        if (mainbranch != "42")
                        {
                            if (ddlemptype.SelectedItem.Text == "Staff")
                            {
                                pay = perdaysal * totalpresentdays;
                            }
                            else
                            {
                                if (location == "Arani CC")
                                {
                                    pay = permonth * paydays;
                                    newrow["GROSS"] = permonth * daysinmonth;
                                }
                                else
                                {
                                    pay = perdaysal * paydays;
                                }
                            }
                        }
                        else
                        {
                            if (ddlemptype.SelectedItem.Text == "Casuals")
                            {
                                pay = permonth * paydays;
                            }
                            //else if (ddlemptype.SelectedItem.Text == "Casual worker")
                            //{
                            //    pay = permonth * paydays;
                            //}
                            else if (ddlemptype.SelectedItem.Text == "Casual worker")
                            {
                                //pay = permonth * paydays;

                                double gr = Convert.ToDouble(dr["gross"].ToString());
                                rate = gr;
                                double bonus;
                                string gender = dr["gender"].ToString();
                                if (gender == "Male")
                                {
                                    if (mainbranch == "1044")
                                    {
                                        bonus = 10;
                                    }
                                    else
                                    {
                                        bonus = 30;
                                    }
                                }
                                else
                                {
                                    if (mainbranch == "1044")
                                    {
                                        bonus = 15;
                                    }
                                    else
                                    {
                                        bonus = 35;
                                    }
                                }
                                double rateperday = 0;
                                double amount = 0;
                                if (paydays >= 24)
                                {
                                    rateperday = rate + bonus;
                                    amount = bonus * paydays;
                                    //newrow["AttendanceBonus>=24days@rs.30"] = amount;
                                }
                                else
                                {
                                    // newrow["AttendanceBonus>=24days@rs.30"] = 0;
                                    rate = gr;
                                }
                                bonusamount = rate * paydays + amount;
                            }

                            else
                            {
                                pay = perdaysal * paybledays;
                            }
                        }
                        double thra = permonth - loseamount;
                        double hra = Math.Round(thra - tt);
                        if (ddlbranchtype.SelectedItem.Text == "CC")
                        {
                            totalearnings = Math.Round(pay);
                        }
                        else if (ddlemptype.SelectedItem.Text == "Casual worker")
                        {

                            totalearnings = Math.Round(bonusamount);
                        }
                        else
                        {
                            totalearnings = Math.Round(hra + tt);
                        }
                        //totalearnings = thra;
                        //newrow["HRA"] = hra;
                        //newrow["GROSS Earnings"] = totalearnings;
                        string pfeligible = dr["pfeligible"].ToString();
                        if (pfeligible == "Yes")
                        {
                            if (ddlemptype.SelectedItem.Text == "Casual worker")
                            {
                                totalpfdays = rate * paydays;
                                providentfund = (totalpfdays * 6) / 100;
                                if (providentfund > 1800)
                                {
                                    providentfund = 1800;
                                }
                                providentfund = Math.Round(providentfund);
                                // newrow["PF"] = providentfund;
                            }
                            else
                            {
                                providentfund = (totalearnings * 6) / 100;
                                if (providentfund > 1800)
                                {
                                    providentfund = 1800;
                                }
                                providentfund = Math.Round(providentfund);
                            }
                            // newrow["PF"] = providentfund;
                        }
                        else
                        {
                            providentfund = 0;
                            // newrow["PF"] = providentfund;
                        }
                        string esieligible = dr["esieligible"].ToString();
                        if (esieligible == "Yes")
                        {
                            esi = (totalearnings * 1.75) / 100;
                            esi = Math.Round(esi);
                            // newrow["ESI"] = esi;
                        }
                        else
                        {
                            esi = 0;
                            //newrow["ESI"] = esi;
                        }
                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                //newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            //newrow["SALARY ADVANCE"] = salaryadvance;
                        }
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    // newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth);
                                }
                            }
                            else
                            {
                                loan = 0;
                                // newrow["Loan"] = loan;
                            }
                        }
                        else
                        {
                            loan = 0;
                            // newrow["Loan"] = loan;
                        }
                        mobilededuction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                    //newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;
                                    }
                                    else
                                    {
                                        mobilededuction = Convert.ToDouble(deductionamount);
                                        mobilededuction = Math.Round(deductionamount);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        else
                        {
                            mobilededuction = 0;
                            //newrow["MOBILE DEDUCTION"] = mobilededuction;
                        }
                        canteendeduction = 0;
                        if (dtcanteen.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        else
                        {
                            canteendeduction = 0;
                            // newrow["CANTEEN DEDUCTION"] = canteendeduction;
                        }

                        medicliamdeduction = 0;
                        if (dtmedicliam.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmedicliam in dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drmedicliam["medicliamamount"].ToString(), out amount);
                                    //newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    medicliamdeduction = Convert.ToDouble(amount);
                                    medicliamdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                medicliamdeduction = 0;
                                //newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                            }
                        }
                        else
                        {
                        }
                        otherdeduction = 0;
                        if (dtotherdeduction.Rows.Count > 0)
                        {
                            DataRow[] drr = dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drotherdeduction in dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
                                    //newrow["OTHER DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    otherdeduction = Convert.ToDouble(amount);
                                    otherdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                otherdeduction = 0;
                                //newrow["OTHER DEDUCTION"] = otherdeduction;
                            }
                        }
                        else
                        {
                        }
                        tdsdeduction = 0;
                        if (dttdsdeduction.Rows.Count > 0)
                        {
                            DataRow[] drr = dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drtdsdeduction in dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drtdsdeduction["tdsamount"].ToString(), out amount);
                                    //newrow["Tds DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    tdsdeduction = Convert.ToDouble(amount);
                                    tdsdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                tdsdeduction = 0;
                                //newrow["Tds DEDUCTION"] = tdsdeduction;
                            }
                        }
                        else
                        {
                            tdsdeduction = 0;
                            //  newrow["Tds DEDUCTION"] = tdsdeduction;
                        }
                        //newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi);
                        if (ddlemptype.SelectedItem.Text == "Staff")
                        {
                            totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        }
                        else
                        {
                            totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + esi + medicliamdeduction + otherdeduction);
                        }
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);

                        string stramount = "0";
                        stramount = netpay.ToString();
                        if (stramount == "NaN")
                        {
                        }
                        else
                        {
                            newrow["Net Pay"] = Math.Round(netpay);
                            netpay = netpay + travelconveyance + shiftamount;
                            if (ddlemptype.SelectedItem.Value == "Casual worker")
                            {
                                newrow["Net Amount"] = Math.Round(netpay + otvalue);
                            }
                            else
                            {
                                newrow["Net Amount"] = Math.Round(netpay + extravalue);
                            }
                            Report.Rows.Add(newrow);
                        }
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Retainers")
            {
                Report.Columns.Add("Location");
                Report.Columns.Add("Sno");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("paymenttype");
                Report.Columns.Add("Gross").DataType = typeof(double);
                Report.Columns.Add("Net Pay").DataType = typeof(double);
                Report.Columns.Add("Extra Pay").DataType = typeof(double);
                Report.Columns.Add("Net Amount").DataType = typeof(double);
                Report.Columns.Add("Employee Signature");
                string branchtype = ddlbranchtype.SelectedItem.Text;
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.branchname, employedetails.empid, employedetails.employee_num, employedetails.employee_type, monthly_attendance.month, monthly_attendance.year, employedetails.fullname, designation.designation,employebankdetails.paymenttype, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi,salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'cash') AND (employedetails.employee_type = 'Retainers') AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'cash') AND (employedetails.employee_type = 'Retainers') AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrure
                // cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.branchname, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi,pay_structure. gross,employedetails.employee_type,pay_structure.providentfund, monthly_attendance.month, monthly_attendance.year, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.paymenttype FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.status='No') and (employedetails.employee_type ='Retainers')  and (employebankdetails.paymenttype = 'cash') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (branchmaster.branchtype = @branchtype) AND (branchmaster.company_code = @company_code)");
                cmd.Parameters.Add("@branchtype", branchtype);
                cmd.Parameters.Add("@company_code", ddlCompanytype.SelectedValue);
                cmd.Parameters.Add("@branchid", mainbranch);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, monthly_attendance.extradays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.extradays, employedetails.employee_num, employedetails.fullname, monthly_attendance.empid, monthly_attendance.doe,  monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays, pay_structure.gross, employebankdetails.employeid, employebankdetails.accountno,  designation.designation FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtOT = SalesDB.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid ");
                DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double totalpresentdays = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double medicliamdeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double totalearnings;
                        double providentfund = 0;
                        double medicalerning = 0;
                        double washingallowance = 0;
                        double convenyance = 0;
                        double esi = 0;
                        double daysinmonth = 0;
                        double loseamount = 0;
                        double loseofconviyance = 0;
                        double loseofwashing = 0;
                        double loseofmedical = 0;
                        double otamount = 0;
                        double paydays = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["Location"] = dr["branchname"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        //newrow["DESIGNATION"] = dr["designation"].ToString();
                        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                        //newrow["Gross"]=dr["gross"].ToString();
                        newrow["Gross"] = peryanam / 12;
                        double permonth = peryanam / 12;
                        double HRA = Convert.ToDouble(dr["hra"].ToString());
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                        //newrow["PT"] = dr["profitionaltax"].ToString();
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                        washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                        newrow["paymenttype"] = dr["paymenttype"].ToString();
                        //Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                daysinmonth = Math.Abs(daysinmonth);
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                totalpresentdays = holidays + paydays;
                                double totalpdays = permonth / daysinmonth;
                                loseamount = lop * totalpdays;
                                double perdayconveyance = convenyance / daysinmonth;
                                loseofconviyance = lop * perdayconveyance;
                                double perdaywashing = washingallowance / daysinmonth;
                                loseofwashing = lop * perdaywashing;
                                double perdaymedical = medicalerning / daysinmonth;
                                loseofmedical = lop * perdaymedical;
                                double perdaybasic = BASIC / daysinmonth;
                            }
                        }
                        foreach (DataRow drot in dtOT.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {

                            string ot = drot["extradays"].ToString();
                            double numberofworkingdays = 0;
                            double.TryParse(drot["numberofworkingdays"].ToString(), out numberofworkingdays);
                            double clorwo = 0;
                            double.TryParse(drot["clorwo"].ToString(), out clorwo);
                            daysinmonth = numberofworkingdays + clorwo;
                            daysinmonth = Math.Abs(daysinmonth);
                            double otdays = 0;
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
                                otdays = Convert.ToDouble(drot["extradays"].ToString());
                            }
                            double monthsal = Convert.ToDouble(drot["gross"].ToString());
                            double perdayamt = monthsal / daysinmonth;
                            double otvalue = perdayamt * otdays;
                            // newrow["OT DAYS"] = otdays;
                            newrow["Extra Pay"] = Math.Round(otvalue);
                            otamount = otvalue;
                        }
                        double perdaysal = permonth / daysinmonth;
                        double basic = 50;
                        double basicsalary = (permonth * 50) / 100;
                        double basicpermonth = basicsalary / daysinmonth;
                        double bs = basicpermonth * totalpresentdays;
                        double basicsal = Math.Round(basicsalary - loseamount);
                        double conve = Math.Round(convenyance - loseofconviyance);
                        double medical = Math.Round(medicalerning - loseofmedical);
                        double washing = Math.Round(washingallowance - loseofwashing);
                        double tt = bs + conve + medical + washing;
                        double thra = permonth - loseamount;
                        double hra = Math.Round(thra - tt);
                        totalearnings = Math.Round(hra + tt);
                        // newrow["HRA"] = hra;
                        //newrow["GROSS Earnings"] = totalearnings;
                        string pfeligible = dr["pfeligible"].ToString();
                        if (pfeligible == "Yes")
                        {
                            providentfund = (totalearnings * 6) / 100;
                            if (providentfund > 1800)
                            {
                                providentfund = 1800;
                            }
                            providentfund = Math.Round(providentfund);
                            //newrow["PF"] = providentfund;
                        }
                        else
                        {
                            providentfund = 0;
                            //newrow["PF"] = providentfund;
                        }
                        string esieligible = dr["esieligible"].ToString();
                        if (esieligible == "Yes")
                        {
                            esi = (totalearnings * 1.75) / 100;
                            esi = Math.Round(esi);
                            //newrow["ESI"] = esi;
                        }
                        else
                        {
                            esi = 0;
                            //newrow["ESI"] = esi;
                        }
                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                //newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            //newrow["SALARY ADVANCE"] = salaryadvance;
                        }
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    //newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth);
                                }
                            }
                            else
                            {
                                loan = 0;
                                //newrow["Loan"] = loan;
                            }
                        }
                        else
                        {
                            loan = 0;
                            //newrow["Loan"] = loan;
                        }
                        mobilededuction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                    // newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;

                                    }
                                    else
                                    {
                                        mobilededuction = Convert.ToDouble(deductionamount);
                                        mobilededuction = Math.Round(deductionamount);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        else
                        {
                            mobilededuction = 0;
                            //newrow["MOBILE DEDUCTION"] = mobilededuction;
                        }
                        canteendeduction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        else
                        {
                            canteendeduction = 0;
                            //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                        }
                        medicliamdeduction = 0;
                        if (dtmedicliam.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmedicliam in dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drmedicliam["medicliamamount"].ToString(), out amount);
                                    // newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    medicliamdeduction = Convert.ToDouble(amount);
                                    medicliamdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                medicliamdeduction = 0;
                                // newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                            }
                        }
                        else
                        {
                            medicliamdeduction = 0;
                            // newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                        }
                        // newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        newrow["Net Pay"] = Math.Round(netpay);
                        newrow["Net Amount"] = Math.Round(netpay + otamount);
                        Report.Rows.Add(newrow);
                    }
                }
            }

            else if (ddlemptype.SelectedItem.Text == "Cleaner")
            {
                double totalearnings = 0;
                Report.Columns.Add("Sno");
                //Report.Columns.Add("Employeeid");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("paymenttype");
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("Net Pay").DataType = typeof(double);
                Report.Columns.Add("Employee Signature");
                int branchid = Convert.ToInt32(mainbranch);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.branchname, employedetails.empid, employedetails.employee_num, employedetails.employee_type, monthly_attendance.month, monthly_attendance.year, employedetails.fullname, designation.designation, employebankdetails.paymenttype, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'cash') AND (employedetails.employee_type = 'cleaner') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'cash') AND (employedetails.employee_type = 'cleaner') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //pay strure wrong cleaner staff have
                // cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, branchmaster.branchname, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi,pay_structure. gross,employedetails.employee_type,pay_structure.providentfund, monthly_attendance.month, monthly_attendance.year, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.paymenttype FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (employedetails.status='No') and ((employedetails.employee_type ='Retainers') OR (employedetails.employee_type ='Staff')) and (employebankdetails.paymenttype = 'cash') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid)");
                cmd.Parameters.Add("@branchid", mainbranch);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid) AND (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double totalpresentdays = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        //double totalearnings;
                        double daysinmonth = 0;
                        double loseamount = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        //newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        //newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        //newrow["PT"] = dr["profitionaltax"].ToString();
                        double rateper = Convert.ToDouble(dr["gross"].ToString());
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        newrow["paymenttype"] = dr["paymenttype"].ToString();
                        //newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        //Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                daysinmonth = Math.Abs(daysinmonth);
                                //double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                //newrow["Payable Days"] = paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                //newrow["Rate/Day"] = rateper;
                                double batta = 80;
                                //newrow["Batta/Day"] = batta;
                                double rateperday = rate + batta;
                                totalearnings = rateperday * paydays;
                                double totalpdays = numberofworkingdays - lop;
                                totalearnings = Math.Round(totalearnings);
                                newrow["GROSS Earnings"] = totalearnings;
                            }
                        }



                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Ceiling(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                //newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            //newrow["SALARY ADVANCE"] = salaryadvance;
                        }
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    //newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Ceiling(loanemimonth);
                                }
                            }
                            else
                            {
                                loan = 0;
                                //newrow["Loan"] = loan;
                            }
                        }
                        else
                        {
                            loan = 0;
                            //newrow["Loan"] = loan;
                        }
                        mobilededuction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                    // newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;

                                    }
                                    else
                                    {
                                        mobilededuction = Convert.ToDouble(deductionamount);
                                        mobilededuction = Math.Ceiling(deductionamount);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        else
                        {
                            mobilededuction = 0;
                            //newrow["MOBILE DEDUCTION"] = mobilededuction;
                        }
                        canteendeduction = 0;
                        if (dtcanteen.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Ceiling(deductionamount);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        else
                        {
                            canteendeduction = 0;
                            //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                        }
                        //newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        double netpay = 0;
                        netpay = Math.Ceiling(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        newrow["Net Pay"] = Math.Ceiling(netpay);
                        Report.Rows.Add(newrow);
                    }
                }
            }
            else if (ddlbranchtype.SelectedItem.Text == "Plant" & ddlemptype.SelectedItem.Text == "Casuals")
            {
                if (ddlCompanytype.SelectedItem.Value == "2")
                {
                    Report.Columns.Add("Location");
                    Report.Columns.Add("Sno");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Employee Name");
                    Report.Columns.Add("DESIGNATION");
                    Report.Columns.Add("Net Pay").DataType = typeof(double);
                    Report.Columns.Add("NDA Earnings").DataType = typeof(double);
                    Report.Columns.Add("Net Amount").DataType = typeof(double);
                    Report.Columns.Add("Emp Signature");
                }
                else
                {
                    Report.Columns.Add("Location");
                    Report.Columns.Add("Sno");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Employee Name");
                    Report.Columns.Add("DESIGNATION");
                    Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                    Report.Columns.Add("Net Pay").DataType = typeof(double);
                    Report.Columns.Add("Emp Signature");
                }
                int branchid = Convert.ToInt32(mainbranch);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.gender, employedetails.pfdate, branchmaster.branchname, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, branchmaster.statename, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type = @emptype) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @branchid) AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type = @emptype) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrure
                // cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.gender,employedetails.pfdate, branchmaster.branchname, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year,employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, branchmaster.statename FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid Left Outer Join branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @branchid) AND (employedetails.status = 'No') AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type =@emptype)  AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@emptype", ddlemptype.SelectedItem.Value);
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                if (ddlCompanytype.SelectedItem.Value == "2")
                {
                    cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.clorwo, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, branchmaster.night_allowance, monthly_attendance.night_days, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmaster.company_code='2')");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    //cmd.Parameters.Add("@branchid", branchid);
                }
                else
                {
                    cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.clorwo, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                    //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                }
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where  (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double totalpresentdays = 0;
                        double nightamount = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double numberofworkingdays = 0;
                        double nightduty = 0;
                        double nightallowance = 0;
                        double totalearnings = 0;
                        double daysinmonth = 0;
                        string statename = "";
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        newrow["Location"] = dr["branchname"].ToString();
                        string location = dr["branchname"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Employee Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        statename = dr["statename"].ToString();
                        double rateper = Convert.ToDouble(dr["gross"].ToString());
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {

                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                daysinmonth = Math.Abs(daysinmonth);
                                //double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                if (ddlCompanytype.SelectedItem.Value == "2")
                                {
                                    double.TryParse(dra["night_days"].ToString(), out nightduty);
                                    double.TryParse(dra["night_allowance"].ToString(), out nightallowance);
                                    double totalnightamount = nightduty * nightallowance;
                                    nightamount = totalnightamount;
                                    newrow["NDA Earnings"] = nightamount;
                                }
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                totalpresentdays = holidays + paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                if (location == "Arani CC")
                                {
                                    rate = rate;
                                }
                                else
                                {
                                    rate = rate / daysinmonth;
                                }
                                double batta = 0;
                                if (location == "Tarigonda CC")
                                {
                                    batta = 0;
                                }
                                else
                                {
                                    batta = 0;
                                }
                                string empnumber = dr["employee_num"].ToString();
                                if (empnumber == "SVDS080135")
                                {
                                    // newrow["Batta/Day"] = "0";
                                    batta = 0;
                                }
                                else
                                {
                                    // newrow["Batta/Day"] = batta;
                                }
                                double rateperday = rate + batta;
                                totalearnings = rateperday * paydays;
                                double totalpdays = numberofworkingdays - lop;
                                totalearnings = Math.Round(totalearnings);
                                if (ddlCompanytype.SelectedValue == "2")
                                {
                                    newrow["Net Pay"] = totalearnings;
                                }
                                else
                                {
                                    newrow["GROSS Earnings"] = totalearnings;
                                }
                                if (ddlemptype.SelectedItem.Text != "Casuals")
                                {
                                    if (statename == "AndraPrdesh")
                                    {
                                        if (totalearnings > 1000 && totalearnings <= 15000)
                                        {
                                            profitionaltax = 0;
                                        }
                                        else if (totalearnings >= 15001 && totalearnings <= 20000)
                                        {
                                            profitionaltax = 150;
                                        }
                                        else if (totalearnings >= 20001)
                                        {
                                            profitionaltax = 200;
                                        }
                                    }
                                    if (statename == "Tamilnadu")
                                    {
                                        if (totalearnings < 7000)
                                        {
                                            profitionaltax = 0;
                                        }
                                        else if (totalearnings >= 7001 && totalearnings <= 10000)
                                        {
                                            profitionaltax = 115;
                                        }
                                        else if (totalearnings >= 10001 && totalearnings <= 11000)
                                        {
                                            profitionaltax = 171;
                                        }
                                        else if (totalearnings >= 11001 && totalearnings <= 12000)
                                        {
                                            profitionaltax = 171;
                                        }
                                        else if (totalearnings >= 12001)
                                        {
                                            profitionaltax = 208;
                                        }
                                    }
                                    if (statename == "karnataka")
                                    {
                                        if (totalearnings <= 15000 && totalearnings <= 15001)
                                        {
                                            profitionaltax = 0;
                                        }
                                        else if (totalearnings >= 15001)
                                        {
                                            profitionaltax = 200;
                                        }
                                    }
                                }
                                //newrow["PT"] = profitionaltax;
                            }
                        }

                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                // newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    //newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
                                //newrow["Loan"] = loan;
                            }
                        }
                        mobilededuction = 0;
                        if (dtmobile.Rows.Count > 0)
                        {
                            DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
                                    //newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        //newrow["MOBILE DEDUCTION"] = mobilededuction;

                                    }
                                    else
                                    {
                                        mobilededuction = Convert.ToDouble(deductionamount);
                                        mobilededuction = Math.Round(deductionamount, 0);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                //newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        canteendeduction = 0;
                        if (dtcanteen.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount, 0);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        // newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay + nightamount);
                        netpay = Math.Round(netpay, 0);
                        string stramount = "";
                        stramount = netpay.ToString();
                        if (stramount == "NaN" || stramount == "" || numberofworkingdays == 0)
                        {
                        }
                        else
                        {
                            if (ddlCompanytype.SelectedValue == "2")
                            {
                                newrow["Net Amount"] = Math.Round(netpay, 0);
                            }
                            else
                            {
                                newrow["Net Pay"] = Math.Round(netpay, 0);
                            }
                            Report.Rows.Add(newrow);
                        }
                        //newrow["Net Pay"] = Math.Ceiling(netpay);
                    }
                }
                DataRow newTotal1 = Report.NewRow();
                newTotal1["Employee Name"] = "Total";
                double valt = 0.0;
                foreach (DataColumn dc in Report.Columns)
                {
                    if (dc.DataType == typeof(Double))
                    {
                        valt = 0.0;
                        double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out valt);
                        if (valt == 0)
                        {
                        }
                        else
                        {
                            newTotal1[dc.ToString()] = valt;
                        }
                    }
                }
                Report.Rows.Add(newTotal1);
                grdReports.DataSource = Report;
                grdReports.DataBind();
                Session["xportdata"] = Report;
                hidepanel.Visible = true;
            }

            else if (ddlemptype.SelectedItem.Text == "KMM Casuals")
            {
                double totalearnings = 0;
                Report.Columns.Add("Sno");
                //Report.Columns.Add("Employeeid");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("paymenttype");
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("Net Pay").DataType = typeof(double);
                Report.Columns.Add("Employee Signature");
                int branchid = Convert.ToInt32(mainbranch);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.paymenttype, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN  designation ON employedetails.designationid = designation.designationid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR(employedetails.status = 'No') AND (employebankdetails.paymenttype = 'Cash') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrure not coming data
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible,employedetails.employee_type, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.paymenttype FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid=@branchid) and (employedetails.status='No') and (employedetails.employee_type=@emptype) and (employebankdetails.paymenttype = 'Cash')");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid)AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    foreach (DataRow dr in dtsalary.Rows)
                    {
                        double totalpresentdays = 0;
                        double profitionaltax = 0;
                        double salaryadvance = 0;
                        double loan = 0;
                        double canteendeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        //double totalearnings;
                        double daysinmonth = 0;
                        double loseamount = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["Sno"] = i++.ToString();
                        // newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        //newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        //double rateper = Convert.ToDouble(dr["gross"].ToString());
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        newrow["paymenttype"] = dr["paymenttype"].ToString();
                        //Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                //newrow["Work Days"] = daysinmonth.ToString();
                                //double rateperday = 0;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                //newrow["Payable Days"] = paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                //newrow["Rate/Day"] = rate;
                                totalearnings = rate * paydays;
                                double totalpdays = numberofworkingdays - lop;
                                totalearnings = Math.Round(totalearnings);
                                newrow["GROSS Earnings"] = totalearnings;
                            }
                        }



                        if (dtsa.Rows.Count > 0)
                        {
                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                    //newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Ceiling(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                //newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            //newrow["SALARY ADVANCE"] = salaryadvance;
                        }
                        canteendeduction = 0;
                        if (dtcanteen.Rows.Count > 0)
                        {
                            DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double deductionamount = 0;
                                    double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
                                    //newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Ceiling(deductionamount);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        else
                        {
                            canteendeduction = 0;
                            //newrow["CANTEEN DEDUCTION"] = canteendeduction;
                        }
                        //newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan);
                        double netpay = 0;
                        netpay = Math.Ceiling(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        newrow["Net Pay"] = Math.Ceiling(netpay);
                        Report.Rows.Add(newrow);

                    }
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

    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Location");
            // GridViewGroup seconf = new GridViewGroup(grdReports, First, "Location");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[3].Text == "Total Amount")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }

    protected void btnlogssave_click(object sender, EventArgs e)
    {
        DBManager SalesDB = new DBManager();
        DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
        DataTable empid = Session["empid"] as DataTable;
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, departments.department, departments.deptid, designation.designation, designation.designationid,branchmaster.branchname FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE(branchmapping.mainbranch = @m) AND (employedetails.status = 'No')");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];        
        DataTable dtlogs = new DataTable();
        dtlogs = (DataTable)Session["xportdata"];
        if (dtlogs.Rows.Count > 0)
        {
            DateTime doe = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string branchtype = ddlbranchtype.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string type = ddlemptype.SelectedItem.Value;
            int premonth = 0;
            string newmonth = "0";
            int.TryParse(month, out premonth);
            premonth = premonth - 1;
            if (premonth >= 10)
            {
                newmonth = premonth.ToString();
            }
            else
            {
                newmonth = "0" + premonth;
            }
            cmd = new SqlCommand("SELECT COUNT(monthlysalarystatement.empid) AS empid  FROM monthlysalarystatement INNER JOIN  branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid WHERE (monthlysalarystatement.month = @month) AND (monthlysalarystatement.emptype = @emptype) AND (monthlysalarystatement.year = @year) AND  (branchmaster.branchtype = @branch) HAVING (COUNT(monthlysalarystatement.month) > 0)");
            cmd.Parameters.Add("@branch", branchtype);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@emptype", type);
            cmd.Parameters.Add("@month", premonth);
            DataTable dtmonth = vdm.SelectQuery(cmd).Tables[0];
            if (dtmonth.Rows.Count > 0)
            {
                cmd = new SqlCommand("SELECT * FROM monthlysalarystatement INNER JOIN branchmaster ON monthlysalarystatement.branchid = branchmaster.branchid WHERE (monthlysalarystatement.month = @month) AND (monthlysalarystatement.emptype = @type) AND (monthlysalarystatement.year = @year) AND (branchmaster.branchtype = @branch)");
                cmd.Parameters.Add("@branch", branchtype);
                cmd.Parameters.Add("@month", month);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@type", type);
                DataTable dtdata = vdm.SelectQuery(cmd).Tables[0];
                if (dtdata.Rows.Count > 0)
                {
                    lblmsg.Text = "THIS MONTH OF DATA ALREADY CLOSED ";
                    return;
                }
                else
                {
                    foreach (DataRow dr in dtlogs.Rows)
                    {
                        //string location = dr["Location"].ToString();
                        string employeid = "";
                        string employecode = dr["Employee Code"].ToString();
                        string location = dr["Location"].ToString();
                        foreach (DataRow dremployee in dtemployee.Select("employee_num='" + employecode + "'"))
                        {
                            location = dremployee["branchid"].ToString();
                            employeid = dremployee["empid"].ToString();
                        }
                        string sno = dr["Sno"].ToString();                        
                        string name = dr["Name"].ToString();
                        string payment = dr["paymenttype"].ToString();
                        string gross = dr["Gross"].ToString();
                        string netpay = dr["Net Pay"].ToString();
                        string extrapay = dr["Extra Pay"].ToString();
                        string conve = dr["Conveyance"].ToString();
                        string netamount = dr["Net Amount"].ToString();
                        cmd = new SqlCommand("insert into monthlysalarystatement (empid,employecode,empname,gross,netpay,extrapay,conveyance,branchid) values(@empid,@employecode,@empname,@gross,@netpay,extrapay,@conveyance,@branchid)");
                        cmd.Parameters.Add("@employecode", employecode);
                        cmd.Parameters.Add("@empid", employeid);
                        cmd.Parameters.Add("@branchid", location);
                        cmd.Parameters.Add("@empname", name);
                        cmd.Parameters.Add("@gross", gross);
                        cmd.Parameters.Add("@netpay", netpay);
                        cmd.Parameters.Add("@extrapay", extrapay);
                        cmd.Parameters.Add("@conveyance", conve);
                        //SalesDB.insert(cmd);
                        lblmsg.Text = " Employee are successfully saved"; 
                    }
                }
            }
            else
            {
                lblmsg.Text = "Please Finalize Previous Month Salary";
            }
        }
    }
}