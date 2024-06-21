﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class esireport : System.Web.UI.Page
{
    SqlCommand cmd;
    string userid = "";
    DBManager vdm;
    double profitionaltax = 0;
    double salaryadvance = 0;
    double loan = 0;
    double canteendeduction = 0;
    double mobilededuction = 0;
    double totaldeduction;
    double totalearnings;
    double providentfund = 0;
    double netpay = 0;
    double medicalerning = 0;
    double washingallowance = 0;
    double convenyance = 0;
    double esi = 0;

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
        ddlbranch.Items.Insert(0, new ListItem { Value = "0", Text = "Select Branch", Selected = true });
        ddlbranch.SelectedValue = "0";
    }
    private void bindemployeetype()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT employee_type FROM employedetails   where (employee_type<>'')  GROUP BY employedetails.employee_type");
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlemptype.DataSource = dttrips;
        ddlemptype.DataTextField = "employee_type";
        ddlemptype.DataValueField = "employee_type";
        ddlemptype.DataBind();
        ddlemptype.ClearSelection();
        ddlemptype.Items.Insert(0, new ListItem { Value = "0", Text = "Select Type", Selected = true });
        ddlemptype.SelectedValue = "0";
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
            string d = "00";
            string date = mymonth + "/" + day + "/" + year;
            lblFromDate.Text = mymonth;
            string mainbranch = Session["mainbranch"].ToString();
            //fromdate = Convert.ToDateTime(date);
            DateTime dtfrom = fromdate;
            string frmdate = dtfrom.ToString("dd/MM/yyyy");
            //Report.Columns.Add("Sno");
            if (ddlbranch.SelectedItem.Text == "Select Branch")
            {
                lblHeading.Text = " ESI Salary Statement" + ddlmonth.SelectedItem.Text + year;
                Session["filename"] =" ESI Salary Statement " + ddlmonth.SelectedItem.Text + year;
                Session["title"] = " ESI Salary Statement " + ddlmonth.SelectedItem.Text + year;
            }
            else
            {
                lblHeading.Text = ddlbranch.SelectedItem.Text + " " + " ESI Salary Statement" + ddlmonth.SelectedItem.Text + year;
                Session["filename"] = ddlbranch.SelectedItem.Text + " " + " ESI Salary Statement " + ddlmonth.SelectedItem.Text + year;
                Session["title"] = ddlbranch.SelectedItem.Text + " " + " ESI Salary Statement " + ddlmonth.SelectedItem.Text + year;
            }
           
            Report.Columns.Add("Location");
            Report.Columns.Add("Sno");
            Report.Columns.Add("Employee Code");
            Report.Columns.Add("Insurance No");
            Report.Columns.Add("Name Of Insured Person");
            Report.Columns.Add("Gross").DataType = typeof(double);
            Report.Columns.Add("Employee's Contribution").DataType = typeof(double);
            Report.Columns.Add("Employer's Contribution").DataType = typeof(double);
            Report.Columns.Add("Total").DataType = typeof(double);
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
            if (branchid != 0)
            {
                //NASI CHAGE code 32
                //paystruter
                //cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.esieligible, employedetails.empid, branchmaster.branchname, employedetails.employee_num, employepfdetails.estnumber, employedetails.fullname, designation.designation, pay_structure.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN pay_structure ON employedetails.empid = pay_structure.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid LEFT OUTER JOIN employepfdetails ON employepfdetails.employeid = employedetails.empid WHERE (employedetails.branchid = @branchid) AND (employedetails.esieligible = 'Yes') AND (employedetails.status = 'No')");
                cmd = new SqlCommand("SELECT employedetails.pfeligible, employedetails.gender,employedetails.esieligible, employedetails.empid, branchmaster.branchname, employedetails.employee_num,employepfdetails.estnumber, employedetails.fullname, designation.designation, salaryappraisals.gross, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid LEFT OUTER JOIN employepfdetails ON employepfdetails.employeid = employedetails.empid WHERE (employedetails.branchid = @branchid) AND (employedetails.employee_type = @employee_type) AND (employedetails.esieligible = 'Yes') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.branchid = @branchid) AND (employedetails.employee_type = @employee_type) AND (employedetails.esieligible = 'Yes') AND (employedetails.status = 'No') AND (salaryappraisals.endingdate > @d1) AND  (salaryappraisals.startingdate <= @d1)");
            }
            else
            {
                cmd = new SqlCommand("SELECT  employedetails.pfeligible, employedetails.gender,employedetails.esieligible, employedetails.empid, branchmaster.branchname, employedetails.employee_num,employepfdetails.estnumber, employedetails.fullname, designation.designation, salaryappraisals.gross, salaryappraisals.salaryperyear FROM employedetails INNER JOIN designation ON employedetails.designationid = designation.designationid LEFT OUTER JOIN employepfdetails ON employepfdetails.employeid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid INNER JOIN branchmapping ON branchmapping.subbranch = branchmaster.branchid INNER JOIN salaryappraisals ON employedetails.empid = salaryappraisals.empid WHERE (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (employedetails.esieligible = 'Yes') AND (branchmapping.mainbranch = @mainbranch) AND (salaryappraisals.endingdate IS NULL) AND (salaryappraisals.startingdate <= @d1) OR (employedetails.status = 'No') AND (employedetails.employee_type = @employee_type) AND (employedetails.esieligible = 'Yes') AND (branchmapping.mainbranch = @mainbranch) AND (salaryappraisals.endingdate > @d1) AND (salaryappraisals.startingdate <= @d1) ORDER BY branchmaster.branchname");
                cmd.Parameters.Add("@mainbranch", mainbranch);
            }
            cmd.Parameters.Add("@branchid", branchid);
            cmd.Parameters.Add("@employee_type", ddlemptype.SelectedItem.Text);
            cmd.Parameters.Add("@d1", date);
            DataTable dtsalary = vdm.SelectQuery(cmd).Tables[0];
            string[] str = frmdate.Split('/');
            cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid, monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year,monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays, employedetails.status FROM  monthly_attendance INNER JOIN employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE (monthly_attendance.month = @month) AND (monthly_attendance.year = @year) AND (employedetails.status = 'No')");
            //cmd = new SqlCommand("SELECT monthly_attendance.sno, monthly_attendance.empid,monthly_attendance.clorwo, monthly_attendance.doe, monthly_attendance.month, monthly_attendance.year, monthly_attendance.otdays, employedetails.employee_num, branchmaster.fromdate, branchmaster.todate, monthly_attendance.lop, branchmaster.branchid, monthly_attendance.numberofworkingdays FROM  monthly_attendance INNER JOIN  employedetails ON monthly_attendance.empid = employedetails.empid INNER JOIN branchmaster ON employedetails.branchid = branchmaster.branchid WHERE  (monthly_attendance.month = @month) AND (monthly_attendance.year = @year)");
            cmd.Parameters.Add("@month", mymonth);
            cmd.Parameters.Add("@year", year);
            DataTable dtattendence = vdm.SelectQuery(cmd).Tables[0];
            if (dtsalary.Rows.Count > 0)
            {
                string prevbranchname = "";
                var i = 1;
                int count = 1;
                int rowcount = 1;
                double totalvalue = 0;
                double totearnings = 0;
                double esitotal = 0;
                double totalemployers = 0;
                double grandtotemployers = 0;
                double grandtotesitotal = 0;
                double grandtotearnings = 0;
                double grandtotalvalue = 0;
                double rate = 0;
                double paydays = 0;
                double bonusamount = 0;
                foreach (DataRow dr in dtsalary.Rows)
                {
                    double employers = 0;
                    double totalpresentdays = 0;
                    double totalearnings;
                    double medicalerning = 0;
                    double washingallowance = 0;
                    double convenyance = 0;
                    double esi = 0;
                    double daysinmonth = 0;
                    double loseamount = 0;
                    double loseofwashing = 0;

                    DataRow newrow = Report.NewRow();
                    newrow["Sno"] = i++.ToString();
                    string presbranchname = dr["branchname"].ToString();
                    double loseofmedical = 0;
                    double loseofconviyance = 0;
                    double grosssal = Convert.ToDouble(dr["salaryperyear"].ToString());
                    double permonth = grosssal / 12;
                    if (presbranchname == prevbranchname)
                    {
                        if (permonth < 15000)
                        {
                            if (dtattendence.Rows.Count > 0)
                            {
                                foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double numberofworkingdays = 0;
                                    double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                    double clorwo = 0;
                                    double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                    daysinmonth = numberofworkingdays + clorwo;
                                    double lop = 0;
                                    double.TryParse(dra["lop"].ToString(), out lop);
                                    paydays = numberofworkingdays - lop;
                                    double holidays = 0;
                                    holidays = daysinmonth - numberofworkingdays;
                                    totalpresentdays = holidays + paydays;
                                    double totalpdays = permonth / daysinmonth;
                                    loseamount = lop * totalpdays;
                                    double perdayconveyance = convenyance / daysinmonth;
                                    loseofconviyance = lop * perdayconveyance;
                                    double perdaywashing = washingallowance / daysinmonth;
                                    loseofwashing = lop * perdaywashing;
                                    double perdaymedical = medicalerning / daysinmonth;
                                    loseofmedical = lop * perdaymedical;
                                }
                            }
                            double perdaysal = permonth / daysinmonth;
                            double basicsalary = (permonth * 50) / 100;
                            double basicpermonth = basicsalary / daysinmonth;
                            double bs = basicpermonth * totalpresentdays;
                            double basicsal = basicsalary - loseamount;
                            double conve = convenyance - loseofconviyance;
                            double medical = medicalerning - loseofmedical;
                            double washing = washingallowance - loseofwashing;
                            double tt = bs + conve + medical + washing;
                            double thra = permonth - loseamount;
                            double hra = thra - tt;

                            string esieligible = dr["esieligible"].ToString();
                            if (ddlemptype.SelectedItem.Text == "Casual worker")
                            {

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
                                }
                                else
                                {
                                    rate = gr;
                                }
                                bonusamount = rate * paydays + amount;
                                if (ddlemptype.SelectedItem.Text == "Casual worker")
                                {

                                    totalearnings = Math.Round(bonusamount);
                                }
                                else
                                {
                                    totalearnings = Math.Round(hra + tt);
                                }
                                if (esieligible == "Yes")
                                {
                                    if (mainbranch == "6")
                                    {
                                        esi = (totalearnings * 3) / 100;
                                        esi = Math.Round(esi);
                                        esitotal += esi;
                                        newrow["Employee's Contribution"] = esi;
                                        employers = (totalearnings * 1) / 100;
                                        employers = Math.Round(employers);
                                        totalemployers += Math.Round(employers);
                                        newrow["Employer's Contribution"] = Math.Round(employers);
                                    }
                                    else
                                    {
                                        if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048")
                                        {
                                            if (ddlbranch.SelectedItem.Value == "1043")
                                            {
                                                double esiamount = rate * 5;
                                                esi = (totalearnings * 4.75) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (totalearnings * 1.75) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);
                                            }
                                            if (ddlbranch.SelectedItem.Value == "1049")
                                            {
                                                double esiamount = rate * 5;
                                                esi = (totalearnings * 4.75) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (totalearnings * 1.75) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);
                                            }
                                            if (ddlbranch.SelectedItem.Value == "1048")
                                            {
                                                double esiamount = rate * 5;
                                                esi = (totalearnings * 4.75) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (totalearnings * 1.75) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);
                                            }

                                        }
                                        else
                                        {
                                            if (ddlbranch.SelectedItem.Value == "1044")
                                            {
                                                double esiamount = rate * 4;
                                                esi = (totalearnings * 3) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (totalearnings * 1) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);

                                            }
                                            if (ddlbranch.SelectedItem.Value == "43")
                                            {
                                                double esiamount = rate * 12;
                                                esi = (totalearnings * 3) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (totalearnings * 1) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);

                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    esitotal += esi;
                                    totalemployers += employers;
                                    newrow["Employee's Contribution"] = esi;
                                    newrow["Employer's Contribution"] = employers;
                                }
                            }


                            else
                            {
                                if (ddlemptype.SelectedItem.Text == "Casual worker")
                                {

                                    totalearnings = Math.Round(bonusamount);
                                }
                                else
                                {
                                    totalearnings = Math.Round(hra + tt);
                                }

                                if (mainbranch == "6")
                                {
                                    if (esieligible == "Yes")
                                    {
                                        esi = (totalearnings * 1.75) / 100;
                                        esi = Math.Round(esi);
                                        esitotal += esi;
                                        newrow["Employee's Contribution"] = esi;
                                        employers = (totalearnings * 4.75) / 100;
                                        employers = Math.Round(employers);
                                        totalemployers += Math.Round(employers);
                                        newrow["Employer's Contribution"] = Math.Round(employers);
                                    }
                                    else
                                    {
                                        esitotal += esi;
                                        totalemployers += employers;
                                        newrow["Employee's Contribution"] = esi;
                                        newrow["Employer's Contribution"] = employers;
                                    }
                                }
                                else
                                {
                                    if (esieligible == "Yes")
                                    {
                                        esi = (totalearnings * 3) / 100;
                                        esi = Math.Round(esi);
                                        esitotal += esi;
                                        newrow["Employer's Contribution"] = esi;
                                        employers = (totalearnings * 1) / 100;
                                        employers = Math.Round(employers);
                                        totalemployers += Math.Round(employers);
                                        newrow["Employee's Contribution"] = Math.Round(employers);
                                    }
                                    else
                                    {
                                        esitotal += esi;
                                        totalemployers += employers;
                                        newrow["Employee's Contribution"] = esi;
                                        newrow["Employer's Contribution"] = employers;
                                    }
                                }
                            }
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["Insurance No"] = dr["estnumber"].ToString();
                            newrow["Name Of Insured Person"] = dr["fullname"].ToString();
                            newrow["Gross"] = Math.Round(totalearnings, 0);
                            totearnings += totalearnings;
                            double total = esi + employers;
                            newrow["Total"] = Math.Round(total);
                            totalvalue += Math.Round(total);
                            if (totalearnings > 0)
                            {
                                Report.Rows.Add(newrow);
                            }
                            rowcount++;
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtsalary.Select("branchname='" + presbranchname + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dtinsalary = dtin.Rows.Count;
                            if (dtinsalary == rowcount)
                            {
                                DataRow newrow1 = Report.NewRow();
                                rowcount = 1;
                                total = Math.Ceiling(esi + employers);
                                newrow1["Employee's Contribution"] = Math.Round(esitotal, 0);
                                newrow1["Employer's Contribution"] = Math.Round(totalemployers, 0);
                                newrow1["Gross"] = totearnings;
                                grandtotearnings += totearnings;
                                grandtotemployers += totalemployers;
                                grandtotesitotal += esitotal;
                                newrow1["Name Of Insured Person"] = "Total";
                                newrow1["Total"] = Math.Round(totalvalue);
                                grandtotalvalue += Math.Round(totalvalue);
                                Report.Rows.Add(newrow1);
                                totalemployers = 0;
                                esitotal = 0;
                                total = 0;
                                totearnings = 0;
                                totalvalue = 0;
                            }
                        }
                    }
                    else
                    {
                        prevbranchname = presbranchname;
                        newrow["Location"] = dr["branchname"].ToString();
                        if (permonth < 15000)
                        {
                            if (dtattendence.Rows.Count > 0)
                            {
                                foreach (DataRow dra in dtattendence.Select("employee_num='" + dr["employee_num"].ToString() + "'"))
                                {
                                    double numberofworkingdays = 0;
                                    double.TryParse(dra["numberofworkingdays"].ToString(), out numberofworkingdays);
                                    double clorwo = 0;
                                    double.TryParse(dra["clorwo"].ToString(), out clorwo);
                                    daysinmonth = numberofworkingdays + clorwo;
                                    double lop = 0;
                                    double.TryParse(dra["lop"].ToString(), out lop);
                                    paydays = numberofworkingdays - lop;
                                    double holidays = 0;
                                    holidays = daysinmonth - numberofworkingdays;
                                    totalpresentdays = holidays + paydays;
                                    double totalpdays = permonth / daysinmonth;
                                    loseamount = lop * totalpdays;
                                    double perdayconveyance = convenyance / daysinmonth;
                                    loseofconviyance = lop * perdayconveyance;
                                    double perdaywashing = washingallowance / daysinmonth;
                                    loseofwashing = lop * perdaywashing;
                                    double perdaymedical = medicalerning / daysinmonth;
                                    loseofmedical = lop * perdaymedical;
                                }
                            }
                            double perdaysal = permonth / daysinmonth;
                            double basicsalary = (permonth * 50) / 100;
                            double basicpermonth = basicsalary / daysinmonth;
                            double bs = basicpermonth * totalpresentdays;
                            double basicsal = (basicsalary - loseamount);
                            double conve = convenyance - loseofconviyance;
                            double medical = medicalerning - loseofmedical;
                            double washing = washingallowance - loseofwashing;
                            double tt = bs + conve + medical + washing;
                            double thra = permonth - loseamount;
                            double hra = thra - tt;

                            string esieligible = dr["esieligible"].ToString();

                            if (ddlemptype.SelectedItem.Text == "Casual worker")
                            {

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
                                }
                                else
                                {
                                    rate = gr;
                                }
                                bonusamount = rate * paydays + amount;
                                if (ddlemptype.SelectedItem.Text == "Casual worker")
                                {

                                    totalearnings = Math.Round(bonusamount);
                                }
                                else
                                {
                                    totalearnings = Math.Round(hra + tt);
                                }
                                if (esieligible == "Yes")
                                {
                                    if (mainbranch == "6")
                                    {
                                        esi = (totalearnings * 3) / 100;
                                        esi = Math.Round(esi);
                                        esitotal += esi;
                                        newrow["Employee's Contribution"] = esi;
                                        employers = (totalearnings * 1) / 100;
                                        employers = Math.Round(employers);
                                        totalemployers += Math.Round(employers);
                                        newrow["Employer's Contribution"] = Math.Round(employers);
                                    }
                                    else
                                    {
                                        if (ddlbranch.SelectedItem.Value == "1043" || ddlbranch.SelectedItem.Value == "1049" || ddlbranch.SelectedItem.Value == "1048")
                                        {
                                            if (ddlbranch.SelectedItem.Value == "1043")
                                            {
                                                double esiamount = rate * 5;
                                                esi = (esiamount * 4.75) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (esiamount * 1.75) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);
                                            }
                                            if (ddlbranch.SelectedItem.Value == "1049")
                                            {
                                                double esiamount = rate * 5;
                                                esi = (esiamount * 4.75) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (esiamount * 1.75) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);
                                            }
                                            if (ddlbranch.SelectedItem.Value == "1048")
                                            {
                                                double esiamount = rate * 5;
                                                esi = (esiamount * 4.75) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (esiamount * 1.75) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);
                                            }

                                        }
                                        else
                                        {
                                            if (ddlbranch.SelectedItem.Value == "1044")
                                            {
                                                double esiamount = rate * 4;
                                                esi = (esiamount * 3) / 100;
                                                esi = Math.Round(esi);
                                                esitotal += esi;
                                                newrow["Employee's Contribution"] = esi;
                                                employers = (esiamount * 1) / 100;
                                                employers = Math.Round(employers);
                                                totalemployers += Math.Round(employers);
                                                newrow["Employer's Contribution"] = Math.Round(employers);

                                            }
                                            if (ddlbranch.SelectedItem.Value == "43")
                                            {

                                                newrow["Employee's Contribution"] = "0";

                                                newrow["Employer's Contribution"] = "0";

                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    // esi = 0;
                                    esitotal += esi;
                                    totalemployers += employers;
                                    newrow["Employee's Contribution"] = esi;
                                    newrow["Employer's Contribution"] = employers;
                                }
                            }
                            else
                            {
                                if (ddlemptype.SelectedItem.Text == "Casual worker")
                                {

                                    totalearnings = Math.Round(bonusamount);
                                }
                                else
                                {
                                    totalearnings = Math.Round(hra + tt);
                                }
                                if (mainbranch == "6")
                                {
                                    if (esieligible == "Yes")
                                    {
                                        esi = (totalearnings * 1.75) / 100;
                                        esi = Math.Round(esi);
                                        esitotal += esi;
                                        newrow["Employee's Contribution"] = esi;
                                        employers = (totalearnings * 4.75) / 100;
                                        employers = Math.Round(employers);
                                        totalemployers += Math.Round(employers);
                                        newrow["Employer's Contribution"] = Math.Round(employers);
                                    }
                                    else
                                    {
                                        // esi = 0;
                                        esitotal += esi;
                                        totalemployers += employers;
                                        newrow["Employee's Contribution"] = esi;
                                        newrow["Employer's Contribution"] = employers;
                                    }
                                }
                                else
                                {
                                    if (esieligible == "Yes")
                                    {
                                        esi = (totalearnings * 3) / 100;
                                        esi = Math.Round(esi);
                                        esitotal += esi;
                                        newrow["Employer's Contribution"] = esi;
                                        employers = (totalearnings * 1) / 100;
                                        employers = Math.Round(employers);
                                        totalemployers += Math.Round(employers);
                                        newrow["Employee's Contribution"] = Math.Round(employers);
                                    }
                                    else
                                    {
                                        // esi = 0;
                                        esitotal += esi;
                                        totalemployers += employers;
                                        newrow["Employee's Contribution"] = esi;
                                        newrow["Employer's Contribution"] = employers;
                                    }
                                }
                            }
                            newrow["Employee Code"] = dr["employee_num"].ToString();
                            newrow["Insurance No"] = dr["estnumber"].ToString();
                            newrow["Name Of Insured Person"] = dr["fullname"].ToString();
                            newrow["Gross"] = totalearnings;
                            totearnings += totalearnings;
                            double total = esi + employers;
                            newrow["Total"] = Math.Round(total, 0);
                            totalvalue += total;
                            Report.Rows.Add(newrow);
                            DataTable dtin = new DataTable();
                            DataRow[] drr = dtsalary.Select("branchname='" + presbranchname + "'");
                            if (drr.Length > 0)
                            {
                                dtin = drr.CopyToDataTable();
                            }
                            int dtinsalary = dtin.Rows.Count;
                            if (dtinsalary > 1)
                            {
                                //rowcount++;
                            }
                            else  //if (dtinsalary == rowcount)
                            {
                                DataRow newrow1 = Report.NewRow();
                                rowcount = 1;
                                total = esi + employers;
                                newrow1["Employee's Contribution"] = Math.Round(esitotal, 0);
                                newrow1["Employer's Contribution"] = Math.Round(totalemployers, 0);
                                newrow1["Gross"] = Math.Round(totearnings, 0);
                                grandtotearnings += Math.Round(totearnings, 0);
                                grandtotesitotal += Math.Round(esitotal, 0);
                                grandtotemployers += Math.Round(totalemployers, 0);
                                newrow1["Name Of Insured Person"] = "Total";
                                newrow1["Total"] = Math.Round(totalvalue, 0);
                                grandtotalvalue += Math.Round(totalvalue, 0);
                                if (totearnings > 0)
                                {
                                    Report.Rows.Add(newrow1);
                                }
                                totalemployers = 0;
                                esitotal = 0;
                                total = 0;
                                totearnings = 0;
                                totalvalue = 0;
                            }
                        }
                    }
                }
                DataRow newTotal = Report.NewRow();
                newTotal["Name Of Insured Person"] = "Grand Total";
                newTotal["Total"] = Math.Round(grandtotalvalue, 0);
                newTotal["Employee's Contribution"] = Math.Round(grandtotesitotal, 0);
                newTotal["Employer's Contribution"] = Math.Round(grandtotemployers, 0);
                newTotal["Gross"] = Math.Round(grandtotearnings, 0);
                Report.Rows.Add(newTotal);
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
            else
            {
                lblmsg.Text = "No data were found";
                hidepanel.Visible = false;
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            hidepanel.Visible = false;
        }
    }
    protected void gvMenu_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Location");
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
            if (e.Row.Cells[4].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
            if (e.Row.Cells[4].Text == "Grand Total")
            {
                e.Row.BackColor = System.Drawing.Color.DeepSkyBlue;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}