var regpw = /^[_0-9a-zA-Z]{6,18}$/;
var regmb = /^1[3|4|5|7|8|][0-9]{9}$/;
var regsfz = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
var regpatrn = /^([1-9][0-9]*)?[0-9]\.[0-9]{2}$/;
var regEmail = /^(?:\w+\.?)*\w+@(?:\w+\.)*\w+$/;

//(function ($) {
//'use strict';


var showMenu = function() {
	var $menu = $('.am-collapse'), $toggle=$('.am-menu-toggle'), $mask=$(".ld-nav-mask");
	$toggle.click(function(e){
		if ($mask.is(":hidden")) {
		    $mask.show();
		}else{
				$mask.hide();
		}
	});
	$mask.click(function(){
		if ($menu.length > 0) {
			$menu.removeClass("am-in");
		    $mask.hide();
		}
	});
}
showMenu();

$(function () {
    //选择抢单
    $(document).on('click', '.ld-home-task-a', function () {
        var reward = "";
        var qid = $(this).attr('quest_id');
        if (qid) {
            $("#one_qid").val("");
            $("#one_qid").val(qid);
            $('#nextstep').trigger("click");
            console.log("选择了：" + qid);
            reward = parseFloat($('#reward').html()) + parseFloat($(this).attr('quest_reward'));
        } else {
            $("#one_qid").val("");
            console.log("取消啦：" + qid);
            reward = parseFloat($('#reward').html()) - parseFloat($(this).attr('quest_reward'));
        }
        $('#reward').html(reward);
        console.log("奖励：" + reward);
    });
    //抢单
    $('.ld-home-task-b , .get-order').click(function () {
        if (!userId) {
            alert("您还没有登录！\n请先登录后再来抢单！");
            setTimeout(window.location.href = signInUrl, 1000);
            return false;
        }
        var quest_id = $("#one_qid").val();
        //$(".ld-task-btn input[type=checkbox]").each(function () {
        //if (this.checked) {
        //quest_id += $(this).attr('quest_id') + ",";
        //}
        //});
        console.log("项目列表：" + quest_id);
        if ('' == quest_id || null == quest_id || 'null' == quest_id) {
            console.log('请选择！');
            alert('您还没有选择单子！');
            return false;
        }
        //执行ajax
        getProjects(quest_id, orderUrl);
        //执行ajax
    });
    showScroll();
    function showScroll() {
        $(window).scroll(function () {
            var $scrollValue = $(window).scrollTop();
            $scrollValue > 100 ? $('div[class=scroll]').fadeIn() : $('div[class=scroll]').fadeOut();
        });
        $('#scroll').on('click', function () {
            $("html,body").animate({scrollTop: 0}, 200);
        });
    }
    var $fullText = $('.admin-fullText');
    $('#admin-fullscreen').on('click', function () {
        $.AMUI.fullscreen.toggle();
    });

    //$(document).on($.AMUI.fullscreen.raw.fullscreenchange, function () {
    // $fullText.text($.AMUI.fullscreen.isFullscreen ? '退出全屏' : '开启全屏');
    //});
});
//})(jQuery);

function showalert(e) {
    $(".comm-alert").remove();
    $("body").append('<div class="comm-alert"><div>' + e + '</div></div>');
    $(".comm-alert").show();
    setTimeout(function () {
        $(".comm-alert").hide().end().remove();
    }, 2000);
}

//抢单
function getProjects(quest_id, dealUrl) {
    var user_id = userId;
    var url = signInUrl;
    if (user_id) {
        if (confirm("亲，确定要抢单么？")) {
            $("#nextstep").attr("submiting", '1').text("提交中...");
            $.ajax({
                type: "POST",
                url: "" + dealUrl,
                dataType: "json",
                data: "quest_id=" + quest_id,
                success: function (res) {
                    if (res.code == 200) {
                        alert("恭喜您，抢单成功！");
                        setTimeout(window.location.href = res.info, 2000);
                    } else {
                        alert(res.msg);
                        $("#nextstep").attr("submiting", '0').text("抢单");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("服务器通讯不稳定，请重试~");
                    $("#nextstep").attr("submiting", '0').text("抢单");
                }

            });
        } else {
            $("#checkbox_c" + quest_id).attr("checked", false);
            $("#one_qid").val("");
            console.log('你选择了取消');
            return false;
        }
    } else {
        alert("请先登录后再来抢单！");
        setTimeout(window.location.href = url, 2000);
    }
}

/**
 * 确认接单
 * @param {string} pubid
 * @param {string} dealUrl
 * @returns {json}
 */
function confirmToFinish(pubid, dealUrl) {
    if (false == confirm("您确认此单已完成吗？该操作不可恢复！")) {
        return false;
    }
    //var pubid = $(this).parent().attr('id');
    //$(this).attr("class", 'confirm').text("提交中...");
    $.ajax({
        type: "POST",
        url: dealUrl,
        dataType: "json",
        data: "pubid=" + pubid,
        success: function (data) {
            if (data.code == 200) {
                alert(data.msg);
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
            //$(this).attr("class ", 'confirm').text("确认");
        }
    });
}

/**
 * 关闭任务
 * @param {string} qid
 * @param {string} dealUrl
 * @returns {json}
 */
function closeQuest(qid, dealUrl) {
    if (false == confirm("确定关闭吗？该操作不可恢复！")) {
        return false;
    }
    //var qid = $(this).attr('qid');
    //var thi = $(this);
    $.post(dealUrl, {'quest_id': qid}, function (data) {
        if (data.code == 200) {
            alert(data.msg);
            window.location.reload();
        } else {
            alert(data.msg);
        }
    }, 'json');
}