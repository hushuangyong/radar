<?php

namespace Service;

use Think\Model;

class UcenterService extends Model {

    //通过 user_id 从 user 表 获取用户信息
    public static function getUserInfoM($user_id) {
        if (empty($user_id) || !is_numeric($user_id)) {
            return FALSE;
        }
        $data = M('User', 'radar_', 'DB_DTD');
        $result = $data->field('p1.`id` ,p1.`username`,p1.`password` , p1.`email` ,p1.`regtime`,p1.`last_login`,p1.`login_ip`, p1.`realname` , p1.`openid` , p1.`nickname` , p1.`sex` ,p1.`headimgurl`  ,p2.`school_id`,p2.`level`,p2.`point`,p2.`vip`,p3.`name` AS `school_name` ')->alias('p1')->join('`radar_user_ex` p2 on p1.`id` = p2.`user_id`', 'LEFT')->join("`radar_school` p3 ON p2.`school_id` = p3.id ", 'LEFT')->where("p1.`id` = '%d'", array($user_id))->find();
        return $result;
    }

    //从 range 表 获取发布范围
    public static function getRange() {
        $data = M('Range', 'radar_', 'DB_DTD');
        $result = $data->field('range_id,range_name')->select();
        return $result;
    }

    //从 class 表 获取发布类别
    public static function getClass() {
        $data = M('Class', 'radar_', 'DB_DTD');
        $result = $data->field('class_id,class_name')->select();
        return $result;
    }

    //通过 user_id 从 address 表 获取个人收货地址
    public static function getUserAddress($user_id, $addressId = NULL, $isDefault = FALSE) {
        $data = M('Address', 'radar_', 'DB_DTD');
        $where = array();
        if (!empty($addressId)) {
            $where['address_id'] = $addressId;
        }
        if ($isDefault) {
            $where['isdefault'] = TRUE;
        }
        $result = $data->field('`address_id`, `user_id`, `name`, `telephone`, `province`, `city`, `distin`, `address_info`, `postcode`, `isdefault`, `addtime`, `update`')->where($where)->where("`user_id` = '%d'", array($user_id))->order('`isdefault` desc,`update` DESC')->select();
        return $result;
    }

    /**
     * 插入用户地址
     * @author Forest King <86721071@qq.com>
     * @param array $paramArr
     * @return boolean
     */
    function addUserAddress($paramArr = array()) {
        $userad = M('Address', 'radar_', 'DB_DTD');
        $paramArr['addtime'] = time();
        $paramArr['update'] = time();
        $result = $userad->add($paramArr);
        return $result;
    }

    /**
     * 更新用户的地址
     * @author Forest King <86721071@qq.com>
     * @param array $paramArr
     * @return int
     */
    function updateUserAddress($paramArr = array()) {
        $userad = M('Address', 'radar_', 'DB_DTD');
        $paramArr['update'] = time();
        if ($paramArr['action'] == 'doDeault') {
            $userad->where("`isdefault` = '1' and `user_id` = '%d' ", array($paramArr['address_id'], $paramArr['user_id']))->save(array('isdefault' => 0)); // 更新该用户所有已默认的为非默认
            $result = $userad->where("`address_id` = %d and `user_id` = '%d' ", array($paramArr['address_id'], $paramArr['user_id']))->save($paramArr); // 根据条件更新记录
        } else {
            $result = $userad->where("`address_id` = %d and `user_id` = '%d' ", array($paramArr['address_id'], $paramArr['user_id']))->save($paramArr); // 根据条件更新记录
        }
        return $result;
    }

    /**
     * 删除用户的地址
     * @author Forest King <86721071@qq.com>
     * @param array $paramArr
     * @return int
     */
    function delUserAddress($paramArr = array()) {
        $userad = M('Address', 'radar_', 'DB_DTD');
        $result = $userad->where('status=0')->delete();
        return $result;
    }

