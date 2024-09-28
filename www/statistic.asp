<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_5#></title>
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
        //init_itoggle('fw_lw_enable', change_lw_enable);
    });

var last_bytes_rx = 0;
var last_bytes_tx = 0;
;
var last_time = 0;
//var sysinfo = <% json_system_status(); %>;
//var uptimeStr = "<% uptime(); %>";
////var timezone = uptimeStr.substring(26,31);
////var newformat_systime = uptimeStr.substring(8,11) + " " + uptimeStr.substring(5,7) + " " + uptimeStr.substring(17,25) + " " + uptimeStr.substring(12,16);  //Ex format: Jun 23 10:33:31 2008
////var systime_millsec = Date.parse(newformat_systime); // millsec from system
////var JS_timeObj = new Date(); // 1970.1.

</script>
<script>

<% wanlink(); %>

var $j = jQuery.noConflict();

window.performance = window.performance || {};
performance.now = (function() {
	return performance.now ||
	performance.mozNow ||
	performance.msNow ||
	performance.oNow ||
	performance.webkitNow ||
	function() { return new Date().getTime(); };
})();

function initial(){
	show_banner(1);
	show_menu(5,7,2);
	
	show_footer();

    if(!checkSERIALNO())
        return;

	showclock();
	
	
	id_update_wanip = setTimeout("update_wanip();", 2500);
}
function bytesToIEC(bytes, precision){
	var absval = Math.abs(bytes);
	var kilobyte = 1024;
	var megabyte = kilobyte * 1024;
	var gigabyte = megabyte * 1024;
	var terabyte = gigabyte * 1024;
	var petabyte = terabyte * 1024;

	if (absval < kilobyte)
		return bytes + ' B';
	else if (absval < megabyte)
		return (bytes / kilobyte).toFixed(precision) + ' KiB';
	else if (absval < gigabyte)
		return (bytes / megabyte).toFixed(precision) + ' MiB';
	else if (absval < terabyte)
		return (bytes / gigabyte).toFixed(precision) + ' GiB';
	else if (absval < petabyte)
		return (bytes / terabyte).toFixed(precision) + ' TiB';
	else
		return (bytes / petabyte).toFixed(precision) + ' PiB';
}

function kbitsToRate(kbits, precision){
	var absval = Math.abs(kbits);
	var megabit = 1000;
	var gigabit = megabit * 1000;

	if (absval < megabit)
		return kbits + ' Kbps';
	else if (absval < gigabit)
		return (kbits / megabit).toFixed(precision) + ' Mbps';
	else
		return (kbits / gigabit).toFixed(precision) + ' Gbps';
}

function secondsToDHM(seconds){
	var days, hours, minutes;

	days = Math.floor(seconds / 86400);
	minutes = Math.floor(seconds / 60);
	hours = (Math.floor(minutes / 60)) % 24;
	minutes = minutes % 60;

	hours = hours < 10 ? ('0'+hours) : hours;
	minutes = minutes < 10 ? ('0'+minutes) : minutes;

	return days+"<#Day#>".substring(0,1)+" "+hours+"<#Hour#>".substring(0,1)+" "+minutes+"<#Minute#>".substring(0,1);
}
function showclock(){
	JS_timeObj.setTime(systime_millsec);
	systime_millsec += 1000;
	JS_timeObj2 = JS_timeObj.toString();
	JS_timeObj2 = JS_timeObj2.substring(0,3) + ", " +
	              JS_timeObj2.substring(4,10) + "  " +
				  checkTime(JS_timeObj.getHours()) + ":" +
				  checkTime(JS_timeObj.getMinutes()) + ":" +
				  checkTime(JS_timeObj.getSeconds()) + "  " ;
				  
	var h = sysinfo.uptime.hours < 10 ? ('0'+sysinfo.uptime.hours) : sysinfo.uptime.hours;
	var m = sysinfo.uptime.minutes < 10 ? ('0'+sysinfo.uptime.minutes) : sysinfo.uptime.minutes;
    
	$("system_time").innerHTML = JS_timeObj2;
	
	$("uptimeInfo").innerHTML = sysinfo.uptime.days + "<#Day#>".substring(0,1) + " " + h+"<#Hour#>".substring(0,1) + " " + m+"<#Minute#>".substring(0,1);
	fill_info();
	setTimeout("showclock()", 1000);
}
//function getDisplayVolume1(volume, isSpeed) {
//	volume = parseInt(volume, 10);
//	if (volume == "" || volume == "0") {
//		return "";
//	}
//	var needReverse = false;
//	if(volume < 0){
//		needReverse = true;
//		volume = 0 - volume;
//	}
//	var numberOfBytesInOneB = 1;
//	var numberOfBytesInOneKB = numberOfBytesInOneB * 1024;
//	var numberOfBytesInOneMB = numberOfBytesInOneKB * 1024;
//	var numberOfBytesInOneGB = numberOfBytesInOneMB * 1024;
//	var numberOfBytesInOneTB = numberOfBytesInOneGB * 1024;

