
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;


public partial class BranchwiseCasualReport : System.Web.UI.Page
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
                    PopulateYear();
                    bindbranchs();
                    bindemployeetype();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
                    string fryear = dtyear.ToString("dd/MM/yyyy");
                    string[] str1 = fryear.Split('/');
                    ddlyear.SelectedValue = str1[2];
                    string mbranch = Session["mainbranch"].ToString();
                    if (mbranch == "42")
                    {
                        tdpf.Visible = true;
                    }
                }
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
        //branchwise
        //cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='1'");
        string mainbranch = Session["mainbranch"].ToString();
        //branch mapping
        cmd = new SqlCommand("SELECT branchmaster.branchid, branchmaster.branchname, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m) ");
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

    protected void btn_Generate_Click(object sender, EventArgs e)
     {
        try
        {
            DataTable Report = new DataTable();
            DataTable nonpf = new DataTable();
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
            //string day = (mydate.Day).ToString();
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
          
            fromdate = Convert.ToDateTime(date);
            string mainbranch = Session["mainbranch"].ToString();
            if (mainbranch == "42")
            {
                Session["filename"] = ddlbranch.SelectedItem.Text + " " + ddlpf.SelectedItem.Text + " Casuals Salary Statement " + ddlmonth.SelectedItem.Text + " " + year;
                Session["title"] = ddlbranch.SelectedItem.Text + " " + ddlpf.SelectedItem.Text + " Casuals Salary Statement " + ddlmonth.SelectedItem.Text + " " + year;
                lblHeading.Text = ddlbranch.SelectedItem.Text + " " + ddlpf.SelectedItem.Text + "  Casuals Salary Statement Report  " + ddlmonth.SelectedItem.Text + " " + year;
            }
            else
            {
                Session["filename"] = ddlbranch.SelectedItem.Text + " Casuals Salary Statement " + ddlmonth.SelectedItem.Text + " " + year;
                Session["title"] = ddlbranch.SelectedItem.Text + " Casuals Salary Statement " + ddlmonth.SelectedItem.Text + " " + year;
                lblHeading.Text = ddlbranch.SelectedItem.Text + " Casuals Salary Statement Report" + ddlmonth.SelectedItem.Text + " " + year;
            }
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
            if (mainbranch == "42")
            {
                if (ddlbranch.SelectedItem.Text != "42" || ddlbranch.SelectedItem.Text != "43")
                {
                    Report.Columns.Add("Sno"); ;
                    Report.Columns.Add("empid");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Employee Name");
                    Report.Columns.Add("Wage For day").DataType = typeof(double);
                    Report.Columns.Add("Payable Days");
                    Report.Columns.Add("AttendanceBonus>=24days@rs.30").DataType = typeof(double);
                    Report.Columns.Add("Basic").DataType = typeof(double);
                    Report.Columns.Add("Earning Gross").DataType = typeof(double);
                    Report.Columns.Add("PF").DataType = typeof(double);
                    Report.Columns.Add("EPF").DataType = typeof(double);
                    Report.Columns.Add("ESI").DataType = typeof(double);
                    Report.Columns.Add("EESI").DataType = typeof(double);
                    Report.Columns.Add("Canteen Deduction").DataType = typeof(double);
                    Report.Columns.Add("Salary Advance").DataType = typeof(double);
                    Report.Columns.Add("Loan").DataType = typeof(double);
                    Report.Columns.Add("Total Deduction").DataType = typeof(double);
                    Report.Columns.Add("NET PAY").DataType = typeof(double);
                    Report.Columns.Add("Bank Acc NO");
                    Report.Columns.Add("IFSC Code");

                    nonpf.Columns.Add("Sno");
                    nonpf.Columns.Add("empid");
                    nonpf.Columns.Add("Employee Code");
                    nonpf.Columns.Add("Employee Name");
                    nonpf.Columns.Add("wage for day").DataType = typeof(double);
                    nonpf.Columns.Add("Payable Days");
                    nonpf.Columns.Add("AttendanceBonus>=24days@rs.30").DataType = typeof(double);
                    nonpf.Columns.Add("Basic").DataType = typeof(double);
                    nonpf.Columns.Add("Earning Gross").DataType = typeof(double);
                    nonpf.Columns.Add("ESI").DataType = typeof(double);
                    nonpf.Columns.Add("EESI").DataType = typeof(double);
                    nonpf.Columns.Add("Canteen Deduction").DataType = typeof(double);
                    nonpf.Columns.Add("Salary Advance").DataType = typeof(double);
                    nonpf.Columns.Add("Loan").DataType = typeof(double);
                    nonpf.Columns.Add("Total Deduction").DataType = typeof(double);
                    nonpf.Columns.Add("NET PAY").DataType = typeof(double);
                    nonpf.Columns.Add("Bank Acc NO");
                    nonpf.Columns.Add("IFSC Code");
                    int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                    cmd = new SqlCommand("SELECT employebankdetails.ifsccode,  employedetails.esieligible,employedetails.gender, employedetails.pfeligible, employedetails.salarymode, employedetails.empid,employedetails.employee_num, employedetails.fullname, designation.designation, salaryappraisals.salaryperyear, employebankdetails.accountno,salaryappraisals.gross, monthly_attendance.month, monthly_attendance.year FROM  employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.salarymode = '1') AND (employedetails.employee_type = 'Casuals' OR employedetails.employee_type = 'Casual worker') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.salarymode = '1') AND (employedetails.employee_type = 'Casuals' OR employedetails.employee_type = 'Casual worker') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)ORDER BY employedetails.gender,employedetails.employee_num");
                    //paystrure
                    //cmd = new SqlCommand("SELECT employebankdetails.ifsccode, employedetails.gender, employedetails.pfeligible, employedetails.salarymode, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, pay_structure.salaryperyear, employebankdetails.accountno, pay_structure.gross, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.salarymode = '1') AND ((employedetails.employee_type = 'Casuals') OR (employedetails.employee_type ='Casual worker')) AND employedetails.status='No' ORDER BY employedetails.gender");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@d1", date);
                    DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT monthly_attendance.empid, monthly_attendance.clorwo,monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.extradays, employedetails.employee_num, branchmaster.company_code, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.sno, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN  branchmaster ON branchmaster.branchid = employedetails.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) and (salaryadvance.month=@month) AND (salaryadvance.year = @year)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                    if (dtsalary.Rows.Count > 0)
                    {
                        int i = 1;
                        foreach (DataRow dr in dtsalary.Rows)
                        {
                            double loan = 0;
                            double salaryadvance = 0;
                            double canteendeduction = 0;
                            double totalpresentdays = 0;
                            double totalearnings = 0;
                            double totalPFearnings = 0;
                            double daysinmonth = 0;
                            double esi = 0;
                            double loseamount = 0;
                            double providentfund = 0;
                            DataRow newrow = Report.NewRow();
                            DataRow dtnewrow = nonpf.NewRow();
                            string pf = dr["pfeligible"].ToString();
                            if (ddlpf.SelectedItem.Text == "PF")
                            {
                                if (pf == "Yes")
                                {
                                    newrow["Sno"] = i++.ToString();
                                    newrow["Employee Code"] = dr["employee_num"].ToString();
                                    newrow["Employee Name"] = dr["fullname"].ToString();
                                    newrow["empid"] = dr["empid"].ToString();
                                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                                    newrow["Wage For day"] = peryanam / 12;
                                    double permonth = peryanam / 12;
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
                                            newrow["Payable Days"] = paydays;
                                            string companycode = dra["company_code"].ToString();
                                            double rate = 0;
                                            double gr = Convert.ToDouble(dr["gross"].ToString());
                                            rate = gr;
                                            double bonus;
                                            string gender = dr["gender"].ToString();
                                            if (gender == "Male")
                                            {
                                                if (branchid == 1044)
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
                                                if (branchid == 1044)
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
                                                newrow["AttendanceBonus>=24days@rs.30"] = amount;
                                            }
                                            else
                                            {
                                                newrow["AttendanceBonus>=24days@rs.30"] = 0;
                                                rate = gr;
                                            }
                                            double paydaysesi = rate * paydays;
                                            totalearnings = rate * paydays + amount;

                                            newrow["Basic"] = paydaysesi / 2;

                                            double totalpdays = numberofworkingdays - lop;
                                            totalearnings = Math.Round(totalearnings);
                                            totalPFearnings = rate * paydays;
                                            string esieligible = dr["esieligible"].ToString();
                                            if (mainbranch == "42")
                                            {
                                                if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048" || ddlbranch.SelectedItem.Value == "1047" || ddlbranch.SelectedItem.Value =="1070")
                                                {
                                                    if (esieligible == "Yes")
                                                    {

                                                        esi = (paydaysesi * 0.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                        newrow["ESI"] = esi;
                                                        double eesi = Math.Round((paydaysesi * 3.25) / 100, 0);
                                                        newrow["EESI"] = eesi;
                                                    }
                                                    else
                                                    {
                                                        esi = 0;
                                                        newrow["ESI"] = esi;
                                                        newrow["EESI"] = esi;

                                                    }
                                                }
                                                else
                                                {
                                                    if (esieligible == "Yes")
                                                    {
                                                        if (ddlbranch.SelectedItem.Value == "1044" || ddlbranch.SelectedItem.Value == "43" || ddlbranch.SelectedItem.Value == "1046")
                                                        {
                                                            if (ddlbranch.SelectedItem.Value == "43")
                                                            {
                                                                esi = (paydaysesi * 0.75) / 100;
                                                                esi = Math.Round(esi, 0);
                                                                newrow["ESI"] = esi;
                                                                double eesi = Math.Round((paydaysesi * 3.25) / 100, 0);
                                                                newrow["EESI"] = eesi;
                                                            }
                                                            else
                                                            {
                                                                esi = (paydaysesi * 0.75) / 100;
                                                                esi = Math.Round(esi, 0);
                                                                newrow["ESI"] = esi;
                                                                double eesi =  Math.Round((paydaysesi * 3.25) / 100, 0);
                                                                newrow["EESI"] = eesi;
                                                            }
                                                        }
                                                    }
                                                    else
                                                    {
                                                        esi = 0;
                                                        newrow["ESI"] = esi;
                                                        newrow["EESI"] = esi;
                                                    }
                                                }
                                            }
                                            string pfeligible = dr["pfeligible"].ToString();
                                            if (pfeligible == "Yes")
                                            {
                                                providentfund = (totalPFearnings * 6) / 100;
                                                if (providentfund > 1800)
                                                {
                                                    providentfund = 1800;
                                                }
                                                providentfund = Math.Round(providentfund, 0);
                                                newrow["PF"] = Math.Round(providentfund, 0);
                                                double ePF = (totalPFearnings * 6) / 100;
                                                newrow["EPF"] = ePF;
                                            }
                                            else
                                            {
                                                providentfund = 0;
                                                newrow["PF"] = providentfund;
                                                newrow["EPF"] = providentfund;
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
                                                        newrow["Canteen Deduction"] = deductionamount.ToString();
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
                                                    newrow["Canteen Deduction"] = canteendeduction;
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
                                                newrow["Canteen Deduction"] = canteendeduction;
                                            }
                                        }
                                        salaryadvance = 0;
                                        if (dtsa.Rows.Count > 0)
                                        {
                                            DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                            if (drr.Length > 0)
                                            {
                                                foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                                {
                                                    double amount = 0;
                                                    double.TryParse(drsa["amount"].ToString(), out amount);
                                                    newrow["Salary Advance"] = amount.ToString();
                                                    salaryadvance = Convert.ToDouble(amount);
                                                    salaryadvance = Math.Round(amount, 0);
                                                }
                                            }
                                            else
                                            {
                                                salaryadvance = 0;
                                                newrow["Salary Advance"] = salaryadvance;
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
                                    }
                                    newrow["Earning Gross"] = totalearnings;
                                    double totaldd = salaryadvance + canteendeduction + loan + providentfund + esi;
                                    newrow["Total Deduction"] = Math.Round(totaldd).ToString();
                                    double netpay = 0;
                                    netpay = totalearnings - totaldd;
                                    netpay = Math.Round(netpay, 2);
                                    newrow["NET PAY"] = netpay;
                                }
                            }
                            else
                            {
                                if (pf != "Yes")
                                {
                                    dtnewrow["Sno"] = i++.ToString();
                                    dtnewrow["Employee Code"] = dr["employee_num"].ToString();
                                    dtnewrow["Employee Name"] = dr["fullname"].ToString();
                                    dtnewrow["empid"] = dr["empid"].ToString();
                                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                                    dtnewrow["Wage For day"] = peryanam / 12;
                                    double permonth = peryanam / 12;
                                    dtnewrow["Bank Acc NO"] = dr["accountno"].ToString();
                                    dtnewrow["IFSC Code"] = dr["ifsccode"].ToString();
                                    nonpf.Rows.Add(dtnewrow);
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
                                            dtnewrow["Payable Days"] = paydays;
                                            string companycode = dra["company_code"].ToString();
                                            double rate = 0;
                                            double gr = Convert.ToDouble(dr["gross"].ToString());
                                            rate = gr;
                                            double bonus;
                                            string gender = dr["gender"].ToString();
                                            if (gender == "Male")
                                            {
                                                if (branchid == 1044)
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
                                                if (branchid == 1044)
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
                                                dtnewrow["AttendanceBonus>=24days@rs.30"] = amount;
                                            }
                                            else
                                            {
                                                dtnewrow["AttendanceBonus>=24days@rs.30"] = 0;
                                                rate = gr;
                                            }
                                            double basic = rate * paydays;
                                            totalearnings = rate * paydays + amount;
                                            dtnewrow["Basic"] = basic / 2;
                                            double totalpdays = numberofworkingdays - lop;
                                            totalearnings = Math.Round(totalearnings);

                                            string esieligible = dr["esieligible"].ToString();
                                            if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048")
                                            {
                                                if (esieligible == "Yes")
                                                {
                                                    if (ddlbranch.SelectedItem.Value == "1043")
                                                    {
                                                        double esiamount = rate * 5;
                                                        //double esiamount = totalearnings / 10;
                                                        esi = (esiamount * 1.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                        dtnewrow["ESI"] = esi;
                                                        double EESI = (esiamount * 4.75) / 100;
                                                        dtnewrow["EESI"] = EESI;
                                                        
                                                    }
                                                    if (ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1047")
                                                    {
                                                        double esiamount = rate * 5;
                                                        //double esiamount = totalearnings / 10;
                                                        esi = (esiamount * 1.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                        dtnewrow["ESI"] = esi;
                                                        double EESI = (esiamount * 4.75) / 100;
                                                        dtnewrow["EESI"] = EESI;
                                                    }
                                                    if (ddlbranch.SelectedItem.Value == "1048")
                                                    {
                                                        double esiamount = rate * 5;
                                                       // double esiamount = totalearnings / 10;
                                                        esi = (esiamount * 1.75) / 100;
                                                        esi = Math.Round(esi, 0);
                                                        dtnewrow["ESI"] = esi;
                                                        double EESI = (esiamount * 4.75) / 100;
                                                        dtnewrow["EESI"] = EESI;
                                                    }
                                                }
                                                else
                                                {
                                                    esi = 0;
                                                    dtnewrow["ESI"] = esi;
                                                    dtnewrow["EESI"] = esi;
                                                }
                                            }
                                            else
                                            {
                                                if (esieligible == "Yes")
                                                {
                                                    if (ddlbranch.SelectedItem.Value == "1044")
                                                    {
                                                        //this month only Calucate 10days(Nxtmonth asuseually monthly deduction)
                                                        // esi = (totalearnings * 1) / 100;
                                                        double esiamount = rate * 4;
                                                        // double esiamount = totalearnings / 10;
                                                        esi = (totalearnings * 1) / 100;
                                                        esi = Math.Round(esi, 0);
                                                        dtnewrow["ESI"] = esi;
                                                        double EESI = (totalearnings * 3) / 100;
                                                        dtnewrow["EESI"] = EESI;
                                                    }
                                                    if (ddlbranch.SelectedItem.Value == "43" || ddlbranch.SelectedItem.Value == "1046")
                                                    {
                                                        if (ddlbranch.SelectedItem.Value == "43")
                                                        {
                                                            if (ddlpf.SelectedValue == "02")
                                                            {
                                                                esi = 0;
                                                                dtnewrow["EESI"] = esi;
                                                            }
                                                            else
                                                            {
                                                                double esiamount = rate * 12;
                                                                // double esiamount = totalearnings / 10;
                                                                esi = (totalearnings * 1) / 100;
                                                                esi = Math.Round(esi, 0);
                                                                newrow["ESI"] = esi;
                                                                double EESI = (totalearnings * 3) / 100;
                                                                dtnewrow["EESI"] = EESI;
                                                            }

                                                        }
                                                      
                                                        //esi = 0;
                                                        //esi = Math.Round(esi, 0);
                                                        //dtnewrow["ESI"] = esi;
                                                    }
                                                }
                                                else
                                                {
                                                    esi = 0;
                                                    dtnewrow["ESI"] = esi;
                                                    dtnewrow["EESI"] = esi;
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
                                                            dtnewrow["Canteen Deduction"] = deductionamount.ToString();
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
                                                        dtnewrow["Canteen Deduction"] = canteendeduction;
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
                                                    dtnewrow["Canteen Deduction"] = canteendeduction;
                                                }
                                            }
                                            salaryadvance = 0;
                                            if (dtsa.Rows.Count > 0)
                                            {
                                                DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                                if (drr.Length > 0)
                                                {
                                                    foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                                    {
                                                        double amt = 0;
                                                        double.TryParse(drsa["amount"].ToString(), out amt);
                                                        dtnewrow["Salary Advance"] = amt.ToString();
                                                        salaryadvance = Convert.ToDouble(amt);
                                                        salaryadvance = Math.Round(amt, 0);
                                                    }
                                                }
                                                else
                                                {
                                                    salaryadvance = 0;
                                                    dtnewrow["Salary Advance"] = salaryadvance;
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
                                                        dtnewrow["Loan"] = loanemimonth.ToString();
                                                        loan = Convert.ToDouble(loanemimonth);
                                                        loan = Math.Round(loanemimonth, 0);
                                                    }
                                                }
                                                else
                                                {
                                                    loan = 0;
                                                    dtnewrow["Loan"] = loan;
                                                }
                                            }
                                        }
                                        dtnewrow["Earning Gross"] = totalearnings;
                                        double totaldd = salaryadvance + canteendeduction + loan + providentfund + esi;
                                        dtnewrow["Total Deduction"] = Math.Round(totaldd).ToString();
                                        double netpay = 0;
                                        netpay = totalearnings - totaldd;
                                        netpay = Math.Round(netpay, 2);
                                        dtnewrow["NET PAY"] = netpay;
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    Report.Columns.Add("Sno");
                    Report.Columns.Add("empid");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Employee Name");
                    Report.Columns.Add("Designation");
                    Report.Columns.Add("Gross").DataType = typeof(double);
                    Report.Columns.Add("Total Days In Month");
                    Report.Columns.Add("Payable Days");
                    Report.Columns.Add("AttendanceBonus>=24days@rs.30").DataType = typeof(double);
                    Report.Columns.Add("Earning Gross").DataType = typeof(double);
                    Report.Columns.Add("ESI").DataType = typeof(double);
                    Report.Columns.Add("Canteen Deduction").DataType = typeof(double);
                    Report.Columns.Add("Salary Advance").DataType = typeof(double);
                    Report.Columns.Add("NET PAY").DataType = typeof(double);
                    Report.Columns.Add("Bank Acc NO");
                    Report.Columns.Add("IFSC Code");
                }
            }
            else
            {
                if (ddlbranch.SelectedItem.Value != "39")
                {
                    Report.Columns.Add("Sno");
                    Report.Columns.Add("empid");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Employee Name");
                    Report.Columns.Add("Designation");
                    Report.Columns.Add("Gross").DataType = typeof(double);
                    Report.Columns.Add("Total Days In Month");
                    Report.Columns.Add("Payable Days");
                    Report.Columns.Add("AttendanceBonus>=26days@rs.20").DataType = typeof(double);
                    Report.Columns.Add("Earning Gross").DataType = typeof(double);
                    Report.Columns.Add("Canteen Deduction").DataType = typeof(double);
                    Report.Columns.Add("Salary Advance").DataType = typeof(double);
                    Report.Columns.Add("Other Deduction").DataType = typeof(double);
                    Report.Columns.Add("NET PAY").DataType = typeof(double);
                    Report.Columns.Add("Bank Acc NO");
                    Report.Columns.Add("IFSC Code");
                    int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                   // OR employedetails.employee_type = 'Casual worker'
                    cmd = new SqlCommand("SELECT employebankdetails.ifsccode, employedetails.salarymode, employedetails.empid, employedetails.employee_num, employedetails.fullname,designation.designation, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year, salaryappraisals.gross,salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.salarymode = '1') AND (employedetails.employee_type = @emptype) AND (employedetails.status = 'No') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.salarymode = '1') AND (employedetails.employee_type = 'Casuals' OR employedetails.employee_type = 'Casual worker') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                    //paystrure
                    //cmd = new SqlCommand("SELECT employebankdetails.ifsccode, employedetails.salarymode, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, pay_structure.salaryperyear, employebankdetails.accountno, pay_structure.gross, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.salarymode = '1') AND ((employedetails.employee_type = 'Casuals') OR (employedetails.employee_type ='Casual worker')) AND employedetails.status='No'");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@d1", date);
                    cmd.Parameters.Add("@emptype", ddlemptype.SelectedItem.Text);
                    DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT monthly_attendance.empid, monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.extradays, employedetails.employee_num, branchmaster.company_code, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.sno, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN  branchmaster ON branchmaster.branchid = employedetails.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) and (salaryadvance.month=@month) AND (salaryadvance.year = @year)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
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
                        int i = 1;

                        foreach (DataRow dr in dtsalary.Rows)
                        {
                            double salaryadvance = 0;
                            double canteendeduction = 0;
                            double totalpresentdays = 0;
                            double totalearnings = 0;
                            double daysinmonth = 0;
                            double loseamount = 0;
                            double otherdeduction = 0;
                            DataRow newrow = Report.NewRow();
                            newrow["Sno"] = i++.ToString();
                            newrow["empid"] = dr["empid"].ToString();
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["Employee Name"] = dr["fullname"].ToString();
                            newrow["Designation"] = dr["designation"].ToString();
                            double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                            newrow["Gross"] = peryanam / 12;
                            double permonth = peryanam / 12;
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
                                    double paydays = 0;
                                    double lop = 0;
                                    double.TryParse(dra["lop"].ToString(), out lop);
                                    paydays = numberofworkingdays - lop;
                                    double holidays = 0;
                                    holidays = daysinmonth - numberofworkingdays;
                                    newrow["Payable Days"] = paydays;
                                    string companycode = dra["company_code"].ToString();
                                    double rate = 0;
                                    if (companycode == "2")
                                    {
                                        double gr = Convert.ToDouble(dr["gross"].ToString());
                                        rate = gr / daysinmonth;
                                    }
                                    else
                                    {
                                        if (ddlbranch.SelectedItem.Text == "Punabaka")
                                        {
                                            rate = Convert.ToDouble(dr["gross"].ToString());
                                        }
                                        else
                                        {
                                            double grr = Convert.ToDouble(dr["gross"].ToString());
                                            rate = grr / daysinmonth;
                                        }
                                    }
                                    // newrow["Rate/Day"] = rate;
                                    double bonus = 20;
                                    double rateperday = 0;
                                    double amount = 0;
                                    if (paydays >= 26)
                                    {
                                        if (ddlbranch.SelectedItem.Text == "Punabaka")
                                        {
                                            if (ddlemptype.SelectedItem.Text == "KMM Casuals")
                                            {
                                                newrow["AttendanceBonus>=26days@rs.20"] = 0;
                                                rateperday = rate;
                                            }
                                            else
                                            {
                                                rateperday = rate + bonus;
                                                amount = bonus * paydays;
                                                newrow["AttendanceBonus>=26days@rs.20"] = amount;
                                            }
                                        }
                                        else
                                        {
                                            newrow["AttendanceBonus>=26days@rs.20"] = 0;
                                            rateperday = rate;
                                        }
                                    }
                                    else
                                    {
                                        newrow["AttendanceBonus>=26days@rs.20"] = 0;
                                        rateperday = rate + bonus;
                                    }
                                    totalearnings = rate * paydays + amount;
                                    double totalpdays = numberofworkingdays - lop;
                                    totalearnings = Math.Round(totalearnings);
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
                                            newrow["Canteen Deduction"] = deductionamount.ToString();
                                            string st = deductionamount.ToString();
                                            canteendeduction = Convert.ToDouble(deductionamount);
                                            canteendeduction = Math.Round(deductionamount);
                                        }
                                    }
                                    else
                                    {
                                        canteendeduction = 0;
                                        newrow["Canteen Deduction"] = canteendeduction;
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
                                            if (amount == 0)
                                            {
                                            }
                                            else
                                            {
                                                newrow["Other Deduction"] = amount.ToString();
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
                                            newrow["Other Deduction"] = otherdeduction;
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
                                salaryadvance = 0;
                                if (dtsa.Rows.Count > 0)
                                {
                                    DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                    if (drr.Length > 0)
                                    {
                                        foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                        {
                                            double amount = 0;
                                            double.TryParse(drsa["amount"].ToString(), out amount);
                                            newrow["Salary Advance"] = amount.ToString();
                                            salaryadvance = Convert.ToDouble(amount);
                                            salaryadvance = Math.Round(amount, 0);
                                        }
                                    }
                                    else
                                    {
                                        salaryadvance = 0;
                                        newrow["Salary Advance"] = salaryadvance;
                                    }
                                }
                            }
                            newrow["Earning Gross"] = totalearnings;
                            double totaldd = salaryadvance + canteendeduction + otherdeduction;
                            double netpay = 0;
                            netpay = totalearnings - totaldd;
                            netpay = Math.Round(netpay, 2);
                            newrow["NET PAY"] = netpay;
                        }
                    }
                }
                else if (ddlbranch.SelectedItem.Value == "39")
                {
                    double totalearnings = 0;
                    Report.Columns.Add("Sno");
                    Report.Columns.Add("empid");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Employee Name");
                    Report.Columns.Add("Designation");
                    Report.Columns.Add("Rate/Day").DataType = typeof(double);
                    Report.Columns.Add("Total Days in Month");
                    Report.Columns.Add("Payable Days");
                    Report.Columns.Add("Gross Earnings").DataType = typeof(double);
                    Report.Columns.Add("AttendanceBonus>=26days@rs.20").DataType = typeof(double);
                    Report.Columns.Add("Salary Advance").DataType = typeof(double);
                    Report.Columns.Add("Canteen Deduction").DataType = typeof(double);
                    Report.Columns.Add("OTHER DEDUCTION").DataType = typeof(double);
                    Report.Columns.Add("NET PAY").DataType = typeof(double);
                    Report.Columns.Add("Bank Acc NO");
                    Report.Columns.Add("IFSC Code");
                    int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                    cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra, salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.travelconveyance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.employee_type = 'Casuals') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @branchid) AND (employedetails.employee_type = 'Casuals' OR employedetails.employee_type = 'KMM Casuals') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1)");
                    //paystrure
                    //cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible,employedetails.employee_type, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid=@branchid) and (employedetails.status='No') and (employedetails.employee_type='Casuals')");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@d1", date);
                    DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                    //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) and  (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", year);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
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
                            double otherdeduction;
                            double daysinmonth = 0;
                            double loseamount = 0;
                            DataRow newrow = Report.NewRow();
                            newrow["Sno"] = i++.ToString();
                            newrow["empid"] = dr["empid"].ToString();
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["Employee Name"] = dr["fullname"].ToString();
                            newrow["Designation"] = dr["designation"].ToString();
                            double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                            //double rateper = Convert.ToDouble(dr["gross"].ToString());
                            //profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
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
                                    newrow["Total Days in Month"] = daysinmonth.ToString();
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
                                    if (paydays >= 26)
                                    {
                                        if (ddlbranch.SelectedItem.Text == "RMRD plant")
                                        {
                                            double bonus = 20;
                                            rate = rate + bonus;
                                            newrow["AttendanceBonus>=26days@rs.20"] = bonus * paydays;
                                        }
                                    }
                                    totalearnings = rate * paydays;
                                    double totalpdays = numberofworkingdays - lop;
                                    totalearnings = Math.Round(totalearnings);
                                    newrow["Gross Earnings"] = totalearnings;
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
                                        newrow["Canteen Deduction"] = deductionamount.ToString();
                                        string st = deductionamount.ToString();
                                        canteendeduction = Convert.ToDouble(deductionamount);
                                        canteendeduction = Math.Ceiling(deductionamount);
                                    }
                                }
                                else
                                {
                                    canteendeduction = 0;
                                    newrow["Canteen Deduction"] = canteendeduction;
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
                            salaryadvance = 0;
                            if (dtsa.Rows.Count > 0)
                            {
                                DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
                                if (drr.Length > 0)
                                {
                                    foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                    {
                                        double amount = 0;
                                        double.TryParse(drsa["amount"].ToString(), out amount);
                                        newrow["Salary Advance"] = amount.ToString();
                                        salaryadvance = Convert.ToDouble(amount);
                                        salaryadvance = Math.Round(amount, 0);
                                    }
                                }
                                else
                                {
                                    salaryadvance = 0;
                                    newrow["Salary Advance"] = salaryadvance;
                                }
                            }
                            // newrow["TOTAL DEDUCTIONS"] = Math.Ceiling(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
                            totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction+otherdeduction);
                            double netpay = 0;
                            netpay = Math.Ceiling(totalearnings - totaldeduction);
                            netpay = Math.Round(netpay, 2);
                            newrow["NET PAY"] = Math.Ceiling(netpay);
                            Report.Rows.Add(newrow);
                        }
                    }
                    else
                    {
                        lblmsg.Text = "No data were found";
                        hidepanel.Visible = false;
                    }

                }
            }

            DataRow newTotal = Report.NewRow();
            newTotal["Employee Name"] = "Total Amount";
            double val = 0.0;
            foreach (DataColumn dc in Report.Columns)
            {
                if (dc.DataType == typeof(Double))
                {
                    val = 0.0;
                    double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
                    if (val == 0.0)
                    {
                    }
                    else
                    {
                        newTotal[dc.ToString()] = val;
                    }
                }
            }
            Report.Rows.Add(newTotal);
            //foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
            //{
            //    if (Report.AsEnumerable().All(drc => drc.IsNull(column)))
            //        Report.Columns.Remove(column);
            //}

            if (nonpf.Rows.Count > 0)
            {
                DataRow dtnewTotal = nonpf.NewRow();
                dtnewTotal["Employee Name"] = "Total Amount";
                double dtval = 0.0;
                foreach (DataColumn dcc in nonpf.Columns)
                {
                    if (dcc.DataType == typeof(Double))
                    {
                        dtval = 0.0;
                        double.TryParse(nonpf.Compute("sum([" + dcc.ToString() + "])", "[" + dcc.ToString() + "]<>'0'").ToString(), out dtval);
                        dtnewTotal[dcc.ToString()] = dtval;
                    }
                }
                nonpf.Rows.Add(dtnewTotal);
                DataRow newrow2 = Report.NewRow();
                newrow2["Employee Code"] = "Non Pf";
                Report.Rows.Add(newrow2);
                Report.Rows.Clear();
                divnonpf.Visible = true;
                //pftext.Visible = true;
                grdnonpf.DataSource = nonpf;
                grdnonpf.DataBind();
            }
            else
            {
                divnonpf.Visible = false;
                // pftext.Visible = false;
                grdnonpf.DataSource = null;
                grdnonpf.DataBind();
            }
            grdReports.DataSource = Report;
            //if (Report.Rows.Count > 2)
            //{
                grdReports.DataBind();
                DataTable dtexport = new DataTable();
                dtexport = Report.Copy();
                dtexport.Merge(nonpf);
                Session["xportdata"] = dtexport;
                hidepanel.Visible = true;
               // lblmsg.Text = "";
            //}
            //else
            //{
            //  //  hidepanel.Visible = false;
            //   // lblmsg.Text = "No Data Found";
            //}
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
            if (e.Row.Cells[1].Text == "Non Pf")
            {
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }

    protected void grdnonpf_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[2].Text == "Total Amount")
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
        DataTable dtlogs = new DataTable();
        dtlogs = (DataTable)Session["xportdata"];
        if (dtlogs.Rows.Count > 0)
        {
            DateTime doe = DateTime.Now;
            string year = ddlyear.SelectedItem.Value;
            string branchid = ddlbranch.SelectedItem.Value;
            string month = ddlmonth.SelectedItem.Value;
            string type = ddlpf.SelectedItem.Value;
            cmd = new SqlCommand("SELECT * FROM monthlysalarystatement WHERE   branchid=@branch AND month=@month and year=@year and type=@type");
            cmd.Parameters.Add("@branch", branchid);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            cmd.Parameters.Add("@type", type);
            DataTable dtdata = vdm.SelectQuery(cmd).Tables[0];
            if (dtdata.Rows.Count > 0)
            {
                lblmsg.Text = "THIS MONTH OF DATA ALREADY CLOSED ";
            }
            else
            {
                foreach (DataRow dr in dtlogs.Rows)
                {
                    string designation = "0";
                    try
                    {
                        designation = dr["DESIGNATION"].ToString();
                    }
                    catch
                    {
                    }
                    string Name = dr["Employee Name"].ToString();
                    if (Name == "Total Amount")
                    {

                    }
                    else
                    {
                        designation = "0";
                        try
                        {
                            designation = dr["DESIGNATION"].ToString();
                        }
                        catch
                        {
                        }
                        string emptype = "0";
                        try
                        {
                            emptype = dr["DESIGNATION"].ToString();
                        }
                        catch
                        {
                        }
                        string empcode = dr["Employee Code"].ToString();
                        Name = dr["Employee Name"].ToString();
                        string daysmonth = "0";
                        try
                        {

                            daysmonth = dr["Total Days in Month"].ToString();
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
                            Attadencebonusdays = dr["AttendanceBonus>=24days@rs.30"].ToString();
                        }
                        catch
                        {
                        }

                        string gross2 = "0";
                        string wageperday = "0";
                        try
                        {
                            gross2 = dr["Wage For day"].ToString();
                        }
                        catch
                        {
                        }
                        try
                        {

                            gross2 = dr["GROSS"].ToString();
                        }
                        catch
                        {
                        }
                        string rateperday = "0";
                        try
                        {
                            gross2 = dr["Rate/Day"].ToString();
                        }
                        catch
                        {
                        }
                        string gross = "0";

                        try
                        {
                            gross = dr["GROSS Earnings"].ToString();
                        }
                        catch
                        {
                        }
                        string gross1 = "0";
                        try
                        {
                            gross1 = dr["Earning Gross"].ToString();
                        }
                        catch
                        {
                        }
                        if (gross1 == "0")
                        {

                            gross = dr["GROSS Earnings"].ToString();
                        }

                        else
                        {

                            gross = dr["Earning Gross"].ToString();

                        }
                        string pf = "0";
                        try
                        {
                            pf = dr["PF"].ToString();
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
                        string empid = dr["empid"].ToString(); ;
                        string empttype = ddlemptype.SelectedItem.Value;
                        string netpay = dr["NET PAY"].ToString();
                        string bankaccountno = dr["Bank Acc NO"].ToString();
                        string ifsccode = dr["IFSC Code"].ToString();
                        cmd = new SqlCommand("insert into monthlysalarystatement(employecode, empname, designation, daysmonth,  payabledays, gross,  salaryadvance, loan, canteendeduction,   netpay, bankaccountno, ifsccode,  branchid, month, dateofclosing,emptype, closedby,basic,year,attendancebonus,pf,empid) Values (@employecode, @empname, @designation, @daysmonth,  @payabledays,@gross,@salaryadvance,@loan,@canteendeduction,@netpay,@bankaccountno,@ifsccode,@branchid,@month,@dateofclosing,@emptype,@closedby,@basic,@year,@attendancebonus,@pf, @empid)");
                        cmd.Parameters.Add("@employecode", empcode);
                        cmd.Parameters.Add("@empname", Name);
                        cmd.Parameters.Add("@designation", designation);
                        cmd.Parameters.Add("@daysmonth", daysmonth);
                        cmd.Parameters.Add("@payabledays", payabledays);
                        cmd.Parameters.Add("@basic", gross2);
                        cmd.Parameters.Add("@gross", gross);
                        cmd.Parameters.Add("@salaryadvance", salaryadvance);
                        cmd.Parameters.Add("@loan", loan);
                        cmd.Parameters.Add("@canteendeduction", canteendeduction);
                        cmd.Parameters.Add("@netpay", netpay);
                        cmd.Parameters.Add("@bankaccountno", bankaccountno);
                        cmd.Parameters.Add("@ifsccode", ifsccode);
                        cmd.Parameters.Add("@emptype", empttype);
                        cmd.Parameters.Add("@branchid", branchid);
                        cmd.Parameters.Add("@month", month);
                        cmd.Parameters.Add("@dateofclosing", doe);
                        cmd.Parameters.Add("@closedby", Session["empid"]);
                        cmd.Parameters.Add("@year", year);
                        cmd.Parameters.Add("@attendancebonus", Attadencebonusdays);
                        cmd.Parameters.Add("@pf", pf);
                        cmd.Parameters.Add("@empid", empid);
                        SalesDB.insert(cmd);
                        lblmsg.Text = " Employee are successfully saved";
                    }
                }
            }
        }
    }

    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch where (employee_type<>'') AND (branchmapping.mainbranch = @bid) GROUP BY employee_type");
        cmd.Parameters.Add("@bid", Session["mainbranch"].ToString());
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
        ddlemptype.SelectedValue = "0";
    }
}