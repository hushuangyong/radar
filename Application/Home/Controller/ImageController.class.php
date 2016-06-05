<?php

// +----------------------------------------------------------------------
// | OneThink [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2013 http://www.onethink.cn All rights reserved.
// +----------------------------------------------------------------------
// | Author: 麦当苗儿 <zuojiazi@vip.qq.com> <http://www.zjzit.cn>
// +----------------------------------------------------------------------

namespace Home\Controller;

use Org\Util;
use Think\Controller;
use Service\UcenterService;
use Think\Log;
use Think\Model;

/**
 * 后台首页控制器
 * @author 麦当苗儿 <zuojiazi@vip.qq.com>
 */
class ImageController extends Controller {

    private $rootPath = '';
    public $img_ini = array(
        array('width' => '200', 'height' => '300'), //默认缩略图片的配置
        array('width' => '100', 'height' => '100'), //默认缩略图片的配置		
    );
    private $user_id;

    public function _initialize() {
        $c_userid = cookie('radar_userid');
        $s_userid = session('user_id');
        if (!empty($c_userid) && empty($s_userid)) {
            session('user_id', cookie('user_id'));
        }
        $this->user_id = session('user_id');
    }

    /**
     * 上传图片
     */
    public function upload() {
        $arrays['quest_id'] = I('post.quest_id'); //商品ID
        $num = $this->getProImgCount($arrays['quest_id']);
        if (!empty($num) && $num >= 4) {
            echo "已有图片{$num}张，请删除后再上传！";
            exit();
        }
        $this->rootPath = str_replace("Application/Home/Controller", "", str_replace("Application\Home\Controller", "", dirname(__FILE__)));
        if ($arrays['quest_id']) {
            //修改
            $path = '/Public/';
            $image_path = date('Ymd') . '';
        } else if ($this->user_id) {
            //新增
            $path = "/Public/";
            $image_path = $this->user_id;
        }

        $this->rootPath = $this->rootPath . $path;
        $error_log_path = dirname(__FILE__) . '../../../../Runtime/Logs/Product/'; //缩略图片错误日志
        //mkDirs($path);
        $extArr = array("jpeg", "jpg", "png", "gif");

        $array = array();

        if (isset($_POST) and $_SERVER['REQUEST_METHOD'] == "POST") {
            $name = $_FILES['photoimg']['name'];
            $size = $_FILES['photoimg']['size'];

            if (empty($name)) {
                echo '请选择要上传的图片';
                exit;
            }
            $ext = $this->extend($name);
            if (!in_array($ext, $extArr)) {
                echo '图片格式错误！';
                exit;
            }
            if ($size > (1024 * 1024 * 4)) {
                echo '图片大小不能超过4MB';
                exit;
            }

            $image_name = time() . rand(100, 999) . "." . $ext;
            $tmp = $_FILES['photoimg']['tmp_name'];

//				$config = array(
//						'maxSize' => 1024*1024*2,
//						'exts'=>array('jpg', 'gif', 'png', 'jpeg'),
//						'rootPath'=>$image_path, //文件在本地调试时上传的目录，其实也等同于public的domain下的Uploads文件夹
//						'autoSub'=>false
//				);
//				$upload = new \Think\Upload($config,'sae');
//				$info=$upload->uploadOne($_FILES['photoimg']);
//				if(!$info) {// 上传错误提示错误信息
//					$this->error($upload->getError());
//				}else{// 上传成功
//					$this->success(' 上传成功! ');
//				}
//				//test upload
//				exit;

            $flag = false;
            $upload = new \Think\Upload(); // 实例化上传类
            $upload->maxSize = 3145728; // 设置附件上传大小
            $upload->exts = array('jpg', 'gif', 'png', 'jpeg'); // 设置附件上传类型
            $upload->rootPath = './Public/'; // 设置附件上传根目录
            $upload->savePath = 'upload/'; // 设置附件上传（子）目录
            $upload->subName = $image_path;
            // 上传文件 
            $info = $upload->upload();
            if (!$info) {// 上传错误提示错误信息
                $flag = false;
            } else {// 上传成功
                $flag = true;
            }

            if (true == $flag) {
                $ima_name = $info['photoimg']['savepath'] . $info['photoimg']['savename'];
                $array['pic'] = '/' . $ima_name; //图片名称
                $array['addtime'] = time();
                $array['pic_path'] = $this->rootPath . $ima_name;
                $array['quest_id'] = $arrays['quest_id'];
                if ($arrays['quest_id']) {
                    $array['id'] = $this->insertQuestImg($array);
                }
                #echo "<div class='item-photo'><img src='" . ((APP_MODE == 'sae') ? $info['photoimg']['url'] : $path . $array['pic']) . "' class='preview' quest_id='{$array['quest_id']}'><div><span class='del' ids='{$array['id']}'>删除</span></div><div class='photo_order'>排序[大到小]：<input type='tel' name='orders' value='{$array['orders']}' class='product_sort product_{$array['quest_id']}' iid='{$array['id']}'></div></div>";

                if (APP_MODE == 'sae') {
                    $thumbname = str_replace(".gif", "_100x100.gif", str_replace(".png", "_100x100.png", str_replace(".jpg", "_100x100.jpg", $ima_name)));
                    $ima_name2 = str_replace("." . $ext, "_400x300." . $ext, $ima_name);
                    $this->sae_thumb($info['photoimg']['url'], $ima_name2, 400, 300, $ext);
                    $this->sae_thumb($info['photoimg']['url'], $ima_name, 200, 150, $ext); #生成缩略图
                    //$this->saeDeleteImg($ima_name);
                } elseif (APP_MODE == 'common') {
                    $this->create_img($array['pic_path'], $this->img_ini, $error_log_path);
                }
            } else {
                //返回错误信息
                echo '上传出错了！';
            }
            exit;
        }
    }

