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
        <form class="am-form" action="" method="post">
            <div class="am-form-group am-form-select">
                <select name="schList" id="schList">
                    <option value="0">选择您的学校</option>
                    <foreach name='schoolList' item='list'>
                        <option value="{$list.id}">{$list.name}</option>
                    </foreach>
                </select>
            </div>
        </form>
    </div>

    <div class="am-margin-lg">
        <button type="button" id="nextstep" class="am-btn am-btn-warning am-btn-block" onclick="doreg_school();">注册</button>
    </div>

    <script type='text/javascript'>
        var status = '{$status}';

        //注册异步
        function doreg_school() {
            if (!status) {
                showalert("非法操作");
                return false;
            }

            var school = $('#schList').val();
            if (school == 0) {
                showalert("请先选择您的学校~");
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
                            showalert("恭喜您，注册成功！");
                            setTimeout(window.location.href = res.info, 2000);
                        } else {
                            showalert(res.msg);
                            $("#nextstep").attr("submiting", '0').text("注册");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        showalert("服务器通讯不稳定，请重试~");
                        $("#nextstep").attr("submiting", '0').text("注册");
                    }

                });
            }

        }
    </script>
<include file="Index/footer" />