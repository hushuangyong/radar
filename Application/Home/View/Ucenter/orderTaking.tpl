<include file="Index/header_new" title="校园雷达-我的接单"  />
</head>
<body>

    <div class="ld-comm-top">
        <ul class="ld-nav-three">
            <foreach name="orderStatus" item="list">
                <li <eq name='status' value="$list['status']">class="current"</eq> ><a href="{$list['url']}" title="{$list['name']}">{$list['name']}</a></li>
            </foreach>
        </ul>
    </div>

    <div class="ld-my-task">
        <notempty name='userGeted'>
            <foreach name='userGeted' item='list'>
                <div class="ld-task">
                    <div class="ld-task-item ld-task-item-fix">
                        <div class="ld-task-l">
                            <dl>
                                <dt class="ld-user-avatars"><a href="{$list.sgkeyUrl}"><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                                <!--<dd class="ld-task-l-btn">
                                    奖 励
                                    <strong>{$list['quest_reward']}</strong>
                                </dd>-->
                            </dl>
                        </div>
                        <div class="ld-task-r" query_url="{$list['projectDetail']}">
                            <div class="ld-task-title">
                                <h4>
                                    <a class="ld-task-h4" href="{$list.sgkeyUrl}" title="{$list.quest_title}">{$list['public_username']}<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/></a>
                                    <span class="<eq name='list.quest_status' value='4'>ld-task-time-end<else />ld-task-time</eq>">
                                        倒计时：<eq name='list.quest_status' value='4'>--:--:--<else /><em class="leave{$list['quest_id']}" id="leave{$list['quest_id']}" remind="{$list.dateline}">正在计时</em><script> $(function (){showTime("{$list['quest_id']}");}
                                            );</script></eq>
                                    </span>
                                </h4>
                                <div class="ld-task-btn">
                                    <if condition="$list[0]['quest_status'] neq 1 OR ($list[0]['order_user_id'] == $user_id && $user_id)">
                                        <a href="javascript:void(0);" name="" id="disItem_{$list[0]['quest_id']}" class="can_not_order" disabled="disabled" >已被抢</a>
                                        <else />
                                        <a href="javascript:void(0);" id="checkbox_c{$list[0]['quest_id']}" class="ld-home-task-a" quest_id="{$list[0]['quest_id']}" quest_reward="{$list[0]['quest_reward']}">抢单</a>
                                    </if>
                                </div>
                            </div>
                            <p class="ld-task-t"  onclick="goProjectDetail('{$list.projectDetail}');">{$list.quest_title}</p>
                            <p class="ld-task-t"><span>状态：{$list.status_name}</span></p>
                            <!--<p class="ld-task-info-m"  onclick="goProjectDetail('{$list.projectDetail}');">{$list.quest_intro} </p>
                            <ul class="ld-task-imgs">
                                <foreach name="list['userPublishedimg']" item="userImg" key="kImg" >
                                    <li><a href="{:U('Ucenter/myOrderDetail')}?pubid={$list.quest_id}"><img src="__UPLOAD__/{$userImg['pic']}"/></a></li>
                                </foreach>

                            </ul>-->
                        </div>
                    </div>
                    <!--<div class="ld-my-task-bot">
                        <if condition="$list['public_user_id'] eq $list['follow']['h_user_id']">
                            <a href="javascript:;" class="ld-like delete_follow" title="已关注" qid="{$list['quest_id']}" id="{$list['follow']['id']}"><i class="i-ld i-like-on"></i>已关注楼主</a>
                            <else />
                            <a href="javascript:;"qid="{$list['quest_id']}" class='ld-like sasc'><i class="i-ld i-like-off"></i> 关注</a>
                        </if>
                        <if condition="$list['user_id'] eq $user_id && $user_id neq ''">
                            <a href="" class="ld-keep cancel_collec" title="已收藏" qid="{$list['quest_id']}"><i class="i-ld i-keep-on"></i>已收藏</a>
                            <else />
                            <a href="javascript:;"qid="{$list['quest_id']}" class='rasc'><i class="i-ld i-keep-off"></i> 收藏</a>
                        </if>

                        <span>状态：{$list.status_name}</span>
                    </div>-->
                    <span class="{$list['className']}"></span>
                </div>
            </foreach>
            <else />
            <div style="text-align:center;margin:10px;">暂无记录</div>
        </notempty>

        <div class="ld-task" style='display:none;'>
            <div class="ld-task-item">
                <div class="ld-task-l">
                    <dl>
                        <dt class="ld-user-avatars"><a href=""><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                    </dl>
                    <div class="ld-task-l-btn">
                        奖 励
                        <strong>¥500</strong>
                    </div>
                </div>
                <div class="ld-task-r">
                    <div class="ld-task-title">
                        <h4>
                            <a class="ld-task-h4" href="">用户ID/昵称用户ID<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/></a>
                            <span class="ld-task-time-end">
                                时效倒计时：<em>00:05:59</em>
                            </span>
                        </h4>
                        <div class="ld-task-btn">
                            <input type="checkbox" id="checkbox_c4" class="ld-check"><label for="checkbox_c4"></label>
                        </div>
                    </div>
                    <p class="ld-task-t">标题</p>
                    <p class="ld-task-info-m">描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描 ...</p>
                    <ul class="ld-task-imgs">
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                    </ul>
                </div>
            </div>
            <div class="ld-my-task-bot">
                <a class="ld-like" href=""><i class="i-ld i-like-on"></i>已关注楼主</a>
                <a class="ld-keep" href=""><i class="i-ld i-keep-on"></i>已收藏</a>
                <span>状态：完成待确认</span>
            </div>
            <span class="ld-task-end"></span>
        </div>

        <div class="ld-task" style="display:none;">
            <div class="ld-task-item">
                <div class="ld-task-l">
                    <dl>
                        <dt class="ld-user-avatars"><a href=""><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                    </dl>
                    <div class="ld-task-l-btn">
                        奖 励
                        <strong>¥500</strong>
                    </div>
                </div>
                <div class="ld-task-r">
                    <div class="ld-task-title">
                        <h4>
                            <a class="ld-task-h4" href="">用户ID/昵称用户ID<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/></a>
                            <span class="ld-task-time-end">
                                时效倒计时：<em>00:05:59</em>
                            </span>
                        </h4>
                        <div class="ld-task-btn">
                            <input type="checkbox" id="checkbox_c4" class="ld-check"><label for="checkbox_c4"></label>
                        </div>
                    </div>
                    <p class="ld-task-t">标题</p>
                    <p class="ld-task-info-m">描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描 ...</p>
                    <ul class="ld-task-imgs">
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                        <li><a href=""><img src="__STATIC__/assets/img/temp/img-01.jpg"/></a></li>
                    </ul>
                </div>
            </div>
            <div class="ld-my-task-bot">
                <a class="ld-like" href=""><i class="i-ld i-like-on"></i>已关注楼主</a>
                <a class="ld-keep" href=""><i class="i-ld i-keep-on"></i>已收藏</a>
                <span>状态：完成待确认</span>
            </div>
            <span class="ld-task-end"></span>
        </div>

    </div>

    <div class="ld-left-side">
        <ul>
            <li><a href="{:U('Index/index')}" target="_blank"><img src="__STATIC__/assets/img/icon/icn-sy.png"/> <span>首页</span></a></li>
            <li><a href="{$pageUrl['publish']}"><img src="__STATIC__/assets/img/icon/icn-fb.png"/> <span>发布</span></a></li>
            <li><a href="{$pageUrl['myHome']}"><img src="__STATIC__/assets/img/icon/icn-wd.png"/> <span>我的</span></a></li>
        </ul>
    </div>

    <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }">
        <div class="ld-comm-btn" style="display:none;">
            <a class="ld-dis" href="">接 单</a>
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
            $.post("__APP__/Home/Ucenter/setCollection",{'qid':qid}, function (data) {
                if (data.code == 404) {
                    alert(data.msg);
                    thi.html("<i class='i-ld i-keep-on'></i> 已收藏");
                    thi.css('color', '#f76257');
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
            $.post("__APP__/Home/Ucenter/setFollow",{'qid':qid}, function (data) {
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