//    var labelForOneB = isSpeed ? 'b' : 'B';
//    var labelForOneKB = isSpeed ? 'Kb' : 'KB';
//    var labelForOneMB = isSpeed ? 'Mb' : 'MB';
//    var labelForOneGB = isSpeed ? 'Gb' : 'GB';
//    var labelForOneTB = isSpeed ? 'Tb' : 'TB';

//    if (isSpeed) {
//        volume = volume * 8;
//    }
//    var vol = volume / numberOfBytesInOneTB;
//	var displayString = roundToTwoDecimalNumber(vol) + labelForOneTB;
//	if (vol < 0.5) {
//		vol = volume / numberOfBytesInOneGB;
//		displayString = roundToTwoDecimalNumber(vol) + labelForOneGB;
//	
//		if (vol < 0.5) {
//			vol = volume / numberOfBytesInOneMB;
//			displayString = roundToTwoDecimalNumber(vol) + labelForOneMB;
//	        if(isSpeed) {
//				if (vol < 0.5) {
//					vol = volume / numberOfBytesInOneKB;
//					displayString = roundToTwoDecimalNumber(vol) + labelForOneKB;

//					if (vol < 0.5) {
//						vol = volume;
//						displayString = roundToTwoDecimalNumber(vol) + labelForOneB;
//					}
//				}
//			}
//		}
//	}
//	if(needReverse){
//		displayString = "-" + displayString;
//	}
//	return displayString;
//}
function fill_wan_bytes(rx,tx,now){
	if (rx > 0 || tx > 0){
		var diff_rx = 0;
		var diff_tx = 0;
		if (last_time > 0 && now > last_time){
			var diff_time = (now - last_time);
			if (last_bytes_rx > 0){
				if (rx < last_bytes_rx){
					if (last_bytes_rx <= 0xFFFFFFFF && last_bytes_rx > 0xE0000000)
						diff_rx = (0xFFFFFFFF - last_bytes_rx) + rx;
				}else
					diff_rx = rx - last_bytes_rx;
				diff_rx = Math.floor(diff_rx * 8 / diff_time);
			}
			if (last_bytes_tx > 0){
				if (tx < last_bytes_tx){
					if (last_bytes_tx <= 0xFFFFFFFF && last_bytes_tx > 0xE0000000)
						diff_tx = (0xFFFFFFFF - last_bytes_tx) + tx;
				}else
					diff_tx = tx - last_bytes_tx;
				diff_tx = Math.floor(diff_tx * 8 / diff_time);
			}
		}
		last_bytes_rx = rx;
		last_bytes_tx = tx;
		last_time = now;
		
		$("WANBytesRX_s").innerHTML = bytesToIEC(rx,2);
		$("WANBytesTX_s").innerHTML = bytesToIEC(tx,2);
	}else{
		//$("row_bytes").style.display = "none";
		//$("row_brate").style.display = "none";
	}
}
function fill_info(){
	var now = performance.now();
  
    fill_wan_bytes(wanlink_bytes_rx(), wanlink_bytes_tx(), now);
     $("MemoryTotal").innerHTML =sysinfo.ram.total+" kB" ;
    $("MemoryLeft").innerHTML =sysinfo.ram.free+" kB" ;

//	fill_status(wanlink_status(), wanlink_type(), simcard_status(), signal_strength(), rsrp(), rsrq(), cellid(),signal_strength_5g(), rsrp_5g(),rsrq_5g());

//	fill_man_addr4(wanlink_ip4_man(), wanlink_gw4_man());
//	
//	$("WANIP4").innerHTML = wanlink_ip4_wan();

//	
//	showtext($("model_version"), '<% nvram_get_x("",  "model_version"); %>');

	
	

}

