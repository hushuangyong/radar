<include file="Index/header" title="校园雷达-个人中心"  />
</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="javascript:;" onclick="goindex();" ><img class="am-header-icon-custom" src="data:image/svg+xml;charset=utf-8,&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 12 20&quot;&gt;&lt;path d=&quot;M10,0l2,2l-8,8l8,8l-2,2L0,10L10,0z&quot; fill=&quot;%23fff&quot;/&gt;&lt;/svg&gt;" alt="">
            </a>
        </div>
        <h1 class="am-header-title">
            <a href="javascript:;">用户中心</a>
        </h1>
        <div class="am-header-right am-header-nav">
            <a href="{:U('Ucenter/myCenter')}" class="">
                <i class="am-header-icon am-icon-user"></i>
            </a>
            <a href="{:U('Ucenter/publish')}" class="post_new" title="发布任务"><i class="am-header-icon am-icon-plus"></i></a>
        </div>
    </header>

    <div class="am-margin-xs">
        <div class="am-g">
            <div class="am-u-sm-12">
                <div class="am-fl i-user-logo">
                    <img class="i-user-img-big" src="__STATIC_IMG__/Radar/Main/img_user.png">
                </div>
                <div class="am-fl i-user-name">
                    <h4>{$user_info.username}</h4>
                    <div><span>等级：</span><span>{$user_info.level}</span></div>
                    <div><span>积分：</span><span>{$user_info.point}</span></div>
                </div>
            </div>
        </div>
    </div>
    <hr data-am-widget="divider" style="" class="am-divider am-divider-default" />

    <div class="i-task-list">
        <ul>
            <li><a href="{:U('Ucenter/publish')}"><img src="__STATIC_IMG__/Radar/Main/icn_01.png"/><span>我要发布</span><i></i></a></li>
            <li><a href="{:U('Ucenter/myPubilshed')}"><img src="__STATIC_IMG__/Radar/Main/icn_02.png"/><span>已发布</span><i></i></a></li>
            <li><a href="{:U('Ucenter/orderTaking')}"><img src="__STATIC_IMG__/Radar/Main/icn_01.png"/><span>我的接单</span><i></i></a></li>
            <li><a href="{:U('Ucenter/myFollow')}"><img src="__STATIC_IMG__/Radar/Main/icn_02.png"/><span>我的关注</span><i></i></a></li>
            <li><a href="{:U('Ucenter/myCollection')}"><img src="__STATIC_IMG__/Radar/Main/icn_02.png"/><span>我的收藏</span><i></i></a></li>			
            <li><a href=""><img src="__STATIC_IMG__/Radar/Main/icn_03.png"/><span>关于我们</span><i></i></a></li>
        </ul>
    </div>

    <div class="am-margin-lg">
        <button type="button" id="nextstep" class="am-btn am-btn-warning am-btn-block" onclick="dologout();">退出</button>
    </div>

    <script type='text/javascript'>

        function goindex() {
            window.location.href = "{:U('Index/radar')}";
        }

        //退出异步
        function dologout() {

            $("#nextstep").attr("submiting", '1').text("提交中...");
            $.ajax({
                type: "POST",
                url: "{:U('Index/logout')}",
                dataType: "json",
                data: "status=" + 1,
                success: function (res) {
                    if (res.code == 200) {
                        window.location.href = res.info;
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    showalert("服务器通讯不稳定，请重试~");
                    $("#nextstep").attr("submiting", '0').text("退出");
                }

            });
        }
    </script>
<include file="Index/footer" />
