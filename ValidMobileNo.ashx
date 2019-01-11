<%@ WebHandler Language="C#" Class="ValidMobileNo" %>

using System;
using System.Web;
using System.IO;
using System.Drawing;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using System.Text.RegularExpressions;
using System.Net;
using System.IO;
using System.Text;


public class ValidMobileNo : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    string strData = "";
    string strPhone = "";
    string errorMessage = "";
    Regex numbers = new Regex("^[0-9]*$");
    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";

        if (HttpUtility.UrlDecode(context.Request["mobile"]) != null)
        {
            strPhone = HttpUtility.UrlDecode(context.Request["mobile"]).Trim();
        }
        else
        {
            strPhone = "";
        }

        if (isValidmobileNo())
        {
            context.Response.Write("success");
        }
        else
        {
            context.Response.Write(strData);
        }
    }


    private bool isValidmobileNo()
    {
        if (strPhone == "" || strPhone == "Phone")
        {
            strData = "Please enter your mobile number.*****txtmobileNo";
            return false;
        }

        if (strPhone != "")
        {
            if (strPhone.Length < 10)
            {
                strData = "Mobile number should be 10 digits.*****txtmobileNo";
                return false;
            }

            else if (!strPhone.StartsWith("9") && !strPhone.StartsWith("8") && !strPhone.StartsWith("7") && !strPhone.StartsWith("6"))
            {
                strData = "Mobile number should start with 6,7,8 and 9.*****txtmobileNo";
                return false;
            }
            else if (strPhone == "9000000000" || strPhone == "9111111111" || strPhone == "9222222222" || strPhone == "9333333333" || strPhone == "944444444" || strPhone == "9555555555" || strPhone == "9666666666" || strPhone == "9777777777" || strPhone == "9888888888" || strPhone == "9999999999")
            {
                strData = "Please enter valid mobile number.*****txtmobileNo";
                return false;
            }
            else if (strPhone == "8000000000" || strPhone == "8111111111" || strPhone == "8222222222" || strPhone == "8333333333" || strPhone == "844444444" || strPhone == "8555555555" || strPhone == "8666666666" || strPhone == "8777777777" || strPhone == "8888888888" || strPhone == "8999999999")
            {
                strData = "Please enter valid mobile number.*****txtmobileNo";
                return false;
            }
            else if (strPhone == "7000000000" || strPhone == "7111111111" || strPhone == "7222222222" || strPhone == "7333333333" || strPhone == "744444444" || strPhone == "7555555555" || strPhone == "7666666666" || strPhone == "7777777777" || strPhone == "7888888888" || strPhone == "7999999999")
            {
                strData = "Please enter valid mobile number.*****txtmobileNo";
                return false;
            }

            else if (strPhone == "6000000000" || strPhone == "6111111111" || strPhone == "6222222222" || strPhone == "6333333333" || strPhone == "6444444444" || strPhone == "6555555555" || strPhone == "6666666666" || strPhone == "6777777777" || strPhone == "6888888888" || strPhone == "6999999999")
            {
                strData = "Please enter valid mobile number.*****txtmobileNo";
                return false;
            }
            

        }
        return true;
    }


    private Boolean fnValidateMobileNumberR(string strPhoneNumber)
    {
        if (!numbers.IsMatch(strPhoneNumber))
        {
            return true;
        }
        if (strPhoneNumber.Length != 10)
        {
            return true;
        }
        if (!strPhoneNumber.StartsWith("9") && !strPhoneNumber.StartsWith("8") && !strPhoneNumber.StartsWith("7") && !strPhoneNumber.StartsWith("6"))
        {
            return true;
        }
        if (strPhoneNumber == "9000000000" || strPhoneNumber == "9111111111" || strPhoneNumber == "9222222222" || strPhoneNumber == "9333333333" || strPhoneNumber == "944444444" || strPhoneNumber == "955555555" || strPhoneNumber == "966666666" || strPhoneNumber == "9777777777" || strPhoneNumber == "9888888888" || strPhoneNumber == "9999999999")
        {
            return true;
        }
        if (strPhoneNumber == "8000000000" || strPhoneNumber == "8111111111" || strPhoneNumber == "8222222222" || strPhoneNumber == "8333333333" || strPhoneNumber == "844444444" || strPhoneNumber == "855555555" || strPhoneNumber == "866666666" || strPhoneNumber == "8777777777" || strPhoneNumber == "8888888888" || strPhoneNumber == "8999999999")
        {
            return true;
        }
        if (strPhoneNumber == "7000000000" || strPhoneNumber == "7111111111" || strPhoneNumber == "7222222222" || strPhoneNumber == "7333333333" || strPhoneNumber == "744444444" || strPhoneNumber == "755555555" || strPhoneNumber == "766666666" || strPhoneNumber == "7777777777" || strPhoneNumber == "7888888888" || strPhoneNumber == "7999999999")
        {

            return true;
        }

        if (strPhoneNumber == "6000000000" || strPhoneNumber == "6111111111" || strPhoneNumber == "6222222222" || strPhoneNumber == "6333333333" || strPhoneNumber == "644444444" || strPhoneNumber == "655555555" || strPhoneNumber == "666666666" || strPhoneNumber == "6777777777" || strPhoneNumber == "6888888888" || strPhoneNumber == "6999999999")
        {

            return true;
        }

        return false;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}