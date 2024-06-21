using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class DairyCasualSupplimentarySalary : System.Web.UI.Page
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
                    DateTime dtfrom = DateTime.Now.AddMonths(-1);
                    //dtp_FromDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //lblAddress.Text = Session["Address"].ToString();
                    //lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
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

    private void bindbranchs()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT branchid, branchname,company_code FROM branchmaster where branchmaster.company_code='2' ");
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
            string year = (mydate.Year).ToString();
            string mymonth = ddlmonth.SelectedItem.Value;
            string day = (mydate.Day).ToString();
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            lblHeading.Text = ddlbranch.SelectedItem.Text + " PF Statement Report" + ddlmonth.SelectedItem.Text + year;
            //string[] datestrig = dtp_FromDate.Text.Split(' ');
            //if (datestrig.Length > 1)
            //{
            //    if (datestrig[0].Split('-').Length > 0)
            //    {
            //        string[] dates = datestrig[0].Split('-');
            //        string[] times = datestrig[1].Split(':');
            //        fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
            //    }
            //}
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            string[] str = frmdate.Split('/');
            lblFromDate.Text = mymonth;
            fromdate = Convert.ToDateTime(date);
            Session["filename"] = ddlbranch.SelectedItem.Text + " PF Statement Report" + ddlmonth.SelectedItem.Text + year;
            Session["title"] = ddlbranch.SelectedItem.Text + " PF Statement Report " + ddlmonth.SelectedItem.Text + year;
            Report.Columns.Add("SNO");
            Report.Columns.Add("Employeeid");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Name");
            Report.Columns.Add("DESIGNATION");
            Report.Columns.Add("GROSS").DataType = typeof(double);
            Report.Columns.Add("DAYS MONTH").DataType = typeof(double);
            Report.Columns.Add("EMP Effective Workdays").DataType = typeof(double);
            //Report.Columns.Add("CL HOLIDAY AND OFF").DataType = typeof(double);
            //Report.Columns.Add("Payable Days").DataType = typeof(double);
            Report.Columns.Add("BASIC").DataType = typeof(double);
            Report.Columns.Add("HRA").DataType = typeof(double);
            Report.Columns.Add("CONVEYANCE ALLOWANCE").DataType = typeof(double);
            Report.Columns.Add("WASHING ALLOWANCE").DataType = typeof(double);
            Report.Columns.Add("MEDICAL ALLOWANCE").DataType = typeof(double);
            Report.Columns.Add("GROSS Earnings").DataType = typeof(double);
            //Report.Columns.Add("PT").DataType = typeof(double);
            Report.Columns.Add("PF").DataType = typeof(double);
            //Report.Columns.Add("ESI").DataType = typeof(double);
            Report.Columns.Add("SALARY ADVANCE").DataType = typeof(double);
            Report.Columns.Add("Loan").DataType = typeof(double);
            Report.Columns.Add("CANTEEN DEDUCTION").DataType = typeof(double);
            Report.Columns.Add("MOBILE DEDUCTION").DataType = typeof(double);
            Report.Columns.Add("TOTAL DEDUCTIONS").DataType = typeof(double);
            Report.Columns.Add("NET PAY").DataType = typeof(double);
            Report.Columns.Add("Bank Acc NO");
            Report.Columns.Add("IFSC Code");
            int branchid = Convert.ToInt32(ddlbranch.SelectedItem.Value);
            cmd = new SqlCommand("SELECT company_master.address, company_master.companyname FROM branchmaster INNER JOIN company_master ON branchmaster.company_code = company_master.sno WHERE (branchmaster.branchid = @BranchID)");
            cmd.Parameters.Add("@BranchID", ddlbranch.SelectedValue);
            DataTable dtcompany = vdm.SelectQuery(cmd).Tables[0];
            if (dtcompany.Rows.Count > 0)
            {
                lblAddress.Text = dtcompany.Rows[0]["address"].ToString();
                lblTitle.Text = dtcompany.Rows[0]["companyname"].ToString();
            }
            else
            {
                lblAddress.Text = Session["Address"].ToString();
                lblTitle.Text = Session["TitleName"].ToString();
            }
            cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.empid,employedetails.employee_num, pay_structure.providentfund, pay_structure.erningbasic,  employedetails.fullname, monthly_attendance.month, monthly_attendance.year, designation.designation, pay_structure.salaryperyear, pay_structure.hra, pay_structure.conveyance,  pay_structure.washingallowance, pay_structure.medicalerning, employebankdetails.accountno, employebankdetails.ifsccode FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN  monthly_attendance ON employedetails.empid = monthly_attendance.empid LEFT OUTER JOIN employebankdetails ON employedetails.empid = employebankdetails.employeid WHERE employedetails.branchid=@branchid  AND (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.employee_type='Staff')");
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", str[2]);
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
                    double totalearnings;
                    double providentfund = 0;
                    double medicalerning = 0;
                    double washingallowance = 0;
                    double convenyance = 0;
                    double esi = 0;
                    int daysinmonth = 0;
                    double loseamount = 0;
                    double loseofconviyance = 0;
                    double loseofwashing = 0;
                    double loseofmedical = 0;
                    DataRow newrow = Report.NewRow();
                    newrow["SNO"] = i++.ToString();
                    newrow["Employeeid"] = dr["empid"].ToString();
                    newrow["Employee Code"] = dr["employee_num"].ToString();
                    newrow["Name"] = dr["fullname"].ToString();
                    newrow["DESIGNATION"] = dr["designation"].ToString();
                    double peryanam = Convert.ToDouble(dr["salaryperyear"].ToString());
                    newrow["GROSS"] = peryanam / 12;
                    double permonth = peryanam / 12;
                    double HRA = Convert.ToDouble(dr["hra"].ToString());
                    double BASIC = Convert.ToDouble(dr["erningbasic"].ToString());
                    convenyance = Convert.ToDouble(dr["conveyance"].ToString());
                    //profitionaltax = Convert.ToDouble(dr["profitionaltax"].ToString());
                    medicalerning = Convert.ToDouble(dr["medicalerning"].ToString());
                    washingallowance = Convert.ToDouble(dr["washingallowance"].ToString());
                    newrow["Bank Acc NO"] = dr["accountno"].ToString();
                    newrow["IFSC Code"] = dr["ifsccode"].ToString();
                    Report.Rows.Add(newrow);
                    if (dtattendence.Rows.Count > 0)
                    {
                        foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                        {
                            string from = dra["fromdate"].ToString();
                            string to = dra["todate"].ToString();
                            int month = 0;
                            int.TryParse(mymonth, out month);
                            month = month - 1;
                            string strfromdate = month + "/" + from + "/" + str[2];
                            string strtodate = mymonth + "/" + to + "/" + str[2];
                            DateTime dtfromdate = Convert.ToDateTime(strfromdate);
                            DateTime dttodate = Convert.ToDateTime(strtodate);
                            TimeSpan days;
                            days = dttodate - dtfromdate;
                            daysinmonth = Convert.ToInt32(days.TotalDays);
                            newrow["DAYS MONTH"] = daysinmonth.ToString();
                            double numberofworkingdays = 0;
                            double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                            double paydays = 0;
                            double lop = 0;
                            double.TryParse(dra["lop"].ToString(), out lop);
                            paydays = numberofworkingdays - lop;
                            newrow["EMP Effective Workdays"] = paydays.ToString();
                            double holidays = 0;
                            holidays = daysinmonth - numberofworkingdays;
                            double clorwo = 0;
                            double.TryParse(dra["clorwo"].ToString(), out clorwo);
                            //paydays = daysinmonth - lop;
                            //newrow["Payable Days"] = paydays + clorwo;
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
                    if (pfeligible == "Yes")
                    {
                        providentfund = (totalearnings * 6) / 100;
                        if (providentfund > 1800)
                        {
                            providentfund = 1800;
                        }
                        providentfund = Math.Ceiling(providentfund);
                        newrow["PF"] = providentfund;
                    }
                    else
                    {
                        providentfund = 0;
                        newrow["PF"] = providentfund;
                    }
                    //string esieligible = dr["esieligible"].ToString();
                    //if (esieligible == "Yes")
                    //{
                    //    esi = (totalearnings * 1.75) / 100;
                    //    esi = Math.Ceiling(esi);
                    //    newrow["ESI"] = esi;
                    //}
                    //else
                    //{
                    //    esi = 0;
                    //    newrow["ESI"] = esi;
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
                                salaryadvance = Math.Ceiling(amount);
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
                                loan = Math.Ceiling(loanemimonth);
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
                    else
                    {
                        mobilededuction = 0;
                        newrow["MOBILE DEDUCTION"] = mobilededuction;
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
                                newrow["CANTEEN DEDUCTION"] = deductionamount.ToString();
                                string st = deductionamount.ToString();
                                canteendeduction = Convert.ToDouble(deductionamount);
                                canteendeduction = Math.Ceiling(deductionamount);
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
                    newrow["TOTAL DEDUCTIONS"] = canteendeduction + salaryadvance + loan + mobilededuction + providentfund;
                    totaldeduction = canteendeduction + salaryadvance + loan + mobilededuction + providentfund;
                    double netpay = 0;
                    netpay = totalearnings - totaldeduction;
                    netpay = Math.Round(netpay, 2);
                    newrow["NET PAY"] = netpay;
                }

            }
            else
            {
                lblmsg.Text = "No data were found";
                hidepanel.Visible = false;
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
                    newTotal[dc.ToString()] = val;
                }
            }
            Report.Rows.Add(newTotal);
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
            if (e.Row.Cells[4].Text == "Total")
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
}