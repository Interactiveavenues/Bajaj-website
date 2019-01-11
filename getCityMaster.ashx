<%@ WebHandler Language="C#" Class="getCityMaster" %>
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

public class getCityMaster : IHttpHandler
{
    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    string strData = "";
    string strState = "";
    string email = "";
    string checkmaildomain = "";
    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";
       
        if (context.Request["state"] != "" && context.Request["state"] != null)
        {
            strState = HttpUtility.UrlDecode(context.Request["state"]).Trim();
        }


        if (context.Request["email"] != "" && context.Request["email"] != null)
        {
          email = HttpUtility.UrlDecode(context.Request["email"]).Trim();
        }

        try
        {
            string flag = "N";
            checkmaildomain = email.Split('@')[1];
            if (checkmaildomain.ToLower() == "relianceada.com")
            {
                flag = "Y";
            }

            string strSql = @"SELECT DISTINCT CityCode,CityName FROM tbl_Digi_Term_States_And_Cities WHERE StateName=@State AND isADAG=@isADAG ORDER BY CityName";
            SqlParameter[] objSqlParameter = { new SqlParameter("@State", strState), new SqlParameter("@isADAG", flag) };

            DataTable objDataTable = SqlHelper.ExecuteDataset(strConnectionString, CommandType.Text, strSql, objSqlParameter).Tables[0];

            List<CityMaster> lstCityMaster = new List<CityMaster>();
            if (objDataTable.Rows.Count > 0)
            {
                for (int i = 0; i < objDataTable.Rows.Count; i++)
                {
                    CityMaster objCityMaster = new CityMaster();
                    objCityMaster.CityCode = Convert.ToString(objDataTable.Rows[i]["CityCode"]);
                    objCityMaster.CityName = Convert.ToString(objDataTable.Rows[i]["CityName"]);
                    lstCityMaster.Add(objCityMaster);
                }
            }

            strData += "var arrCityMasterinfo =" + JsonConvert.SerializeObject(lstCityMaster.ToArray(), Formatting.Indented) + ";";
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

public class CityMaster
{

    public string CityCode;
    public string CityName;
   

}