using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class cmporgrpt : System.Web.UI.Page
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
                   
                    lblAddress.Text = Session["Address"].ToString();
                    lblTitle.Text = Session["TitleName"].ToString();
                   
                }
            }
        }
    }

    protected void ddltype_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddltype.SelectedItem.Value == "01")
        {
            ddlcompany.Visible = false;
        }
        else
        {
            ddlcompany.Visible = true;
            fillcompanydetails();
        }
    }
    public void fillcompanydetails()
    {
        DBManager SalesDB = new DBManager();
        cmd = new SqlCommand("SELECT sno,companyname,address,phoneno,mailid,tinno FROM company_master where cmpgroup='1'");
        cmd.Parameters.Add("@bid", Session["mainbranch"].ToString());
        DataTable dttrips = vdm.SelectQuery(cmd).Tables[0];
        ddlcompany.DataSource = dttrips;
        ddlcompany.DataTextField = "companyname";
        ddlcompany.DataValueField = "sno";
        ddlcompany.DataBind();
        ddlcompany.ClearSelection();
        ddlcompany.Items.Insert(0, new ListItem { Value = "0", Text = "--Select companyname--", Selected = true });
        ddlcompany.SelectedValue = "0";
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
            lblmsg.Text = "";
            DBManager SalesDB = new DBManager();
            DateTime fromdate = DateTime.Now;
            DateTime mydate = DateTime.Now;
            DataTable dtinfo = new DataTable();
            Report.Columns.Add("Company Name");
            Report.Columns.Add("MainBranch");
            Report.Columns.Add("BranchType");
            Report.Columns.Add("BranchName");
            if (ddltype.SelectedItem.Value == "02")
            {
                SqlCommand cmd = new SqlCommand("SELECT company_master.sno, company_master.companyname, cmporginfo.branchname AS mainbranch, cmporginfo.branchtype AS mainbranchtype, cmporgbranchinfo.branchname AS subbranch,   cmporgbranchinfo.branchtype AS subbranchtype FROM            company_master INNER JOIN cmporginfo ON company_master.sno = cmporginfo.cmpid INNER JOIN cmporgbranchinfo ON cmporginfo.sno = cmporgbranchinfo.mainbranchid WHERE company_master.sno=@cmpid ORDER BY company_master.sno");
                cmd.Parameters.Add("@cmpid", ddlcompany.SelectedItem.Value);
                dtinfo = vdm.SelectQuery(cmd).Tables[0];
            }
            else
            {
                SqlCommand cmd = new SqlCommand("SELECT company_master.sno, company_master.companyname, cmporginfo.branchname AS mainbranch, cmporginfo.branchtype AS mainbranchtype, cmporgbranchinfo.branchname AS subbranch,   cmporgbranchinfo.branchtype AS subbranchtype FROM            company_master INNER JOIN cmporginfo ON company_master.sno = cmporginfo.cmpid INNER JOIN cmporgbranchinfo ON cmporginfo.sno = cmporgbranchinfo.mainbranchid ORDER BY company_master.sno");
                 dtinfo = vdm.SelectQuery(cmd).Tables[0];
            }
            if (dtinfo.Rows.Count > 0)
            {
                
                foreach (DataRow dr in dtinfo.Rows)
                {
                    DataRow newrow = Report.NewRow();
                    newrow["Company Name"] = dr["companyname"].ToString();
                    newrow["MainBranch"] = dr["mainbranch"].ToString();
                    newrow["BranchName"] = dr["subbranch"].ToString();
                    newrow["BranchType"] = dr["subbranchtype"].ToString();
                    Report.Rows.Add(newrow);
                }
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
        
    }

    protected void grdReports_DataBinding(object sender, EventArgs e)
    {
        try
        {
            GridViewGroup First = new GridViewGroup(grdReports, null, "Company Name");
            GridViewGroup second = new GridViewGroup(grdReports, First, "MainBranch");
            GridViewGroup three = new GridViewGroup(grdReports, second, "BranchType");
            GridViewGroup four = new GridViewGroup(grdReports, three, "BranchName");
            // GridViewGroup three = new GridViewGroup(grdReports, seconf, "PF");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void btnlogssave_click(object sender, EventArgs e)
    {
       

    }  
}