<include file="Index/header" title="校园雷达-详情"  />
</head>
<body>

    <!-- Header -->
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="javascript:;" onclick="goback();" ><img class="am-header-icon-custom" src="data:image/svg+xml;charset=utf-8,&lt;svg xmlns=&quot;http://www.w3.org/2000/svg&quot; viewBox=&quot;0 0 12 20&quot;&gt;&lt;path d=&quot;M10,0l2,2l-8,8l8,8l-2,2L0,10L10,0z&quot; fill=&quot;%23fff&quot;/&gt;&lt;/svg&gt;" alt="">
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
                <foreach name='userPublishedimg' item='vo' key='k'>
                    <if condition='$k elt 3'>
                        <li><img style="max-width:1349px;max-height:150px;"  src="__UPLOAD__{$vo.pic}" width="200" height="150" title="" alt="" /></li>
                    </if>
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
                    <if condition='$projectDetail.quest_reward_type eq 1'>
                        ￥{$projectDetail.quest_reward}
                        <else />
                        奖励：{$projectDetail.quest_reward}
                    </if></span></div>
            <div class="am-u-sm-6 i-time"><span class="leave" id="leave" date="">{$projectDetail.dateline}</span></div>
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
            <div class="am-u-sm-4 am-text-right i-time-up am-padding-0"><span>{$projectDetail.public_time|date='Y-m-d H:i',###}</span></div>
        </div>
        <div class="am-g">
            <p class="i-text">{$projectDetail.quest_intro}</p>
        </div>

        <div class="am-g i-buff-bolck">
            <ul class="am-avg-sm-3 i-buff">
                <if condition='$projectDetail.quest_status eq 1'>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li><span class="i-buff5">2</span><p>已接单</p></li>
                    <li><span class="i-buff5">3</span><p>已完成</p></li>
                    <elseif condition='$projectDetail.quest_status eq 2'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2</span>
                        <p>已接单</p>
                    </li>
                    <li><span class="i-buff5">3</span><p>已完成</p></li>
                    <elseif condition='$projectDetail.quest_status eq 3'/>
                    <li>
                        <span class="i-buff1">1</span>
                        <p>已发布</p>
                    </li>
                    <li>
                        <span class="i-buff2">2</span>
                        <p>已接单</p>
                    </li>
                    <li><span class="i-buff4">3</span><p>已完成</p></li>
                    <elseif condition='($projectDetail.quest_status eq 4) OR ($projectDetail.quest_status eq 5)'/>
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

    <div data-am-widget="duoshuo" class="am-duoshuo am-duoshuo-default" data-ds-short-name="amazeui">
        <div class="ds-thread" >
        </div>
    </div>

    <!-- Nav -->
    <div data-am-widget="navbar" class="am-navbar am-cf am-navbar-default  am-no-layout">
        <ul class="am-navbar-nav am-cf am-avg-sm-4">
            <li>
            <if condition="($user_id != '') AND ($user_id eq $projectDetail['user_id'])">
                <a href="javascript:;" class="cancel_collec" id="{$projectDetail.quest_id}" style='color:#ff9d00' title="已收藏"><i class="am-icon-star-o"></i><span class="am-navbar-label">已收藏</span></a>
                <else />
                <a href="javascript:;" class='rasc' qid="{$projectDetail.quest_id}"><i class="am-icon-star-o"></i><span class="am-navbar-label">收藏</span></a>
            </if>
            </li>
            <li>
            <if condition="$projectDetail['public_user_id'] eq $projectDetail['follow']['h_user_id']">
                <a href="javascript:;" class='delete_follow' id="{$projectDetail['follow']['id']}" style='color:#ff9d00' qid="{$projectDetail.quest_id}" title="已关注"><i class="am-icon-heart-o"></i><span class="am-navbar-label">已关注</span></a>
                <else />
                <a href="javascript:;" class='sasc' qid="{$projectDetail.quest_id}"><i class="am-icon-heart-o"></i><span class="am-navbar-label">关注</span></a>
            </if>

            </li>
            <li>
                <a href="###" id="go_to_comment">
                    <i class="am-icon-comment-o"></i>
                    <span class="am-navbar-label">评论</span>
                </a>
            </li>
            <if condition='$projectDetail.quest_status eq 1'>
                <li>
                    <a class="am-btn am-btn-warning" href="javascript:;" onclick="getPro();" >
                        <span id="nextstep" class="am-navbar-label">抢单</span>
                    </a>
                </li>
            </if>
        </ul>
    </div>

    <!-- <div data-am-widget="duoshuo" class="am-duoshuo am-duoshuo-default" data-ds-short-name="amazeui">
            <div class="ds-thread" data-thread-key='1'>
            </div>
    </div> -->

    <script type='text/javascript'>
                        var quest_id = '{$projectDetail.quest_id}';
                        var user_id = '{$Think.session.user_id}';
                        var url = "{:U('Index/login')}";

                        function sleeptime(n) { //n表示的毫秒数
                            var start = new Date().getTime();
                            while (true)
                                if (new Date().getTime() - start > n)
                                    break;
                        }

                        //抢单
                        function getPro() {
                            if (user_id) {
                                if (confirm("亲，确定要抢单么？")) {
                                    $("#nextstep").attr("submiting", '1').text("提交中...");
                                    $.ajax({
                                        type: "POST",
                                        url: "{:U('Ucenter/getOrder')}",
                                        dataType: "json",
                                        data: "quest_id=" + quest_id,
                                        success: function (res) {
                                            if (res.code == 200) {
                                                showalert("恭喜您，抢单成功！");
                                                setTimeout(window.location.href = res.info, 2000);
                                            } else {
                                                showalert(res.msg);
                                                $("#nextstep").attr("submiting", '0').text("抢单");
                                            }
                                        },
                                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                                            showalert("服务器通讯不稳定，请重试~");
                                            $("#nextstep").attr("submiting", '0').text("抢单");
                                        }

                                    });
                                } else {
                                    return false;
                                }
                            } else {
                                showalert("请先登录！");
                                setTimeout(window.location.href = url, 2000);
                            }


                        }
    </script>
    <script src="__STATIC_JS__/Radar/timer.js"></script>
    <script>
        //收藏
        $('.rasc').click(function () {
            if (('' == user_id) || (isNaN(user_id))) {
                showalert('请先登录～');
                setTimeout(window.location.href = url, 2000);
                return false;
            }

            var qid = $(this).attr('qid');
            var thi = $(this);
            $.post("__APP__/Home/Ucenter/setCollection",{qid:qid}, function (data) {
                if (data.code == 404) {
                    showalert(data.msg);
                    thi.html("<i class='am-icon-star-o'></i><span class='am-navbar-label'>已收藏</span>");
                    thi.css('color', '#ff9d00');
                } else {
                    showalert(data.msg);
                }

            }, 'json');

        });

        //取消收藏
        $('.cancel_collec').click(function () {
            if (false == confirm("确定删除吗？该操作不可恢复！")) {
                return false;
            }
            var pubid = $(this).attr('id');
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
            if (('' == user_id) || (isNaN(user_id))) {
                showalert('请先登录～');
                setTimeout(window.location.href = url, 2000);
                return false;
            }

            var qid = $(this).attr('qid');
            var thi = $(this);
            $.post("__APP__/Home/Ucenter/setFollow",{qid:qid}, function (data) {
                if (data.code == 404) {
                    showalert(data.msg);
                    thi.html("<i class='am-icon-heart-o'></i><span class='am-navbar-label'>已关注</span>");
                    thi.css('color', '#ff9d00');
                } else {
                    showalert(data.msg);
                }

            }, 'json');

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

        //评论
        $('#go_to_comment').click(function () {
            $("html,body").animate({scrollTop: $('html,body').height()}, 200);
        });
    </script>

<include file="Index/footer" />
