<include file="Index/header_new" title="校园雷达-我的接单详情"  />
</head>
<body>

    <div class="ld-task-banner">
        <img src="__STATIC__/assets/img/temp/img-banner.jpg"/>
    </div>

    <div class="ld-task ld-task-my">
        <div class="ld-task-item">
            <div class="ld-task-l">
                <dl>
                    <dt class="ld-user-avatars"><a href="{$userGeted.sgkeyUrl}"><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                </dl>
            </div>
            <div class="ld-task-r">
                <div class="ld-task-title">
                    <h4>
                        <a class="ld-task-h4" href="{$userGeted.detail_url}">{$userGeted['public_username']}<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/></a>
                        <span class="ld-task-time">
                            倒计时：<eq name='userGeted.quest_status' value='4'>--:--:--<else /><em class="leave{$userGeted['quest_id']}" id="leave{$userGeted['quest_id']}" remind="{$userGeted.dateline}">正在计时</em>
                            <script>
                                $(function () {
                                    showTime("{$userGeted['quest_id']}");
                                });
                            </script></eq>
                        </span>
                    </h4>
                    <div class="ld-task-btn">
                        奖 励
                        <strong>¥{$userGeted.quest_reward}</strong>
                    </div>
                </div>
                <p class="ld-task-info-m">{$userGeted.quest_intro} </p>
                <p class="ld-task-addr"><if condition="$user_info['id'] && ($user_info['id'] eq $userGeted['order_user_id']  )">收货人：{$userGeted['receive_name']}<br />手机号：{$userGeted['telephone']}<br /></if>交货地址：{$userGeted.quest_address}</p>
                <ul class="ld-task-imgs">
                    <foreach name="userGeted['userPublishedimg']" item="userImg" key="kImg" >
                        <li><a href="{$userGeted.detail_url}"><img src="__UPLOAD__/{$userImg['pic']}"/></a></li>
                    </foreach>

                </ul>
            </div>
        </div>
    </div>
    <div class="ld-task-blank5"></div>
    <div class="ld-task-buff-fix">
    	<eq name="userGeted['quest_status']" value="2">
    		<ul>
				<li class="current">
					<span>1</span>
				</li>
				<li class="current">
					<div class="ld-task-buff-line"></div>
				</li>
				<li>
					<span>2</span>
				</li>
				<li>
					<div class="ld-task-buff-line"></div>
				</li>
				<li>
					<span>3</span>
				</li>
			</ul>
			<ul class="ld-task-buff-txt">
				<li class="current"><strong>已接单</strong></li>
				<li><strong>完成待确认</strong></li>
				<li><strong>已完成</strong></li>
			</ul>
    	</eq>
    	<eq name="userGeted['quest_status']" value="3">
    		<ul>
				<li class="current">
					<span>1</span>
				</li>
				<li class="current">
					<div class="ld-task-buff-line"></div>
				</li>
				<li class="current">
					<span>2</span>
				</li>
				<li class="current">
					<div class="ld-task-buff-line"></div>
				</li>
				<li>
					<span>3</span>
				</li>
			</ul>
			<ul class="ld-task-buff-txt">
				<li class="current"><strong>已接单</strong></li>
				<li class="current"><strong>完成待确认</strong></li>
				<li><strong>已完成</strong></li>
			</ul>
    	</eq>
    	<eq name="userGeted['quest_status']" value="4">
    		<ul>
				<li class="current">
					<span>1</span>
				</li>
				<li class="current">
					<div class="ld-task-buff-line"></div>
				</li>
				<li class="current">
					<span>2</span>
				</li>
				<li class="current">
					<div class="ld-task-buff-line"></div>
				</li>
				<li class="current">
					<span>3</span>
				</li>
			</ul>
			<ul class="ld-task-buff-txt">
				<li class="current"><strong>已接单</strong></li>
				<li class="current"><strong>完成待确认</strong></li>
				<li class="current"><strong>已完成</strong></li>
			</ul>
    	</eq>
        <div class="ld-task-sub">
            <eq name="userGeted.quest_status" value="2"><a class="ld-btn-push confirm_done_quest" href="javascript:void(0);" class="confirm_done_quest" qid="{$userGeted['quest_id']}" title="提交任务">提交任务</a></eq>
            <eq name="userGeted.quest_status" value="3"><a href="javascript:void(0);" class="cannot" title="该任务已提交">该任务已提交</a></eq>
            <eq name="userGeted.quest_status" value="4"><a href="javascript:void(0);" class="cannot" title="该任务已结束！">该任务已结束！</a></eq>
        </div>
    </div>
    <div class="ld-task-blank5"></div>

    <div class="ld-task-comment">
        <div class="ld-task-comment-top">
            <span class="am-fl">评论</span>
            <span class="am-fr">
                <if condition="$userGeted['public_user_id'] eq $userGeted['follow']['h_user_id']">
                    <a href="javascript:void(0);" qid="{$userGeted['quest_id']}" id="{$userGeted['follow']['id']}" style='' class="ld-like delete_follow" title="已关注楼主"><i class="i-ld i-like-on"></i> 已关注楼主</a>
                    <else />
                    <a class="ld-like sasc" href="javascript:void(0);" qid="{$userGeted['quest_id']}" ><i class="i-ld i-like-off"></i>关注楼主</a>
                </if>

                <if condition="$userGeted['user_id'] eq $user_id && $user_id neq ''">
                    <a href="javascript:void(0);" qid="{$userGeted['quest_id']}" style='' class="ld-keep cancel_collec" title="已收藏"><i class="i-ld i-keep-on"></i> 已收藏</a>
                    <else />
                    <a href="javascript:void(0);" qid="{$userGeted['quest_id']}" class='rasc'><i class="i-ld i-keep-off"></i>收藏</a>
                </if>
            </span>
        </div>
        <div class="ld-task-comment-body">



        </div>
    </div>

    <div class="ld-left-side">
        <ul>
            <li><a href="{$pageUrl['indexHome']}"><img src="__STATIC__/assets/img/icon/icn-sy.png"/> <span>首页</span></a></li>
            <li><a href="{$pageUrl['publish']}"><img src="__STATIC__/assets/img/icon/icn-fb.png"/> <span>发布</span></a></li>
            <li><a href="{$pageUrl['myHome']}"><img src="__STATIC__/assets/img/icon/icn-wd.png"/> <span>我的</span></a></li>
        </ul>
    </div>

    <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }">
        <div class="am-margin-sm">
            <input class="ld-comment-input" type="text" id="" value="" placeholder="随便说点什么吧" />
            <a class="ld-comment-btn" href="javascript:void(0);" qid='{$userGeted.quest_id}'>评论</a>
            <span class="am-cf"></span>
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

    </script>
    <script>
        $(function () {
            //提交任务
            $('.confirm_done_quest').click(function () {
                if (false == confirm("确定提交任务吗？该操作不可恢复！")) {
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
            var quest_id = "{$userGeted['quest_id']}";
            //评论
            $('.ld-comment-btn').click(function () {
                var content = $.trim($('.ld-comment-input').val());
                if ('' == content) {
                    $('.ld-comment-input').focus();
                    alert('请填写评论内容！');
                    return false;
                }
                var qid = $(this).attr('qid');
                $.post("__APP__/Home/Ucenter/cmtQuest",{'quest_id':qid,'content':content}, function (data) {
                    if (data.code == 200) {
                        alert(data.msg);
                        $('.ld-task-comment-body').html('');//清空评论的列表
                        $('.ld-comment-input').val('');//清空评论框的内容
                        getCmtList(qid);
                    } else {
                        alert(data.msg);
                    }
                }, 'json');
            });
            //获取评论
            setTimeout(getCmtList(quest_id), 5000);
        });
        function getCmtList(qid) {
            $.ajax({
                type: "POST", //请求方式  
                url: "{:U('Ucenter/getCmt')}",
                data: {"quest_id":qid},
                success: function (msg) {
                    if (200 == msg.code) {
                        var html = "";
                        $.each(msg.data, function (i, item) {
                            html += '<div class="ld-task-item"><div class="ld-task-l"><dl><dt class="ld-user-avatars"><a href="' + item.sgkeyUrl + '"><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt></dl></div><div class="ld-task-r"><div class="ld-task-title"><h4><a class="ld-task-h4" href="">' + '' + item.user_name + '</a></h4></div><p class="ld-task-info-m">' + item.content + ' </p></div></div>';
                        });
                    } else {
                        //alert(msg.msg);
                        html = "<div style='    text-align: center;    margin: 10px;    padding: 10px;'>暂时没有人评论，赶快抢沙发！</div>";
                    }
                    $('.ld-task-comment-body').append(html);
                }
            });
        }
    </script>

    <script src="__STATIC_JS__/Radar/timer.js"></script>
<include file="Index/footer_new" />
