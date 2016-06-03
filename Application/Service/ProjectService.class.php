<?php

namespace Service;

use Think\Model;
use Service\UcenterService;

class ProjectService extends Model {

    //从 quest 表 获取所有已发布项目 / 通过 class_id 获取某个类型的所有项目
    public static function getProject($class_id = 0, $sgkey = null, $offset = 0, $length = 10) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $whereStr = " p1.`end_time` > '" . time() . "'  ";
        if ($class_id > 0) {
            $result = $data->alias('p1')
                    ->field('p1.`quest_id`,public_user_id,quest_title,quest_range,`end_time`,quest_class,address_id,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time,p3.`user_id`,school.`id` AS s_id,school.`name` AS s_name,user.`username` AS public_username')
                    //->join('left join radar_quest_img p2 on p1.quest_id=p2.quest_id')
                    ->join('left join `radar_school` school on p1.`quest_range` = school.`id` ')
                    ->join('left join `radar_user` user on p1.`public_user_id` = user.`id` ')
                    ->join("left join `radar_collection` p3 on (p1.`quest_id` = p3.`quest_id` AND p3.`user_id` = '" . session('user_id') . "')")
                    ->where("{$whereStr} AND `quest_class` = '%d'", array($class_id))
                    ->order('`public_time` DESC, `quest_status` ASC')->limit($offset, $length)->select();
        } else {
            if ($sgkey) {
                $user_id = dtd_decrypt($sgkey); //解密用户ID
                $where = " WHERE {$whereStr} AND p1.`public_user_id` = '{$user_id}' ";
            } else {
                $where = ' WHERE' . $whereStr . '';
            }
            $result = $data->alias('p1')
                    ->field('p1.`quest_id`,public_user_id,quest_title,quest_range,`end_time`,quest_class,address_id,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time,p3.`user_id`,school.`id` AS s_id,school.`name` AS s_name,user.`username` AS public_username')
                    //->join('left join `radar_quest_img` p2 on p1.`quest_id` = p2.`quest_id` ')
                    ->join('left join `radar_school` school on p1.`quest_range` = school.`id` ')
                    ->join('left join `radar_user` user on p1.`public_user_id` = user.`id` ')
                    ->join("left join `radar_collection` p3 on p1.`quest_id` = p3.`quest_id` AND p3.`user_id` = '" . session('user_id') . "' {$where}")
                    ->order('`public_time` DESC, `quest_status` ASC')->limit($offset, $length)->select();
        }

        $array = array();
        //筛选数据
        for ($i = 0; $i <= count($result) - 1; $i++) {
            $array[$result[$i]['quest_id']][] = $result[$i];
            if (time() > $result[$i]['end_time']) {
                $array[$result[$i]['quest_id']][0]['quest_status'] = 5; #过期的项目状态显示为已关闭
            }
            if (1 == $result[$i]['quest_reward_type']) {
                $array[$result[$i]['quest_id']][0]['quest_reward'] = '￥' . $result[$i]['quest_reward']; #价格
            } else if (2 == $result[$i]['quest_reward_type']) {
                $array[$result[$i]['quest_id']][0]['quest_reward'] = $result[$i]['quest_reward']; #其他奖励
            }
            $array[$result[$i]['quest_id']][0]['quest_intro'] = cn_substr($result[$i]['quest_intro'], 0, 20); #项目介绍
            $array[$result[$i]['quest_id']][0]['public_username'] = phone_number_mask($result[$i]['public_username']); #发布人的用户名
            $array[$result[$i]['quest_id']][0]['projectDetail'] = U('Project/detail', array('pubid' => $result[$i]['quest_id'])); #项目详细页
            $array[$result[$i]['quest_id']][0]['follow'] = UcenterService::isFollow(session('user_id'), $result[$i]['public_user_id']); #是否关注
            $array[$result[$i]['quest_id']][0]['dateline'] = ($result[$i]['end_time'] > time()) ? ( $result[$i]['end_time'] - time()) : 0; #剩余时间
            $array[$result[$i]['quest_id']][0]['userPublishedimg'] = UcenterService::getUserPublishedDetailImg($result[$i]['quest_id'], 4); #项目图片
            $array[$result[$i]['quest_id']][0]['sgkeyUrl'] = U('Index/radar', array('sgkey' => dtd_encrypt($result[$i]['public_user_id']))); # 该用户发布的项目
            $array[$result[$i]['quest_id']][0]['status_name'] = get_quest_status($result[$i]['quest_status']); #项目状态名
        }

