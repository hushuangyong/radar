<include file="Index/header_new" title="校园雷达-用户登录"  />
</head>
<body>
    <div class="ld-login-box">
        <div class="am-margin-sm">
            <h2><img src="__STATIC__/assets/img/login/logo-login.png"/></h2>
            <ul class="am-margin-sm">
                <li class="ld-login-row">
                    <input type="tel" name="mobile" id="mobile" value=""  class="am-login-btn11 am-colorfff" maxlength="11" required placeholder="请输入手机号" />
                    <img src="__STATIC__/assets/img/login/iphone.png" class="ld-login-row-img"/>
                    <img src="__STATIC__/assets/img/login/login_close.png" width="20" class="ld-login-close am-hide"/>
                </li>
                <li class="ld-login-row">
                    <input type="password" name="password" id="password" value=""  class="am-login-btn11 am-colorfff" maxlength="18" required placeholder="请输入密码" />
                    <img src="__STATIC__/assets/img/login/password.png" class="ld-login-row-img"/>
                    <img src="__STATIC__/assets/img/login/login_close.png" width="20" class="ld-login-close am-hide"/>
                </li>
            </ul>
        </div>
    </div>


    <div class="ld-login-btn">
        <a href="javascript:void(0);" onclick="dologin();">登录</a>
        &nbsp;<a href="{$signup}">还没有帐号?马上注册</a>
    </div>
    <script type="text/javascript">
        $('.ld-login-row input').focus(function () {
            $(this).siblings('.ld-login-row-img').css('left', '10px');
            $(this).siblings('.ld-login-close').removeClass('am-hide');
        });
        $('.ld-login-close').mousedown(function () {
            $(this).siblings('.ld-login-row input').val(this.defaultvalue);
            $(this).siblings('.ld-login-row-img').css('left', '45%');
            $(this).addClass('am-hide');
        });
        $('.ld-login-row input').blur(function () {
            if ($(this).val() == '') {
                $(this).siblings('.ld-login-row-img').css('left', '45%');
            }
            $(this).siblings('.ld-login-close').addClass('am-hide');
        });
    </script>
    <script type='text/javascript'>
        //回车执行
        $(".ld-login-row input").keyup(function (e) {
            if (e.keyCode == 13) {
                dologin();
            }
        });

        //登录异步
        function dologin() {
            var mobile = $.trim($("#mobile").val());
            var password = $.trim($("#password").val());
            var returnUrl = "{$refer}";//来源地址

            if (mobile == "") {
                alert("请输入手机号码");
                $('#mobile').focus();
                return false;
            } else if (!regmb.test(mobile)) {
                alert("请输入正确的手机格式");
                $('#mobile').select();
                return false;
            } else if (password == "") {
                alert("请输入6-18位密码");
                $('#password').focus();
                return false;
            } else if (!regpw.test(password)) {
                alert("密码应为6-18位字母、数字、下划线组成");
                $('#password').select();
                return false;
            } else {
                $("#nextstep").attr("submiting", '1').text("提交中...");
                $.ajax({
                    type: "POST",
                    url: "{:U('Index/loginUser')}",
                    dataType: "json",
                    data: "mobile=" + mobile + "&password=" + password + '&returnUrl=' + returnUrl,
                    success: function (res) {
                        if (res.code == 200) {
                            window.location.href = res.info;
                        } else {
                            alert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("登录");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("登录");
                    }

                });
            }

        }
    </script>
<include file="Index/footer_new" />