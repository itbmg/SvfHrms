using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Text.RegularExpressions;

public partial class login : System.Web.UI.Page
{
    DBManager vdm = new DBManager();
    SqlCommand cmd;
    AccessControldbmanger Accescontrol_db = new AccessControldbmanger();
    //akbar acces code
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            commanlogin();
        }

        //string ipaddress;
        //ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        //if (ipaddress == "" || ipaddress == null)
        //{
        //    ipaddress = Request.ServerVariables["REMOTE_ADDR"];
        //}

        //HttpBrowserCapabilities browser = Request.Browser;
        //string devicetype = "";
        //string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
        //Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
        //Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
        //string device_info = string.Empty;
        //if (OS.IsMatch(userAgent))
        //{
        //    device_info = OS.Match(userAgent).Groups[0].Value;
        //}
        //if (device.IsMatch(userAgent.Substring(0, 4)))
        //{
        //    device_info += device.Match(userAgent).Groups[0].Value;
        //}
        //if (!string.IsNullOrEmpty(device_info))
        //{
        //    devicetype = device_info;
        //    string[] words = devicetype.Split(')');
        //    devicetype = words[0].ToString();
        //}
        //else
        //{
        //    devicetype = "Desktop";
        //}


        //string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        //string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
        //string numbers = "1234567890";

        //string characters = numbers;
        //characters += alphabets + small_alphabets + numbers;
        //int length = 8;
        //string otp = string.Empty;
        //for (int i = 0; i < length; i++)
        //{
        //    string character = string.Empty;
        //    do
        //    {
        //        int index = new Random().Next(0, characters.Length);
        //        character = characters.ToCharArray()[index].ToString();
        //    } while (otp.IndexOf(character) != -1);
        //    otp += character;
        //}
        //cmd = new SqlCommand("INSERT INTO logininfo(empid, empname, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
        //cmd.Parameters.Add("@userid", empid);
        //cmd.Parameters.Add("@UserName", empname);
        //cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
        //cmd.Parameters.Add("@ipaddress", ipaddress);
        //cmd.Parameters.Add("@device", devicetype);
        ////cmd.Parameters.Add("@otp", otp);
        //vdm.insert(cmd);

        //cmd = new SqlCommand("UPDATE employe_logins SET loginstatus=@logstatus WHERE empid = @empid");
        //cmd.Parameters.Add("@empid", empid);
        //cmd.Parameters.Add("@logstatus", "1");
        //vdm.Update(cmd);
        //if (leveltype == "user")
        //{
        //    Response.Redirect("EmployeeDirectory.aspx", false);
        //}
        //if (leveltype == "accounts")
        //{
        //    Response.Redirect("EmployeeDirectory.aspx", false);
        //}
        //if (leveltype == "Admin" || leveltype == "SuperAdmin")
        //{
        //    Response.Redirect("MainPage.aspx", false);
        //}
        //if (leveltype == "Operations")
        //{
        //    Response.Redirect("reportsgalary.aspx", false);
        //}
        //if (leveltype == "manager")
        //{
        //    Response.Redirect("EmployeeDirectory.aspx", false);
        //}


    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtUserName.Text.Trim() == "" || txtPassword.Text.Trim() == "")
            {
                lblMsg.Text = "Required userName and password";
                return;
            }
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            string username = txtUserName.Text, password = txtPassword.Text;
            lbl_username.Text = username;
            lbl_passwords.Text = password;
            cmd = new SqlCommand("SELECT  el.loginid, el.leveltype, el.username, ed.employee_dept,ed.fullname, ed.company_id, ed.photos, ed.empid, designation.designation,el.loginstatus, designation.designationid, branchmaster.branchid, branchmaster.company_code, branchmapping.mainbranch,el.loginstatus FROM  employe_logins AS el INNER JOIN employedetails AS ed ON ed.empid = el.empid INNER JOIN  branchmaster ON ed.branchid = branchmaster.branchid INNER JOIN  designation ON ed.designationid = designation.designationid INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE  (el.username = @UN) AND (el.password = @Pwd) and (ed.status='No')");
            cmd.Parameters.Add("@Pwd", password);
            cmd.Parameters.Add("@UN", username);
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string loginflag = dt.Rows[0]["loginstatus"].ToString();
                //if (loginflag == "True")
                //{
                //    this.AlertBoxMessage.InnerText = "Already Some one Login With This User Name";
                //    this.AlertBox.Visible = true;
                //}
                //else
                //{
                string company_code = dt.Rows[0]["company_code"].ToString();
                if (company_code == "1")
                {
                    Session["TitleName"] = "SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD";
                }
                else if (company_code == "2")
                {
                    Session["TitleName"] = "Sri Vyshnavi Dairy Pvt Ltd";
                }
                else if (company_code == "3")
                {
                    Session["TitleName"] = "Sri Vyshnavi Foods Pvt Ltd";
                }
                Session["TinNo"] = "37921042267";
                Session["empid"] = dt.Rows[0]["empid"].ToString();
                Session["fullname"] = dt.Rows[0]["fullname"].ToString();
                Session["branchid"] = dt.Rows[0]["branchid"].ToString();
                Session["mainbranch"] = dt.Rows[0]["mainbranch"].ToString();
                Session["deptid"] = dt.Rows[0]["employee_dept"].ToString();
                Session["company_id"] = dt.Rows[0]["company_id"].ToString();
                Session["leveltype"] = dt.Rows[0]["leveltype"].ToString();
                Session["photo"] = dt.Rows[0]["photos"].ToString();
                Session["company_code"] = dt.Rows[0]["company_code"].ToString();
                if (company_code == "1")
                {
                    Session["Address"] = "Survey No.381-2, Punabaka (V), Pellakur (M), SPSR Nellore Dt - 524129.";// dt.Rows[0]["brnch_address"].ToString();
                }
                else if (company_code == "2")
                {
                    Session["Address"] = "JAMMALAPALEM (VILLAGE) JALADANKI (MANDEL) S.P.S.R NELLORE (DIST ) PIN : 524223 Andhra Pradesh";
                }
                else if (company_code == "3")
                {
                    Session["Address"] = "Near Ayyappa swamy Temple, Shasta Nagar, Wyra-507165,Khammam dist. Telangana State.";// dt.Rows[0]["brnch_address"].ToString();
                }
                Session["UserName"] = username;
                Session["userid"] = dt.Rows[0]["loginid"].ToString();
                Session["designation"] = dt.Rows[0]["designation"].ToString();
                Session["designationid"] = dt.Rows[0]["designationid"].ToString();
                string leveltype = Session["leveltype"].ToString();
                string empid = dt.Rows[0]["empid"].ToString();
                string empname = dt.Rows[0]["fullname"].ToString();

                string ipaddress;
                ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (ipaddress == "" || ipaddress == null)
                {
                    ipaddress = Request.ServerVariables["REMOTE_ADDR"];
                }

                HttpBrowserCapabilities browser = Request.Browser;
                string devicetype = "";
                string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
                Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                string device_info = string.Empty;
                if (OS.IsMatch(userAgent))
                {
                    device_info = OS.Match(userAgent).Groups[0].Value;
                }
                if (device.IsMatch(userAgent.Substring(0, 4)))
                {
                    device_info += device.Match(userAgent).Groups[0].Value;
                }
                if (!string.IsNullOrEmpty(device_info))
                {
                    devicetype = device_info;
                    string[] words = devicetype.Split(')');
                    devicetype = words[0].ToString();
                }
                else
                {
                    devicetype = "Desktop";
                }
                cmd = new SqlCommand("INSERT INTO logininfo(empid, empname, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
                cmd.Parameters.Add("@userid", empid);
                cmd.Parameters.Add("@UserName", empname);
                cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
                cmd.Parameters.Add("@ipaddress", ipaddress);
                cmd.Parameters.Add("@device", devicetype);
                //cmd.Parameters.Add("@otp", otp);
                vdm.insert(cmd);
                cmd = new SqlCommand("UPDATE employe_logins SET loginstatus=@logstatus WHERE empid = @empid");
                cmd.Parameters.Add("@empid", empid);
                cmd.Parameters.Add("@logstatus", "1");
                vdm.Update(cmd);
                if (leveltype == "user")
                {
                    Response.Redirect("EmployeeDirectory.aspx", false);
                }
                if (leveltype == "Admin" || leveltype == "SuperAdmin")
                {
                    Response.Redirect("attandancedashboard.aspx", false);
                }
                if (leveltype == "Operations")
                {
                    Response.Redirect("reportsgalary.aspx", false);
                }
                if (leveltype == "accounts")
                {
                    Response.Redirect("EmployeeDirectory.aspx", false);
                }
                if (leveltype == "manager")
                {
                    Response.Redirect("EmployeeDirectory.aspx", false);
                }
            }
            else
            {
                lblMsg.Text = "Username and password Not found";
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
    }
    protected void sessionsclick_click(object sender, EventArgs e)
    {
        try
        {
            string username = lbl_username.Text.ToString();
            string password = lbl_passwords.Text.ToString();
            cmd = new SqlCommand("update employe_logins set loginstatus=@log where username=@username and password=@passward");
            cmd.Parameters.Add("@log", "0");
            cmd.Parameters.Add("@username", username);
            cmd.Parameters.Add("@passward", password);
            vdm.Update(cmd);
            DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
            cmd = new SqlCommand("SELECT loginid,empid FROM employe_logins where username=@username and password=@passward");
            cmd.Parameters.Add("@username", username);
            cmd.Parameters.Add("@passward", password);
            DataTable dtEMP = vdm.SelectQuery(cmd).Tables[0];
            if (dtEMP.Rows.Count > 0)
            {
                string empid = dtEMP.Rows[0]["empid"].ToString();
                cmd = new SqlCommand("Select max(sno) as transno from logininfo where empid=@userid");
                cmd.Parameters.Add("@userid", empid);
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
            this.AlertBox.Visible = false;
        }
        catch
        {

        }
    }
    protected void sessionsclick_Close(object sender, EventArgs e)
    {
        this.AlertBox.Visible = false;
        Response.Redirect("login.aspx");
    }

    private void commanlogin()
    {
        try
        {
            string firstname = Request.QueryString["username"];
            string lastname = Request.QueryString["pwd"];
            txtUserName.Text = firstname;
            txtPassword.Text = lastname;
            if (txtUserName.Text.Trim() == "" || txtPassword.Text.Trim() == "")
            {
                lblMsg.Text = "Required userName and password";
                return;
            }
            
            string username = txtUserName.Text, password = txtPassword.Text;
            lbl_username.Text = username;
            lbl_passwords.Text = password;
            cmd = new SqlCommand("SELECT  el.loginid, el.leveltype, el.username, ed.employee_dept,ed.fullname, ed.company_id, ed.photos, ed.empid, designation.designation, branchmaster.branchid, branchmaster.company_code, branchmapping.mainbranch,el.loginstatus FROM  employe_logins AS el INNER JOIN employedetails AS ed ON ed.empid = el.empid INNER JOIN  branchmaster ON ed.branchid = branchmaster.branchid INNER JOIN  designation ON ed.designationid = designation.designationid INNER JOIN branchmapping ON branchmaster.branchid = branchmapping.subbranch WHERE  (el.username = @UN) AND (el.password = @Pwd) and (ed.status='No')");
            cmd.Parameters.Add("@Pwd", password);
            cmd.Parameters.Add("@UN", username);
            DataTable dt = vdm.SelectQuery(cmd).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string loginflag = dt.Rows[0]["loginstatus"].ToString();
                //if (loginflag == "True")
                //{
                //    this.AlertBoxMessage.InnerText = "Already Some one Login With This User Name";
                //    this.AlertBox.Visible = true;
                //}
                //else
                //{
                string company_code = dt.Rows[0]["company_code"].ToString();
                if (company_code == "1")
                {
                    Session["TitleName"] = "SRI VYSHNAVI DAIRY SPECIALITIES (P) LTD";
                }
                else if (company_code == "2")
                {
                    Session["TitleName"] = "Sri Vyshnavi Dairy Pvt Ltd";
                }
                else if (company_code == "3")
                {
                    Session["TitleName"] = "Sri Vyshnavi Foods Pvt Ltd";
                }
                Session["TinNo"] = "37921042267";
                Session["empid"] = dt.Rows[0]["empid"].ToString();
                Session["fullname"] = dt.Rows[0]["fullname"].ToString();
                Session["branchid"] = dt.Rows[0]["branchid"].ToString();
                Session["mainbranch"] = dt.Rows[0]["mainbranch"].ToString();
                Session["deptid"] = dt.Rows[0]["employee_dept"].ToString();
                Session["company_id"] = dt.Rows[0]["company_id"].ToString();
                Session["leveltype"] = dt.Rows[0]["leveltype"].ToString();
                Session["photo"] = dt.Rows[0]["photos"].ToString();
                Session["company_code"] = dt.Rows[0]["company_code"].ToString();
                if (company_code == "1")
                {
                    Session["Address"] = "Survey No.381-2, Punabaka (V), Pellakur (M), SPSR Nellore Dt - 524129.";// dt.Rows[0]["brnch_address"].ToString();
                }
                else if (company_code == "2")
                {
                    Session["Address"] = "JAMMALAPALEM (VILLAGE) JALADANKI (MANDEL) S.P.S.R NELLORE (DIST ) PIN : 524223 Andhra Pradesh";
                }
                else if (company_code == "3")
                {
                    Session["Address"] = "Near Ayyappa swamy Temple, Shasta Nagar, Wyra-507165,Khammam dist. Telangana State.";// dt.Rows[0]["brnch_address"].ToString();
                }
                Session["UserName"] = username;
                Session["userid"] = dt.Rows[0]["loginid"].ToString();
                Session["designation"] = dt.Rows[0]["designation"].ToString();
                string leveltype = Session["leveltype"].ToString();
                string empid = dt.Rows[0]["empid"].ToString();
                string empname = dt.Rows[0]["fullname"].ToString();

                string ipaddress;
                ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (ipaddress == "" || ipaddress == null)
                {
                    ipaddress = Request.ServerVariables["REMOTE_ADDR"];
                }

                HttpBrowserCapabilities browser = Request.Browser;
                string devicetype = "";
                string userAgent = Request.ServerVariables["HTTP_USER_AGENT"];
                Regex OS = new Regex(@"(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                Regex device = new Regex(@"1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                string device_info = string.Empty;
                if (OS.IsMatch(userAgent))
                {
                    device_info = OS.Match(userAgent).Groups[0].Value;
                }
                if (device.IsMatch(userAgent.Substring(0, 4)))
                {
                    device_info += device.Match(userAgent).Groups[0].Value;
                }
                if (!string.IsNullOrEmpty(device_info))
                {
                    devicetype = device_info;
                    string[] words = devicetype.Split(')');
                    devicetype = words[0].ToString();
                }
                else
                {
                    devicetype = "Desktop";
                }
                DateTime ServerDateCurrentdate = DBManager.GetTime(vdm.conn);
                cmd = new SqlCommand("INSERT INTO logininfo(empid, empname, logintime, ipaddress, devicetype) values (@userid, @UserName, @logintime, @ipaddress, @device)");
                cmd.Parameters.Add("@userid", empid);
                cmd.Parameters.Add("@UserName", empname);
                cmd.Parameters.Add("@logintime", ServerDateCurrentdate);
                cmd.Parameters.Add("@ipaddress", ipaddress);
                cmd.Parameters.Add("@device", devicetype);
                //cmd.Parameters.Add("@otp", otp);
                vdm.insert(cmd);
                cmd = new SqlCommand("UPDATE employe_logins SET loginstatus=@logstatus WHERE empid = @empid");
                cmd.Parameters.Add("@empid", empid);
                cmd.Parameters.Add("@logstatus", "1");
                vdm.Update(cmd);
                if (leveltype == "user")
                {
                    Response.Redirect("EmployeeDirectory.aspx", false);
                }
                if (leveltype == "Admin" || leveltype == "SuperAdmin")
                {
                    Response.Redirect("attandancedashboard.aspx", false);
                }
                if (leveltype == "Operations")
                {
                    Response.Redirect("reportsgalary.aspx", false);
                }
                if (leveltype == "accounts")
                {
                    Response.Redirect("EmployeeDirectory.aspx", false);
                }
                if (leveltype == "manager")
                {
                    Response.Redirect("EmployeeDirectory.aspx", false);
                }
            }
            else
            {
                lblMsg.Text = "Username and password Not found";
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
        }
    }
}