        //$array = array_unique($array);

        return $array;
    }

    //通过 quest_id 从 quest 表 获取某个已发布项目详情
    public static function getProjectDetail($quest_id, $user_id = null) {
        if ($quest_id < 0) {
            return FALSE;
        }
        $data = M('Quest', 'radar_', 'DB_DTD');
        if ($user_id) {
            //单个项目详情
            $result = $data->alias('p1')
                ->field('p1.quest_id,public_user_id,quest_title,quest_range,`end_time`,quest_class,p3.`address_info` AS quest_address,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time,p3.`province`,p3.`city`,p3.`distin`,p2.user_id ,user.`username` AS public_username')
                ->join('left join radar_collection as p2 on p2.quest_id=p1.quest_id')->join('left join `radar_user` user on p1.`public_user_id` = user.`id` ')->join('left join `radar_address` p3 on p1.`address_id` = p3.`address_id` ')
                ->where("p1.`quest_id` = '%d'", array($quest_id))
                ->find();
        } else {
            $result = $data->field('quest_id,public_user_id,quest_title,quest_range,`end_time`,quest_class,p3.`address_info` AS quest_address,quest_intro,quest_reward,quest_reward_type,quest_pic,quest_status,public_time,order_user_id,order_time ,p3.`province` ,p3.`city` ,p3.`distin` ,user.`username` AS public_username')->alias('p1')->join('left join `radar_user` user on p1.`public_user_id` = user.`id` ')->join('left join `radar_address` p3 on p1.`address_id` = p3.`address_id` ')->where("`quest_id` = '%d'", array($quest_id))->find();
        }

        if (!empty($result) && is_array($result)) {
            if (time() > $result['end_time'] && 1 == $result['quest_status']) {
                $result['quest_status'] = 5; #过期的项目状态显示为已关闭
            }
            if (1 == $result['quest_reward_type']) {
                $result['quest_reward'] = '￥' . $result['quest_reward']; #价格
            } else if (2 == $result['quest_reward_type']) {
                $result['quest_reward'] = $result['quest_reward']; #其他奖励
            }
            $result['public_username'] = phone_number_mask($result['public_username']); #掩码手机号
            $result['follow'] = UcenterService::isFollow(session('user_id'), $result['public_user_id']); #关注信息
            $result['dateline'] = ($result['end_time'] > time()) ? ( $result['end_time'] - time()) : 0; #剩余时间
            $result['quest_address'] = $result['province'] . $result['city'] . $result['distin'] . $result['quest_address']; #省区市-地址
        }
        return $result;
    }

    //通过 user_id 从 user 表 获取发布人的昵称（不获取敏感信息）
    public static function getPublisherName($user_id) {
        if (!is_integer($user_id) || empty($user_id)) {
            return FALSE;
        }
        $data = M('User', 'radar_', 'DB_DTD');
        $result = $data->field('p1.`id`,p1.`username`')->alias('p1')->where("p1.`id` = '%d'", array($user_id))->find();
        return $result;
    }

    /**
     * 根据发布用户id和项目id更新项目状态
     * @param int $user_id 发布的用户id
     * @param int $quest_id 任务id
     * @param int $quest_status 状态标记码
     * @return boolean
     */
    function updateQuestStutus($user_id, $quest_id, $quest_status = 5) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $savepro = $data
            ->where("`public_user_id` ='%d' AND `quest_id` = '%d'", array($user_id, $quest_id))
            ->save(array('quest_status' => $quest_status));
        return $savepro;
    }

    /**
     * 根据接单用户id和项目id更新项目状态
     * @author Forest King <86721071@vip.qq.com>
     * @date 2016-01-17 13:48
     * @param int $user_id 接单的用户id
     * @param int $quest_id 任务id
     * @param int $status 状态标记码
     * @param boolean
     */
    function updateOrderQuestStutus($user_id, $quest_id, $status = 5) {
        $data = M('Quest', 'radar_', 'DB_DTD');
        $savepro = $data->where("`order_user_id` ='%d' AND `quest_id` = '%d'", array($user_id, $quest_id))->save(array('quest_status' => $status));
        return $savepro;
    }

}
