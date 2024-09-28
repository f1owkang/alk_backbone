<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_5_1#></title>
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
    init_itoggle('portfilter_enable', change_portfilter_enabled);
});
function change_portfilter_enabled() {
    var v = document.form.portfilter_enable[0].checked;
    showhide_div('PFList_Block', v);
}

</script>
<script>

//var http_proto = '<% nvram_get_x("", "http_proto"); %>';
var PortList = [<% get_nvram_list("FirewallConfig", "PortList"); %>];
function initial(){
	show_banner(1);
	show_menu(5,5,6);
	show_footer();
	
    if(!checkSERIALNO())
        return;	
	change_portfilter_enabled();
	showPFList();
	load_body();

	
}

function applyRule(){
	//if(validForm())
	{
		showLoading();
		 document.form.group_id.value = "PortList";
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "Advanced_PortFiltering.asp";
		document.form.next_page.value = "";
		
		 pageChanged = 0;
		document.form.submit();
	}
	return true;
}
function markGroupPort(o, c, b) {
    document.form.group_id.value = "PortList";
    if (b == " Add ") {
        obj = document.form.portfilter_eport_x_0;
		if(obj.value==""){
			alert("<#JS_fieldblank#>");
			obj.focus();
			return false;
		}
		if (!validate_portrange(obj, "") /*|| !validate_range_sp(document.form.vts_lport_x_0, 1, 65535)*/)
				return false;
				
	    obj = document.form.portfilter_sport_x_0;
		if(obj.value==""){
			alert("<#JS_fieldblank#>");
			obj.focus();
			return false;
		}
		if (!validate_portrange(obj, "") /*|| !validate_range_sp(document.form.vts_lport_x_0, 1, 65535)*/)
				return false;
		if(!validForm())
		{
		    return false;
		}
//        if (validNewRow(c) == false)
//            return false;

       
    }
    pageChanged = 0;
    document.form.action_mode.value = b;
    return true;
}
//function showPFList(){
//	var i;
//	var code = '';
//	var proto, srcip, startport, endport;
//	if(PortList.length == 0)
//		code +='<tr><td colspan="7" style="text-align: center;"><div class="alert alert-info"><#IPConnection_PFList_Norule#></div></td></tr>';
//	else{
//	    for(i = 0; i < PortList.length; i++){
////		srcip = "*";
////		eport = "";
////		lport = "";
////		proto = PortList[i][3];
////		if(proto == "OTHER"){
////			proto = PortList[i][4];
////		}else{
////			if (proto == "BOTH")
////				proto = "TCP/UDP";
//			startport = PortList[i][0];
//			endport   = PortList[i][1];
////			if (PortList[i][2] != null && PortList[i][2] != "")
////				lport = PortList[i][2];
//////		}
////		if (PortList[i][5] != null && PortList[i][5] != "")
////			srcip = PortList[i][5];
//		code +='<tr id="row' + i + '">';
////		code +='<td>&nbsp;'             + PortList[i][6] + '</td>';
////		code +='<td width="18%">&nbsp;' + srcip + '</td>';
//        code +='<th width="45%">&nbsp;</th>';
//		code +='<td width="20%">&nbsp;' +  startport + '</td>';
//		code +='<td width="20%">&nbsp;' +endport + '</td>';
////		code +='<td width="10%">&nbsp;' + lport + '</td>';
////		code +='<td width="11%">&nbsp;' + proto + '</td>';
//		code +='<td width="5%" style="text-align: center;"><input type="checkbox" name="portfilter_enable" value="' + i + '" onClick="changeBgColor(this,' + i + ');" id="check' + i + '"></td>';
//		code +='</tr>';
//	    }
//		code += '<tr>';
//		code += '<td width="50%">&nbsp;</td>'
//		code += '<td width="45%">&nbsp;</td>'
//		code += '<td width="5%" style="text-align: right;"><button class="btn btn-danger" type="submit" onclick="markGroupPort(this, 64,\' Del \');" name="PortList"><i class="icon icon-minus icon-white"></i></button></td>';
//		code += '</tr>'
//	}
//	$j('#PFList_Block').append(code);
//}
function showPFList(){
	var i;
	var code = '';
	var proto, srcip, eport, sport;
	if(PortList.length == 0)
		code +='<tr><td colspan="7" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
	else{
	    for(i = 0; i < PortList.length; i++){
		srcip = "*";
		eport = "";
		lport = "";
		
//		if(proto == "OTHER"){
//			proto = PortList[i][4];
//		}else{
//			if (proto == "BOTH")
//				proto = "TCP/UDP";
			sport = PortList[i][0];
			eport = PortList[i][1];
//			if (VSList[i][2] != null && PortList[i][2] != "")
//				lport = PortList[i][2];
////		}
//		if (PortList[i][5] != null && PortList[i][5] != "")
//			srcip = PortList[i][5];
		code +='<tr id="row' + i + '">';
		code +='<td width="50%">&nbsp;'             + '</td>';
		code +='<td width="20%">&nbsp;' + sport + '</td>';
		code +='<td width="20%">&nbsp;' + eport + '</td>';
		
//		code +='<td width="10%">&nbsp;' + lport + '</td>';
//		code +='<td width="11%">&nbsp;' + proto + '</td>';
		code +='<td width="5%" style="text-align: center;"><input type="checkbox" name="PortList_s" value="' + i + '" onClick="changeBgColor(this,' + i + ');" id="check' + i + '"></td>';
		code +='</tr>';
	    }
		code += '<tr>';
		code += '<td width="10%">&nbsp;</td>'
		code += '<td width="10%">&nbsp;</td>'
		code += '<td width="75%">&nbsp;</td>'
		code += '<td width="5%" style="text-align: right;"><button class="btn btn-danger" type="submit" onclick="markGroupPort(this, 64,\' Del \');" name="PortList"><i class="icon icon-minus icon-white"></i></button></td>';
		code += '</tr>'
	}
	$j('#PFList_Block').append(code);
}
function validNewRow(max_rows) {
    if (document.form.portfilter_num_x_0.value >= max_rows) {
        alert("<#JS_itemlimit1#> " + max_rows + " <#JS_itemlimit2#>");
        return false;
    }

    if (document.form.portaddr_filter.value == "") {
        alert("<#JS_fieldblank#>");
        document.form.portaddr_filter.focus();
        document.form.portaddr_filter.select();
        return false;
    }
    return true;
}
function validate_portrange(o, v) {
    if (o.value.length == 0)
        return true;

    prev = -1;
    num = -1;
    num_front = 0;
    for (var i = 0; i < o.value.length; i++) {
        c = o.value.charAt(i);
        if (c >= '0' && c <= '9') {
            if (num == -1) num = 0;
            num = num * 10 + (c - '0');
        }
        else {
            if (num > 65535 || num == 0 || (c != ':' && c != '>' && c != '<' && c != ',')) {
                alert(o.value + " <#JS_validport#>");
                o.focus();
                o.select();
                return false;
            }

            if (c == '>') prev = -2;
            else if (c == '<') prev = -3;
            else if (c == ',') {
                prev = -4;
                num = 0;
            }
            else { //when c=":"
                if (prev == -4)
                    prev == -4;
                else {
                    prev = num;
                    num = 0;
                }
            }
        }
    }

    if ((num > 65535 && prev != -3) || (num < 1 && prev != -2) || (prev > num) || (num >= 65535 && prev == -2) || (num <= 1 && prev == -3)) {
        if (num > 65535) {
            alert(o.value + " <#JS_validport#>");
            o.focus();
            o.select();
            return false;
        }
        else {
            alert(o.value + " <#JS_validportrange#>");
            o.focus();
            o.select();
            return false;
        }
    } // wrong port 
    else {
        if (prev == -2) {
            if (num == 65535) o.value = num;
            else o.value = (num + 1) + ":65535";  //ex. o.value=">2000", it will change to 2001:65535
        }
        else if (prev == -3) {
            if (num == 1) o.value = num;
            else o.value = "1:" + (num - 1);     //ex. o.value="<2000", it will change to 1:1999
        }
        else if (prev == -4) {
            if (document.form.current_page.value == "Advanced_VirtualServer_Content.asp") {
                multi_vts_port = o.value.split(",");
                //o.value = multi_vts_port[0];
                split_vts_rule(multi_vts_port);
                return false;
            }
            else {
                alert(o.value + " <#JS_validport#>");
                o.focus();
                o.select();
                return false;
            }
        }
        else if (prev != -1)
            o.value = prev + ":" + num;
        else
            o.value = num;                  //single port number case;
    }
    return true;
}
function validForm() {
    var obj = document.form.portfilter_sport_x_0;
    if (!validate_portrange(obj, "") || !validate_range_sp(obj, 1, 65535)) {
        return fasle;
    }
    var obj1 = document.form.portfilter_eport_x_0;
    if (!validate_portrange(obj1, "") || !validate_range_sp(obj1, 1, 65535)) {
        return fasle;
    }
//	if (sw_mode == '4')
//		return true;

//	if (support_http_ssl()){
//		if (http_proto == "0" || http_proto == "2"){
//			if(!validate_range(document.form.misc_httpport_x, 80, 65535))
//				return false;
//		}
//		if (http_proto == "1" || http_proto == "2"){
//			if(!validate_range(document.form.https_wport, 81, 65535))
//				return false;
//		}
//		if (http_proto == "2"){
//			if (document.form.misc_httpport_x.value == document.form.https_wport.value){
//				alert("HTTP and HTTPS ports is equal!");
//				document.form.https_wport.focus();
//				document.form.https_wport.select();
//				return false;
//			}
//		}
//	}else{
//		if(!validate_range(document.form.misc_httpport_x, 80, 65535))
//			return false;
//	}

//	if(!validate_range(document.form.udpxy_wport, 1024, 65535))
//		return false;

//	if(found_app_sshd()){
//		if(!validate_range(document.form.sshd_wport, 22, 65535))
//			return false;
//	}

//	if(found_app_ftpd()){
//		if(!validate_range(document.form.ftpd_wport, 21, 65535))
//			return false;
//	}

	return true;
}



