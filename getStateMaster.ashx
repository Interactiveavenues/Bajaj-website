<%@ WebHandler Language="C#" Class="getStateMaster" %>
using System;
using System.Web;
using System.IO;
using System.Drawing;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using System.Text.RegularExpressions;
using System.Globalization;
using Newtonsoft.Json;
using System.Dynamic;

public class getStateMaster : IHttpHandler
{
    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    string strData = "";
    string email = "";
    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";
        if (context.Request["email"] != "" && context.Request["email"] != null)
        {
            email = HttpUtility.UrlDecode(context.Request["email"]).Trim();
        }

        if (email.Contains("@"))
        {
            string flag = "N";
            string checkmaildomain = email.Split('@')[1];
            if (checkmaildomain.ToLower() == "relianceada.com")
            {
                flag = "Y";
            }

            string strSql = @"SELECT DISTINCT StateCode,StateName FROM tbl_Digi_Term_States_And_Cities WHERE isADAG=@isADAG ORDER BY StateName";
            SqlParameter[] objSqlParameter = { new SqlParameter("@isADAG", flag) };

            DataTable objDataTable = SqlHelper.ExecuteDataset(strConnectionString, CommandType.Text, strSql, objSqlParameter).Tables[0];

            List<StateMaster> lstStateMaster = new List<StateMaster>();
            if (objDataTable.Rows.Count > 0)
            {
                for (int i = 0; i < objDataTable.Rows.Count; i++)
                {
                    StateMaster objStateMaster = new StateMaster();
                    objStateMaster.StateCode = Convert.ToString(objDataTable.Rows[i]["StateCode"]);
                    objStateMaster.StateName = Convert.ToString(objDataTable.Rows[i]["StateName"]);
                    lstStateMaster.Add(objStateMaster);
                }
            }

            strData += "var arrStateMasterinfo =" + JsonConvert.SerializeObject(lstStateMaster.ToArray(), Formatting.Indented) + ";";
            context.Response.Write(strData);
            context.Response.End();
        }
        else
        {
            context.Response.Write(strData);
            context.Response.End();
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}

public class StateMaster
{

    public string StateCode;
    public string StateName;
   

}