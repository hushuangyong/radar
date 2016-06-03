<include file="Index/header" title="校园雷达"  />
</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="/" title="雷达"><img class="am-header-icon-custom" src="__STATIC_IMG__/Radar/Main/logo.png" style=" width: 32px; height: 32px;" width="32" height="32" />
            </a>
        </div>
        <h1 class="am-header-title">
            <a href="javascript:;">校园雷达</a>
        </h1>
        <div class="am-header-right am-header-nav">
            <a href="{:U('Ucenter/myCenter')}">
                <i class="am-header-icon am-icon-user"></i>
            </a>
            <a href="{:U('Ucenter/publish')}" class="post_new" title="发布任务"><i class="am-header-icon am-icon-plus"></i></a>
        </div>
    </header>

    <!-- Nav -->
    <div data-am-widget="navbar" class="am-navbar am-cf am-navbar-default  am-no-layout i-navbar">
        <ul class="am-navbar-nav am-cf am-avg-sm-4">
            <if condition="$Think.get.type eq '' ">
                <li class="am-nav-on">
                <else/>
                <li>
            </if>
            <a href="{:U('Index/radar')}">
                <span class="am-navbar-label">最新发布</span>
            </a>
            </li>
            <if condition="$Think.get.type eq 1 ">
                <li class="am-nav-on">
                <else/>
                <li>
            </if>
            <a href="{:U('Index/radar')}?type=1" title="学习">
                <span class="am-navbar-label">学习</span>
            </a>
            </li>
            <if condition="$Think.get.type eq 2 ">
                <li class="am-nav-on">
                <else/>
                <li>
            </if>
            <a href="{:U('Index/radar')}?type=2" title="代购">
                <span class="am-navbar-label">代购</span>
            </a>
            </li>
            <if condition="$Think.get.type eq 3 ">
                <li class="am-nav-on">
                <else/>
                <li>
            </if>
            <a href="{:U('Index/radar')}?type=3" title="跑腿">
                <span class="am-navbar-label">跑腿</span>
            </a>
            </li>
            <if condition="$Think.get.type eq 4 ">
                <li class="am-nav-on">
                <else/>
                <li>
            </if>
            <a href="{:U('Index/radar')}?type=4" title="二手">
                <span class="am-navbar-label">二手</span>
            </a>
            </li>
            <if condition="$Think.get.type eq 5 ">
                <li class="am-nav-on">
                <else/>
                <li>
            </if>
            <a href="{:U('Index/radar')}?type=5" title="其他">
                <span class="am-navbar-label">其他</span>
            </a>
            </li>
        </ul>
    </div>

    <!-- Slides -->
    <!--
    <div data-am-widget="slider" class="am-slider am-slider-a1" data-am-slider='{"directionNav":false}' >
            <ul class="am-slides">
                    <li>
                            <img src="http://s.amazeui.org/media/i/demos/bing-1.jpg">
                    </li>
                    <li>
                            <img src="http://s.amazeui.org/media/i/demos/bing-2.jpg">
                    </li>
                    <li>
                            <img src="http://s.amazeui.org/media/i/demos/bing-3.jpg">
                    </li>
                    <li>
                            <img src="http://s.amazeui.org/media/i/demos/bing-4.jpg">
                    </li>
            </ul>
    </div>
    -->
    <div class="am-list-news am-list-news-default am-no-layout">

        <!-- List -->
        <notempty name='plist'>
            <foreach name='plist' item='list'>
                <div class="i-list-bd">
                    <div class="am-margin-xs">
                        <div class="am-g">
                            <div class="am-u-sm-8 am-padding-0">
                                <div class="am-fl i-user-logo">
                                    <img class="i-user-img" src="__STATIC_IMG__/Radar/Main/img_user.png"/>
                                </div>
                                <div class="am-fl i-user-name am-padding-0">
                                    <h4><a href="{:U('Project/projectDetail')}?pubid={$list[0].quest_id}" title="{$list[0].quest_title}">{$list[0].quest_title|cn_substr=0,8}</a></h4>
                                    <div>
                                        <span>{$list[0].public_time|date='Y-m-d H:i',###}</span>
                                        <span>
                                            <if condition='$list[0].quest_status eq 1'>
                                                已发布
                                                <elseif condition='$list[0].quest_status eq 2'/>
                                                已接单
                                                <elseif condition='$list[0].quest_status eq 3'/>
                                                已提交
                                                <elseif condition='$list[0].quest_status eq 4'/>
                                                已完成
                                                <elseif condition='$list[0].quest_status eq 5'/>
                                                已关闭
                                            </if>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="am-u-sm-4 i-award am-padding-0"><span>奖励：
                                    <if condition='$list[0].quest_reward_type eq 1'>
                                        {$list[0].quest_reward}元
                                        <else />
                                        {$list[0].quest_reward}
                                    </if></span>
                            </div>
                        </div>
                    </div>

                    <div class="i-list-img">
                        <ul class="am-avg-sm-3 am-thumbnails" query_url="{:U('Project/projectDetail')}?pubid={$list[0].quest_id}">
                            <foreach name='list' item='vo' key='k'>
                                <if condition="$vo.pic neq '' AND $k lt 3 ">
                                    <li><img class="am-thumbnail" src="__UPLOAD__{$vo.pic}" width="200" height="150" title="缩略图" alt="图片" /></li>						
                                    <else />
                                    <eq name="k" value="0">
                                    <li><img src="__STATIC_IMG__/Radar/Main/no_photo.jpg" class="am-thumbnail" width="200" height="150" /></li>
                                    </eq>
                                </if>
                            </foreach>
                            <if condition="(count($list) gt 1) AND (count($list) lt 3) "><li><img src="__STATIC_IMG__/Radar/Main/no_photo.jpg" class="am-thumbnail" width="200" height="150" /></li></if>
                            <if condition="(count($list) gt 0) AND (count($list) lt 2) "><li><img src="__STATIC_IMG__/Radar/Main/no_photo.jpg" class="am-thumbnail" width="200" height="150" /><li><img src="__STATIC_IMG__/Radar/Main/no_photo.jpg" class="am-thumbnail" width="200" height="150" /></li></if>
                        </ul>
                        <p class="am-margin-xs">{$list[0].quest_intro}</p>
                    </div>

                    <div class="am-g am-margin-bottom-xs">
                        <div class="am-u-sm-8 i-link">                            
                            <if condition="$list[0]['user_id'] eq $user_id && $user_id neq ''">
                                <a href="javascript:;"qid="{$list[0]['quest_id']}" style='color:#ff9d00' class="cancel_collec" title="已收藏"><i class="am-icon-star-o"></i> 已收藏</a>
                                <else />
                                <a href="javascript:;"qid="{$list[0]['quest_id']}" class='rasc'><i class="am-icon-star-o"></i> 收藏</a>
                            </if>
                            <if condition="$list[0]['public_user_id'] eq $list[0]['follow']['h_user_id']">
                                <a href="javascript:;"qid="{$list[0]['quest_id']}" id="{$list[0]['follow']['id']}" style='color:#ff9d00' class="delete_follow" title="已关注"><i class="am-icon-heart-o"></i> 已关注</a>
                                <else />
                                <a href="javascript:;"qid="{$list[0]['quest_id']}" class='sasc'><i class="am-icon-heart-o"></i> 关注</a>
                            </if>
                        </div>
                        <div class="am-u-sm-4 am-text-right"><a class="am-btn am-btn-warning am-round" href="{:U('Project/projectDetail')}?pubid={$list[0].quest_id}" title="详情">详情</a></div>
                    </div>

                </div>
            </foreach>
            <else />
            <div style="text-align:center;margin:10px;">暂无记录</div>
        </notempty>
        <!-- List End -->

    </div>
    <div class="i-footer-btn">
        <a href="{:U('Ucenter/publish')}" class="" id="" title="发布项目">+</a>
    </div>	
    <script>
        var loginUrl = "{:U('Index/login')}";//登录页
        //收藏
        $('.rasc').click(function () {
            var user_id = "{$user_id}";
            if (('' == user_id) || (isNaN(user_id))) {
                showalert('请先登录～');
                setTimeout(window.location.href = loginUrl, 2000);
                return false;
            }
            var qid = $(this).attr('qid');
            var thi = $(this);
            $.post("__APP__/Home/Ucenter/setCollection",{'qid':qid}, function (data) {
                if (data.code == 404) {
                    showalert(data.msg);
                    thi.html("<i class='am-icon-star-o'></i> 已收藏");
                    thi.css('color', '#ff9d00');
                } else {
                    showalert(data.msg);
                }
            }, 'json')
        });

        //取消收藏
        $('.cancel_collec').click(function () {
            if (false == confirm("确定删除吗？该操作不可恢复！")) {
                return false;
            }
            var pubid = $(this).attr('qid');
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
                }
            });
        });

        //关注
        $('.sasc').click(function () {
            var user_id = "{$user_id}";
            if (('' == user_id) || (isNaN(user_id))) {
                showalert('请先登录～');
                setTimeout(window.location.href = loginUrl, 2000);
                return false;
            }
            var qid = $(this).attr('qid');
            var thi = $(this);
            $.post("__APP__/Home/Ucenter/setFollow",{'qid':qid}, function (data) {
                if (data.code == 404) {
                    showalert(data.msg);
                    thi.html("<i class='am-icon-heart-o'></i> 已关注");
                    thi.css('color', '#ff9d00');
                } else {
                    showalert(data.msg);
                }
            }, 'json')
        });

        //取消关注
        $('.delete_follow').click(function () {
            if (false == confirm("确定删除吗？该操作不可恢复！")) {
                return false;
            }
            var id = $(this).attr('id');
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
                }
            });
        });

        //图片跳转
        $('.am-thumbnail').click(function () {
            location.href = '' + $(this).parent().parent().attr('query_url') + '';
        });

    </script>
<include file="Index/footer" />
