<html class="no-js">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="description" content="">
        <meta name="keywords" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
		<meta name="format-detection" content="telephone=no" />
        <title>校园雷达-发布项目</title>
        <meta name="renderer" content="webkit">
        <meta http-equiv="Cache-Control" content="no-siteapp"/>
        <link rel="icon" type="image/png" href="">
        <link rel="stylesheet" href="__STATIC__/assets/css/amazeui.min.css">
        <link rel="stylesheet" href="__STATIC__/assets/css/app.css">
        <link rel="stylesheet" type="text/css" href="__STATIC__/assets/webuploader/webuploader.css" />
        <script src="__STATIC__/assets/js/jquery.min.js"></script>
        <script src="__STATIC__/assets/js/amazeui.min.js"></script>
        <script src="__STATIC__/assets/webuploader/webuploader.js" type="text/javascript" charset="utf-8"></script>
        <script src="__STATIC__/assets/js/upload.js" type="text/javascript" charset="utf-8"></script>
        <script>var current_questId = "{$userPublished['quest_id']}";</script>
        <script type="text/javascript" src="__STATIC__/assets/js/jquery.cityselect.js"></script>
    </head>
    <body>

        <div class="ld-home">
            <div class="ld-task-from">
                <form action="" method="post">
                    <ul>
                        <li>
                            <span class="ld-task-from-l">标      题</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="text" id="title" value="{$userPublished.quest_title}" maxlength="15" placeholder="请输入标题（不超过15字）" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">发布范围</span>
                            <div class="ld-task-from-r">
                                <input type="radio" name="range" id="" value="100" <eq name="userPublished['quest_range']" value="100">checked = 'checked'</eq> /><label for="radio1">校内</label>
                                <input type="radio" name="range" id="" value="-1" <eq name="userPublished['quest_range']" value="-1">checked = 'checked'</eq> /><label for="radio1">全部</label>
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">类      别</span>
                            <div class="ld-task-from-r">
                                <select class="ld-input" name="rclass" id="rclass">
                                    <option value="0">请选择</option>
                                    <foreach name='rclass' item='list'>
                                        <option value="{$list.class_id}"<php> if($userPublished['quest_class'] == $list['class_id']){
                                            echo " selected = 'selected' ";} </php>>{$list.class_name}</option>
                                    </foreach>
                                </select>
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">截止日期</span>
                            <div class="ld-task-from-r">
                                <input type="datetime-local" class="ld-input" id="end_time" name="end_time" value="{$userPublished.end_time|date='Y-m-d',###}T{$userPublished.end_time|date='H:i:s',###}" placeholder="有效期" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">交货地址</span>
                            <div class="ld-task-from-r">
                                <if condition="!empty($userAddressArr)">
                                    <select class="ld-input" name="userAddress" id="userAddress">
                                        <option value="0">请选择</option>
                                        <foreach name='userAddressArr' item='list'>
                                            <option value="{$list.address_id}"<php> if($userPublished['address_id'] == $list['address_id']){
                                                echo " selected = 'selected' ";} </php>>编号：{$list.address_id}/收货人：{$list.name}&nbsp;联系电话：{$list.telephone}&nbsp;地址：{$list.province}{$list.city}{$list.distin}{$list.address_info}&nbsp;<br />邮编：{$list.postcode}</option>
                                        </foreach>
                                    </select>
                                    <else />
                                    <span>您没有默认地址，<a href="{$pageUrl['userAddress']}">现在就去设置</a></span>
                                </if>
                            </div>
                        </li>
                        <li>
                        	<span class="ld-task-from-l">奖励类型</span>
                        	<div class="ld-task-from-r">
                                <label> <input type="radio" name="docInlineRadio" id="type_prize" value="1" <eq name="userPublished['quest_reward_type']" value="1">checked="checked"</eq> /> 现金奖励</label>
                                <label><input type="radio" name="docInlineRadio" id="type_other" value="2" <eq name="userPublished['quest_reward_type']" value="2">checked="checked"</eq> /> 其他奖励</label>
                            </div>
                            <!--<span class="ld-task-from-l"><input type="radio" name="docInlineRadio" id="type_prize" value="1" <eq name="userPublished['quest_reward_type']" value="1">checked="checked"</eq> /><label for="">现金奖励</label></span>
                            <span class="ld-task-from-l"><input type="radio" name="docInlineRadio" id="type_other" value="2" <eq name="userPublished['quest_reward_type']" value="2">checked="checked"</eq> /><label for="">其他奖励</label></span>-->
                        </li>
                        <li class="am-hide">
                        	<div class="ld-task-from-r">
                                <input class="ld-input" type="number" id="prize" placeholder="请输入金额" onkeyup="value=value.replace(/^0*(\d*).*$/,'$1')" value="{$userPublished.quest_reward}" />
                            </div>
                        </li>
                        <li class="am-hide">
                            <div class="ld-task-from-r"><input class="ld-input" type="text" id="other" placeholder="请输入奖励"  value="{$userPublished.quest_reward}" /></div>
                        </li>
                    </ul>
                    <ul>
                        <li><textarea class="ld-textarea" name="" id="doc-ta-1" rows="4" cols="30" maxlength="140" placeholder="描述下你的任务（140字以内）">{$userPublished.quest_intro}</textarea></li>
                        <li>
                            <div id="uploader" class="wu-example">
                                <div class="queueList">
                                    <div id="dndArea" class="placeholder">
                                        <div id="filePicker"></div>
                                    </div>
                                </div>
                                <div id="filePicker2"></div>
                                <div class="statusBar">
                                    <div class="progress">
                                        <span class="text">0%</span>
                                        <span class="percentage"></span>
                                    </div><div class="info"></div>
                                    <div class="btns">
                                        <div class="uploadBtn">开始上传</div>
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>

                        <if condition="$userPublishedimg neq ''">
                            <div class="preview" id="preview" style="height: 240px;">
                                <foreach name='userPublishedimg' item='vo'>
                                    <div class="item-photo" style="float: left;position: relative;">
                                        <img src="__UPLOAD__{$vo.pic}" class="preview" quest_id='{$vo.quest_id}' />
                                        <div class="delete_photo" style=" position: absolute; bottom: 10px; left: 5px;">
                                            <span class='del am-btn am-btn-warning am-round' ids='{$vo.id}'>删除</span>
                                        </div>
                                        <div class="photo_order" style="display: none;">排序[大到小]：<input type='tel' name='orders' value='{$vo.orders}' class='product_sort' iid='{$vo.id}' size="3" /></div>
                                    </div>
                                </foreach>
                            </div>
                        </if>

                        </li>
                    </ul>
                   
                </form>
            </div>
        </div>

        <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }">
            <div class="ld-comm-btn">
                <if condition="$quest_id eq ''"> <input type='hidden' id='models' qid='null' value='add'><else /> <input type='hidden' id='models' qid='{$quest_id}'  value='update'></if>
                <a href="javascript:void(0);" id="nextstep" class="" ><php>if($quest_id == ''){ echo  '确定发布'; }else{ echo  '确定修改'; }</php></a>
            </div>
        </footer>

        <script type="text/javascript">
            $(document).ready(function () {
                //奖励内容切换
                $('#type_prize').click(function () {
                    $('#prize').parents("li").removeClass("am-hide");
                    $('#other').parents("li").addClass("am-hide");
                });

                $('#type_other').click(function () {
                    $('#other').parents("li").removeClass("am-hide");
                    $('#prize').parents("li").addClass("am-hide");
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

                //省市级联
                $("#area").citySelect({
                    prov: "{$userPublished.province}",
                    city: "{$userPublished.city}",
                    dist: "{$userPublished.distin}",
                    nodata: "none",
                    required: false
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
                var range = $('input:radio[name=range]:checked').val();
                var rclass = $('#rclass').val();
                var end_time = $('#end_time').val();//
                var province = $('#province').val();
                var city = $('#city').val();
                var distin = $('#distin').val();
                var userAddress = $('#userAddress').val();
                var prize = $('#prize').val();
                var other = $('#other').val();
                var content = $('#doc-ta-1').val();
                var imagefile = $('#doc-form-file').val();//
                var models = $('#models').val();
                var quest_id = $('#models').attr('qid');

                if (title == '') {
                    alert("请先输入标题~");
                    $('#title').focus();
                    return false;
                }

                if (range == '' || range == undefined) {
                    alert("请先选择发布范围~");
                    $("input:radio[name=range][value='100']").attr("checked", 'checked');
                    return false;
                }

                if (rclass == 0) {
                    alert("请先选择发布类别~");
                    $('#rclass').focus();
                    return false;
                }

                if (province == '') {
                    alert("清选择省份~");
                    $('#province').focus();
                    return false;
                }
                if (city == '') {
                    alert("清选择市级~");
                    $('#city').focus();
                    return false;
                }
                if (distin == '') {
                    alert("清选择区县~");
                    $('#distin').focus();
                    return false;
                }
                if (userAddress == '' || userAddress == 0) {
                    alert("请先选择交货地址~");
                    $('#userAddress').focus();
                    return false;
                }

                if (content == '') {
                    alert("请先填写任务描述~");
                    $('#doc-ta-1').focus();
                    return false;
                }
                var checkval = $('input:radio[name="docInlineRadio"]:checked').val();
                if (checkval == 1) {
                    if (prize) {
                        var award = prize;
                    } else {
                        alert("请先填写价格~");
                        $('#prize').focus();
                        return false;
                    }
                } else if (checkval == 2) {
                    if (other) {
                        award = other;
                    } else {
                        alert("请先填写奖励内容~");
                        $('#other').focus();
                        return false;
                    }
                } else {
                    alert("请先选择奖励类型~");
                    return false;
                }

                console.log(title + "@" + range + "@" + rclass + "@" + userAddress + "@" + content + "@" + award + "@" + checkval);

                //提交
                if (title && range && rclass && userAddress && content && award && checkval) {
                    $("#nextstep").attr("submiting", '1').text("提交中...");
                    $.ajax({
                        type: "POST",
                        url: "/index.php/Home/Ucenter/publishCheck.html",
                        dataType: "json",
                        data: "title=" + title + "&range=" + range + "&end_time=" + end_time + "&rclass=" + rclass + "&province=" + province + "&city=" + city + "&distin=" + distin + "&userAddress=" + userAddress + "&content=" + content + "&award=" + award + "&checkval=" + checkval + "&imagefile=" + imagefile + "&models=" + models + "&quest_id=" + quest_id,
                        success: function (res) {
                            if (res.code == 200) {
                                if (quest_id == 'null') {
                                    alert("恭喜您，发布成功！");
                                } else {
                                    alert("恭喜您，修改成功！");
                                }

                                setTimeout(window.location.href = res.info, 2000);
                            } else {
                                alert(res.msg);
                                if (quest_id == 'null') {
                                    $("#nextstep").attr("submiting", '0').text("确定发布");
                                } else {
                                    $("#nextstep").attr("submiting", '0').text("确定修改");
                                }

                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("服务器通讯不稳定，请重试~");
                            if (quest_id == 'null') {
                                $("#nextstep").attr("submiting", '0').text("确定发布");
                            } else {
                                $("#nextstep").attr("submiting", '0').text("确定修改");
                            }
                        }

                    });
                } else {
                    alert('信息不完整！');
                }
            }
        </script>
        <script type="text/javascript">
            // 添加全局站点信息
            var BASE_URL = '/webuploader';

        </script>

    </body>
</html>
