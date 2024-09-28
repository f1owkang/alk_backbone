<!DOCTYPE html>
<html>
  <head>
    <title>5G MiFi - 短信转发</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />

    <link rel="shortcut icon" href="images/favicon.ico" />
    <link rel="icon" href="images/favicon.png" />
    <link
      rel="stylesheet"
      type="text/css"
      href="/bootstrap/css/bootstrap.min.css"
    />
    <link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css" />

    <script type="text/javascript" src="/jquery.js"></script>
    <script
      type="text/javascript"
      src="/bootstrap/js/bootstrap.min.js"
    ></script>
    <script type="text/javascript" src="/state.js"></script>
    <script type="text/javascript" src="/popup.js"></script>
    <script type="text/javascript" src="/client_function.js"></script>
    <script type="text/javascript" src="/underscore.base.js"></script>
    <script type="text/javascript" src="/jquery.tmpl.js"></script>
    <script type="text/javascript" src="/util.js"></script>
    <script>
      function initial() {
        show_banner(0);
        show_menu(3, 11, 5);
        show_footer();

        getToken();
        getChannel();

        getLog();
        getForwardActive();
        
        if (!checkSERIALNO()) return;
      }

      const url_8181 = "http://" + window.location.hostname + ":8181";

      function makeAjaxRequest(url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.onerror = function () {
          console.error("无法连接服务");
          callback("无法连接服务");
        };
        xhr.onload = function () {
          if (xhr.status === 200) {
            var response = xhr.responseText;
            callback(response);
          } else {
            console.error("请求错误：" + xhr.status);
            callback("请求错误：" + xhr.status);
          }
        };
        xhr.send();
      }
      
      function getToken() {
        var gettoken_url = url_8181 + "/cgi-bin/api?getToken";
        makeAjaxRequest(gettoken_url, function (response) {
          var jsonResponse = JSON.parse(response);
          var token = jsonResponse.Token;
          if (token === 'null'){
            document.getElementById("token_input").value = "";
          }else{
            document.getElementById("token_input").value = token;
          }
            
        });
      }

      function getChannel() {
        var getChannelUrl = url_8181 + "/cgi-bin/api?getChannel";
        makeAjaxRequest(getChannelUrl, function (response) {
            var jsonResponse = JSON.parse(response);

            var Channel = jsonResponse.Channel;
            var ChannelCode = jsonResponse.ChannelCode;
      
            document.getElementById('channel_opt').value= Channel; 
            document.getElementById("channel_code").value = ChannelCode;
            readOnly_ChannelCode();
        });
      }
      function getChannelCode(thisChannel) {
        var getChannelCodeUrl = url_8181 + "/cgi-bin/api";
        var formData = new FormData();
        formData.append("getChannelCode", thisChannel);
        var xhr = new XMLHttpRequest();
        xhr.open("POST", getChannelCodeUrl, true);
        xhr.setRequestHeader(
          "Content-type",
          "application/x-www-form-urlencoded"
        );
        xhr.onreadystatechange = function () {
          if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
            var jsonResponse = JSON.parse(xhr.responseText);
            var ChannelCode = jsonResponse.ChannelCode;
            if (ChannelCode === 'null'){
              document.getElementById("channel_code").value = "";
              document.getElementById("channel_code").placeholder="请填写编码"
            }else{
              document.getElementById("channel_code").value = ChannelCode;
            }
       
            readOnly_ChannelCode();
          }
        };
        var sendmsg=new URLSearchParams(formData).toString()
        xhr.send(sendmsg);
      }

      function readOnly_ChannelCode(){
        var channel_opt=document.getElementById('channel_opt')
        var channel_code=document.getElementById("channel_code")
        if (channel_opt.value === 'wechat' || channel_opt.value === 'delChannel') {
            channel_code.readOnly = true;
            channel_code.value="无需填写"
            
        } else {
            channel_code.readOnly = false;
        }
      }
      function setChannel(){
        const regex = /^[a-zA-Z0-9]+$/;
        const inputValue = document.getElementById("token_input").value.trim();
        const channel_opt = document.getElementById("channel_opt").value.trim();
        const channel_code = document.getElementById("channel_code").value.trim();
        if(!channel_opt==="delChannel"){
          if (!regex.test(channel_code)) {
            alert("请输入数字、字母格式的配置编码");
            return;
        }
        }
        var savetokenurl = url_8181 + "/cgi-bin/api";
        var formData = new FormData();
        formData.append("setChannel", channel_opt);
        formData.append(channel_opt, channel_code);
        formData.append("token", inputValue);
        var xhr = new XMLHttpRequest();
        xhr.open("POST", savetokenurl, true);
        xhr.setRequestHeader(
          "Content-type",
          "application/x-www-form-urlencoded"
        );
        xhr.onreadystatechange = function () {
          if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
            getToken();
            getChannel();
            var jsonResponse = JSON.parse(xhr.responseText);
            var Token = jsonResponse.Token;
            var Channel = jsonResponse.Channel;
            var ChannelCode = jsonResponse.ChannelCode;
            if(Channel==='wechat'){
              ChannelCode="无需填写"
            }
            alert("应用成功，\n令牌："+Token+"\n渠道："+Channel+"\n渠道编码："+ChannelCode)
          }
        };
        var sendmsg=new URLSearchParams(formData).toString()
        xhr.send(sendmsg);

      }

      function startForward() {
        var start_url = url_8181 + "/cgi-bin/api?start";
        makeAjaxRequest(start_url, function (response) {
          // console.log("start:" + response);
          var jsonResponse = JSON.parse(response);
          var pushStatus = jsonResponse.status;
          var pushMessage = jsonResponse.message;
          var pushBtn = jsonResponse.btn;
          console.log(pushStatus)
          console.log(pushMessage)
          if (pushBtn === '1') {
              alert(pushMessage)
              document.getElementById("onoff").value = "关闭转发";
              document.getElementById("set_channel_btn").disabled=true
              document.getElementById("token_input").readOnly=true
              document.getElementById("channel_opt").disabled=true
              document.getElementById("channel_code").readOnly=true
              getLog();
          } else {
            alert(pushMessage)
            document.getElementById("onoff").value = "开启转发";
              document.getElementById("set_channel_btn").disabled=false
              document.getElementById("token_input").readOnly=false
              document.getElementById("channel_opt").disabled=false
              var channel_opt_value=document.getElementById("channel_opt").value
              if (channel_opt_value==='webhook' || channel_opt_value==='mail'){
                document.getElementById("channel_code").readOnly=false
              }
            getLog();
          }
   
        });
      }



      function getLog() {
        var start_url = url_8181 + "/cgi-bin/api?getLog";
        makeAjaxRequest(start_url, function (response) {

          document.getElementById("LogsBox").textContent = response;
         
        });
      }
      function getForwardActive() {
        var start_url = url_8181 + "/cgi-bin/api?getForwardActive";
        makeAjaxRequest(start_url, function (response) {
          var jsonResponse = JSON.parse(response);
          var pushStatus = jsonResponse.status;
          document.getElementById("onoff").value = pushStatus; 
          if (pushStatus==='关闭转发'){
            document.getElementById("set_channel_btn").disabled=true
            document.getElementById("token_input").readOnly=true
            document.getElementById("channel_opt").disabled=true
            document.getElementById("channel_code").readOnly = true;
          }
        });
      }

      setInterval(getForwardActive, 3000);
      setInterval(getLog, 5000);
    </script>
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
          <div class="span9">
            <div id="TopBanner"></div>
          </div>
        </div>
      </div>

      <div id="Loading" class="popup_bg"></div>

      <iframe
        name="hidden_frame"
        id="hidden_frame"
        src=""
        width="0"
        height="0"
        frameborder="0"
      ></iframe>

      <form
        method="post"
        name="form"
        id="ruleForm"
        action="/start_apply.htm"
        target="hidden_frame"
      >
        <input type="hidden" name="preferred_lang" id="preferred_lang" value="<%
        nvram_get_x("", "preferred_lang"); %>">

        <div class="container-fluid">
          <div class="row-fluid">
            <div class="span3">
              <!--Sidebar content-->
              <!--=====Beginning of Main Menu=====-->
              <div class="well sidebar-nav side_nav" style="padding: 0px">
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
                    <h2 class="box_head round_top">
                      <#menu11#> - <#menu5_11_5#>
                    </h2>
                    <div class="round_bottom">
                      <div class="row-fluid">
                        <div id="tabMenu" class="submenuBlock"></div>
              
                        <div id="pushplusbox">
                          <div id="getPushPlusToken" style="margin-top: 0px;margin-left: 5px; width: 100%; height: 30px;float: left;display: flex;align-items: center;border: 0px solid red;">
                            <a href="https://www.pushplus.plus/push1.html" target="_blank">点击获取：pushplus token(令牌)</a>
                          </div>
                          <div id="get_set_token" style="margin-top: 0px; width: 100%; height: 30px;float: left;border:0px solid red;display: flex;align-items: center; ">
                            
                             <input name="token_input" id="token_input" maxlength="32" placeholder="请填写token" style="width: 265px; height: 100%; box-sizing: border-box;margin-bottom: 0px; margin-left: 5px; border: 0px solid black;"/>
                            
                            <input name="onoff" id="onoff" type="button" class="btn btn-primary" style="width: 100px; height: 100%; box-sizing: border-box; margin-left: 5px;margin-bottom: 0px;" onclick="startForward();" value="开启转发"/>
                          </div>
                          <div id="channel" style="margin-top: 5px;margin-bottom: 5px; width: 100%;height: 30px; float: left; border: 0px solid red; display: flex; align-items: center;">
                            
                            <select name="channel_opt" id="channel_opt" style="height: 100%; width: 130px;box-sizing: border-box;margin-bottom: 0px;margin-left: 5px;border: 0px solid black;">
                              <option value="wechat" title="pushplus微信公众号推送">微信</option>
                              <option value="mail" title="接收邮箱为pushplus微信公众号→功能→个人中心→个人资料中绑定的邮箱&#10;接收渠道和编码请在pushplus微信公众号→功能→个人中心→渠道配置→邮件中配置">邮箱</option>
                              <option value="webhook" title="接收渠道和编码请在pushplus微信公众号→功能→个人中心→渠道配置→webhook中配置">webhook</option>
                              <option value="delChannel" title="该选项会清空令牌，转发渠道和配置编码">清空配置</option>
                            </select>
 
                            <input name="channel_code" id="channel_code" style="width: 130px; height: 100%; box-sizing: border-box; margin-left: 5px;margin-bottom: 0px;border: 0px solid black" />
                            <input name="set_channel_btn" id="set_channel_btn" type="button" class="btn btn-primary" style="width: 100px; height: 100%; box-sizing: border-box; margin-left: 5px;" onclick="setChannel();" value="应用配置"/>
                           
                          </div>
 
                          <div id="log_box" style="margin : 5px; ">
                            <textarea
                                  readonly
                                  id="LogsBox"
                                  style="
                                    width: 100%;
                                    height: 300px;
                                    margin-bottom: 5px;
                                    padding: 7px;
                                    float: left;
                                    box-sizing: border-box;
                                  "
                                  placeholder=""
                                >
                                </textarea>
                            </div>
                          <script> 
                                var selectElement = document.getElementById('channel_opt');
                                var inputElement = document.getElementById('channel_code');

                                 selectElement.addEventListener('change', function(event) {
                                    var selectedValue = event.target.value;  
                                    getChannelCode(selectedValue);

                                    readOnly_ChannelCode();
                                });
                            </script>
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
