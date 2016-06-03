<?php

namespace Service;

use Think\Model;

class IndexService extends Model {

    /**
     * 从 school 表 获取学校列表
     */
    public static function getSchoolList() {
        $data = M('School', 'radar_', 'DB_DTD');
        $result = $data->field('id,name')->select();
        return $result;
    }

    /**
     * 通过手机号 mobile 从 user 表 获取用户信息 注册查重
     */
    public static function getUserInfo($mobile) {
        if (!isMobile($mobile)) {
            return FALSE;
        }
        $data = M('User', 'radar_', 'DB_DTD');
        $result = $data->field('id,username,password,regtime,last_login,login_ip')->where("`username` = '%s'", array($mobile))->find();
        return $result;
    }

    /**
     * 通过邮箱 email 从 user 表 获取用户信息 注册查重
     * @param string $email
     * @return array
     */
    public static function getUserInfoByEmail($email) {
        if (empty($email) || !is_email($email)) {
            return FALSE;
        }
        $data = M('User', 'radar_', 'DB_DTD');
        $result = $data->field('id,username,email,regtime,last_login,login_ip')->where("`email` = '%s'", array($email))->find();
        return $result;
    }

    /**
     * 根据用户email更新其密码
     * @param string $email 用户的email
     * @param string $newpass 用户重置的密码
     * @param boolean
     * @return array
     */
    function updateUserPassword($email, $newpass) {
        if (empty($email) || empty($newpass)) {
            return FALSE;
        }
        $model = M('user', 'radar_', 'DB_DTD');
        $result = $model->where(" `email` = '%s' ", array($email))->save(array('password' => $newpass));
        return $result;
    }

    /**
     * 更新用户信息
     * @author Forest King <86721071@qq.com>
     * @date 2016-02-01 14:53
     * @param string $username 用户名-手机号
     * @param array $data 要更新的数据
     * @return boolean
     */
    public static function updateUserInfo($username, $data = array()) {
        if (empty($username) || !is_array($data)) {
            return FALSE;
        }
        $model = M('user', 'radar_', 'DB_DTD');
        $result = $model->where(" `username` = '%s' ", array($username))->save($data);
        return $result;
    }

    /**
     * 注册 插入 user && user_ex 表
     */
    public static function regist($mobile, $password, $email, $school) {
        $addData = M('User', 'radar_', 'DB_DTD');
        $addData_ex = M('UserEx', 'radar_', 'DB_DTD');

        //启动事务
        $addData->startTrans();
        $user_info = array('username' => $mobile, 'password' => md5($password), 'email' => $email, 'regtime' => time(), 'last_login' => time(), 'login_ip' => ip_address());
        $user = $addData->add($user_info);
        $user_last_id = $addData->getLastInsID();

        $user_ex_info = array('user_id' => $user_last_id, 'school_id' => $school, 'mobile' => $mobile);
        $user_ex = $addData_ex->add($user_ex_info);
        $user_ex_last_id = $addData_ex->getLastInsID();

        if ($user && $user_ex) {
            $addData->commit();
            return $user_last_id;
        } else {
            $addData->rollback();
            return false;
        }
    }

}