    //发布项目 插入 quest 表 / quest_status = 1 表示发布成功
    public static function publish($user_id, $title, $range, $rclass, $end_time = 0, $province = NULL, $city = null, $distin = null, $userAddress, $content, $award, $checkval, $imagefile = '') {
        $addData = M('Quest', 'radar_', 'DB_DTD');

        $info = array('public_user_id' => $user_id, 'quest_title' => $title, 'quest_range' => $range, 'end_time' => $end_time, 'province' => $province, 'city' => $city, 'distin' => $distin, 'quest_class' => $rclass, 'address_id' => $userAddress, 'quest_intro' => $content, 'quest_reward' => $award, 'quest_reward_type' => $checkval, 'quest_pic' => $imagefile, 'quest_status' => 1, 'public_time' => time());
        $result = $addData->add($info);
        $last_id = $addData->getLastInsID();

        if ($result) {
            self::publish_img($last_id, $user_id);
            return $last_id;
        } else {
            return false;
        }
    }

    //修改项目 更新 quest 表 / quest_status = 1 表示发布成功
    public static function Up_publish($quest_id, $title, $range, $rclass, $end_time = 0, $province = NULL, $city = NULL, $distin = null, $userAddress, $content, $award, $checkval, $imagefile = '') {
        $addData = M('Quest', 'radar_', 'DB_DTD');

        $info = array('quest_title' => $title, 'quest_range' => $range, 'end_time' => $end_time, 'province' => $province, 'city' => $city, 'distin' => $distin, 'quest_class' => $rclass, 'address_id' => $userAddress, 'quest_intro' => $content, 'quest_reward' => $award, 'quest_reward_type' => $checkval, 'quest_pic' => $imagefile, 'quest_status' => 1, 'public_time' => time());
        $result = $addData->where("`quest_id` = '{$quest_id}'")->save($info);

        if ($result) {
            return $quest_id;
        } else {
            return false;
        }
    }

    //发布项目图片 插入 quest_img 表 / quest_status = 1 表示发布成功
    public static function publish_img($quest_id, $user_id) {
        $img = M('quest_img', 'radar_', 'DB_DTD');
        $data['quest_id'] = $quest_id;
        $data['addtime'] = time();

        if (APP_MODE == 'sae') {
            $stor = new \SaeStorage();
            $ret = $stor->getListByPath("public", "upload/{$user_id}", 5);
            $path_new = '/data1/www/htdocs/82/radar/1/Public/upload/' . date('Ymd') . '/';
            foreach ($ret['files'] as $val) {
                $data['pic_path'] = $path_new . $val['Name']; #绝对路径
                $data['pic'] = "/upload/" . date('Ymd') . '/' . $val['Name']; #相对路径
                $retFile = $stor->read('public', $val['fullName']); # 读取旧的文件内容
                $newFile = $stor->write('public', $data['pic'], $retFile); #写入文件内容到新文件
                self::saeDeleteImg($val['fullName']); #删除旧的文件
                if (!strrpos($data['pic_path'], '_')) {
                    $result = $img->add($data);
                }
            }
        } else {
            $path = dirname(__FILE__) . "../../../Public/upload/{$user_id}/";
            $path_new = dirname(__FILE__) . "../../../Public/upload/" . date('Ymd') . '/';
            $path_new = str_replace("Application\Service../../../", "", $path_new);
            mkDirs($path_new);
            $file = scandir($path);
            unset($file[0]); //删除.
            unset($file[1]); //删除..		
            foreach ($file as $val) {
                $data['pic_path'] = $path_new . $val;
                $data['pic'] = "/upload/" . date('Ymd') . '/' . $val;
                $newfile = $path_new . $val;
                copy($path . $val, $newfile);
                unlink($path . $val);
                if (!strrpos($data['pic_path'], '_')) {
                    $result = $img->add($data);
                }
            }
        }
    }

    //删除所以有属于自己的临时图片
    public static function del_temp_img($user_id) {
        if (APP_MODE == 'sae') {
            $stor = new \SaeStorage();
            $ret = $stor->getListByPath("public", "upload/{$user_id}", 50);
            foreach ($ret['files'] as $val) {
                self::saeDeleteImg($val['fullName']); #删除旧的文件
            }
        }

        $path = realpath(__ROOT__) . "/Public/upload/{$user_id}/";
        trace($path, '用户临时图片的目录');
        if (!file_exists($path)) {
            trace('目录"' . $path . '"不存在！');
            return FALSE;
        }

        $file = scandir($path);
        unset($file[0]); //删除.
        unset($file[1]); //删除..		

        foreach ($file as $val) {

            unlink($path . $val);
        }
    }

