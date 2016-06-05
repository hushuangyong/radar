<html class="no-js">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="description" content="">
        <meta name="keywords" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
		<meta name="format-detection" content="telephone=no" />
        <title>校园雷达-用户收货地址</title>
        <meta name="renderer" content="webkit">
        <meta http-equiv="Cache-Control" content="no-siteapp"/>
        <link rel="icon" type="image/png" href="">
        <link rel="stylesheet" href="__STATIC__/assets/css/amazeui.min.css">
        <link rel="stylesheet" href="__STATIC__/assets/css/app.css">

        <script src="__STATIC__/assets/js/jquery.min.js"></script>
        <script src="__STATIC__/assets/js/amazeui.min.js"></script>
        <script>var current_questId = "{$dataArr['address_id']}";</script>
        <script type="text/javascript" src="__STATIC__/assets/js/jquery.cityselect.js"></script>
    </head>
    <body>

        <div class="ld-home">
            <div class="ld-task-from">
                <form action="" method="post" id="addressPost">
                    <ul>
                        <li>
                            <span class="ld-task-from-l">收货人</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="text" name="name" id="name" value="{$dataArr.name}" placeholder="名字" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">联系电话</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="tel" name="telephone" id="telephone" value="{$dataArr.telephone}" placeholder="手机或固话" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">交货地址</span>
                            <div class="ld-task-from-r" id="area">
                                <select class="ld-select prov" name="prov" id="province">
                                    <option value="">请选择</option>
                                </select>
                                <select class="ld-select city" name="city" id="city">
                                    <option value="">请选择</option>
                                </select>
                                <select class="ld-select dist" name="distin" id="distin" <eq name="dataArr.distin" value="">style="display:none;"</eq> ><option value="">请选择</option></select>
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">详细地址</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="text" name="address_info" id="address_info" value="{$dataArr.address_info}" placeholder="街道等详细地址" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">邮政编码</span>
                            <div class="ld-task-from-r">
                                <input class="ld-input" type="text" name="postcode" id="postcode" value="{$dataArr.postcode}" placeholder="邮政编码" maxlength="6" />
                            </div>
                        </li>
                        <li>
                            <span class="ld-task-from-l">设为默认</span>
                            <div class="ld-task-from-r">
                                <input type="radio" name="isdefault" id="radio1" value="1" <eq name="dataArr['isdefault']" value="1">checked = 'checked'</eq> /><label for="radio1">是</label>
                                <input type="radio" name="isdefault" id="radio2" value="0" <eq name="dataArr['isdefault']" value="0">checked = 'checked'</eq> /><label for="radio2">否</label>
                            </div>
                        </li>
                        <li><input type="hidden" name="address_id" id="address_if" value="{$dataArr['address_id']}" /></li>
                    </ul>

                </form>
            </div>
        </div>

        <footer data-am-widget="footer" class="am-footer am-footer-default ld-home-footer" data-am-footer="{  }">
            <div class="ld-comm-btn">
                <if condition="$dataArr['address_id'] eq ''"> <input type='hidden' name="models" id='models' qid='null' value='add'><else /> <input type='hidden' name="models" id='models' qid='{$dataArr['address_id']}'  value='update'></if>
                <a href="javascript:void(0);" id="nextstep" class="" ><php>if($dataArr['address_id'] == ''){ echo  '确定添加'; }else{ echo  '确定修改'; }</php></a>
            </div>
        </footer>

        <script type="text/javascript">
            $(document).ready(function () {
                //省市级联
                $("#area").citySelect({
                    prov: "{$dataArr.province}",
                    city: "{$dataArr.city}",
                    dist: "{$dataArr.distin}",
                    nodata: "none",
                    required: false
                });

                //点击下一步
                $('#nextstep').click(function () {
                    do_publish();
                });

            });

            //添加异步
            function do_publish() {
                //处理参数
                var name = $('#name').val();
                var telephone = $('#telephone').val();
                var province = $('#province').val();
                var city = $('#city').val();
                var distin = $('#distin').val();
                var address_info = $('#address_info').val();
                var postcode = $('#postcode').val();
                var isdefault = $('input:radio[name=isdefault]:checked').val();

                var models = $('#models').val();
                var address_id = $('#models').attr('qid');

                if (name == '') {
                    alert("请填写收货人姓名~");
                    $('#name').focus();
                    return false;
                }

                if (telephone == '') {
                    alert("请先填写联系电话~");
                    $('#telephone').focus();
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
                if (address_info == '') {
                    alert("请先填写交货地址~");
                    $('#address_info').focus();
                    return false;
                }

                if (postcode == '') {
                    alert("请先填写邮政编码~");
                    $('#postcode').focus();
                    return false;
                }

                if (isdefault == '' || isdefault == undefined) {
                    alert("请先选择是否默认地址~");
                    $("input:radio[name=isdefault][value='0']").attr("checked", 'checked');
                    return false;
                }

                console.log(name + "@" + telephone + "@" + province + "@" + city + "@" + distin + "@" + address_info + "@" + postcode + "@" + isdefault);

                //提交
                if (name && telephone && province && city && address_info && postcode && isdefault && models) {
                    $("#nextstep").attr("submiting", '1').text("提交中...");
                    var params = $('#addressPost').serialize(); //序列化表单的值
                    $.ajax({
                        type: "POST",
                        url: "/index.php/Home/Ucenter/addressCheck.html",
                        dataType: "json",
                        data: params,
                        success: function (res) {
                            if (res.code == 200) {
                                alert("恭喜您，修改成功！");
                                setTimeout(window.location.href = res.info, 2000);
                            } else {
                                alert(res.msg);
                                if (address_id == 'null') {
                                    $("#nextstep").attr("submiting", '0').text("确定添加");
                                } else {
                                    $("#nextstep").attr("submiting", '0').text("确定修改");
                                }

                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("服务器通讯不稳定，请重试~");
                            console.log(XMLHttpRequest);
                            console.log(textStatus);
                            if (address_id == 'null') {
                                $("#nextstep").attr("submiting", '0').text("确定添加");
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
    </body>
</html>
