using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class ChangePassWord : System.Web.UI.Page
{
    SqlCommand cmd;
    static string UserName = "";
    string userid = "";
    static DBManager vdm;
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void btnSubmitt_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["empid"] != null)
            {
                lblError.Text = "";
                UserName = Session["empid"].ToString();
                vdm = new DBManager();
                cmd = new SqlCommand("SELECT password FROM employe_logins WHERE empid = @empid");
                cmd.Parameters.Add("@empid", UserName);
                DataTable dt = vdm.SelectQuery(cmd).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    if (txtNewPassWord.Text == txtConformPassWord.Text)
                    {
                        txtNewPassWord.Text = txtConformPassWord.Text;
                        cmd = new SqlCommand("Update employe_logins set password=@Password where empid = @empid ");
                        cmd.Parameters.Add("@empid", UserName);
                        cmd.Parameters.Add("@Password", txtNewPassWord.Text.Trim());
                        vdm.Update(cmd);
                        lblMessage.Text = "Your Password has been Changed successfully";
                        Response.Redirect("login.aspx", false);
                    }
                    else
                    {
                        lblError.Text = "Conform password not match";
                    }
                }
                else
                {
                    lblError.Text = "Entered username is incorrect";
                }
            }
            else
            {
                Response.Redirect("Login.aspx", false);
            }
        }
        catch (Exception ex)
        {
            lblError.Text = "Password Changed Failed";
        }
    }
}