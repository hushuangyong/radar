<include file="Index/header" title="校园雷达-登录"  />
</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="javascript:;" onclick="goback();" ><img class="am-header-icon-custom" src="data:image/svg+xml;charset=utf-8,&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 12 20&quot;&gt;&lt;path d=&quot;M10,0l2,2l-8,8l8,8l-2,2L0,10L10,0z&quot; fill=&quot;%23fff&quot;/&gt;&lt;/svg&gt;" alt=""></a>
        </div>
        <h1 class="am-header-title">
            <a href="javascript:;">登录</a>
        </h1>
    </header>

    <form action="" class="am-form" id="doc-vld-msg">
        <div class="am-container am-margin-top-xl">
            <div class="am-form-group">
                <input class="am-form-field am-radius" type="tel" name="mobile" id="mobile" value="" placeholder="手机号码：请输入您的手机号" maxlength="11" required />
            </div>
            <div class="am-form-group">
                <input class="am-form-field am-radius" type="password" name="password" id="password" value="" placeholder="登录密码：请输入您的登录密码" maxlength="18" required />
            </div>
        </div>
        <div class="am-container am-cf">
            <div class="am-fl">
                <a href="{:U('Index/regist')}">点击注册</a>
            </div>
            <div class="am-fr">
                <a href="{:U('Ucenter/resetPassword')}">忘记密码了？</a>
            </div>
        </div>

        <div class="am-margin-lg">
            <button type="button" id="nextstep" class="am-btn am-btn-warning am-btn-block am-radius" onclick="dologin();">登录</button>
        </div>
    </form>

    <script type='text/javascript'>

        //登录异步
        function dologin() {
            var mobile = $.trim($("#mobile").val());
            var password = $.trim($("#password").val());

            if (mobile == "") {
                showalert("请输入手机号码");
                $('#mobile').focus();
                return false;
            } else if (!regmb.test(mobile)) {
                showalert("请输入正确的手机格式");
                $('#mobile').select();
                return false;
            } else if (password == "") {
                showalert("请输入6-18位密码");
                $('#password').focus();
                return false;
            } else if (!regpw.test(password)) {
                showalert("密码应为6-18位字母、数字、下划线组成");
                $('#password').select();
                return false;
            } else {
                $("#nextstep").attr("submiting", '1').text("提交中...");
                $.ajax({
                    type: "POST",
                    url: "{:U('Index/loginUser')}",
                    dataType: "json",
                    data: "mobile=" + mobile + "&password=" + password,
                    success: function (res) {
                        if (res.code == 200) {
                            window.location.href = res.info;
                        } else {
                            showalert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("登录");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        showalert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("登录");
                    }

                });
            }

        }
    </script>

<include file="Index/footer" />
