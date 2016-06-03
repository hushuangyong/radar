<include file="Index/header" title="校园雷达-已抢单"  />


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
            <a href="{:U('Index/radar')}" title="">校园雷达</a>
        </h1>
        <div class="am-header-right am-header-nav">
            <a href="{:U('Ucenter/myCenter')}" class="" title="个人中心">
                <i class="am-header-icon am-icon-user"></i>
            </a>
            <a href="{:U('Ucenter/publish')}" class="post_new" title="发布任务"><i class="am-header-icon am-icon-plus"></i></a>
        </div>
    </header>

    <div style="text-align:center;margin:10px;">已接单项目列表</div>
    <div class="i-task-list">
        <ul>
            <notempty name='userGeted'>
                <foreach name='userGeted' item='list'>
                    <li id="$list.quest_id"><a href="{:U('Ucenter/myGetedDetail')}?pubid={$list.quest_id}" title="{$list.quest_title}"><span class="{$list.className}" title="接单于{$list.order_time|date='Y-m-d H:i:s',###}">{$list.status_name}</span><span>{$list.quest_title|cn_substr=0,12}</span></a></li>
                </foreach>
                <else />
                <div style="text-align:center;margin:10px;">暂无接单记录</div>
            </notempty>
        </ul>
    </div>


<include file="Index/footer" />