    /**
     * 获取扩展名
     * @param string $file_name
     * @return string
     */
    public function extend($file_name) {
        $extend = pathinfo($file_name);
        $extend = strtolower($extend["extension"]);
        return $extend;
    }

    //创建缩略图
    public function create_img($source, $array, $paths) {

        $w = strrpos($source, '.');
        $path = substr($source, 0, $w);
        $ext = substr($source, $w);
        if (is_array($array)) {
            $obj = new \Org\Util\PicThumb($logfile);
            foreach ($array as $val) {
                $name = $path . '_' . $val['width'] . 'x' . $val['height'] . $ext; //缩略图名
                mkDirs($paths);
                $logfile = $paths . date('Y_m_d') . '.log';
                // 按比例生成缩略图
                $param = array(
                    'type' => 'fit',
                    'width' => $val['width'],
                    'height' => $val['height'],
                    'quality' => '100'//生成的图片质量
                );


                $obj->set_config($param);
                $flag = $obj->create_thumb($source, $name);
            }
            unlink($source); #删除原图
            rename($path . '_' . $this->img_ini[0]['width'] . 'x' . $this->img_ini[0]['height'] . $ext, $source); #重命名为原图的名称
        }
    }

    /**
     * sae下生成缩略图
     * 此函数3个参数，第一个是源文件的URL,包括文件名，第二个是缩略图要保存的URL，包括文件名，后边是缩略图的宽和长
     */
    public function sae_thumb($field, $thumbname = '', $maxWidth = 200, $maxHeight = 200, $ext = 'jpg') {
        //实例化SAE存储引擎
        $s = new \SaeStorage();
        $domain = "public";

        $info = getimagesize($field);
        $width = $info[0]; //获取图片宽度
        $height = $info[1]; //获取图片高度
        $temp_img = imagecreatetruecolor($maxWidth, $maxHeight); //创建画布
        if ('jpg' == $ext || 'jpeg' == $ext) {
            $im = imagecreatefromjpeg($field);
        } elseif ('png' == $ext) {
            $im = imagecreatefrompng($field);
        } elseif ('gif' == $ext) {
            $im = imagecreatefromgif($field);
        }

        //imagecopyresized($temp_img, $im, 0, 0, 0, 0, $maxWidth, $maxHeight, $width, $height);
        imagecopyresampled($temp_img, $im, 0, 0, 0, 0, $maxWidth, $maxHeight, $width, $height);
        ob_start();
        if ('jpg' == $ext || 'jpeg' == $ext) {
            imagejpeg($temp_img);
        } elseif ('png' == $ext) {
            imagepng($temp_img);
        } elseif ('gif' == $ext) {
            imagegif($temp_img);
        }

        $imgstr = ob_get_contents();
        if (!$thumbname) {
            $toFile = $field;
        } else {
            $toFile = $thumbname;
        }
        $s->write($domain, $toFile, $imgstr);
        ob_end_clean();
        imagedestroy($im);

        // $toFile; //返回缩略图的URL
    }

