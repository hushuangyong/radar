<include file="Index/header" title="校园雷达-发布"  />

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
            <a href="javascript:;">发布</a>
        </h1>
        <div class="am-header-right am-header-nav">
            <a href="{:U('Ucenter/myCenter')}" class="">
                <i class="am-header-icon am-icon-user"></i>
            </a>
            <a href="{:U('Ucenter/publish')}" class="post_new" title="发布任务"><i class="am-header-icon am-icon-plus"></i></a>
        </div>
    </header>

    <form class="am-form" action="" method="post">
        <div id="widget-list">

            <ul class="am-list m-widget-list">
                <li class="i-form-row">
                    <span class="">标题</span>
                    <div class="am-form-group ">
                        <input class="am-form-field am-input-lg" type="text" id="title" name="title" value="{$userPublished.quest_title}" placeholder="请输入标题" />
                    </div>
                </li>
                <li class="i-form-row">
                    <span>发布范围</span>
                    <div class="am-form-group am-form-select">
                        <select name="range" id="range">
                            <option value="0">请选择</option>
                            <foreach name='range' item='list'>
                                <option value="{$list.range_id}"<php> if($userPublished['quest_range'] == $list['range_id']){

                                    echo " selected = 'selected' ";

                                    } </php>>{$list.range_name}</option>
                            </foreach>
                        </select>
                    </div>
                </li>
                <li class="i-form-row">
                    <span>类别</span>
                    <div class="am-form-group am-form-select">
                        <select name="rclass" id="rclass">
                            <option value="0">请选择</option>
                            <foreach name='rclass' item='list'>
                                <option value="{$list.class_id}"<php> if($userPublished['quest_class'] == $list['class_id']){

                                    echo " selected = 'selected' ";

                                    } </php>>{$list.class_name}</option>
                            </foreach>
                        </select>
                    </div>
                </li>
                <li class="i-form-row">
                    <span>截止日期</span>
                    <div class="am-form-group am-form-select">
                        <input type="datetime-local" class="am-form-field am-input-lg" id="end_time" name="end_time" value="{$userPublished.end_time|date='Y-m-d',###}T{$userPublished.end_time|date='H:i:s',###}" placeholder="有效期" />
                    </div>                    
                </li>
                <li class="i-form-row">
                    <span>地址</span>
                    <div class="am-form-group ">
                        <input class="am-form-field am-input-lg" type="text" id="userAddress" name="userAddress" value="{$userPublished.quest_address}" placeholder="请输入交货地址" />
                    </div>
                </li>
                <li>
                    <div class="am-form-group">
                        <label class="am-radio-inline">
                            <input class="ctype" id="type_prize" type="radio" value="1" name="docInlineRadio" <php> if($userPublished['quest_reward_type'] == 1){

                                echo  'checked="checked"';

                                }else if($quest_id == ''){ echo  'checked="checked"'; } </php>> 价格</label>
                        <label class="am-radio-inline">
                            <input class="ctype" id="type_other" type="radio" value="2"<php> if($userPublished['quest_reward_type'] == 2){

                                echo  'checked="checked"';

                                } </php> name="docInlineRadio"> 其他奖励</label>
                    </div>
                    <div class="am-form-group">
                        <input style="display:block;" class="am-form-field am-input-lg" type="tel" name="prize" id="prize" value="{$userPublished.quest_reward}" placeholder="请输入价格,单位“元”" /> 
                        <input style="display:none;" class="am-form-field am-input-lg" type="text" name="prize" id="other" value="{$userPublished.quest_reward}" placeholder="请输入奖励内容" /> 
                    </div>
                </li>
                <li>
                    <div class="am-form-group">
                        <textarea class="" rows="5" id="doc-ta-1" placeholder="请详细描述您的任务，可上传多张图片">{$userPublished.quest_intro}</textarea>
                    </div>
                    <div class="am-form-group am-form-file">
                    </div>
                </li>
            </ul>
        </div>

        <if condition="$quest_id eq ''"> <input type='hidden' id='models' qid='null' value='add'><else /> <input type='hidden' id='models' qid='{$quest_id}'  value='update'></if>
        <!-- Nav -->
        <div data-am-widget="navbar" class="am-navbar am-cf am-navbar-default am-no-layout">
            <input id="nextstep" type="button" class="am-btn am-btn-warning am-btn-block" <php>if($quest_id == ''){ echo  'value="确定发布"'; }else{ echo  'value="确定修改"'; }</php>/>
        </div>

    </form>



