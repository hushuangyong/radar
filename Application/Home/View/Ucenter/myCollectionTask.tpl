<include file="Index/header_new" title="校园雷达-我的关注-任务"  />
</head>
<body>

    <div class="ld-comm-top">
        <ul class="ld-nav-three">
            <li class="current"><a href="javascript:void(0);">任务</a></li>
            <li><a href="{:U('Ucenter/myFollowUser')}">用户</a></li>
        </ul>
    </div>

    <div class="ld-my-task">
        <notempty name='dataList'>
            <foreach name='dataList' item='list'>
                <div class="ld-task">
                    <div class="ld-task-item">
                        <div class="ld-task-l">
                            <dl>
                                <dt class="ld-user-avatars"><a href="{$list.sgkeyUrl}"><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                            </dl>
                            <div class="ld-task-l-btn">
                                奖 励
                                <strong>{$list['quest_reward']}</strong>
                            </div>
                        </div>
                        <div class="ld-task-r" query_url="{$list['projectDetail']}">
                            <div class="ld-task-title">
                                <h4>
                                    <a class="ld-task-h4" href="{$list.sgkeyUrl}" title="{$list.quest_title}">{$list['public_username']}<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/></a>
                                    <span class="ld-task-time">
                                        时效倒计时：<em class="leave{$list['quest_id']}" id="leave{$list['quest_id']}" remind="{$list.dateline}">正在计时</em><script> $(function (){showTime("{$list['quest_id']}");}
                                            );</script>
                                    </span>
                                </h4>
                                <div class="ld-task-btn">
                                    <if condition="$list['quest_status'] neq 1 OR ($list['order_user_id'] == $user_id && $user_id)">
                                        <a href="javascript:void(0);" name="" id="" class="can_not_order" disabled="disabled" >已禁用</a>
                                        <else />
                                        <a href="javascript:void(0);" name="projects" id="checkbox_c{$list['quest_id']}" class="ld-home-task-a get_order" quest_id="{$list['quest_id']}" quest_reward="{$list['quest_reward']}">抢单</a>
                                    </if>                                  
                                </div>
                            </div>
                            <p class="ld-task-t" onclick="goProjectDetail('{$list.projectDetail}');">{$list.quest_title}</p>
                            <p class="ld-task-info-m"  onclick="goProjectDetail('{$list.projectDetail}');">{$list.quest_intro} </p>
                            <ul class="ld-task-imgs">
                                <foreach name="list['userPublishedimg']" item="userImg" key="kImg" >
                                    <li><a href="{:U('Project/detail')}?pubid={$list.quest_id}"><img src="__UPLOAD__/{$userImg['pic']}"/></a></li>
                                </foreach>

                            </ul>
                        </div>
                    </div>
                    <div class="ld-my-task-bot">
                        <if condition="$list['public_user_id'] eq $list['follow']['h_user_id']">
                            <a href="javascript:;" class="ld-like delete_follow" title="已关注" qid="{$list['quest_id']}" id="{$list['follow']['id']}"><i class="i-ld i-like-on"></i>已关注楼主</a>
                            <else />
                            <a href="javascript:;"qid="{$list['quest_id']}" class='ld-like sasc'><i class="i-ld i-like-off"></i> 关注</a>
                        </if>
                        <if condition="$list['user_id'] eq $user_id && $user_id neq ''">
                            <a href="javascript:void(0);" class="ld-keep cancel_collec" title="已收藏" qid="{$list['quest_id']}"><i class="i-ld i-keep-on"></i>已收藏</a>
                            <else />
                            <a href="javascript:;"qid="{$list['quest_id']}" class='rasc'><i class="i-ld i-keep-off"></i> 收藏</a>
                        </if>

                        <span>状态：{$list.status_name}</span>
                    </div>
                    <span class="{$list['className']}"></span>
                </div>
            </foreach>
            <else />
            <div style="text-align:center;margin:10px;">暂无记录</div>
        </notempty>



    </div>

    <div class="ld-left-side">
        <ul>
            <li><a href="{:U('Index/index')}" target="_blank"><img src="__STATIC__/assets/img/icon/icn-sy.png"/> <span>首页</span></a></li>
            <li><a href="{$pageUrl['publish']}"><img src="__STATIC__/assets/img/icon/icn-fb.png"/> <span>发布</span></a></li>
            <li><a href="{$pageUrl['myHome']}"><img src="__STATIC__/assets/img/icon/icn-wd.png"/> <span>我的</span></a></li>
        </ul>
    </div>

    <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }" style="display:none;">
        <div class="ld-comm-btn">
            <em id="reward" style="display:none;">0</em><a href="javascript:void(0);" id="nextstep" class="get-order">接 单</a><input type="hidden" id="one_qid" name="one_qid" value="" />
        </div>
    </footer>

    <script type="text/javascript">
        var loginUrl = "{:U('Index/signin')}";//登录页
        //收藏
        $('.rasc').click(function () {
            var user_id = "{$user_id}";
            if (('' == user_id) || (isNaN(user_id))) {
                alert('请先登录～');
                setTimeout(window.location.href = loginUrl, 2000);
                return false;
            }
            var qid = $(this).attr('qid');
            var thi = $(this);
            $.post("__APP__/Home/Ucenter/setCollection", {'qid': qid}, function (data) {
                if (data.code == 404) {
                    alert(data.msg);
                    thi.html("<i class='i-ld i-keep-on'></i> 已收藏");
                } else {
                    alert(data.msg);
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
                        alert(data.msg);
                        return false;
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                    console.log(textStatus);
                    console.log(errorThrown);
                    alert("服务器通讯不稳定，请重试~");
                }
            });
        });

        //关注
        $('.sasc').click(function () {
            var user_id = "{$user_id}";
            if (('' == user_id) || (isNaN(user_id))) {
                alert('请先登录～');
                setTimeout(window.location.href = loginUrl, 2000);
                return false;
            }
            var qid = $(this).attr('qid');
            var thi = $(this);
            $.post("__APP__/Home/Ucenter/setFollow", {'qid': qid}, function (data) {
                if (data.code == 404) {
                    alert(data.msg);
                    thi.html("<i class='i-ld i-like-on'></i> 已关注楼主");
                } else {
                    alert(data.msg);
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
                        alert(data.msg);
                        return false;
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                    console.log(textStatus);
                    console.log(errorThrown);
                    alert("服务器通讯不稳定，请重试~");
                }
            });
        });

        //点击文字跳转
        function goProjectDetail(query_url) {
            location.href = '' + query_url + '';
        }

    </script>        
    <script src="__STATIC_JS__/Radar/timer.js"></script>
<include file="Index/footer_new" />
