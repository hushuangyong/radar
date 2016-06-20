<html class="no-js">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="description" content="">
        <meta name="keywords" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
        <meta name="format-detection" content="telephone=no" />
        <title>校园雷达-用户信息设置</title>
        <meta name="renderer" content="webkit">
        <meta http-equiv="Cache-Control" content="no-siteapp"/>
        <link rel="icon" type="image/png" href="">
        <link rel="stylesheet" href="__STATIC__/assets/css/amazeui.min.css">
        <link rel="stylesheet" href="__STATIC__/assets/css/app.css">

        <script src="__STATIC__/assets/js/jquery.min.js"></script>
        <script src="__STATIC__/assets/js/amazeui.min.js"></script>

        <script type="text/javascript" src="__STATIC__/assets/js/app.js"></script>
    </head>
    <body>

        <div class="ld-home">
            <div class="ld-task-from">
                <form action="" method="post" id="infoPost">
                    <ul>
                        <li>
                            <span class="ld-task-from-l">手机号</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="text" name="username" id="username" value="{$user_info.username}" placeholder="手机号" maxlength="11" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">邮箱</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="type" name="email" id="email" value="{$user_info.email}" placeholder="邮箱地址" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">注册时间</span>
                            <div class="ld-task-from-r">
                                {$user_info.regtime|date="Y-m-d H:i:s",###}
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">上次登录</span>
                            <div class="ld-task-from-r">
                                {$user_info.last_login|date="Y-m-d H:i:s",###}
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">登录IP</span>
                            <div class="ld-task-from-r">
                                {$user_info.login_ip}
                                <script src="http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"type="text/ecmascript"></script>
                                <script type="text/javascript">
                                    document.write(remote_ip_info["country"] + "," + remote_ip_info["province"] + " " + ',' + remote_ip_info["city"] + " " + remote_ip_info["district"]);
                                </script>
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">姓名</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="type" name="realname" id="realname" value="{$user_info.realname}" placeholder="您的名字，方便校友联系" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">所在学校</span>
                            <div class="ld-task-from-r" id="">
                                <if condition="$user_info.school_id eq '0' OR $user_info.school_id eq '-1' ">
                                    <select class="ld-select prov" name="school" id="school">
                                        <foreach name='schoolList' item='list'>
                                            <option value="{$list.id}" title='{$list.name}' <eq name="$list.id" value="$user_info.school_id">selected="selected"</eq> >{$list.name}</option>
                                        </foreach>
                                    </select><else />{$user_info.school_name|default="这家伙很懒，什么也没留下"}<input type="hidden" name="school" id="school" value="{$user_info.school_id}" /></if>
                            </div>
                        </li>

                        <li><a href="{$pageUrl['myHome']}">返回到 个人中心</a></li>
                    </ul>
                </form>
            </div>
        </div>

        <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }">
            <div class="ld-comm-btn">
                <a href="javascript:void(0);" id="nextstep" class="" >更新个人资料</a>
            </div>
        </footer>

        <script type="text/javascript">
            $(document).ready(function () {

                //点击下一步
                $('#nextstep').click(function () {
                    do_update();
                });

            });

            //异步处理
            function do_update() {
                //处理参数
                var username = $('#username').val();
                var email = $('#email').val();
                var realname = $('#realname').val();
                var school = $('#school').val();

                if (!regmb.test(username)) {
                    alert("请填写手机号~");
                    $('#username').focus();
                    return false;
                }

                if (!regEmail.test(email)) {
                    alert("请先填写邮件地址~");
                    $('#email').focus();
                    return false;
                }

                if (realname == '') {
                    alert("请先填写您的姓名~");
                    $('#realname').focus();
                    return false;
                }

                if (school == '') {
                    alert("清选择学校~");
                    $('#school').focus();
                    return false;
                }

                console.log(username + "@" + email + '@' + realname + "@" + school);

                //提交
                if (username && email && realname) {
                    $("#nextstep").attr("submiting", '1').text("提交中...");
                    var params = $('#infoPost').serialize(); //序列化表单的值
                    $.ajax({
                        type: "POST",
                        url: "{:U('Ucenter/setUserInfo')}",
                        dataType: "json",
                        data: params,
                        success: function (res) {
                            if (res.code == 200) {
                                alert("恭喜您，修改成功！");
                                location.reload();
                            } else {
                                alert(res.msg);
                                $("#nextstep").attr("submiting", '0').text("更新个人资料");
                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("服务器通讯不稳定，请重试~");
                            console.log(XMLHttpRequest);
                            console.log(textStatus);
                        }
                    });
                } else {
                    alert('信息不完整！');
                    return false;
                }
            }
        </script>        
    </body>
</html>
