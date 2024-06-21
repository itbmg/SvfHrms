using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;


public partial class SAPMarketingSalaryReport : System.Web.UI.Page
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
                    DateTime dtfrom = DateTime.Now.AddMonths(0);
                    DateTime dtyear = DateTime.Now.AddYears(0);
                    dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    FillBranches();
                    bindemployeetype();
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

    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails where (employee_type<>'')   GROUP BY employee_type");
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
            DBManager SalesDB = new DBManager();
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
            string namonth = dt.ToString("MMM yy");
            Session["xporttype"] = "TallySalarys";

            lblHeading.Text = ddlbranches.SelectedItem.Text + " Tally Salary Statement" + ddlmonth.SelectedItem.Text + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;

            fromdate = Convert.ToDateTime(date);
            Session["filename"] = ddlbranches.SelectedItem.Text + " Tally Salary Statement " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranches.SelectedItem.Text + " Tally Salary Statement " + ddlmonth.SelectedItem.Text + year;
            string invoivebranch = "";
            string sapcode = "";
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname, branchmaster.branchcode,branchmaster.sapcode FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
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

            string invoice = "" + invoivebranch + "JV" + mymonth + "";

            if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Permanent")
            {

                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("ledgername");
                Report.Columns.Add("ledgercode");
                // Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("GROSS").DataType = typeof(double);
                Report.Columns.Add("DAYS MONTH").DataType = typeof(double);
                Report.Columns.Add("Attendance Days").DataType = typeof(double);
                Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
                Report.Columns.Add("Payable Days").DataType = typeof(double);
                Report.Columns.Add("BASIC").DataType = typeof(double);
                Report.Columns.Add("HRA").DataType = typeof(double);
                Report.Columns.Add("CONVEYANCE ALLOWANCE").DataType = typeof(double);
                Report.Columns.Add("MEDICAL ALLOWANCE").DataType = typeof(double);
                Report.Columns.Add("WASHING ALLOWANCE").DataType = typeof(double);
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("PT").DataType = typeof(double);
                Report.Columns.Add("PF").DataType = typeof(double);
                Report.Columns.Add("ESI").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                Report.Columns.Add("Loan").DataType = typeof(double);
                Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("MEDICLAIM DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("Tds DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("OTHER DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranches.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.ledgercode, employedetails.ledgername,employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_dept = '5')");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
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
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid)");
                // cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                //cmd.Parameters.Add("@month", mymonth);
                //cmd.Parameters.Add("@year", str[2]);
                DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid WHERE (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid WHERE (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];
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
                        double otherdeduction = 0;
                        double tdsdeduction = 0;
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
                        double losofprofitionaltax = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        //newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["ledgername"] = dr["ledgername"].ToString();
                        newrow["ledgercode"] = dr["ledgercode"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                        newrow["GROSS"] = peryanam / 12;
                        double permonth = peryanam / 12;
                        double HRA = Convert.ToDouble(dr["hra"].ToString());
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                        //newrow["PT"] = dr["profitionaltax"].ToString();
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                        washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                        newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                newrow["DAYS MONTH"] = daysinmonth.ToString();
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                newrow["Attendance Days"] = paydays.ToString();
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                if (lop != 0)
                                {
                                    double totaldays = paydays + clorwo;
                                    newrow["Payable Days"] = totaldays;
                                }
                                else
                                {
                                    newrow["Payable Days"] = paydays + clorwo;
                                }
                                if (clorwo == 0)
                                {
                                }
                                else
                                {
                                    newrow["CL HOLIDAY AND OFF"] = clorwo;
                                }
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
                                double perdaprofitionaltax = profitionaltax / daysinmonth;
                                losofprofitionaltax = lop * perdaprofitionaltax;
                            }
                        }
                        double perdaysal = permonth / daysinmonth;
                        double basic = 50;
                        double basicsalary = (permonth * 50) / 100;
                        double basicpermonth = basicsalary / daysinmonth;
                        double bs = basicpermonth * totalpresentdays;
                        newrow["BASIC"] = Math.Round(bs);
                        newrow["CONVEYANCE ALLOWANCE"] = Math.Round(convenyance - loseofconviyance);
                        newrow["MEDICAL ALLOWANCE"] = Math.Round(medicalerning - loseofmedical);
                        newrow["WASHING ALLOWANCE"] = Math.Round(washingallowance - loseofwashing);
                        double basicsal = Math.Round(basicsalary - loseamount);
                        double conve = Math.Round(convenyance - loseofconviyance);
                        double medical = Math.Round(medicalerning - loseofmedical);
                        double washing = Math.Round(washingallowance - loseofwashing);
                        double tt = bs + conve + medical + washing;
                        double thra = permonth - loseamount;
                        double hra = Math.Round(thra - tt);
                        totalearnings = Math.Round(hra + tt);
                        double ptax = 0;
                        if (branchid == 6)
                        {
                            if (totalearnings >= 15000)
                            {
                                ptax = profitionaltax;
                                newrow["PT"] = profitionaltax;
                            }
                            else
                            {
                                ptax = 0;
                                profitionaltax = ptax;
                                newrow["PT"] = ptax;
                            }
                        }
                        else
                        {
                            newrow["PT"] = profitionaltax;
                        }
                        if (hra > 0)
                        {
                            newrow["HRA"] = hra;
                        }
                        else
                        {
                            newrow["HRA"] = 0;
                        }
                        newrow["GROSS Earnings"] = totalearnings;
                        string pfeligible = dr["pfeligible"].ToString();
                        if (pfeligible == "Yes")
                        {
                            providentfund = (totalearnings * 6) / 100;
                            if (providentfund > 1800)
                            {
                                providentfund = 1800;
                            }
                            providentfund = Math.Round(providentfund, 0);
                            newrow["PF"] = Math.Round(providentfund, 0);
                        }
                        else
                        {
                            providentfund = 0;
                            newrow["PF"] = providentfund;
                        }
                        string esieligible = dr["esieligible"].ToString();
                        if (esieligible == "Yes")
                        {
                            esi = (totalearnings * 1.75) / 100;
                            esi = Math.Round(esi, 0);
                            newrow["ESI"] = esi;
                        }
                        else
                        {
                            esi = 0;
                            newrow["ESI"] = esi;
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
                                    if (amount == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["SALARY ADVANCE"] = amount.ToString();
                                        salaryadvance = Convert.ToDouble(amount);
                                        salaryadvance = Math.Round(amount, 0);
                                    }
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                if (salaryadvance == 0)
                                {
                                }
                                else
                                {
                                    newrow["SALARY ADVANCE"] = salaryadvance;
                                }
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            if (salaryadvance == 0)
                            {
                            }
                            else
                            {
                                newrow["SALARY ADVANCE"] = salaryadvance;
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
                                    if (loanemimonth == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["Loan"] = loanemimonth.ToString();
                                        loan = Convert.ToDouble(loanemimonth);
                                        loan = Math.Round(loanemimonth, 0);
                                    }
                                }
                            }
                            else
                            {
                                loan = 0;
                                if (loan == 0)
                                {
                                }
                                else
                                {
                                    newrow["Loan"] = loan;
                                }
                            }
                        }
                        else
                        {
                            loan = 0;
                            if (loan == 0)
                            {
                            }
                            else
                            {
                                newrow["Loan"] = loan;
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
                                    newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    if (st == "0.0")
                                    {
                                        mobilededuction = 0;
                                        newrow["MOBILE DEDUCTION"] = mobilededuction;

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
                                newrow["MOBILE DEDUCTION"] = mobilededuction;
                            }
                        }
                        else
                        {
                            mobilededuction = 0;
                            newrow["MOBILE DEDUCTION"] = mobilededuction;
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
                                    if (deductionamount == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                        string st = deductionamount.ToString();
                                        canteendeduction = Convert.ToDouble(deductionamount);
                                        canteendeduction = Math.Round(deductionamount);
                                    }
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                if (canteendeduction == 0)
                                {
                                }
                                else
                                {
                                    newrow["CANTEEN DEDUCTION"] = canteendeduction;
                                }
                            }
                        }
                        else
                        {
                            canteendeduction = 0;
                            if (canteendeduction == 0)
                            {
                            }
                            else
                            {
                                newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
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
                                    newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    medicliamdeduction = Convert.ToDouble(amount);
                                    medicliamdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                medicliamdeduction = 0;
                                newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                            }
                        }
                        else
                        {
                            medicliamdeduction = 0;
                            newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
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
                                    if (amount == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["OTHER DEDUCTION"] = amount.ToString();
                                        string st = amount.ToString();
                                        otherdeduction = Convert.ToDouble(amount);
                                        otherdeduction = Math.Round(amount, 0);
                                    }
                                }
                            }
                            else
                            {
                                otherdeduction = 0;
                                if (otherdeduction == 0)
                                {
                                }
                                else
                                {
                                    //otherdeduction = 0;
                                    newrow["OTHER DEDUCTION"] = otherdeduction;
                                }
                            }
                        }
                        else
                        {
                            otherdeduction = 0;
                            if (otherdeduction == 0)
                            {
                            }
                            else
                            {
                                //otherdeduction = 0;
                                newrow["OTHER DEDUCTION"] = otherdeduction;
                            }
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
                                    if (amount == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["Tds DEDUCTION"] = amount.ToString();
                                        string st = amount.ToString();
                                        tdsdeduction = Convert.ToDouble(amount);
                                        tdsdeduction = Math.Round(amount, 0);
                                    }
                                }
                            }
                            else
                            {
                                tdsdeduction = 0;
                                if (tdsdeduction == 0)
                                {
                                }
                                else
                                {

                                    newrow["Tds DEDUCTION"] = tdsdeduction;
                                }
                            }
                        }
                        else
                        {
                            tdsdeduction = 0;
                            if (tdsdeduction == 0)
                            {
                            }
                            else
                            {
                                newrow["Tds DEDUCTION"] = tdsdeduction;
                            }
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 0);
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                        Report.Rows.Add(newrow);
                    }
                }
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
                    if (val == 0)
                    {
                    }
                    else
                    {
                        newTotal[dc.ToString()] = val;
                    }
                }
            }
            Report.Rows.Add(newTotal);

            DataTable dtnew = new DataTable();
            dtnew.Columns.Add("Invoice");
            dtnew.Columns.Add("JV Date");
            dtnew.Columns.Add("WH Code");
            dtnew.Columns.Add("Ledger Code");
            dtnew.Columns.Add("Ledger Name");
            dtnew.Columns.Add("Employee Name");
            dtnew.Columns.Add("Amount");
            dtnew.Columns.Add("Narration");
            string designation = "Total";
            var k = 1;
            string tnarration = "";
            cmd = new SqlCommand("SELECT groupledgername.ledgername, groupledgername.ledgercode,groupledgername.glcodesno, glgroup.glname,glgroup.sno FROM glgroup INNER JOIN groupledgername ON glgroup.sno = groupledgername.glcodesno INNER JOIN branchmaster ON groupledgername.branchid = branchmaster.branchid WHERE (groupledgername.branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranches.SelectedValue);
            DataTable dtledger = vdm.SelectQuery(cmd).Tables[0];
            foreach (DataRow dreport in Report.Select("DESIGNATION='" + designation + "'"))
            {
                double tnetpay = 0;
                double tgross = 0;
                string narration = "";
                DataRow nr_sp = dtnew.NewRow();
                nr_sp["Invoice"] = invoice;
                nr_sp["JV Date"] = talydate;
                string salpayable = "1";
                string sal_ledger = "";
                foreach (DataRow dr in dtledger.Select("sno='" + salpayable + "'"))
                {
                    sal_ledger = dr["ledgername"].ToString();
                    nr_sp["Ledger Code"] = dr["ledgercode"].ToString();
                }
                nr_sp["WH Code"] = sapcode;
                nr_sp["Ledger Name"] = sal_ledger;
                double amt = 0;
                double.TryParse(dreport["NET PAY"].ToString(), out amt);
                amt = Math.Round(amt, 2);
                string amount = "-" + amt + "";
                nr_sp["Amount"] = amount;
                tnetpay = Convert.ToDouble(amt);
                string ddgross=dreport["GROSS Earnings"].ToString();
                if (ddgross == "" || ddgross == null)
                {
                    ddgross = "0";
                }
                tgross = Convert.ToDouble(ddgross);
                narration = "Being The SVDS " + ddlbranches.SelectedItem.Text + " salaries For the Month Of " + namonth + ", Total Gross=" + tgross + "/-,NetPay=" + tnetpay + "/- ";
                nr_sp["Narration"] = narration;
                dtnew.Rows.Add(nr_sp);

                if (ddlemptype.SelectedItem.Text == "Cleaner" || ddlemptype.SelectedItem.Text == "Driver")
                {
                }
                else
                {
                    DataRow nr_mp = dtnew.NewRow();
                    nr_mp["Invoice"] = invoice;
                    nr_mp["JV Date"] = talydate;
                    string medicliampayble = "2";
                    string medicl_lger = "";
                    foreach (DataRow dr in dtledger.Select("sno='" + medicliampayble + "'"))
                    {
                        medicl_lger = dr["ledgername"].ToString();
                        nr_mp["Ledger Code"] = dr["ledgercode"].ToString();
                    }
                    nr_mp["WH Code"] = sapcode;
                    nr_mp["Ledger Name"] = medicl_lger;
                    nr_mp["Narration"] = narration;
                    double MEDICLAIM = 0;
                    double.TryParse(dreport["MEDICLAIM DEDUCTION"].ToString(), out MEDICLAIM);
                    if (MEDICLAIM == 0.0)
                    {
                    }
                    else
                    {
                        double mamt = 0;
                        double.TryParse(dreport["MEDICLAIM DEDUCTION"].ToString(), out mamt);
                        mamt = Math.Round(mamt, 2);
                        string mamount = "-" + mamt + "";
                        nr_mp["Amount"] = mamount;
                        dtnew.Rows.Add(nr_mp);
                    }
                    DataRow tdr_mp = dtnew.NewRow();
                    tdr_mp["Invoice"] = invoice;
                    tdr_mp["JV Date"] = talydate;
                    string tdspayble = "3";
                    string tds_ledger = "";
                    foreach (DataRow dr in dtledger.Select("sno='" + tdspayble + "'"))
                    {
                        tds_ledger = dr["ledgername"].ToString();
                        tdr_mp["Ledger Code"] = dr["ledgercode"].ToString();
                    }
                    tdr_mp["WH Code"] = sapcode;
                    tdr_mp["Ledger Name"] = tds_ledger;

                    //tdr_mp["Ledger Name"] = "TDS-Payble Employees - " + ddlbranches.SelectedItem.Text + "";
                    tdr_mp["Narration"] = narration;
                    double tds = 0;
                    double.TryParse(dreport["Tds DEDUCTION"].ToString(), out tds);
                    if (tds == 0.0)
                    {
                    }
                    else
                    {
                        double tdsamt = 0;
                        double.TryParse(dreport["Tds DEDUCTION"].ToString(), out tdsamt);
                        tdsamt = Math.Round(tdsamt, 2);
                        string tdsamount = "-" + tdsamt + "";
                        tdr_mp["Amount"] = tdsamount;
                        dtnew.Rows.Add(tdr_mp);
                    }
                }
                DataRow nr_tp = dtnew.NewRow();
                //nr_tp["Employee Name"] = empname;
                nr_tp["Invoice"] = invoice;
                nr_tp["JV Date"] = talydate;
                string telphonepayble = "4";
                string telphone_ledger = "";
                foreach (DataRow dr in dtledger.Select("sno='" + telphonepayble + "'"))
                {
                    telphone_ledger = dr["ledgername"].ToString();
                    nr_tp["Ledger Code"] = dr["ledgercode"].ToString();
                }
                nr_tp["WH Code"] = sapcode;
                nr_tp["Ledger Name"] = telphone_ledger;
                //nr_tp["Ledger Name"] = "Telephone & Telex - " + ddlbranches.SelectedItem.Text + "";
                nr_tp["Narration"] = narration;
                double MOBILE = 0;
                double.TryParse(dreport["MOBILE DEDUCTION"].ToString(), out MOBILE);
                if (MOBILE == 0.0)
                {
                }
                else
                {
                    double moamt = 0;
                    double.TryParse(dreport["MOBILE DEDUCTION"].ToString(), out moamt);
                    string en = dreport["Name"].ToString();
                    nr_tp["Employee Name"] = en;
                    moamt = Math.Round(moamt, 2);
                    string moamount = "-" + moamt + "";
                    nr_tp["Amount"] = moamount;
                    dtnew.Rows.Add(nr_tp);
                }

                DataRow nr_pt = dtnew.NewRow();
                nr_pt["Invoice"] = invoice;
                nr_pt["JV Date"] = talydate;
                string Ptpayble = "5";
                string pt_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + Ptpayble + "'"))
                {
                    pt_ledgr = dr["ledgername"].ToString();
                    nr_pt["Ledger Code"] = dr["ledgercode"].ToString();
                }
                nr_pt["WH Code"] = sapcode;
                nr_pt["Ledger Name"] = pt_ledgr;
                //nr_pt["Ledger Name"] = "Professional Tax Payble- " + ddlbranches.SelectedItem.Text + "";
                nr_pt["Narration"] = narration;
                double PT = 0;
                double.TryParse(dreport["PT"].ToString(), out PT);
                if (PT == 0.0)
                {
                }
                else
                {
                    double ptamt = 0;
                    double.TryParse(dreport["PT"].ToString(), out ptamt);
                    ptamt = Math.Round(ptamt, 2);
                    string ptamount = "-" + ptamt + "";
                    nr_pt["Amount"] = ptamount;
                    dtnew.Rows.Add(nr_pt);
                }
                if (ddlemptype.SelectedItem.Text == "Cleaner" || ddlemptype.SelectedItem.Text == "Driver")
                {
                }
                else
                {
                    DataRow nr_pf = dtnew.NewRow();
                    nr_pf["Invoice"] = invoice;
                    nr_pf["JV Date"] = talydate;
                    string PFpayble = "13";
                    string PF_ledgr = "";
                    foreach (DataRow dr in dtledger.Select("sno='" + PFpayble + "'"))
                    {
                        PF_ledgr = dr["ledgername"].ToString();
                        nr_pf["Ledger Code"] = dr["ledgercode"].ToString();
                    }
                    nr_pf["WH Code"] = sapcode;
                    nr_pf["Ledger Name"] = PF_ledgr;
                    //nr_pf["Ledger Name"] = "EPF Employee Contribution- " + ddlbranches.SelectedItem.Text + "";
                    nr_pf["Narration"] = narration;
                    double PF = 0;
                    double.TryParse(dreport["PF"].ToString(), out PF);
                    if (PF == 0.0)
                    {
                    }
                    else
                    {
                        double pfamt = 0;
                        double.TryParse(dreport["PF"].ToString(), out pfamt);
                        pfamt = Math.Round(pfamt, 2);
                        string pfamount = "-" + pfamt + "";
                        nr_pf["Amount"] = pfamount;
                        dtnew.Rows.Add(nr_pf);
                    }

                    DataRow nr_esi = dtnew.NewRow();
                    nr_esi["Invoice"] = invoice;
                    nr_esi["JV Date"] = talydate;
                    string esipayble = "14";
                    string ESI_ledgr = "";
                    foreach (DataRow dr in dtledger.Select("sno='" + esipayble + "'"))
                    {
                        ESI_ledgr = dr["ledgername"].ToString();
                        nr_esi["Ledger Code"] = dr["ledgercode"].ToString();
                    }
                    nr_esi["WH Code"] = sapcode;
                    nr_esi["Ledger Name"] = ESI_ledgr;
                    //nr_esi["Ledger Name"] = "Employee Staff Insurance - " + ddlbranches.SelectedItem.Text + "";
                    nr_esi["Narration"] = narration;
                    double ESI = 0;
                    double.TryParse(dreport["ESI"].ToString(), out ESI);
                    if (ESI == 0.0)
                    {
                    }
                    else
                    {
                        double esiamt = 0;
                        double.TryParse(dreport["ESI"].ToString(), out esiamt);
                        esiamt = Math.Round(esiamt, 2);

                        string esiamount = "-" + esiamt + "";
                        nr_esi["Amount"] = esiamount;
                        dtnew.Rows.Add(nr_esi);
                    }
                }
                DataRow nr_cd = dtnew.NewRow();
                nr_cd["Invoice"] = invoice;
                nr_cd["JV Date"] = talydate;
                string messpayble = "15";
                string Mess_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + messpayble + "'"))
                {
                    Mess_ledgr = dr["ledgername"].ToString();
                    nr_cd["Ledger Code"] = dr["ledgercode"].ToString();
                }
                nr_cd["WH Code"] = sapcode;
                nr_cd["Ledger Name"] = Mess_ledgr;
                //nr_cd["Ledger Name"] = "Mess Collection - " + ddlbranches.SelectedItem.Text + "";
                nr_cd["Narration"] = narration;
                double CANTEEN = 0;
                double.TryParse(dreport["CANTEEN DEDUCTION"].ToString(), out CANTEEN);
                if (CANTEEN == 0.0)
                {
                }
                else
                {
                    double camt = 0;
                    double.TryParse(dreport["CANTEEN DEDUCTION"].ToString(), out camt);
                    camt = Math.Round(camt, 2);
                    string camount = "-" + camt + "";
                    nr_cd["Amount"] = camount;
                    dtnew.Rows.Add(nr_cd);
                }

                tnarration = narration;
            }

            foreach (DataRow dreport in Report.Rows)
            {
                string tot = dreport["DESIGNATION"].ToString();
                if (tot == "Total")
                {
                }
                else
                {
                    DataRow nr_salary = dtnew.NewRow();
                    double saladv = 0;
                    double.TryParse(dreport["SALARY ADVANCE"].ToString(), out saladv);
                    //if (saladv > 0)
                    //{
                    nr_salary["Invoice"] = invoice;
                    nr_salary["JV Date"] = talydate;
                    string empname = dreport["Name"].ToString();
                    string ledgername = dreport["ledgername"].ToString();
                    string ledgercode = dreport["ledgercode"].ToString();
                    string desi = dreport["DESIGNATION"].ToString();
                    //nr_salary["Ledger Name"] = "" + empname + "-" + desi + "";
                    nr_salary["Ledger Name"] = ledgername;
                    nr_salary["Ledger Code"] = ledgercode;
                    nr_salary["Ledger Name"] = ledgername;
                    nr_salary["Employee Name"] = empname;
                    nr_salary["WH Code"] = sapcode;
                    nr_salary["Narration"] = tnarration;
                    double Amount = 0;
                    double otherdeduction = 0;
                    double loan = 0;
                    double.TryParse(dreport["SALARY ADVANCE"].ToString(), out Amount);
                    if (ddlemptype.SelectedItem.Text == "Cleaner" || ddlemptype.SelectedItem.Text == "Driver")
                    {
                    }
                    else
                    {
                        double.TryParse(dreport["OTHER DEDUCTION"].ToString(), out otherdeduction);
                    }
                    double.TryParse(dreport["Loan"].ToString(), out loan);
                    double amtdeduction = Amount + otherdeduction + loan;
                    if (amtdeduction == 0.0)
                    {
                    }
                    else
                    {
                        string salamt = amtdeduction.ToString();
                        double camt = 0;
                        double.TryParse(salamt, out camt);
                        camt = Math.Round(camt, 2);
                        string salamount = "-" + camt + "";
                        nr_salary["Amount"] = salamount;

                    }
                    dtnew.Rows.Add(nr_salary);
                    //}
                }
            }
            foreach (DataRow dreport in Report.Select("DESIGNATION='" + designation + "'"))
            {
                DataRow nr_sp = dtnew.NewRow();
                nr_sp["Invoice"] = invoice;
                nr_sp["JV Date"] = talydate;
                string salpayble = "6";
                string sp_ledgr = "";
                foreach (DataRow dr in dtledger.Select("sno='" + salpayble + "'"))
                {
                    sp_ledgr = dr["ledgername"].ToString();
                    nr_sp["Ledger Code"] = dr["ledgercode"].ToString();
                }
                nr_sp["WH Code"] = sapcode;
                nr_sp["Ledger Name"] = sp_ledgr;
                //nr_sp["Ledger Name"] = "Salary - " + ddlbranches.SelectedItem.Text + "";
                nr_sp["Amount"] = dreport["GROSS Earnings"].ToString();
                nr_sp["Narration"] = tnarration;
                dtnew.Rows.Add(nr_sp);
            }
            grdReports.DataSource = dtnew;
            grdReports.DataBind();
            Session["xportdata"] = dtnew;
            hidepanel.Visible = true;
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
                string whcode = dr["WH CODE"].ToString();
                if (AcctCode == "" && whcode == "")
                {
                }
                else
                {
                    sqlcmd = new SqlCommand("Insert into EMROJDT (CreateDate, RefDate, DocDate, TransNo, AcctCode, AcctName, Debit, Credit, B1Upload, Processed,Ref1,OCRCODE,Series) values (@CreateDate, @RefDate, @DocDate,@TransNo, @AcctCode, @AcctName, @Debit, @Credit, @B1Upload, @Processed,@Ref1,@OCRCODE,@Series)");
                    sqlcmd.Parameters.Add("@CreateDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@RefDate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@docdate", GetLowDate(fromdate));
                    sqlcmd.Parameters.Add("@Ref1", dr["Invoice"].ToString());
                    sqlcmd.Parameters.Add("@OCRCODE", dr["WH Code"].ToString());
                    //int TransNo = 1;
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