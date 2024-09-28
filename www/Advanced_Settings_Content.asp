<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_12#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript">
<!--
    var clicked = 0;
    function processClick() {
        if (clicked === 10) {
            //alert ('DONE');
            fullFwUpload();
            clicked = 0;
            return;
        }
        clicked = clicked + 1;
        //alert(clicked);
    }
-->
</script>
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('help_enable');
	init_itoggle('roam_enable_x');
});

</script>
<script>

<% login_state_hook(); %>

function initial(){
	show_banner(1);
	show_menu(5,6,1); 
	show_footer();

	if(!checkSERIALNO())
        return;

	load_body();
	update_apn();
}

var sim1_apn = '<% nvram_get_x("","sim1_apn"); %>';
var sim2_apn = '<% nvram_get_x("","sim2_apn"); %>';

function fullFwUpload(){
	alert("Update device using QFlash program after 1 min!");
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_Settings_Content.asp";
	document.form.next_page.value = "";
	document.form.sys_settings_mode.value = "FULLFWUPDATE";
	document.form.submit();
}
function recoveryApplyRule(){
	showLoading();		
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_Settings_Content.asp";
	document.form.next_page.value = "";
	document.form.sys_settings_mode.value = "AUTORECOVERY";
	document.form.submit();
}
function morningRebootApplyRule(){
	showLoading();		
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_Settings_Content.asp";
	document.form.next_page.value = "";
	document.form.sys_settings_mode.value = "MORNINGREBOOT";
	document.form.submit();
}
function pingApplyRule(){
	showLoading();		
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_Settings_Content.asp";
	document.form.next_page.value = "";
	document.form.sys_settings_mode.value = "PING";
	document.form.submit();
}
function operationModeApplyRule(){
	showLoading();		
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_Settings_Content.asp";
	document.form.next_page.value = "";
	document.form.sys_settings_mode.value = "OPERATIONMODE";
	document.form.submit();
}
function applyRule2(){
	showLoading();
	document.form.action_mode.value = " ApplyApn ";
		document.form.current_page.value = "Advanced_Settings_Content.asp";
		document.form.next_page.value = "";
		document.form.submit();
}
function lteBandApplyRule(){
	showLoading();		
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_Settings_Content.asp";
	document.form.next_page.value = "";
	document.form.sys_settings_mode.value = "LTEBAND";
	document.form.submit();
}

function validForm(){
	return true;
}

function done_validating(action){
	refreshpage();
}

function blanktest(obj, flag){
	var value2 = eval("document.form."+flag+"2.value");

	if(obj.value == ""){
		if(value2 != "")
			obj.value = decodeURIComponent(value2);
		else
			obj.value = "";
		
		alert("<#JS_Shareblanktest#>");
		
		return false;
	}

	return true;
}

function update_apn(){
	var simcard = document.form.simcard.value;
	if(simcard == 1){
		document.form.modem_apn.value = sim1_apn;
	}else if(simcard == 2){
		document.form.modem_apn.value = sim2_apn;
	}
}
</script>
<style>
    .table th, .table td{vertical-align: middle;}
    .table input, .table select {margin-bottom: 0px;}
