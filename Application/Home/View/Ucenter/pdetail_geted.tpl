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
            <li><img src="http://s.amazeui.org/media/i/demos/bing-1.jpg"></li>
            <li><img src="http://s.amazeui.org/media/i/demos/bing-2.jpg"></li>
            <li><img src="http://s.amazeui.org/media/i/demos/bing-3.jpg"></li>
            <li><img src="http://s.amazeui.org/media/i/demos/bing-4.jpg"></li>
        </ul>
    </div>

    <div class="detail_content">
        <div class="am-g i-title">
            <div class="am-u-sm-6 i-money"><span>
                    <if condition='$userGeted.quest_reward_type eq 1'>
                        ￥{$userGeted.quest_reward}
                        <else />
                        奖励：{$userGeted.quest_reward}
                    </if>
                </span></div>
            <div class="am-u-sm-6 i-time"><span class="leave" id="leave" date="">{$userGeted.dateline}</span></div>
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
            <div class="am-u-sm-4 am-text-right i-time-up am-padding-0"><span>{$userGeted.public_time|date='Y-m-d H:i',###}</span></div>
        </div>
        <div class="am-g">
            <p class="i-text">详细描述：{$userGeted.quest_intro}</p>
            <p class="i-text">交货地址：{$userGeted.quest_address}</p>
        </div>

        <div class="am-g i-buff-bolck">
            <ul class="am-avg-sm-3 i-buff">
                <if condition='$userGeted.quest_status eq 1'>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li><li><span class="i-buff5">2</span><p>已接单</p></li>
                    <li><span class="i-buff5">3</span><p>已完成</p></li>
                    <elseif condition='$userGeted.quest_status eq 2'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2</span>
                        <p>已接单</p>
                    <li><span class="i-buff5">3</span><p>已完成</p></li>
                    <elseif condition='$userGeted.quest_status eq 3'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2/3</span>
                        <p>已接单/已确认</p>
                    </li>
                    <li><span class="i-buff5">4</span><p>已完成</p></li>
                    <elseif condition='($userGeted.quest_status eq 4) or ($userGeted.quest_status eq 5)'/>
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
                <eq name="userGeted.quest_status" value="2"><a href="{$userGeted.detail_url}" title="评价任务">评价任务</a></li></eq>
            <li>
                <eq name="userGeted.quest_status" value="2"><a href="javascript:void(0);" class="confirm_done_quest" qid="{$userGeted.quest_id}" title="确认完成任务">确认完成任务</a></li></eq>
                <eq name="userGeted.quest_status" value="4"><a href="javascript:void(0);" class="" title="">再来一单</a></li></eq>            
        </ul>
    </div>

    <script src="__STATIC_JS__/Radar/timer.js"></script>
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
    <script>
                $(function () {
                    //确认完成任务
                    $('.confirm_done_quest').click(function () {
                        if (false == confirm("确定完成任务吗？该操作不可恢复！")) {
                            return false;
                        }
                        var qid = $(this).attr('qid');
                        $.post("__APP__/Home/Ucenter/doneQuest",{'quest_id':qid}, function (data) {
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
