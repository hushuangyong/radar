var regpw = /^[_0-9a-zA-Z]{6,18}$/;
var regmb = /^1[3|4|5|7|8|][0-9]{9}$/;
var regsfz = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
var regpatrn = /^([1-9][0-9]*)?[0-9]\.[0-9]{2}$/;
var regEmail = /^(?:\w+\.?)*\w+@(?:\w+\.)*\w+$/;

(function ($) {
    'use strict';

    $(function () {
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

        $(document).on($.AMUI.fullscreen.raw.fullscreenchange, function () {
            $fullText.text($.AMUI.fullscreen.isFullscreen ? '退出全屏' : '开启全屏');
        });
    });
})(jQuery);

function showalert(e) {
    $(".comm-alert").remove();
    $("body").append('<div class="comm-alert"><div>' + e + '</div></div>');
    $(".comm-alert").show();
    setTimeout(function () {
        $(".comm-alert").hide().end().remove();
    }, 2000);
}