</style>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
    <div class="container-fluid" style="padding-right: 0px">
        <div class="row-fluid">
            <div class="span3">
                <center>
                    <div id="logo"></div>
                    <div id="company_name"><#Company_Name#></div>
                    <div id="product_name"><#Product_Name#></div>
                    <div id="model_name"><#Model_Name#></div>
                    <div id="model_name1"><#Model_Name1#></div>
                </center>
            </div>
            <div class="span9" >
                <div id="TopBanner"></div>
            </div>
        </div>
    </div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="current_page" value="Advanced_Settings_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="LANHostConfig;General;Storage;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="sys_settings">
    <input type="hidden" name="sys_settings_mode" value="">

    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <!--Sidebar content-->
                <!--=====Beginning of Main Menu=====-->
                <div class="well sidebar-nav side_nav" style="padding: 0px;">
                    <ul id="mainMenu" class="clearfix"></ul>
                    <ul class="clearfix">
                        <li>
                            <div id="subMenu" class="accordion"></div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="span9">
                <!--Body content-->
                <div class="row-fluid">
                    <div class="span12">
                        <div class="box well grad_colour_dark_blue">
                            <h2 class="box_head round_top"><#menu5_4#> - <#menu5_6_12#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#Modem_Settings_desc#></div>


      
          
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Network_Mode_Setting#></th>
                                        </tr>
										    <tr>
                                            <th  width="50%"><#Dial_Policy#></th>
						  <td>
						    <select name="dial_policy">
                                                 <option value="0" <% nvram_match_x("","dial_policy", "0","selected"); %>><#Dial_Policy_Sel0#></option>
							<option value="1" <% nvram_match_x("","dial_policy", "1","selected"); %>><#Dial_Policy_Sel1#></option>
							<option value="2" <% nvram_match_x("","dial_policy", "2","selected"); %>><#Dial_Policy_Sel2#></option>
							<option value="3" <% nvram_match_x("","dial_policy", "3","selected"); %>><#Dial_Policy_Sel3#></option>
						    </select>
						  </td>
                                        </tr>
										
                                        <tr>
                                            <th  width="50%"><#Network_Mode#></th>
						  <td>
						    <select name="operationModeSelect">
                                                  <option value="AUTO" <% nvram_match_x("","operationModeSelect", "AUTO","selected"); %>><#NetworkMode0#></option>
							   <option value="NR5G+LTE" <% nvram_match_x("","operationModeSelect", "NR5G+LTE","selected"); %>>NR5G+LTE</option>
							  <option value="NR5G" <% nvram_match_x("","operationModeSelect", "NR5G","selected"); %>><#NetworkMode1#></option>
                                                  <option value="LTE" <% nvram_match_x("","operationModeSelect", "LTE","selected"); %>><#NetworkMode2#></option>
                                                  <option value="WCDMA" <% nvram_match_x("","operationModeSelect", "WCDMA","selected"); %>>3G</option>
						    </select>
						  </td>
                                        </tr>
										
										<tr>
                                            <th width="50%"><#Roam#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="roam_enable_x_on_of">
                                                        <input type="checkbox" id="roam_enable_x_fake" <% nvram_match_x("", "roam_enable_x", "1", "value=1 checked"); %><% nvram_match_x("", "roam_enable_x", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="roam_enable_x" id="roam_enable_x_1" <% nvram_match_x("","roam_enable_x", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="roam_enable_x" id="roam_enable_x_0" <% nvram_match_x("","roam_enable_x", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
										
                                    </table>                                    
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="operationModeApplyRule();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>

                                        <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#apn_setting#></th>
                                        </tr>
										<tr>
                                            <th width="50%"><#Simcard#></th>
                                            <td>
                                                <select name="simcard" onclick="update_apn();">
                                                    <option value="1" <% nvram_match_x("", "simcard", "1", "selected"); %>><#Dial_Policy_Sel0#></option>
                                                    <option value="2" <% nvram_match_x("", "simcard", "2", "selected"); %>><#Dial_Policy_Sel1#></option>
                                                    <option value="3" <% nvram_match_x("", "simcard", "3", "selected"); %>><#Dial_Policy_Sel2#></option>
                                                    <option value="4" <% nvram_match_x("", "simcard", "4", "selected"); %>><#Dial_Policy_Sel3#></option>

                                                </select>
                                            </td>
                                        </tr>
										
                                        <tr>
                                            <th  width="50%"><#apn#></th>
                                            
                                            <td>
                                                <input id="modem_apn" name="modem_apn" maxlength="64" class="input" type="text" value=""/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="50%"><#pdp_type#></th>
                                            <td>
                                                <select name="modem_pdp_type" id="modem_pdp_type" class="input">
                                                    <option value="0" <% nvram_match_x("", "modem_pdp_type", "0", "selected"); %>>IPv4</option>
                                                    <option value="2" <% nvram_match_x("", "modem_pdp_type", "2", "selected"); %>>IPv6</option>
                                                    <option value="3" <% nvram_match_x("", "modem_pdp_type", "3", "selected"); %>>IPv4v6</option>
                                                </select>
                                            </td>
                                        </tr>

                                    </table>
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="applyRule2();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>


                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </form>

    <div id="footer"></div>
</div>
</body>
</html>
