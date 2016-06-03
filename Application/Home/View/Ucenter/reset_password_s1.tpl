<include file="Index/header" title="校园雷达-忘记密码"  />
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
        <div class="am-form-group">
            <input class="am-form-field am-radius" type="email" name="email" id="email" value="" maxlength="50" placeholder="请输入您的邮箱地址" />
        </div>
        <p>为验证您的信息，会发送短信验证码到您的邮箱</p>

    </div>

    <div class="am-margin-lg">
        <button type="button" id="nextstep" class="am-btn am-btn-warning am-radius am-btn-block" onclick="docheck();" >发送验证码</button>
    </div>

    <script type='text/javascript'>
        //发送验证码
        function docheck() {
            var email = $.trim($("#email").val());

            if (email == "") {
                showalert("请输入邮箱地址");
                $('#email').focus();
                return false;
            } else if (!regEmail.test(email)) {
                showalert("请输入正确的邮箱格式~");
                $('#email').select();
                return false;
            } else {
                $("#nextstep").attr("submiting", '1').text("提交中...");
                $.ajax({
                    type: "POST",
                    url: "{:U('Ucenter/mobileCheck')}",
                    dataType: "json",
                    data: "mobile=" + email,
                    success: function (res) {
                        if (res.code == 200) {
                            window.location.href = res.info;
                        } else {
                            showalert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("发送验证码");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        showalert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("发送验证码");
                    }

                });
            }

        }
    </script>
<include file="Index/footer" />
