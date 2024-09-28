<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_title#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>

<script>
    var $j = jQuery.noConflict();
var map_code = "";

function initial(){
	show_banner(0);
	show_menu(3,11,4);
	show_footer();

	if (!checkSERIALNO())
	    return;
	    
	    

	$j("#chosen-search-field-input").val("<#Number#>");

}


function applyRule() {
    if (validForm()) {
        showLoading();
        document.form.next_page.value = "";
        document.form.action_mode.value = " Apply ";
		document.form.handle_sms_mode.value = "SEND";
        document.form.submit();
    }
}
function validForm() {
    /*
    if(document.form.imei.value.length != 15){
    return false;
    }
    var i;
    for(i = 0; i < document.form.imei.value.length; i++) {
    if (document.form.imei.value.charAt(i) < '0' || document.form.imei.value.charAt(i) > '9') {
    return false;
    }
    }*/
    return true;
}
//var sendFreeback = -1;
//$("#btn-send").bind('click', function(e) {

//    var param = { funcNo: 1032, number: $("#chosen-search-field-input").val(), content: $("#chat-input").val() };
//    request(param, function(data) {
//        var flag = data.flag;
//        var error_info = data.error_info;
//        sendFreeback = -1;

//        if (flag == "1") {//正确

//            var iTimes = 0;
//            do {
//                setTimeout(function() {

//                    getSMSFreback();

//                }, 1000);
//                if (sendFreeback) {
//                    Alert(get_lan_sms('sendPass'));
//                    return;
//                }

//                iTimes++;
//                if (iTimes == 4) {
//                    Alert(get_lan_sms('sendFail'));
//                    return;
//                }
//            } while (sendFreeback != 1 && iTimes < 5);
//            Alert(get_lan_sms('sendPass'));

//        } else {//错误
//            Alert(error_info);

//        }
//    });


//    //////////////////////////////////




//});



//$("#chosen-search-field-input").bind('click', function(e) {
//    $("#chosen-search-field-input").val("");

//});
//$("#chosen-search-field-input").blur(function() {
//    if ($("#chosen-search-field-input").length == 0) {
//        $("#chosen-search-field-input").val(get_lan_sms('number'));
//    }
//});
//function getSMSFreback() {

//    var param = { funcNo: 1033 };
//    request(param, function(data) {
//        var flag = data.flag;
//        var error_info = data.error_info;

//        if (flag == "1") {//正确
//            var result = data.results[0];
//            var resultSend = result.SendResult;
//            sendFreeback = resultSend;
//            return sendFreeback;

//        } else {//错误
//            Alert(error_info);
//            return 3;

//        }
//    });
//    return 3;

//}
</script>

<style>
    table#menu_body tr td.head {text-align: center;}
    table#menu_body tr td {vertical-align: top;}
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

    <input type="hidden" name="current_page" value="smsSend.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="General;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="handle_sms">
    <input type="hidden" name="handle_sms_mode" value="">

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
                            <h2 class="box_head round_top"><#menu11#> - <#menu5_11_3#></h2>
                            <div class="round_bottom">

                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                   
                                    <div id="smsChatRoom">
                                     <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table" >
                                              <tr>
                                              <th style="border-top-width: 0px;" width="3%"><#Phone_nume#></th>
                                              <td style="border-top-width: 0px;">
	                                            <div id="chosenUser"  style="width:514px;">
		                                            <div id="chosenUserList">
			                                            <select id="chosenUserSelect" multiple="" class="chosen-select-deselect" style="display: none;">
                                			           
			                                          <!--  <div class="chosen-container chosen-container-multi" style="width: 740px;" title="" id="chosenUserSelect_chosen">-->
			                                            <ul class="chosen-choices">
			                                            <li class="search-field">
			                                                <input type="text" name="number" id="number" maxlength="40"   class="default" autocomplete="off" style="width: 508px;" onchange="txtChange()">
			                                            </li>
			                                            </ul>
			                                       <!--     </div>-->

	                                                </div>
                                                </div>
                                                </td>
                                              </tr>
                                                <h2 id="chosenUser1" class="hide"></h2>
	                                            <div id="chatpanel" style="width:472px;display: none;">
		                                            <div class="clear-container">
			                                            <div id="chatlist">
                                            				
			                                            </div>
		                                            </div>
	                                            </div>
	                                          <tr>
	                                          <th style="vertical-align:top;padding-top:15px;border-top-width: 0px;"><#Content#></th>
	                                          <td style="border-top-width: 0px;">
	                                            <div id="inputpanel" style="width: 504px;">
		                                            <div class="chatform">
			                                            <div class="chattextinput">
				                                            <textarea name="content" id="content"  class="form-control"></textarea>
			                                            </div>
			                                            <div class="chatfun row" >
				                                            <div id="toolbar" class="ext col-xs-8">
              
				                                            </div>
				                                            <div class="text-right">
				                                                 <input type="submit" id="btn-send" class="common-btn"  onclick="applyRule();" value="<#Send#>" style="margin-left: 450px;"></input>
                                				                              
				                                            </div>
			                                            </div>
		                                            </div>
	                                            </div>
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
    </div>

    </form>
    <div id="footer"></div>
</div>

</body>
</html>
