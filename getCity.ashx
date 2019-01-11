<%@ WebHandler Language="C#" Class="getCity" %>

using System;
using System.Web;
using System.IO;
using System.Drawing;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using System.Text.RegularExpressions;

public class getCity : IHttpHandler
{
   
    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";

        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");

        string strData = "";
        string strState = "";
        string strSql = "";
        string email = "";
        if (context.Request["state"] != "" && context.Request["state"] != null)
        {
            strState = context.Request["state"].Trim();
            
        }

        
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

            strSql = @"SELECT DISTINCT CityCode,CityName FROM tbl_Digi_Term_States_And_Cities WHERE StateCode=@State AND isADAG=@isADAG ORDER BY CityName";
            SqlParameter[] objSqlParameter = { new SqlParameter("@State", strState), new SqlParameter("@isADAG", flag) };
            DataTable objDataTable = SqlHelper.ExecuteDataset(strConnectionString, CommandType.Text, strSql, objSqlParameter).Tables[0];
         
            if (objDataTable.Rows.Count > 0)
            {
                for (int i = 0; i < objDataTable.Rows.Count; i++)
                {
                    strData += objDataTable.Rows[i]["CityCode"].ToString() + "," + objDataTable.Rows[i]["CityName"].ToString() + "*****";
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
