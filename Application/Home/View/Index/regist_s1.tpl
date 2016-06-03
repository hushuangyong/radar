<include file="Index/header" title="校园雷达-注册"  />
</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="javascript:;" onclick="goback();" ><img class="am-header-icon-custom" src="data:image/svg+xml;charset=utf-8,&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 12 20&quot;&gt;&lt;path d=&quot;M10,0l2,2l-8,8l8,8l-2,2L0,10L10,0z&quot; fill=&quot;%23fff&quot;/&gt;&lt;/svg&gt;" alt=""></a>
        </div>
        <h1 class="am-header-title">
            <a href="javascript:;">注册</a>
        </h1>
    </header>

    <div class="am-container am-margin-top-xl">
        <div class="am-form-group">
            <input class="am-form-field am-radius" type="tel" name="mobile" id="mobile" value="" placeholder="手机号码：请输入您的手机号" maxlength="11" />
        </div>
        <div class="am-form-group">
            <input class="am-form-field am-radius" type="email" name="email" id="email" value="" placeholder="Email：请输入您的邮箱" maxlength="50" />
        </div>
        <div class="am-form-group">
            <input class="am-form-field am-radius" type="password" name="password" id="password" value="" maxlength="18" placeholder="登录密码：请输入6-18位字母、数字、下划线组成的密码" />
        </div>
    </div>
    <div class="am-container">
        <p class="am-pagination-centered">
            <input type="checkbox" name="zhuce" id="zhuce" value="1" checked="true" /> <label for="zhuce">我已阅读并同意<a href="javascript:void(0);" onclick="show_protocal();">《注册协议》</a></label>
        </p>
    </div>

    <div class="am-margin-lg">
        <button type="button" id="nextstep" class="am-btn am-btn-warning am-btn-block" onclick="doreg_mobile();">下一步</button>
    </div>

    <script type='text/javascript'>

        //注册异步
        function doreg_mobile() {
            var mobile = $.trim($("#mobile").val());
            var email = $.trim($("#email").val());
            var password = $.trim($("#password").val());

            if (!$('#zhuce').is(':checked')) {
                showalert("请勾选注册协议");
                return false;
            } else if (mobile == "") {
                showalert("请输入手机号码");
                $('#mobile').focus();
                return false;
            } else if (!regmb.test(mobile)) {
                showalert("请输入正确的手机格式");
                $('#mobile').select();
                return false;
            } else if ((email == "") || !regEmail.test(email)) {
                showalert("请输入正确的邮箱地址~");
                $('#email').focus();
                return false;
            } else if (password == "") {
                showalert("请输入6-18位密码");
                $('#password').focus();
                return false;
            } else if (!regpw.test(password)) {
                showalert("密码应为6-18位字母、数字、下划线组成");
                $('#password').focus();
                return false;
            } else {
                $("#nextstep").attr("submiting", '1').text("提交中...");
                $.ajax({
                    type: "POST",
                    url: "{:U('Index/registMobile')}",
                    dataType: "json",
                    data: "mobile=" + mobile + "&email=" + email + "&password=" + password,
                    success: function (res) {
                        if (res.code == 200) {
                            window.location.href = res.info;
                        } else {
                            showalert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("下一步");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        showalert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("下一步");
                    }

                });
            }

        }

        //显示协议
        function show_protocal() {
            showalert("尊敬的客户，欢迎您注册成为本网站用户。在注册前请您仔细阅读如下服务条款：本服务协议双方为本网站与本网站客户，本服务协议具有合同效力。您确认本服务协议后，本服务协议即在您和本网站之间产生法律效力。请您务必在注册之前认真阅读全部服务协议内容，如有任何疑问，可向本网站咨询。无论您事实上是否在注册之前认真阅读了本服务协议，只要您点击协议正本下方的\"下一步\"按钮并按照本网站注册程序成功注册为用户，您的行为仍然表示您同意并签署了本服务协议。");
        }
    </script>

<include file="Index/footer" />