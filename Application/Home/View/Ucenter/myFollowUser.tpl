<include file="Index/header_new" title="校园雷达-我的关注-用户"  />
<script src="__STATIC__/assets/js/amazeui.min.js"></script>
</head>
<body>

    <div class="ld-comm-top">
        <ul class="ld-nav-two">
            <li><a href="{:U('Ucenter/myCollectionTask')}">任务</a></li>
            <li class="current"><a href="javascript:void(0);">用户</a></li>
        </ul>
    </div>

    <div class="ld-my-task">
        <div class="ld-user-list">
            <ul>
                <notempty name='dataList'>
                    <foreach name='dataList' item='list'>
                        <php>$url['sgkey'] = dtd_encrypt($list['user_id']);</php>
                        <li>
                            <dl>
                                <dt class="ld-user-avatars"><a href="{:U('Index/radar',array('sgkey'=>$url['sgkey']))}"><img src="__STATIC__/assets/img/temp/img-user.jpg"/></a></dt>
                            </dl>
                            <h4>
                                <a class="ld-task-h4" href="{:U('Index/radar',array('sgkey'=>$url['sgkey']))}">{$list.id}/{$list.username}<img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/></a>
                            </h4>
                        </li>
                    </foreach>
                    <else />
                    <div style="text-align:center;margin:10px;color:#999;">暂无关注人</div>
                </notempty>
            </ul>
        </div>
    </div>

    <div class="ld-left-side">
        <ul>
            <li><a href="{:U('Index/index')}"><img src="__STATIC__/assets/img/icon/icn-sy.png"/> <span>首页</span></a></li>
        </ul>
    </div>

    <script src="__STATIC_JS__/Radar/timer.js"></script>
<include file="Index/footer_new" />
