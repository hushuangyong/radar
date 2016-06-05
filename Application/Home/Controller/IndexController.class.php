<?php

namespace Home\Controller;

use Think\Controller;
use Service\IndexService;
use Service\ProjectService;
use Think\Log;

class IndexController extends Controller {

    private $user_id;

    /**
     * 空操作
     */
    public function _empty() {
        header("HTTP/1.0 404 Not Found"); //使HTTP返回404状态码
        redirect(U(CONTROLLER_NAME . "/radar", '', TRUE, TRUE), 0, '页面跳转中...');
    }

    /**
     * 初始化
     */
    public function _initialize() {
        $refer = $_SERVER['HTTP_REFERER'];
        cookie('refer', $refer); //设置 来源地址
        trace($refer, '设置@Referer@');
        if (!empty(cookie('radar_userid'))) {
            session('user_id', cookie('user_id'));
        }
        $this->user_id = session('user_id');
        $this->assign('topNav', array('newest' => U('Index/radar'), 'study' => U('Index/radar', array('type' => 1)), 'purchasing' => U('Index/radar', array('type' => 2)), 'errands' => U('Index/radar', array('type' => 3)), 'second-hand' => U('Index/radar', array('type' => 4)), 'other' => U('Index/radar', array('type' => 5)))); #顶部导航
        $this->assign('publish', U('Ucenter/publishProject')); #发布
        $this->assign('myCenter', U('Ucenter/index')); #我的
        $this->assign('signin', U('Index/signin')); #登录
        $this->assign('signup', U('Index/signup')); #注册
    }

    //注册--step1--输入手机号/密码
    public function regist() {
        $this->display('regist_s1');
    }

    /**
     * 处理手机号注册
     */
    public function registMobile() {
        if (IS_AJAX) {
            $mobile = I('post.mobile', '');
            $password = I('post.password', '');
            $school = I('post.school', ''); //学校

            if ($mobile && $password && $school) {
                //验证处理参数
                $mobile = trim($mobile);
                $password = trim($password);
                if (!isMobile($mobile)) {
                    $result['code'] = 401;
                    $result['msg'] = '手机号码格式错误~';
                } else {
                    $userInfo = IndexService::getUserInfo($mobile);
                    #$emailInfo = IndexService::getUserInfoByEmail($email);
                    if ($userInfo['id'] > 0) {
                        $result['code'] = 501;
                        $result['msg'] = '该手机号已被注册~';
                        //} else if (!empty($emailInfo['email'])) {
                        //$result['code'] = 502;
                        //$result['msg'] = '该邮箱已被注册~';
                    } else {
                        $status = md5($mobile);
                        session('user_regist_mobile_' . $status, $mobile);
                        session('user_regist_school_' . $status, $school);
                        session('user_regist_password_' . $status, $password);
                        $result['code'] = 200;
                        $result['msg'] = 'OK';
                        $result['info'] = U('Index/registNext', array('status' => $status));
                        $result['status'] = $status;
                    }
                }
            } else {
                $result['code'] = 402;
                $result['msg'] = '信息不能为空~';
            }

            $this->ajaxreturn($result);
        } else {
            exit('非法操作');
        }
    }

    //注册--step2--选择学校
    public function registNext() {
        $status = I('get.status', '');
        $schoolList = IndexService::getSchoolList();
        $this->assign('schoolList', $schoolList);
        $this->assign('status', $status);
        $this->display('regist_s2');
    }

    /**
     * 注册学校后-以事务入库
     */
    public function registSchool() {
        if (IS_AJAX) {
            $status = I('post.status', '');
            $school = I('post.school', '');

            if ($status) {
                //验证处理参数
                $status = trim($status);
                $mobile = session('user_regist_mobile_' . $status);
                $email = session('user_regist_school_' . $status); //原来是邮箱，现在改为学校
                $password = session('user_regist_password_' . $status);
                if ($mobile && $email && $password) {
                    if ($school > 0) {
                        $userInfo = IndexService::getUserInfo($mobile);
                        #$emailInfo = IndexService::getUserInfoByEmail($email);
                        if ($userInfo['id'] > 0) {
                            $result['code'] = 501;
                            $result['msg'] = '该手机号已被注册~';
                            //} else if ($emailInfo['email'] == $email) {
                            //$result['code'] = 504;
                            //$result['msg'] = '该Email已被注册~';
                        } else {
                            $reg = IndexService::regist($mobile, $password, $email, $school);
                            if ($reg > 0) {
                                $result['code'] = 200;
                                $result['msg'] = 'OK';
                                session('user_id', $reg);
                                cookie('radar_userid', $reg, 3600 * 24 * 7);
                                session('user_regist_mobile_' . $status, null);
                                session('user_regist_school_' . $status, null);
                                session('user_regist_password_' . $status, null);
                                $result['info'] = U('Ucenter/index');
                            } else {
                                $result['code'] = 502;
                                $result['msg'] = '通讯错误，注册失败~';
                            }
                        }
                    } else {
                        $result['code'] = 401;
                        $result['msg'] = '学校信息不能为空~';
                    }
                } else {
                    $result['code'] = 503;
                    $result['msg'] = '请求时间过长，请重新注册~';
                }
            } else {
                $result['code'] = 402;
                $result['msg'] = '非法操作';
            }

            $this->ajaxreturn($result);
        }
    }

