<?php

namespace Home\Controller;

use Think\Controller;
use Service\IndexService;
use Service\ProjectService;
use Service\UcenterService;
use Think\Log;

/**
 * 用户中心 控制器
 */
class UcenterController extends Controller {

    /**
     * 当前登录的用户ID
     * @var string 
     */
    private $user_id;

    /**
     * 空操作
     */
    public function _empty() {
        header("HTTP/1.0 404 Not Found"); //使HTTP返回404状态码
        redirect(U(CONTROLLER_NAME . "/index", '', TRUE, TRUE), 0, '页面跳转中...');
    }

    /**
     * 初始化
     */
    public function _initialize() {
        $this->redis = new \Redis();
        $this->redis->connect(C('REDIS_HOST'), C('REDIS_PORT'));

        $c_userid = cookie('radar_userid');
        $s_userid = session('user_id');
        if (!empty($c_userid) && empty($s_userid)) {
            session('user_id', $c_userid);
        }
        //从Redis取用户id
        $redisUserId = $this->redis->get('red_user_id_' . $c_userid);
        $this->user_id = session('user_id') ? session('user_id') : $redisUserId;
        $this->assign('user_id', $this->user_id);
        if (!empty($this->user_id)) {
            //获取用户与信息
            $userInfo = $this->getUserInfo($this->user_id);
            if (!isMobile($userInfo['username']) && !empty($userInfo['nickname'])) {
                $userInfo['username'] = $userInfo['nickname'];
            }

            trace($userInfo);
            $this->assign('user_info', $userInfo);
        }
        #页面导航
        $linkUrl = array(
            'setting' => U(CONTROLLER_NAME . '/setting'), #账号设置
            'publish' => U(CONTROLLER_NAME . '/publishProject'),
            'published' => U(CONTROLLER_NAME . '/orderTaking', array('sgkey' => dtd_encrypt($this->user_id))), #已发布
            'myHome' => U(CONTROLLER_NAME . '/index'),
            'myGetted' => U(CONTROLLER_NAME . '/orderTaking'),
            'myFocus' => U(CONTROLLER_NAME . '/myCollectionTask'),
            'userAddress' => U(CONTROLLER_NAME . '/address'), #地址管理
            'aboutUs' => U(CONTROLLER_NAME . '/aboutUs'),
            'indexHome' => U('Index/index'));
        trace($linkUrl);
        $this->assign('pageUrl', $linkUrl);

        //获取发布范围
        $rangeHC = session('radar_rangeHC');
        if (!$rangeHC) {
            $range = UcenterService::getRange(); //发布范围
            $rangeHC = serialize($range);
            if ($rangeHC)
                session('radar_rangeHC', $rangeHC);
        }else {
            $range = unserialize($rangeHC);
        }

        //获取类型
        $classHC = session('radar_classHC');
        if (!$classHC) {
            $class = UcenterService::getClass(); //类别
            $classHC = serialize($class);
            if ($classHC)
                session('radar_classHC', $classHC);
        }else {
            $class = unserialize($classHC);
        }
        //获取学校列表
        $schoolList = $this->redis->get('radar_schoolList');
        if (empty($schoolList)) {
            $schoolList = IndexService::getSchoolList();
            $this->redis->set('radar_schoolList', serialize($schoolList));
        } else {
            $schoolList = unserialize($schoolList);
        }
        trace($schoolList);

        $this->assign('range', $range);
        $this->assign('rclass', $class);
        $this->assign('schoolList', $schoolList);
    }

