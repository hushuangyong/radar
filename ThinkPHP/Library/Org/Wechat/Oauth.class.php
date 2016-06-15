<?php

namespace Org\Wechat;

/**
 * 微信网页授权
 * @author Forest King <86721071@qq.com>
 * @date 2016-06-15 15:30
 */
class Oauth {

    protected $appid;               //公众平台AppID
    protected $appsecret;   //公众平台AppSecret;
    protected $curl_timeout;        //CRUL超时时间 默认30S
    protected $code;                        //Oauth认证 回调Code
    protected $flag;                        //Oauth认证的模式
    //false-->不弹出授权页面，直接跳转，只能获取用户openid
    //true-->弹出授权页面，可通过openid拿到昵称、性别、所在地。并且，即使在未关注的情况下，只要用户授权，也能获取其信息
    protected $access_token; //网页授权接口调用凭证,注意：此access_token与基础支持的access_token不同
    protected $openid; // 用户的唯一标识
    protected $refresh_token;

    public function __construct($appid = '', $appsecret = '', $curl_timeout = 30, $flag = false) {
        if ($appid == '' || $appsecret == '') {
            return false;
        }
        $this->appid = $appid;
        $this->appsecret = $appsecret;
        $this->curl_timeout = $curl_timeout;
        $this->flag = $flag;
    }

    /**
     * 第一步：用户同意授权，获取code
     * 作用：生成可以获得code的url
     */
    public function createOauthUrlForCode($redirectUrl = '') {
        if ($redirectUrl == '') {
            return false;
        }
        $urlObj['appid'] = $this->appid; #公众号的唯一标识
        $urlObj['redirect_uri'] = urlencode($redirectUrl); #授权后重定向的回调链接地址，请使用urlencode对链接进行处理
        $urlObj['response_type'] = 'code'; #返回类型，请填写code

        /**
         * 应用授权作用域，snsapi_base （不弹出授权页面，直接跳转，只能获取用户openid），snsapi_userinfo （弹出授权页面，可通过openid拿到昵称、性别、所在地。并且，即使在未关注的情况下，只要用户授权，也能获取其信息）
         */
        if ($this->flag) {
            $urlObj["scope"] = "snsapi_userinfo"; //弹出授权页面
        } else {
            $urlObj["scope"] = "snsapi_base";       //不弹出授权页面
        }

        $urlObj["state"] = "STATE" . "#wechat_redirect";
        $bizString = $this->formatPara($urlObj);
        $url = 'https://open.weixin.qq.com/connect/oauth2/authorize?' . $bizString;
        return $url;
    }

    /**
     * 第二步：通过code换取网页授权access_token
     * 作用：生成可以获得openid的url
     * 
     */
    public function createOauthUrlForOpenid() {
        $urlObj["appid"] = $this->appid; #公众号的唯一标识
        $urlObj["secret"] = $this->appsecret; #公众号的appsecret
        $urlObj["code"] = $this->code; #填写第一步获取的code参数
        $urlObj["grant_type"] = "authorization_code"; #填写为authorization_code   
        $bizString = $this->formatPara($urlObj);
        return "https://api.weixin.qq.com/sns/oauth2/access_token?" . $bizString;
    }

    /**
     * 作用：生成可以获得用户详细信息的URL
     */
    public function createUrlForUserInfo() {
        $urlObj["access_token"] = $this->access_token; //网页授权接口调用凭证,注意：此access_token与基础支持的access_token不同
        $urlObj["openid"] = $this->openid; //用户的唯一标识
        $urlObj["lang"] = 'zh_CN '; //返回国家地区语言版本，zh_CN 简体，zh_TW 繁体，en 英语
        $bizString = $this->formatPara($urlObj);
        return "https://api.weixin.qq.com/sns/userinfo?" . $bizString;
    }

    /**
     * 作用：设置code
     */
    public function setCode($code_) {
        $this->code = $code_;
    }

    /**
     * 作用：通过curl向微信提交code，以获取openid  类型为snsapi_base 到此结束
     */
    public function getOpenid() {
        $url = $this->createOauthUrlForOpenid(); # 第二步：通过code换取网页授权access_token
        $res = file_get_contents($url);
        //取出openid
        $data = json_decode($res, true);
        $this->access_token = $data['access_token']; #网页授权接口调用凭证,注意：此access_token与基础支持的access_token不同
        $this->expires_in = $data['expires_in']; #access_token接口调用凭证超时时间，单位（秒）
        $this->refresh_token = $data['refresh_token']; #用户刷新access_token
        $this->openid = $data['openid']; #用户唯一标识，请注意，在未关注公众号时，用户访问公众号的网页，也会产生一个用户和公众号唯一的OpenID
        $this->scope = $data['scope']; #用户授权的作用域，使用逗号（,）分隔
        return $this->openid;
    }

    /**
     * 作用：通过curl获取用户信息 类型为snsapi_userinfo调用
     */
    public function getUserInfo() {
        $this->getOpenid();
        $url = $this->createUrlForUserInfo();
        $auth = $this->checkAccessToken();
        if ($auth['errcode'] == 40003) {
            $refresh = $this->refreshToken(); //刷新access_token
            if ($refresh['errcode'] != 40029) {
                $this->access_token = $refresh['access_token'];
                $this->expires_in = $refresh['expires_in'];
                $this->refresh_token = $refresh['refresh_token'];
            }
        }
        $res = file_get_contents($url);
        //取出openid
        $data = json_decode($res, true);

        return $data;
    }

    /**
     * 第三步：刷新access_token（如果需要）
     * @date 2016-06-14 10:48
     * @author God
     */
    function refreshToken() {
        $url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=" . $this->appid . "&grant_type=refresh_token&refresh_token=" . $this->refresh_token;
        $Info_json = file_get_contents($url);
        return json_decode($Info_json, true);
    }

    /**
     * 作用：生成参数
     */
    protected function formatPara($paraMap) {
        $buff = '';
        foreach ($paraMap as $k => $v) {
            $buff .= $k . '=' . $v . '&';
        }
        $reqPar = '';
        if (strlen($buff) > 0) {
            $reqPar = substr($buff, 0, strlen($buff) - 1);
        }
        return $reqPar;
    }

    /**
     * 附：检验授权凭证（access_token）是否有效
     * http：GET（请使用https协议） https://api.weixin.qq.com/sns/auth?access_token=ACCESS_TOKEN&openid=OPENID 
     * @return array 返回json
     */
    function checkAccessToken() {
        $url = "https://api.weixin.qq.com/sns/auth?access_token=" . $this->access_token . "&openid=" . $this->openid;
        $Info_json = file_get_contents($url);
        $data = json_decode($Info_json, true);
        return $data;
    }

}
