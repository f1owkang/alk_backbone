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
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/underscore.base.js"></script>
<script type="text/javascript" src="/jquery.tmpl.js"></script>
<script type="text/javascript" src="/util.js"></script>

<script>
    var $j = jQuery.noConflict();
var map_code = "";
    var smsmonitor = [<% get_sms(1); %>];
    var smsOut = getsms();

function initial(){
	show_banner(0);
	show_menu(3,11,2);
	show_footer();

	if (!checkSERIALNO())
	    return;
	$j("#checkbox-all").removeAttr("checked");
	getAllSMS();

	bindingEvents(); 
}
function update_smsOut(e) {
    $j.ajax({
        url: '/sms_out.asp',
        dataType: 'script',
        error: function(xhr) {
            ;
        },
        success: function(response) {
            smsmonitor = smsmonitor_last;
            nmap_fullscan = nmap_fullscan_last;
            smsOut = [];
            smsOut = getsms();
            //show_clients_wifi();
            getAllSMS();
            
        }
    });
}
//短信删除事件处理
deleteSelectedSimMsgClickHandler = function() {
    var checkbox = $j("input[name=msgId]:checked", "#simMsgList_container");
    var msgIds = [];
    for (var i = 0; i < checkbox.length; i++) {
       if(checkbox[i].style.display != "none")
            msgIds.push($j(checkbox[i]).val());
    }
    if (msgIds.length == 0) {
        return false;
    }
    if (confirm("<#confirm_sms_delete#>")) {
        showLoading();	
        var idsString = "";	
        for (var i = 0; i < msgIds.length; i++) {
              if( msgIds[i])
              {      
	              idsString=idsString+msgIds[i];    
	          } 
	          if(i+1 <msgIds.length)
	             idsString= idsString+"|";
	     } 
	     document.form.sms_id.value =idsString;//id    
	     document.form.action_mode.value = " Apply ";
	     document.form.current_page.value = "smsOutbox.asp";
	     document.form.next_page.value = "smsOutbox.asp";
	     document.form.box_type.value = "1";//删除类型 ：发送或者收件箱 
	     document.form.handle_sms_mode.value = "DELETE";
	     document.form.submit();
	   
    }

}
//点击短信列表条目
simsmsItemClickHandler = function(type, id, num) { 
    if (type == "0") {
         document.form.action_mode.value = " Apply ";
	     document.form.current_page.value = "smsOutbox.asp";
	     document.form.next_page.value = "smsOutbox.asp";
	     document.form.sms_id.value = id;
	     document.form.handle_sms_mode.value = "MODIFYTYPE";
	     document.form.submit();
         $j(".simMsgList-item-class-" + id, "#simMsgTableContainer").removeClass('font-weight-bold');
     }
}

//将被checked的条目添加到self.checkedItem中，用于在滚动还原checkbox
checkboxClickHandler = function(id) {
    checkDeleteBtnStatus();
};

//获取已选择的条目
getSelectedItem = function() {
    var selected = [];
    var checkedItem = $j("#smslist-table input:checkbox:checked");
    checkedItem.each(function(i, e) {
        selected.push($j(e).val());
    });
    return selected;
};

//删除按钮是否禁用
checkDeleteBtnStatus = function() {
    var size = getSelectedItem().length;
    if (size == 0) {
        disableBtn($j("#smslist-delete"));
    } else {
        enableBtn($j("#smslist-delete"));
    }
};

//刷新短消息列表
refreshClickHandler = function() {
    $j("#smslist-table").empty();
    disableBtn($j("#smslist-delete"));
    disableCheckbox($j("#smslist-checkAll", "#smsListForm"));
    init();
    renderCheckbox();
};



//删除选中的短消息
deleteSelectClickHandler = function() {
    if (confirm("confirm_sms_delete")) {
        var items = getIdsBySelectedIds();
        var param = { funcNo: 1034, box: "inbox", id: items.ids };


        request(param, function(data) {
            var flag = data.flag;
            var error_info = data.error_info;

            if (flag == "1") {//正确

                var result = data.results[0];
            } else {//错误
                alert(error_info);


            }

        });
    }


}


function getIdsBySelectedIds() {
    var nums = [];
    var resultIds = [];
    var normalIds = [];
    var groups = [];
    var selectedItem = getSelectedItem();
    $.each(selectedItem, function(i, e) {
        var checkbox = $j("#checkbox" + e);
        if (checkbox.attr("groupid")) {
            groups.push(checkbox.attr("groupid"));
        } else {
            nums.push(getLastNumber(checkbox.attr("number"), config.SMS_MATCH_LENGTH));
        }
    });

}

