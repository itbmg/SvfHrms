using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.IO;

public partial class Logout : System.Web.UI.Page
{
    DBManager vdm = new DBManager();
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["empid"] != null)
        {
            string sno = Session["empid"].ToString();
            cmd = new SqlCommand("UPDATE employe_logins SET loginstatus=@logstatus WHERE empid = @empid");
            cmd.Parameters.Add("@empid", Session["empid"]);
            cmd.Parameters.Add("@logstatus", "0");
            vdm.Update(cmd);

            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            cmd = new SqlCommand("Select max(sno) as transno from logininfo where empid=@userid AND empname=@UserName");
            cmd.Parameters.Add("@userid", Session["empid"]);
            cmd.Parameters.Add("@UserName", Session["fullname"]);
            DataTable dttime = vdm.SelectQuery(cmd).Tables[0];
            if (dttime.Rows.Count > 0)
            {
                string transno = dttime.Rows[0]["transno"].ToString();
                cmd = new SqlCommand("UPDATE logininfo set logouttime=@logouttime where sno=@sno");
                cmd.Parameters.Add("@logouttime", ServerDateCurrentdate);
                cmd.Parameters.Add("@sno", transno);
                vdm.Update(cmd);
            }
        }
        else
        {
            cmd = new SqlCommand("update employe_logins set loginstatus=@log");
            cmd.Parameters.Add("@log", "0");
            vdm.Update(cmd);
        }
        Session.Clear();
        Session.RemoveAll();
        Session.Abandon();
        //window.localStorage.clear();
        //ClearCache();
        //clearchachelocalall();

       

        Response.Redirect("login.aspx");
    }


    public static void ClearCache()
    {
        HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.Cache.SetExpires(DateTime.Now);
        HttpContext.Current.Response.Cache.SetNoServerCaching();
        HttpContext.Current.Response.Cache.SetNoStore();
        HttpContext.Current.Response.Cookies.Clear();
        HttpContext.Current.Request.Cookies.Clear();
    }

    private void clearchachelocalall()
    {
        string GooglePath = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Local\Google\Chrome\User Data\Default\";
        string MozilaPath = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Roaming\Mozilla\Firefox\";
        string Opera1 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Local\Opera\Opera";
        string Opera2 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Roaming\Opera\Opera";
        string Safari1 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Local\Apple Computer\Safari";
        string Safari2 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Roaming\Apple Computer\Safari";
        string IE1 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Local\Microsoft\Intern~1";
        string IE2 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Local\Microsoft\Windows\History";
        string IE3 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Local\Microsoft\Windows\Tempor~1";
        string IE4 = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Roaming\Microsoft\Windows\Cookies";
        string Flash = Environment.GetEnvironmentVariable("USERPROFILE") + @"\AppData\Roaming\Macromedia\Flashp~1";

        //Call This Method ClearAllSettings and Pass String Array Param
        ClearAllSettings(new string[] { GooglePath, MozilaPath, Opera1, Opera2, Safari1, Safari2, IE1, IE2, IE3, IE4, Flash });

    }

    public void ClearAllSettings(string[] ClearPath)
    {
        foreach (string HistoryPath in ClearPath)
        {
            if (Directory.Exists(HistoryPath))
            {
                DoDelete(new DirectoryInfo(HistoryPath));
            }

        }
    }

    void DoDelete(DirectoryInfo folder)
    {
        try
        {

            foreach (FileInfo file in folder.GetFiles())
            {
                try
                {
                    file.Delete();
                }
                catch
                { }

            }
            foreach (DirectoryInfo subfolder in folder.GetDirectories())
            {
                DoDelete(subfolder);
            }
        }
        catch
        {
        }
    }
}