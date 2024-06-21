using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text.pdf;
using iTextSharp.text;
using System.IO;
using System.Net.Mail;
using System.Configuration;
using System.Net;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Threading;

public partial class SendMailPayslip : System.Web.UI.Page
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
                if (!Page.IsCallback)
                {

                }
            }
        }
    }

    protected void bindgrid()
    {
        string[] filePaths = Directory.GetFiles(Server.MapPath("~/Drawings/"));
        List<System.Web.UI.WebControls.ListItem> Drawings = new List<System.Web.UI.WebControls.ListItem>();
        foreach (string filePath in filePaths)
        {
            Drawings.Add(new System.Web.UI.WebControls.ListItem(Path.GetFileName(filePath), filePath));
        }
        GridView1.DataSource = Drawings;
        GridView1.DataBind();
    }

    protected void btn_generate_click(object sender, EventArgs e)
    {
        try
        {
            vdm = new DBManager();
            string empid = txtsupid.Text;
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
            cmd = new SqlCommand("SELECT branchid From employedetails where empid=@eid");
            cmd.Parameters.Add("@eid", empid);
            DataTable dtbranches = vdm.SelectQuery(cmd).Tables[0];
            if (dtbranches.Rows.Count > 0)
            {
                bid = dtbranches.Rows[0]["branchid"].ToString();
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
                        DateTime dtto = fromdate;
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
                
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employepfdetails.estnumber, employedetails.salarymode, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, pay_structure.salaryperyear, employedetails.joindate, branchmaster.branchname, employepfdetails.pfnumber, employepfdetails.uannumber, employedetails.pancard, employebankdetails.accountno, designation.designation, departments.department, bankmaster.bankname  FROM employebankdetails INNER JOIN bankmaster ON employebankdetails.bankid = bankmaster.sno INNER JOIN employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid ON employebankdetails.employeid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (employedetails.empid = @empid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                //cmd = new SqlCommand("SELECT  employedetails.employee_num, employedetails.empid, employedetails.salarymode, employedetails.state, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, pay_structure.salaryperyear, branchmaster.statename FROM employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (employedetails.empid = @empid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@empid", empid);
                cmd.Parameters.Add("@month", amonth);
                cmd.Parameters.Add("@year", ayear);
                DataTable routes = vdm.SelectQuery(cmd).Tables[0];
                foreach (DataRow dr in routes.Rows)
                {
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
                    //getsaldetails.salaryadvance = "3000";
                    string empsno = empid;
                    string empname = dr["fullname"].ToString();
                    string statename = dr["statename"].ToString();
                    string joidate = dr["joindate"].ToString();
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
                    int days = Convert.ToInt32(dr["lop"].ToString());
                    //int daysInmonth = DateTime.DaysInMonth(year, month);
                    //string year = dr["year"].ToString();
                    TimeSpan t = dttodate - dtfromdate;
                    //double NrOfDays = Convert.ToDouble(t);
                    double NrOfDays = t.TotalDays;
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

                    // getsaldetails.attandancedays = monthsalary.ToString();
                    double otval = Convert.ToDouble(20000);
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
                                double pf = 12;
                                providentfound = Math.Round(erbasic * pf) / 100;
                            }
                            if (esieligible == "No")
                            {
                                esi = 0;
                            }
                            else
                            {
                                double esiper = 1.75;
                                esi = Math.Round(totalsal * esiper) / 100;
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
                                if (msal < 3500)
                                {
                                    professionaltax = 0;
                                }
                                else if (msal >= 3501 && msal <= 5000)
                                {
                                    professionaltax = 16.6;
                                }
                                else if (msal >= 5001 && msal <= 9000)
                                {
                                    professionaltax = 40;
                                }
                                else if (msal >= 9001 && msal <= 10000)
                                {
                                    professionaltax = 85;
                                }
                                else if (msal >= 10001 && msal <= 12500)
                                {
                                    professionaltax = 126.67;
                                }
                                else if (msal >= 12501)
                                {
                                    professionaltax = 182.50;
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
                            totalernings = tot + hre;
                            grosstotalernings = Math.Round(ghtotal + grosshra);
                            totaldeduction = Math.Round(professionaltax + providentfound + esi + canten + salaryadvance + incometax + loan);
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
                                double pf = 12;
                                providentfound = Math.Round(erbasic * pf) / 100;
                            }
                            if (esieligible == "No")
                            {
                                esi = 0;
                            }
                            else
                            {
                                double esiper = 1.75;
                                esi = Math.Round(totalsal * esiper) / 100;
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
                            double perdaywashing = 1000 / noofdays;
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
                                if (msal < 3500)
                                {
                                    professionaltax = 0;
                                }
                                else if (msal >= 3501 && msal <= 5000)
                                {
                                    professionaltax = 16.6;
                                }
                                else if (msal >= 5001 && msal <= 9000)
                                {
                                    professionaltax = 40;
                                }
                                else if (msal >= 9001 && msal <= 10000)
                                {
                                    professionaltax = 85;
                                }
                                else if (msal >= 10001 && msal <= 12500)
                                {
                                    professionaltax = 126.67;
                                }
                                else if (msal >= 12501)
                                {
                                    professionaltax = 182.50;
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
                            totalernings = Math.Round(tot + hre);
                            grosstotalernings = ghtotal + grosshra;
                            totaldeduction = Math.Round(professionaltax + providentfound + esi + canten + incometax + salaryadvance + loan);
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
                    txtempcode.Text = employeid;
                    txtempname.Text = empname;
                    joindate = joidate;
                    desigiation = desigination;
                    depatment = department;
                    branch = Location;
                    pfn = PFNO;
                    uan = PFUAN;
                    bank = bankname;
                    accountno = accountnumber;
                    esin = ESINo;
                    txtmonth.Text = MonthName;
                    txtnoofdays.Text = NrOfDays.ToString();
                    txtdayspaid.Text = dayspaid.ToString();
                    txtlop.Text = lop;
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
                }
                PaySlipPDFGeneration();
                //SendMail(msgTo, msgSubject, msgBody);
                //SendMail();
            }
            //PaySlipPDFGeneration();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        bindgrid();

    }

    protected void PaySlipPDFGeneration()
    {
        string EmployeeCode = txtempcode.Text;
        string EmpName = txtempname.Text;
        string ForMonth = txtmonth.Text;
        string NoofDays = txtnoofdays.Text;
        string DaysPaid = txtdayspaid.Text;
        string LOP = txtlop.Text;
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

        DateTime dt = DateTime.Now;
        string year = "2016";
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

        cell = new PdfPCell(new Phrase("SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD", BoldFont));
        cell.FixedHeight = 20.0f;
        cell.Colspan = 4;
        cell.Border = Rectangle.NO_BORDER;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_LEFT;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase("SURVEY NO 381-2, PUNABAKA(V), PELLAKUR(M), SPSR NELLORE DT - 524129.", NormalFont));
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

        cell = new PdfPCell(new Phrase("OTHER LOAN", NormalFont));
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);

        cell = new PdfPCell(new Phrase(loan, NormalFont));
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

        //cell = new PdfPCell(new Phrase(""));
        //cell.FixedHeight = 75.0f;
        //cell.Colspan = 6;
        //cell.Border = Rectangle.NO_BORDER;
        //table.AddCell(cell);

        cell = new PdfPCell(new Phrase("NOTE: This is computer generated payslip and needs no signature. If there is any discrepancy in your pay, you need to contact us within 3 days after payslip issue.", NormalFont));
        cell.FixedHeight = 15.0f;
        cell.Colspan = 5;
        cell.HorizontalAlignment = Element.ALIGN_LEFT;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);



        cell = new PdfPCell(new Phrase("Phone: +91 90870 22244, Email; hr@vyshnavi.in, www.vyshnavidairy.com", NormalFont));
        cell.FixedHeight = 15.0f;
        cell.Colspan = 5;
        cell.Border = Rectangle.NO_BORDER;
        cell.HorizontalAlignment = Element.ALIGN_CENTER;
        cell.VerticalAlignment = Element.ALIGN_MIDDLE;
        table.AddCell(cell);
        doc.Add(table);

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
        string msgTo = "naveen15444@gmail.com";
        string msgSubject = "PaySlip";
        //string msgcontent="Dear SK. Naseema Begam, We are sending your payslip for the month Jun 2016 as an attachment with this mail.Note: This is an auto-generated mail. Please do not reply";
        string msgBody = PaySlipPath;
        SendMail(msgTo, msgSubject, msgBody);
        //System.IO.File.Delete(Server.MapPath(PaySlipPath));
        //response.End();[;'
    }

    protected void SendMail(string msgTo, string msgSubject, string msgBody)
    {
        try
        {
            string email = msgTo;
            //string cellphone = "9490003933";
            string toAddress = email;
            string subject = "Payslip";
            //string content = "Dear SK. Naseema Begam, We are sending your payslip for the month Jun 2016 as an attachment with this mail.Note: This is an auto-generated mail. Please do not reply";
            string result = "Payslip";
            string senderID = "ravindra@vyshnavi.in";// use sender's email id here..
            const string senderPassword = "Ravindra@123"; // sender password here...
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
            MailMessage message = new MailMessage(senderID, toAddress, subject, "<html><body><iframe src=" + msgBody + "></iframe></body></html>");
            message.Attachments.Add(new Attachment(new MemoryStream(data), msgBody));
            message.IsBodyHtml = true;
            smtp.Send(message);
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
            //Handle the exception that, mail does not sent                
        }
    }
}