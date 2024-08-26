using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class pfreport : System.Web.UI.Page
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
            string mainbranch = Session["mainbranch"].ToString();
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
            lblHeading.Text = ddlbranch.SelectedItem.Text + " PF Statement Report" + " " + ddlmonth.SelectedItem.Text + year;
            string mainbranch = Session["mainbranch"].ToString();
            Session["filename"] = ddlbranch.SelectedItem.Text + " PF Statement Report" + " " + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranch.SelectedItem.Text + " PF Statement Report " + " " + ddlmonth.SelectedItem.Text + year;
            Report.Columns.Add("Department");
            Report.Columns.Add("Sno");
            //Report.Columns.Add("Employeeid");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            
            Report.Columns.Add("Designation");
            Report.Columns.Add("Gross").DataType = typeof(double);
            Report.Columns.Add("Days Month");
            Report.Columns.Add("Attendance Days");
            Report.Columns.Add("CL Holiday And Off");
            Report.Columns.Add("Payable Days");
            Report.Columns.Add("Basic").DataType = typeof(double);
            Report.Columns.Add("HRA").DataType = typeof(double);
            Report.Columns.Add("Conveyance Allowance").DataType = typeof(double);
            Report.Columns.Add("Washing Allowance").DataType = typeof(double);
            Report.Columns.Add("Medical Allowance").DataType = typeof(double);
            Report.Columns.Add("Variable Allowance").DataType = typeof(double);
            Report.Columns.Add("Gross Earnings").DataType = typeof(double);
            Report.Columns.Add("PT").DataType = typeof(double);
            Report.Columns.Add("PF").DataType = typeof(double);
                Report.Columns.Add("EPF").DataType = typeof(double);
            Report.Columns.Add("ESI").DataType = typeof(double);
                Report.Columns.Add("EESI").DataType = typeof(double);
            Report.Columns.Add("Salary Advance").DataType = typeof(double);
            Report.Columns.Add("Loan").DataType = typeof(double);
            Report.Columns.Add("Canteen Deductions").DataType = typeof(double);
            Report.Columns.Add("Mobile Deductions").DataType = typeof(double);
            Report.Columns.Add("MEDICLAIM DEDUCTION").DataType = typeof(double);
            Report.Columns.Add("Tds Deductions").DataType = typeof(double);
            Report.Columns.Add("Other Deductions").DataType = typeof(double);
            Report.Columns.Add("Total Deductions").DataType = typeof(double);
            Report.Columns.Add("Net Pay").DataType = typeof(double);
            Report.Columns.Add("Bank Acc NO");
            Report.Columns.Add("IFSC Code");
            int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            //paystrure
            //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid,employedetails.employee_num, pay_structure.providentfund, pay_structure.erningbasic, pay_structure.esi, employedetails.fullname, monthly_attendance.month, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE employedetails.branchid=@branchid  AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible='Yes') AND ((employedetails.employee_type='Staff') OR (employedetails.employee_type='Permanent')) AND (employedetails.status='No')");
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.employee_type, employedetails.esieligible, employedetails.empid, employedetails.employee_num, departments.department,employedetails.fullname, monthly_attendance.month, monthly_attendance.year, designation.designation, employebankdetails.ifsccode,employebankdetails.accountno, salaryappraisals.gross, salaryappraisals.erningbasic, salaryappraisals.hra,salaryappraisals.profitionaltax, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.medicalerning, salaryappraisals.washingallowance, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid  INNER JOIN departments ON employedetails.employee_dept = departments.deptid WHERE (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Permanent') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @branchid) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.pfeligible = 'Yes') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Permanent') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) ORDER BY employedetails.employee_dept,salaryappraisals.erningbasic DESC");
            cmd.Parameters.Add("@branchid", branchid);
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
                foreach (DataRow dr in dtsalary.Rows)
                {
                    
                    double totalpresentdays = 0;
                    double profitionaltax = 0;
                    double salaryadvance = 0;
                    double loan = 0;
                    double canteendeduction = 0;
                    double mobilededuction = 0;
                    double totaldeduction;
                    double totalearnings;
                    double otherdeduction = 0;
                    double medicliamdeduction = 0;
                    double providentfund = 0;
                    double medicalerning = 0;
                    double washingallowance = 0;
                    double convenyance = 0;
                    double esi = 0;
                    double tdsdeduction = 0;
                    double daysinmonth = 0;
                    double loseamount = 0;
                    double loseofconviyance = 0;
                    double loseofwashing = 0;
                    double loseofmedical = 0;
                    double losofprofitionaltax = 0;
                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    //newrow["Employeeid"] = dr["empid"].ToString();
                    string emptype = dr["employee_type"].ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["Designation"] = dr["designation"].ToString();
                    newrow["Department"] = dr["department"].ToString();
                    //newrow["Designation"] = dr["designation"].ToString();
                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                    newrow["Gross"] = peryanam / 12;
                    double permonth = peryanam / 12;
                    double HRA = Convert.ToDouble(dr["hra"].ToString());
                    double Basic = Convert.ToDouble(dr["erningbasic"].ToString());
                    convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                    //newrow["PT"] = dr["profitionaltax"].ToString();
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
                            if (mainbranch == "6")
                            {
                                newrow["Days Month"] = daysinmonth.ToString();
                            }
                           
                            double paydays = 0;
                            double lop = 0;
                            double.TryParse(dra["lop"].ToString(), out lop);
                            paydays = numberofworkingdays - lop;
                            if (mainbranch == "6")
                            {
                                newrow["Attendance Days"] = paydays.ToString();
                            }
                            double holidays = 0;
                            holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = paydays + clorwo;
                            if (clorwo == 0)
                            {
                            }
                            else
                            {
                                newrow["CL Holiday And Off"] = clorwo;
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
                            double perdaybasic = Basic / daysinmonth;
                            double perdaprofitionaltax = profitionaltax / daysinmonth;
                            losofprofitionaltax = lop * perdaprofitionaltax;
                        }
                    }
                    double perdaysal = permonth / daysinmonth;
                    double basic = 40;
                    double basicsalary = (permonth * basic) / 100;
                    double basicpermonth = basicsalary / daysinmonth;
                    double PerMonthAfter = perdaysal * totalpresentdays;
                    double bs = basicpermonth * totalpresentdays;
                    newrow["Basic"] = Math.Round(bs);
                    newrow["Conveyance Allowance"] = Math.Round(convenyance - loseofconviyance);
                    newrow["Medical Allowance"] = Math.Round(medicalerning - loseofmedical);
                    newrow["Washing Allowance"] = Math.Round(washingallowance - loseofwashing);

                    double basicsal = Math.Round(basicsalary - loseamount);
                    double conve = Math.Round(convenyance - loseofconviyance);
                    double medical = Math.Round(medicalerning - loseofmedical);
                    double washing = Math.Round(washingallowance - loseofwashing);
                    double ptax = Math.Round(profitionaltax - losofprofitionaltax);
                    double thra = 40;
                    double hra = (basicsalary * thra) / 100;
                    double tt = bs + conve + medical + washing + hra;
                    double otherallawance = Math.Round(PerMonthAfter - tt);
                    if (otherallawance > 0)
                    {
                        newrow["Variable Allowance"] = Math.Round(otherallawance);

                    }
                    else
                    {
                        newrow["Variable Allowance"] = 0;
                    }
                    totalearnings = Math.Round(tt + otherallawance);
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
                    //else if (branchid == 42)
                    //{
                    //    ptax = profitionaltax;
                    //    newrow["PT"] = ptax;
                    //}
                    if (totalearnings >= 15000)
                    {
                        ptax = profitionaltax;
                        newrow["PT"] = profitionaltax;
                    }
                    else
                    {
                        newrow["PT"] = profitionaltax;
                        //ptax = profitionaltax - losofprofitionaltax;
                        //ptax = Math.Round(ptax, 0);
                        //newrow["PT"] = ptax;
                    }
                    if (hra > 0)
                    {
                        newrow["HRA"] = hra;
                    }
                    else
                    {
                        newrow["HRA"] = 0;
                    }
                    newrow["Gross Earnings"] = totalearnings;

                    string pfeligible = dr["pfeligible"].ToString();
                    if (pfeligible == "Yes")
                    {
                        providentfund = (bs * 12) / 100;
                        if (providentfund > 1800)
                        {
                            providentfund = 1800;
                        }
                        providentfund = Math.Round(providentfund);
                        newrow["PF"] = providentfund;
                        if (mainbranch == "42")
                        {
                            double employercontri = (bs * 12) / 100;
                            if (employercontri > 1800)
                            {
                                employercontri = 1800;
                            }
                            newrow["EPF"] = Math.Round(employercontri, 0);
                        }
                    }
                    else
                    {
                        providentfund = 0;
                        newrow["PF"] = providentfund;
                        newrow["EPF"] = providentfund;
                        
                    }
                    string esieligible = dr["esieligible"].ToString();

                    if (permonth <= 21000)
                    {
                        esi = (totalearnings * 0.75) / 100;
                        esi = Math.Round(esi, 0);
                        newrow["ESI"] = esi;
                        newrow["EESI"] = Math.Round((totalearnings * 3.25) / 100, 0);
                    }
                    else
                    {
                        esi = 0;
                        newrow["ESI"] = esi;
                        newrow["EESI"] = esi;
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
                                newrow["Salary Advance"] = amount.ToString();
                                salaryadvance = Convert.ToDouble(amount);
                                salaryadvance = Math.Round(amount);
                            }
                        }
                        else
                        {
                            salaryadvance = 0;
                            newrow["Salary Advance"] = salaryadvance;
                        }
                    }
                    else
                    {
                        salaryadvance = 0;
                        newrow["Salary Advance"] = salaryadvance;
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
                                loan = Math.Round(loanemimonth);
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
                        loan = 0;
                        newrow["Loan"] = loan;
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
                                    newrow["Mobile Deductions"] = deductionamount.ToString();
                                    string st = deductionamount.ToString();
                                    mobilededuction = Convert.ToDouble(deductionamount);
                                    mobilededuction = Math.Round(deductionamount, 0);
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
                                newrow["Mobile Deductions"] = mobilededuction;
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
                            newrow["Mobile Deductions"] = mobilededuction;
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
                                if (amount == 0)
                                {
                                }
                                else
                                {
                                    newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    medicliamdeduction = Convert.ToDouble(amount);
                                    medicliamdeduction = Math.Round(amount, 0);
                                }
                            }
                        }
                        else
                        {
                            medicliamdeduction = 0;
                            if (medicliamdeduction == 0)
                            {
                            }
                            else
                            {
                                newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
                            }
                        }
                    }
                    else
                    {
                        medicliamdeduction = 0;
                        if (medicliamdeduction == 0)
                        {
                        }
                        else
                        {
                            newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
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
                                newrow["Other Deductions"] = amount.ToString();
                                string st = amount.ToString();
                                otherdeduction = Convert.ToDouble(amount);
                                otherdeduction = Math.Round(amount, 0);
                            }
                        }
                        else
                        {
                            otherdeduction = 0;
                            newrow["Other Deductions"] = otherdeduction;
                        }
                    }
                    else
                    {
                        otherdeduction = 0;
                        newrow["Other Deductions"] = otherdeduction;
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
                                    newrow["Canteen Deductions"] = deductionamount.ToString();
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
                                newrow["Canteen Deductions"] = canteendeduction;
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
                            newrow["Canteen Deductions"] = canteendeduction;
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
                                newrow["Tds Deductions"] = amount.ToString();
                                string st = amount.ToString();
                                tdsdeduction = Convert.ToDouble(amount);
                                tdsdeduction = Math.Round(amount, 0);
                            }
                        }
                        else
                        {
                            tdsdeduction = 0;
                            newrow["Tds Deductions"] = tdsdeduction;
                        }
                    }
                    else
                    {
                        tdsdeduction = 0;
                        newrow["Tds Deductions"] = tdsdeduction;
                    }
                    newrow["Total Deductions"] = profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + medicliamdeduction + otherdeduction + tdsdeduction + esi;
                    totaldeduction = profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + medicliamdeduction + otherdeduction + tdsdeduction + esi;
                    double netpay = 0;
                    netpay = totalearnings - totaldeduction;
                    netpay = Math.Round(netpay, 2);
                    newrow["Net Pay"] = netpay;
                }
            }
            DataRow newTotal = Report.NewRow();
            newTotal["Designation"] = "Total";
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
            foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
            {
                if (Report.AsEnumerable().All(drc => drc.IsNull(column)))
                    Report.Columns.Remove(column);
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
                hidepanel.Visible = false;
                lblmsg.Text = "No Data Found";
            }
        }
        catch(Exception ex)
        {
            lblmsg.Text = ex.Message;
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

    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Department");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
    
    
    
