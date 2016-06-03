<include file="Index/header_new" title="校园雷达-注册用户"  />
</head>
<body>
    <div class="ld-login-box">
        <div class="am-margin-sm">
            <h2><img src="__STATIC__/assets/img/login/logo.png"/></h2>
            <ul class="am-margin-sm">
                <li class="ld-login-row">
                    <input type="tel" name="mobile" id="mobile" value="" maxlength="11" />
                    <img src="__STATIC__/assets/img/login/iphone.png" class="ld-login-row-img"/>
                    <img src="__STATIC__/assets/img/login/login_close.png" width="20" class="ld-login-close am-hide"/>
                </li>
                <li class="ld-login-row">
                    <input type="password" name="password" id="password" value=""  class="am-login-btn11 am-colorfff" maxlength="18" required />
                    <img src="__STATIC__/assets/img/login/password.png" class="ld-login-row-img"/>
                    <img src="__STATIC__/assets/img/login/login_close.png" width="20" class="ld-login-close am-hide"/>
                </li>
                <li class="ld-login-row">
                    <div class="dropdown">
                        <select name="one" class="dropdown-select" id="schList">
                            <option value="">选择您的学校</option>
                            <foreach name='schoolList' item='list'>
                                <option value="{$list.id}">{$list.name}</option>
                            </foreach>
                        </select>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    <div class="am-margin-sm ld-login-text">
        <div class="roundedTwo am-fl">
            <input type="checkbox" value="1" id="zhuce" name="zhuce" checked="true">
            <label for="zhuce"></label>
        </div>
        <span>我同意校园雷达<a href="javascript:show_protocal();">《注册协议》</a>条款,<a href="javascript:user_protocal();">《雷达用户使用协议》</a>条款</a></span>
    </div>
    <div class="ld-login-btn">
        <a href="javascript:void(0);" onclick="doreg_mobile();">注册</a>
        &nbsp;<a href="{$signin}">已经注册?马上登录</a>
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
        //注册异步
        function doreg_mobile() {
            var mobile = $.trim($("#mobile").val());
            var school = $.trim($("#schList").val());
            var password = $.trim($("#password").val());

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
                $('#password').focus();
                return false;
            } else if ((school == "") || school == 0) {
                alert("请先选择您的学校~");
                $('#schList').focus();
                return false;
            } else if (!$('#zhuce').is(':checked')) {
                alert("请勾选注册协议");
                return false;
            } else {
                $("#nextstep").attr("submiting", '1').text("提交中...");
                $.ajax({
                    type: "POST",
                    url: "{:U('Index/registMobile')}",
                    dataType: "json",
                    data: "mobile=" + mobile + "&password=" + password + "&school=" + school,
                    success: function (res) {
                        if (res.code == 200) {
                            var status = res.status;
                            doreg_school(status, school);
                            //console.log(res);
                            //window.location.href = res.info;
                        } else {
                            alert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("下一步");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("下一步");
                    }

                });
            }

        }

        //注册异步
        function doreg_school(status, school) {
            if (!status) {
                alert("非法操作");
                return false;
            }

            //var school = $('#schList').val();
            if (school == 0) {
                alert("请先选择您的学校~");
                return false;
            } else {
                $("#nextstep").attr("submiting", '1').text("提交中...");
                $.ajax({
                    type: "POST",
                    url: "{:U('Index/registSchool')}",
                    dataType: "json",
                    data: "status=" + status + "&school=" + school,
                    success: function (res) {
                        if (res.code == 200) {
                            alert("恭喜您，注册成功！");
                            setTimeout(window.location.href = res.info, 2000);
                        } else {
                            alert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("注册");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("注册");
                    }

                });
            }

        }

        //显示协议
        function show_protocal() {
            alert("尊敬的客户，欢迎您注册成为本网站用户。在注册前请您仔细阅读如下服务条款：本服务协议双方为本网站与本网站客户，本服务协议具有合同效力。您确认本服务协议后，本服务协议即在您和本网站之间产生法律效力。请您务必在注册之前认真阅读全部服务协议内容，如有任何疑问，可向本网站咨询。无论您事实上是否在注册之前认真阅读了本服务协议，只要您点击协议正本下方的\"下一步\"按钮并按照本网站注册程序成功注册为用户，您的行为仍然表示您同意并签署了本服务协议。");
        }

        //用户使用协议
        function user_protocal() {
            alert('用户使用协议');
        }

        //回车执行
        $(".ld-login-row input").keyup(function (e) {
            if (e.keyCode == 13) {
                doreg_mobile();
            }
        });
    </script>

<include file="Index/footer_new" />