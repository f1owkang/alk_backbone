<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_11#></title>
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
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('help_enable');
});

</script>
<script>

<% login_state_hook(); %>

function initial(){
	show_banner(1);
	show_menu(5,7,5); 
	show_footer();

	if(!checkSERIALNO())
        return;

	document.form.NmsEnable.value= '<% nvram_get_x("", "NmsEnable"); %>'
	document.form.oneM2MEnable.value= '<% nvram_get_x("", "oneM2MEnable"); %>'
	document.form.oneM2MServerURL.value= '<% nvram_get_x("", "oneM2MServerURL"); %>'
	document.form.oneM2MAutoFwUpgrade.value= '<% nvram_get_x("", "oneM2MAutoFwUpgrade"); %>'

	load_body();
}

function nmsApplyRule(){
	showLoading();
		
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_NMS_Content.asp";
	document.form.next_page.value = "";
	document.form.nms_oneM2M_mode.value = "NMS";

	document.form.submit();
}
function oneM2MapplyRule(){
	
	showLoading();

	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_NMS_Content.asp";
	document.form.next_page.value = "";
	document.form.nms_oneM2M_mode.value = "oneM2M";
		
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
    <input type="hidden" name="current_page" value="Advanced_NMS_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="nms_oneM2M">
    <input type="hidden" name="nms_oneM2M_mode" value="">

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
                            <h2 class="box_head round_top"><#menu5_6#> - <#menu5_6_11#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#Adm_NMS_desc#></div>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">NMS</th>
                                        </tr>
                                        <tr>
                                            <th width="50%">Enable NMS Agent</th>
						  <td>
						    <select name="NmsEnable">
						        <option value="disable">Disable</option>
						        <option value="enable">Enable</option>
						    </select>
						  </td>
                                        </tr>
                                        <tr>
                                            <th>Server IP</th>
                                            <td>
                                                <input name="NmsServerIp" maxlength="32" class="input" type="text" value="<% nvram_get_x("","NmsServerIp"); %>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Server Port</th>
                                            <td>
                                                <input name="NmsServerPort" maxlength="32" class="input" type="text" value="<% nvram_get_x("","NmsServerPort"); %>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Report Interval(sec)</th>
                                            <td>
                                                <input name="NmsReportInterval" maxlength="32" class="input" type="text" value="<% nvram_get_x("","NmsReportInterval"); %>"/>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="nmsApplyRule();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;">OneM2M</th>
                                        </tr> 
                                        <tr>
                                            <th width="50%">Enable OneM2M Agent</th>
						  <td>
						    <select name="oneM2MEnable">
						        <option value="disable">Disable</option>
						        <option value="enable">Enable</option>
						    </select>
						  </td>
                                        </tr>
                                        <tr>
                                            <th width="50%">Server Type</th>
						  <td>
						    <select name="oneM2MServerURL">
						        <option value="0">Test Server</option>
						        <option value="1">Real Server</option>
						    </select>
						  </td>
                                        </tr>
                                        <tr>
                                            <th width="50%">Automatic FW Update After Boot</th>
						  <td>
						    <select name="oneM2MAutoFwUpgrade">
						        <option value="0">Disable</option>
						        <option value="1">Enable</option>
						    </select>
						  </td>
                                        </tr>
                                        <tr>
                                            <th>Service Code</th>
                                            <td>
                                                <input name="oneM2MServiceCode" maxlength="32" class="input" type="text" value="<% nvram_get_x("","oneM2MServiceCode"); %>"/>
                                            </td>
                                        </tr>
                                    </table> 
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="oneM2MapplyRule();" type="button" value="<#CTL_apply#>" /></center>
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