    /**
     * 登录
     */
    public function login() {
        $this->display('login');
    }

    /**
     * 用户登录
     */
    public function loginUser() {
        if (IS_AJAX) {
            $mobile = I('post.mobile', '');
            $password = I('post.password', '');
            $returnUrl = I('returnUrl', ''); //来源地址

            if ($mobile && $password) {
                //验证处理参数
                $mobile = trim($mobile);
                $password = trim($password);
                $password = md5($password);
                if (!isMobile($mobile)) {
                    $result['code'] = 401;
                    $result['msg'] = '手机号码格式错误~';
                } else {
                    $userInfo = IndexService::getUserInfo($mobile);
                    if ($userInfo['id'] > 0) {
                        if ($userInfo['password'] == $password) {
                            $result['code'] = 200;
                            $result['msg'] = 'OK';
                            $result['info'] = $returnUrl ? $returnUrl : U('Ucenter/index');
                            session('user_id', $userInfo['id']);
                            cookie('radar_userid', $userInfo['id']);
                            IndexService::updateUserInfo($mobile, array('last_login' => time(), 'login_ip' => ip_address())); //登录成功后，更新用户信息
                        } else {
                            $result['code'] = 501;
                            $result['msg'] = '手机或密码错误~';
                        }
                    } else {
                        $result['code'] = 502;
                        $result['msg'] = '该手机尚未注册~';
                    }
                }
            } else {
                $result['code'] = 402;
                $result['msg'] = '信息不能为空~';
            }

            $this->ajaxreturn($result);
        }
    }

    /**
     * 退出登录
     */
    public function logout() {
        session(null);
        cookie('radar_userid', NULL);
        if (IS_AJAX) {
            $result['code'] = 200;
            $result['msg'] = 'OK';
            $result['info'] = U('Index/radar');
            $this->ajaxreturn($result);
        } else {
            redirect(U(CONTROLLER_NAME . "/radar", '', TRUE, TRUE), 0, '页面跳转中...');
        }
    }

    //首页
    public function lists() {
        //$st =   new \SaeStorage();
        //echo $st->getUrl('public','');
        //获取项目列表
        $class_id = I('get.type', 0); //类别
        $sgkey = I('get.sgkey', 0); //用来获取关注人的数据
        $page = I('get.page', '1', 'intval');
        if ($page < 1) {
            $page = 1;
        }
        $length = 10;
        $offset = ($page - 1) * $length;
        $plist = ProjectService::getProject($class_id, $sgkey, $offset, $length);
        $this->assign('plist', $plist);
        $this->assign('user_id', session('user_id')); //当前用户id
        $this->display('index');
    }

    //首页
    public function index() {
        redirect(U('Index/radar'));
    }

    /**
     * 首页/列表页
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-19 19:29
     */
    public function radar() {
        trace($this->user_id, '当前用户ID');
        //获取项目列表
        $dataType = I('dataType', '');
        $class_id = I('type', 0); //类别
        $sgkey = I('sgkey', 0); //用来获取关注人的数据
        $page = I('page', '1', 'intval'); //当前分页
        if ($page < 1) {
            $page = 1;
        }
        $length = 10;
        $offset = ($page - 1) * $length;
        $plist = ProjectService::getProject($class_id, $sgkey, $offset, $length);
        trace($plist);
        if ('dataJson' == $dataType) {
            sort($plist);
            sleep(1);
            $this->ajaxReturn($plist);
        }

        $this->assign('plist', $plist);
        $this->assign('_type', $class_id);
        $this->assign('_sgkey', $sgkey);
        $this->assign('user_id', $this->user_id); //当前用户id
        $this->display('radar');
    }

    /**
     * 登录页面
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-19 19:39
     */
    public function signin() {
        $refer = cookie('refer');
        if (!empty($this->user_id)) {
            if (strpos($refer, 'Index/signin.html')) {
                $refer = str_replace('signup', 'index', $refer);
            }
            redirect($refer); #如果已经登录，就跳到来源页面
            exit();
        } else {
            trace($refer, '读取来源@');
            $this->assign('refer', $refer);
            $this->display();
        }
    }

    /**
     * 注册页面
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-19 19:49
     */
    public function signup() {
        $refer = cookie('refer');
        if (!empty($this->user_id)) {
            if (strpos($refer, 'Index/signup.html')) {
                $refer = str_replace('signup', 'index', $refer);
            }
            $this->success('您已经登录～', $refer); #如果已经登录，就跳到来源页面
            exit();
        } else {
            //获取学校列表
            $schoolList = session('radar_schoolList');
            if (empty($schoolList)) {
                $schoolList = IndexService::getSchoolList();
                session('radar_schoolList', serialize($schoolList));
            } else {
                $schoolList = unserialize($schoolList);
            }
            trace($schoolList);
            $this->assign('schoolList', $schoolList);

            $this->display('signup');
        }
    }

}
