using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class summaryreport : System.Web.UI.Page
{
    SqlCommand cmd;
    string BranchID = "";
    DBManager vdm;
    string getbranch = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["branchid"] == null)
            Response.Redirect("Login.aspx");
        else
        {
            //BranchID = Session["branchid"].ToString();
            vdm = new DBManager();
            if (!Page.IsPostBack)
            {
                if (!Page.IsCallback)
                {

                    //lblAddress.Text = Session["Address"].ToString();
                    //lblTitle.Text = Session["TitleName"].ToString();
                }
            }
        }
    }

    //DataTable Report = new DataTable();
    //DataTable Report1 = new DataTable();
    //protected void btn_Generate_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        lblmsg.Text = "";
    //        DBManager SalesDB = new DBManager();
    //        DateTime fromdate = DateTime.Now;
    //        DateTime mydate = DateTime.Now;
    //        string currentyear = (mydate.Year).ToString();
    //        string year = ddlyear.SelectedItem.Value;
    //        string mymonth = ddlmonth.SelectedItem.Value;
    //        string day = "";
    //        if (mymonth == "02")
    //        {
    //            day = "28";
    //        }
    //        else
    //        {
    //            day = (mydate.Day).ToString();
    //        }
    //        //string day = (mydate.Day).ToString();
    //        string d = "00";
    //        string date = mymonth + "/" + day + "/" + year;
    //        lblHeading.Text = " Summary Salary Statement" + ddlmonth.SelectedItem.Text + year;
    //        DateTime dtfrom = fromdate;
    //        string frmdate = dtfrom.ToString("dd/MM/yyyy");
    //        string[] str = frmdate.Split('/');
    //        lblFromDate.Text = mymonth;
    //        fromdate = Convert.ToDateTime(date);
    //        Session["filename"] = " Summary Salary Statement " + ddlmonth.SelectedItem.Text + year;
    //        Session["title"] = " Summary Salary Statement " + ddlmonth.SelectedItem.Text + year;

    //        cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno");
    //        DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
    //        if (dtcompany.Rows.Count > 0)
    //        {
    //            lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
    //            lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
    //        }
    //        else
    //        {
    //            lblAddress.Text = Session["Address"].ToString();
    //            lblTitle.Text = Session["TitleName"].ToString();
    //        }
    //        string mainbranch = Session["mainbranch"].ToString();
    //        if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC" || ddlbranchtype.SelectedItem.Text == "Plant")
    //        {
    //            if (ddltype.SelectedItem.Text == "Location")
    //            {
    //                cmd = new SqlCommand(" SELECT  branchmaster.branchid, branchmaster.branchname, branchmaster.branchtype, branchmaster.company_code FROM branchmaster INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch  Where branchmaster.branchtype=@branchtype and  (branchmapping.mainbranch = @m)");
    //                cmd.Parameters.Add("@m", mainbranch);
    //                cmd.Parameters.Add("@branchtype", ddlbranchtype.SelectedItem.Value);
    //                DataTable dtbranch = vdm.SelectQuery(cmd).Tables[0];
    //                DataTable dtnew = new DataTable();
    //                dtnew.Columns.Add("SNO");
    //                dtnew.Columns.Add("Month");
    //                dtnew.Columns.Add("loacation");
    //                dtnew.Columns.Add("Amount").DataType = typeof(double);
    //                if (dtbranch.Rows.Count > 0)
    //                {
    //                    var k = 1;
    //                    foreach (DataRow dtbr in dtbranch.Rows)
    //                    {
    //                        Report = new DataTable();
    //                        Report.Columns.Add("Employee Code");
    //                        Report.Columns.Add("Name");
    //                        Report.Columns.Add("Extra Pay");
    //                        Report.Columns.Add("Location");
    //                        Report.Columns.Add("DESIGNATION");
    //                        Report.Columns.Add("GROSS").DataType = typeof(double);
    //                        Report.Columns.Add("DAYS MONTH").DataType = typeof(double);
    //                        Report.Columns.Add("Attendance Days").DataType = typeof(double);
    //                        Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
    //                        Report.Columns.Add("Payable Days").DataType = typeof(double);
    //                        Report.Columns.Add("BASIC").DataType = typeof(double);
    //                        Report.Columns.Add("HRA").DataType = typeof(double);
    //                        Report.Columns.Add("CONVEYANCE ALLOWANCE").DataType = typeof(double);
    //                        Report.Columns.Add("MEDICAL ALLOWANCE").DataType = typeof(double);
    //                        Report.Columns.Add("WASHING ALLOWANCE").DataType = typeof(double);
    //                        Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
    //                        Report.Columns.Add("PT").DataType = typeof(double);
    //                        Report.Columns.Add("PF").DataType = typeof(double);
    //                        Report.Columns.Add("ESI").DataType = typeof(double);
    //                        Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
    //                        Report.Columns.Add("Loan").DataType = typeof(double);
    //                        Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
    //                        Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
    //                        Report.Columns.Add("MEDICLAIM DEDUCTION").DataType = typeof(double);
    //                        Report.Columns.Add("OTHER DEDUCTION").DataType = typeof(double);
    //                        Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
    //                        Report.Columns.Add("Tds DEDUCTION").DataType = typeof(double);
    //                        Report.Columns.Add("NET PAY").DataType = typeof(double);
    //                        Report.Columns.Add("Bank Acc NO");
    //                        Report.Columns.Add("IFSC Code");
    //                        string branchid = dtbr["branchid"].ToString();
    //                        string branchname = dtbr["branchname"].ToString();
    //                        cmd = new SqlCommand("SELECT employedetails.pfeligible,  employedetails.pfdate, employedetails.esidate, employedetails.esieligible, employedetails.employee_type, employedetails.empid, employedetails.employee_num,pay_structure.erningbasic, pay_structure.esi, pay_structure.providentfund, employedetails.fullname, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax,employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname,monthly_attendance.month, monthly_attendance.year FROM  employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN monthly_attendance ON employedetails.empid = monthly_attendance.empid INNER JOIN  branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid  INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid  WHERE (employedetails.status = 'No') AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (branchmapping.mainbranch = @m) and (employedetails.branchid = @branchid) AND  (employedetails.employee_type = 'Staff')");
    //                        cmd.Parameters.Add("@m", mainbranch);
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.extradays,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.branchid = @branchid)");
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where (employedetails.branchid=@branchid) AND (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        DataTable dtsa = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where (employedetails.branchid=@branchid) AND (loan_request.month = @month) AND (loan_request.year = @year)");
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        DataTable dtloan = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where (employedetails.branchid=@branchid) AND (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        DataTable dtmobile = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where (employedetails.branchid=@branchid) AND (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        DataTable dtcanteen = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid WHERE (employedetails.branchid = @branchid)");
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        //cmd.Parameters.Add("@month", mymonth);
    //                        //cmd.Parameters.Add("@year", str[2]);
    //                        DataTable dtmedicliam = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE (employedetails.branchid = @branchid) AND (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        cmd.Parameters.Add("@month", mymonth);
    //                        cmd.Parameters.Add("@year", year);
    //                        DataTable dtotherdeduction = vdm.SelectQuery(cmd).Tables[0];
    //                        cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid WHERE (employedetails.branchid = @branchid)");
    //                        cmd.Parameters.Add("@branchid", branchid);
    //                        //cmd.Parameters.Add("@month", mymonth);
    //                        //cmd.Parameters.Add("@year", str[2]);
    //                        DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];
    //                        if (dtsalary.Rows.Count > 0)
    //                        {
    //                            var i = 1;
    //                            foreach (DataRow dr in dtsalary.Rows)
    //                            {
    //                                double otamount = 0;
    //                                double totalpresentdays = 0;
    //                                double profitionaltax = 0;
    //                                double salaryadvance = 0;
    //                                double loan = 0;
    //                                double canteendeduction = 0;
    //                                double otherdeduction = 0;
    //                                double tdsdeduction = 0;
    //                                double medicliamdeduction = 0;
    //                                double mobilededuction = 0;
    //                                double totaldeduction;
    //                                double totalearnings;
    //                                double providentfund = 0;
    //                                double medicalerning = 0;
    //                                double washingallowance = 0;
    //                                double convenyance = 0;
    //                                double esi = 0;
    //                                double daysinmonth = 0;
    //                                double loseamount = 0;
    //                                double loseofconviyance = 0;
    //                                double loseofwashing = 0;
    //                                double loseofmedical = 0;
    //                                double losofprofitionaltax = 0;
    //                                DataRow newrow = Report.NewRow();
    //                                newrow["Employee Code"] = dr["employee_num"].ToString();
    //                                newrow["Name"] = dr["fullname"].ToString();
    //                                newrow["DESIGNATION"] = dr["designation"].ToString();
    //                                double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
    //                                newrow["GROSS"] = peryanam / 12;
    //                                double permonth = peryanam / 12;
    //                                double HRA = Convert.ToDouble(dr["hra"].ToString());
    //                                double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
    //                                convenyance = Convert.ToDouble(dr["conveyance"].ToString());
    //                                profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
    //                                medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
    //                                washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
    //                                newrow["Bank Acc NO"] = dr["accountno"].ToString();
    //                                newrow["IFSC Code"] = dr["ifsccode"].ToString();
                                    
    //                                if (dtattendence.Rows.Count > 0)
    //                                {
    //                                    foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double otdays = 0;
    //                                        string ot ;
                                         
    //                                        double otvalue = 0;
    //                                        double numberofworkingdays = 0;
    //                                        double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
    //                                        double clorwo = 0;
    //                                        double.TryParse(dra["clorwo"].ToString(), out clorwo);
    //                                        daysinmonth = numberofworkingdays + clorwo;
    //                                        newrow["DAYS MONTH"] = daysinmonth.ToString();
                                            
    //                                        double paydays = 0;
    //                                        double lop = 0;
    //                                        double.TryParse(dra["lop"].ToString(), out lop);
    //                                        paydays = numberofworkingdays - lop;
    //                                        newrow["Attendance Days"] = paydays.ToString();

    //                                        double holidays = 0;
    //                                        holidays = daysinmonth - numberofworkingdays;
    //                                        if (lop != 0)
    //                                        {
    //                                            double totaldays = paydays + clorwo;
    //                                            newrow["Payable Days"] = totaldays;
    //                                        }
    //                                        else
    //                                        {
    //                                            newrow["Payable Days"] = paydays + clorwo;
    //                                        }
    //                                        newrow["CL HOLIDAY AND OFF"] = clorwo;
    //                                        totalpresentdays = holidays + paydays;
    //                                        double totalpdays = permonth / daysinmonth;
    //                                        loseamount = lop * totalpdays;
    //                                        double perdayconveyance = convenyance / daysinmonth;
    //                                        loseofconviyance = lop * perdayconveyance;
    //                                        double perdaywashing = washingallowance / daysinmonth;
    //                                        loseofwashing = lop * perdaywashing;
    //                                        double perdaymedical = medicalerning / daysinmonth;
    //                                        loseofmedical = lop * perdaymedical;
    //                                        double perdaybasic = BASIC / daysinmonth;
    //                                        double perdaprofitionaltax = profitionaltax / daysinmonth;
    //                                        losofprofitionaltax = lop * perdaprofitionaltax;
    //                                        double perdaysal = permonth / daysinmonth;
    //                                        ot = dra["extradays"].ToString();
    //                                        if (ot == "" || ot == "0")
    //                                        {
    //                                            otdays = 0;
    //                                        }
    //                                        else
    //                                        {
    //                                            otdays = Convert.ToDouble(dra["extradays"].ToString());
    //                                            otvalue = perdaysal * otdays;
    //                                            newrow["Extra Pay"] = Math.Round(otvalue);
    //                                            otamount = otvalue;
    //                                        }
    //                                    }
    //                                }
    //                                //double perdaysal = permonth / daysinmonth;
    //                                double basic = 50;
    //                                double basicsalary = (permonth * 50) / 100;
    //                                double basicpermonth = basicsalary / daysinmonth;
    //                                double bs = basicpermonth * totalpresentdays;
                                   
                                   
    //                                newrow["BASIC"] = Math.Round(bs);
    //                                newrow["CONVEYANCE ALLOWANCE"] = Math.Round(convenyance - loseofconviyance);
    //                                newrow["MEDICAL ALLOWANCE"] = Math.Round(medicalerning - loseofmedical);
    //                                newrow["WASHING ALLOWANCE"] = Math.Round(washingallowance - loseofwashing);
    //                                newrow["PT"] = Math.Round(profitionaltax - losofprofitionaltax);
    //                                double basicsal = Math.Round(basicsalary - loseamount);
    //                                double conve = Math.Round(convenyance - loseofconviyance);
    //                                double medical = Math.Round(medicalerning - loseofmedical);
    //                                double washing = Math.Round(washingallowance - loseofwashing);
    //                                double ptax = Math.Round(profitionaltax - losofprofitionaltax);
    //                                double tt = bs + conve + medical + washing;
    //                                double thra = permonth - loseamount;
    //                                double hra = Math.Round(thra - tt);
    //                                totalearnings = Math.Round(hra + tt);
    //                                newrow["HRA"] = hra;
    //                                newrow["GROSS Earnings"] = totalearnings;
    //                                string pfeligible = dr["pfeligible"].ToString();
    //                                if (pfeligible == "Yes")
    //                                {
    //                                    providentfund = (totalearnings * 6) / 100;
    //                                    if (providentfund > 1800)
    //                                    {
    //                                        providentfund = 1800;
    //                                    }
    //                                    providentfund = Math.Round(providentfund, 0);
    //                                    newrow["PF"] = Math.Round(providentfund, 0);
    //                                }
    //                                else
    //                                {
    //                                    providentfund = 0;
    //                                    newrow["PF"] = providentfund;
    //                                }
    //                                string esieligible = dr["esieligible"].ToString();
    //                                if (esieligible == "Yes")
    //                                {
    //                                    esi = (totalearnings * 1.75) / 100;
    //                                    esi = Math.Round(esi, 0);
    //                                    newrow["ESI"] = esi;
    //                                }
    //                                else
    //                                {
    //                                    esi = 0;
    //                                    newrow["ESI"] = esi;
    //                                }
    //                                if (dtsa.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drsa in dtsa.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double amount = 0;
    //                                            double.TryParse(drsa["amount"].ToString(), out amount);
    //                                            newrow["SALARY ADVANCE"] = amount.ToString();
    //                                            salaryadvance = Convert.ToDouble(amount);
    //                                            salaryadvance = Math.Round(amount, 0);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        salaryadvance = 0;
    //                                        newrow["SALARY ADVANCE"] = salaryadvance;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    salaryadvance = 0;
    //                                    newrow["SALARY ADVANCE"] = salaryadvance;
    //                                }
    //                                if (dtloan.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drloan in dtloan.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double loanemimonth = 0;
    //                                            double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
    //                                            newrow["Loan"] = loanemimonth.ToString();
    //                                            loan = Convert.ToDouble(loanemimonth);
    //                                            loan = Math.Round(loanemimonth, 0);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        loan = 0;
    //                                        newrow["Loan"] = loan;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    loan = 0;
    //                                    newrow["Loan"] = loan;
    //                                }
    //                                mobilededuction = 0;
    //                                if (dtmobile.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drmobile in dtmobile.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double deductionamount = 0;
    //                                            double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
    //                                            newrow["MOBILE DEDUCTION"] = deductionamount.ToString();
    //                                            string st = deductionamount.ToString();
    //                                            if (st == "0.0")
    //                                            {
    //                                                mobilededuction = 0;
    //                                                newrow["MOBILE DEDUCTION"] = mobilededuction;

    //                                            }
    //                                            else
    //                                            {
    //                                                mobilededuction = Convert.ToDouble(deductionamount);
    //                                                mobilededuction = Math.Round(deductionamount, 0);
    //                                            }
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        mobilededuction = 0;
    //                                        newrow["MOBILE DEDUCTION"] = mobilededuction;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    mobilededuction = 0;
    //                                    newrow["MOBILE DEDUCTION"] = mobilededuction;
    //                                }
    //                                canteendeduction = 0;
    //                                if (dtcanteen.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drcanteen in dtcanteen.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double deductionamount = 0;
    //                                            double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
    //                                            newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
    //                                            string st = deductionamount.ToString();
    //                                            canteendeduction = Convert.ToDouble(deductionamount);
    //                                            canteendeduction = Math.Round(deductionamount, 0);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        canteendeduction = 0;
    //                                        newrow["CANTEEN DEDUCTION"] = canteendeduction;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    canteendeduction = 0;
    //                                    newrow["CANTEEN DEDUCTION"] = canteendeduction;
    //                                }
    //                                medicliamdeduction = 0;
    //                                if (dtmedicliam.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drmedicliam in dtmedicliam.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double amount = 0;
    //                                            double.TryParse(drmedicliam["medicliamamount"].ToString(), out amount);
    //                                            newrow["MEDICLAIM DEDUCTION"] = amount.ToString();
    //                                            string st = amount.ToString();
    //                                            medicliamdeduction = Convert.ToDouble(amount);
    //                                            medicliamdeduction = Math.Round(amount, 0);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        medicliamdeduction = 0;
    //                                        newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    medicliamdeduction = 0;
    //                                    newrow["MEDICLAIM DEDUCTION"] = medicliamdeduction;
    //                                }
    //                                otherdeduction = 0;
    //                                if (dtotherdeduction.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drotherdeduction in dtotherdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double amount = 0;
    //                                            double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
    //                                            newrow["OTHER DEDUCTION"] = amount.ToString();
    //                                            string st = amount.ToString();
    //                                            otherdeduction = Convert.ToDouble(amount);
    //                                            otherdeduction = Math.Round(amount, 0);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        otherdeduction = 0;
    //                                        newrow["OTHER DEDUCTION"] = otherdeduction;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    otherdeduction = 0;
    //                                    newrow["OTHER DEDUCTION"] = otherdeduction;
    //                                }
    //                                tdsdeduction = 0;
    //                                if (dttdsdeduction.Rows.Count > 0)
    //                                {
    //                                    DataRow[] drr = dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                    if (drr.Length > 0)
    //                                    {
    //                                        foreach (DataRow drtdsdeduction in dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                        {
    //                                            double amount = 0;
    //                                            double.TryParse(drtdsdeduction["tdsamount"].ToString(), out amount);
    //                                            newrow["Tds DEDUCTION"] = amount.ToString();
    //                                            string st = amount.ToString();
    //                                            tdsdeduction = Convert.ToDouble(amount);
    //                                            tdsdeduction = Math.Round(amount, 0);
    //                                        }
    //                                    }
    //                                    else
    //                                    {
    //                                        tdsdeduction = 0;
    //                                        newrow["Tds DEDUCTION"] = tdsdeduction;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    tdsdeduction = 0;
    //                                    newrow["Tds DEDUCTION"] = tdsdeduction;
    //                                }
    //                                newrow["TOTAL DEDUCTIONS"] = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
    //                                totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
    //                                double netpay = 0;
    //                                netpay = Math.Round(totalearnings - totaldeduction + otamount);
    //                                netpay = Math.Round(netpay, 0);
    //                                newrow["NET PAY"] = Math.Round(netpay, 0);
    //                                Report.Rows.Add(newrow);
    //                                //total += netpay;
    //                                //netpay = 0;
    //                            }
    //                        }
    //                        DataRow newTotal = Report.NewRow();
    //                        newTotal["DESIGNATION"] = "Total";
    //                        double val = 0.0;
    //                        foreach (DataColumn dc in Report.Columns)
    //                        {
    //                            if (dc.DataType == typeof(Double))
    //                            {
    //                                val = 0.0;
    //                                double.TryParse(Report.Compute("sum([" + dc.ToString() + "])", "[" + dc.ToString() + "]<>'0'").ToString(), out val);
    //                                newTotal[dc.ToString()] = val;
    //                            }
    //                        }

    //                        Report.Rows.Add(newTotal);
    //                        string designation = "Total";

    //                        foreach (DataRow dreport in Report.Select("DESIGNATION='" + designation + "'"))
    //                        {
    //                            DataRow nr_sp = dtnew.NewRow();
    //                            nr_sp["SNO"] = k++.ToString();
    //                            nr_sp["Month"] = ddlmonth.SelectedItem.Text;
    //                            nr_sp["loacation"] = branchname;
    //                            nr_sp["Amount"] = dreport["NET PAY"].ToString();
    //                            dtnew.Rows.Add(nr_sp);
    //                        }
    //                    }


    //                    DataRow newTotal3 = dtnew.NewRow();
    //                    newTotal3["loacation"] = "Total";
    //                    double val1 = 0.0;
    //                    foreach (DataColumn dc1 in dtnew.Columns)
    //                    {

    //                        if (dc1.DataType == typeof(Double))
    //                        {
    //                            val1 = 0.0;
    //                            double.TryParse(dtnew.Compute("sum([" + dc1.ToString() + "])", "[" + dc1.ToString() + "]<>'0'").ToString(), out val1);
    //                            newTotal3[dc1.ToString()] = val1;
    //                        }

    //                    }
    //                    dtnew.Rows.Add(newTotal3);

    //                    grdReports.DataSource = dtnew;
    //                    grdReports.DataBind();
    //                    Session["xportdata"] = dtnew;
    //                    hidepanel.Visible = true;
    //                }
    //            }
    //            // }
    //            //}
    //            double totalextrapay = 0;
    //            mainbranch = Session["mainbranch"].ToString();
    //            cmd = new SqlCommand(" SELECT bankname, sno FROM bankmaster");
    //            cmd.Parameters.Add("@m", mainbranch);
    //            DataTable dtbank = vdm.SelectQuery(cmd).Tables[0];
    //            DataTable dtbanknew = new DataTable();
    //            dtbanknew.Columns.Add("SNO");
    //            dtbanknew.Columns.Add("MOnth");
    //            dtbanknew.Columns.Add("Bank Name");
    //            dtbanknew.Columns.Add("Amount1").DataType = typeof(double);
    //            if (dtbank.Rows.Count > 0)
    //            {
    //                var n = 1;
    //                foreach (DataRow dtbn in dtbank.Rows)
    //                {
    //                    Report1 = new DataTable();
    //                    Report1.Columns.Add("Location1");
    //                    Report1.Columns.Add("Employee Code1");
    //                    Report1.Columns.Add("EmployeeName");
    //                    Report1.Columns.Add("GROSS1").DataType = typeof(double);
    //                    Report1.Columns.Add("Extra Pay").DataType = typeof(double);
    //                    Report1.Columns.Add("CONVEYANCE").DataType = typeof(double);
    //                    Report1.Columns.Add("Shift Allowance").DataType = typeof(double);
    //                    Report1.Columns.Add("NET PAY1").DataType = typeof(double);
    //                    string bankid = dtbn["sno"].ToString();
    //                    string bankname = dtbn["bankname"].ToString();
    //                    cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, employedetails.fullname, employedetails.employee_num, pay_structure.erningbasic, pay_structure.travelconveyance, pay_structure.esi, pay_structure.providentfund, employedetails.fullname AS Expr2, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance, pay_structure.washingallowance, pay_structure.medicalerning, pay_structure.profitionaltax, employebankdetails.accountno, employebankdetails.ifsccode, branchmaster.branchname FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmapping ON employedetails.branchid = branchmapping.subbranch LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid LEFT OUTER JOIN branchmaster ON branchmaster.branchid = employedetails.branchid LEFT OUTER JOIN bankmaster ON bankmaster.sno = employebankdetails.bankid WHERE (branchmaster.branchtype = @branchtype) AND (employebankdetails.bankid = @bankid)  AND  (branchmapping.mainbranch = @m) AND (employedetails.status = 'No') and (employedetails.employee_type = 'Staff') ORDER BY branchmaster.branchname ");
    //                    cmd.Parameters.Add("@m", mainbranch);
    //                    cmd.Parameters.Add("@bankid", bankid);
    //                    cmd.Parameters.Add("@branchtype", ddlbranchtype.SelectedItem.Value);
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtsalary1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, monthly_attendance.extradays, employedetails.employee_num, branchmaster.fromdate,branchmaster.night_allowance,monthly_attendance.night_days, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) ");
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtattendence1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT  employedetails.employee_num, salaryadvance.amount, salaryadvance.monthofpaid, employedetails.fullname, salaryadvance.empid FROM   salaryadvance INNER JOIN  employedetails ON salaryadvance.empid = employedetails.empid where  (salaryadvance.month = @month) AND (salaryadvance.year = @year)");
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtsa1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT employedetails.employee_num, loan_request.loanemimonth, loan_request.months, loan_request.startdate FROM employedetails INNER JOIN  loan_request ON employedetails.empid = loan_request.empid where  (loan_request.month = @month) AND (loan_request.year = @year)");
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtloan1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT  employedetails.employee_num, mobile_deduction.deductionamount, employedetails.fullname, employedetails.empid FROM  mobile_deduction INNER JOIN employedetails ON mobile_deduction.employee_num = employedetails.employee_num   where  (mobile_deduction.month = @month) AND (mobile_deduction.year = @year)");
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtmobile1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT  employedetails.employee_num, canteendeductions.amount, employedetails.fullname, employedetails.empid FROM  canteendeductions INNER JOIN employedetails ON canteendeductions.employee_num = employedetails.employee_num where  (canteendeductions.month = @month) AND (canteendeductions.year = @year)");
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtcanteen1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, mediclaimdeduction.medicliamamount FROM employedetails INNER JOIN mediclaimdeduction ON employedetails.empid = mediclaimdeduction.empid");
    //                    //cmd.Parameters.Add("@month", mymonth);
    //                    //cmd.Parameters.Add("@year", str[2]);
    //                    DataTable dtmedicliam1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, otherdeduction.otherdeductionamount FROM employedetails INNER JOIN otherdeduction ON employedetails.empid = otherdeduction.empid WHERE  (otherdeduction.month = @month) AND (otherdeduction.year = @year)");
    //                    cmd.Parameters.Add("@month", mymonth);
    //                    cmd.Parameters.Add("@year", year);
    //                    DataTable dtotherdeduction1 = vdm.SelectQuery(cmd).Tables[0];
    //                    cmd = new SqlCommand("SELECT employedetails.employee_num, employedetails.fullname, employedetails.empid, tds_deduction.tdsamount FROM employedetails INNER JOIN tds_deduction ON employedetails.empid = tds_deduction.empid");
    //                    //cmd.Parameters.Add("@month", mymonth);
    //                    //cmd.Parameters.Add("@year", str[2]);
    //                    DataTable dttdsdeduction = vdm.SelectQuery(cmd).Tables[0];
    //                    if (dtsalary1.Rows.Count > 0)
    //                    {
    //                        //var i = 1;
    //                        foreach (DataRow dr in dtsalary1.Rows)
    //                        {
    //                            double otamount = 0;
    //                            double otvalue = 0;
    //                            double ptax = 0;
    //                            double totalpresentdays = 0;
    //                            double profitionaltax = 0;
    //                            double salaryadvance = 0;
    //                            double otherdeduction = 0;
    //                            double tdsdeduction = 0;
    //                            double loan = 0;
    //                            double medicliamdeduction = 0;
    //                            double canteendeduction = 0;
    //                            double mobilededuction = 0;
    //                            double totaldeduction;
    //                            double totalearnings;
    //                            double providentfund = 0;
    //                            double medicalerning = 0;
    //                            double washingallowance = 0;
    //                            double convenyance = 0;
    //                            double esi = 0;
    //                            double daysinmonth = 0;
    //                            double loseamount = 0;
    //                            double loseofconviyance = 0;
    //                            double loseofwashing = 0;
    //                            double loseofmedical = 0;
    //                            double losofprofitionaltax = 0;
    //                            DataRow newrow = Report1.NewRow();
    //                            newrow["Location1"] = dr["branchname"].ToString();
    //                            newrow["Employee Code1"] = dr["employee_num"].ToString();
    //                            newrow["EmployeeName"] = dr["fullname"].ToString();
    //                            double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
    //                            newrow["GROSS1"] = peryanam / 12;
    //                            double permonth = peryanam / 12;
    //                            double HRA = Convert.ToDouble(dr["hra"].ToString());
    //                            double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
    //                            convenyance = Convert.ToDouble(dr["conveyance"].ToString());
    //                            profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
    //                            medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
    //                            washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
    //                            double travelconveyance = 0;
    //                            double shiftamount = 0;
    //                            if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC")
    //                            {

    //                                double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
    //                                newrow["CONVEYANCE"] = travelconveyance;

    //                                //Report.Columns.Add("CONVEYANCE").DataType = typeof(double);
    //                            }
    //                            if (dtattendence1.Rows.Count > 0)
    //                            {
    //                                foreach (DataRow dra in dtattendence1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                {

    //                                    double numberofworkingdays = 0;
    //                                    double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
    //                                    double clorwo = 0;
    //                                    double.TryParse(dra["clorwo"].ToString(), out clorwo);
    //                                    daysinmonth = numberofworkingdays + clorwo;
    //                                    double paydays = 0;
    //                                    double lop = 0;
    //                                    //double otvalue = 0;
                                      
    //                                    double.TryParse(dra["lop"].ToString(), out lop);
    //                                    paydays = numberofworkingdays - lop;
    //                                    double holidays = 0;
    //                                    holidays = daysinmonth - numberofworkingdays;
    //                                    double paybledays = 0;
    //                                    paybledays = numberofworkingdays + clorwo;
    //                                    totalpresentdays = holidays + paydays;
    //                                    double totalpdays = permonth / daysinmonth;
    //                                    loseamount = lop * totalpdays;
    //                                    double perdayconveyance = convenyance / daysinmonth;
    //                                    loseofconviyance = lop * perdayconveyance;
    //                                    double perdaywashing = washingallowance / daysinmonth;
    //                                    loseofwashing = lop * perdaywashing;
    //                                    double perdaymedical = medicalerning / daysinmonth;
    //                                    loseofmedical = lop * perdaymedical;
    //                                    double perdaybasic = BASIC / daysinmonth;
    //                                    string ot = dra["extradays"].ToString();
    //                                    double perdayamt = permonth / daysinmonth;
                                       
    //                                    double perdaprofitionaltax = profitionaltax / daysinmonth;
    //                                    losofprofitionaltax = lop * perdaprofitionaltax;
    //                                    if (ddlbranchtype.SelectedItem.Text == "SalesOffice" || ddlbranchtype.SelectedItem.Text == "CC")
    //                                    {

    //                                        double nightdays = 0;
    //                                        double.TryParse(dra["night_days"].ToString(), out nightdays);
    //                                        double perdaycost = 0;
    //                                        double.TryParse(dra["night_allowance"].ToString(), out perdaycost);
    //                                        shiftamount = nightdays * perdaycost;
    //                                        shiftamount = Math.Round(shiftamount);
    //                                        newrow["Shift Allowance"] = shiftamount;

    //                                    }
    //                                    double otdays = 0;
    //                                    if (ot == "" || ot == "0")
    //                                    {
    //                                        otdays = 0;
    //                                    }
    //                                    else
    //                                    {
    //                                        otdays = Convert.ToDouble(dra["extradays"].ToString());
    //                                        otvalue = perdayamt * otdays;
    //                                        newrow["Extra Pay"] = Math.Round(otvalue);
    //                                        otamount = Math.Round(otvalue); ;
    //                                    }
    //                                }
    //                            }
    //                            double perdaysal = permonth / daysinmonth;
    //                            double basic = 50;
    //                            double basicsalary = (permonth * 50) / 100;
    //                            double basicpermonth = basicsalary / daysinmonth;
    //                            double bs = basicpermonth * totalpresentdays;
    //                            double basicsal = Math.Round(basicsalary - loseamount);
    //                            double conve = Math.Round(convenyance - loseofconviyance);
    //                            double medical = Math.Round(medicalerning - loseofmedical);
    //                            double washing = Math.Round(washingallowance - loseofwashing);
    //                            double tt = bs + conve + medical + washing;
    //                            double thra = permonth - loseamount;
    //                            double hra = Math.Round(thra - tt);
    //                            totalearnings = Math.Round(hra + tt);
    //                            double.TryParse(dr["travelconveyance"].ToString(), out travelconveyance);
    //                            double totamount = 0;
    //                            //double perdaycost = 0;
    //                            //perdaycost = travelconveyance / daysinmonth;
    //                            //totamount = totalpresentdays * perdaycost;
    //                            string pfeligible = dr["pfeligible"].ToString();
    //                            if (pfeligible == "Yes")
    //                            {
    //                                providentfund = (totalearnings * 6) / 100;
    //                                if (providentfund > 1800)
    //                                {
    //                                    providentfund = 1800;
    //                                }
    //                                providentfund = Math.Round(providentfund);
    //                            }
    //                            else
    //                            {
    //                                providentfund = 0;
    //                            }
    //                            string esieligible = dr["esieligible"].ToString();
    //                            if (esieligible == "Yes")
    //                            {
    //                                esi = (totalearnings * 1.75) / 100;
    //                                esi = Math.Round(esi);
    //                            }
    //                            else
    //                            {
    //                                esi = 0;
    //                            }
    //                            if (dtsa1.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dtsa1.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drsa in dtsa1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double amount = 0;
    //                                        double.TryParse(drsa["amount"].ToString(), out amount);
    //                                        salaryadvance = Convert.ToDouble(amount);
    //                                        salaryadvance = Math.Round(amount);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    salaryadvance = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                salaryadvance = 0;
    //                            }
    //                            if (dtloan1.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dtloan1.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drloan in dtloan1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double loanemimonth = 0;
    //                                        double.TryParse(drloan["loanemimonth"].ToString(), out loanemimonth);
    //                                        loan = Convert.ToDouble(loanemimonth);
    //                                        loan = Math.Round(loanemimonth);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    loan = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                loan = 0;
    //                            }
    //                            mobilededuction = 0;
    //                            if (dtmobile1.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dtmobile1.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drmobile in dtmobile1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double deductionamount = 0;
    //                                        double.TryParse(drmobile["deductionamount"].ToString(), out deductionamount);
    //                                        string st = deductionamount.ToString();
    //                                        if (st == "0.0")
    //                                        {
    //                                            mobilededuction = 0;
    //                                        }
    //                                        else
    //                                        {
    //                                            mobilededuction = Convert.ToDouble(deductionamount);
    //                                            mobilededuction = Math.Round(deductionamount);
    //                                        }
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    mobilededuction = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                mobilededuction = 0;
    //                            }
    //                            canteendeduction = 0;
    //                            if (dtcanteen1.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dtcanteen1.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drcanteen in dtcanteen1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double deductionamount = 0;
    //                                        double.TryParse(drcanteen["amount"].ToString(), out deductionamount);
    //                                        string st = deductionamount.ToString();
    //                                        canteendeduction = Convert.ToDouble(deductionamount);
    //                                        canteendeduction = Math.Round(deductionamount);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    canteendeduction = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                canteendeduction = 0;
    //                            }

    //                            medicliamdeduction = 0;
    //                            if (dtmedicliam1.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dtmedicliam1.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drmedicliam in dtmedicliam1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double amount = 0;
    //                                        double.TryParse(drmedicliam["medicliamamount"].ToString(), out amount);
    //                                        string st = amount.ToString();
    //                                        medicliamdeduction = Convert.ToDouble(amount);
    //                                        medicliamdeduction = Math.Round(amount, 0);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    medicliamdeduction = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                            }
    //                            otherdeduction = 0;
    //                            if (dtotherdeduction1.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dtotherdeduction1.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drotherdeduction in dtotherdeduction1.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double amount = 0;
    //                                        double.TryParse(drotherdeduction["otherdeductionamount"].ToString(), out amount);
    //                                        string st = amount.ToString();
    //                                        otherdeduction = Convert.ToDouble(amount);
    //                                        otherdeduction = Math.Round(amount, 0);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    otherdeduction = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                            }
    //                            tdsdeduction = 0;
    //                            if (dttdsdeduction.Rows.Count > 0)
    //                            {
    //                                DataRow[] drr = dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'");
    //                                if (drr.Length > 0)
    //                                {
    //                                    foreach (DataRow drtdsdeduction in dttdsdeduction.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
    //                                    {
    //                                        double amount = 0;
    //                                        double.TryParse(drtdsdeduction["tdsamount"].ToString(), out amount);
    //                                        string st = amount.ToString();
    //                                        tdsdeduction = Convert.ToDouble(amount);
    //                                        tdsdeduction = Math.Round(amount, 0);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    tdsdeduction = 0;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                tdsdeduction = 0;
    //                            }
    //                            ptax = profitionaltax - losofprofitionaltax;
    //                            totaldeduction = Math.Round(profitionaltax + canteendeduction + salaryadvance + loan + mobilededuction + providentfund + esi + medicliamdeduction + otherdeduction + tdsdeduction);
    //                            double netpay = 0;
    //                            netpay = totalearnings - totaldeduction;
    //                            netpay = Math.Round(netpay, 2);

    //                            string stramount = "0";
    //                            stramount = netpay.ToString();
    //                            if (stramount == "NaN")
    //                            {
    //                                //newrow["NET PAY1"] = netpay;
    //                                //Report1.Rows.Add(newrow);
    //                            }
    //                            else
    //                            {
    //                                //if (stramount == "NaN" || stramount == "0")
    //                                //{
    //                                newrow["NET PAY1"] = netpay;
    //                                netpay = netpay + travelconveyance + shiftamount;
    //                                double NEGATIVE = Math.Round(netpay + otvalue);
    //                                if (NEGATIVE > 0)
    //                                {
    //                                    Report1.Rows.Add(newrow);
    //                                }
    //                                else
    //                                {
    //                                    Report1.Rows.Add(newrow);
    //                                }
    //                                //}

    //                            }
    //                        }
    //                    }
    //                    DataRow newTotal1 = Report1.NewRow();
    //                    newTotal1["EmployeeName"] = "Total";
    //                    double val = 0.0;
    //                    foreach (DataColumn dc1 in Report1.Columns)
    //                    {

    //                        if (dc1.DataType == typeof(Double))
    //                        {
    //                            val = 0.0;
    //                            double.TryParse(Report1.Compute("sum([" + dc1.ToString() + "])", "[" + dc1.ToString() + "]<>'0'").ToString(), out val);
    //                            newTotal1[dc1.ToString()] = val;
    //                        }

    //                    }
    //                    Report1.Rows.Add(newTotal1);
    //                    //var n = 1;
    //                    string name = "Total";
    //                    foreach (DataRow dbreport in Report1.Select("EmployeeName='" + name + "'"))
    //                    {
    //                        DataRow nr_bank = dtbanknew.NewRow();
    //                        nr_bank["SNO"] = n++.ToString();
    //                        //string mymonth1 = mymonth("MMM");
    //                        nr_bank["MOnth"] = ddlmonth.SelectedItem.Text;
    //                        string branch = "";
    //                        nr_bank["Bank Name"] = bankname;
    //                        double temp = Convert.ToDouble(dbreport["NET PAY1"].ToString());
    //                        if (temp > 0)
    //                        {
    //                            nr_bank["Amount1"] = dbreport["NET PAY1"].ToString();
    //                            dtbanknew.Rows.Add(nr_bank);

    //                        }

    //                        //nr_bank["Amount2"] = dbreport["Extra Pay"].ToString();

    //                        //foreach (DataRow dreport in Report1.Select("EmployeeName='" + name + "'"))
    //                        //{
    //                        DataRow nr_mp = dtbanknew.NewRow();
    //                        nr_mp["MOnth"] = ddlmonth.SelectedItem.Text;
    //                        nr_mp["Bank Name"] = "Extra Pay" + " " + bankname;
    //                        double temp1 = Convert.ToDouble(dbreport["Extra Pay"].ToString());
    //                        if (temp1 > 0)
    //                        {
    //                            nr_mp["Amount1"] = dbreport["Extra Pay"].ToString();
    //                            dtbanknew.Rows.Add(nr_mp);
    //                        }

    //                        DataRow nr_conv = dtbanknew.NewRow();
    //                        nr_conv["MOnth"] = ddlmonth.SelectedItem.Text;
    //                        nr_conv["Bank Name"] = "CONVEYANCE" + " " + bankname;
    //                        double temp2 = Convert.ToDouble(dbreport["CONVEYANCE"].ToString());
    //                        if (temp2 > 0)
    //                        {
    //                            nr_conv["Amount1"] = dbreport["CONVEYANCE"].ToString();
    //                            dtbanknew.Rows.Add(nr_conv);
    //                        }

    //                        DataRow nr_nightshift = dtbanknew.NewRow();
    //                        nr_nightshift["MOnth"] = ddlmonth.SelectedItem.Text;
    //                        nr_nightshift["Bank Name"] = "Shift Allowance" + " " + bankname;
    //                        double temp3 = Convert.ToDouble(dbreport["Shift Allowance"].ToString());
    //                        if (temp3 > 0)
    //                        {
    //                            nr_nightshift["Amount1"] = dbreport["Shift Allowance"].ToString();
    //                            dtbanknew.Rows.Add(nr_nightshift);

    //                        }

    //                        //} 
    //                    }
    //                }
    //                DataRow newTotal2 = dtbanknew.NewRow();
    //                newTotal2["Bank Name"] = "Total";
    //                double val1 = 0.0;
    //                foreach (DataColumn dc1 in dtbanknew.Columns)
    //                {

    //                    if (dc1.DataType == typeof(Double))
    //                    {
    //                        val1 = 0.0;
    //                        double.TryParse(dtbanknew.Compute("sum([" + dc1.ToString() + "])", "[" + dc1.ToString() + "]<>'0'").ToString(), out val1);
    //                        newTotal2[dc1.ToString()] = val1;
    //                    }

    //                }
    //                dtbanknew.Rows.Add(newTotal2);
    //                gridBank.DataSource = dtbanknew;
    //                gridBank.DataBind();
    //                Session["xportdata"] = dtbanknew;
    //                hidepanel.Visible = true;
    //            }
    //        }
    //    }

    //    catch (Exception ex)
    //    {
    //        lblmsg.Text = ex.Message;
    //        hidepanel.Visible = false;

    //    }
    //}
    //protected void grdReports_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        if (e.Row.Cells[2].Text == "Total")
    //        {
    //            e.Row.BackColor = System.Drawing.Color.Aquamarine;
    //            e.Row.Font.Size = FontUnit.Large;
    //            e.Row.Font.Bold = true;
    //        }
    //        //if (e.Row.Cells[2].Text == "Grand Total")
    //        //{
    //        //    e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
    //        //    e.Row.Font.Size = FontUnit.Large;
    //        //    e.Row.Font.Bold = true;
    //        //}
    //    }
    //}
}