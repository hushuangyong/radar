<?php
$st =   new SaeStorage();
return array(
	//'配置项'=>'配置值'
	'URL_MODEL'             =>  1,
    'DEFAULT_FILTER'        => 'htmlspecialchars,addslashes',
    'MODULE_DENY_LIST'      =>  array('Common','Runtime','Service'),
    'TMPL_TEMPLATE_SUFFIX'  =>  '.tpl',
    'TMPL_PARSE_STRING' =>array(
            '__UPLOAD__' => 'http://radar-public.stor.sinaapp.com',
    		'__STATIC__' => '/Public',
    		'__STATIC_JS__' => '/Public/Js',
            '__STATIC_CSS__' => '/Public/Css',
            '__STATIC_IMG__' => '/Public/Images',
            //'/Public/upload' => $st->getUrl('public','upload'),
    ),
	//数据库配置信息
	'DB_DTD' => array(
	    'DB_TYPE'   => 'mysql', // 数据库类型
		'DB_HOST'   => SAE_MYSQL_HOST_M, // 服务器地址
		'DB_NAME'   => 'app_radar', // 数据库名
		'DB_USER'   => SAE_MYSQL_USER, // 用户名
		'DB_PWD'    => SAE_MYSQL_PASS, // 密码
		'DB_PORT'   => SAE_MYSQL_PORT, // 端口
		'DB_CHARSET'=> 'utf8' // 字符集
	),
);