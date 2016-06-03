<include file="Index/header" title="校园雷达-忘记密码-重设密码"  />
</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="javascript:;" onclick="goback();"><img class="am-header-icon-custom" src="data:image/svg+xml;charset=utf-8,&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 12 20&quot;&gt;&lt;path d=&quot;M10,0l2,2l-8,8l8,8l-2,2L0,10L10,0z&quot; fill=&quot;%23fff&quot;/&gt;&lt;/svg&gt;" alt=""></a>
        </div>
        <h1 class="am-header-title">
            <a href="javascript:;">忘记密码</a>
        </h1>
    </header>

    <div class="am-container am-margin-top-xl">
        <p>验证码已发送到{$email}，30分钟内有效</p>
        <div class="am-g">
            <div class="am-u-sm-8">
                <div class="am-form-group">
                    <input class="am-form-field am-radius" type="tel" name="vcode" id="vcode" value="" placeholder="请输入验证码" />
                </div>
            </div>
            <div class="">
                <div class="am-form-group">
                    <input class="am-btn am-btn-warning am-radius" type="button" name="resend" id="resend" value="重新发送" />
                </div>
            </div>
        </div>

        <div class="am-form-group">
            <input class="am-form-field am-radius" type="password" name="newpass" id="newpass" value="" placeholder="请输入新密码（6-16位字母或数字）" />
        </div>
    </div>

    <div class="am-margin-lg">
        <button type="button" id="nextstep" class="am-btn am-btn-warning am-radius am-btn-block" onclick="do_check();">下一步</button>
    </div>

    <script type='text/javascript'>
        $(document).ready(function () {
            //重新发送
            $('#resend').click(function () {
                console.log(new Date());
                alert(new Date());
            });
        });

        //找回密码
        function do_check() {
            var vcode = $('#vcode').val();
            if (("" == vcode) || isNaN(vcode)) {
                showalert('请输入数字验证码！');
                $('#vcode').focus();
                return false;
            }
            var newpass = $('#newpass').val();
            if (("" == newpass) || !isNaN(newpass) || !regpw.test(newpass)) {
                showalert('请输入新密码（6-16位字母或数字）！');
                $('#newpass').focus();
                return false;
            }

            $("#nextstep").attr("submiting", '1').text("提交中...");
            $.ajax({
                type: "POST",
                url: "{:U('Ucenter/updatePassword')}",
                dataType: "json",
                data: "status=" + 1 + "&vcode=" + vcode + "&newpass=" + newpass,
                success: function (res) {
                    if (res.code == 200) {
                        window.location.href = res.info;
                    } else {
                        showalert(res.msg);
                        $("#nextstep").attr("submiting", '0').text("下一步");
                        return false;
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    showalert("服务器通讯不稳定，请重试~");
                    $("#nextstep").attr("submiting", '0').text("下一步");
                }

            });
        }
    </script>
<include file="Index/footer" />
