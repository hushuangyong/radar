<?php

/**
 * 验证手机号是否正确
 * @param INT $mobile
 */
function isMobile($mobile) {
    if (!is_numeric($mobile)) {
        return false;
    }
    return preg_match('#^13[\d]{9}$|^14[5,7]{1}\d{8}$|^15[^4]{1}\d{8}$|^17[0,6,7,8]{1}\d{8}$|^18[\d]{9}$#', $mobile) ? true : false;
}

/**
 * 验证是否正确email地址
 * @param string $email
 * @return boolean
 */
function is_email($email) {
    if (empty($email)) {
        return FALSE;
    }
    $pattern = "/^([0-9A-Za-z\\-_\\.]+)@([0-9a-z]+\\.[a-z]{2,3}(\\.[a-z]{2})?)$/i";
    if (preg_match($pattern, $email, $matches)) {
        return $matches;
    } else {
        return FALSE;
    }
}

/**
 * 发送邮件
 * @param array $paramArr 数组参数
 * @return mixed 发送结果
 */
function send_email($paramArr = array()) {
    import("ORG.Util.email");
    //******************** 配置信息 ********************************
    $smtpserver = "smtp.tom.com"; //SMTP服务器
    $smtpserverport = 25; //SMTP服务器端口
    $smtpusermail = "radar20151231@tom.com"; //SMTP服务器的用户邮箱
    $smtpuser = "radar20151231"; //SMTP服务器的用户帐号
    $smtppass = "1q2w3e"; //SMTP服务器的用户密码
    $smtpemailto = $paramArr['toemail']; //发送给谁
    $mailtitle = $paramArr['title']; //邮件主题
    $mailcontent = "亲爱的{$paramArr['toemail']}：<br />欢迎使用校园雷达找回密码功能。<br /><br /><br />您此次找回密码的验证码是<b>：{$paramArr['content']}</b>，请在30分钟内在找回密码页填入此验证码。<br /><br />如果您并未发过此请求，则可能是因为其他用户在尝试重设密码时误输入了您的电子邮件地址而使您收到这封邮件，那么您可以放心的忽略此邮件，无需进一步采取任何操作。<br /><br />此致<br /><br />校园雷达敬上<br />" . date('Y-m-d H:i:s') . ""; //邮件内容
    $mailtype = "HTML"; //邮件格式（HTML/TXT）,TXT为文本邮件
    //************************ 配置信息 ****************************
    $smtp = new smtp($smtpserver, $smtpserverport, true, $smtpuser, $smtppass); //这里面的一个true是表示使用身份验证,否则不使用身份验证.
    $smtp->debug = false; //是否显示发送的调试信息
    $state = $smtp->sendmail($smtpemailto, $smtpusermail, $mailtitle, $mailcontent, $mailtype);

    if ($state == "") {
        return '对不起，邮件发送失败！请检查邮箱填写是否有误。';
    }
    return $state;
}

/**

 * 中文截取，支持gb2312,gbk,utf-8,big5 
 * @param string $str 要截取的字串 
 * @param int $start 截取起始位置 
 * @param int $length 截取长度 
 * @param string $charset utf-8|gb2312|gbk|big5 编码 
 * @param $suffix 是否加尾缀 
 */
function cn_substr($str, $start = 0, $length, $charset = "utf-8", $suffix = true) {
    if (function_exists("mb_substr")) {
        if (mb_strlen($str, $charset) <= $length) {
            return $str;
        }
        $slice = mb_substr($str, $start, $length, $charset);
    } else {
        $re['utf-8'] = "/[\x01-\x7f]|[\xc2-\xdf][\x80-\xbf]|[\xe0-\xef][\x80-\xbf]{2}|[\xf0-\xff][\x80-\xbf]{3}/";
        $re['gb2312'] = "/[\x01-\x7f]|[\xb0-\xf7][\xa0-\xfe]/";
        $re['gbk'] = "/[\x01-\x7f]|[\x81-\xfe][\x40-\xfe]/";
        $re['big5'] = "/[\x01-\x7f]|[\x81-\xfe]([\x40-\x7e]|\xa1-\xfe])/";
        preg_match_all($re[$charset], $str, $match);
        if (count($match[0]) <= $length) {
            return $str;
        }
        $slice = join("", array_slice($match[0], $start, $length));
    }
    if ($suffix) {
        return $slice . "…";
    }
    return $slice;
}

/**
 * 发送HTTP请求方法，目前只支持CURL发送请求
 * @param  string $url    请求URL
 * @param  array  $params 请求参数
 * @param  string $method 请求方法GET/POST
 * @return array  $data   响应数据
 */
