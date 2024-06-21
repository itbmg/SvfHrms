using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for StockManagement
/// </summary>
public class StockManagement
{
	public StockManagement()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public bool IsReusable
    {
        get { return true; }
    }
    private static string GetJson(object obj)
    {
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        return jsonSerializer.Serialize(obj);
    }
    class GetJsonData
    {
        public string op { set; get; }
    }
}