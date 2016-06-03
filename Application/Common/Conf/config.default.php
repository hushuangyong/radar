<?php
return array(
	//'配置项'=>'配置值'
	'SHOW_PAGE_TRACE'=>1,
	'URL_MODEL'             =>  1,
    'DEFAULT_FILTER'        => 'htmlspecialchars,addslashes',
    'MODULE_DENY_LIST'      =>  array('Common','Runtime','Service'),
    'TMPL_TEMPLATE_SUFFIX'  =>  '.tpl',
    'TMPL_PARSE_STRING' =>array(
            '__UPLOAD__' => '/Public',
    		'__STATIC__' => '/Public',
    		'__STATIC_JS__' => '/Public/Js',
            '__STATIC_CSS__' => '/Public/Css',
            '__STATIC_IMG__' => '/Public/Images',
    ),
    
	//数据库配置信息
	'DB_DTD' => array(
	    'DB_TYPE'   => 'mysql', // 数据库类型
		'DB_HOST'   => '192.168.11.17', // 服务器地址
		'DB_NAME'   => 'radar', // 数据库名
		'DB_USER'   => 'root', // 用户名
		'DB_PWD'    => '1234567a', // 密码
		'DB_PORT'   => 3306, // 端口
		'DB_CHARSET'=> 'utf8' // 字符集
	),
);