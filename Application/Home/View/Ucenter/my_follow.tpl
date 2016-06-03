<include file="Index/header" title="校园雷达-我的关注"  />

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

    <div style="text-align:center;margin:10px;">关注人列表</div>
<notempty name='userPublished'>
    <foreach name='userPublished' item='list'>
        <php>$url['sgkey'] = dtd_encrypt($list['user_id']);</php>
        <div class="i-list-bd">
            <div class="am-margin-xs">
                <div class="am-g">
                    <div class="am-u-sm-8">
                        <div class="am-fl i-user-logo">
                            <a href="{:U('Index/radar',array('sgkey'=>$url['sgkey']))}"><img class="i-user-img" src="/Public/Images/Radar/Main/img_user.png"></a>
                        </div>
                        <div class="am-fl i-user-name" >
                            <a href="{:U('Index/radar',array('sgkey'=>$url['sgkey']))}" title="{$list.username}"><h4>{$list.username}</h4></a>
                            <span></span>
                        </div>
                    </div>
                    <div class="am-u-sm-3" id="{$list.id}"><span></span><em class="delete_follow">删除</em></div>
                </div>
            </div>

        </div>
    </foreach>
    <else />
    <div style="text-align:center;margin:10px;color:#999;">暂无关注人</div>
</notempty>		

<script>

    //取消关注
    $('.delete_follow').click(function () {
        if (false == confirm("确定删除吗？该操作不可恢复！")) {
            return false;
        }
        var id = $(this).parent().attr('id');
        $(this).attr("class", '').text("提交中...");
        $.ajax({
            type: "POST",
            url: "{:U('Ucenter/cancelAttention')}",
            dataType: "json",
            data: "id=" + id,
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
                $(this).attr("class ", 'cancel').text("删除");
            }
        });
    });

</script>

<include file="Index/footer" />
