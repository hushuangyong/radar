<include file="Index/header" title="校园雷达-已发布"  />

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


    <div data-am-widget="slider" class="am-slider am-slider-a1" data-am-slider='{"directionNav":false}' >
        <ul class="am-slides">
            <if condition="$userPublishedimg neq ''">
                <foreach name='userPublishedimg' item='vo'>
                    <li><img style="max-width:1349px;max-height:798px" src="__UPLOAD__{$vo.pic}"></li>
                </foreach>
                <else />
                <li><img src="http://s.amazeui.org/media/i/demos/bing-1.jpg"></li>
                <li><img src="http://s.amazeui.org/media/i/demos/bing-2.jpg"></li>
                <li><img src="http://s.amazeui.org/media/i/demos/bing-3.jpg"></li>
                <li><img src="http://s.amazeui.org/media/i/demos/bing-4.jpg"></li>
            </if>
        </ul>
    </div>

    <div class="detail_content">
        <div class="am-g i-title">
            <div class="am-u-sm-6 i-money"><span>
                    <if condition='$userPublished.quest_reward_type eq 1'>
                        ￥{$userPublished.quest_reward}
                        <else />
                        奖励：{$userPublished.quest_reward}
                    </if>
                </span></div>
            <div class="am-u-sm-6 i-time"><span class="leave" id="leave" date="">{$userPublished.dateline}</span></div>
        </div>

        <div class="am-g am-padding-xs">
            <div class="am-u-sm-8">
                <div class="am-fl i-user-logo">
                    <img class="i-user-img" src="__STATIC_IMG__/Radar/Main/img_user.png"/>
                </div>
                <div class="am-fl i-user-name">
                    <h5>{$user_info.username}</h5>
                </div>
            </div>
            <div class="am-u-sm-4 am-text-right i-time-up am-padding-0"><span>{$userPublished.public_time|date='Y-m-d H:i',###}</span></div>
        </div>
        <div class="am-g">
            <p class="i-text">{$userPublished.quest_address}</p>
            <p class="i-text">{$userPublished.quest_intro}</p>
        </div>

        <div class="am-g i-buff-bolck">
            <ul class="am-avg-sm-3 i-buff">
                <if condition='$userPublished.quest_status eq 1'>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li><li><span class="i-buff5">2</span><p>已接单</p></li>
                    <li><span class="i-buff5">3</span><p>已完成</p></li>	
                    <elseif condition='$userPublished.quest_status eq 2'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2</span>
                        <p>已接单</p>
                    </li>
                    <li><span class="i-buff5">3</span><p>已完成</p></li>
                    <elseif condition='$userPublished.quest_status eq 3'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2/3</span>
                        <p>已接单/已确认</p>
                    </li>
                    <li><span class="i-buff5">4</span><p>已完成</p></li>
                    <elseif condition='($userPublished.quest_status eq 4) or ($userPublished.quest_status eq 5)'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2</span>
                        <p>已接单</p>
                    </li>
                    <li>
                        <span class="i-buff4">3</span>
                        <p>已完成</p>
                    </li>
                </if>
            </ul>
            <div class="i-buff-line"></div>
        </div>
    </div>

    <div class="am-g">
        <ul class="am-navbar-nav am-cf am-avg-sm-2 i-buff-btn">
            <li>
                <eq name="userPublished.quest_status" value="1"><a href="__APP__/Home/Ucenter/publish/pubid/{$userPublished.quest_id}">编辑任务</a></eq>
            </li>
            <li>
                <eq name="userPublished.quest_status" value="1"><a href="javascript:void(0);" class="close_quest" qid="{$userPublished.quest_id}" title="关闭任务">关闭任务</a></eq>
            </li>
        </ul>
        <!-- <div class="i-buff-line"></div> -->
    </div>
</div>

<!-- Nav -->
<!-- <div data-am-widget="navbar" class="am-navbar am-cf am-navbar-default  am-no-layout">
        <ul class="am-navbar-nav am-cf am-avg-sm-4">
        <li>
                <a href="###">
                          <i class="am-icon-star-o"></i>
                          <span class="am-navbar-label">收藏</span>
                </a>
        </li>
        <li>
                <a href="###">
                        <i class="am-icon-heart-o"></i>
                        <span class="am-navbar-label">关注</span>
                </a>
        </li>
        <li>
                <a href="###">
                        <i class="am-icon-comment-o"></i>
                        <span class="am-navbar-label">评论</span>
                </a>
        </li>
        <li>
                <a class="am-btn am-btn-warning" href="###">
                        <span class="am-navbar-label">抢单</span>
                </a>
        </li>
        </ul>
</div> -->

<!-- <div data-am-widget="duoshuo" class="am-duoshuo am-duoshuo-default" data-ds-short-name="amazeui">
        <div class="ds-thread" >
        </div>
</div> -->
<script src="__STATIC_JS__/Radar/timer.js"></script>
<script>
                $(function () {
                    //关闭任务
                    $('.close_quest').click(function () {
                        if (false == confirm("确定关闭吗？该操作不可恢复！")) {
                            return false;
                        }
                        var qid = $(this).attr('qid');
                        //var thi = $(this);
                        $.post("__APP__/Home/Ucenter/closeQuest",{'quest_id':qid}, function (data) {
                            if (data.code == 200) {
                                alert(data.msg);
                                window.location.reload();
                            } else {
                                alert(data.msg);
                            }
                        }, 'json');
                    });
                });
</script>
<include file="Index/footer" />