</script>
<style>
    .nav-tabs > li > a {
          padding-right: 6px;
          padding-left: 6px;
    }
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

    <input type="hidden" name="current_page" value="Advanced_PortFiltering.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="FirewallConfig;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="portfilter_num_x_0" value="<% nvram_get_x("", "portfilter_num_x"); %>" readonly="1" />

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
                            <h2 class="box_head round_top"><#menu5_5#> - <#menu5_5_9#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                   <!-- <div class="alert alert-info" style="margin: 10px;"><#FirewallConfig_display2_sectiondesc#></div>-->

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table ">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#menu5_5_9#></th>
                                        </tr>
                                         <tr>
                                            <th width="50%"><a class="help_tooltip"><#menu5_5_9#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="portfilter_enable_on_of">
                                                        <input type="checkbox" id="portfilter_enable_fake" <% nvram_match_x("", "portfilter_enable", "1", "value=1 checked"); %><% nvram_match_x("", "portfilter_enable", "0", "value=0"); %> />
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="portfilter_enable" id="portfilter_enable_1" <% nvram_match_x("", "portfilter_enable", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="portfilter_enable" id="portfilter_enable_0" <% nvram_match_x("", "portfilter_enable", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>   
                                      </table>  
                                     <table  width="100%"  cellpadding="4" cellspacing="0" class="table table-list"  id="PFList_Block">   
                                          <tr>                                         
                                            <th colspan="7" style="background-color: #E3E3E3;"><#IPConnection_PFList_title#></th>
                                         </tr>
                                     <tr>
                                            <td width="40%"><#PFList_title#></td>
                                            <td width="25%"><#Start_Port#></td>
                                            <td width="25%"><#End_Port#></td>
                                            
                                         
                                            <td width="5%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td >&nbsp;</td>
                                           <td>
                                                <input type="text" size="10" class="span12"  name="portfilter_sport_x_0" value="<% nvram_get_x("", "portfilter_sport_x_0"); %>" onkeypress="return is_portrange(this,event);" />
                                            </td>
                                           <td>
                                                <input type="text" size="10" class="span12" name="portfilter_eport_x_0" value="<% nvram_get_x("", "portfilter_eport_x_0"); %>" onKeyPress="return is_portrange(this,event);"/>
                                            </td>                                        
                                         
                                         
                                         
                                         
                                         
                                         
                                            
<!--                                         <tr>     
                                            <th width="50%"><#menu5_5_9#></th>
                                            <td width="18%">
                                                <input type="text" maxlength="5" class="input" size="10"  id="portfilter_sport_x_0"  name="portfilter_sport_x_0" value="<% nvram_get_x("", "portfilter_sport_x_0"); %>" onkeypress="return is_number(this,event);"/>
                                             </td>
                                            <td width="5%">&nbsp;-</td>
                                             
                                             <td width="18%">
                                                <input type="text" maxlength="5" class="input" size="10"  id="portfilter_eport_x_0"  name="portfilter_eport_x_0" value="<% nvram_get_x("", "portfilter_eport_x_0"); %>" onkeypress="return is_number(this,event);"/>
                                                
                                            </td>
                                        -->
                                            <td width="5%" style="text-align: left;border-top: 0 none;">
                                                <button class="btn" style="max-width: 219px" type="submit" onclick="return markGroupPort(this, 64, ' Add ');"  name="PortList" value="<#CTL_add#>" size="12"><i class="icon icon-plus"></i></button>
                                         </td>  
                                        </tr>
                                    </table>

                       
                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;"><center><input name="PortList" type="button submit" class="btn btn-primary"  style="width: 219px"  onclick="return applyRule();" value="<#CTL_apply#>"/></center></td>
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