function http($url, $params, $method = 'GET', $header = array(), $multi = false) {
    $opts = array(
        CURLOPT_TIMEOUT => 30,
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_SSL_VERIFYHOST => false,
        CURLOPT_HTTPHEADER => $header,
    );

    /* 根据请求类型设置特定参数 */
    switch (strtoupper($method)) {
        case 'GET':
            $opts[CURLOPT_URL] = $url . '?' . http_build_query($params);
            break;
        case 'POST':
            //判断是否传输文件
            $params = $multi ? $params : http_build_query($params);
            $opts[CURLOPT_URL] = $url;
            $opts[CURLOPT_POST] = 1;
            $opts[CURLOPT_POSTFIELDS] = $params;
            break;
        default:
            throw new Exception('不支持的请求方式！');
    }

    /* 初始化并执行curl请求 */
    $ch = curl_init();
    curl_setopt_array($ch, $opts);
    $data = curl_exec($ch);
    $error = curl_error($ch);
    curl_close($ch);
    if ($error)
        throw new Exception('请求发生错误：' . $error);
    return $data;
}

function auto_charset($fContents, $from = '', $to = '') {
    if (empty($from))
        $from = C('TEMPLATE_CHARSET');
    if (empty($to))
        $to = C('OUTPUT_CHARSET');

    $from = strtoupper($from) == 'UTF8' ? 'utf-8' : $from;
    $to = strtoupper($to) == 'UTF8' ? 'utf-8' : $to;
    if (strtoupper($from) === strtoupper($to) || empty($fContents) || (is_scalar($fContents) && !is_string($fContents))) {
        //如果编码相同或者非字符串标量则不转换
        return $fContents;
    }
    if (is_string($fContents)) {
        if (function_exists('mb_convert_encoding')) {
            return mb_convert_encoding($fContents, $to, $from);
        } elseif (function_exists('iconv')) {
            return iconv($from, $to, $fContents);
        } else {
            halt(L('_NO_AUTO_CHARSET_'));
            return $fContents;
        }
    } elseif (is_array($fContents)) {
        foreach ($fContents as $key => $val) {
            $_key = auto_charset($key, $from, $to);
            $fContents[$_key] = auto_charset($val, $from, $to);
            if ($key != $_key) {
                unset($fContents[$key]);
            }
        }
        return $fContents;
    } elseif (is_object($fContents)) {
        $vars = get_object_vars($fContents);
        foreach ($vars as $key => $val) {
            $fContents->$key = auto_charset($val, $from, $to);
        }
        return $fContents;
    } else {
        //halt('系统不支持对'.gettype($fContents).'类型的编码转换！');
        return $fContents;
    }
}

//判断函数是否存在，不存在则返回false
function IsExiest($val) {
    if (isset($val) && ($val != "" || $val == 0)) {
        return $val;
    } else {
        return false;
    }
}

//把HTML实体转成字符
function htmlentitydecode($str) {
    if (is_array($str)) {
        foreach ($str as $key => $value) {
            $str[$key] = htmlentitydecode($value);
        }
    } else {
        $str = html_entity_decode($str);
    }
    return $str;
}

//获取IP地址
function ip_address($type = 0) {
    $type = $type ? 1 : 0;
    $ip = '';

    if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $arr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $pos = array_search('unknown', $arr);
        if (false !== $pos)
            unset($arr[$pos]);
        $ip = trim($arr[0]);
    }elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    }

    $long = sprintf("%u", ip2long($ip));
    $real_ip = $long ? array($ip, $long) : array('0.0.0.0', 0);
    if (isset($_SERVER['REMOTE_ADDR']) && $real_ip[$type] == 0) {
        $real_ip = array($_SERVER['REMOTE_ADDR']);
    }
    return $real_ip[$type];
}

function get_times($data = array()) {

    if (isset($data['time']) && $data['time'] != "") {
        $time = $data['time']; //时间
    } elseif (isset($data['date']) && $data['date'] != "") {
        $time = strtotime($data['date']); //日期
    } else {
        $time = time(); //现在时间
    }
    if (isset($data['type']) && $data['type'] != "") {
        $type = $data['type']; //时间转换类型，有day week month year
    } else {
        $type = "month";
    }
    if (isset($data['num']) && ($data['num'] != "" || $data['num'] == "0")) {
        $num = $data['num'];
    } else {
        $num = 1;
    }
    if ($type == "month") {
        $month = date("m", $time);
        $year = date("Y", $time);
        $_result = strtotime("$num month", $time);
        $_month = (int) date("m", $_result);
        if ($month + $num > 12) {
            $_num = $month + $num - 12;
            $year = $year + 1;
        } else {
            $_num = $month + $num;
        }

        if ($_num != $_month) {

            //$_result = strtotime("-1 day",strtotime("{$year}-{$_month}-01"));
        }
    } else {
        $_result = strtotime("$num $type", $time);
    }
    if (isset($data['format']) && $data['format'] != "") {
        return date($data['format'], $_result);
    } else {
        return $_result;
    }
}

/**
 *    身份证验证
 *
 *    @param    string    $id
 *    @return   boolean
 */