/**
* 删除按钮禁用可用处理
* @method checkDeleteBtnStatus
*/
checkDeleteBtnStatus = function() {
    var size = getSelectedItem().length;
    if (size == 0) {
        disableBtn($j("#smslist-delete"));
    } else {
        enableBtn($j("#smslist-delete"));
    }
};
//事件绑定
bindingEvents = function() {
    $j("#smslist-table p.checkbox").die().live("click", function() {
        checkboxClickHandler($(this).attr("id"));
    });

    $j("#smslist-checkAll", "#smsListForm").die().live("click", function() {
        checkDeleteBtnStatus();
    });

    $j(".smslist-item-msg", "#simMsgTableContainer").die().live("click", function() {
        var $this = $(this).addClass('showFullHeight');
        $('.smslist-item-msg.showFullHeight', '#simMsgTableContainer').not($this).removeClass('showFullHeight');
    });
    $j("#simMsgList_container p.checkbox, #simMsgListForm #simMsgList-checkAll").die().live("click", function() {
        checkboxClickHandler();
    });
}
function check_full_scan_done() {
    if (nmap_fullscan != "1") {
        $j("LoadingBar").style.display = "none";
        //$("refresh_list").disabled = false;
        if (sw_mode == "3") {
            $j('.popover_top').popover({ placement: 'top' });
            $j('.popover_bottom').popover({ placement: 'bottom' });
        } else {
            $j('.popover_top').popover({ placement: 'right' });
            $j('.popover_bottom').popover({ placement: 'right' });
        }
    } else {
        $j("LoadingBar").style.display = "block";
        //$("refresh_list").disabled = true;
        setTimeout("update_smsOut();", 2000);
    }
}

var resultMessages = [];
function getAllSMS() {
        resultMessages = parseMessages(smsOut);
        renderSimMessageList(resultMessages);
//    var param = { funcNo: 1034, box: "inbox"
//    };


//    request(param, function(data) {
//        var flag = data.flag;
//        var error_info = data.error_info;

//        if (flag == "1") {//正确

//            var result = data.results[0];

//            resultMessages = parseMessages(result.info_arr);
//            renderSimMessageList(resultMessages);



//        } else {//错误
//            alert(error_info);


//        }

//    });

}