    /**
     * SAE删除图片
     * @param string $filename
     * @return boolean
     */
    function saeDeleteImg($filename) {
        //实例化SAE存储引擎
        $s = new \SaeStorage();
        $domain = "public";
        $result = $s->delete($domain, $filename);
        return $result;
    }

    /**
     * 获取某个项目的图片数量
     * @param int $quest_id 项目id
     * @return int
     */
    public function getProImgCount($quest_id) {
        if (empty($quest_id)) {
            return FALSE;
        }
        $img = M('quest_img', 'radar_', 'DB_DTD');
        $result = $img->where("`quest_id` = '{$quest_id}' ")->count('id');
        return $result;
    }

    /**
     * 插入图片信息
     * @param array $data
     * @return boolean
     */
    public function insertQuestImg($data) {
        $img = M('quest_img', 'radar_', 'DB_DTD');
        $result = $img->add($data);

        return $result;
    }

    /**
     * 删除图片
     */
    public function imgdel() {

        $img = M('quest_img', 'radar_', 'DB_DTD');
        $array['id'] = I('post.id'); //图片ID	
        $imgname = I('post.img'); //图片ID
        if ($array['id']) {
            $pic_path = $img->where("id={$array['id']}")->field('pic_path')->find();
            if (!empty($pic_path)) {

                $w = strrpos($pic_path['pic_path'], '.');
                $path = substr($pic_path['pic_path'], 0, $w);
                $ext = substr($pic_path['pic_path'], $w);
                @unlink($pic_path['pic_path']); //删除图片
                if (APP_MODE == 'sae') {
                    $picUrl = explode("/", $path);
                    $pic = $picUrl[count($picUrl) - 3] . "/" . $picUrl[count($picUrl) - 2] . '/' . $picUrl[count($picUrl) - 1] . $ext; #图片路径
                    $this->saeDeleteImg('' . $pic); #SAE删除图片
                    $this->saeDeleteImg('' . str_replace(".gif", "_100x100.gif", str_replace(".png", "_100x100.png", str_replace(".jpg", "_100x100.jpg", $pic)))); #SAE删除图片
                }

                foreach ($this->img_ini as $val) {


                    $name = $path . '_' . $val['width'] . 'x' . $val['height'] . $ext; //缩略图名				
                    @unlink($name); //删除缩略图片				
                }

                $data = $img->where("id={$array['id']}")->delete();
                echo $pic_path['pic_path'];
            }
        } else {

            $file = dirname(__FILE__) . '../../../..' . $imgname;
            $w = strrpos($file, '.');
            $path = substr($file, 0, $w);
            $ext = substr($file, $w);
            foreach ($this->img_ini as $val) {


                $name = $path . '_' . $val['width'] . 'x' . $val['height'] . $ext; //缩略图名				
                @unlink($name); //删除缩略图片				
            }
            echo $file;
            unlink($file);
        }
    }

    /**
     * 更新图片的排序值
     * @return boolean
     */
    public function orders() {
        $img = M('quest_img', 'radar_', 'DB_DTD');
        $data['id'] = I('id', 0, 'int');
        $data['orders'] = I('orders', 0, 'int');
        $value = $img->where("`id` = '{$data['id']}'")->save($data);
        return $value;
    }

}