function update_wanip(){
	clearTimeout(id_update_wanip);
	$j.ajax({
		url: '/status_wanlink.asp',
		dataType: 'script',
		cache: true,
		error: function(xhr){
			;
		},
		success: function(response){
			fill_info();
			id_update_wanip = setTimeout("update_wanip();", 2500);
		}
	});
}

function submitInternet(v){
//	parent.showLoading();
//	document.internetForm.action = "wan_action.asp";
//	document.internetForm.wan_action.value = v;
//	document.internetForm.modem_prio.value = $("modem_prio").value;
//	document.internetForm.sim_slot.value = $("sim_slot").value;
//	document.internetForm.submit();
}

</script>
<style>
.nav-tabs > li > a {
    padding-right: 6px;
    padding-left: 6px;
}

.radio.inline + .radio.inline,
.checkbox.inline + .checkbox.inline {
    margin-left: 3px;
}
.table-list td {
    padding: 6px 4px;
}
.table-list input,
.table-list select {
    margin-top: 0px;
    margin-bottom: 0px;
}
.table-list tr:nth-child(2) {
    font-size: 75%;
    font-weight: bold;
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

    <input type="hidden" name="current_page" value="statistic.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">

    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">

<!--    <input type="hidden" name="filter_lw_date_x" value="<% nvram_get_x("","filter_lw_date_x"); %>">
    <input type="hidden" name="filter_lw_time_x" value="<% nvram_get_x("","filter_lw_time_x"); %>">
    <input type="hidden" name="filter_lw_num_x_0" value="<% nvram_get_x("", "filter_lw_num_x"); %>" readonly="1">-->

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
                            <h2 class="box_head round_top"><#menu5_6#> - <#menu5_6_5#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                 <!--   <div class="alert alert-info" style="margin: 10px;"><#FirewallConfig_display1_sectiondesc#></div>-->

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                       <tr>
                                                <th colspan="2" style="background-color: #E3E3E3;"><#Statistics#></th>
                                       </tr>                                    
                                       <tr>
                                       <th ><#General_x_SystemTime_itemname#></th>
                                            <td id="system_time" colspan="3"   name="system_time" ></td>
                                      </tr>
                                        <tr>
                                       <th ><#SI_Uptime#></th>
                                            <td id="uptimeInfo" colspan="3"   name="uptimeInfo" ></td>
                                      </tr>
                                      
                                        <tr>
                                                <th colspan="2" style="background-color: #E3E3E3;"><#Memory#></th>
                                       </tr>  
                                          <tr  >
                                               <th><#MemoryTotal#></th>
                                               <td id="MemoryTotal" colspan="3"   name="MemoryTotal" ></td>                                           
                                         </tr>  
                                         <tr  >
                                               <th><#MemoryLeft#></th>
                                               <td id="MemoryLeft" colspan="3"   name="MemoryLeft" ></td>                                           
                                         </tr>  
                                       <tr>
                                             <!--   <th colspan="2" style="background-color: #E3E3E3;"><#Data_usage#></th>
                                       </tr>    
                                         <tr  >
                                               <th><#WAN_RX_bytes#></th>
                                               <td id="WANBytesRX_s" colspan="3"   name="WANBytesRX_s" ></td>                                           
                                         </tr>
                                          <tr  >
                                                <th><#WAN_TX_bytes#></th>
                                               <td id="WANBytesTX_s" colspan="3"   name="WANBytesTX_s" ></td>                                           
                                         </tr>      -->                             
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
