using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;

public partial class compensationitemstatement : System.Web.UI.Page
{
    ///string BranchID = "";
    SqlCommand cmd;
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
                DateTime dtfrom = DateTime.Now.AddMonths(-1);
                //dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
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
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("Amount").DataType = typeof(double);
            vdm = new DBManager();
            string noofmonths = "1";
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            DateTime dtfromdate = ServerDateCurrentdate;
            DateTime dttodate = ServerDateCurrentdate;
            string amonth = "";
            string ayear = "";
            double otdays = 0;
            string bid = "";
            //string statename = "";
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
            DateTime fromdate = ServerDateCurrentdate;
            //DateTime todate = DateTime.Now;
            DateTime dtfrom = fromdate.AddMonths(-1);
            string frmdate = dtfrom.ToString("MM/dd/yyyy");
            string frommonth = dtfrom.ToString("MMM");
            string[] str = frmdate.Split('/');
            int lastmonth = 24;
            int years = Convert.ToInt32(str[2]);
            int months = Convert.ToInt32(str[0]);
            dtfromdate = new DateTime(years, months, lastmonth);
            amonth = str[0];
            string day = (fromdate.Day).ToString();
            ayear = str[2];
            int pday = Convert.ToInt32(day);
            int nodays = DateTime.DaysInMonth(years, months);
            if (pday > nodays)
            {
                day = nodays.ToString();
            }
            string date = amonth + "/" + day + "/" + ayear;
            DateTime dtto = fromdate;
            string todate = dtto.ToString("MM/dd/yyyy");
            string[] strto = todate.Split('/');
            int prasentdate = 24;
            int prasentyears = Convert.ToInt32(strto[2]);
            int prasentmonths = Convert.ToInt32(strto[0]);
            dttodate = new DateTime(prasentyears, prasentmonths, prasentdate);

