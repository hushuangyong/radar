<include file="Index/header_new" title="校园雷达-我的收货地址-用户"  />
<script src="__STATIC__/assets/js/amazeui.min.js"></script>
</head>
<body>

    <div class="ld-comm-top">
        <ul class="ld-nav-two">
            <li><a href="{$newAddress}">新增收货地址</a></li>
            <li class="current"><a href="javascript:void(0);">收货地址</a></li>
        </ul>
    </div>

    <div class="ld-my-task">
        <div class="ld-user-list">
            <ul>
                <notempty name='dataList'>
                    <foreach name='dataList' item='list'>
                        <li>
                            <dl>
                                <dt class="ld-user-avatars"><a href="{$list['editUrl']}" title='编辑'><img src="__STATIC__/assets/img/icn-nav-b22.png"/></a></dt>
                            </dl>
                            <h4>
                                <a class="ld-task-h4" href="{$list.editUrl}" title='查看'>{$list.address_id}/收货人：{$list.name}&nbsp;联系电话：{$list.telephone}&nbsp;地址：{$list.province}{$list.city}{$list.distin}{$list.address_info}&nbsp;<br />邮编：{$list.postcode}&nbsp;默认地址：{$list.isDefault}&nbsp;添加时间：{$list.addtime}&nbsp;更新时间：{$list.update}<img class="ld-list-r" src="__STATIC__/assets/img/icon/icn-rightside.png"/></a>
                                <eq name="list.isdefault" value="0"><br /><a href="javascript:void(0);" class="setDeault" style="color:#f60;" addr_id="{$list['address_id']}">设为默认</a></eq>
                            </h4>
                        </li>
                    </foreach>
                    <else />
                    <div style="text-align:center;margin:10px;color:#999; height: 300px;">暂无收获地址</div>
                </notempty>

            </ul>
        </div>
    </div>

    <div class="ld-left-side">
        <ul>
            <li><a href="{:U('Index/index')}"><img src="__STATIC__/assets/img/icon/icn-sy.png"/> <span>首页</span></a></li>
            <li><a href="{$pageUrl['publish']}"><img src="__STATIC__/assets/img/icon/icn-fb.png"/> <span>发布</span></a></li>
            <li><a href="{$pageUrl['myHome']}"><img src="__STATIC__/assets/img/icon/icn-wd.png"/> <span>我的</span></a></li>
        </ul>
    </div>

    <script type="text/javascript">
        //设置默认地址的操作
        $(document).on('click', '.setDeault', function () {
            var id = $(this).attr('addr_id');
            if (!id) {
                alert('非法参数！');
                return false;
            }
            var $this = $(this);

            $.ajax({
                type: "POST",
                url: '__APP__/Home/Ucenter/setDefaultAddress',
                data:{id:id,Password:"sanmaoword"},
                dataType: "json",
                beforeSend: function () {
                    //
                },
                success: function (data) {
                    if (data.code == '200') {
                        alert(data.msg);
                        $this.hide();
                    } else {
                        alert('设置失败！');
                    }
                },
                complete: function (XMLHttpRequest, textStatus) {
                    //alert(XMLHttpRequest.responseText);
                    //alert(textStatus);
                },
                error: function () {
                    //请求出错处理
                }
            });
        });

    </script>
<include file="Index/footer_new" />
