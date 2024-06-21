using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class sal : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;

    double netpay = 0;

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
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
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
    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails where (employee_type<>'')  GROUP BY employee_type");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
        ddlemptype.SelectedValue = "0";
    }
    private void bindbranchs()
    {

        DBManager SalesDB = new DBManager();
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
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
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            //string year = "2016";
            double grandpaytotal = 0;

            double grandtotalbasic = 0;
            double grandtotalhra = 0;
            double grandtotalconve = 0;
            double grandtotalmedi = 0;
            double grandtotalwashing = 0;
            double grandtotalgrass = 0;
            double grandtotalpt = 0;
            double grandtotalpf = 0;
            double grandtotalesi = 0;
            double grandtotalsalaryadvance = 0;
            double grandtotalloan = 0;
            double grandtotalcanteen = 0;
            double grandtotalmobile = 0;
            double grandtotalmediclaim = 0;
            double grandtotaltds = 0;
            double grandtotalother = 0;
            double grandtotaltotdeduction = 0;
            double grandtotalgrosssal = 0;







            string year = ddlyear.SelectedItem.Value;
            //string currentyear = (mydate.Year).ToString();
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
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            lblHeading.Text = ddlbranch.SelectedItem.Text + " " + ddlemptype.SelectedItem.Text + " Salary Statement Report " + " " + ddlmonth.SelectedItem.Text + " " + year;
            Session["filename"] = ddlbranch.SelectedItem.Text + " Salary Statement " + " " + ddlmonth.SelectedItem.Text + " " + year;
            Session["title"] = ddlbranch.SelectedItem.Text + " Salary Statement " + " " + ddlmonth.SelectedItem.Text + " " + year;
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranch.SelectedValue);
            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
            if (dtcompany.Rows.Count > 0)
            {
                lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
                Session["TitleName"] = dtcompany.Rows[0]["companyname"].ToString();
                Session["Address"] = dtcompany.Rows[0]["address"].ToString();
            }
            else
            {
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
            }
            if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Retainers")
            {
                Report.Columns.Add("DEPT");
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                //Report.Columns.Add("Department");
                Report.Columns.Add("GROSS").DataType = typeof(double);
                Report.Columns.Add("DAYS MONTH");
                Report.Columns.Add("Attendance Days");
                Report.Columns.Add("CL HOLIDAY AND OFF");
                Report.Columns.Add("Payable Days");
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
                //Report.Columns.Add("Department1");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.employee_dept, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid,employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.washingallowance, salaryappraisals.salaryperyear, salaryappraisals.medicalerning, salaryappraisals.profitionaltax, salaryappraisals.hra, salaryappraisals.erningbasic FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN  salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1)AND (salaryappraisals.startingdate <= @d1) ORDER BY employedetails.employee_dept,salaryappraisals.erningbasic DESC");
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
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
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
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
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid) AND (mediclaimdeduction.flag='1')");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid WHERE (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];
                if (dtsalary.Rows.Count > 0)
                {
                    var i = 1;
                    string prevdept = "";
                    double grandnetpay = 0;
                    double totalbasic = 0;
                    double totalhra = 0;
                    double totalconve = 0;
                    double totalmedi = 0;
                    double totalwashing = 0;
                    double totalgrass = 0;
                    double totalpt = 0;
                    double totalpf = 0;
                    double totalesi = 0;
                    double totalsalaryadvance = 0;
                    double totalloan = 0;
                    double totalcanteen = 0;
                    double totalmobile = 0;
                    double totalmediclaim = 0;
                    double totaltds = 0;
                    double totalother = 0;
                    double totaltotdeduction = 0;
                    double totalgrosssal = 0;
                    
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
                        double rate = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        string empdept = dr["employee_dept"].ToString();
                        if (empdept == prevdept)
                        {
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["DEPT"] = dr["department"].ToString();
                            newrow["Name"] = dr["fullname"].ToString();
                            newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                            double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                            newrow["GROSS"] = peryanam / 12;
                            double permonth = peryanam / 12;
                            totalgrosssal += permonth;
                            double HRA = Convert.ToDouble(dr["hra"].ToString());
                            double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                            convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                            profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                            medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                            washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                            string bankacno = dr["accountno"].ToString();
                            newrow["Bank Acc NO"] = bankacno;
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
                            rate = permonth;
                            double perdaysal = permonth / daysinmonth;
                            double basic = 50;
                            double basicsalary = (permonth * 50) / 100;
                            double basicpermonth = basicsalary / daysinmonth;
                            double bs = basicpermonth * totalpresentdays;
                            totalbasic += bs;
                            newrow["BASIC"] = Math.Round(bs);
                            newrow["CONVEYANCE ALLOWANCE"] = Math.Round(convenyance - loseofconviyance);
                            newrow["MEDICAL ALLOWANCE"] = Math.Round(medicalerning - loseofmedical);
                            newrow["WASHING ALLOWANCE"] = Math.Round(washingallowance - loseofwashing);
                            double basicsal = Math.Round(basicsalary - loseamount);
                            double conve = Math.Round(convenyance - loseofconviyance);
                            totalconve += conve;
                            double medical = Math.Round(medicalerning - loseofmedical);
                            totalmedi += medical;
                            double washing = Math.Round(washingallowance - loseofwashing);
                            totalwashing += washing;
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
                                    totalpt += profitionaltax;
                                }
                                else
                                {
                                    ptax = 0;
                                    profitionaltax = ptax;
                                    newrow["PT"] = ptax;
                                    totalpt += ptax;
                                }
                            }
                            else
                            {
                                newrow["PT"] = profitionaltax;
                                totalpt += profitionaltax;
                            }
                            if (hra > 0)
                            {
                                newrow["HRA"] = hra;
                                totalhra += hra;
                            }
                            else
                            {
                                newrow["HRA"] = 0;
                            }
                            newrow["GROSS Earnings"] = totalearnings;
                            totalgrass += totalearnings;
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
                                totalpf += providentfund;
                            }
                            else
                            {
                                providentfund = 0;
                                newrow["PF"] = providentfund;
                            }
                            string esieligible = dr["esieligible"].ToString();
                            if (ddlbranch.SelectedItem.Value == "42")
                            {
                                if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048")
                                {
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
                                }
                                else
                                {
                                    if (esieligible == "Yes")
                                    {
                                        if (ddlbranch.SelectedItem.Value == "1044" || ddlbranch.SelectedItem.Value == "43" || ddlbranch.SelectedItem.Value == "1046")
                                        {
                                            esi = (totalearnings * 1) / 100;
                                            esi = Math.Round(esi, 0);
                                            newrow["ESI"] = esi;
                                        }
                                    }
                                    else
                                    {
                                        esi = 0;
                                        newrow["ESI"] = esi;
                                    }
                                }
                            }
                            else
                            {
                                if (esieligible == "Yes")
                                {
                                    esi = (totalearnings * 1.75) / 100;
                                    esi = Math.Round(esi, 0);
                                    newrow["ESI"] = esi;
                                    totalesi += esi;
                                }
                                else
                                {
                                    esi = 0;
                                    newrow["ESI"] = esi;
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
                                        if (amount == 0)
                                        {
                                        }
                                        else
                                        {
                                            newrow["SALARY ADVANCE"] = amount.ToString();
                                            salaryadvance = Convert.ToDouble(amount);
                                            salaryadvance = Math.Round(amount, 0);
                                            totalsalaryadvance += salaryadvance;
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
                                        totalsalaryadvance += salaryadvance;
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
                                    totalsalaryadvance += salaryadvance;
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
                                            totalloan += loan;
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
                                        totalloan += loan;
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
                                    totalloan += loan;
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
                                        if (deductionamount == 0)
                                        {
                                        }
                                        else
                                        {
                                            newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            mobilededuction = Convert.ToDouble(deductionamount);
                                            mobilededuction = Math.Round(deductionamount, 0);
                                            totalmobile += mobilededuction;
                                        }
                                    }
                                }
                                else
                                {
                                    mobilededuction = 0;
                                    if (mobilededuction == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["MOBILE DEDUCTION"] = Math.Round(mobilededuction, 0);
                                        totalmobile += mobilededuction;
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                if (mobilededuction == 0)
                                {
                                }
                                else
                                {
                                    newrow["MOBILE DEDUCTION"] = Math.Round(mobilededuction, 0);
                                    totalmobile += mobilededuction;
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
                                        if (deductionamount == 0)
                                        {
                                        }
                                        else
                                        {
                                            newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            canteendeduction = Convert.ToDouble(deductionamount);
                                            canteendeduction = Math.Round(deductionamount);
                                            totalcanteen += canteendeduction;
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
                                        totalcanteen += canteendeduction;
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
                                    totalcanteen += canteendeduction;
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
                                        totalmediclaim += medicliamdeduction;
                                    }
                                }
                                else
                                {
                                    medicliamdeduction = 0;
                                    newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                                    totalmediclaim += medicliamdeduction;
                                }
                            }
                            else
                            {
                                medicliamdeduction = 0;
                                newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                                totalmediclaim += medicliamdeduction;
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
                                            totalother += otherdeduction;
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
                                        totalother += otherdeduction;
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
                                    totalother += otherdeduction;
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
                                            totaltds += tdsdeduction;
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
                                        totaltds += tdsdeduction;
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
                                    totaltds += tdsdeduction;
                                }
                            }
                            newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                            totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                            totaltotdeduction += totaldeduction;
                            double netpay = 0;
                            netpay = Math.Round(totalearnings - totaldeduction);
                            netpay = Math.Round(netpay, 0);
                            grandnetpay += netpay;
                            newrow["NET PAY"] = Math.Round(netpay, 0);
                            Report.Rows.Add(newrow);
                        }
                        else
                        {
                            if (grandnetpay > 0)
                            {
                                DataRow newrow1 = Report.NewRow();
                                newrow1["Name"] = "Total";
                                newrow1["GROSS"] = Math.Round(totalgrosssal, 0);
                               
                                newrow1["NET PAY"] = Math.Round(grandnetpay, 0);
                                newrow1["BASIC"] = Math.Round(totalbasic, 0);
                                newrow1["HRA"] = Math.Round(totalhra, 0);
                                newrow1["CONVEYANCE ALLOWANCE"] = Math.Round(totalconve, 0);
                                newrow1["MEDICAL ALLOWANCE"] = Math.Round(totalmedi, 0);
                                newrow1["WASHING ALLOWANCE"] = Math.Round(totalwashing, 0);
                                newrow1["GROSS Earnings"] = Math.Round(totalgrass, 0);
                                newrow1["PT"] = Math.Round(totalpt, 0);
                                newrow1["PF"] = Math.Round(totalpf, 0);
                                newrow1["ESI"] = Math.Round(totalesi, 0);
                                newrow1["SALARY ADVANCE"] = Math.Round(totalsalaryadvance, 0);
                                newrow1["Loan"] = Math.Round(totalloan, 0);
                                newrow1["CANTEEN DEDUCTION"] = Math.Round(totalcanteen, 0);
                                newrow1["MOBILE DEDUCTION"] = Math.Round(totalmobile, 0);
                                newrow1["MEDICLAIM DEDUCTION"] = Math.Round(totalmediclaim, 0);

                                newrow1["Tds DEDUCTION"] = Math.Round(totaltds, 0);
                                newrow1["OTHER DEDUCTION"] = Math.Round(totalother, 0);
                                newrow1["TOTAL DEDUCTIONS"] = Math.Round(totaltotdeduction, 0);
                                Report.Rows.Add(newrow1);


                                grandpaytotal += Math.Round(totalgrosssal, 0);
                                grandtotalbasic += Math.Round(totalbasic, 0);
                                grandtotalhra += Math.Round(totalhra, 0);
                                grandtotalconve += Math.Round(totalconve, 0);
                                grandtotalmedi += Math.Round(totalmedi, 0);
                                grandtotalwashing += Math.Round(totalwashing, 0);
                                grandtotalgrass += Math.Round(totalgrass, 0);
                                grandtotalpt += Math.Round(totalpt, 0);
                                grandtotalpf += Math.Round(totalpf, 0);
                                grandtotalesi += Math.Round(totalesi, 0);
                                grandtotalsalaryadvance += Math.Round(totalsalaryadvance, 0);
                                grandtotalloan += Math.Round(totalloan, 0);
                                grandtotalcanteen += Math.Round(totalcanteen, 0);
                                grandtotalmobile += Math.Round(totalmobile, 0);
                                grandtotalmediclaim += Math.Round(totalmediclaim, 0);
                                grandtotaltds += Math.Round(totaltds, 0);
                                grandtotalother += Math.Round(totalother, 0);
                                grandtotaltotdeduction += Math.Round(totaltotdeduction, 0);
                                grandtotalgrosssal += Math.Round(grandnetpay, 0);
                                totalbasic = 0;
                                totalhra = 0;
                                totalconve = 0;
                                totalmedi = 0;
                                totalwashing = 0;
                                totalgrass = 0;
                                totalpt = 0;
                                totalpf = 0;
                                totalesi = 0;
                                totalsalaryadvance = 0;
                                totalloan = 0;
                                totalcanteen = 0;
                                totalmobile = 0;
                                totalmediclaim = 0;
                                totaltds = 0;
                                totalother = 0;
                                totaltotdeduction = 0;
                                totalgrosssal = 0;
                            }
                            prevdept = empdept;
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["DEPT"] = dr["department"].ToString();
                            newrow["Name"] = dr["fullname"].ToString();
                            newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                            double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                            newrow["GROSS"] = peryanam / 12;
                            double permonth = peryanam / 12;
                            totalgrosssal += permonth;
                            double HRA = Convert.ToDouble(dr["hra"].ToString());
                            double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                            convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                            profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                            medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                            washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                            string bankacno = dr["accountno"].ToString();
                            newrow["Bank Acc NO"] = bankacno;
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
                            rate = permonth;
                            double perdaysal = permonth / daysinmonth;
                            double basic = 50;
                            double basicsalary = (permonth * 50) / 100;
                            double basicpermonth = basicsalary / daysinmonth;
                            double bs = basicpermonth * totalpresentdays;
                            newrow["BASIC"] = Math.Round(bs);
                            totalbasic += Math.Round(bs);
                            newrow["CONVEYANCE ALLOWANCE"] = Math.Round(convenyance - loseofconviyance);
                            newrow["MEDICAL ALLOWANCE"] = Math.Round(medicalerning - loseofmedical);
                            newrow["WASHING ALLOWANCE"] = Math.Round(washingallowance - loseofwashing);
                            double basicsal = Math.Round(basicsalary - loseamount);
                            double conve = Math.Round(convenyance - loseofconviyance);
                            totalconve += conve;
                            double medical = Math.Round(medicalerning - loseofmedical);
                            totalmedi += medical;
                            double washing = Math.Round(washingallowance - loseofwashing);
                            totalwashing += washing;
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
                                    totalpt += profitionaltax;
                                }
                                else
                                {
                                    ptax = 0;
                                    profitionaltax = ptax;
                                    newrow["PT"] = ptax;
                                    totalpt += profitionaltax;
                                }
                            }
                            else
                            {
                                newrow["PT"] = profitionaltax;
                                totalpt += profitionaltax;
                            }
                            if (hra > 0)
                            {
                                newrow["HRA"] = hra;
                                totalhra += hra;
                            }
                            else
                            {
                                newrow["HRA"] = 0;
                            }
                            newrow["GROSS Earnings"] = totalearnings;
                            totalgrass += totalearnings;
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
                                totalpf += providentfund;
                            }
                            else
                            {
                                providentfund = 0;
                                newrow["PF"] = providentfund;
                                totalpf += providentfund;
                            }
                            string esieligible = dr["esieligible"].ToString();
                            if (ddlbranch.SelectedItem.Value == "42")
                            {
                                if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048")
                                {
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
                                }
                                else
                                {
                                    if (esieligible == "Yes")
                                    {
                                        if (ddlbranch.SelectedItem.Value == "1044" || ddlbranch.SelectedItem.Value == "43" || ddlbranch.SelectedItem.Value == "1046")
                                        {
                                            esi = (totalearnings * 1) / 100;
                                            esi = Math.Round(esi, 0);
                                            newrow["ESI"] = esi;
                                        }
                                    }
                                    else
                                    {
                                        esi = 0;
                                        newrow["ESI"] = esi;
                                    }
                                }
                            }
                            else
                            {
                                if (esieligible == "Yes")
                                {
                                    esi = (totalearnings * 1.75) / 100;
                                    esi = Math.Round(esi, 0);
                                    newrow["ESI"] = esi;
                                    totalesi += esi;
                                }
                                else
                                {
                                    esi = 0;
                                    newrow["ESI"] = esi;
                                    totalesi += esi;
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
                                        if (amount == 0)
                                        {
                                        }
                                        else
                                        {
                                            newrow["SALARY ADVANCE"] = amount.ToString();
                                            salaryadvance = Convert.ToDouble(amount);
                                            salaryadvance = Math.Round(amount, 0);
                                            totalsalaryadvance += salaryadvance;
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
                                        totalsalaryadvance += salaryadvance;
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
                                    totalsalaryadvance += salaryadvance;
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
                                            totalloan += loan;
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
                                        totalloan += loan;
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
                                    totalloan += loan;
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
                                        if (deductionamount == 0)
                                        {
                                        }
                                        else
                                        {
                                            newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            mobilededuction = Convert.ToDouble(deductionamount);
                                            mobilededuction = Math.Round(deductionamount, 0);
                                            totalmobile += mobilededuction;
                                        }
                                    }
                                }
                                else
                                {
                                    mobilededuction = 0;
                                    if (mobilededuction == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["MOBILE DEDUCTION"] = Math.Round(mobilededuction, 0);
                                        totalmobile += mobilededuction;
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                if (mobilededuction == 0)
                                {
                                }
                                else
                                {
                                    newrow["MOBILE DEDUCTION"] = Math.Round(mobilededuction, 0);
                                    totalmobile += mobilededuction;
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
                                        if (deductionamount == 0)
                                        {
                                        }
                                        else
                                        {
                                            newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            canteendeduction = Convert.ToDouble(deductionamount);
                                            canteendeduction = Math.Round(deductionamount);
                                            totalcanteen += canteendeduction;
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
                                        totalcanteen += canteendeduction;
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
                                    totalcanteen += canteendeduction;
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
                                        totalmediclaim += medicliamdeduction;
                                    }
                                }
                                else
                                {
                                    medicliamdeduction = 0;
                                    newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                                    totalmediclaim += medicliamdeduction;
                                }
                            }
                            else
                            {
                                medicliamdeduction = 0;
                                newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                                totalmediclaim += medicliamdeduction;
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
                                            totalother += otherdeduction;
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
                                        totalother += otherdeduction;
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
                                    totalother += otherdeduction;
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
                                            totaltds += tdsdeduction;
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
                                        totaltds += tdsdeduction;
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
                                    totaltds += tdsdeduction;
                                }
                            }
                            newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                            totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                            totaltotdeduction += totaldeduction;
                            double netpay = 0;
                            netpay = Math.Round(totalearnings - totaldeduction);
                            netpay = Math.Round(netpay, 0);
                            grandnetpay += netpay;
                            newrow["NET PAY"] = Math.Round(netpay, 0);
                            Report.Rows.Add(newrow);
                        }
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Permanent")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("GROSS").DataType = typeof(double);
                Report.Columns.Add("Payable Days");
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
                Report.Columns.Add("Tds DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("OTHER DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid,employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode,monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department, salaryappraisals.gross,salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)  AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrcture
                //cmd = new SqlCommand("SELECT  employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE(employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@d1", date);
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
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid WHERE (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
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
                        double medicliamdeduction = 0;
                        double mobilededuction = 0;
                        double totaldeduction;
                        double totalearnings;
                        double providentfund = 0;
                        double tdsdeduction = 0;
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
                        newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                        //newrow["Department"] = dr["department"].ToString();
                        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                        newrow["GROSS"] = peryanam / 12;
                        double grosssalary = peryanam / 12;
                        double permonth = peryanam / 12;
                        double HRA = Convert.ToDouble(dr["hra"].ToString());
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                        newrow["PT"] = dr["profitionaltax"].ToString();
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                        washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                        newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {

                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
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
                        double ptax = Math.Round(profitionaltax - losofprofitionaltax);
                        double tt = bs + conve + medical + washing;
                        double thra = permonth - loseamount;
                        double hra = Math.Round(thra - tt);
                        totalearnings = Math.Round(hra + tt);
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

                        if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1055" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048" || ddlbranch.SelectedItem.Value == "1047")
                        {
                            if (esieligible == "Yes")
                            {
                                if (grosssalary < 21001)
                                {
                                    esi = (grosssalary * 1.75) / 100;
                                    esi = Math.Round(esi, 0);
                                    newrow["ESI"] = esi;
                                }
                            }
                            else
                            {
                                esi = 0;
                                newrow["ESI"] = esi;
                            }
                        }
                        else
                        {
                            if (esieligible == "Yes")
                            {
                                if (ddlbranch.SelectedItem.Value == "1044" || ddlbranch.SelectedItem.Value == "43" || ddlbranch.SelectedItem.Value == "1046")
                                {
                                    if (grosssalary < 21001)
                                    {
                                        esi = (grosssalary * 1) / 100;
                                        esi = Math.Round(esi, 0);
                                        newrow["ESI"] = esi;
                                    }
                                }
                            }
                            else
                            {
                                esi = 0;
                                newrow["ESI"] = esi;
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
                                    newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                newrow["SALARY ADVANCE"] = salaryadvance;
                            }
                        }
                        else
                        {
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
                                    newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
                                newrow["Loan"] = loan;
                            }
                        }
                        else
                        {
                        }
                        mobilededuction = 0;

                        canteendeduction = 0;

                        medicliamdeduction = 0;
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
                                    newrow["OTHER DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    otherdeduction = Convert.ToDouble(amount);
                                    otherdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                otherdeduction = 0;
                                newrow["OTHER DEDUCTION"] = otherdeduction;
                            }
                        }
                        else
                        {
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 0);
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Driver")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Rate/Day");
                Report.Columns.Add("Batta/Day");
                Report.Columns.Add("Work Days");
                Report.Columns.Add("Payable Days");
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("PT").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                Report.Columns.Add("Loan").DataType = typeof(double);
                Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("OTHER DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month,monthly_attendance.year, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname,designation.designation, employebankdetails.accountno, branchmaster.statename, employedetails.employee_dept, departments.department,salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund,salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                //paystrcture
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month,  monthly_attendance.year, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi,  pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, branchmaster.statename,  employedetails.employee_dept, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE(employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
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
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
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
                        //double totalearnings;
                        double daysinmonth = 0;
                        string statename = "";
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        //newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                        //newrow["Department"] = dr["department"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        statename = dr["statename"].ToString();
                        //newrow["PT"] = dr["profitionaltax"].ToString();
                        double rateper = Convert.ToDouble(dr["gross"].ToString());
                        //profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        //Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {

                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                newrow["Work Days"] = daysinmonth.ToString();
                                //double rateperday = 0;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = paydays;
                                totalpresentdays = holidays + paydays;
                                //double perdaybasic = BASIC / daysinmonth;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                newrow["Rate/Day"] = rateper;
                                double batta = 80;
                                string empnumber = dr["employee_num"].ToString();
                                if (empnumber == "SVDS080135" || empnumber == "SVDS100095")
                                {
                                    newrow["Batta/Day"] = "0";
                                    batta = 0;
                                }
                                else
                                {
                                    newrow["Batta/Day"] = batta;
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
                                newrow["PT"] = profitionaltax;
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
                                    newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
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
                                    newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
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
                                    newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount, 0);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        double otherdeduction = 0;
                        if (dtotherdeduction.Rows.Count > 0)
                        {
                            DataRow[] drr = dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drotherdeduction in dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double amount = 0;
                                    double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
                                    newrow["OTHER DEDUCTIONS"] = amount.ToString();
                                    string st = amount.ToString();
                                    otherdeduction = Convert.ToDouble(amount);
                                    otherdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                otherdeduction = 0;
                                newrow["OTHER DEDUCTIONS"] = otherdeduction;
                            }
                        }
                        else
                        {
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + otherdeduction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + otherdeduction);
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
                            newrow["NET PAY"] = Math.Round(netpay, 0);
                            Report.Rows.Add(newrow);
                        }
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Cleaner")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Rate/Day");
                Report.Columns.Add("Batta/Day");
                Report.Columns.Add("Work Days");
                Report.Columns.Add("Payable Days");
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("PT").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                Report.Columns.Add("Loan").DataType = typeof(double);
                Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                //paystructure
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, branchmaster.statename, employedetails.employee_dept, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE(employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, branchmaster.statename, employedetails.employee_dept, departments.department, salaryappraisals.gross,salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@d1", date);

                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
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
                        newrow["SNO"] = i++.ToString();
                        //newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                        //newrow["Department"] = dr["department"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        newrow["PT"] = dr["profitionaltax"].ToString();
                        double rateper = Convert.ToDouble(dr["gross"].ToString());
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                newrow["Work Days"] = daysinmonth.ToString();
                                //double rateperday = 0;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                newrow["Rate/Day"] = rateper;
                                double batta = 80;
                                newrow["Batta/Day"] = batta;
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
                                    newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
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
                                    newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
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
                                        mobilededuction = Math.Ceiling(deductionamount);
                                    }
                                }
                            }
                            else
                            {
                                mobilededuction = 0;
                                newrow["MOBILE DEDUCTION"] = mobilededuction;
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
                                    newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount, 0);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Casuals")
            {
                Report.Columns.Add("DESIGNATION");
                if (ddlbranch.SelectedItem.Text == "Punabaka plant")
                {
                    double totalearnings = 0;
                    Report.Columns.Add("SNO");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Name");
                    Report.Columns.Add("Rate/Day").DataType = typeof(double);
                    Report.Columns.Add("Total Days in Month");
                    Report.Columns.Add("Payable Days");
                    Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                    Report.Columns.Add("AttendanceBonus>=26days@rs.20").DataType = typeof(double);
                    Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                    Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                    Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                    Report.Columns.Add("NET PAY").DataType = typeof(double);
                    Report.Columns.Add("Bank Acc NO");
                    Report.Columns.Add("IFSC Code");
                    int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                    string employee_type = ddlemptype.SelectedItem.Value;
                    cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid,employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, monthly_attendance.month,monthly_attendance.year, employedetails.employee_dept, departments.department, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning,salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                    //paystrucre
                    //cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation,pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department FROM  employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@emptype", employee_type);
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@d1", date);
                    DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                    //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) and (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
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
                            newrow["SNO"] = i++.ToString();
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["Name"] = dr["fullname"].ToString();
                            newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                            double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                            profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                            newrow["Bank Acc NO"] = dr["accountno"].ToString();
                            newrow["IFSC Code"] = dr["ifsccode"].ToString();
                            Report.Rows.Add(newrow);
                            if (dtattendence.Rows.Count > 0)
                            {
                                foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double numberofworkingdays = 0;
                                    double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                    double clorwo = 0;
                                    double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                    daysinmonth = numberofworkingdays + clorwo;
                                    newrow["Total Days in Month"] = daysinmonth.ToString();
                                    //double rateperday = 0;
                                    newrow["Total Days in Month"] = numberofworkingdays.ToString();
                                    double paydays = 0;
                                    double lop = 0;
                                    double.TryParse(dra["lop"].ToString(), out lop);
                                    paydays = numberofworkingdays - lop;
                                    double holidays = 0;
                                    holidays = daysinmonth - numberofworkingdays;
                                    newrow["Payable Days"] = paydays;
                                    double rate = Convert.ToDouble(dr["gross"].ToString());
                                    newrow["Rate/Day"] = rate;
                                    double bonus = 20;
                                    double rateperday = 0;
                                    double amount = 0;
                                    if (paydays >= 26)
                                    {
                                        rateperday = rate + bonus;
                                        amount = bonus * paydays;
                                        newrow["AttendanceBonus>=26days@rs.20"] = amount;

                                    }
                                    else
                                    {
                                        newrow["AttendanceBonus>=26days@rs.20"] = 0;
                                        rateperday = rate + bonus;
                                    }
                                    totalearnings = rate * paydays + amount;
                                    double totalpdays = numberofworkingdays - lop;
                                    totalearnings = Math.Round(totalearnings);
                                    newrow["GROSS Earnings"] = totalearnings;
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
                                        newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                        string st = deductionamount.ToString();
                                        canteendeduction = Convert.ToDouble(deductionamount);
                                        canteendeduction = Math.Round(deductionamount);
                                    }
                                }
                                else
                                {
                                    canteendeduction = 0;
                                    newrow["CANTEEN DEDUCTION"] = canteendeduction;
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
                                        newrow["SALARY ADVANCE"] = amount.ToString();
                                        salaryadvance = Convert.ToDouble(amount);
                                        salaryadvance = Math.Round(amount, 0);
                                    }
                                }
                                else
                                {
                                    salaryadvance = 0;
                                    newrow["SALARY ADVANCE"] = salaryadvance;
                                }
                            }
                            newrow["TOTAL DEDUCTIONS"] = canteendeduction + salaryadvance;
                            totaldeduction = Math.Round(canteendeduction + salaryadvance);
                            double netpay = 0;
                            netpay = Math.Round(totalearnings - totaldeduction);
                            netpay = Math.Round(netpay, 2);
                            newrow["NET PAY"] = Math.Round(netpay, 0);
                        }
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "KMM Casuals")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Rate/Day").DataType = typeof(double);
                Report.Columns.Add("Work Days");
                Report.Columns.Add("Payable Days");
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                //paystrutre
                // cmd = new SqlCommand("SELECT  employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid,  employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year,  employedetails.employee_dept FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, monthly_attendance.month,  monthly_attendance.year, employedetails.employee_dept, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
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
                        double daysinmonth = 0;
                        double loseamount = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                newrow["Work Days"] = daysinmonth.ToString();
                                //double rateperday = 0;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                newrow["Rate/Day"] = rate;
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
                                    newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                newrow["SALARY ADVANCE"] = salaryadvance;
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
                                    newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    canteendeduction = Convert.ToDouble(deductionamount);
                                    canteendeduction = Math.Round(deductionamount, 0);
                                }
                            }
                            else
                            {
                                canteendeduction = 0;
                                newrow["CANTEEN DEDUCTION"] = canteendeduction;
                            }
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Canteen")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Gross Salary").DataType = typeof(double);
                Report.Columns.Add("Total days in the month");
                Report.Columns.Add("Attendance days");
                Report.Columns.Add("CL HOLIDAY AND OFF");
                Report.Columns.Add("Weekly off /cl").DataType = typeof(double);
                Report.Columns.Add("Payable Days").DataType = typeof(double);
                Report.Columns.Add("Gross Earnings").DataType = typeof(double);
                Report.Columns.Add("Extra Days").DataType = typeof(double);
                Report.Columns.Add("Extra DAYS Value").DataType = typeof(double);
                Report.Columns.Add("Loan").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Total Salary").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                //paystrutre
                // cmd = new SqlCommand("SELECT  employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid,  employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year,  employedetails.employee_dept FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, monthly_attendance.month,  monthly_attendance.year, employedetails.employee_dept, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@d1", date);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo,monthly_attendance.extradays, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.month FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, employedetails.employee_num, employedetails.fullname, monthly_attendance.empid, monthly_attendance.doe,  monthly_attendance.month, monthly_attendance.year, monthly_attendance.extradays, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays, pay_structure.gross, employebankdetails.employeid, employebankdetails.accountno,  designation.designation FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN designation ON employedetails.designationid = designation.designationid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", year);
                DataTable dtOT = SalesDB.SelectQuery(cmd).Tables[0];
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
                        double daysinmonth = 0;
                        double loseamount = 0;
                        double otamount = 0;
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        // profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                        newrow["Gross Salary"] = dr["gross"].ToString();
                        newrow["Bank Acc NO"] = dr["accountno"].ToString();
                        newrow["IFSC Code"] = dr["ifsccode"].ToString();
                        //double permonth = peryanam / 12;
                        Report.Rows.Add(newrow);
                        if (dtattendence.Rows.Count > 0)
                        {
                            foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                            {
                                double numberofworkingdays = 0;
                                double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                double clorwo = 0;
                                double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                daysinmonth = numberofworkingdays + clorwo;
                                newrow["Attendance days"] = daysinmonth.ToString();
                                //double rateperday = 0;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = daysinmonth - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = paydays;
                                double monthsal = Convert.ToDouble(dr["gross"].ToString());
                                //newrow["Rate/Day"] = rate;
                                totalpresentdays = holidays + paydays;
                                // double perdaysal = permonth / daysinmonth;
                                //totalearnings = rate * paydays;
                                double perdayamt = monthsal / daysinmonth;
                                //double otvalue = perdayamt * otdays;
                                totalearnings = perdayamt * paydays;
                                totalearnings = Math.Round(totalearnings);
                                newrow["Gross Earnings"] = totalearnings;
                                if (clorwo == 0)
                                {
                                }
                                else
                                {
                                    newrow["CL HOLIDAY AND OFF"] = clorwo;
                                }
                            }
                        }
                        foreach (DataRow drot in dtOT.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {

                            string ot = drot["extradays"].ToString();
                            double numberofworkingdays = 0;
                            double.TryParse(drot["numberofworkingdays"].ToString(), out numberofworkingdays);
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
                            newrow["Extra DAYS"] = otdays;
                            newrow["Extra DAYS Value"] = Math.Round(otvalue);
                            otamount = otvalue;
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
                                    newrow["SALARY ADVANCE"] = amount.ToString();
                                    salaryadvance = Convert.ToDouble(amount);
                                    salaryadvance = Math.Round(amount);
                                }
                            }
                            else
                            {
                                salaryadvance = 0;
                                newrow["SALARY ADVANCE"] = salaryadvance;
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
                        if (dtloan.Rows.Count > 0)
                        {
                            DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                            if (drr.Length > 0)
                            {
                                foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double loanemimonth = 0;
                                    double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
                                    newrow["Loan"] = loanemimonth.ToString();
                                    loan = Convert.ToDouble(loanemimonth);
                                    loan = Math.Round(loanemimonth, 0);
                                }
                            }
                            else
                            {
                                loan = 0;
                                newrow["Loan"] = loan;
                            }
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(canteendeduction + salaryadvance + loan);
                        totaldeduction = Math.Round(canteendeduction + salaryadvance + loan);
                        double netpay = 0;
                        double netpayextpay = 0;
                        netpayextpay = Math.Round(totalearnings - totaldeduction + otamount);
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                        newrow["Total Salary"] = Math.Round(netpayextpay, 0);
                    }
                }
            }
            
            DataRow newTotal = Report.NewRow();
            newTotal["DESIGNATION"] = "Total Amount";
            double val = 0.0;
            foreach (DataColumn dc in Report.Columns)
            {
                if (dc.DataType == typeof(Double))
                {
                    val = 0.0;
                    string columname = dc.ToString();
                    double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                    if (val == 0.0)
                    {
                    }
                    else
                    {
                        
                        if (columname == "GROSS")
                        {
                            newTotal[dc.ToString()] = val - grandpaytotal;
                        }
                        if (columname == "BASIC")
                        {
                            newTotal[dc.ToString()] = val - grandtotalbasic;
                        }
                        if (columname == "HRA")
                        {
                            newTotal[dc.ToString()] = val - grandtotalhra;
                        }
                        if (columname == "CONVEYANCE ALLOWANCE")
                        {
                            newTotal[dc.ToString()] = val - grandtotalconve;
                        }
                        if (columname == "MEDICAL ALLOWANCE")
                        {
                            newTotal[dc.ToString()] = val - grandtotalmedi;
                        }
                        if (columname == "WASHING ALLOWANCE")
                        {
                            newTotal[dc.ToString()] = val - grandtotalwashing;
                        }
                        if (columname == "GROSS Earnings")
                        {
                            newTotal[dc.ToString()] = val - grandtotalgrass;
                        }
                        if (columname == "PT")
                        {
                            newTotal[dc.ToString()] = val - grandtotalpt;
                        }
                        if (columname == "PF")
                        {
                            newTotal[dc.ToString()] = val - grandtotalpf;
                        }
                        if (columname == "ESI")
                        {
                            newTotal[dc.ToString()] = val - grandtotalesi;
                        }
                        if (columname == "SALARY ADVANCE")
                        {
                            newTotal[dc.ToString()] = val - grandtotalsalaryadvance;
                        }
                        if (columname == "Loan")
                        {
                            newTotal[dc.ToString()] = val - grandtotalloan;
                        }
                        if (columname == "CANTEEN DEDUCTION")
                        {
                            newTotal[dc.ToString()] = val - grandtotalcanteen;
                        }
                        if (columname == "MOBILE DEDUCTION")
                        {
                            newTotal[dc.ToString()] = val - grandtotalmobile;
                        }
                        if (columname == "MEDICLAIM DEDUCTION")
                        {
                            newTotal[dc.ToString()] = val - grandtotalmediclaim;
                        }
                        if (columname == "Tds DEDUCTION")
                        {
                            newTotal[dc.ToString()] = val - grandtotaltds;
                        }
                        if (columname == "OTHER DEDUCTION")
                        {
                            newTotal[dc.ToString()] = val - grandtotalother;
                        }
                        if (columname == "TOTAL DEDUCTIONS")
                        {
                            newTotal[dc.ToString()] = val - grandtotaltotdeduction;
                        }
                        if (columname == "NET PAY")
                        {
                            newTotal[dc.ToString()] = val - grandtotalgrosssal;
                        }
                    }
                }
            }
            Report.Rows.Add(newTotal);
            foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
            {
                if (Report.AsEnumerable().All(dr => dr.IsNull(column)))
                    Report.Columns.Remove(column);
            }
            grdReports.DataSource = Report;
            grdReports.DataBind();
            Session["xportdata"] = Report;
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
            //e.Row.Cells[4].Visible = false;
            if (e.Row.Cells.Count > 2)
            {
                if (e.Row.Cells[3].Text == "Total")
                {
                    e.Row.BackColor = System.Drawing.Color.CadetBlue;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;

                }
                if (e.Row.Cells[4].Text == "Total Amount")
                {
                    e.Row.BackColor = System.Drawing.Color.Aquamarine;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;

                }
            }
        }
    }

    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        try
        {
            string mainb = Session["mainbranch"].ToString();
            if (mainb == "6")
            {
                if (ddlemptype.SelectedItem.Text == "Staff")
                {
                    GridViewGroup First = new GridViewGroup(grdReports, null, "DEPT");
                    // GridViewGroup three = new GridViewGroup(grdReports, seconf, "PF");
                }
            }
            else
            {

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void btnlogssave_click(object sender, EventArgs e)
    {
        DBManager SalesDB = new DBManager();
        DataTable empid = Session["empid"] as DataTable;
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname, departments.department, departments.deptid, designation.designation, designation.designationid FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN designation ON employedetails.designationid = designation.designationid WHERE(branchmapping.mainbranch = @m) AND (employedetails.status = 'No')");
        cmd.Parameters.Add("@m", mainbranch);
        DataTable dtemployee = vdm.SelectQuery(cmd).Tables[0];
        //DataTable designationid = Session["designationid"] as DataTable;
        //cmd = new SqlCommand("SELECT designationid, designation FROM designation ");
        //DataTable dtdesignation = vdm.SelectQuery(cmd).Tables[0];
        DataTable dtlogs = new DataTable();
        dtlogs = (DataTable)Session["xportdata"];
        if (dtlogs.Rows.Count > 0)
        {
            DateTime doe = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string branchid = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string type = ddlemptype.SelectedItem.Value;
            cmd = new SqlCommand("SELECT * FROM monthlysalarystatement WHERE   branchid=@branch AND month=@month and year=@year and type=@type");
            cmd.Parameters.Add("@branch", branchid);
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
                    string employeeid = "";
                    string employeid = dr["Employee Code"].ToString();
                    foreach (DataRow dremployee in dtemployee.Select("employee_num='" + employeid + "'"))
                    {
                        employeeid = dremployee["empid"].ToString();
                    }

                    string desigationid = "";

                    string designation = dr["Employee Code"].ToString();
                    foreach (DataRow dremployee in dtemployee.Select("employee_num='" + designation + "'"))
                    {
                        desigationid = dremployee["designationid"].ToString();
                    }


                    //string design = (dr["department"].ToString() + "-" + dr["designation"].ToString());
                    //string[] tokens = design.Split('-');
                    //string desig = tokens[0];
                    //string dept = tokens[1]; 
                    string deptid = "";
                    string Department = dr["Employee Code"].ToString();
                    foreach (DataRow dremployee in dtemployee.Select("employee_num='" + Department + "'"))
                    {
                        deptid = dremployee["deptid"].ToString();
                    }

                    string desgn = dr["DESIGNATION"].ToString();
                    if (desgn == "Total Amount")
                    {

                    }
                    else
                    {
                        desgn = dr["DESIGNATION"].ToString();
                        string emptype = ddlemptype.SelectedItem.Value;
                        string empcode = dr["Employee Code"].ToString();
                        string Name = dr["Name"].ToString();
                        string daysmonth = "0";
                        try
                        {
                            daysmonth = dr["DAYS MONTH"].ToString();
                        }
                        catch
                        {
                        }
                        try
                        {
                            daysmonth = dr["Total Days in Month"].ToString();
                        }
                        catch
                        {
                        }
                        string WorkDays = "0";
                        try
                        {
                            WorkDays = dr["Work Days"].ToString();
                        }
                        catch
                        {
                        }
                        string BetaperDay = "0";
                        try
                        {
                            BetaperDay = dr["Batta/Day"].ToString();
                        }
                        catch
                        {
                        }
                        string attandancedays = "0";
                        try
                        {
                            attandancedays = dr["Attendance Days"].ToString();
                        }
                        catch
                        {
                        }

                        string clandholidayoff = "0";
                        try
                        {
                            clandholidayoff = dr["CL HOLIDAY AND OFF"].ToString();
                        }
                        catch
                        {
                        }

                        string payabledays = "0";
                        try
                        {
                            payabledays = dr["Payable Days"].ToString();
                        }
                        catch
                        {
                        }
                        string Attadencebonusdays = "0";
                        try
                        {
                            Attadencebonusdays = dr["AttendanceBonus>=26days@rs.20"].ToString();
                        }
                        catch
                        {
                        }


                        string salary = "0";
                        try
                        {
                            salary = dr["GROSS"].ToString();
                        }
                        catch
                        {
                        }
                        try
                        {
                            salary = dr[" Rate/Day	"].ToString();
                        }
                        catch
                        {
                        }
                        string basic = "0";
                        try
                        {
                            basic = dr["BASIC"].ToString();
                        }
                        catch
                        {
                        }

                        string hra = "0";
                        try
                        {
                            hra = dr["HRA"].ToString();
                        }
                        catch
                        {
                        }
                        string conveyance = "0";
                        try
                        {
                            conveyance = dr["CONVEYANCE ALLOWANCE"].ToString();
                        }
                        catch
                        {
                        }
                        string medical = "0";
                        try
                        {
                            medical = dr["MEDICAL ALLOWANCE"].ToString();
                        }
                        catch
                        {
                        }
                        string washing = "0";
                        try
                        {
                            washing = dr["WASHING ALLOWANCE"].ToString();
                        }
                        catch
                        {
                        }
                        string gross = dr["GROSS Earnings"].ToString();
                        string pt = "0";
                        try
                        {
                            pt = dr["PT"].ToString();
                        }
                        catch
                        {
                        }
                        string pf = "0";
                        try
                        {
                            pf = dr["PF"].ToString();
                        }
                        catch
                        {
                        }
                        string esi = "0";
                        try
                        {
                            esi = dr["ESI"].ToString(); ;
                        }
                        catch
                        {
                        }

                        string salaryadvance = "0";
                        try
                        {
                            salaryadvance = dr["SALARY ADVANCE"].ToString();
                        }
                        catch
                        {
                        }
                        string loan = "0";
                        try
                        {
                            loan = dr["Loan"].ToString();
                        }
                        catch
                        {
                        }

                        string canteendeduction = "0";
                        try
                        {
                            canteendeduction = dr["CANTEEN DEDUCTION"].ToString();
                        }
                        catch
                        {
                        }
                        string mobilededuction = "0";
                        try
                        {
                            mobilededuction = dr["MOBILE DEDUCTION"].ToString();
                        }
                        catch
                        {
                        }
                        string mediclim = "0";
                        try
                        {
                            mediclim = dr["MEDICLAIM DEDUCTION"].ToString();
                        }
                        catch
                        {
                        }
                        string otherdeduction = "0";
                        try
                        {
                            otherdeduction = dr["OTHER DEDUCTION"].ToString();
                        }
                        catch
                        {
                        }
                        string tdsdeduction = "0";
                        try
                        {
                            tdsdeduction = dr["Tds DEDUCTION"].ToString();
                        }
                        catch
                        {
                        }
                        string totaldeduction = dr["TOTAL DEDUCTIONS"].ToString();
                        string netpay = dr["NET PAY"].ToString();
                        string bankaccountno = dr["Bank Acc NO"].ToString();
                        string ifsccode = dr["IFSC Code"].ToString();
                        //if (empcode != )
                        //{
                        cmd = new SqlCommand("insert into monthlysalarystatement(employecode, empname, designation, daysmonth, attandancedays, clandholidayoff, payabledays, basic, hra, conveyance, medical, washing, gross, pt, pf, esi,  salaryadvance, loan, canteendeduction, mobilededuction, mediclim, otherdeduction, totaldeduction, netpay, bankaccountno, ifsccode, emptype, branchid, month, dateofclosing, closedby,Tdsdeduction,betaperday,deptid,year,attendancebonus,empid,salary) Values (@employecode, @empname, @designation, @daysmonth, @attandancedays, @clandholidayoff, @payabledays, @basic, @hra, @conveyance, @medical, @washing,@gross,@pt,@pf,@esi,@salaryadvance,@loan,@canteendeduction,@mobilededuction,@mediclim,@otherdeduction,@totaldeduction,@netpay,@bankaccountno,@ifsccode,@emptype,@branchid,@month,@dateofclosing,@closedby,@Tdsdeduction,@betaperday,@deptid,@year,@attendancebonus,@empid,@salary)");
                        cmd.Parameters.Add("@employecode", empcode);
                        cmd.Parameters.Add("@empname", Name);
                        cmd.Parameters.Add("@designation", desigationid);
                        cmd.Parameters.Add("@daysmonth", daysmonth);
                        cmd.Parameters.Add("@attandancedays", attandancedays);
                        cmd.Parameters.Add("@clandholidayoff", clandholidayoff);
                        cmd.Parameters.Add("@payabledays", payabledays);
                        cmd.Parameters.Add("@salary", salary);
                        cmd.Parameters.Add("@basic", basic);
                        cmd.Parameters.Add("@hra", hra);
                        cmd.Parameters.Add("@conveyance", conveyance);
                        cmd.Parameters.Add("@medical", medical);
                        cmd.Parameters.Add("@washing", washing);
                        cmd.Parameters.Add("@gross", gross);
                        cmd.Parameters.Add("@pt", pt);
                        cmd.Parameters.Add("@pf", pf);
                        cmd.Parameters.Add("@esi", esi);
                        cmd.Parameters.Add("@attendancebonus", Attadencebonusdays);
                        cmd.Parameters.Add("@salaryadvance", salaryadvance);
                        cmd.Parameters.Add("@loan", loan);
                        cmd.Parameters.Add("@canteendeduction", canteendeduction);
                        cmd.Parameters.Add("@mobilededuction", mobilededuction);
                        cmd.Parameters.Add("@mediclim", mediclim);
                        cmd.Parameters.Add("@otherdeduction", otherdeduction);
                        cmd.Parameters.Add("@totaldeduction", totaldeduction);
                        cmd.Parameters.Add("@Tdsdeduction", tdsdeduction);
                        cmd.Parameters.Add("@netpay", netpay);
                        cmd.Parameters.Add("@bankaccountno", bankaccountno);
                        cmd.Parameters.Add("@ifsccode", ifsccode);
                        cmd.Parameters.Add("@emptype", emptype);
                        cmd.Parameters.Add("@branchid", branchid);
                        cmd.Parameters.Add("@month", month);
                        cmd.Parameters.Add("@dateofclosing", doe);
                        cmd.Parameters.Add("@closedby", Session["empid"]);
                        cmd.Parameters.Add("@betaperday", BetaperDay);
                        cmd.Parameters.Add("@deptid", deptid);
                        cmd.Parameters.Add("@year", year);
                        cmd.Parameters.Add("@empid", employeeid);
                        SalesDB.insert(cmd);
                        lblmsg.Text = " Employee are successfully saved";                   //}
                    }
                }
            }
        }
    }
}