            lblHeading.Text = " Compensation Item Statement" + " " + frommonth + " - " + years;
            Session["filename"] = "Compensation Item Statement " + " " + frommonth + " - " + years;
            Session["title"] = " Compensation Item Statement " + " " + frommonth + " - " + years;
            //branchwise
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employepfdetails.estnumber, employedetails.salarymode, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, pay_structure.salaryperyear, employedetails.joindate, branchmaster.branchname, employepfdetails.pfnumber, employepfdetails.uannumber, employedetails.pancard, employebankdetails.accountno, designation.designation, departments.department, bankmaster.bankname  FROM employebankdetails INNER JOIN bankmaster ON employebankdetails.bankid = bankmaster.sno INNER JOIN employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid ON employebankdetails.employeid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
            //branchmapping
            string mainbranch = Session["mainbranch"].ToString();
            //paystrure
            //cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employepfdetails.estnumber, employedetails.salarymode, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays,  monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, pay_structure.salaryperyear, employedetails.joindate, branchmaster.branchname, employepfdetails.pfnumber, employepfdetails.uannumber,employedetails.pancard, employebankdetails.accountno, designation.designation, departments.department, bankmaster.bankname FROM employebankdetails INNER JOIN bankmaster ON employebankdetails.bankid = bankmaster.sno INNER JOIN employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN  pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid ON employebankdetails.employeid = employedetails.empid INNER JOIN  branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @m)");
            cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.empid, employepfdetails.estnumber, employedetails.salarymode, branchmaster.statename, employedetails.pfeligible, employedetails.esieligible, employedetails.fullname, monthly_attendance.lop, monthly_attendance.numberofworkingdays, monthly_attendance.otdays, monthly_attendance.clorwo, monthly_attendance.extradays, monthly_attendance.month, monthly_attendance.year, employedetails.joindate, branchmaster.branchname, employepfdetails.pfnumber, employepfdetails.uannumber, employedetails.pancard, employebankdetails.accountno, designation.designation, departments.department, bankmaster.bankname, salaryappraisals.gross, salaryappraisals.salaryperyear FROM employebankdetails INNER JOIN bankmaster ON employebankdetails.bankid = bankmaster.sno INNER JOIN employedetails INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN departments ON employedetails.employee_dept = departments.deptid ON employebankdetails.employeid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employepfdetails ON employedetails.empid = employepfdetails.employeid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @m) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @m) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
            cmd.Parameters.Add("@d1", date);
            cmd.Parameters.Add("@m", mainbranch);
            cmd.Parameters.Add("@month", amonth);
            cmd.Parameters.Add("@year", ayear);
            DataTable routes = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT deductionamount, empid from mobile_deduction where  month = @emonth AND year= @eyear");
            cmd.Parameters.Add("@emonth", amonth);
            cmd.Parameters.Add("@eyear", ayear);
            DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT amount, empid from canteendeductions where month = @cmonth AND year= @cyear");
            cmd.Parameters.Add("@cmonth", amonth);
            cmd.Parameters.Add("@cyear", ayear);
            DataTable dtcantenn = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("SELECT amount, empid from salaryadvance where  month = @Smonth AND year= @Syear");
            cmd.Parameters.Add("@Smonth", amonth);
            cmd.Parameters.Add("@Syear", ayear);
            DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("Select loanemimonth, empid from loan_request where month=@lmonth and year=@lyear");
            cmd.Parameters.Add("@lmonth", amonth);
            cmd.Parameters.Add("@lyear", ayear);
            DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
            cmd = new SqlCommand("Select medicliamamount, empid from mediclaimdeduction");
            DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
            int i = 1;
            foreach (DataRow dr in routes.Rows)
            {
                DataRow newrow = Report.NewRow();
                newrow["Sno"] = i++;
                string empid = dr["empid"].ToString();
                if (dtmobile.Rows.Count > 0)
                {
                    foreach (DataRow drmobile in dtmobile.Select("empid='" + empid + "'"))
                    {
                        double amount = 0;
                        double.TryParse(drmobile["deductionamount"].ToString(), out amount);
                        mobilededuction = Convert.ToDouble(amount);
                        mobilededuction = Math.Round(amount, 0);
                    }
                }
                if (dtcantenn.Rows.Count > 0)
                {
                    foreach (DataRow drcanteen in dtcantenn.Select("empid='" + empid + "'"))
                    {
                        double amount = 0;
                        double.TryParse(drcanteen["amount"].ToString(), out amount);
                        canteendeduction = Convert.ToDouble(amount);
                        canteendeduction = Math.Round(amount, 0);

                    }
                }
                if (dtsalary.Rows.Count > 0)
                {
                    foreach (DataRow drsa in dtsalary.Select("empid='" + empid + "'"))
                    {
                        double amount = 0;
                        double.TryParse(drsa["amount"].ToString(), out amount);
                        salaryadvance = Convert.ToDouble(amount);
                        salaryadvance = Math.Round(amount, 0);
                    }
                }
                if (dtloan.Rows.Count > 0)
                {
                    foreach (DataRow drloan in dtloan.Select("empid='" + empid + "'"))
                    {
                        double amount = 0;
                        double.TryParse(drloan["loanemimonth"].ToString(), out amount);
                        loan = Convert.ToDouble(amount);
                        loan = Math.Round(amount, 0);
                    }
                }
                if (dtmedicliam.Rows.Count > 0)
                {
                    foreach (DataRow drmediclm in dtmedicliam.Select("empid='" + empid + "'"))
                    {
                        double amount = 0;
                        double.TryParse(drmediclm["medicliamamount"].ToString(), out amount);
                        medicalcilam = Convert.ToDouble(amount);
                        medicalcilam = Math.Round(amount, 0);
                    }
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
                string lossofdays = dr["lop"].ToString();
                double days = 0;
                if (lossofdays == "")
                {
                    days = 0;
                }
                else
                {
                    days = Convert.ToDouble(lossofdays);
                }
                //int daysInmonth = DateTime.DaysInMonth(year, month);
                //string year = dr["year"].ToString();
                TimeSpan t = dttodate - dtfromdate;
                //double NrOfDays = Convert.ToDouble(t);
                double NrOfDays = t.TotalDays;
                string daysinmonth = NrOfDays.ToString();
                List<DateTime> dates = new List<DateTime>();
                double countsundays = 0;
                countsundays = Convert.ToDouble(dr["clorwo"].ToString());
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
                double attandancedays = totaldays - lossofpay;
                // getsaldetails.attandancedays = monthsalary.ToString();
                double otval = Convert.ToDouble(20000);
                if (monthsalary < otval)
                {
                    double.TryParse(dr["otdays"].ToString(),out otdays);
                }
                else
                {
                    otdays = 0;
                }
                if (salarymode == "0")
                {
                    if (lop == "0")
                    {
                        msal = Convert.ToDouble(monthsal);
                        //msal = 18000;                            
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
                        totalernings = tot + hre;
                        grosstotalernings = Math.Round(ghtotal + grosshra);
                        totaldeduction = Math.Round(professionaltax + providentfound + esi + canten + salaryadvance + incometax + loan + mobilededuction + medicalcilam);
                        netsal = Math.Round(totalernings - totaldeduction);
                    }
                    else
                    {
                        msal = Convert.ToDouble(monthsal);
                        double perdayamount = msal / NrOfDays;
                        double lossofamount = lossofpay * perdayamount;
                        double totalsal = Math.Round(msal - lossofamount);
                        if (otdays > 0)
                        {
                            otvalue = Convert.ToDouble(otdays) * perdayamount;
                        }
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
                        totalernings = Math.Round(tot + hre);
                        grosstotalernings = ghtotal + grosshra;
                        totaldeduction = Math.Round(professionaltax + providentfound + esi + canten + incometax + salaryadvance + loan + mobilededuction + medicalcilam);
                        netsal = Math.Round(totalernings - totaldeduction);
                    }

                    if (ddlcompantype.SelectedItem.Value == "1")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = attandancedays;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "2")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = grosssal;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "3")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = grossbasic;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "4")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = hre;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "5")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = conveyanceallavance;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "6")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = medicalallavance;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "7")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = washingallowance;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "8")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = canteendeduction;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "9")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = mobilededuction;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "10")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = mobilededuction;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "11")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = providentfound;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "12")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = esi;
                        Report.Rows.Add(newrow);
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
                    if (ddlcompantype.SelectedItem.Value == "1")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = attandancedays;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "2")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = grosssal;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "3")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = grossbasic;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "4")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = hre;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "5")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = conveyanceallavance;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "6")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = medicalallavance;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "7")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = washingallowance;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "8")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = canteendeduction;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "9")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = mobilededuction;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "10")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = mobilededuction;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "11")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = providentfound;
                        Report.Rows.Add(newrow);
                    }
                    if (ddlcompantype.SelectedItem.Value == "12")
                    {
                        newrow["Employee Code"] = employeid;
                        newrow["Name"] = empname;
                        newrow["Amount"] = esi;
                        Report.Rows.Add(newrow);
                    }
                }
            }
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
        catch (Exception ex)
        {
            throw ex;

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
            //{ddlcompantype
            //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
            //    e.Row.Font.Size = FontUnit.Large;
            //    e.Row.Font.Bold = true;
            //}
        }
    }
}