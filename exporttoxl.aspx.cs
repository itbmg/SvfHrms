using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;

public partial class exporttoxl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["xportdata"] != null)
        {
            DataTable dtt = (DataTable)Session["xportdata"];
            ExportToExcel(dtt);
            //EXPORTTOPDF(dtt);
        }
    }

    public void ExportToExcel(DataTable dt)
    {
        try
        {
            if (dt.Rows.Count > 0)
            {
                string filena = Session["filename"].ToString();
                string address = Session["Address"].ToString();
                string TitleName = Session["TitleName"].ToString();
                string title = Session["title"].ToString();
                string filename = "";
                if (filena != "" && filena != null)
                {
                    filename = filena;
                }
                else
                {
                    filename = "Report";
                }

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ClearContent();
                HttpContext.Current.Response.ClearHeaders();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "application/ms-excel";
                HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + filename + ".xls");

                HttpContext.Current.Response.Charset = "utf-8";
                HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");
                //sets font
                HttpContext.Current.Response.Write("<font style='font-size:10.0pt;'>");
                HttpContext.Current.Response.Write("<BR><BR><BR>");
                //sets the table border, cell spacing, border color, font of the text, background, foreground, font height
                HttpContext.Current.Response.Write("<Table border='1' bgColor='#ffffff' " +
                  "borderColor='#000000' cellSpacing='0' cellPadding='0' " +
                  "style='font-size:10.0pt; background:white;'> <TR>");
                int columnscount = dt.Columns.Count;
                //For Header
                if (filename == "Total Deduction" || filename == "Employeedetails" || filename == "Employeebankdetails" || filename == "Organisetionflowdetails")
                {
                }
                else
                {
                    if (columnscount < 9)
                    {
                        if (columnscount < 5)
                        {
                            HttpContext.Current.Response.Write("<Td colspan='" + 6 + "' align='center' style='font-size:15.0pt;'>" + TitleName + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 6 + "' align='center' style='font-size:10.0pt;'>" + address + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 6 + "' align='center' style='font-size:12.0pt;'>" + title + "</Td><TR>");
                        }
                        else
                        {
                            HttpContext.Current.Response.Write("<Td colspan='" + 10 + "' align='center' style='font-size:20.0pt;'>" + TitleName + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 10 + "' align='center' style='font-size:10.0pt;'>" + address + "</Td><TR>");
                            HttpContext.Current.Response.Write("<Td colspan='" + 10 + "' align='center' style='font-size:15.0pt;'>" + title + "</Td><TR>");
                        }
                    }
                    else
                    {
                        HttpContext.Current.Response.Write("<Td colspan='" + columnscount + "' align='center' style='font-size:30.0pt;'>" + TitleName + "</Td><TR>");
                        HttpContext.Current.Response.Write("<Td colspan='" + columnscount + "' align='center' style='font-size:14.0pt;'>" + address + "</Td><TR>");
                        HttpContext.Current.Response.Write("<Td colspan='" + columnscount + "' align='center' style='font-size:20.0pt;'>" + title + "</Td><TR>");
                    }
                }
                //am getting my grid's column headers


                for (int j = 0; j < columnscount; j++)
                {      //write in new column
                    int name = dt.Columns[j].ColumnName.Length;
                    if (name <= 3)
                    {
                        HttpContext.Current.Response.Write("<Td style='font-size:11.0pt;height:40.pt;width:40px'>");
                    }
                    if (name > 3)
                    {
                        HttpContext.Current.Response.Write("<Td style='font-size:11.0pt;height:40.pt;width:85px'>");
                    }
                    //if (dt.Columns[j].ColumnName == "Bank Acc NO")
                    //{
                    //    HttpContext.Current.Response.Write("<Td style='font-size:11.0pt;height:40.pt;width:110px'>");
                    //}
                    //Get column headers  and make it as bold in excel columns
                    HttpContext.Current.Response.Write("<B>");
                    if (dt.Columns[j].ColumnName.ToString() == "Bank Acc NO")
                    {
                        HttpContext.Current.Response.Write(dt.Columns[j].ColumnName.ToString());
                    }
                    else
                    {
                        HttpContext.Current.Response.Write(dt.Columns[j].ColumnName.ToString());
                    }
                    HttpContext.Current.Response.Write("</B>");
                    HttpContext.Current.Response.Write("</Td>");
                }
                HttpContext.Current.Response.Write("</TR>");
                foreach (DataRow row in dt.Rows)
                {//write in new row
                    HttpContext.Current.Response.Write("<TR>");
                    if (columnscount < 9)
                    {
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {

                            HttpContext.Current.Response.Write("<Td style='font-size:10.0pt;height:40px;width:120px'>");
                            HttpContext.Current.Response.Write(row[i].ToString());
                            HttpContext.Current.Response.Write("</Td>");
                        }
                    }
                    else
                    {
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {
                            HttpContext.Current.Response.Write("<Td style='font-size:10.0pt;height:40px'>");
                            HttpContext.Current.Response.Write(row[i].ToString());
                            HttpContext.Current.Response.Write("</Td>");
                        }
                    }
                    HttpContext.Current.Response.Write("</TR>");
                }
                HttpContext.Current.Response.Write("</Table>");
                HttpContext.Current.Response.Write("</font>");
                HttpContext.Current.Response.Flush();
                HttpContext.Current.Response.End();
            }
        }
        catch (Exception ex)
        {
        }
    }

   
}