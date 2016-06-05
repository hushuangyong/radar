<include file="Index/header_new" title="校园雷达-首页"  />
<script src="https://www.dtd365.com/themes/new/static/js/jquery-1.7.2.min.js"></script>
<link href="__STATIC__/assets/css/fancybox.css" type="text/css" rel="stylesheet" />
<script src="__STATIC__/assets/js/jquery.fancybox-1.3.1.pack.js"></script>
</head>
<body>
    <header data-am-widget="header" class="am-header am-header-default">
        <div class="am-header-left am-header-nav">
            <a href="{$topNav['newest']}" title="校园雷达">
                <img src="__STATIC__/assets/img/logo.png"/>
            </a>
        </div>
    </header>
    <nav data-am-widget="menu" class="am-menu am-menu-dropdown1 ld-nav" data-am-menu-collapse> 
        <a href="javascript: void(0)" class="am-menu-toggle">
            <img class="ld-nav-img" src="__STATIC__/assets/img/icn-nav.png"/>
        </a>
        <ul class="am-menu-nav am-collapse ld-nav-list">
            <li class="ld-nav-item">
                <a href="{$topNav['newest']}"><img src="__STATIC__/assets/img/icn-nav-item1.png"/></a>
            </li>
            <li class="ld-nav-item">
                <a href="{$topNav['study']}"><img src="__STATIC__/assets/img/icn-nav-item2.png"/></a>
            </li>
            <li class="ld-nav-item">
                <a href="{$topNav['purchasing']}"><img src="__STATIC__/assets/img/icn-nav-item3.png"/></a>
            </li>
            <li class="ld-nav-item">
                <a href="{$topNav['errands']}"><img src="__STATIC__/assets/img/icn-nav-item4.png"/></a>
            </li>
            <li class="ld-nav-item">
                <a href="{$topNav['second-hand']}"><img src="__STATIC__/assets/img/icn-nav-item5.png"/></a>
            </li>
            <li class="ld-nav-item">
                <a href="{$topNav['other']}"><img src="__STATIC__/assets/img/icn-nav-item6.png"/></a>
            </li>
            <li class="ld-nav-btn la-nav-first-btn">
                <a href="{$publish}"><img src="__STATIC__/assets/img/icn-nav-b1.png"/>发布</a>
                <a href="{$myCenter}"><img src="__STATIC__/assets/img/icn-nav-b2.png"/>我的</a>
            </li>
            <eq name="user_id" value="">
            <li class="ld-nav-btn"><a href="{$signin}">登录</a><a href="{$signup}">注册</a></li>
            </eq>
        </ul>
        <div class="ld-nav-mask"></div>
    </nav>

    <div class="ld-home">
        <empty name="plist">
            <div class="" id="" style="text-align: center;height: 200px; padding: 100px 0; color: #999;">暂无项目记录</div>
            <else />
            <foreach name="plist" item="list" key="k" >
                <div class="ld-task-item" projectId="{$k}">
                    <div class="ld-task-l">
                        <dl>
                            <dt class="ld-user-avatars"><a href="{$list[0]['sgkeyUrl']}" title="{$list[0]['quest_title']}"><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                            <dd class="ld-task-l-btn">奖 励<strong>{$list[0]['quest_reward']}</strong></dd>
                            <dd class="ld-user-time"></dd>
                        </dl>
                    </div>
                    <div class="ld-task-r">
                        <div class="ld-task-title get_order">
                            <h4>
                                <a class="ld-task-h4" href="{$list[0]['sgkeyUrl']}">{$list[0]['public_username']}<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/><em class="ld-task-tips">{$list[0]['s_name']}</em></a>
                            </h4>
                            <div class="ld-task-btn">
                                <if condition="$list[0]['quest_status'] neq 1 OR ($list[0]['order_user_id'] == $user_id && $user_id)">
                                    <a href="javascript:void(0);" name="" id="disItem_{$list[0]['quest_id']}" class="can_not_order" disabled="disabled" >已被抢</a>
                                    <else />
                                    <a href="javascript:void(0);" id="checkbox_c{$list[0]['quest_id']}" class="ld-home-task-a" quest_id="{$list[0]['quest_id']}" quest_reward="{$list[0]['quest_reward']}">抢单</a>
                                </if>

                            </div>
                        </div>
                        <div class="ld-task-time timer">倒计时：<eq name="list[0]['quest_status']" value="4">--:--:--<else /><span class="leave{$list[0]['quest_id']}" id="leave{$list[0]['quest_id']}" remind="{$list[0].dateline}">正在计时</span><script> $(function (){showTime("{$list[0]['quest_id']}");}
                            );</script></eq></div>
                        <a class="ld-task-info" href="{$list[0]['projectDetail']}" title="{$list[0]['quest_title']}"><b>{$list[0]['quest_title']}</b><br />{$list[0]['quest_intro']} </a>
                        <ul class="ld-task-imgs">
                            <foreach name="list[0]['userPublishedimg']" item="userImg" key="kImg" >
                                <li><a <eq name="userImg['pic_origin']" value="">href="javascript:void(0);"<else/>href="__UPLOAD__{$userImg['pic_origin']}" rel="group"</eq>  title="{$list[0]['quest_title']}"><img src="__UPLOAD__<eq name="userImg['pic']" value="">{$userImg['nonepic']}<else/>{$userImg['pic']}</eq>" /></a></li>
                            </foreach>                            
                        </ul>
                    </div>
                    <div class="ld-home-task-bot ld-my-task-bot">
                        <if condition="$list[0]['public_user_id'] eq $list[0]['follow']['h_user_id']">
                            <a href="javascript:void(0);" qid="{$list[0]['quest_id']}" id="{$list[0]['follow']['id']}" style='color:#4D56A5;' class="delete_follow" title="已关注"><i class="i-ld i-like-on"></i> 已关注楼主</a>
                            <else />
                            <a class="ld-like sasc" href="javascript:void(0);" qid="{$list[0]['quest_id']}" ><i class="i-ld i-like-off"></i>关注楼主</a>
                        </if>

                        <if condition="$list[0]['user_id'] eq $user_id && $user_id neq ''">
                            <a href="javascript:void(0);" qid="{$list[0]['quest_id']}" style='color:#ff9d00' class="cancel_collec" title="已收藏"><i class="i-ld i-keep-on"></i> 已收藏</a>
                            <else />
                            <a href="javascript:void(0);" qid="{$list[0]['quest_id']}" class='rasc'><i class="i-ld i-keep-off"></i>收藏</a>
                        </if>
                        <span>状态：{$list[0]['status_name']}</span>
                    </div>
                </div>
            </foreach>
        </empty>
		 <div class="ld-left-side">
	        <ul>
	            <li id="ld-go-top"><a href="javascript:;"><img src="__STATIC__/assets/img/icon/icn-top.png"/> <span>顶部</span></a></li>
	            <li><a href="{$pageUrl['publish']}"><img src="__STATIC__/assets/img/icon/icn-fb.png"/> <span>发布</span></a></li>
            	<li><a href="{$pageUrl['myGetted']}"><img src="__STATIC__/assets/img/icon/icn-wd.png"/> <span>我的</span></a></li>
	        </ul>
	    </div>
    </div>
    <div class="operation" style="position: relative;text-align: center;bottom: 3.4em; height: 30px; line-height: 30px; background: #f3f5f9;">
        <a href="javascript:void(0);" class="load_more" style="display: block;" title="点击加载">加载更多</a>
        <a href="#" class="loading" id="loading" style="display:none;">加载中。。。</a>
        <input type="hidden" id="hidePage" name="hidePage" value="1" />
        <input type="hidden" id="one_qid" name="one_qid" value="" />
    </div>

    <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }" style="display:none;">
        <div class="am-margin-sm">
            <span class="ld-home-task-s">奖 励：<strong>￥<em id="reward">0</em></strong></span>
            <a class="ld-home-task-b" id="nextstep" href="javascript:void(0);">抢单</a>
            <span class="am-cf"></span>
        </div>
    </footer>

    <script type="text/javascript">
        $(function () {

            var user_id = '{$Think.session.user_id}';
            var url = "{:U('Index/signin')}";//登录页面
            var num = 1; //初始化请求次数

            //自动加载
            var totalheight = 0; //定义一个总的高度变量
            $(window).scroll(function () {
                totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()); //浏览器的高度加上滚动条的高度
                if ($(document).height() <= totalheight) { //当文档的高度小于或者等于总的高度的时候，开始动态加载数据
                    //loadMore();
                }
            });
            //滚动加载


            //点击加载
            $('.load_more').on("click", function () {
                //return false;
                $(this).hide();
                setTimeout(function () {
                    loadMore();
                }, 100);
            });
            //ajax加载更多信息
            function loadMore() {
                $.ajax({
                    url: "{:U('Index/radar')}",
                    type: "post",
                    timeout: 10000,
                    //dataType: "json",
                    data: {
                        'type': "{$_type}",
                        'dataType': "dataJson",
                        'page': parseInt($("#hidePage").val()) + 1,
                        "sgkey": "{$_sgkey}"
                    },
                    beforeSend: function () {
                        $('.loading').show(); //显示 加载中
                    },
                    success: function (dataSource) {
                        var html = "";
                        var resultArr = dataSource;
                        var user_id = "{$user_id}";
                        if (resultArr.length <= 0) {
                            html = '<div id="" class="" style="text-align: center;line-height: 50px;height: 50px;color: #999;">没有了，亲！</div>';
                            $('.load_more').unbind();
                            $('.operation').hide();
                        } else {
                            for (var i = 0; i < resultArr.length; i++) {
                                html += '<div class="ld-task-item" project_id="' + resultArr[i][0]['quest_id'] + '"><div class="ld-task-l"><dl><dt class="ld-user-avatars"><a href="' + resultArr[i][0]['projectDetail'] + '"><img src="/Public/assets/img/temp/img-user.jpg"/></a></dt><dd class="ld-task-l-btn"><a href="#' + resultArr[i][0]['projectDetail'] + '" >奖 励<strong>' + resultArr[i][0]['quest_reward'] + '</strong></a></dd><dd class="">';
                                html += '</dd></dl></div>';
                                html += '<div class="ld-task-r"><div class="ld-task-title get_order"><h4><a class="ld-task-h4" href="' + resultArr[i][0]['projectDetail'] + '">' + resultArr[i][0]['public_username'] + '<img class="ld-user-lv" src="/Public/assets/img/icn-user-lv.png"><em class="ld-task-tips">' + resultArr[i][0]['s_name'] + '</em></a>';

                                html += '</h4><div class="ld-task-btn">';
                                if (resultArr[i][0]['quest_status'] != 1 || (resultArr[i][0]['order_user_id'] == user_id && user_id)) {
                                    html += '<a href="javascript:void(0);" name="can_not_choose" id="dis_' + resultArr[i][0]['quest_id'] + '" class="can_not_order" disabled="disabled" >已经被抢</a>';
                                } else {
                                    html += '<a href="javascript:void(0);" name="projects" id="checkbox_c' + resultArr[i][0]['quest_id'] + '" class="ld-home-task-a" quest_id="' + resultArr[i][0]['quest_id'] + '" quest_reward="' + resultArr[i][0]['quest_reward'] + '" >抢单</a>';
                                }
                                html += '</div></div>';
                                html += '<div class="ld-task-time timer">倒计时：';
                                if (resultArr[i][0]['quest_status'] == 4) {
                                    html += '--:--:--';//已完成
                                } else {
                                    html += '<span class="leave' + resultArr[i][0]['quest_id'] + '" id="leave' + resultArr[i][0]['quest_id'] + '" remind="' + resultArr[i][0]['dateline'] + '">计时中</span>';
                                    html += "<script type='text/javascript' >showTime('" + resultArr[i][0]['quest_id'] + "');<\/script>";
                                }
                                html += '</div>';
                                html += '<a class="ld-task-info" href="' + resultArr[i][0]['projectDetail'] + '" title="' + resultArr[i][0]['quest_title'] + '"><b>' + resultArr[i][0]['quest_title'] + '</b><br />' + resultArr[i][0]['quest_intro'] + ' </a><ul class="ld-task-imgs">';
                                for (var j = 0; j < resultArr[i][0]['userPublishedimg'].length; j++) {
                                    if (resultArr[i][0]['userPublishedimg'][j]['pic_origin']) {
                                        html += '<li><a href="' + resultArr[i][0]['userPublishedimg'][j]['pic_domain'] + resultArr[i][0]['userPublishedimg'][j]['pic_origin'] + '" class="photo_list" rel="group"> <img src = "' + resultArr[i][0]['userPublishedimg'][j]['pic_domain'] + resultArr[i][0]['userPublishedimg'][j]['pic'] + '" /></a></li>'; //项目图片 有大图
                                    } else {
                                        html += '<li><a href="javascript:void(0);" class="none-pic" rel="none-pic"> <img src = "' + resultArr[i][0]['userPublishedimg'][j]['pic_domain'] + resultArr[i][0]['userPublishedimg'][j]['pic'] + '" /></a></li>'; //项目图片 无大图
                                    }
                                }
                                html += '</ul></div>';
                                html += '<div class="ld-home-task-bot ld-my-task-bot">';
                                if (resultArr[i][0]['follow'] != null) {
                                    if (resultArr[i][0]['public_user_id'] == resultArr[i][0]['follow']['h_user_id']) {
                                        html += '<a href="javascript:void(0);" qid="' + resultArr[i][0]['quest_id'] + '" id="' + resultArr[i][0]['follow']['id'] + '" style="color:#4D56A5;" class="delete_follow" title="已关注"><i class="i-ld i-like-on"></i> 已关注楼主</a>';
                                    } else {
                                        html += '<a class="ld-like sasc" href="javascript:void(0);" qid="' + resultArr[i][0]['quest_id'] + '"><i class="i-ld i-like-off"></i>关注楼主</a>';
                                    }
                                } else {
                                    html += '<a class="ld-like sasc" href="javascript:void(0);" qid="' + resultArr[i][0]['quest_id'] + '"><i class="i-ld i-like-off"></i>关注楼主</a>';
                                }

                                if (resultArr[i][0]['user_id'] == user_id && user_id != '') {
                                    html += '<a href="javascript:void(0);"qid="' + resultArr[i][0]['quest_id'] + '" class="cancel_collec" title="已收藏"><i class="i-ld i-keep-on"></i> 已收藏</a>';
                                } else {
                                    html += '<a href="javascript:void(0);"  qid="' + resultArr[i][0]['quest_id'] + '" class="rasc"><i class="i-ld i-keep-off"></i>收藏</a>';
                                }
                                html += '<span class="">状态：' + resultArr[i][0]['status_name'] + '</span></div>';
                                html += '</div>';
                            }
                            num += 1; //累加请求次数
                            $("#hidePage").val(num);
                            $('.load_more').fadeIn();
                            $('.operation').show();
                        }
                        $('.loading').hide(); //隐藏 加载中
                        $(".ld-home").append(html);

                    },
                    error: function () {
                        alert('哎呀，加载失败啦！(┬＿┬)');
                    }
                });
            }



        });
    </script>

    <script type="text/javascript">
        var loginUrl = "{:U('Index/signin')}"; //登录页
        //收藏
        $(document).on("click", ".rasc", function () {
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
                    thi.css('color', '#ff9d00');
                } else {
                    alert(data.msg);
                }
            }, 'json')
        });
        //取消收藏
        $(document).on('click', '.cancel_collec', function () {
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
        $(document).on("click", ".sasc", function () {
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
                    thi.css('color', '#4D56A5');
                } else {
                    alert(data.msg);
                }
            }, 'json');
        });
        //取消关注
        $(document).on("click", ".delete_follow", function () {
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
        //$(document).on("click", ".ld-task-info", function () {
        //location.href = '' + $(this).attr('query_url') + '';
        //});

    </script>
    <script>
        //缩略图预览
        $(function () {
            $(document).on("click", ".photo_list", function () {
                $("a[rel=group]").fancybox({});
                return false;
            });
            $("a[rel=group]").fancybox({
                'width': '500px',
                'titlePosition': 'over',
                'autoScale': true,
                'cyclic': true,
                'titleFormat': function (title, currentArray, currentIndex, currentOpts) {
                    return '<span id="fancybox-title-over">' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
                }
            });
        });
    </script>
    <script src="__STATIC_JS__/Radar/timer.js"></script>
<include file="Index/footer_new" />