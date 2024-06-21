using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Leave_management : System.Web.UI.Page
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
                    DateTime dtfrom = DateTime.Now;
                    DateTime dtyear = DateTime.Now.AddYears(-1);
                    txtFromdate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    txtTodate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    //dtp_Todate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm");
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                    bindbranchs();
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
              lblHeading.Text = " Leave Report ";
              DataTable dtDriver = new DataTable();
              Session["title"] = " Leave Report";
              Session["filename"] = " Leave Report ";
              DateTime todate = DateTime.Now;
              DateTime fromdate = DateTime.Now;
              string[] datestrig = txtFromdate.Text.Split(' ');
              if (datestrig.Length > 1)
              {
                  if (datestrig[0].Split('-').Length > 0)
                  {
                      string[] dates = datestrig[0].Split('-');
                      string[] times = datestrig[1].Split(':');
                      fromdate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                  }
              }
              datestrig = txtTodate.Text.Split(' ');
              if (datestrig.Length > 1)
              {
                  if (datestrig[0].Split('-').Length > 0)
                  {
                      string[] dates = datestrig[0].Split('-');
                      string[] times = datestrig[1].Split(':');
                      todate = new DateTime(int.Parse(dates[2]), int.Parse(dates[1]), int.Parse(dates[0]), int.Parse(times[0]), int.Parse(times[1]), 0);
                  }
              }
              lblFromDate.Text = fromdate.ToString("dd/MMM/yyyy");
              lbltodate.Text = todate.ToString("dd/MMM/yyyy");
              string mainbranch = Session["mainbranch"].ToString();
              Report.Columns.Add("Sno");
              Report.Columns.Add("Employe Name");
              Report.Columns.Add("Phone Number");
              Report.Columns.Add("Status");
              Report.Columns.Add("From Date");
              Report.Columns.Add("To Date");
              Report.Columns.Add("To Days");
              Report.Columns.Add("Aprrove By");
              string leveltype = Session["leveltype"].ToString();
              if (leveltype == "user")
              {
                  cmd = new SqlCommand("SELECT la.leaveapplicationid, la.employee_no, la.remarks, la.leave_description, la.request_to, la.request_date, la.leave_from_dt, la.leave_to_dt, la.leave_satus, la.employee_no AS Expr1, la.aproved_by, la.operated_by, la.leave_type_id, la.mobile_number, la.leave_days, ed.fullname, lt.leavetypecode, et.fullname AS approvedby, lt.leavetype FROM  leave_application AS la INNER JOIN leavetypes AS lt ON la.leave_type_id = lt.leavetypeid INNER JOIN employedetails AS et ON et.empid = la.request_to INNER JOIN employedetails AS ed ON la.employee_no = ed.empid INNER JOIN branchmapping ON et.branchid = branchmapping.subbranch INNER JOIN branchmaster ON ed.branchid = branchmaster.branchid WHERE (et.status = 'No') AND (branchmapping.mainbranch = @m) AND (la.request_date BETWEEN @d1 AND @d2) AND (ed.branchid = @b) AND et.empid=@EmpID");
                  cmd.Parameters.Add("@EmpID", Session["empid"].ToString());
              }
              else
              {
                  cmd = new SqlCommand("SELECT la.leaveapplicationid, la.employee_no, la.remarks, la.leave_description, la.request_to, la.request_date, la.leave_from_dt, la.leave_to_dt, la.leave_satus, la.employee_no AS Expr1, la.aproved_by, la.operated_by, la.leave_type_id, la.mobile_number, la.leave_days, ed.fullname, lt.leavetypecode, et.fullname AS approvedby, lt.leavetype FROM  leave_application AS la INNER JOIN leavetypes AS lt ON la.leave_type_id = lt.leavetypeid INNER JOIN employedetails AS et ON et.empid = la.request_to INNER JOIN employedetails AS ed ON la.employee_no = ed.empid INNER JOIN branchmapping ON et.branchid = branchmapping.subbranch INNER JOIN branchmaster ON ed.branchid = branchmaster.branchid WHERE (et.status = 'No') AND (branchmapping.mainbranch = @m) AND (la.request_date BETWEEN @d1 AND @d2) AND (ed.branchid = @b) ORDER BY la.leave_from_dt");
              }
              cmd.Parameters.Add("@m", mainbranch);
              cmd.Parameters.Add("@d1", GetLowDate(fromdate));
              cmd.Parameters.Add("@d2", GetHighDate(todate));
              cmd.Parameters.Add("@b", ddlbranch.SelectedItem.Value);
              dtDriver = vdm.SelectQuery(cmd).Tables[0];
              if (dtDriver.Rows.Count > 0)
              {
                  int i = 1;
                  foreach (DataRow dr in dtDriver.Rows)
                  {
                      DataRow newrow = Report.NewRow();
                      newrow["Sno"] = i++.ToString();
                      newrow["Employe Name"] = dr["fullname"].ToString();
                      newrow["Phone Number"] = dr["mobile_number"].ToString();
                      newrow["Aprrove By"] = dr["approvedby"].ToString();
                      string status = dr["leave_satus"].ToString();
                      if (status == "P")
                      {
                          newrow["Status"] = "Pending";
                      }
                      else if (status == "A")
                      {
                          newrow["Status"] = "Approved";
                      }
                      else if (status == "R")
                      {
                          newrow["Status"] = "Reject";

                      }
                      //newrow["From Date"] = dr["leave_from_dt"].ToString();
                      DateTime from_dt = Convert.ToDateTime(dr["leave_from_dt"].ToString());
                      string dfrom_dt = from_dt.ToString("dd/MMM/yyyy");
                      newrow["From Date"] = dfrom_dt;
                      //newrow["To Date"] = dr["leave_to_dt"].ToString();
                      DateTime to_dt = Convert.ToDateTime(dr["leave_to_dt"].ToString());
                      string dto_dt = to_dt.ToString("dd/MMM/yyyy");
                      newrow["To Date"] = dto_dt;
                      newrow["To Days"] = dr["leave_days"].ToString();
                      Report.Rows.Add(newrow);
                  }
                  grdReports.DataSource = Report;
                  grdReports.DataBind();
                  Session["xportdata"] = Report;
                  hidepanel.Visible = true;
              }
              else
              {
                  lblmsg.Text = "No data found";
              }
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
            if (e.Row.Cells[1].Text == "Total")
            {
                e.Row.BackColor = System.Drawing.Color.Aquamarine;
                e.Row.Font.Size = FontUnit.Large;
                e.Row.Font.Bold = true;
            }
        }
    }
}