<%@ WebHandler Language="C#" Class="submit_DigiTerm" %> 

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

public class submit_DigiTerm : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    string strConnectionString = ConfigurationManager.ConnectionStrings["connectionStringWebsite"].ConnectionString;
    Regex charc = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
    Regex numbers = new Regex("^[0-9]*$");

    Regex DateFormat = new Regex("^(((0[1-9]|[12]\\d|3[01])\\/(0[13578]|1[02])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|[12]\\d|30)\\/(0[13456789]|1[012])\\/((19|[2-9]\\d)\\d{2}))|((0[1-9]|1\\d|2[0-8])\\/02\\/((19|[2-9]\\d)\\d{2}))|(29\\/02\\/((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$");
    string strData = "";
    string strName = "";
    string strPhone = "";
    string strEmail = "";
    string strdateofBirth = "";
    string strstate = "";
    string strcity = "";
    string chkTerms = "";
    string Captcha = "";
    
    string utm_source = "";
    string utm_campaign = "";
    string strError = "";

    HttpContext objContext = HttpContext.Current;

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        context.Response.Expires = -1500;
        context.Response.CacheControl = "no-cache";
        context.Response.ContentType = "text/plain";

        if (HttpUtility.UrlDecode(context.Request["name"]) != null)
        {
            strName = HttpUtility.UrlDecode(context.Request["name"]).Trim();
        }
        else
        {
            strName = "";
        }

        if (HttpUtility.UrlDecode(context.Request["mobile"]) != null)
        {
            strPhone = HttpUtility.UrlDecode(context.Request["mobile"]).Trim();
        }
        else
        {
            strPhone = "";
        }

        if (HttpUtility.UrlDecode(context.Request["emailId"]) != null)
        {
            strEmail = HttpUtility.UrlDecode(context.Request["emailId"]).Trim();
        }
        else
        {
            strEmail = "";
        }

        if (HttpUtility.UrlDecode(context.Request["dateofBirth"]) != null)
        {
            strdateofBirth = HttpUtility.UrlDecode(context.Request["dateofBirth"]).Trim();
        }
        else
        {
            strdateofBirth = "";
        }

        if (HttpUtility.UrlDecode(context.Request["state"]) != null)
        {
            strstate = HttpUtility.UrlDecode(context.Request["state"]).Trim();
        }
        else
        {
            strstate = "";
        }

        if (HttpUtility.UrlDecode(context.Request["city"]) != null)
        {
            strcity = HttpUtility.UrlDecode(context.Request["city"]).Trim();
        }
        else
        {
            strcity = "";
        }

        if (HttpUtility.UrlDecode(context.Request["captcha"]) != null)
        {
            Captcha = HttpUtility.UrlDecode(context.Request["captcha"]).Trim();
        }
        else
        {
            Captcha = "";
        }


        if (HttpUtility.UrlDecode(context.Request["chk_terms"]) != null)
        {
            if (HttpUtility.UrlDecode(context.Request["chk_terms"]) == "1")
            {
                chkTerms = HttpUtility.UrlDecode(context.Request["chk_terms"]).Trim();
            }
            else
            {
                chkTerms = "0";
            }
        }
        else
        {
            chkTerms = "0";
        }



        


        



        if (HttpUtility.UrlDecode(context.Request["utm_source"]) != null)
        {
            utm_source = HttpUtility.UrlDecode(context.Request["utm_source"]).Trim();
        }
        else
        {
            utm_source = "";
        }


        if (HttpUtility.UrlDecode(context.Request["utm_campaign"]) != null)
        {
            utm_campaign = HttpUtility.UrlDecode(context.Request["utm_campaign"]).Trim();
        }
        else
        {
            utm_campaign = "";
        }

        if (isValidForm())
        {

            string state = "0"; string city = "0";

            string strSql = @"SELECT CityCode,StateCode FROM tbl_Digi_Term_States_And_Cities WHERE StateName=@State AND CityName=@CityName";
            SqlParameter[] objSqlParameter = { new SqlParameter("@State", strstate), new SqlParameter("@CityName", strcity) };

            DataTable objDataTable = SqlHelper.ExecuteDataset(strConnectionString, CommandType.Text, strSql, objSqlParameter).Tables[0];
            if (objDataTable.Rows.Count > 0)
            {

                state = Convert.ToString(objDataTable.Rows[0]["StateCode"]);
                city = Convert.ToString(objDataTable.Rows[0]["CityCode"]);
            }

            string leadId = CallAPI(strName, strPhone, strdateofBirth, strEmail, city, state, utm_source, utm_campaign);
            if (leadId.Contains("Failed"))
            {
                strData = leadId;
                context.Response.Write(strData);
            }
            else
            {
                strData = "success***" + leadId;
                context.Response.Write(strData);
            }


        }
        else
        {
            context.Response.Write(strData);
        }



        context.Response.End();
    }

    private string CallAPI(string strName, string strPhone, string strdateofBirth, string strEmail, string strcity, string strstate, string utm_source, string utm_campaign)
    {
        string leadid = "";
        string URI = "http://124.124.218.139/EsalesCRM_API/api/lead/SaveDetails";
        string myParameters = "name=" + strName + "&mobile=" + strPhone + "&city=" + strcity + "&email=" + strEmail + "&dob=" + strdateofBirth + "&utm_source=" + utm_source + "&utm_campaign=" + utm_campaign + "&state=" + strstate + "";

        using (WebClient wc = new WebClient())
        {
            try
            {
                wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                //wc.Credentials = new NetworkCredential("esales_user", "master123$");
                string credentials = String.Format("{0}:{1}", "esales_user", "master123$");
                byte[] bytes = Encoding.ASCII.GetBytes(credentials);
                string base64 = Convert.ToBase64String(bytes);
                string authorization = String.Concat("basic ", base64);
                wc.Headers.Add("Authorization", authorization);

                string ApiResult = wc.UploadString(URI, myParameters);

                APIDetails leadData = (APIDetails)Newtonsoft.Json.JsonConvert.DeserializeObject(ApiResult, typeof(APIDetails));
                if (leadData.lead_id != null && leadData.lead_id != "")
                {

                    leadid = leadData.lead_id;
                    string strSql = @"INSERT INTO [tbl_DigiTerm_API_logs](lead_id,status,error_message)
                                      VALUES(@lead_id,@status,@error_message)";

                    SqlParameter[] objSqlParameter = { 
                                              new SqlParameter("@lead_id", leadData.lead_id),
                                              new SqlParameter("@status", leadData.status),
                                              new SqlParameter("@error_message", leadData.error_message + ApiResult+" par "+myParameters)
                                             };
                    int roweffect = SqlHelper.ExecuteNonQuery(strConnectionString, CommandType.Text, strSql, objSqlParameter);

                }
            }
            catch (Exception ex)
            {
                string strSql = @"INSERT INTO [tbl_DigiTerm_API_logs](lead_id,status,error_message)
                                      VALUES(@lead_id,@status,@error_message)";

                SqlParameter[] objSqlParameter = { 
                                              new SqlParameter("@lead_id", "0"),
                                              new SqlParameter("@status", "error"),
                                              new SqlParameter("@error_message", "par "+myParameters+" Exception:"+ex.Message)
                                             };
                int roweffect = SqlHelper.ExecuteNonQuery(strConnectionString, CommandType.Text, strSql, objSqlParameter);

                leadid = "Failed***DigiTerm API Error: " + ex.Message;
            }

        }
        return leadid;
    }


    private bool isValidForm()
    {

        if (strName == "" || strName == "Name")
        {
            strData += "Please enter your name.*****txtname@@";
        }

        if (strName != "")
        {

            Regex rgobj = new Regex(@"^[a-zA-Z][a-zA-Z ]*$");
            if (!rgobj.IsMatch(strName))
            {
                strData += "Please enter valid name.*****txtname@@";
            }

            if (strName.Length < 3)
            {
                strData += "Please enter valid name.*****txtname@@";
            }
        }

        if (strPhone == "" || strPhone == "Phone")
        {
            strData += "Please enter your mobile number.*****txtmobileNo@@";
        }

        if (strPhone != "")
        {
            if (strPhone.Length < 10)
            {
                strData += "Please enter valid mobile number.*****txtmobileNo@@";
            }

            else if (fnValidateMobileNumberR(strPhone))
            {
                strData += "Please enter valid mobile number.*****txtmobileNo@@";
            }
        }

        if (strdateofBirth == "")
        {
            strData += "Please enter your date of birth.*****txtDOB@@";
        }
        if (strdateofBirth != "")
        {
            if (!DateFormat.IsMatch(strdateofBirth))
            {
                strData += "Please enter your valid date of birth.*****txtDOB@@";
            }
            else
            {

                if (validateAge(strdateofBirth))
                {
                    strData += "Enter Age should be greater than 18 and less than 60*****txtDOB@@";
                }
            }
        }


        if (strEmail == "" || strEmail == "Email")
        {
            strData += "Please enter your e-mailId*****txtemail@@";
        }
        if (strEmail != "" && !ValidEmail(strEmail))
        {
            strData += "Please enter valid e-mailId*****txtemail@@";
        }

        if (strstate == "" || strstate == "Select State")
        {
            strData += "Please select state*****ddlstate@@";
        }


        if (strcity == "" || strcity == "Select City")
        {
            strData += "Please select city*****ddlcity@@";
        }

        if (Captcha == "")
        {
            strData += "Please enter the captcha.*****txtDgTermCaptcha@@";
        }

        if (Captcha != "" && Captcha.ToLower() != HttpContext.Current.Session["captcha"].ToString().ToLower())
        {
            strData += "Please enter valid captcha*****txtDgTermCaptcha@@";
        }       

        if (chkTerms == "0")
        {
            strData += "Please agree to the terms to proceed.*****chk_terms@@";
        }

        if (strData != "")
        {
            return false;
        }
        else
        {
            return true;
        }
    }




    public bool validateAge(string inputDate)
    {
        bool flag = false;
        try
        {
            string date1 = inputDate.Split('/')[0];
            string month = inputDate.Split('/')[1];
            string year1 = inputDate.Split('/')[2];
            double age = 0.0;
            DateTime dateCurrent = DateTime.Today;
            DateTime dob = Convert.ToDateTime(year1 + "-" + month + "-" + date1);
            TimeSpan ageC = dateCurrent - dob;
            double ageInDays = ageC.TotalDays;
            double daysInYear = 365.2425;
            age = ageInDays / daysInYear;

            if (age < 18.00 || age > 60.00)
            {
                flag = true;
            }
        }
        catch { }
        return flag;
    }

    private bool ValidEmail(string validatingstring)
    {
        if (!Regex.Match(validatingstring, @"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$").Success)
        {
            return false;
        }
        else
        {
            return true;
        }
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





    public class APIDetails
    {
        public string lead_id;
        public string status;
        public string error_message;
    }



}