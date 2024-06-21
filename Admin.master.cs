using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;

public partial class Admin : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["fullname"] == null)
        {
            Response.Redirect("login.aspx");
        }
        if (!IsPostBack)
        {
            if (Session["fullname"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                lblName.Text = Session["fullname"].ToString();
                lblMessage.Text = Session["fullname"].ToString();
                lbldesignation.Text = Session["designation"].ToString();
                string b = Session["branchid"].ToString(); ;
                string m = Session["mainbranch"].ToString();
                Session["branchid"] = b.ToString();
                Session["mainbranch"] = m.ToString();
            }
        }
        else
        {
            if (Session["fullname"] == null)
            {
                Response.Redirect("login.aspx");
            }
            else
            {
                string b = Session["branchid"].ToString(); ;
                string m = Session["mainbranch"].ToString();
                Session["branchid"] = b.ToString();
                Session["mainbranch"] = m.ToString();
            }
        }
    }
}
