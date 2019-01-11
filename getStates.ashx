<%@ WebHandler Language="C#" Class="getStates" %>

using System;
using System.Web;
using System.IO;
using System.Drawing;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using System.Text.RegularExpressions;

public class getStates : IHttpHandler
{
    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    HttpContext objContext = HttpContext.Current;
    string email = "";
    string strData = "";
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";

        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        if (context.Request["email"] != "" && context.Request["email"] != null)
        {
            email = context.Request["email"].Trim();
        }

        try
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
            if (objDataTable.Rows.Count > 0)
            {
                for (int i = 0; i < objDataTable.Rows.Count; i++)
                {
                    strData += objDataTable.Rows[i]["StateCode"].ToString() + "," + objDataTable.Rows[i]["StateName"].ToString() + "*****";
                }

                strData = strData.Substring(0, strData.Length - 5);
            }
        }
        catch { }
        context.Response.Write(strData);
        context.Response.End();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
