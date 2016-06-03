var CID = "leave";
if (document.getElementById(CID)) {
    var iTime = document.getElementById(CID).innerHTML;
    var Account;
    RemainTime();
}

function RemainTime() {
    var iDay, iHour, iMinute, iSecond;
    var sDay = "", sTime = "";
    if (iTime >= 0) {
        iDay = parseInt(iTime / 24 / 3600);
        iHour = parseInt((iTime / 3600) % 24);
        iMinute = parseInt((iTime / 60) % 60);
        iSecond = parseInt(iTime % 60);
        if (iDay > 0) {
            sDay = iDay + "天";
        }
        sTime = '还剩' + sDay + iHour + "时" + iMinute + "分" + iSecond + "秒";
        if (iTime == 0) {
            clearTimeout(Account);
            sTime = "<span style='color:green'>已过期</span>";
        } else {
            Account = setTimeout("RemainTime()", 1000);
        }
        iTime = iTime - 1;
    } else {
        sTime = "<span style='color:red'>0天0时0分</span>";
    }

    document.getElementById(CID).innerHTML = sTime;
}


/**
 * 显示倒计时
 * @param {string} toEnd
 * @returns {string}
 */
function showTime(toEnd) {
    var intDiff = parseInt($('.leave' + toEnd).attr('remind'));//倒计时总秒数量
    window.setInterval(function () {
        var day = 0,
                hour = 0,
                minute = 0,
                second = 0;//时间默认值		
        if (intDiff > 0) {
            day = Math.floor(intDiff / (60 * 60 * 24));
            hour = Math.floor(intDiff / (60 * 60)) - (day * 24);
            minute = Math.floor(intDiff / 60) - (day * 24 * 60) - (hour * 60);
            second = Math.floor(intDiff) - (day * 24 * 60 * 60) - (hour * 60 * 60) - (minute * 60);
        }
        if (hour <= 9)
            hour = '0' + hour;
        if (minute <= 9)
            minute = '0' + minute;
        if (second <= 9)
            second = '0' + second;
        $('.leave' + toEnd + '').html('' + '' + (day > 0 ? (parseInt(day) * 24 + parseInt(hour)) : hour) + ':' + '' + minute + ':' + '' + second + '');
        //        $('.leave' + toEnd + '').html((day > 0 ? day + ":" : '') + '' + hour + ':' + '' + minute + ':' + '' + second + '');
        intDiff--;
        if (intDiff == 0) {
            $("#checkbox_c" + toEnd + '').attr({'disabled': 'disabled', 'title': 'js定时禁用'});//禁用当前选择框
        }
    }, 1000);
}