function parseMessages(messages, isReport) {
    var result = [];
    for (var i = 0; i < messages.length; i++) {
        var oneMessage = {};
     
      oneMessage.tag = messages[i][0];
            
      if (oneMessage.tag != 1)
            continue;
        oneMessage.id = messages[i][1];
        oneMessage.type = messages[i][2];
        oneMessage.time = messages[i][3];
		oneMessage.number = messages[i][4];
		oneMessage.content = messages[i][5];

        result.push(oneMessage);
    }
    if (true) {
        var ids = [];
        var tmpResult = [];
        for (var i = result.length; i--; ) {
            var n = result[i];
            var idx = $j.inArray(n.id, ids);
            if (idx == -1) {
                ids.push(n.id);
                tmpResult.push(n);
            } else {
                if (n.content.length > tmpResult[idx].content.length) {
                    tmpResult[idx] = n;
                }
            }
        }
        return _.sortBy(tmpResult, function(n) {
            return 0 - n.id;


        });
    } else {
        return result;
    }
}
//清楚短信列表内容
cleanSimSmsList = function() {
    $j("#simMsgList_container").empty();
};
function renderSimMessageList(messages) {
    if (simMsgListTmpl == null) {
        simMsgListTmpl = $j.template("simMsgListTmpl", $j("#simMsgListTmpl"));
    }
    cleanSimSmsList();
    //    $("#simMsgList_container").html($.tmpl("simMsgListTmpl", {
    //        data: messages
    //    }));
    $j("#simMsgListTmpl").tmpl({ data: messages }).appendTo('#simMsgList_container');
    addPageSize1("pageSize1");
    //对表格数据进行分页处理
    tablePagingShow1("simMsgList_table", "pageItems1", "pageInfoShow1", "dataSum1", "pageSize1", "changePage1", "goPage1");

}
   function addPageSize1(sltID) {
        var sltNode = document.getElementById(sltID);
        if(sltNode == null)
             return;
        sltNode.innerHTML = "";
        for (var i = 10; i < 30; i++) {
            var opt = new Option(i, i);
            sltNode.options[i - 10] = opt;
        }
    }
    /**
    * 实现页面跳转
    * @param tableId：table的id，为标签<table id=tableId>
    * @param pageUlID：实现分页操作功能项，为标签<ul id=pageUlID>
    * @param pageInfoID：显示分页信息的元素节点，为标签<a id=pageInfoID>
    * @param dataSumID：显示数据总量的元素节点，为标签<a id=dataSumID>
    * @param pageSizeID：显示每页数目的元素节点，为标签<select id=pageSizeID>
    * @param changePageID：要跳转的页面值，为标签<input id=changePageID type="text">
    * @param goPageID：页面跳转操作，为标签<a id=goPageID>
    */
    function tablePagingShow1(tableId, pageUlID, pageInfoID, dataSumID, pageSizeID, changePageID, goPageID) {
        var pageSize = 10;     //每页显示的记录条数，默认是15条
        var curPage = 0;       //当前页
        var lastPage;          //最后页
        var direct = 0;        //方向
        var totalRows;         //总行数
        var totalPage;         //总页数
        var begin;             //当前页面对应的起始行号
        var end;               //当前页面对应的终止行号

        //获取表格的行数信息
        var tb = document.getElementById(tableId);
        var tbody = tb.getElementsByTagName("tbody")[0];
        var trs = tbody.getElementsByTagName("tr");

        totalRows = trs.length;           // 求这个表的总行数，不带属性名称行
        if(trs.length <1)
            return ;

        totalPage = totalRows % pageSize == 0 ? totalRows / pageSize : Math.floor(totalRows / pageSize) + 1;  //根据记录条数，计算页数 。  Math.floor():返回不大于的最大整数
        curPage = 1;           // 设置当前为第一页
        displayPage();         //显示第一页

        document.getElementById(pageInfoID).innerHTML = curPage + "/" + totalPage +"<#page#>";              // 显示表格分页信息
        document.getElementById(dataSumID).innerHTML = "<#Total#>" + ": "+totalRows + "";                           // 显示数据总量
        //document.getElementById(pageSizeID).value = pageSize;                                                    //每页显示的数据量

        //页面跳转处理
        var nodes = document.getElementById(pageUlID).getElementsByTagName("a");
        for (var j = 0; j < nodes.length; j++) {
            var nodeA = nodes[j];
            //nodeA.addEventListener("click",function(){
            nodeA.onclick = function() {
                var title = this.getAttribute("name");
                switch (title) {
                    case "firstPage": 
                        {
                            curPage = 1;
                            direct = 0;
                            displayPage();
                            break;
                        }
                    case "prePage": 
                        {
                            direct = -1;
                            displayPage();
                            break;
                        }
                    case "nextPage": 
                        {
                            direct = 1;
                            displayPage();
                            break;
                        }
                    case "lastPage": 
                        {
                            curPage = totalPage;
                            direct = 0;
                            displayPage();
                            break;
                        }
                }
            }; //);
        }

        //保证输入正整数
        document.getElementById(changePageID).addEventListener("keyup", function() {
            if (this.value.length == 1) {
                this.value = this.value.replace(/[^1-9]/g, '')
            } else {
                this.value = this.value.replace(/\D/g, '')
            }
        });

        document.getElementById(changePageID).addEventListener("afterpaste", function() {
            if (this.value.length == 1) {
                this.value = this.value.replace(/[^1-9]/g, '')
            } else {
                this.value = this.value.replace(/\D/g, '')
            }
        });

        //跳转到指定页面
        document.getElementById(goPageID).addEventListener("click", function changePage() {
            if (document.getElementById(changePageID).value == "") {
                alert("<#jumpTopageError#>");
                return;
            }
            curPage = document.getElementById(changePageID).value * 1;
            console.log(curPage);
            var reg = /^\+?[1-9][0-9]*$/;
            if (!reg.test(curPage)) {
                alert("<#SMS_inputInt#>");
                return;
            }
            if (curPage > totalPage) {
                alert("<#ExceedDataPage#>");
                document.getElementById(changePageID).value = "";
                return;
            }
            direct = 0;
            displayPage();
        });

        //设置每页显示记录数
        document.getElementById(pageSizeID).addEventListener("change", function setPageSize() {
            var sltNode = document.getElementById(pageSizeID);
            var index = sltNode.selectedIndex;
            pageSize = sltNode.options[index].value;
            console.log(pageSize);
            var reg = /^\+?[1-9][0-9]*$/;
            if (!reg.test(pageSize)) {
                alert("<#SMS_inputInt#>");
                return;
            }
            totalRows = trs.length;
            totalPage = totalRows % pageSize == 0 ? totalRows / pageSize : Math.floor(totalRows / pageSize) + 1;    //根据记录条数，计算页数
            curPage = 1;         //当前页
            direct = 0;          //方向
            displayPage();
        });

        function displayPage() {
            console.log("displayPage" + ";Current Page：" + curPage);
            if (curPage <= 1 && direct == -1) {
                direct = 0;
                alert("<#First_page#>");
                return;
            } else if (curPage >= totalPage && direct == 1) {
                direct = 0;
                alert("<#Last_page#>");
                return;
            }

            lastPage = curPage;
            //计算当前页
            if (totalRows > pageSize) {
                curPage = ((curPage + direct + totalRows) % totalRows);
            } else {
                curPage = 1;
            }

            document.getElementById(pageInfoID).innerHTML = curPage + "/" + totalPage + "<#page#>";   // 显示当前多少页

            begin = (curPage - 1) * pageSize;    // 起始记录号
            end = begin + 1 * pageSize;          // 末尾记录号

            if (end > totalRows) {
                end = totalRows;
            }

            //隐藏不显示的行
            for (var k = 0; k < trs.length; k++) {
                var nodeTr = trs[k];
                var tds = nodeTr.getElementsByTagName("input");
                if (k >= begin && k < end) {
                    nodeTr.style.display = "table-row";
                    tds[0].style.display = "table-row";
                } else {
                    nodeTr.style.display = "none";
                    tds[0].style.display = "none";
                }
            }
        }

    }
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

    <input type="hidden" name="current_page" value="smInbox.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="General;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="handle_sms">
    <input type="hidden" name="handle_sms_mode" value="">
    <input type="hidden" name="box_type" value="">
    <input type="hidden" name="sms_id" value="">

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
                            <h2 class="box_head round_top"><#menu11#> - <#menu5_11_2#></h2>
                            <div class="round_bottom">

                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                   
                                        <div class="simMsgList-btns smslist-btns">
                                                    <div class="row-fluid" >
                                                              <div class="sms-operator">
                                                                   <!-- <span id="boxmessage"style="margin-left: 20px;"><#Outbox#></span>-->
                                                                    <div>
                                                                        <input id="smslist-delete" type="button" class="common-btn" value="<#CTL_del#>" onclick="deleteSelectedSimMsgClickHandler();" style="margin-left: 500px;">
                                                                    </div>
                                                                </div>
                                                        

                                                    </div>
                                                </div>
                                                <div id="simMsgTableContainer" class="width100p overflow-only-y">
                                                    <table id="simMsgList_table" class="table table-striped table-hover ko-grid table-fixed">
                                                        <thead>
                                                        <tr style="background-color:#8080804d">
                                                            <th width="20" class="text-center">
                                                                <p id="simMsgList-checkAll" target="simMsgList_container" class="checkbox checkboxToggle">
                                                                    <input id="checkbox-all" type="checkbox" style="margin-top: 10px;"/>
                                                                </p>
                                                            </th>
                                                            <th width="110" class="text-center"><#Number#></th>
                                                            <th width="450" class="text-center"><#Content#></th>
                                                            <th width="150" class="text-center"><#Time#></th>
                                                        </tr>
                                                        </thead>
                                                        <tbody id="simMsgList_container">
                                                        </tbody>
                                                    </table>
                                                      <div id="pageInfo1" onselectstart="return false" class="col-md-8">
                                                        <ul id="pageItems1">
                                                            <li><a href="#" id="pageInfoShow1"></a></li>
                                                            <li><a href="#" id="dataSum1"></a></li>
                                                            <li style="display:none"><a href="#">Number of Items/page:</a><select id="pageSize1" ></select></li>
                                                            <li><a href="#" title="首页" name="firstPage"><<</a></li>
                                                            <li><a href="#" title="上一页" name="prePage"><</a></li>
                                                            <li><a href="#" title="下一页" name="nextPage">></a></li>
                                                            <li><a href="#" title="尾页" name="lastPage">>></a></li>
                                                            <li><input type="text" id="changePage1"><a id="goPage1" href="#" title="跳转">Page</a></li>
                                                        </ul>
                                                    </div>
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
<script id="simMsgListTmpl" type="text/x-jquery-tmpl">
{{each(i, sms) data }}
    <tr class="smslist-item simMsgList-item-class-${id} ${type == "0" ? 'font-weight-bold':''}" id="simMsgList-item-${number}">
        <td>
            <div class="smslist-item-checkbox">
                <p class="checkbox" id="${id}">
                    <input type="checkbox" target="simMsgList-checkAll" name="msgId" id="checkbox${id}" value="${id}" number="${number}" number="${number}" />
                </p>
            </div>
        </td>
        <td>
          
                {{if number.length > 11}}
                    <div class="smslist-item-name pull-left">${number.substring(0,11)+"..."}</div>
                {{else}}
                     <div class="smslist-item-name pull-left">${number}</div>
                {{/if}}
        
        </td>
        <td class="cursorhand" title="${content}" onclick="simsmsItemClickHandler('${type}','${id}','${number}')">
            <div class="sms-table-content smslist-item-msg">${content}</div>
        </td>
        <td style="padding:8px 0px;"><span class="clock-time ${type==2||type==3?'hide':''}" style="white-space: nowrap;">${time}</span></td>
    </tr>
{{/each}}
</script>
</html>
