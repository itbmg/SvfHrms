using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class MarketingSalarystatement : System.Web.UI.Page
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
                    //bindemployeetype();
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
    //private void bindemployeetype()
    //{
    //    DBManager SalesDB = new DBManager();
    //    cmd = new SqlCommand("SELECT employee_type FROM employedetails where (employee_type<>'')  GROUP BY employee_type");
    //    DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
    //    ddlemptype.DataSource = dttrips;
    //    ddlemptype.DataTextField = "employee_type";
    //    ddlemptype.DataValueField = "employee_type";
    //    ddlemptype.DataBind();
    //    ddlemptype.ClearSelection();
    //    ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
    //    ddlemptype.SelectedValue = "0";
    //}
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
            string year = ddlyear.SelectedItem.Value;
            //string currentyear = (mydate.Year).ToString();
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
            string date = mymonth + "/" + day + "/" + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;

            fromdate = Convert.ToDateTime(date);


            lblHeading.Text = "Marketing" + " " + ddlbranch.SelectedItem.Text + " Salary Statement Report " + " " + ddlmonth.SelectedItem.Text + " " + year;
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
            //if (ddlemptype.SelectedItem.Text == "Staff" || ddlemptype.SelectedItem.Text == "Permanent")
            //{

                //Report.Columns.Add("DEPT");
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
                //string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid,employedetails.employee_num, employedetails.fullname, designation.designation, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department, salaryappraisals.esi, salaryappraisals.providentfund, salaryappraisals.conveyance, salaryappraisals.washingallowance, salaryappraisals.salaryperyear, salaryappraisals.medicalerning, salaryappraisals.profitionaltax, salaryappraisals.hra, salaryappraisals.erningbasic FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN  salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Permanent' ) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) AND (employedetails.employee_dept = '5') OR (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = 'Staff' OR employedetails.employee_type = 'Permanent') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (salaryappraisals.endingdate > @d1)AND (salaryappraisals.startingdate <= @d1) AND (employedetails.employee_dept = '5') ORDER BY  employedetails.employee_dept");
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                //cmd.Parameters.Add("@emptype", employee_type);
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
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        //newrow["DEPT"] = dr["department"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = (dr["department"].ToString() + " " + dr["designation"].ToString());
                        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                        newrow["GROSS"] = peryanam / 12;


                        double permonth = peryanam / 12;
                        double HRA = Convert.ToDouble(dr["hra"].ToString());
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        convenyance = Convert.ToDouble(dr["conveyance"].ToString());
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
                        rate = permonth;
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
                                    if (deductionamount == 0)
                                    {
                                    }
                                    else
                                    {
                                        newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
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
                                    newrow["MOBILE DEDUCTION"] = Math.Round(mobilededuction, 0);
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
            //}
            
            
            
            
            
            
           
            DataRow newTotal = Report.NewRow();
            newTotal["DESIGNATION"] = "Total Amount";
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
                if (e.Row.Cells[3].Text == "Total Amount")
                {
                    e.Row.BackColor = System.Drawing.Color.Aquamarine;
                    e.Row.Font.Size = FontUnit.Large;
                    e.Row.Font.Bold = true;

                }
            }

        }
    }
    //protected void grdReports_DataBinding(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string mainb = Session["mainbranch"].ToString();
    //        if (mainb == "6")
    //        {
    //            GridViewGroup First = new GridViewGroup(grdReports, null, "DEPT");
    //            // GridViewGroup three = new GridViewGroup(grdReports, seconf, "PF");
    //        }
    //        else
    //        {

    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //}
    protected void btnlogssave_click(object sender, EventArgs e)
    {
        DBManager SalesDB = new DBManager();
        DataTable empid = Session["empid"] as DataTable;
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid,employedetails.employee_type, employedetails.employee_num, employedetails.fullname, departments.department, departments.deptid, designation.designation, designation.designationid FROM employedetails INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch INNER JOIN departments ON employedetails.employee_dept = departments.deptid INNER JOIN designation ON employedetails.designationid = designation.designationid WHERE(branchmapping.mainbranch = @m) AND (employedetails.status = 'No')");
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
            //string type = ddlemptype.SelectedItem.Value;
            cmd = new SqlCommand("SELECT * FROM monthlysalarystatement WHERE   branchid=@branch AND month=@month and year=@year and (type='Staff' OR type='Permanent')");
            cmd.Parameters.Add("@branch", branchid);
            cmd.Parameters.Add("@month", month);
            cmd.Parameters.Add("@year", year);
            //cmd.Parameters.Add("@type", type);
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
                        string emptype = dr["employee_type"].ToString();
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