    //通过 user_id 从 quest 表 获取个人已发布项目
    public static function getUserPublished($user_id) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $result = $data->field('quest_id,public_user_id,quest_title,quest_range,quest_class,address_id,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time')->where("`public_user_id` = '%d'", array($user_id))->select();
        return $result;
    }

    //通过 quest_id user_id 从 quest 表 获取某个已发布项目详情
    public static function getUserPublishedDetail($quest_id, $user_id) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $result = $data->field('quest_id,public_user_id,quest_title,quest_range , `end_time` ,quest_class,address_id,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time , `address_id`  ')->where("`public_user_id` = '%d' and `quest_id` = '%d'", array($user_id, $quest_id))->find();
        if (!empty($result) && is_array($result)) {
            $result['end_time'] = ($result['end_time'] > time()) ? $result['end_time'] : time(); #截止时间
            $result['dateline'] = ($result['end_time'] > time()) ? ($result['end_time'] - time()) : '0'; #剩余时间
        }
        return $result;
    }

    //通过 quest_id 从 quest 表 获取某个已发布项目详情
    public static function getUserPublishedDetailFind($quest_id) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $result = $data->field('public_user_id')->where("`quest_id` = '%d'", array($quest_id))->find();
        return $result;
    }

    //通过 quest_id  从 quest_img 表 获取某个已发布项目的图片详情
    public static function getUserPublishedDetailImg($quest_id, $limit = 3) {
        $img = M('quest_img', 'radar_', 'DB_DTD');
        $result = $img->where("`quest_id` = '{$quest_id}'")->order('orders asc')->limit($limit)->select();
        foreach ($result as $key => $value) {
            if (APP_MODE == 'sae') {
                $result[$key]['pic_origin'] = str_replace(".gif", "_400x300.gif", str_replace(".png", "_400x300.png", str_replace(".jpg", "_400x300.jpg", str_replace(".jpeg", "_400x300.jpeg", $value['pic'])))); #原图
                $result[$key]['pic_domain'] = 'http://radar-public.stor.sinaapp.com/'; //线上的新浪SAE
                $result[$key]['nonepic'] = $result[$key]['pic_domain'] . '/none_pic/no_photo.jpg'; #没图片的占位符
            } elseif (APP_MODE == 'common') {
                $result[$key]['pic'] = str_replace(".gif", "_300x390.gif", str_replace(".png", "_300x390.png", str_replace(".jpg", "_300x390.jpg", str_replace(".jpeg", "_300x390.jpeg", $value['pic'])))); #缩略图
                $result[$key]['pic_origin'] = $value['pic']; #原图
                $result[$key]['pic_domain'] = '/Public/'; //本地开发
                $result[$key]['nonepic'] = $result[$key]['pic_domain'] . '/Images/Radar/Main/no_photo.jpg'; #没图片的占位符
            }
        }
        return $result;
    }

    //通过 user_id 从 quest 表 获取个人已抢单项目
    public static function getUserGeted($user_id, $status, $sgkey = NULL) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $where = array();
        if (!empty($sgkey)) {
            $where['public_user_id'] = dtd_decrypt($sgkey); #我的已发布
        } else {
            $where['order_user_id'] = $user_id; #我的接单
        }
        if (!empty($status) && $status > 0) {
            $where['quest_status'] = $status;
        }
        $result = $data->field(' `quest_id`, `quest_title`, `quest_range`, `end_time`, `quest_class`, `address_id`, `quest_reward`, `quest_reward_type`, `quest_intro`, `quest_pic`, `quest_status`, `public_time`, `public_user_id`, `order_time`, `order_user_id`, user.`username` AS public_username , user.`headimgurl`')->alias('p1')->join('left join `radar_user` user on p1.`public_user_id` = user.`id` ')->where($where)->select();
        return $result;
    }

    /**
     * 通过 quest_id user_id 从 quest 表 获取某个已抢单项目详情
     * @param int $quest_id 项目id
     * @param int $user_id 当前登录的用户id
     */
    public static function getUserGetedDetail($quest_id, $user_id) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $result = $data->field('quest_id,public_user_id,quest_title,quest_range,`end_time` ,quest_class,p3.`address_info` AS quest_address,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time, p3.`name` AS `receive_name` ,p3.`telephone` ,p3.`province`, p3.`city`, p3.`distin` , users.`username` AS public_username , users.`headimgurl` ')->alias('p1')->join('left join `radar_user` users on p1.`public_user_id` = users.`id` ')->join('left join `radar_address` p3 on p1.`address_id` = p3.`address_id` ')->where("`order_user_id` = '%d' and `quest_id` = '%d'", array($user_id, $quest_id))->find();

        if (!empty($result) && is_array($result)) {
            $result['dateline'] = ($result['end_time'] > time()) ? $result['end_time'] - time() : '0'; #剩余时间
            $result['quest_address'] = $result['province'] . '&nbsp;' . $result['city'] . '&nbsp;' . $result['distin'] . $result['quest_address']; #省区市-地址
            if (empty($result['headimgurl'])) {
                $result['headimg'] = "/Public/assets/img/temp/img-user.jpg"; #发布人的头像
            } else {
                $result['headimg'] = trim($result['headimgurl']); #发布人的头像
            }
        }
        return $result;
    }

    //通过 quest_id user_id 更新 quest 表
    public static function orderQuest($quest_id, $user_id) {
        $data = M('Quest', 'radar_', 'DB_DTD');

        //启动事务
        $data->startTrans();
        #根据项目id获取信息
        $getpro = $data->field('end_time,order_user_id,quest_status,public_user_id,`version`')->where("`quest_status` = '1' AND `quest_id` = '%d'", array($quest_id))->find();
        if (($getpro['end_time'] >= 0) && (time() > intval($getpro['end_time']))) {
            return 4; //已过截止时间
        }
        if ($getpro['public_user_id'] != $user_id) {
            if (($getpro['order_user_id'] == '' || $getpro['order_user_id'] == 0) && $getpro['quest_status'] == 1) {
                $status = 1;
                $info = array('order_user_id' => $user_id, 'order_time' => time(), 'quest_status' => 2, 'version' => $getpro['version'] + 1);
                $savepro = $data->where("`quest_id` = '%d' AND version = '%d'  ", array($quest_id, $getpro['version']))->save($info);
            } else {
                $status = 0;
            }
        } else {
            //下单ID和发布ID不能相同
            return 2;
        }


        if ($status > 0 && $getpro && $savepro) {
            $data->commit();
            return 1; //抢单成功
        } else {
            $data->rollback();
            return 3;
        }
    }

    /**
     * 通过任务ID和用户ID来收藏任务
     * @param int $quest_id 任务id
     * @param int $user_id 用户id
     * @return boolean|int
     */
    public function setCollection($quest_id, $user_id) {
        if (empty($quest_id) || empty($user_id)) {
            return FALSE;
        }

        $collection = M('collection', 'radar_', 'DB_DTD');
        $rel = $collection->where("`quest_id` = '{$quest_id}' and `user_id` = '{$user_id}'")->find();
        if ($rel) {
            return 1; //已经收藏
        } else {
            $Quest = M('Quest', 'radar_', 'DB_DTD');
            $result = $Quest->field('public_user_id')->where("`quest_id` = '{$quest_id}'")->find();
            if ($result['public_user_id'] == $user_id) {
                return 4; //不能收藏自己的			
                die;
            }

            $data['quest_id'] = $quest_id;
            $data['user_id'] = $user_id;
            $data['addtime'] = time();
            $res = $collection->add($data);
            if ($res) {
                return 2; //收藏成功
            } else {
                return 3; //收藏失败		
            }
        }
    }

    /**
     * 关注用户
     * @param int $user_id 当前用户id
     * @param int $public_user_id 对方用户id
     * @return int
     */
    public function setFollow($user_id, $public_user_id) {
        if ($user_id == $public_user_id) {
            return 4; //不能关注自己	
            die;
        } else {
            $result = self::isFollow($user_id, $public_user_id);
            if ($result) {
                return 1; //已经关注	
                die;
            }

            $data['m_user_id'] = $user_id;
            $data['h_user_id'] = $public_user_id;
            $data['addtime'] = time();
            $follow = M('follow', 'radar_', 'DB_DTD');
            $res = $follow->add($data);
            if ($res) {
                return 2; //关注成功
            } else {
                return 3; //关注失败		
            }
        }
    }

    /**
     * 删除关注
     * @date 2015/12/29 11:41
     * @param array $paramArr 参数数组
     * @return boolean
     */
    public static function cancelAttention($paramArr = array()) {
        $follow = M('follow', 'radar_', 'DB_DTD');
        $result = $follow->where("`id` = '{$paramArr['follow_id']}' and `m_user_id` = '{$paramArr['m_user_id']}'")->delete();
        if ($result) {
            return TRUE;
        } else {
            return FALSE;
        }
    }

    /**
     * 获取是否收藏过某个项目
     * @param init $user_id 当前登录的用户id
     * @param int $quest_id 项目id
     * @return mixed
     */
    public static function isCollection($user_id, $quest_id) {
        if (empty($user_id) || empty($quest_id)) {
            return FALSE;
        }
        $model = M('collection', 'radar_', 'DB_DTD');
        $outArr = $model->where("`user_id` = '{$user_id}' and `quest_id` = '{$quest_id}' ")->find();
        return $outArr['user_id'];
    }

    /**
     * 通过 user_id 获取个人的收藏
     * @param string $user_id 用户id
     */
    public static function getCollection($user_id) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $result = $data->field('p1.`quest_id`, p1.`quest_title`, p1.`quest_range`, p1.`end_time`, p1.`quest_class`, p1.`address_id`, p1.`quest_reward`, p1.`quest_reward_type`, p1.`quest_intro`, p1.`quest_pic`, p1.`quest_status`, p1.`public_time`, p1.`public_user_id`, p1.`order_time`, p1.`order_user_id` ,p2.quest_id, user.`username` AS public_username , user.`headimgurl` ')->alias('p1')->join("inner join `radar_collection` as p2 on p2.`quest_id` = p1.`quest_id`")->join('left join `radar_user` user on p1.`public_user_id` = user.`id` ')->where("p2.`user_id` = '{$user_id}' ")->select();
        if (is_array($result)) {
            foreach ($result as $key => $value) {
                if (1 == $value['quest_reward_type']) {
                    $result[$key]['quest_reward'] = '￥' . $value['quest_reward']; #价格
                } else if (2 == $value['quest_reward_type']) {
                    $result[$key]['quest_reward'] = $value['quest_reward']; #其他奖励
                }
                $result[$key]['projectDetail'] = U('Project/detail', array('pubid' => $value['quest_id'],)); // 任务详细页
                $result[$key]['sgkeyUrl'] = U('Index/radar', array('sgkey' => dtd_encrypt($value['public_user_id']))); # 该用户发布的项目
                $result[$key]['public_username'] = phone_number_mask($value['public_username']); #处理手机号
                $result[$key]['status_name'] = get_quest_status($value['quest_status']); #获取状态的对应名
                $result[$key]['className'] = get_quest_status($value['quest_status'], 'styleName'); #获取状态的对应style名称
                $result[$key]['follow'] = UcenterService::isFollow($user_id, $value['public_user_id']); #是否关注
                $result[$key]['user_id'] = UcenterService::isCollection($user_id, $value['quest_id']); #是否收藏
                $result[$key]['dateline'] = ($value['end_time'] > time()) ? ( $value['end_time'] - time()) : 0; #剩余时间
                $result[$key]['userPublishedimg'] = UcenterService::getUserPublishedDetailImg($value['quest_id'], 4); #项目图片
                if (empty($value['headimgurl'])) {
                    $result[$key]['headimg'] = "/Public/assets/img/temp/img-user.jpg"; #发布人的头像
                } else {
                    $result[$key]['headimg'] = trim($value['headimgurl']); #发布人的头像
                }
            }
        }
        return $result;
    }

    /**
     * 删除收藏
     * @date 2015/12/29 10:15
     * @param array $paramArr
     * @return boolean
     */
    public static function deleteCollection($paramArr = array()) {
        $collection = M('collection', 'radar_', 'DB_DTD');
        $result = $collection->where("`quest_id` = '{$paramArr['quest_id']}' and `user_id` = '{$paramArr['user_id']}'")->delete();
        if ($result) {
            return TRUE;
        } else {
            return FALSE;
        }
    }

    //通过 user_id 获取个人的关注列表	
    public static function getFollow($user_id) {
        $data = M('follow', 'radar_', 'DB_DTD');
        $result = $data->field('p1.`id`,p2.username,p2.`realname`, p2.`nickname` ,p2.id AS `user_id` , p2.`headimgurl` ')->alias('p1')->join("inner join `radar_user` as p2 on p2.`id` = p1.`h_user_id`")->where("p1.`m_user_id` = '{$user_id}' ")->select();
        if (is_array($result)) {
            foreach ($result as $key => $value) {
                $result[$key]['username'] = phone_number_mask($value['username']); #处理手机号
                if (empty($value['headimgurl'])) {
                    $result[$key]['headimg'] = "/Public/assets/img/temp/img-user.jpg"; #发布人的头像
                } else {
                    $result[$key]['headimg'] = trim($value['headimgurl']); #发布人的头像
                }
            }
        }
        return $result;
    }

    /**
     * 获取是否关注对方
     * @param init $user_id 当前登录的用户id
     * @param int $public_user_id 对方用户id
     * @return mixed
     */
    public static function isFollow($user_id, $public_user_id) {
        $outArr = array();
        if (empty($user_id) || empty($public_user_id)) {
            return $outArr;
        }
        $follow = M('follow', 'radar_', 'DB_DTD');
        $outArr = $follow->where("`m_user_id` = '{$user_id}' and `h_user_id` = '{$public_user_id}' ")->find();
        return $outArr;
    }

    /**
     * SAE 删除图片
     * @param string $filename
     * @return boolean
     */
    static function saeDeleteImg($filename) {
        //实例化SAE存储引擎
        $s = new \SaeStorage();
        $domain = "public";
        $result = $s->delete($domain, $filename);
        return $result;
    }

    /**
     * 插入用户评论
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-26 10:20
     * @param array$paramArr 评论的数据
     * @return boolean|int
     */
    public static function insertComment($paramArr = array()) {
        $model = M('comment', 'radar_', 'DB_DTD');
        if (empty($paramArr)) {
            return FALSE;
        }
        $result = $model->add($paramArr);
        $last_id = $model->getLastInsID();

        if ($result) {
            return $last_id;
        } else {
            return false;
        }
    }

    /**
     * 获取用户评论
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-26 18:20
     * @return array
     */
    public static function getComment($paramArr = array()) {
        $data = M('comment', 'radar_', 'DB_DTD');
        $map['quest_id'] = $paramArr['quest_id'];
        $result = $data->field('cmt.* , user.`nickname`, user.`headimgurl`')->alias('cmt')->join('left join `radar_user` user on cmt.`user_id` = user.`id` ')->where($map)->order('id desc,status')->select();
        if (is_array($result)) {
            foreach ($result as $key => $value) {
                $result[$key]['sgkeyUrl'] = U('Index/radar', array('sgkey' => dtd_encrypt($value['user_id']))); # 该用户发布的项目
                $result[$key]['user_name'] = phone_number_mask($value['user_name']); #处理手机号
                if (empty($value['headimgurl'])) {
                    $result[$key]['headimg'] = "/Public/assets/img/temp/img-user.jpg"; #发布人的头像
                } else {
                    $result[$key]['headimg'] = trim($value['headimgurl']); #发布人的头像
                }
            }
        }

        return $result;
    }

}