function is_idcard($id) {
    $id = strtoupper($id);
    $regx = "/(^\d{15}$)|(^\d{17}([0-9]|X)$)/";
    $arr_split = array();
    if (!preg_match($regx, $id)) {
        return FALSE;
    }
    if (18 == strlen($id)) { //检查18位
        $regx = "/^(\d{6})+(\d{4})+(\d{2})+(\d{2})+(\d{3})([0-9]|X)$/";
        @preg_match($regx, $id, $arr_split);
        $dtm_birth = $arr_split[2] . '/' . $arr_split[3] . '/' . $arr_split[4];
        if (!strtotime($dtm_birth)) {  //检查生日日期是否正确
            return FALSE;
        } else {
            //检验18位身份证的校验码是否正确。
            //校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。
            $arr_int = array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
            $arr_ch = array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');
            $sign = 0;
            for ($i = 0; $i < 17; $i++) {
                $b = (int) $id{$i};
                $w = $arr_int[$i];
                $sign += $b * $w;
            }
            $n = $sign % 11;
            $val_num = $arr_ch[$n];
            if ($val_num != substr($id, 17, 1)) {
                return FALSE;
            } else {
                return TRUE;
            }
        }
    } else {           //检查15位
        return FALSE;
        /* $regx = "/^(\d{6})+(\d{2})+(\d{2})+(\d{2})+(\d{3})$/";

          @preg_match($regx, $id, $arr_split);
          //检查生日日期是否正确
          $dtm_birth = "19".$arr_split[2] . '/' . $arr_split[3]. '/' .$arr_split[4];
          if(!strtotime($dtm_birth))
          {
          return FALSE;
          } else {
          return TRUE;
          } */
    }
}

function get_xingbie($cid, $comm = 0) { //根据身份证号，自动返回性别
    $sexint = (int) substr($cid, 16, 1);
    if ($comm > 1) {
        return $sexint % 2 === 0 ? '女士' : '先生';
    } elseif ($comm == 1) {
        return $sexint % 2 === 0 ? 2 : 1;
    } else {
        return $sexint % 2 === 0 ? '女' : '男';
    }
}

function page_count($count, $page_size) {
    if ($count % $page_size == 0)
        return intval($count / $page_size);
    else
        return intval($count / $page_size) + 1;
}

function myfunction($v) {
    if ($v === '' || $v === null) {
        return false;
    }
    return true;
}

//对象转成数组
function objarray_to_array($obj) {
    $ret = array();
    foreach ($obj as $key => $value) {
        if (gettype($value) == "array" || gettype($value) == "object") {
            $ret[$key] = objarray_to_array($value);
        } else {
            $ret[$key] = $value;
        }
    }
    return $ret;
}

//创建目录
function mkDirs($dir) {

    if (!is_dir($dir)) {
        if (!mkDirs(dirname($dir))) {
            return false;
        }
        if (!mkdir($dir, 0777)) {
            return false;
        }
    }
    return true;
}

function dtd_encrypt($input) {//数据加密
    $data = trim($input);
    $data = base64_encode($data);
    return $input;
}

function dtd_decrypt($encrypted) {//数据解密
    $encrypted = trim($encrypted);
    $data = base64_decode($encrypted);
    return $encrypted;
}

function pkcs5_pad($text, $blocksize) {
    $pad = $blocksize - (strlen($text) % $blocksize);
    return $text . str_repeat(chr($pad), $pad);
}

function pkcs5_unpad($text) {
    $pad = ord($text{strlen($text) - 1});
    if ($pad > strlen($text)) {
        return false;
    }
    if (strspn($text, chr($pad), strlen($text) - $pad) != $pad) {
        return false;
    }
    return substr($text, 0, -1 * $pad);
}

/**
 * 获取项目状态
 * @author Forest King <86721071@qq.com>
 * @date 2016-02-01 10:50
 * @param int $status 状态值
 * @param string $keyName 样式值
 * @return array
 */
function get_quest_status($status, $keyName = 'name') {
    $status = intval($status);
    $statusArr = array(
        array('id' => '1', 'name' => '已发布', 'className' => 'released', 'styleName' => '',),
        array('id' => '2', 'name' => '已接单', 'className' => 'ordered', 'styleName' => ''),
        array('id' => '3', 'name' => '已完成待确认', 'className' => 'confirmed', 'styleName' => ''),
        array('id' => '4', 'name' => '已完成', 'className' => 'completed', 'styleName' => 'ld-task-end'),
        array('id' => '5', 'name' => '已关闭', 'className' => 'closed', 'styleName' => '',),
    );
    return !empty($status) ? $statusArr[$status - 1][$keyName] : $statusArr;
}

/**
 * 手机号掩码
 * @param string $param 手机号
 * @return string
 */
function phone_number_mask($param) {
    if (isMobile($param)) {
        $outData = substr($param, 0, 4) . '****' . substr($param, -4, 4);
    } else {
        $outData = $param;
    }
    return $outData;
}

/**
 * 检查用户名、邮箱、所在学校的信息是否符合指定格式
 * @param array $param 用户信息
 * @return boolean
 */
function inspectuser($param = array()) {
    if ($param['username'] == 'NULL' || !isMobile($param['username']) || !is_email($param['email']) || $param['email'] == 'NULL' || $param['school_id'] == '-1' || $param['school_id'] == '0') {
        return FALSE;
    }
    return TRUE;
}