<block name="body">

    <style type="text/css">

        .preview {	width:200px;	border:1px solid #c9c9c9;	margin:10px;	padding:10px;}
        .demo p{line-height:26px}
        .btn{position: relative;overflow: hidden;margin-right: 4px;display:inline-block;*display:inline;padding:4px 10px 4px;font-size:14px;line-height:18px;*line-height:20px;color:#fff;text-align:center;vertical-align:middle;cursor:pointer;background-color:#5bb75b;border:1px solid #cccccc;border-color:#e6e6e6 #e6e6e6 #bfbfbf;border-bottom-color:#b3b3b3;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;}
        .btn input {position: absolute;top: 0; right: 0;margin: 0;border: solid transparent;opacity: 0;filter:alpha(opacity=0); cursor: pointer;}
    </style>
    <script type="text/javascript" src="__PUBLIC__/PicThumb/js/jquery-2.0.3.min.js"></script>
    <script type="text/javascript" src="__PUBLIC__/PicThumb/js/jquery.wallform.js"></script>
    <script language="javascript" type="text/javascript" src="__PUBLIC__/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#photoimg').die('click').live('change', function () {
                var status = $("#up_status");
                var btn = $("#up_btn");
                $("#imageform").ajaxForm({
                    target: '#preview',
                    beforeSubmit: function () {
                        status.show();
                        btn.hide();
                    },
                    success: function () {
                        status.hide();
                        btn.show();
                    },
                    error: function () {
                        status.hide();
                        btn.show();
                    }}).submit();
            });


            //删除操作
            $("#preview").on('click', '.del', function () {
                var r = confirm("确定删除吗？");
                if (r == true) {
                    //
                } else {
                    //
                    return false;
                }

                var id = $(this).attr('ids');
                var thi = $(this);
                var img = $(this).parent().prev().attr('src');

                $.post('__APP__/Home/Image/imgdel',{id:id,img:img}, function (data) {
                    if (data != '') {
                        thi.parent().parent().remove();
                    } else {
                        showalert('删除失败');
                    }
                });

            });

            //排序操作 

            $('#orders').live('click', function () {
                $('.product_sort').each(function () {
                    var id = $(this).attr('iid');
                    var orders = $(this).val();
                    $.ajax({
                        url: '__APP__/Home/Image/orders',
                        data: {id:id,"orders":orders},
                        type: 'post',
                        async: false,
                        success: function (data) {
                            console.log(data);
                        }
                    });

                });

                location.reload();
            });
        });
    </script>



    <div id="main">
        <h3 class="top_title" style="margin-left: 4%;"><a href="javascript:;">多图片上传</a>&nbsp;&nbsp;&nbsp;<a href="javascript:;" id='orders'>一键保存排序</a></h3>
        <div class="demo am-container">       
            <form id="imageform" method="post" enctype="multipart/form-data" action="__APP__/Home/Image/upload">
                <div id="up_status" style="display:none"><img src="__PUBLIC__/PicThumb/img/loader.gif" alt="uploading"/></div>
                <div id="up_btn" class="btn">
                    <span>添加图片</span>
                    <input id="photoimg" type="file" name="photoimg">
                    <input id="quest_id" type="hidden" name="quest_id" value='{$quest_id}'>				
                </div>
            </form>
            <p>最大4MB，支持jpg，gif，png格式。</p>
            <div id="preview">
                <if condition="$userPublishedimg neq ''">			
                    <foreach name='userPublishedimg' item='vo'>
                        <div class="item-photo"><img src="__UPLOAD__{$vo.pic}" class="preview" quest_id='{$vo.quest_id}'><div class="delete_photo"><span class='del am-btn am-btn-warning am-round' ids='{$vo.id}'>删除</span></div><div class="photo_order">排序[大到小]：<input type='tel' name='orders' value='{$vo.orders}' class='product_sort' iid='{$vo.id}'></div></div>
                    </foreach>
                </if>
            </div>
        </div>

        <br/>
    </div>

