using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class EmployeeWiseSalarySheet : System.Web.UI.Page
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
                    DateTime dtfrom = DateTime.Now;
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
                    bindemployeetype();
                    bindemploye();
                    string frmdate = dtfrom.ToString("dd/MM/yyyy");
                    string[] str = frmdate.Split('/');
                    ddlmonth.SelectedValue = str[1];
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

     private void bindemploye()
    {
        DBManager SalesDB = new DBManager();
        string mainbranch = Session["mainbranch"].ToString();
        cmd = new SqlCommand("SELECT employedetails.empid, employedetails.employee_num, employedetails.fullname FROM employedetails INNER JOIN  branchmapping ON employedetails.branchid = branchmapping.subbranch WHERE (branchmapping.mainbranch = @m)");
        //cmd.Parameters.Add("@BranchID", BranchID);
        cmd.Parameters.Add("@m", mainbranch);
        //cmd.Parameters.Add("@BranchID", BranchID);
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemployee.DataSource = dttrips;
        ddlemployee.DataTextField = "fullname";
        ddlemployee.DataValueField = "empid";
        ddlemployee.DataBind();
        ddlemployee.ClearSelection();
        ddlemployee.Items.Insert(0, new ListItem { Value = "0", Text = "--Select Type--", Selected = true });
        ddlemployee.SelectedValue = "0";
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
            string day = (mydate.Day).ToString();
            string date = mymonth + "/" + day + "/" + year;
            lblHeading.Text = ddlemptype.SelectedItem.Text + " " + ddlbranch.SelectedItem.Text + " Employee Wise Salary Statement Report " + " " + ddlmonth.SelectedItem.Text + " " + year;
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            Session["filename"] = ddlbranch.SelectedItem.Text + " Employee Wise Salary Statement " + " " + ddlmonth.SelectedItem.Text + " " + year;
            Session["title"] = ddlbranch.SelectedItem.Text + " Employee Wise Salary Statement " + " " + ddlmonth.SelectedItem.Text + " " + year;
            if (ddlemptype.SelectedItem.Text == "Staff")
            {
                Report.Columns.Add("SNO");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
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
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                string empid = ddlemployee.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year, employedetails.employee_dept, departments.department FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN departments ON employedetails.employee_dept = departments.deptid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and(employedetails.empid = @empid)");
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and (employedetails.empid=@empid)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@empid", empid);
                //cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
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
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
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
                                newrow["CL HOLIDAY AND OFF"] = clorwo;
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
                        newrow["PT"] = Math.Round(profitionaltax - losofprofitionaltax);
                        double basicsal = Math.Round(basicsalary - loseamount);
                        double conve = Math.Round(convenyance - loseofconviyance);
                        double medical = Math.Round(medicalerning - loseofmedical);
                        double washing = Math.Round(washingallowance - loseofwashing);
                        double ptax = Math.Round(profitionaltax - losofprofitionaltax);
                        double tt = bs + conve + medical + washing + ptax;
                        double thra = permonth - loseamount;
                        double hra = Math.Round(thra - tt);
                        totalearnings = Math.Round(hra + tt);
                        newrow["HRA"] = hra;
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
                            salaryadvance = 0;
                            newrow["SALARY ADVANCE"] = salaryadvance;
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
                        else
                        {
                            canteendeduction = 0;
                            newrow["CANTEEN DEDUCTION"] = canteendeduction;
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
                            otherdeduction = 0;
                            newrow["OTHER DEDUCTION"] = otherdeduction;
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
                                    newrow["Tds DEDUCTION"] = amount.ToString();
                                    string st = amount.ToString();
                                    tdsdeduction = Convert.ToDouble(amount);
                                    tdsdeduction = Math.Round(amount, 0);
                                }
                            }
                            else
                            {
                                tdsdeduction = 0;
                                newrow["Tds DEDUCTION"] = tdsdeduction;
                            }
                        }
                        else
                        {
                            tdsdeduction = 0;
                            newrow["Tds DEDUCTION"] = tdsdeduction;
                        }
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(ptax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        totaldeduction = Math.Round(ptax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 0);
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                        Report.Rows.Add(newrow);
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
                Report.Columns.Add("DAYS MONTH").DataType = typeof(double);
                Report.Columns.Add("Attendance Days").DataType = typeof(double);
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
                Report.Columns.Add("OTHER DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)  and (employedetails.empid=@empid)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
                cmd.Parameters.Add("@emptype", employee_type);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
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
                                //newrow["CL HOLIDAY AND OFF"] = clorwo;
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
                        newrow["PT"] = Math.Round(profitionaltax - losofprofitionaltax);
                        double basicsal = Math.Round(basicsalary - loseamount);
                        double conve = Math.Round(convenyance - loseofconviyance);
                        double medical = Math.Round(medicalerning - loseofmedical);
                        double washing = Math.Round(washingallowance - loseofwashing);
                        double ptax = Math.Round(profitionaltax - losofprofitionaltax);
                        double tt = bs + conve + medical + washing + ptax;
                        double thra = permonth - loseamount;
                        double hra = Math.Round(thra - tt);
                        totalearnings = Math.Round(hra + tt);
                        newrow["HRA"] = hra;
                        newrow["GROSS Earnings"] = totalearnings;
                        string pfeligible = dr["pfeligible"].ToString();
                        //string pdate = dr["pfdate"].ToString();
                        //if (pdate != "")
                        //{
                        //    DateTime dtpfdate = Convert.ToDateTime(pdate);
                        //    if (pfeligible == "Yes")
                        //    {
                        //        string pfdate = dtpfdate.ToString("MM/dd/yyyy");
                        //        string[] strpf = pfdate.Split('/');
                        //        int fmnth = Convert.ToInt32(mymonth);
                        //        int pmnth = Convert.ToInt32(strpf[1]);
                        //        if (fmnth >= pmnth)
                        //        {
                        //            providentfund = (totalearnings * 6) / 100;
                        //            if (providentfund > 1800)
                        //            {
                        //                providentfund = 1800;
                        //            }
                        //            providentfund = Math.Round(providentfund, 0);
                        //            newrow["PF"] = Math.Round(providentfund, 0);
                        //        }
                        //        else
                        //        {

                        //            providentfund = 0;
                        //            newrow["PF"] = providentfund;

                        //        }
                        //    }
                        //    else
                        //    {
                        //        providentfund = 0;
                        //        newrow["PF"] = providentfund;
                        //    }
                        //}
                        //else
                        //{
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
                        //}
                        //string edate = dr["esidate"].ToString();
                        string esieligible = dr["esieligible"].ToString();
                        //if (edate != "")
                        //{
                        //    DateTime dtesidate = Convert.ToDateTime(edate);
                        //    if (esieligible == "Yes")
                        //    {
                        //        string esidate = dtesidate.ToString("MM/dd/yyyy");
                        //        string[] stresi = esidate.Split('/');
                        //        int fmnth = Convert.ToInt32(mymonth);
                        //        int pmnth = Convert.ToInt32(stresi[1]);
                        //        if (fmnth >= pmnth)
                        //        {
                        //            esi = (totalearnings * 1.75) / 100;
                        //            esi = Math.Round(esi, 0);
                        //            newrow["ESI"] = esi;
                        //        }
                        //        else
                        //        {
                        //            esi = 0;
                        //            newrow["ESI"] = esi;
                        //        }
                        //    }
                        //    else
                        //    {
                        //        esi = 0;
                        //        newrow["ESI"] = esi;
                        //    }
                        //}
                        //else
                        //{
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
                        //}
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
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 0);
                        //string stramount = "0";
                        //stramount = netpay.ToString();
                        //if (stramount == "NaN" || stramount == "0")
                        //{
                        //}
                        //else
                        //{
                        //    newrow["NET PAY"] = Math.Ceiling(netpay);
                        //    Report.Rows.Add(newrow);
                        //}
                        newrow["NET PAY"] = Math.Round(netpay, 0);
                    }
                }
            }


            else if (ddlemptype.SelectedItem.Text == "Driver")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                // Report.Columns.Add("Employeeid");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Rate/Day");
                Report.Columns.Add("Batta/Day");
                Report.Columns.Add("Work Days").DataType = typeof(double);
                //Report.Columns.Add("Attendance Days").DataType = typeof(double);
                //Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
                Report.Columns.Add("Payable Days").DataType = typeof(double);
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
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year,employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, branchmaster.statename FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and (employedetails.empid=@empid)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@emptype", employee_type);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid) AND (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
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
                        //double totalearnings;
                        double daysinmonth = 0;
                        string statename = "";
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        //newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
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
                                if (empnumber == "SVDS080135")
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
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction);
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
                            newrow["NET PAY"] = Math.Round(netpay, 0);
                            Report.Rows.Add(newrow);
                        }
                        //newrow["NET PAY"] = Math.Ceiling(netpay);
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Cleaner")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                // Report.Columns.Add("Employeeid");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Rate/Day");
                Report.Columns.Add("Batta/Day");
                Report.Columns.Add("Work Days").DataType = typeof(double);
                //Report.Columns.Add("Attendance Days").DataType = typeof(double);
                //Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
                Report.Columns.Add("Payable Days").DataType = typeof(double);
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
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, monthly_attendance.month, monthly_attendance.year,employedetails.employee_type, employedetails.empid, employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, branchmaster.statename FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and (employedetails.empid=@empid)");
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible,employedetails.employee_type, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid=@branchid) and (employedetails.status='No') and (employedetails.employee_type=@emptype)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@emptype", employee_type);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid) AND (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
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
                        newrow["DESIGNATION"] = dr["designation"].ToString();
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
                        //string stramount = "0";
                        //stramount = netpay.ToString();
                        //if (stramount == "NaN" || stramount == "0")
                        //{
                        //}
                        //else
                        //{
                        //    newrow["NET PAY"] = Math.Ceiling(netpay);
                        //    Report.Rows.Add(newrow);
                        //}
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Casuals")
            {
                if (ddlbranch.SelectedItem.Text == "Punabaka plant")
                {
                    double totalearnings = 0;
                    Report.Columns.Add("SNO");
                    //Report.Columns.Add("Employeeid");
                    Report.Columns.Add("Employee Code");
                    Report.Columns.Add("Name");
                    Report.Columns.Add("DESIGNATION");
                    Report.Columns.Add("Rate/Day").DataType = typeof(double);
                    Report.Columns.Add("Total Days in Month").DataType = typeof(double);
                    Report.Columns.Add("Payable Days").DataType = typeof(double);
                    Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                    Report.Columns.Add("AttendanceBonus>=26days@rs.20").DataType = typeof(double);
                    Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                    //Report.Columns.Add("PT").DataType = typeof(double);
                    //Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                    //Report.Columns.Add("Loan").DataType = typeof(double);
                    Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                    //Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
                    Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                    Report.Columns.Add("NET PAY").DataType = typeof(double);
                    Report.Columns.Add("Bank Acc NO");
                    Report.Columns.Add("IFSC Code");
                    int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                    string employee_type = ddlemptype.SelectedItem.Value;
                    cmd = new SqlCommand("SELECT  employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid,  employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)and (employedetails.empid=@empid)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
                    cmd.Parameters.Add("@emptype", employee_type);
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", str[2]);
                    DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                    //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", str[2]);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid)");
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", str[2]);
                    cmd.Parameters.Add("@branchid", branchid);
                    DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                    //cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid)");
                    //cmd.Parameters.Add("@month", mymonth);
                    //cmd.Parameters.Add("@year", str[2]);
                    //cmd.Parameters.Add("@branchid", branchid);
                    //DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                    //cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid)");
                    //cmd.Parameters.Add("@branchid", branchid);
                    //DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                    cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@month", mymonth);
                    cmd.Parameters.Add("@year", str[2]);
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
                            newrow["DESIGNATION"] = dr["designation"].ToString();
                            double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                            //newrow["PT"] = dr["profitionaltax"].ToString();
                            //double rateper = Convert.ToDouble(dr["gross"].ToString());
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
                            //string stramount = "0";
                            //stramount = netpay.ToString();
                            //if (stramount == "NaN" || stramount == "0")
                            //{
                            //}
                            //else
                            //{
                            //    newrow["NET PAY"] = Math.Ceiling(netpay);
                            //    Report.Rows.Add(newrow);
                            //}
                        }
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "KMM Casuals")
            {
                double totalearnings = 0;
                Report.Columns.Add("SNO");
                //Report.Columns.Add("Employeeid");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("Rate/Day").DataType = typeof(double);
                Report.Columns.Add("Work Days").DataType = typeof(double);
                Report.Columns.Add("Payable Days").DataType = typeof(double);
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                //Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                //Report.Columns.Add("Loan").DataType = typeof(double);
                Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT  employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid,  employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and (employedetails.empid=@empid)");
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employebankdetails.ifsccode,employedetails.employee_type, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid=@branchid) and (employedetails.status='No') and (employedetails.employee_type=@emptype)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@emptype", employee_type);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                //cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid)");
                //cmd.Parameters.Add("@month", mymonth);
                //cmd.Parameters.Add("@year", str[2]);
                //cmd.Parameters.Add("@branchid", branchid);
                //DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                //cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid)");
                //cmd.Parameters.Add("@branchid", branchid);
                //DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid)AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
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
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                        //double rateper = Convert.ToDouble(dr["gross"].ToString());
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
                                //double rateperday = 0;
                                newrow["Work Days"] = numberofworkingdays;
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = paydays;
                                double rate = Convert.ToDouble(dr["gross"].ToString());
                                newrow["Rate/Day"] = rate;
                                //double bonus = 20;
                                //double rateperday = 0;
                                //double amount = 0;
                                //if (paydays >= 26)
                                //{
                                //    rateperday = rate + bonus;
                                //    amount = bonus * paydays;
                                //    newrow["AttendanceBonus>=26days@rs.20"] = amount;

                                //}
                                //else
                                //{
                                //    newrow["AttendanceBonus>=26days@rs.20"] = 0;
                                //    rateperday = rate + bonus;
                                //}
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
                        //string stramount = "0";
                        //stramount = netpay.ToString();
                        //if (stramount == "NaN" || stramount == "0")
                        //{
                        //}
                        //else
                        //{
                        //    newrow["NET PAY"] = Math.Ceiling(netpay);
                        //    Report.Rows.Add(newrow);
                        //}
                    }
                }
            }
            else if (ddlemptype.SelectedItem.Text == "Retainers")
            {
                Report.Columns.Add("SNO");
                //Report.Columns.Add("Employeeid");
                Report.Columns.Add("Employee Code");
                Report.Columns.Add("Name");
                Report.Columns.Add("DESIGNATION");
                Report.Columns.Add("GROSS").DataType = typeof(double);
                Report.Columns.Add("DAYS MONTH").DataType = typeof(double);
                Report.Columns.Add("Attendance Days").DataType = typeof(double);
                Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
                Report.Columns.Add("Payable Days").DataType = typeof(double);
                Report.Columns.Add("BASIC").DataType = typeof(double);
                Report.Columns.Add("HRA").DataType = typeof(double);
                Report.Columns.Add("CONVEYANCE ALLOWANCE").DataType = typeof(double);
                Report.Columns.Add("WASHING ALLOWANCE").DataType = typeof(double);
                Report.Columns.Add("MEDICAL ALLOWANCE").DataType = typeof(double);
                Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
                Report.Columns.Add("PT").DataType = typeof(double);
                Report.Columns.Add("PF").DataType = typeof(double);
                Report.Columns.Add("ESI").DataType = typeof(double);
                Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
                Report.Columns.Add("Loan").DataType = typeof(double);
                Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("MEDICLAIM DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("OTHER DEDUCTION").DataType = typeof(double);
                Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
                Report.Columns.Add("NET PAY").DataType = typeof(double);
                Report.Columns.Add("Bank Acc NO");
                Report.Columns.Add("IFSC Code");
                int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
                string employee_type = ddlemptype.SelectedItem.Value;
                cmd = new SqlCommand("SELECT  employedetails.pfeligible, employedetails.pfdate, employedetails.esidate, pay_structure.salaryperyear, employebankdetails.ifsccode, employedetails.esieligible, employedetails.employee_type, employedetails.empid,  employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.gross, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, monthly_attendance.month, monthly_attendance.year FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid = @branchid) AND (employedetails.status = 'No') AND (employedetails.employee_type = @emptype) AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) and (employedetails.empid=@empid)");
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employebankdetails.ifsccode, employedetails.esieligible,employedetails.employee_type, employedetails.empid,employedetails.employee_num, pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid  LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE (employedetails.branchid=@branchid) and (employedetails.status='No') and (employedetails.employee_type=@emptype)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@empid", ddlemployee.SelectedItem.Value);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@emptype", employee_type);
                DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
                //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_workingdays.numberofworkingdays, monthly_attendance.lop,  branchmaster.branchid FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN monthly_workingdays ON branchmaster.branchid = monthly_workingdays.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid=@branchid)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                cmd.Parameters.Add("@branchid", branchid);
                DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid) AND (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
                DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid)");
                cmd.Parameters.Add("@branchid", branchid);
                //cmd.Parameters.Add("@month", mymonth);
                //cmd.Parameters.Add("@year", str[2]);
                DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
                cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
                cmd.Parameters.Add("@branchid", branchid);
                cmd.Parameters.Add("@month", mymonth);
                cmd.Parameters.Add("@year", str[2]);
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
                        double otherdeduction = 0;
                        double medicliamdeduction = 0;
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
                        DataRow newrow = Report.NewRow();
                        newrow["SNO"] = i++.ToString();
                        //newrow["Employeeid"] = dr["empid"].ToString();
                        newrow["Employee Code"] = dr["employee_num"].ToString();
                        newrow["Name"] = dr["fullname"].ToString();
                        newrow["DESIGNATION"] = dr["designation"].ToString();
                        double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                        newrow["GROSS"] = peryanam / 12;
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
                                newrow["DAYS MONTH"] = daysinmonth.ToString();
                                newrow["Attendance Days"] = dra["numberofworkingdays"].ToString();
                                double paydays = 0;
                                double lop = 0;
                                double.TryParse(dra["lop"].ToString(), out lop);
                                paydays = numberofworkingdays - lop;
                                double holidays = 0;
                                holidays = daysinmonth - numberofworkingdays;
                                newrow["Payable Days"] = numberofworkingdays + clorwo;
                                newrow["CL HOLIDAY AND OFF"] = clorwo;
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
                        newrow["HRA"] = hra;
                        newrow["GROSS Earnings"] = totalearnings;
                        string pfeligible = dr["pfeligible"].ToString();
                        string esieligible = dr["esieligible"].ToString();
                        string pdate = dr["pfdate"].ToString();
                        string edate = dr["esidate"].ToString();
                        //if (pdate != "")
                        //{
                        //    DateTime dtpfdate = Convert.ToDateTime(pdate);
                        //    if (pfeligible == "Yes")
                        //    {
                        //        string pfdate = dtpfdate.ToString("MM/dd/yyyy");
                        //        string[] strpf = pfdate.Split('/');
                        //        int fmnth = Convert.ToInt32(mymonth);
                        //        int pmnth = Convert.ToInt32(strpf[1]);
                        //        if (fmnth >= pmnth)
                        //        {
                        //            providentfund = (totalearnings * 6) / 100;
                        //            if (providentfund > 1800)
                        //            {
                        //                providentfund = 1800;
                        //            }
                        //            providentfund = Math.Round(providentfund, 0);
                        //            newrow["PF"] = Math.Round(providentfund, 0);
                        //        }
                        //        else
                        //        {

                        //            providentfund = 0;
                        //            newrow["PF"] = providentfund;

                        //        }
                        //    }
                        //    else
                        //    {
                        //        providentfund = 0;
                        //        newrow["PF"] = providentfund;
                        //    }
                        //}
                        //else
                        //{
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
                        //}
                        //if (edate != "")
                        //{
                        //    DateTime dtesidate = Convert.ToDateTime(edate);
                        //    if (esieligible == "Yes")
                        //    {
                        //        string pfdate = dtesidate.ToString("MM/dd/yyyy");
                        //        string[] strpf = pfdate.Split('/');
                        //        int fmnth = Convert.ToInt32(mymonth);
                        //        int pmnth = Convert.ToInt32(strpf[1]);
                        //        if (fmnth >= pmnth)
                        //        {
                        //            esi = (totalearnings * 1.75) / 100;
                        //            esi = Math.Round(esi, 0);
                        //            newrow["ESI"] = esi;
                        //        }
                        //        else
                        //        {
                        //            esi = 0;
                        //            newrow["ESI"] = esi;
                        //        }
                        //    }
                        //    else
                        //    {
                        //        esi = 0;
                        //        newrow["ESI"] = esi;
                        //    }
                        //}
                        //else
                        //{
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
                        //}
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
                        newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction);
                        totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction);
                        double netpay = 0;
                        netpay = Math.Round(totalearnings - totaldeduction);
                        netpay = Math.Round(netpay, 2);
                        //string stramount = "0";
                        //stramount = netpay.ToString();
                        //if (stramount == "NaN" || stramount == "0")
                        //{
                        //}
                        //else
                        //{
                        //    newrow["NET PAY"] = Math.Ceiling(netpay);
                        //    Report.Rows.Add(newrow);
                        //}
                        newrow["NET PAY"] = Math.Round(netpay, 0);
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
            //foreach (var column in Report.Columns.Cast<DataColumn>().ToArray())
            //{
            //    if (Report.AsEnumerable().All(dr => dr.IsNull(column)))
            //        Report.Columns.Remove(column);
            //}
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
            if (e.Row.Cells[3].Text == "Total")
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

    protected void btnlogssave_click(object sender, EventArgs e)
    {
        DBManager SalesDB = new DBManager();
        DataTable dtlogs = new DataTable();
        dtlogs = (DataTable)Session["xportdata"];
        if (dtlogs.Rows.Count > 0)
        {
            DateTime doe = DateTime.Now;
            foreach (DataRow dr in dtlogs.Rows)
            {
                string emptype = ddlemptype.SelectedItem.Value;
                string branchid = ddlbranch.SelectedItem.Value;
                string month = ddlbranch.SelectedItem.Value;
                string empcode = dr["Employee Code"].ToString();
                string Name = dr["Name"].ToString();
                string designation = dr["DESIGNATION"].ToString();
                string daysmonth = dr["DAYS MONTH"].ToString();
                string attandancedays = dr["Attendance Days"].ToString();
                string clandholidayoff = dr["CL HOLIDAY AND OFF"].ToString();
                string payabledays = dr["Payable Days"].ToString();
                string basic = dr["BASIC"].ToString();
                string hra = dr["HRA"].ToString();
                string conveyance = dr["CONVEYANCE ALLOWANCE"].ToString();
                string medical = dr["MEDICAL ALLOWANCE"].ToString();
                string washing = dr["WASHING ALLOWANCE"].ToString();
                string gross = dr["GROSS Earnings"].ToString();
                string pt = dr["PT"].ToString();
                string pf = dr["PF"].ToString();
                string esi = dr["ESI"].ToString();
                string salaryadvance = dr["SALARY ADVANCE"].ToString();
                string loan = dr["Loan"].ToString();
                string canteendeduction = dr["CANTEEN DEDUCTION"].ToString();
                string mobilededuction = dr["MOBILE DEDUCTION"].ToString();
                string mediclim = dr["MEDICLAIM DEDUCTION"].ToString();
                string otherdeduction = dr["OTHER DEDUCTION"].ToString();
                string totaldeduction = dr["TOTAL DEDUCTIONS"].ToString();
                string netpay = dr["NET PAY"].ToString();
                string bankaccountno = dr["Bank Acc NO"].ToString();
                string ifsccode = dr["IFSC Code"].ToString();
                cmd = new SqlCommand("SELECT * FROM monthlysalarystatement WHERE emptype=@empPtype AND branchid=@branch AND month=@monthd");
                cmd.Parameters.Add("@empPtype", emptype);
                cmd.Parameters.Add("@branch", branchid);
                cmd.Parameters.Add("@monthd", month);
                DataTable dtdata = vdm.SelectQuery(cmd).Tables[0];
                if (dtdata.Rows.Count > 0)
                {
                    lblmsg.Text = "THIS MONTH OF DATA ALREADY CLOSED ";
                }
                else
                {
                    cmd = new SqlCommand("insert into monthlysalarystatement(employecode, empname, designation, daysmonth, attandancedays, clandholidayoff, payabledays, basic, hra, conveyance, medical, washing, gross, pt, pf, esi,  salaryadvance, loan, canteendeduction, mobilededuction, mediclim, otherdeduction, totaldeduction, netpay, bankaccountno, ifsccode, emptype, branchid, month, dateofclosing, closedby) Values (@employecode, @empname, @designation, @daysmonth, @attandancedays, @clandholidayoff, @payabledays, @basic, @hra, @conveyance, @medical, @washing,@gross,@pt,@pf,@esi,@salaryadvance,@loan,@canteendeduction,@mobilededuction,@mediclim,@otherdeduction,@totaldeduction,@netpay,@bankaccountno,@ifsccode,@emptype,@branchid,@month,@dateofclosing,@closedby)");
                    cmd.Parameters.Add("@employecode", empcode);
                    cmd.Parameters.Add("@empname", Name);
                    cmd.Parameters.Add("@designation", designation);
                    cmd.Parameters.Add("@daysmonth", daysmonth);
                    cmd.Parameters.Add("@attandancedays", attandancedays);
                    cmd.Parameters.Add("@clandholidayoff", clandholidayoff);
                    cmd.Parameters.Add("@payabledays", payabledays);
                    cmd.Parameters.Add("@basic", basic);
                    cmd.Parameters.Add("@hra", hra);
                    cmd.Parameters.Add("@conveyance", conveyance);
                    cmd.Parameters.Add("@medical", medical);
                    cmd.Parameters.Add("@washing", washing);
                    cmd.Parameters.Add("@gross", gross);
                    cmd.Parameters.Add("@pt", pt);
                    cmd.Parameters.Add("@pf", pf);
                    cmd.Parameters.Add("@esi", esi);
                    cmd.Parameters.Add("@salaryadvance", salaryadvance);
                    cmd.Parameters.Add("@loan", loan);
                    cmd.Parameters.Add("@canteendeduction", canteendeduction);
                    cmd.Parameters.Add("@mobilededuction", mobilededuction);
                    cmd.Parameters.Add("@mediclim", mediclim);
                    cmd.Parameters.Add("@otherdeduction", otherdeduction);
                    cmd.Parameters.Add("@totaldeduction", totaldeduction);
                    cmd.Parameters.Add("@netpay", netpay);
                    cmd.Parameters.Add("@bankaccountno", bankaccountno);
                    cmd.Parameters.Add("@ifsccode", ifsccode);
                    cmd.Parameters.Add("@emptype", emptype);
                    cmd.Parameters.Add("@branchid", branchid);
                    cmd.Parameters.Add("@month", month);
                    cmd.Parameters.Add("@dateofclosing", doe);
                    cmd.Parameters.Add("@closedby", Session["empid"]);
                    SalesDB.insert(cmd);
                }
            }
        }
    }
}