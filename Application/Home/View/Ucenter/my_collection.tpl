<include file="Index/header" title="校园雷达-我的收藏"  />

</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="javascript:;" onclick="goback();" >
                <img class="am-header-icon-custom" src="data:image/svg+xml;charset=utf-8,&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 12 20&quot;&gt;&lt;path d=&quot;M10,0l2,2l-8,8l8,8l-2,2L0,10L10,0z&quot; fill=&quot;%23fff&quot;/&gt;&lt;/svg&gt;" alt="">
            </a>
        </div>
        <h1 class="am-header-title">
            <a href="{:U('Index/radar')}">校园雷达</a>
        </h1>
        <div class="am-header-right am-header-nav">
            <a href="{:U('Ucenter/myCenter')}" class="">
                <i class="am-header-icon am-icon-user"></i>
            </a>
            <a href="{:U('Ucenter/publish')}" class="post_new" title="发布任务"><i class="am-header-icon am-icon-plus"></i></a>
        </div>
    </header>

    <div style="text-align:center;margin:10px;">已收藏项目列表</div>
    <div class="i-task-list">
        <ul>
            <notempty name='userPublished'>
                <foreach name='userPublished' item='list'>
                    <li id="{$list.quest_id}"><a href="{:U('Ucenter/myPubilshedDetail')}?pubid={$list.quest_id}" class="list-item" title="{$list.quest_title}"><span>{$list.quest_title|cn_substr=0,12}</span></a>&nbsp;<a href="javascript:void(0);" class="cancel">取消收藏</a></li>
                </foreach>
                <else />
                <div style="text-align:center;margin:10px;color:#999;">暂无收藏记录</div>
            </notempty>
        </ul>
    </div>

    <script>

        //取消收藏
        $('.cancel').click(function () {
            if (false == confirm("确定删除吗？该操作不可恢复！")) {
                return false;
            }
            var pubid = $(this).parent().attr('id');
            $(this).attr("class", 'cancel').text("提交中...");
            $.ajax({
                type: "POST",
                url: "{:U('Ucenter/cancelCollection')}",
                dataType: "json",
                data: "pubid=" + pubid,
                success: function (data) {
                    if (data.code == 200) {
                        location.reload();
                    } else {
                        showalert(data.msg);
                        return false;
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                    console.log(textStatus);
                    console.log(errorThrown);
                    showalert("服务器通讯不稳定，请重试~");
                    $(this).attr("class ", 'cancel').text("取消收藏");
                }
            });
        });

    </script>
<include file="Index/footer" />