</block>	

<script type='text/javascript'>
    $(document).ready(function () {
        //奖励内容切换
        $('#type_prize').click(function () {
            $('#prize').show();
            $('#other').hide();
        });

        $('#type_other').click(function () {
            $('#other').show();
            $('#prize').hide();
        });

        //点击下一步
        $('#nextstep').click(function () {
            do_publish();
        });

    });

    //发布异步
    function do_publish() {
        //处理参数
        var title = $('#title').val();
        var range = $('#range').val();
        var rclass = $('#rclass').val();
        var end_time = $('#end_time').val();
        var userAddress = $('#userAddress').val();
        var prize = $('#prize').val();
        var other = $('#other').val();
        var content = $('#doc-ta-1').val();
        var imagefile = $('#doc-form-file').val();
        var models = $('#models').val();
        var quest_id = $('#models').attr('qid');

        if (title == '') {
            showalert("请先输入标题~");
            $('#title').focus();
            return false;
        }

        if (range == 0) {
            showalert("请先选择发布范围~");
            $('#range').focus();
            return false;
        }

        if (rclass == 0) {
            showalert("请先选择发布类别~");
            $('#rclass').focus();
            return false;
        }

        if (userAddress == '') {
            showalert("请先填写交货地址~");
            $('#userAddress').focus();
            return false;
        }

        var checkval = $('input:radio[name="docInlineRadio"]:checked').val();
        if (checkval == 1) {
            if (prize) {
                var award = prize;
            } else {
                showalert("请先填写价格~");
                $('#prize').focus();
                return false;
            }
        } else if (checkval == 2) {
            if (other) {
                award = other;
            } else {
                showalert("请先填写奖励内容~");
                $('#other').focus();
                return false;
            }
        } else {
            showalert("请先选择奖励类型~");
            return false;
        }

        if (content == '') {
            showalert("请先填写任务描述~");
            $('#doc-ta-1').focus();
            return false;
        }

        //提交
        if (title && range && rclass && userAddress && content && award && checkval) {
            $("#nextstep").attr("submiting", '1').text("提交中...");
            $.ajax({
                type: "POST",
                url: "{:U('Ucenter/publishCheck')}",
                dataType: "json",
                data: "title=" + title + "&range=" + range + "&end_time=" + end_time + "&rclass=" + rclass + "&userAddress=" + userAddress + "&content=" + content + "&award=" + award + "&checkval=" + checkval + "&imagefile=" + imagefile + "&models=" + models + "&quest_id=" + quest_id,
                success: function (res) {
                    if (res.code == 200) {
                        if (quest_id == 'null') {
                            showalert("恭喜您，发布成功！");
                        } else {
                            showalert("恭喜您，修改成功！");
                        }

                        setTimeout(window.location.href = res.info, 2000);
                    } else {
                        showalert(res.msg);
                        if (quest_id == 'null') {
                            $("#nextstep").attr("submiting", '0').text("确定发布");
                        } else {
                            $("#nextstep").attr("submiting", '0').text("确定修改");
                        }

                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    showalert("服务器通讯不稳定，请重试~");
                    if (quest_id == 'null') {
                        $("#nextstep").attr("submiting", '0').text("确定发布");
                    } else {
                        $("#nextstep").attr("submiting", '0').text("确定修改");
                    }
                }

            });
        }

    }
</script>
<include file="Index/footer" />