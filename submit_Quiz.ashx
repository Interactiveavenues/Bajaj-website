<%@ WebHandler Language="C#" Class="submit_Quiz" %> 

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

public class submit_Quiz : IHttpHandler, System.Web.SessionState.IRequiresSessionState
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
    string strshirtSize = "";
    string chkTerms = "";
    string Captcha = "";
    string CompareValue = "";
    string utm_source = "";
    string utm_campaign = "";
    string strError = "";
    string stepNo = "";
    string hdnQuestion1, hdnQuestion2, hdnQuestion3, hdnQuestion4, hdnQuestion5 = "";
    string hdnAnswer1, hdnAnswer2, hdnAnswer3, hdnAnswer4, hdnAnswer5 = "";

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


        if (HttpUtility.UrlDecode(context.Request["shirtSize"]) != null)
        {
            strshirtSize = HttpUtility.UrlDecode(context.Request["shirtSize"]).Trim();
        }
        else
        {
            strshirtSize = "";
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


        if (HttpUtility.UrlDecode(context.Request["captcha"]) != null)
        {
            Captcha = HttpUtility.UrlDecode(context.Request["captcha"]).Trim();
        }
        else
        {
            Captcha = "";
        }

        CompareValue = Convert.ToString(context.Session["captcha"]);


        if (HttpUtility.UrlDecode(context.Request["stepNo"]) != null)
        {
            stepNo = HttpUtility.UrlDecode(context.Request["stepNo"]).Trim();
        }
        else
        {
            stepNo = "";
        }


        if (HttpUtility.UrlDecode(context.Request["hdnQuestion1"]) != null)
        {
            hdnQuestion1 = HttpUtility.UrlDecode(context.Request["hdnQuestion1"]).Trim();
        }
        else
        {
            hdnQuestion1 = "";
        }

        if (HttpUtility.UrlDecode(context.Request["hdnAnswer1"]) != null)
        {
            hdnAnswer1 = HttpUtility.UrlDecode(context.Request["hdnAnswer1"]).Trim();
        }
        else
        {
            hdnAnswer1 = "";
        }


        if (HttpUtility.UrlDecode(context.Request["hdnQuestion2"]) != null)
        {
            hdnQuestion2 = HttpUtility.UrlDecode(context.Request["hdnQuestion2"]).Trim();
        }
        else
        {
            hdnQuestion2 = "";
        }

        if (HttpUtility.UrlDecode(context.Request["hdnAnswer2"]) != null)
        {
            hdnAnswer2 = HttpUtility.UrlDecode(context.Request["hdnAnswer2"]).Trim();
        }
        else
        {
            hdnAnswer2 = "";
        }


        if (HttpUtility.UrlDecode(context.Request["hdnQuestion3"]) != null)
        {
            hdnQuestion3 = HttpUtility.UrlDecode(context.Request["hdnQuestion3"]).Trim();
        }
        else
        {
            hdnQuestion3 = "";
        }

        if (HttpUtility.UrlDecode(context.Request["hdnAnswer3"]) != null)
        {
            hdnAnswer3 = HttpUtility.UrlDecode(context.Request["hdnAnswer3"]).Trim();
        }
        else
        {
            hdnAnswer3 = "";
        }


        if (HttpUtility.UrlDecode(context.Request["hdnQuestion4"]) != null)
        {
            hdnQuestion4 = HttpUtility.UrlDecode(context.Request["hdnQuestion4"]).Trim();
        }
        else
        {
            hdnQuestion4 = "";
        }

        if (HttpUtility.UrlDecode(context.Request["hdnAnswer4"]) != null)
        {
            hdnAnswer4 = HttpUtility.UrlDecode(context.Request["hdnAnswer4"]).Trim();
        }
        else
        {
            hdnAnswer4 = "";
        }


        if (HttpUtility.UrlDecode(context.Request["hdnQuestion5"]) != null)
        {
            hdnQuestion5 = HttpUtility.UrlDecode(context.Request["hdnQuestion5"]).Trim();
        }
        else
        {
            hdnQuestion5 = "";
        }

        if (HttpUtility.UrlDecode(context.Request["hdnAnswer5"]) != null)
        {
            hdnAnswer5 = HttpUtility.UrlDecode(context.Request["hdnAnswer5"]).Trim();
        }
        else
        {
            hdnAnswer5 = "";
        }


        if (stepNo == "1")
        {
            if (validateStepNo1())
            {
                strData = "success***";
                context.Response.Write(strData); 
            }
            else
            {
                context.Response.Write(strData);
            }
        }

        if (stepNo == "2")
        {
            if (validateStepNo2())
            {
                strData = "step2success***";
                context.Response.Write(strData);
            }
            else
            {
                context.Response.Write(strData);
            }
        }


        if (stepNo == "3")
        {
            if (validateStepNo3())
            {
                strData = "step3success***";
                context.Response.Write(strData);
            }
            else
            {
                context.Response.Write(strData);
            }
        }


        if (stepNo == "4")
        {
            if (validateStepNo4())
            {
                strData = "step4success***";
                context.Response.Write(strData);
            }
            else
            {
                context.Response.Write(strData);
            }
        }

        if (stepNo == "5")
        {
            if (validateStepNo5())
            {
                strData = "step5success***";
                context.Response.Write(strData);
            }
            else
            {
                context.Response.Write(strData);
            }
        }

        if (stepNo == "6")
        {
            if (validateStepNo6())
            {

                string strSql = @"INSERT INTO tbl_DigiTermQuiz(name,mobile,email,shirtSize,TermCds,Answer1,Answer2,Answer3,Answer4,Answer5)  VALUES (@name,@mobile,@email,@shirtSize,@TermCds,@Answer1,@Answer2,@Answer3,@Answer4,@Answer5)";


                SqlParameter[] objSqlParameter =
                {
                            new SqlParameter("@name", strName),                            
                            new SqlParameter("@email",strEmail),
                            new SqlParameter("@mobile",strPhone),
                            new SqlParameter("@shirtSize",strshirtSize),                            
                            new SqlParameter("@TermCds",chkTerms),
                            new SqlParameter("@Answer1",hdnAnswer1),
                            new SqlParameter("@Answer2",hdnAnswer2),
                            new SqlParameter("@Answer3",hdnAnswer3),
                            new SqlParameter("@Answer4",hdnAnswer4),
                            new SqlParameter("@Answer5",hdnAnswer5)
                           
                };

                int i = SqlHelper.ExecuteNonQuery(strConnectionString, CommandType.Text, strSql, objSqlParameter);

                if (i > 0)
                {

                    strData = "step6success***";
                    context.Response.Write(strData);

                }               
                
                
            }
            else
            {
                context.Response.Write(strData);
            }
        }

        context.Response.End();
    }





    private bool validateStepNo2()
    {

        if (hdnQuestion1 == "" && hdnAnswer1 == "")
        {
            strData += "Please select any one option.*****hdnAnswer1@@";
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

    private bool validateStepNo3()
    {
        if (hdnQuestion2 == "" && hdnAnswer2 == "")
        {
            strData += "Please select any one option.*****hdnAnswer2@@";
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

    private bool validateStepNo4()
    {

        if (hdnQuestion3 == "" && hdnAnswer3 == "")
        {
            strData += "Please select any one option.*****hdnAnswer3@@";
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

    private bool validateStepNo5()
    {
        if (hdnQuestion4 == "" && hdnAnswer4 == "")
        {
            strData += "Please select any one option.*****hdnAnswer4@@";
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

    private bool validateStepNo6()
    {
        if (hdnQuestion5 == "" && hdnAnswer5 == "")
        {
            strData += "Please select any one option.*****hdnAnswer5@@";
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

    private bool validateStepNo1()
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
                strData += "Name can have only letters.*****txtname@@";
            }

            if (strName.Length < 3)
            {
                strData += "Please enter your valid name.*****txtname@@";
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
                strData += "Mobile number should be 10 digits.*****txtmobileNo@@";
            }

            else if (fnValidateMobileNumberR(strPhone))
            {
                strData += "Mobile number should start with 6,7,8 and 9.*****txtmobileNo@@";
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

        if (strshirtSize == "" || strshirtSize == "Select State")
        {
            strData += "Select T-shirt size*****ddlshirtSize@@";
        }


        if (Captcha == "" || Captcha == "Enter Captcha*")
        {
            strData += "Please enter the captcha.*****txtCaptcha@@";
        }

        if (Captcha != "" && Captcha != "Enter Captcha*" && Captcha.ToLower() != CompareValue.ToLower())
        {
            strData += "Please enter valid captcha.*****txtCaptcha@@";
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