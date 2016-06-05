<?php

namespace Home\Controller;

use Think\Controller;
use Service\ProjectService;
use Service\UcenterService;

/**
 * 项目/任务 控制器
 */
class ProjectController extends Controller {

    private $user_id;

    /**
     * 初始化
     */
    public function _initialize() {
        if (!empty(cookie('radar_userid'))) {
            session('user_id', cookie('user_id'));
        }
        $this->user_id = session('user_id');
        $this->assign('user_id', $this->user_id);
#公共导航
        $linkUrl = array('publish' => U('Ucenter' . '/publishProject'), 'myGetted' => U('Ucenter' . '/orderTaking'), 'indexHome' => U('Index/index'));
        trace($linkUrl);
        $this->assign('pageUrl', $linkUrl);
    }

    /**
     * 项目详情
     * @author Forest King <86721071@qq.com>
     * @date 2016-04-25 20:20
     */
    public function detail() {
        $quest_id = I('get.pubid', '', 'intval'); #项目ID
        if ($quest_id) {
            $userGeted = ProjectService::getProjectDetail($quest_id, $this->user_id); //获取项目详情
            if (empty($userGeted) || !is_array($userGeted)) {
                $this->error('该任务不存在或已被删除～', U('Index/index'));
                #redirect(U('Index/index'), 3, '该任务不存在或已被删除～');
            }
            $userGeted['detail_url'] = U('Project/detail', array('pubid' => $userGeted['quest_id'],)); // 任务详细页
            $userGeted['editProject'] = U('Ucenter/publishProject', array('pubid' => $userGeted['quest_id'])); //任务编辑页
            $userGeted['user_id'] = UcenterService::isCollection($this->user_id, $userGeted['quest_id']); #是否收藏             
            $userGeted['userPublishedimg'] = UcenterService::getUserPublishedDetailImg($userGeted['quest_id'], 4); #项目图片

            $user_info = UcenterService::getUserInfoM($this->user_id); //获取用户与信息
            trace($user_info);
            trace($userGeted);
            $this->assign('user_info', $user_info);
            $this->assign('userGeted', $userGeted);
            $this->display();
        } else {
            $this->redirect('Index/index');
        }
    }

    //项目详情
    public function projectDetail() {
        $quest_id = I('get.pubid', '0', 'intval,abs'); // 项目/任务编号
        $user_id = session('user_id');
        if ($quest_id > 0) {
            //获取项目详情
            $projectDetail = ProjectService::getProjectDetail($quest_id, $user_id);

            //获取用户与信息
            $user_info = ProjectService::getPublisherName($projectDetail['public_user_id']);
            //文章图片
            $userPublishedimg = UcenterService::getUserPublishedDetailImg($quest_id);
            if (!$userPublishedimg) {
                $userPublishedimg = '';
            }

            $this->assign('userPublishedimg', $userPublishedimg);
            $this->assign('user_info', $user_info);
            $this->assign('projectDetail', $projectDetail);
            $this->assign('user_id', $user_id);
            $this->display('project_detail');
        } else {
            $this->redirect('Index/radar');
        }
    }

}
