using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Payroll_Rejoinings : System.Web.UI.Page
{
    #region Page Event Handlers

    protected void Page_Load(object sender, EventArgs e)
    {
        //try
        //{
        //    if (Session["UserName"] == null || (Session["UserName"] != null && Convert.ToString(Session["UserName"]) == string.Empty))
        //        Response.Redirect(ConfigurationManager.AppSettings["LoginUrl"]);
        //    else
        //    {
        //        lblMsg.Text = string.Empty;
        //        if (!Page.IsPostBack)
        //        {
        //            trDetails.Visible = false;
        //        }
        //    }
        //}
        //catch (Exception ex)
        //{
        //    if (!(ex is System.Threading.ThreadAbortException))
        //        WriteLogItem(ex.Message, ex.StackTrace, Convert.ToString(Session["UserName"]));
        //}
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //try
        //{
        //    if (txtEmployeeCode.Text == string.Empty && txtEmployeeName.Text == string.Empty)
        //    {
        //        lblMsg.Text = "Required employee code or name";
        //        lblMsg.ForeColor = System.Drawing.Color.Red;
        //        txtEmployeeCode.Focus();
        //        return;
        //    }
        //    BindEmployeeDetails();
        //}
        //catch (Exception ex)
        //{
        //    WriteLogItem(ex.Message, ex.StackTrace, Convert.ToString(Session["UserName"]));
        //}
    }

    protected void txtDOJ_TextChanged(object sender, EventArgs e)
    {
        //try
        //{
        //    if (txtDOJ.Text != "")
        //    {
        //        DateTime dtDOJ = Convert.ToDateTime(txtDOJ.Text);
        //        if (dtDOJ > DateTime.Today)
        //        {
        //            lblMsg.Text = "DOJ must be less than or equal to today date";
        //            lblMsg.ForeColor = System.Drawing.Color.Red;
        //            txtDOJ.Text = "";
        //        }
        //    }
        //}
        //catch (Exception ex)
        //{
        //    WriteLogItem(ex.Message, ex.StackTrace, Convert.ToString(Session["UserName"]));
        //}
    }

    protected void chkLogin_CheckedChanged(object sender, EventArgs e)
    {
        //try
        //{
        //    chkLogin.Focus();
        //    txtUsername.Text = string.Empty;
        //    txtPassword.Text = string.Empty;
        //    txtConfirmPassword.Text = string.Empty;
        //    ddlRole.SelectedIndex = 0;
        //    if (chkLogin.Checked == true)
        //    {
        //        txtUsername.Enabled = true;
        //        txtPassword.Enabled = true;
        //        txtConfirmPassword.Enabled = true;
        //        ddlRole.Enabled = true;
        //    }
        //    else
        //    {
        //        txtUsername.Enabled = false;
        //        txtPassword.Enabled = false;
        //        txtConfirmPassword.Enabled = false;
        //        ddlRole.Enabled = false;
        //    }
        //}
        //catch (Exception ex)
        //{
        //    WriteLogItem(ex.Message, ex.StackTrace, Convert.ToString(Session["UserName"]));
        //}
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        //try
        //{
        //    BE_Payroll_Rejoinings beRejoin = new BE_Payroll_Rejoinings();
        //    int RejoinId = 0;
        //    beRejoin.EmployeeId = Convert.ToInt32(hfEmpId.Value.Trim());
        //    beRejoin.PreviousDepartmentId = Convert.ToInt32(hfDepartmentId.Value.Trim());
        //    beRejoin.RejoinDepartmentId = Convert.ToInt32(ddlDepartment.SelectedValue.Trim());
        //    beRejoin.PreviousDesignationId = Convert.ToInt32(hfDesignationId.Value.Trim());
        //    beRejoin.RejoinDesignationId = Convert.ToInt32(ddlDesignation.SelectedValue.Trim());
        //    beRejoin.PreviousDOJ = Convert.ToDateTime(lblDOJ.Text.Trim());
        //    beRejoin.RejoinDOJ = Convert.ToDateTime(txtDOJ.Text.Trim());
        //    beRejoin.PreviousResignationDate = Convert.ToDateTime(lblResignedDate.Text.Trim());
        //    beRejoin.PreviousReportingTo = Convert.ToInt32(hfReportingTo.Value.Trim());
        //    beRejoin.RejoinReportingTo = Convert.ToInt32(ddlReportingTo.SelectedValue.Trim());
        //    beRejoin.CreatedBy = txtUsername.Text.Trim();
        //    if (chkLogin.Checked == true)
        //    {
        //        beRejoin.UserName = txtUsername.Text.Trim();
        //        if (txtPassword.Enabled == true)
        //            beRejoin.Password = txtPassword.Text.Trim();
        //        else
        //            beRejoin.Password = "camirine";
        //        beRejoin.RoleId = Convert.ToInt32(ddlRole.SelectedValue.Trim());
        //    }
        //    foreach (ListItem li in chkLeaveTypes.Items)
        //    {
        //        if (li.Selected == true)
        //        {
        //            beRejoin.RejoinId = RejoinId;
        //            beRejoin.LeaveTypeId = Convert.ToInt32(li.Value.Trim());
        //            DataSet dsResult = new BL_Payroll_Rejoinings().InsertRejoinDetails(beRejoin);
        //            RejoinId = Convert.ToInt32(dsResult.Tables[0].Rows[0][0].ToString());
        //        }
        //    }
        //    if (RejoinId > 0)
        //    {

        //        if (chkLogin.Checked == true && txtPassword.Enabled == false)
        //            lblMsg.Text = "Rejoin Details added successfully and login password is camirine";
        //        else
        //            lblMsg.Text = "Rejoin Details added successfully";
        //        lblMsg.ForeColor = System.Drawing.Color.Green;
        //        txtEmployeeCode.Text = string.Empty;
        //        txtEmployeeName.Text = string.Empty;
        //        trDetails.Visible = false;
        //        txtEmployeeCode.Focus();
        //    }
        //}
        //catch (Exception ex)
        //{
        //    WriteLogItem(ex.Message, ex.StackTrace, Convert.ToString(Session["UserName"]));
        //}
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
       
    }

    #endregion
}