    /**
     * 我的个人中心
     */
    public function index() {
        if ($this->user_id) {


            $this->display();
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 我的－我的关注－任务
     */
    public function myCollectionTask() {
        if ($this->user_id) {
            //获取个人已收藏项目列表
            $userPublished = UcenterService::getCollection($this->user_id);

            trace($userPublished);
            $this->assign('dataList', $userPublished);
            $this->display();
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 我的－我的关注－用户
     */
    public function myFollowUser() {
        if ($this->user_id) {
            //获取个人已收藏项目列表
            $userPublished = UcenterService::getFollow($this->user_id);
            trace($userPublished);

            $this->assign('dataList', $userPublished);
            $this->display();
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 获取用户信息（带缓存）
     * @param string $userid 用户id
     * @return array
     */
    public function getUserInfo($userid) {
        if ($this->user_id) {
            //获取用户与信息
            $user_info_hc = session('radar_userinfo_' . $userid);
            //session('radar_userinfo_'.$userid,null);
            if (!$user_info_hc) {
                $user_info = UcenterService::getUserInfoM($userid);
                $user_info_hc = serialize($user_info);
                if ($user_info_hc)
                    session('radar_userinfo_' . $userid, $user_info_hc);
            }else {
                $user_info = unserialize($user_info_hc);
            }
            //dump($user_info);
            return $user_info;
        } else {
            return false;
        }
    }

    //用户中心首页
    public function myCenter() {
        if ($this->user_id) {
            //获取用户与信息
            $user_info = $this->getUserInfo($this->user_id);
            $this->assign('user_info', $user_info);
            $this->display('my_center');
        } else {
            $this->redirect('Index/signin');
        }
    }

    //我的收藏
    public function myCollection() {
        if ($this->user_id) {
            //获取个人已收藏项目列表
            $userPublished = UcenterService::getCollection($this->user_id);
            $this->assign('userPublished', $userPublished);

            #$this->assign('user_info', $user_info);
            $this->display('my_collection');
        } else {
            $this->redirect('Index/signin');
        }
    }

    //我的关注列表
    public function myFollow() {
        if ($this->user_id) {
            //获取个人已收藏项目列表
            $userPublished = UcenterService::getFollow($this->user_id);

            $this->assign('userPublished', $userPublished);

            #$this->assign('user_info', $user_info);
            $this->display('my_follow');
        } else {
            $this->redirect('Index/signin');
        }
    }

    //忘记密码--step1
    public function resetPassword() {

        $this->display('reset_password_s1');
    }

    /**
     * 发送邮箱验证码
     */
    public function mobileCheck() {
        if (IS_AJAX) {
            $email = I('post.mobile', '');

            if ($email) {
                //验证处理参数
                $email = trim($email);
                if (!is_email($email)) {
                    $result['code'] = 401;
                    $result['msg'] = '邮箱格式错误~';
                } else {
                    $userInfo = IndexService::getUserInfoByEmail($email);
                    if (empty($userInfo) && !is_array($userInfo)) {
                        $result['code'] = '404';
                        $result['msg'] = '该邮箱地址不存在~';
                    } else {
                        $code = rand(100000, 999999); //生成随机验证码
                        session('retrieve_password_authentication_code', $code); //将验证码存入服务器
                        session('retrieve_password_authentication_email', $email); //将邮箱地址存入服务器
                        session('auth_code_send_time', time()); //验证码的发送时间戳
                        $send = send_email(array('title' => '校园雷达 -- 找回密码', 'content' => $code, 'toemail' => $userInfo['email'])); #发送邮件
                        if (TRUE == $send) {
                            $result['code'] = 200;
                            $result['msg'] = 'OK';
                            $result['info'] = U('Ucenter/resetPasswordCheck');
                        } else {
                            $result['code'] = '201';
                            $result['msg'] = '邮件发送失败～';
                        }
                    }
                }
            } else {
                $result['code'] = 402;
                $result['msg'] = '邮箱不能为空~';
            }
        } else {
            $result['code'] = 403;
            $result['msg'] = '非法操作';
        }

        $this->ajaxreturn($result);
    }

    //忘记密码--step2
    public function resetPasswordCheck() {
        $email = session('retrieve_password_authentication_email');
        $this->assign('email', $email);
        $this->display('reset_password_s2');
    }

    /**
     * 重置用户密码
     * @return json
     */
    function updatePassword() {
        $email = session('retrieve_password_authentication_email'); //获取服务器里的邮箱地址
        if (IS_AJAX && $email) {
            $vcode = I('vcode', ''); //表单的验证码
            $newpass = I('newpass', '', 'md5'); //表单的新密码
            $code = session('retrieve_password_authentication_code'); //获取服务器里的验证码
            $code_time = session('auth_code_send_time'); //验证码的发送时间戳
            if (isset($code_time) && ((time() - $code_time) > 1800)) {
                $result['code'] = '402';
                $result['msg'] = '验证码已过期~';
            } else if ($vcode && ($vcode == $code) && is_email($email)) {
                $flag = IndexService::updateUserPassword($email, $newpass);
                if (TRUE == $flag) {
                    session('retrieve_password_authentication_code', NULL); //清空验证码
                    session('retrieve_password_authentication_email', NULL); //清空email
                    $result['code'] = '200';
                    $result['msg'] = '密码重置成功';
                    $result['info'] = U('Index/radar');
                } else {
                    $result['code'] = '201';
                    $result['msg'] = '密码重置失败';
                }
            } else {
                $result['code'] = '403';
                $result['msg'] = '验证码不正确哦~';
            }
        } else {
            $result['code'] = '404';
            $result['msg'] = '非法请求，一定是你的请求姿势不对~';
        }
        $this->ajaxreturn($result);
    }

    //发布项目--页面
    public function publish() {
        if ($this->user_id) {


            //获取个人收货地址
            //$userAddress = UcenterService::getUserAddress($this->user_id);
            //删除所有属于自己的临时图片
            UcenterService::del_temp_img($this->user_id);


            $quest_id = I('get.pubid', '');
            if ($quest_id) {
                //获取项目详情
                $userPublished = UcenterService::getUserPublishedDetail($quest_id, $this->user_id);
                if (is_array($userPublished) && (1 != $userPublished['quest_status'])) {
                    $this->error('只有状态为“已发布”的项目才能被编辑！', U('Index/index'));
                    //redirect(U('Index/index'), 3, '只有状态为“已发布”的项目才能被编辑！');
                }
                //文章图片
                $userPublishedimg = UcenterService::getUserPublishedDetailImg($quest_id);
                if (!$userPublishedimg) {

                    $userPublishedimg = '';
                }

                $this->assign('userPublished', $userPublished);
                $this->assign('userPublishedimg', $userPublishedimg);
                $this->assign('quest_id', $quest_id);
            } else {
                $userPublished['end_time'] = time();
                $this->assign('userPublished', $userPublished);
            }

            #$this->assign('userAddress', $userAddress);
            $this->display('my_publish');
        } else {
            $this->redirect('Index/signin');
        }
    }

    //发布项目--处理
    public function publishCheck() {
        if (IS_AJAX) {
            if ($this->user_id) {
                $title = I('post.title', '');
                $range = I('post.range', '');
                $rclass = I('post.rclass', '');
                $end_time = I('post.end_time', ''); //截止时间
                $province = I('post.province', ''); //省
                $city = I('post.city', ''); //市
                $distin = I('post.distin', ''); //区县
                $distin = ('null' == $distin) ? '' : $distin;
                $userAddress = I('post.userAddress', '');
                $content = I('post.content', '');
                $award = I('post.award', '');
                $checkval = I('post.checkval', '');
                $imagefile = I('post.imagefile', '');
                $models = I('post.models', '');
                $quest_id = I('post.quest_id', '');
                if ($title && $range && $rclass && $userAddress && $content && $award && $checkval) {
                    //验证处理参数
                    $title = trim($title);
                    if (mb_strlen($title) > 30) {
                        $this->ajaxreturn(array('code' => '4001', 'msg' => '标题不超过15个字符！您已经输入了' . mb_strlen($title) . '个字符。'));
                        exit();
                    }
                    $content = trim($content);
                    if (mb_strlen($content) > 280) {
                        $this->ajaxreturn(array('code' => '4002', 'msg' => '任务描述不超过140个字符！您已经输入了' . mb_strlen($award) . '个字符。'));
                        exit();
                    }
                    if (1 == $checkval) {
                        $award = floatval($award); // 价格
                    } elseif (2 == $checkval) {
                        $award = trim($award); //其他奖励
                    }
                    $end_time = strtotime($end_time);
                    if ($models == 'add') {
                        $publish_result = UcenterService::publish($this->user_id, $title, $range, $rclass, $end_time, $province, $city, $distin, $userAddress, $content, $award, $checkval, $imagefile);
                    } else if ($models == 'update') {
                        //修改
                        //获取项目详情
                        $userPublished = UcenterService::getUserPublishedDetail($quest_id, $this->user_id);
                        if (is_array($userPublished) && (1 != $userPublished['quest_status'])) {
                            $this->ajaxreturn(array('code' => 201, 'msg' => '只有状态为“已发布”的项目才能被编辑！'));
                        }
                        $publish_result = UcenterService::Up_publish($quest_id, $title, $range, $rclass, $end_time, $province, $city, $distin, $userAddress, $content, $award, $checkval, $imagefile);
                    }



                    if ($publish_result > 0) {
                        $result['code'] = 200;
                        $result['msg'] = 'OK';
                        $result['info'] = U('Ucenter/index');
                    } else {
                        $result['code'] = 501;
                        $result['msg'] = '通讯错误，发布失败~';
                    }
                } else {
                    $result['code'] = 401;
                    $result['msg'] = '信息不能为空~';
                }
            } else {
                $result['code'] = 402;
                $result['msg'] = '请先登录';
            }
        } else {
            $result['code'] = 403;
            $result['msg'] = '非法操作';
        }
        $this->ajaxreturn($result);
    }

    //我的已发布项目列表
    public function myPubilshed() {
        if ($this->user_id) {
            //获取个人已发布项目列表
            $userPublished = UcenterService::getUserPublished($this->user_id);
            if (is_array($userPublished) && !empty($userPublished)) {
                foreach ($userPublished as $key => $value) {
                    $userPublished[$key]['status_name'] = get_quest_status($value['quest_status']);
                    $userPublished[$key]['className'] = get_quest_status($value['quest_status'], 'className');
                }
            }

            $this->assign('userPublished', $userPublished);
            $this->display('pdetail_published_list');
        } else {
            $this->redirect('Index/signin');
        }
    }

    //我的已发布项目--单个详情
    public function myPubilshedDetail() {
        if ($this->user_id) {
            $quest_id = I('get.pubid', '');
            if ($quest_id) {
                //获取项目详情
                $userPublished = UcenterService::getUserPublishedDetail($quest_id, $this->user_id);
                if (empty($userPublished) || !is_array($userPublished)) {
                    redirect(U('Index/index'), 3, '该任务不存在或已被删除～');
                }
                //获取用户与信息
                $user_info = $this->getUserInfo($userPublished['public_user_id']);
                //文章图片
                $userPublishedimg = UcenterService::getUserPublishedDetailImg($quest_id);
                if (!$userPublishedimg) {

                    $userPublishedimg = '';
                }
                $this->assign('user_info', $user_info);
                $this->assign('userPublished', $userPublished);
                $this->assign('userPublishedimg', $userPublishedimg);
                $this->display('pdetail_published');
            } else {
                $this->redirect('Ucenter/myPubilshed');
            }
        } else {
            $this->redirect('Index/signin');
        }
    }

    //我的已抢单项目列表
    public function myGeted() {
        if ($this->user_id) {
            //获取个人已获得项目列表
            $userGeted = UcenterService::getUserGeted($this->user_id);
            if (is_array($userGeted) && !empty($userGeted)) {
                foreach ($userGeted as $key => $value) {
                    $userGeted[$key]['status_name'] = get_quest_status($value['quest_status']);
                    $userGeted[$key]['className'] = get_quest_status($value['quest_status'], 'className');
                }
            }

            $this->assign('userGeted', $userGeted);
            $this->display('pdetail_geted_list');
        } else {
            $this->redirect('Index/signin');
        }
    }

    //我的已抢单项目--单个详情
    public function myGetedDetail() {
        if ($this->user_id) {
            $quest_id = I('get.pubid', '');
            if ($quest_id) {
                //获取项目详情
                $userGeted = UcenterService::getUserGetedDetail($quest_id, $this->user_id);
                if (empty($userGeted) || !is_array($userGeted)) {
                    redirect(U('Index/index'), 3, '该任务不存在或已被删除～');
                }
                $userGeted['detail_url'] = U('Project/projectDetail', array('pubid' => $userGeted['quest_id'],)); // 任务详细页
                //获取用户与信息
                $user_info = $this->getUserInfo($userGeted['public_user_id']);

                $this->assign('user_info', $user_info);
                $this->assign('userGeted', $userGeted);
                $this->display('pdetail_geted');
            } else {
                $this->redirect('Ucenter/myGeted');
            }
        } else {
            $this->redirect('Index/signin');
        }
    }

    //下单
    public function getOrder() {
        if (IS_AJAX) {
            if ($this->user_id) {
                $quest_id = I('post.quest_id', '');
                $idArr = explode(',', $quest_id);

                foreach ($idArr as $key => $questId) {
                    if ($questId) {
                        //下单
                        $thisorder = UcenterService::orderQuest($questId, $this->user_id);
                        if ($thisorder == 1) {
                            $result['code'] = 200;
                            $result['msg'] = 'OK';
                            $result['info'] = U('Ucenter/orderTaking');
                        } elseif ($thisorder == 2) {
                            $result['code'] = 501;
                            $result['msg'] = '亲，不能抢自己的单哦~';
                        } else if ($thisorder == 3) {
                            $result['code'] = '503';
                            $result['msg'] = '此单已被抢～';
                        } else if ($thisorder == 4) {
                            $result['code'] = '504';
                            $result['msg'] = '项目编号：' . $questId . '， ' . '已被抢或已过截止时间～';
                        } else {
                            $result['code'] = 502;
                            $result['msg'] = '通讯错误，抢单失败~';
                        }
                    } else {
                        #$result['code'] = 401;
                        #$result['msg'] = '非法操作~';
                    }
                }
            } else {
                $result['code'] = 402;
                $result['msg'] = '请先登录~';
            }
        } else {
            $result['code'] = 403;
            $result['msg'] = '非法操作';
        }

        $this->ajaxreturn($result);
    }

    /**
     * 添加收藏
     * @author Forest King <86721071@qq.com>
     * @date 2016-01-22 20:20
     */
    public function setCollection() {
        if ($this->user_id) {
            $quest_id = (int) $_POST['qid']; //文章ID
            $data = UcenterService::setCollection($quest_id, $this->user_id);
            if ($data == 1) {
                $result['code'] = 403;
                $result['msg'] = '你已经收藏过了~';
            } else if ($data == 2) {
                $result['code'] = 404;
                $result['msg'] = '收藏成功~';
            } else if ($data == 3) {
                $result['code'] = 405;
                $result['msg'] = '收藏失败';
            } else if ($data == 4) {
                $result['code'] = 407;
                $result['msg'] = '你不能收藏自己的单！';
            } else {
                $result['code'] = 406;
                $result['msg'] = '通讯错误，收藏失败~';
            }
        } else {
            $result['code'] = 402;
            $result['msg'] = '请先登录~';
        }

        echo json_encode($result);
        exit();
    }

    /**
     * 添加关注
     * @author Forest King <86721071@qq.com>
     * @date 2016-01-16 20:20
     */
    public function setFollow() {
        if ($this->user_id) {
            $quest_id = (int) $_POST['qid']; //文章ID
            $res = UcenterService::getUserPublishedDetailFind($quest_id); // 获取发布人用户id
            $public_user_id = $res['public_user_id'];
            $data = UcenterService::setFollow($this->user_id, $public_user_id);
            if ($data == 1) {
                $result['code'] = 403;
                $result['msg'] = '你已经关注过了~';
            } else if ($data == 2) {
                $result['code'] = 404;
                $result['msg'] = '关注成功~';
            } else if ($data == 3) {
                $result['code'] = 405;
                $result['msg'] = '关注失败';
            } else if ($data == 4) {
                $result['code'] = 407;
                $result['msg'] = '你不能关注自己！';
            } else {
                $result['code'] = 406;
                $result['msg'] = '通讯错误，关注失败~';
            }
        } else {
            $result['code'] = 402;
            $result['msg'] = '请先登录~';
        }

        echo json_encode($result);
        exit();
    }

    /**
     * 关闭任务
     * @author Forest King <86721071@qq.com>
     * @date 2016-01-26 20:20
     * @return json
     */
    function closeQuest() {
        if (IS_AJAX && $this->user_id) {
            $quest_id = I('quest_id', 0, 'intval');
            if (empty($quest_id)) {
                return false;
            }
            $questArr = UcenterService::getUserPublishedDetail($quest_id, $this->user_id);
            if (1 != $questArr['quest_status']) {
                $result['code'] = '403';
                $result['msg'] = '无法关闭';
            } else {
                $data = ProjectService::updateQuestStutus($this->user_id, $quest_id);
                if ($data) {
                    $result['code'] = '200';
                    $result['msg'] = '任务已关闭';
                } else {
                    $result['code'] = '404';
                    $result['msg'] = '任务关闭失败';
                }
            }
        } else {
            $result['code'] = '400';
            $result['msg'] = '非法请求';
        }
        $this->ajaxreturn($result);
    }

    /**
     * 完成任务
     * @author Forest King <86721071@vip.qq.com>
     * @date 2016-01-17 13:52
     * @return json
     */
    function doneQuest() {
        if (IS_AJAX && $this->user_id) {
            $quest_id = I('quest_id', 0, 'intval');
            if (empty($quest_id)) {
                return false;
            }
            $questArr = UcenterService::getUserGetedDetail($quest_id, $this->user_id);
            if (2 != $questArr['quest_status']) {
                $result['code'] = '403';
                $result['msg'] = '无法确认完成！';
            } else {
                $flag = ProjectService::updateOrderQuestStutus($this->user_id, $quest_id, '3');
                if ($flag) {
                    $result['code'] = '200';
                    $result['msg'] = '任务已完成～';
                } else {
                    $result['code'] = '404';
                    $result['msg'] = '任务完成失败！';
                }
            }
        } else {
            $result['code'] = '400';
            $result['msg'] = '非法请求';
        }
        $this->ajaxreturn($result);
    }

    /**
     * 取消收藏
     * @date 2015/12/29 11:02
     * @author Forest King <86721071@qq.com>
     * @return json
     */
    function cancelCollection() {
        if (IS_AJAX) {
            $pubid = I('post.pubid', '0', 'intval');
            if (!empty($pubid) && !empty($this->user_id)) {
                $flag = UcenterService::deleteCollection(array('quest_id' => $pubid, 'user_id' => $this->user_id));
                if (TRUE == $flag) {
                    $result['code'] = '200';
                    $result['msg'] = '删除成功';
                } else {
                    $result['code'] = '201';
                    $result['msg'] = '删除失败';
                }
            } else {
                $result['code'] = '403';
                $result['msg'] = '非法操作，收藏编号不能为空~';
            }

            $this->ajaxreturn($result);
        }
    }

    /**
     * 取消关注
     * @author Forest King <86721071@qq.com>
     * @date 2015/12/29 11:02
     * @return json
     */
    function cancelAttention() {
        if (IS_AJAX) {
            $id = I('post.id', '0', 'intval');
            if (!empty($id) && !empty($this->user_id)) {
                $flag = UcenterService::cancelAttention(array('follow_id' => $id, 'm_user_id' => $this->user_id));
                if (TRUE == $flag) {
                    $result['code'] = '200';
                    $result['msg'] = '删除成功';
                } else {
                    $result['code'] = '201';
                    $result['msg'] = '删除失败';
                }
            } else {
                $result['code'] = '403';
                $result['msg'] = '非法操作，关注编号不能为空~';
            }

            $this->ajaxreturn($result);
        }
    }

    /**
     * 确认接单
     * @author Forest King <86721071@qq.com>
     * @date 2016-02-01 13:45
     * @return json
     */
    function confirmOrder() {
        if (IS_AJAX) {
            $pubid = I('post.pubid', '0', 'intval');
            if (!empty($pubid) && !empty($this->user_id)) {
                $flag = ProjectService::updateQuestStutus($this->user_id, $pubid, '4');
                if (TRUE == $flag) {
                    $result['code'] = '200';
                    $result['msg'] = '更新成功';
                } else {
                    $result['code'] = '201';
                    $result['msg'] = '更新失败';
                }
            } else {
                $result['code'] = '403';
                $result['msg'] = '非法操作，任务编号不能为空~';
            }

            $this->ajaxreturn($result);
        }
    }

    /**
     * 我的－我的接单
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-25 10:28
     */
    public function orderTaking() {
        if ($this->user_id) {
            $sgkey = I('get.sgkey', '', 'intval'); #地址栏的用户id-已发布
            $status = I('get.status', '2', 'intval,int'); //项目的状态
            //获取个人已获得项目列表
            $userGeted = UcenterService::getUserGeted($this->user_id, $status, $sgkey);
            if (is_array($userGeted) && !empty($userGeted)) {
                foreach ($userGeted as $key => $value) {
                    if (1 == $value['quest_reward_type']) {
                        $userGeted[$key]['quest_reward'] = '￥' . $value['quest_reward']; #价格
                    } else if (2 == $value['quest_reward_type']) {
                        $userGeted[$key]['quest_reward'] = $value['quest_reward']; #其他奖励
                    }
                    $userGeted[$key]['projectDetail'] = $sgkey ? U('Project/detail', array('pubid' => $value['quest_id'],)) : U('Ucenter/myOrderDetail', array('pubid' => $value['quest_id'],)); // 任务详细页
                    $userGeted[$key]['sgkeyUrl'] = U('Index/radar', array('sgkey' => dtd_encrypt($value['public_user_id']))); # 该用户发布的项目
                    $userGeted[$key]['public_username'] = phone_number_mask($value['public_username']); #处理手机号
                    $userGeted[$key]['status_name'] = get_quest_status($value['quest_status']); #获取状态的对应名
                    $userGeted[$key]['className'] = get_quest_status($value['quest_status'], 'styleName'); #获取状态的对应style名称
                    $userGeted[$key]['follow'] = UcenterService::isFollow($this->user_id, $value['public_user_id']); #是否关注
                    $userGeted[$key]['user_id'] = UcenterService::isCollection($this->user_id, $value['quest_id']); #是否收藏
                    $userGeted[$key]['dateline'] = ($value['end_time'] > time()) ? ( $value['end_time'] - time()) : 0; #剩余时间
                    $userGeted[$key]['userPublishedimg'] = UcenterService::getUserPublishedDetailImg($value['quest_id'], 4); #项目图片
                }
            }
            $statusArr = array(array('name' => '已接收', 'url' => U(CONTROLLER_NAME . '/' . ACTION_NAME, 'status=2&sgkey=' . $sgkey), 'status' => 2,), array('name' => '完成待确认', 'url' => U(CONTROLLER_NAME . '/' . ACTION_NAME, 'status=3&sgkey=' . $sgkey), 'status' => 3,), array('name' => '已结束', 'url' => U(CONTROLLER_NAME . '/' . ACTION_NAME, 'status=4&sgkey=' . $sgkey), 'status' => 4,));
            trace($status, '状态码');
            trace($statusArr, '状态');
            trace($userGeted);

            $this->assign('status', $status);
            $this->assign('orderStatus', $statusArr);
            $this->assign('userGeted', $userGeted);
            $this->display();
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 我的－我的接单－已接单详情
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-25 15:36
     */
    public function myOrderDetail() {
        if ($this->user_id) {
            $quest_id = I('get.pubid', '', 'intval'); #项目ID
            if ($quest_id) {
                //获取项目详情
                $userGeted = UcenterService::getUserGetedDetail($quest_id, $this->user_id);
                if (empty($userGeted) || !is_array($userGeted)) {
                    redirect(U('Index/index'), 3, '该任务不存在或已被删除～');
                }
                $userGeted['sgkeyUrl'] = U('Index/radar', array('sgkey' => dtd_encrypt($userGeted['public_user_id']))); # 该用户发布的项目
                $userGeted['public_username'] = phone_number_mask($userGeted['public_username']); #处理手机号
                $userGeted['detail_url'] = U('Project/detail', array('pubid' => $userGeted['quest_id'],)); // 任务详细页
                $userGeted['follow'] = UcenterService::isFollow($this->user_id, $userGeted['public_user_id']); #是否关注
                $userGeted['user_id'] = UcenterService::isCollection($this->user_id, $userGeted['quest_id']); #是否收藏             
                $userGeted['userPublishedimg'] = UcenterService::getUserPublishedDetailImg($userGeted['quest_id'], 4); #项目图片
                //获取用户与信息
                $user_info = $this->getUserInfo($this->user_id);
                trace($user_info);
                trace($userGeted);
                $this->assign('user_info', $user_info);
                $this->assign('userGeted', $userGeted);
                $this->display();
            } else {
                $this->redirect('Ucenter/orderTaking');
            }
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 评论项目
     * @author Forest King <86721071@vip.qq.com>
     * @date 2016-04-25 16:52
     * @return json
     */
    function cmtQuest() {
        if (IS_AJAX && $this->user_id) {
            $quest_id = I('quest_id', 0, 'intval'); #项目id
            $content = I('content', '', 'htmlspecialchars'); #评论内容
            if (empty($quest_id) || empty($content)) {
                return false;
            }
            $userInfo = $this->getUserInfo($this->user_id);
            if (empty($userInfo) || !is_array($userInfo)) {
                $result['code'] = '401';
                $result['msg'] = '用户未登录！';
            }
            $flag = UcenterService::insertComment(array('quest_id' => $quest_id, 'user_id' => $this->user_id, 'user_name' => $userInfo['username'], 'content' => strip_tags($content), 'addtime' => time(), 'addip' => ip_address(), 'status' => 1));
            if ($flag) {
                $result['code'] = '200';
                $result['msg'] = '评论成功～';
            } else {
                $result['code'] = '404';
                $result['msg'] = '评论失败！';
            }
        } else {
            $result['code'] = '400';
            $result['msg'] = '非法请求';
        }
        $this->ajaxreturn($result);
    }

    /**
     * 获取评论的列表
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-26 10:20
     * @return json
     */
    public function getCmt() {
        if (IS_AJAX) {
            $quest_id = I('quest_id', 0, 'intval'); #项目id
            if (empty($quest_id)) {
                return false;
            }
            $resultArr = UcenterService::getComment(array('quest_id' => $quest_id, 'status' => 1));
            if ($resultArr) {
                $result['code'] = '200';
                $result['msg'] = '成功～';
                $result['data'] = $resultArr;
            } else {
                $result['code'] = '404';
                $result['msg'] = '失败！';
            }
        } else {
            $result['code'] = '400';
            $result['msg'] = '非法请求';
        }
        $this->ajaxreturn($result);
    }

    /**
     * 发布
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-26 20:20
     */
    public function publishProject() {
        if ($this->user_id) {
            if(FALSE == inspectuser($this->user_info)) {
                $this->error('您的个人信息需要补全。', U('Ucenter/setting'), 3);
            }
            UcenterService::del_temp_img($this->user_id); //删除所有属于自己的临时图片
            //获取个人收货地址
            $userAddressArr = UcenterService::getUserAddress($this->user_id, '', TRUE);

            $quest_id = I('get.pubid', '');
            if ($quest_id) {
                //获取项目详情
                $userPublished = UcenterService::getUserPublishedDetail($quest_id, $this->user_id);
                if (is_array($userPublished) && (1 != $userPublished['quest_status'])) {
                    $this->error('只有状态为“已发布”的项目才能被编辑！', U('Index/index'));
                    //redirect(U('Index/index'), 3, '只有状态为“已发布”的项目才能被编辑！');
                }

                $userPublishedimg = UcenterService::getUserPublishedDetailImg($quest_id, 4); //文章图片
                if (!$userPublishedimg) {
                    $userPublishedimg = '';
                }

                trace($userPublished);
                trace($userPublishedimg);
                $this->assign('userPublishedimg', $userPublishedimg);
                $this->assign('quest_id', $quest_id);
            } else {
                $userPublished['end_time'] = time() + 60 * 60 * 24 * 1; #默认1天后
            }

            trace($userAddressArr);
            $this->assign('userAddressArr', $userAddressArr);
            $this->assign('userPublished', $userPublished);
            $this->display();
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 关于我们
     * @author Forest King <86721071@qq.com>
     * @date 2016-05-30 10:20
     */
    public function aboutUs() {
        $this->display();
    }

    /**
     * 地址管理
     * @author Forest King <86721071@qq.com>
     * @date 2016-06-01 10:20
     */
    public function address() {
        $list = UcenterService::getUserAddress($this->user_id);
        if (!empty($list)) {
            foreach ($list as $key => $value) {
                $list[$key]['editUrl'] = U(CONTROLLER_NAME . '/addr', array('address_id' => $value['address_id']));
                $list[$key]['isDefault'] = $value['isdefault'] ? '是' : '否';
                $list[$key]['addtime'] = date('Y-m-d H:i:s', $value['addtime']);
                $list[$key]['update'] = date('Y-m-d H:i:s', $value['update']);
            }
        }
        trace($list);

        $this->assign('dataList', $list);
        $this->assign('newAddress', U(CONTROLLER_NAME . '/addr'));
        $this->display();
    }

    /**
     * 添加/编辑 用户地址
     * @author Forest King <86721071@qq.com>
     * @date 2016-06-02 13:28
     */
    public function addr() {
        $address_id = I('address_id', '', 'intval');
        if (!empty($address_id)) {
            $dataArr = UcenterService::getUserAddress($this->user_id, $address_id);
            trace($dataArr);
            $this->assign('dataArr', $dataArr[0] ? $dataArr[0] : array());
            $this->assign('address_id', $address_id);
        } else {
            $this->assign('dataArr', NULL);
        }
        $this->display();
    }

    /**
     * 处理用户地址的添加与修改
     * @author Forest King <86721071@qq.com>
     * @date 2016-06-02 17:58
     */
    public function addressCheck() {
        $name = I('name', '', 'trim');
        $telephone = I('telephone', '', 'trim');
        $prov = I('prov', '', 'trim');
        $city = I('city', '', 'trim');
        $distin = I('distin', '', 'trim');
        $address_info = I('address_info', '', 'trim');
        $postcode = I('postcode', '', 'trim');
        $isdefault = I('isdefault', '', 'trim');
        $address_id = I('address_id', '', 'trim');
        $refer = U(CONTROLLER_NAME . '/address');

        if (empty($name)) {
            $result['code'] = 4001;
            $result['msg'] = '收货人不能为空';
        } else if (empty($telephone)) {
            $result['code'] = 4002;
            $result['msg'] = '联系电话不能为空';
        } else if (empty($prov)) {
            $result['code'] = 4003;
            $result['msg'] = '省份不能为空';
        } else if (empty($city)) {
            $result['code'] = 4004;
            $result['msg'] = '市级不能为空';
        } else if (empty($address_info)) {
            $result['code'] = 4005;
            $result['msg'] = '详细地址不能为空';
        } else if (empty($postcode)) {
            $result['code'] = 4006;
            $result['msg'] = '邮政编码不能为空';
        } else if (!in_array($isdefault, array(0, 1))) {
            $result['code'] = 4007;
            $result['msg'] = '是否默认地址不能为空';
        } else if ($address_id) {
            $dataArr = array('address_id' => $address_id, 'user_id' => $this->user_id, 'name' => $name, 'telephone' => $telephone, 'province' => $prov, 'city' => $city, 'distin' => $distin, 'address_info' => $address_info, 'postcode' => $postcode, 'isdefault' => $isdefault);
            $flag = UcenterService::updateUserAddress($dataArr);
            if (1 == $flag) {
                $result['code'] = 200;
                $result['msg'] = '更新成功';
                $result['info'] = $refer;
            } else {
                $result['code'] = 5001;
                $result['msg'] = '更新失败';
            }
        } else {
            $dataArr = array('user_id' => $this->user_id, 'name' => $name, 'telephone' => $telephone, 'province' => $prov, 'city' => $city, 'distin' => $distin, 'address_info' => $address_info, 'postcode' => $postcode, 'isdefault' => $isdefault);
            $flag = UcenterService::addUserAddress($dataArr);
            if ($flag >= 1) {
                $result['code'] = 200;
                $result['msg'] = '添加成功';
                $result['info'] = $refer;
            } else {
                $result['code'] = 5002;
                $result['msg'] = '添加失败';
            }
        }
        echo json_encode($result);
        exit();
    }

    /**
     * 设置默认地址
     * @author Forest King <86721071@qq.com>
     * @date 2016-06-03 10:58
     */
    function setDefaultAddress() {
        if ($this->user_id) {
            $addr_id = I('id'); //地址ID
            $flag = UcenterService::updateUserAddress(array('action' => 'doDeault', 'address_id' => $addr_id, 'user_id' => $this->user_id, 'isdefault' => 1));
            if ($flag == 1) {
                $result['code'] = 200;
                $result['msg'] = '设置成功~';
            } else {
                $result['code'] = 201;
                $result['msg'] = '设置失败~';
            }
        } else {
            $result['code'] = 203;
            $result['msg'] = '请先登录~';
        }

        echo json_encode($result);
        exit();
    }

    /**
     * 账户设置
     * @author Forest King <86721071@qq.com>
     * @date 2016-06-16 11:25
     */
    public function setting() {
        if ($this->user_id) {

            $this->display();
        } else {
            $this->redirect('Index/signin');
        }
    }

    /**
     * 更新用户信息
     * @author Forest King <86721071@qq.com>
     * @date 2016-06-16 13:30
     */
    public function setUserInfo() {
        if (IS_AJAX && $this->user_id) {
            $username = I('post.username', '');
            $email = I('post.email', '');
            $school = I('post.school', '');

            if ($username && $email) {
                //验证处理参数
                if (!isMobile($username)) {
                    $result['code'] = 401;
                    $result['msg'] = '手机号格式错误~';
                } else if (!is_email($email)) {
                    $result['code'] = 402;
                    $result['msg'] = '邮箱格式错误~';
                } else {
                    $flag = IndexService::modifyUserInfo($username, $email, $school);
                    if (TRUE == $flag) {
                        $result['code'] = 200;
                        $result['msg'] = 'OK';
                        session('radar_userinfo_' . $this->user_id, NULL); #清空该用户的缓存信息
                    } else {
                        $result['code'] = '201';
                        $result['msg'] = '修改失败～';
                    }
                }
            } else {
                $result['code'] = 403;
                $result['msg'] = '手机号和邮箱不能为空~';
            }
        } else {
            $result['code'] = 404;
            $result['msg'] = '非法操作';
        }

        $this->ajaxreturn($result);
    }

}
