<include file="Index/header_new" title="校园雷达-我的个人中心"  />
</head>
<body>

    <div class="ld-task ld-task-my">
        <div class="ld-task-item">
            <div class="ld-task-l">
                <dl>
                    <dt class="ld-user-avatars"><a href=""><img src="<eq name='user_info.headimgurl' vlaue=''>__STATIC__/assets/img/temp/img-user.jpg<else />{$user_info.headimgurl}</eq>"/></a></dt>
                </dl>
            </div>
            <div class="ld-task-r">
                <div class="ld-user-title">
                    <h4>
                        <a class="ld-task-h4" href="">{$user_info['username']}<img class="ld-user-lv" src="__STATIC__/assets/img/icn-user-lv.png"/></a>
                    </h4>
                </div>
            </div>
            <div class="ld-user-details am-hide">
                <ul>
                    <li>积分：{$user_info['point']}</li>
                    <li class="ld-user-details-line"></li>
                    <li>等级：{$user_info.level}</li>
                </ul>
            </div>
        </div>
    </div>

    <div class="ld-list">
        <ul>
            <li>
                <a href="{$pageUrl['published']}">
                    <img class="ld-list-l" src="__STATIC__/assets/img/icon/icn-user1.png"/>我的发布
                    <img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/>
                </a>
            </li>
            <li>
                <a href="{$pageUrl['myGetted']}">
                    <img class="ld-list-l" src="__STATIC__/assets/img/icon/icn-user2.png"/>我的接单
                    <img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/>
                </a>
            </li>
            <li>
                <a href="{$pageUrl['myFocus']}">
                    <img class="ld-list-l" src="__STATIC__/assets/img/icon/icn-user3.png"/>我的关注
                    <img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/>
                </a>
            </li>
            <li>
                <a href="{$pageUrl['userAddress']}">
                    <img class="ld-list-l" src="__STATIC__/assets/img/icon/icn-user2.png"/>地址管理
                    <img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/>
                </a>
            </li>
        </ul>
        <ul>
            <li>
                <a href="{$pageUrl['aboutUs']}">
                    <img class="ld-list-l" src="__STATIC__/assets/img/icon/icn-user4.png"/>关于我们
                    <img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/>
                </a>
            </li>
        </ul>
    </div>

    <div class="ld-left-side">
        <ul>
            <li><a href="{$pageUrl['indexHome']}"><img src="__STATIC__/assets/img/icon/icn-sy.png"/> <span>首页</span></a></li>
            <li><a href="{$pageUrl['publish']}"><img src="__STATIC__/assets/img/icon/icn-fb.png"/> <span>发布</span></a></li>
            <!--<li><a href=""><img src="__STATIC__/assets/img/icon/icn-wd.png"/> <span>我的</span></a></li>-->
        </ul>
    </div>

    <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }" style="display: none;">
        <div class="ld-comm-btn">
            <a href="{:U('Index/logout')}">退出</a>
        </div>
    </footer>


<include file="Index/footer_new" />