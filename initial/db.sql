SET NAMES utf8;
-- SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 限制IP登录
DROP TABLE IF EXISTS `ph_ip_limit_log`;
CREATE TABLE `ph_ip_limit_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `game_id`     bigint(20)   NOT NULL COMMENT '活动ID',
  `ip`     VARCHAR(255) NOT NULL COMMENT 'IP',
  `account`     VARCHAR(255) NOT NULL COMMENT '会员账号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 月签到打码记录
DROP TABLE IF EXISTS `ph_monthsignin_bet`;
CREATE TABLE `ph_monthsignin_bet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime     NOT NULL COMMENT '修改日期',
  `creator`     bigint(20)   NOT NULL COMMENT '创建人id',
  `modifior`    bigint(20)   NOT NULL COMMENT '修改人id',
  `version`     bigint(20)   NOT NULL COMMENT '版本号',
  `game_id`     bigint(20)   NOT NULL COMMENT '活动ID',
  `account`     VARCHAR(255) NOT NULL COMMENT '会员账号',
  `bet`         bigint(20)   NOT NULL COMMENT '打码量',
  `surplus_bet` bigint(20)   NOT NULL COMMENT '补签用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 月签到记录
DROP TABLE IF EXISTS `ph_monthsignin_log`;
CREATE TABLE `ph_monthsignin_log` (
  `id`          bigint(20)   NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `game_id`     bigint(20)   NOT NULL COMMENT '活动ID',
  `account`     VARCHAR(255) NOT NULL COMMENT '会员账号',
  `signin_date` datetime     NOT NULL COMMENT '创建日期',
  `gift_Id`     bigint(20) COMMENT '奖励总天数',
  `status`     bigint(20) COMMENT '签到状态0:正常1:补签',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_signin_date` (`signin_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- VIP价值查询
DROP TABLE IF EXISTS `ph_vip_value`;
CREATE TABLE `ph_vip_value` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `vip_level` bigint(20) NOT NULL COMMENT 'VIP等级',
  `register_date` datetime NOT NULL COMMENT '注册日期',
  `register_days` bigint(20) NOT NULL COMMENT '注册天数',
  `value` bigint(20) NOT NULL COMMENT '价值',
  `get_enable` bigint(20) NOT NULL COMMENT '是否领取（0:未领取，1:已领取）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_vipvalue_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 评论
DROP TABLE IF EXISTS `ph_comment`;
CREATE TABLE `ph_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `mobile` VARCHAR(255) DEFAULT NULL COMMENT '手机',
  `content` VARCHAR(1024) DEFAULT NULL COMMENT '评论内容',
  `thumbs` INT DEFAULT 0 COMMENT '赞次数',
  `tag` INT DEFAULT 0 COMMENT '标签(0:默认，1:普通；2：优秀；3：精华；9：置顶)',
  `status` INT DEFAULT 0 COMMENT '审核状态(0:待审核;1:审核通过;2:审核拒绝)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 秒杀和抢购关联
DROP TABLE IF EXISTS `ph_seckill_and_rush`;
CREATE TABLE `ph_seckill_and_rush` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `seckill_id` bigint(20) NOT NULL  COMMENT '秒杀id',
  `rush_id` bigint(20) NOT NULL  COMMENT '抢购id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 宝箱关联
DROP TABLE IF EXISTS `ph_box`;
CREATE TABLE `ph_box` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `game_id` bigint(20) NOT NULL  COMMENT '活动id',
  `bronzebox_id` bigint(20) NOT NULL  COMMENT '青铜宝箱id',
  `silverbox_id` bigint(20) NOT NULL  COMMENT '白银宝箱id',
  `goldbox_id` bigint(20) NOT NULL  COMMENT '黄金宝箱id',
  `extremebox_id` bigint(20) NOT NULL  COMMENT '至尊宝箱id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 签到-等级设置
DROP TABLE IF EXISTS `ph_signin_level`;
CREATE TABLE `ph_signin_level` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `name` VARCHAR(255) NOT NULL COMMENT '等级名称',
  `level` INT NOT NULL DEFAULT 0 COMMENT '等级',
  `min_force` INT NOT NULL DEFAULT 0 COMMENT '最小原力',
  `max_force` INT NOT NULL DEFAULT 0 COMMENT '最大原力',
  `min_amount` INT NOT NULL DEFAULT 0 COMMENT '最小金额',
  `max_amount` INT NOT NULL DEFAULT 0 COMMENT '最大金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 投票活动-投票详情
DROP TABLE IF EXISTS `ph_vote_detail`;
CREATE TABLE `ph_vote_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号或手机号',
  `ip` VARCHAR(255) NOT NULL COMMENT '投票ip',
  `vote_item_id` bigint(20) NOT NULL COMMENT '选票ID',
  `vote_item_name` VARCHAR(255) DEFAULT NULL COMMENT '选票名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 投票活动-选票
DROP TABLE IF EXISTS `ph_vote_item`;
CREATE TABLE `ph_vote_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `name` VARCHAR(255) NOT NULL COMMENT '选票名称',
  `seq` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `num_vote` INT NOT NULL DEFAULT 0 COMMENT '真实票数',
  `num_adjust` INT NOT NULL DEFAULT 0 COMMENT '调整票数',
  `flag` INT DEFAULT 0 COMMENT '中奖标记(0:非中奖项；1:中奖项)',
  `img` VARCHAR (255)  DEFAULT NULL COMMENT '选票图片',
  `detail` VARCHAR (255) DEFAULT NULL  COMMENT '选票详情',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 电子金管家总信息
DROP TABLE IF EXISTS `ph_upgrading`;
CREATE TABLE `ph_upgrading` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `total_amount` INT NOT NULL COMMENT '总投注额度',
  `level` INT NOT NULL COMMENT '当前等级',
  `current_gift` INT NOT NULL COMMENT '最新一期晋级彩金',
  `total_gift` INT NOT NULL COMMENT '所有晋级彩金',
  `week_salary` INT NOT NULL COMMENT '周俸禄',
  `month_salary` INT NOT NULL COMMENT '月俸禄',
  `balance` INT NOT NULL COMMENT '晋级下一级需要投注的金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- 电子金管家周信息
DROP TABLE IF EXISTS `ph_upgrading_week`;
CREATE TABLE `ph_upgrading_week` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `week_amount` INT NOT NULL COMMENT '当周投注金额',
  `rise_amount` INT  COMMENT '当周投注金额',
  `period` INT NOT NULL COMMENT '投注周期',
  `period_string` varchar(255)  COMMENT '投注周期',
  `count_enable` tinyint(4) DEFAULT 0 COMMENT '是否已计算',
  `delivered` tinyint(4) DEFAULT 0 COMMENT '是否派送',
  `delivered_time` datetime DEFAULT NULL COMMENT '派送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- 电子金管家配置信息
DROP TABLE IF EXISTS `ph_upgrading_config`;
CREATE TABLE `ph_upgrading_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `level` INT NOT NULL COMMENT '晋升标准等级',
  `total_amount` INT NOT NULL COMMENT '累计打码',
  `level_gift` INT NOT NULL COMMENT '等级礼金',
  `week_amount` INT NOT NULL COMMENT '周俸禄',
  `month_amount` INT NOT NULL COMMENT '月俸禄',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;


-- 排行榜
DROP TABLE IF EXISTS `ph_ranking`;
CREATE TABLE `ph_ranking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `ranking_flag` int(11) NOT NULL DEFAULT '0' COMMENT '标识(0:普通;1:虚拟)',
  `ranking_type` int(11) NOT NULL COMMENT '类型(0:周排行;1:月排行;2:幸运榜;3:总排行;)',
  `account` varchar(255) NOT NULL COMMENT '会员账号',
  `amount` int(11) NOT NULL COMMENT '有效投注',
  `seq` int(11) NOT NULL COMMENT '排名',
  `period` int(11) NOT NULL COMMENT '期数;月份',
  `period_string` varchar(225) NOT NULL COMMENT '字符串显示期数',
  `prize` varchar(225) NOT NULL COMMENT '奖品',
  `delivered` tinyint(4) DEFAULT '0' COMMENT '是否派送',
  `delivered_time` datetime DEFAULT NULL COMMENT '派送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- 排行榜配置
DROP TABLE IF EXISTS `ph_ranking_config`;
CREATE TABLE `ph_ranking_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `ranking_type` bigint(20) NOT NUll COMMENT '排行榜类型',
  `min_rank` bigint(20) NOT NULL COMMENT '最小排名',
  `max_rank` bigint(20) NOT NULL COMMENT '最大排名',
  `effective_betting` bigint(20) NOT NULL COMMENT '有效投注',
  `prize` varchar(225) NOT NULL COMMENT '奖品',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
-- 问卷调查计分版
DROP TABLE IF EXISTS `ph_questionscore`;
CREATE TABLE `ph_questionscore` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `pid` bigint(20) NOT NULL COMMENT '父节点ID',
  `seq` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `content` VARCHAR(255) NOT NULL COMMENT '内容',
  `content_type` INT NOT NULL COMMENT '类型(0:选项;1:单选;2:多选;3:单行输入;4:多行输入;)',
  `score` INT DEFAULT 0 COMMENT '分数',
  `category` INT DEFAULT 0 COMMENT '题目分类',
  `required` tinyint(4) DEFAULT 0 COMMENT '是否必填',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 问卷调查计分版答案
DROP TABLE IF EXISTS `ph_questionscore_answer`;
CREATE TABLE `ph_questionscore_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `pid` bigint(20) NOT NULL COMMENT '父节点ID',
  `content` VARCHAR(1024) NOT NULL COMMENT '内容',
  `score` INT DEFAULT 0 COMMENT '分数',
  `content_type` INT NOT NULL COMMENT '类型(0:根节点;1:选择题;2:输入题)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 问卷调查计分版分数排行
DROP TABLE IF EXISTS `ph_questionscore_ranking`;
CREATE TABLE `ph_questionscore_ranking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `Account` VARCHAR(1024) NOT NULL COMMENT '会员账号',
  `score` INT DEFAULT 0 COMMENT '分数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_member_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




-- 问卷调查
DROP TABLE IF EXISTS `ph_question`;
CREATE TABLE `ph_question` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `pid` bigint(20) NOT NULL COMMENT '父节点ID',
  `seq` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `content` VARCHAR(255) NOT NULL COMMENT '内容',
  `content_type` INT NOT NULL COMMENT '类型(0:选项;1:单选;2:多选;3:单行输入;4:多行输入;)',
  `required` tinyint(4) DEFAULT 0 COMMENT '是否必填',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_question_answer`;
CREATE TABLE `ph_question_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `pid` bigint(20) NOT NULL COMMENT '父节点ID',
  `content` VARCHAR(1024) NOT NULL COMMENT '内容',
  `content_type` INT NOT NULL COMMENT '类型(0:根节点;1:选择题;2:输入题)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 许愿活动
DROP TABLE IF EXISTS `ph_wish`;
CREATE TABLE `ph_wish` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `mobile` VARCHAR(255) DEFAULT NULL COMMENT '手机',
  `content` VARCHAR(1024) DEFAULT NULL COMMENT '愿望内容',
  `thumbs` INT DEFAULT NULL COMMENT '赞次数',
  `enabled` tinyint(4) DEFAULT 0 COMMENT '审核状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 大富翁：会员步数统计
DROP TABLE IF EXISTS `ph_rich_step`;
CREATE TABLE `ph_rich_step` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `step_count` INT DEFAULT 0 COMMENT '总计步数',
  `last_date` date NOT NULL COMMENT '最后参与日期',
  `lottery_addtime` date NOT NULL COMMENT '最后免费添加次数时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_rich_step_gid_account` (`game_id`,`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 通用:分享详情
DROP TABLE IF EXISTS `ph_share_detail`;
CREATE TABLE `ph_share_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `share_out` VARCHAR(255) NOT NULL COMMENT '分享人',
  `share_use` VARCHAR(255) NOT NULL COMMENT '使用分享的人',
  `ip` VARCHAR(255) NOT NULL COMMENT '使用分享的ip',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_share_detail_gid_shareuse` (`game_id`,`share_use`),
  UNIQUE KEY `uni_share_detail_gid_ip` (`game_id`,`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_game`;
CREATE TABLE `ph_game` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_version` bigint(20) NOT NULL COMMENT '游戏版本号',
  `name` VARCHAR(255) NOT NULL COMMENT '名称',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '描述',
  `deleted` tinyint(1) DEFAULT 0 COMMENT '是否删除 0:未删除;1:已删除',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否启用',
  `announcement` VARCHAR(1024) DEFAULT NULL COMMENT '公告',
  `bind_domain` VARCHAR(255) DEFAULT NULL COMMENT '绑定域名',
  `game_type` VARCHAR(10) DEFAULT NULL COMMENT '活动类型',
  `game_rule` longtext DEFAULT NULL COMMENT '活动规则说明',
  `game_statement` longtext DEFAULT NULL COMMENT '活动免责申明',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 活动属性设置
DROP TABLE IF EXISTS `ph_game_attribute`;
CREATE TABLE `ph_game_attribute` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `code` VARCHAR(255) NOT NULL COMMENT '活动属性',
  `value` VARCHAR(255) NOT NULL COMMENT '值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_game_period`;
CREATE TABLE `ph_game_period` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `start_time` VARCHAR(8) NOT NULL COMMENT '开始时间',
  `end_time` VARCHAR(8) NOT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_member`;
CREATE TABLE `ph_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `name` VARCHAR(255) DEFAULT NULL COMMENT '姓名',
  `mobile` VARCHAR(255) DEFAULT NULL COMMENT '手机',
  `level` INT DEFAULT 0 COMMENT '等级',
  `level_name` VARCHAR(255) DEFAULT NULL COMMENT '等级名称',
  `force` INT DEFAULT 0 COMMENT '原力值',
  `dynamic` INT DEFAULT 0 COMMENT '活力值',
  `last_signin_date` datetime DEFAULT NULL COMMENT '最近签到日期',
  `flag` INT DEFAULT 0 COMMENT '标识；0：导入；1：注册',
  `reg_ip` VARCHAR(45) DEFAULT NULL COMMENT '注册ip',
  `invitation_code` VARCHAR(45) DEFAULT NULL COMMENT '邀请码',
  `referrer_code` VARCHAR(45) DEFAULT NULL COMMENT '推荐人',
  `sign_enable` bigint(20) NOT NULL COMMENT '可签到活动id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_member_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_member_lottery`;
CREATE TABLE `ph_member_lottery` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `lottery_nums` INT NOT NULL DEFAULT 0 COMMENT '抽奖次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_member_lottery_gid_account` (`game_id`,`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_assign_member`;
CREATE TABLE `ph_assign_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `gift_id` bigint(20) NOT NULL COMMENT '奖品ID',
  `enabled` tinyint(4) NOT NULL COMMENT '是否使用；1：已使用；0：未使用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_gift`;
CREATE TABLE `ph_gift` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `seq` INT DEFAULT 1 COMMENT '编号',
  `name` VARCHAR(255) NOT NULL COMMENT '名称',
  `probability` INT NOT NULL DEFAULT 0 COMMENT '概率0-100',
  `quantity` INT NOT NULL DEFAULT 0 COMMENT '数量',
  `gift_type` tinyint(4) NOT NULL COMMENT '类型(0:未中奖;1:中奖)用于特效',
  `content` VARCHAR(255) NOT NULL COMMENT '奖品内容(金额等)',
  `photo` VARCHAR(255) DEFAULT NULL COMMENT '奖品图片',
  `broadcast_flag` tinyint(4) DEFAULT 0 COMMENT '大奖广播(0:不广播;1:广播)用于大奖全服广播',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_thumbs`;
CREATE TABLE `ph_thumbs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `account` VARCHAR(255) NOT NULL COMMENT '被点赞的会员账号',
  `ip` VARCHAR(255) NOT NULL COMMENT '点赞的ip',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_reward_log`;
CREATE TABLE `ph_reward_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `deleted` tinyint(1) DEFAULT 0 COMMENT '是否删除 0:未删除;1:已删除',
  `game_id` bigint(20) NOT NULL COMMENT '活动ID',
  `category` bigint(20) NOT NULL DEFAULT 0 COMMENT '类别',
  `account` VARCHAR(255) NOT NULL COMMENT '会员账号',
  `gift_id` bigint(20) NOT NULL COMMENT '奖品ID',
  `gift_name` VARCHAR(255) DEFAULT NULL COMMENT '名称',
  `gift_content` VARCHAR(255) DEFAULT NULL COMMENT '奖品内容(金额等)',
  `delivered` tinyint(4) DEFAULT 0 COMMENT '是否派送',
  `delivered_time` datetime DEFAULT NULL COMMENT '派送时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ph_site_config`;
CREATE TABLE `ph_site_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `code` VARCHAR(20) NOT NULL COMMENT '代码',
  `value` VARCHAR(255) NOT NULL COMMENT '值',
  `is_system` tinyint(1) NOT NULL COMMENT '是否内置(内置不可删除)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

BEGIN;
INSERT INTO `ph_site_config` VALUES ('1', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'NAME', '平台名称', 1);
INSERT INTO `ph_site_config` VALUES ('2', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'CUST', 'http://baidu.com', 1);
INSERT INTO `ph_site_config` VALUES ('3', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'OFFICIAL', 'http://baidu.com', 1);
INSERT INTO `ph_site_config` VALUES ('4', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'REGIST', 'http://baidu.com', 0);
INSERT INTO `ph_site_config` VALUES ('5', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'PARTNER', 'http://baidu.com', 0);
INSERT INTO `ph_site_config` VALUES ('6', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'PROMOT', 'http://baidu.com', 0);
INSERT INTO `ph_site_config` VALUES ('7', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'FQA', 'http://baidu.com', 0);
INSERT INTO `ph_site_config` VALUES ('8', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'RECHARGE', 'http://baidu.com', 0);
INSERT INTO `ph_site_config` VALUES ('9', '2017-10-15 14:22:56', '2017-10-16 09:39:39', 1, 1, '1', 'NAVOPEN', '0', 0);
COMMIT;

DROP TABLE IF EXISTS `ph_admin`;
CREATE TABLE `ph_admin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `enabled` tinyint(4) NOT NULL COMMENT '是否启用',
  `locked` tinyint(4) NOT NULL COMMENT '是否锁定',
  `is_system` tinyint(4) NOT NULL COMMENT '是否内置(内置不显示)',
  `locked_date` datetime DEFAULT NULL COMMENT '锁定日期',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `login_failure_count` int(11) NOT NULL COMMENT '连续登录失败次数',
  `login_ip` varchar(255) DEFAULT NULL COMMENT '最后登录IP',
  `salt` varchar(255) DEFAULT NULL COMMENT '加密盐',
  `name` varchar(255) DEFAULT NULL COMMENT '姓名',
  `password` varchar(255) NOT NULL DEFAULT '' COMMENT '密码',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_admin_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `ph_admin`
-- ----------------------------
BEGIN;
INSERT INTO `ph_admin` VALUES (1,'2017-10-01 20:59:59','2017-10-01 22:08:51',1,1,1,1,1,1,NULL,'2017-10-26 14:24:03',0,'127.0.0.1','17b007bdb8e7af362a1167bcce7277c9','超级管理员','9b16a6a8b524be91d0f440f61ed76fab','superadmin');
INSERT INTO `ph_admin` VALUES (2,'2017-10-13 22:24:06','2017-10-13 22:24:31',1,1,0,1,0,0,NULL,'2017-10-13 22:54:08',0,'127.0.0.1','253da8a9583fccd5645690aa25a71d20','管理员','ec7d8fc2e0093ffec5f39fede8e0bdd6','admin');
COMMIT;


-- ----------------------------
--  Table structure for ``
-- ----------------------------
DROP TABLE IF EXISTS `ph_role`;
CREATE TABLE `ph_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `enabled` tinyint(4) NOT NULL COMMENT '是否启用',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `is_system` tinyint(4) NOT NULL COMMENT '是否内置(内置不可选择)',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `role`
-- ----------------------------
BEGIN;
INSERT INTO `ph_role` VALUES ('1', '2017-10-01 20:59:59', '2017-10-01 20:59:59', 1, 1, '1', 1, '拥有最高后台管理权限', 1, '超级管理员');
INSERT INTO `ph_role` VALUES ('2', '2017-10-01 20:59:59', '2017-10-01 20:59:59', 1, 1, '1', 1, '拥有后台管理权限', 0, '管理员');
INSERT INTO `ph_role` VALUES ('3', '2017-10-01 20:59:59', '2017-10-01 20:59:59', 1, 1, '1', 1, '会员抽奖次数（查询）；中奖记录（全部）', 0, '客服');

COMMIT;

-- ----------------------------
--  Table structure for `ph_admin_role`
-- ----------------------------
DROP TABLE IF EXISTS `ph_admin_role`;
CREATE TABLE `ph_admin_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_admin_role` (`admin_id`,`role_id`),
  KEY `ind_admin_role_role_id` (`role_id`),
  CONSTRAINT `fk_admin_role_admin_id` FOREIGN KEY (`admin_id`) REFERENCES `ph_admin` (`id`),
  CONSTRAINT `fk_admin_role_role_id` FOREIGN KEY (`role_id`) REFERENCES `ph_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `ph_admin_role`
-- ----------------------------
BEGIN;
INSERT INTO `ph_admin_role` VALUES ('1', '1', '1');
INSERT INTO `ph_admin_role` VALUES ('2', '2', '2');
COMMIT;

-- ----------------------------
--  Table structure for `ph_permission`
-- ----------------------------
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `ph_permission`;
CREATE TABLE `ph_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `create_date` datetime NOT NULL COMMENT '创建日期',
  `modify_date` datetime NOT NULL COMMENT '修改日期',
  `creator` bigint(20) NOT NULL COMMENT '创建人id',
  `modifior` bigint(20) NOT NULL COMMENT '修改人id',
  `version` bigint(20) NOT NULL COMMENT '版本号',
  `pid` bigint(20) NOT NULL COMMENT '父节点id',
  `enabled` tinyint(4) NOT NULL COMMENT '是否启用',
  `display` tinyint(4) NOT NULL COMMENT '是否显示',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接地址',
  `name` varchar(255) NOT NULL COMMENT '名称',
  `icon` varchar(16) DEFAULT NULL COMMENT '图标',
  `sort` INT DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8 COMMENT='权限菜单,最多4级';

-- ----------------------------
--  Records of `permission`
-- ----------------------------
BEGIN;
INSERT INTO `ph_permission` VALUES ('1', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '系统设置', '', '系统设置', '#xe614;', '100');
INSERT INTO `ph_permission` VALUES ('2', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '1', '1', '0', '修改密码', 'ChangePwdController.Get', '修改密码', '', '100');
INSERT INTO `ph_permission` VALUES ('3', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '1', '1', '1', '管理员', 'AdminIndexController.Get', '管理员', '', '100');
INSERT INTO `ph_permission` VALUES ('4', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '3', '1', '0', '添加管理员', 'AdminAddController.Get', '添加管理员', '', '100');
INSERT INTO `ph_permission` VALUES ('5', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '3', '1', '0', '编辑管理员', 'AdminEditController.Get', '编辑管理员', '', '100');
INSERT INTO `ph_permission` VALUES ('6', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '3', '1', '0', '删除管理员', 'AdminIndexController.Delone', '删除管理员', '', '100');
INSERT INTO `ph_permission` VALUES ('7', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '1', '1', '1', '角色管理', 'RoleIndexController.Get', '角色管理', '', '100');
INSERT INTO `ph_permission` VALUES ('8', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '7', '1', '0', '添加角色', 'RoleAddController.Get', '添加角色', '', '100');
INSERT INTO `ph_permission` VALUES ('9', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '7', '1', '0', '编辑角色', 'RoleEditController.Get', '编辑角色', '', '100');
INSERT INTO `ph_permission` VALUES ('10', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '7', '1', '0', '删除角色', 'RoleIndexController.Delone', '删除角色', '', '100');
INSERT INTO `ph_permission` VALUES ('11', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '1', '1', '1', '菜单管理', 'PermissionIndexController.Get', '菜单管理', '', '100');
INSERT INTO `ph_permission` VALUES ('12', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '11', '1', '0', '添加菜单', 'PermissionAddController.Get', '添加菜单', '', '100');
INSERT INTO `ph_permission` VALUES ('13', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '11', '1', '0', '编辑菜单', 'PermissionEditController.Get', '编辑菜单', '', '100');
INSERT INTO `ph_permission` VALUES ('14', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '11', '1', '0', '删除菜单', 'PermissionIndexController.Delone', '删除菜单', '', '100');
INSERT INTO `ph_permission` VALUES ('15', '2017-10-14 15:11:23', '2017-10-14 15:11:23', '0', '0', '0', '1', '1', '1', '站点配置', 'SiteConfigIndexController.Get', '站点配置', '', '100');
INSERT INTO `ph_permission` VALUES ('16', '2017-10-14 15:12:26', '2017-10-14 15:13:48', '0', '0', '0', '15', '1', '0', '添加站点配置', 'SiteConfigAddController.Get', '添加站点配置', '', '100');
INSERT INTO `ph_permission` VALUES ('17', '2017-10-14 15:12:54', '2017-10-14 15:13:52', '0', '0', '0', '15', '1', '0', '编辑站点配置', 'SiteConfigEditController.Get', '编辑站点配置', '', '100');
INSERT INTO `ph_permission` VALUES ('18', '2017-10-14 15:13:22', '2017-10-14 15:13:57', '0', '0', '0', '15', '1', '0', '删除站点配置', 'SiteConfigIndexController.Delone', '删除站点配置', '', '100');
INSERT INTO `ph_permission` VALUES ('19', '2017-10-14 15:13:22', '2017-10-14 15:13:57', '0', '0', '0', '0', '1', '0', '系统信息', 'SysIndexController.Get', '系统信息', '', '10');
INSERT INTO `ph_permission` VALUES ('20', '2017-10-14 15:13:22', '2017-10-14 15:13:57', '0', '0', '0', '0', '1', '0', '系统通用-文件上传', 'SyscommonController.Upload', '系统通用-文件上传', '', '11');
INSERT INTO `ph_permission` VALUES ('21', '2017-10-14 15:13:22', '2017-10-14 15:13:57', '0', '0', '0', '0', '1', '0', '系统通用-UEditor', 'SysUeditorController.Action', '系统通用-UEditor', '', '11');
INSERT INTO `ph_permission` VALUES ('100', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '活动与会员', '', '活动与会员', '#xe857;', '100');
INSERT INTO `ph_permission` VALUES ('101', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '100', '1', '1', '活动配置', 'GameIndexController.Get', '活动配置', '', '100');
INSERT INTO `ph_permission` VALUES ('102', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '101', '1', '0', '添加活动', 'GameAddController.Get', '添加活动', '', '100');
INSERT INTO `ph_permission` VALUES ('103', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '101', '1', '0', '编辑活动', 'GameEditController.Get', '编辑活动', '', '100');
INSERT INTO `ph_permission` VALUES ('104', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '101', '1', '0', '删除活动', 'GameIndexController.Delone', '删除活动', '', '100');
INSERT INTO `ph_permission` VALUES ('105', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '101', '1', '0', '显示时间段', 'GamePeriodIndexController.Get', '显示时间段', '', '100');
INSERT INTO `ph_permission` VALUES ('106', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '101', '1', '0', '活动设置是否启用', 'GameIndexController.Enabled', '活动设置是否启用', '', '100');
INSERT INTO `ph_permission` VALUES ('107', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '105', '1', '0', '添加时间段', 'GamePeriodAddController.Get', '添加时间段', '', '100');
INSERT INTO `ph_permission` VALUES ('108', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '105', '1', '0', '删除时间段', 'GamePeriodIndexController.Delone', '删除时间段', '', '100');
INSERT INTO `ph_permission` VALUES ('120', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '100', '1', '1', '会员管理', 'MemberIndexController.Get', '会员管理', '', '100');
INSERT INTO `ph_permission` VALUES ('121', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '添加会员', 'MemberAddController.Get', '添加会员', '', '100');
INSERT INTO `ph_permission` VALUES ('122', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '编辑会员', 'MemberEditController.Get', '编辑会员', '', '100');
INSERT INTO `ph_permission` VALUES ('123', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '删除会员', 'MemberIndexController.Delone', '删除会员', '', '100');
INSERT INTO `ph_permission` VALUES ('124', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '导入会员', 'MemberIndexController.Import', '导入会员', '', '100');
INSERT INTO `ph_permission` VALUES ('125', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '批量删除会员', 'MemberIndexController.Delbatch', '批量删除会员', '', '100');
INSERT INTO `ph_permission` VALUES ('126', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '重置签到信息', 'MemberIndexController.RebootSign', '重置签到信息', '', '100');
INSERT INTO `ph_permission` VALUES ('127', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '120', '1', '0', '导入可签到会员', 'MemberIndexController.ImportSign', '导入可签到会员', '', '100');
INSERT INTO `ph_permission` VALUES ('130', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '100', '1', '1', '分享记录', 'ShareDetailIndexController.Get', '分享记录', '', '100');
INSERT INTO `ph_permission` VALUES ('131', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '130', '1', '0', '删除分享记录', 'ShareDetailIndexController.Delone', '删除分享记录', '', '100');
INSERT INTO `ph_permission` VALUES ('132', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '130', '1', '0', '导出分享记录', 'ShareDetailIndexController.Export', '导出分享记录', '', '100');
INSERT INTO `ph_permission` VALUES ('135', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '100', '1', '1', '评论记录', 'CommentIndexController.get', '评论记录', '', '100');
INSERT INTO `ph_permission` VALUES ('136', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '130', '1', '0', '删除评论记录', 'CommentIndexController.Delone', '删除评论记录', '', '100');
INSERT INTO `ph_permission` VALUES ('137', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '130', '1', '0', '审核评论记录', 'CommentIndexController.Status', '审核评论记录', '', '100');
INSERT INTO `ph_permission` VALUES ('138', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '130', '1', '0', '标记评论记录', 'CommentIndexController.Tag', '标记评论记录', '', '100');
INSERT INTO `ph_permission` VALUES ('140', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '奖品与中奖', '', '奖品与中奖', '#xe735;', '100');
INSERT INTO `ph_permission` VALUES ('141', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '140', '1', '1', '奖品管理', 'GiftIndexController.Get', '奖品管理', '', '100');
INSERT INTO `ph_permission` VALUES ('142', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '141', '1', '0', '添加奖品', 'GiftAddController.Get', '添加奖品', '', '100');
INSERT INTO `ph_permission` VALUES ('143', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '141', '1', '0', '编辑奖品', 'GiftEditController.Get', '编辑奖品', '', '100');
INSERT INTO `ph_permission` VALUES ('144', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '141', '1', '0', '删除奖品', 'GiftIndexController.Delone', '删除奖品', '', '100');
INSERT INTO `ph_permission` VALUES ('150', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '140', '1', '1', '会员抽奖次数', 'MemberLotteryIndexController.Get', '会员抽奖次数', '', '100');
INSERT INTO `ph_permission` VALUES ('151', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '150', '1', '0', '添加抽奖次数', 'MemberLotteryAddController.Get', '添加抽奖次数', '', '100');
INSERT INTO `ph_permission` VALUES ('152', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '150', '1', '0', '编辑抽奖次数', 'MemberLotteryEditController.Get', '编辑抽奖次数', '', '100');
INSERT INTO `ph_permission` VALUES ('153', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '150', '1', '0', '删除抽奖次数', 'MemberLotteryIndexController.Delone', '删除抽奖次数', '', '100');
INSERT INTO `ph_permission` VALUES ('154', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '150', '1', '0', '批量删除抽奖次数', 'MemberLotteryIndexController.Delbatch', '批量删除抽奖次数', '', '100');
INSERT INTO `ph_permission` VALUES ('155', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '150', '1', '0', '导入会员抽奖次数', 'MemberLotteryIndexController.Import', '导入会员抽奖次数', '', '100');
INSERT INTO `ph_permission` VALUES ('160', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '140', '1', '1', '内定会员', 'AssignMemberIndexController.Get', '内定会员', '', '100');
INSERT INTO `ph_permission` VALUES ('161', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '160', '1', '0', '添加内定会员', 'AssignMemberAddController.Get', '添加内定会员', '', '100');
INSERT INTO `ph_permission` VALUES ('162', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '160', '1', '0', '编辑内定会员', 'AssignMemberEditController.Get', '编辑内定会员', '', '100');
INSERT INTO `ph_permission` VALUES ('163', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '160', '1', '0', '删除内定会员', 'AssignMemberIndexController.Delone', '删除内定会员', '', '100');
INSERT INTO `ph_permission` VALUES ('164', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '160', '1', '0', '导入内定会员', 'AssignMemberIndexController.Import', '导入内定会员', '', '100');
INSERT INTO `ph_permission` VALUES ('165', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '160', '1', '0', '删除所有内定会员', 'AssignMemberIndexController.Delbatch', '删除所有内定会员', '', '100');
INSERT INTO `ph_permission` VALUES ('170', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '140', '1', '1', '中奖记录', 'RewardLogIndexController.Get', '中奖记录', '', '100');
INSERT INTO `ph_permission` VALUES ('171', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '170', '1', '0', '中奖记录派送', 'RewardLogIndexController.Delivered', '中奖记录派送', '', '100');
INSERT INTO `ph_permission` VALUES ('172', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '170', '1', '0', '删除中奖记录', 'RewardLogIndexController.Delone', '删除中奖记录', '', '100');
INSERT INTO `ph_permission` VALUES ('173', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '170', '1', '0', '中奖记录批量标记派送', 'RewardLogIndexController.Deliveredbatch', '批量标记派送', '', '100');
INSERT INTO `ph_permission` VALUES ('174', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '170', '1', '0', '中奖记录批量删除', 'RewardLogIndexController.Delbatch', '中奖记录批量删除', '', '100');
INSERT INTO `ph_permission` VALUES ('175', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '170', '1', '0', '中奖记录导入', 'RewardLogIndexController.Import', '中奖记录导入', '', '100');
INSERT INTO `ph_permission` VALUES ('180', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '许愿活动', '', '许愿活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('181', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '180', '1', '1', '愿望列表', 'WishIndexController.Get', '愿望列表', '', '100');
INSERT INTO `ph_permission` VALUES ('182', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '181', '1', '0', '删除愿望', 'WishIndexController.Delone', '删除愿望', '', '100');
INSERT INTO `ph_permission` VALUES ('183', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '181', '1', '0', '审核愿望', 'WishIndexController.Enabled', '审核愿望', '', '100');
INSERT INTO `ph_permission` VALUES ('184', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '181', '1', '0', '愿望派奖', 'WishIndexController.Reward', '愿望派奖', '', '100');
INSERT INTO `ph_permission` VALUES ('185', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '181', '1', '0', '愿望列表导出', 'WishIndexController.Export', '愿望列表导出', '', '100');
INSERT INTO `ph_permission` VALUES ('186', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '181', '1', '0', '批量审核愿望', 'WishIndexController.CheckboxDelone', '批量审核愿望', '', '100');
INSERT INTO `ph_permission` VALUES ('200', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '大富翁活动', '', '大富翁活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('201', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '200', '1', '1', '大富翁配置', 'RichAttributeIndexController.Get', '大富翁配置', '', '100');
INSERT INTO `ph_permission` VALUES ('202', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '200', '1', '1', '大富翁会员参与情况', 'RichStepIndexController.Get', '会员参与情况', '', '100');
INSERT INTO `ph_permission` VALUES ('203', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '200', '1', '1', '删除大富翁会员参与情况', 'RichStepIndexController.Delone', '删除大富翁会员参与情况', '', '100');
INSERT INTO `ph_permission` VALUES ('204', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '200', '1', '0', '导出大富翁会员参与情况', 'RichStepIndexController.Export', '导出大富翁会员参与情况', '', '100');
INSERT INTO `ph_permission` VALUES ('220', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '大转盘活动', '', '大转盘活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('221', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '220', '1', '1', '大转盘配置', 'WheelAttributeIndexController.Get', '大转盘配置', '', '100');
INSERT INTO `ph_permission` VALUES ('240', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '问卷调查', '', '问卷调查', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('241', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '1', '问卷配置', 'QuestionIndexController.Get', '问卷配置', '', '100');
INSERT INTO `ph_permission` VALUES ('242', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '241', '1', '1', '删除问卷题目或选项', 'QuestionIndexController.Delone', '删除问卷题目或选项', '', '100');
INSERT INTO `ph_permission` VALUES ('260', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '1', '调查结果', 'QuestionAnswerIndexController.Get', '调查结果', '', '200');
INSERT INTO `ph_permission` VALUES ('265', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '1', '问卷调查(计分版)', 'QuestionscoreIndexController.Get', '调查结果(计分版)', '', '200');
INSERT INTO `ph_permission` VALUES ('266', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '0', '删除问卷题目或选项(计分版)', 'QuestionscoreIndexController.Delone', '删除问卷题目或选项(计分版)', '', '200');
INSERT INTO `ph_permission` VALUES ('267', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '1', '调查结果答案(计分版)', 'QuestionscoreAnswerIndexController.Get', '调查结果答案(计分版)', '', '200');
INSERT INTO `ph_permission` VALUES ('268', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '0', '导入问卷调查(计分版)', 'QuestionscoreIndexController.Import', '导入问卷调查(计分版)', '', '200');
INSERT INTO `ph_permission` VALUES ('269', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '0', '批量删除问卷调查(计分版)', 'QuestionscoreIndexController.Batchdel', '批量删除问卷调查(计分版)', '', '200');
INSERT INTO `ph_permission` VALUES ('270', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '240', '1', '0', '修改问卷调查题目数量(计分版)', 'QuestionscoreIndexController.ModifyAttr', '修改问卷调查题目数量(计分版)', '', '200');
INSERT INTO `ph_permission` VALUES ('280', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '积分商城', '', '积分商城', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('281', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '280', '1', '1', '商品管理', 'GoodsIndexController.Get', '商品管理', '', '100');
INSERT INTO `ph_permission` VALUES ('282', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '281', '1', '0', '添加商品', 'GoodsAddController.Get', '添加商品', '', '100');
INSERT INTO `ph_permission` VALUES ('283', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '281', '1', '0', '编辑商品', 'GoodsEditController.Get', '编辑商品', '', '100');
INSERT INTO `ph_permission` VALUES ('284', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '281', '1', '0', '删除商品', 'GoodsIndexController.Delone', '删除商品', '', '100');
INSERT INTO `ph_permission` VALUES ('300', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '280', '1', '1', '会员积分管理', 'IntegralIndexController.Get', '会员积分管理', '', '100');
INSERT INTO `ph_permission` VALUES ('301', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '300', '1', '0', '添加会员积分', 'IntegralAddController.Get', '添加会员积分', '', '100');
INSERT INTO `ph_permission` VALUES ('302', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '300', '1', '0', '编辑会员积分', 'IntegralEditController.Get', '编辑会员积分', '', '100');
INSERT INTO `ph_permission` VALUES ('303', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '300', '1', '0', '删除会员积分', 'IntegralIndexController.Delone', '删除会员积分', '', '100');
INSERT INTO `ph_permission` VALUES ('304', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '300', '1', '0', '批量删除会员积分', 'IntegralIndexController.Delbatch', '批量删除会员积分', '', '100');
INSERT INTO `ph_permission` VALUES ('305', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '300', '1', '0', '导入会员积分', 'IntegralIndexController.Import', '导入会员积分', '', '100');
INSERT INTO `ph_permission` VALUES ('320', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '投注排行榜', '', '投注排行榜', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('321', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '1', '投注排行榜管理', 'RankingIndexController.get', '投注排行榜管理', '', '100');
INSERT INTO `ph_permission` VALUES ('322', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '添加排行榜信息', 'AddRankingController.get', '添加排行榜信息', '', '100');
INSERT INTO `ph_permission` VALUES ('323', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '删除排行榜信息', 'RankingIndexController.Delone', '删除排行榜信息', '', '100');
INSERT INTO `ph_permission` VALUES ('324', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '修改排行榜信息', 'EditRankingController.Get', '修改排行榜信息', '', '100');
INSERT INTO `ph_permission` VALUES ('325', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '删除所有排行榜信息', 'RankingIndexController.Delbatch', '删除所有排行榜信息', '', '100');
INSERT INTO `ph_permission` VALUES ('326', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '导入排行榜信息', 'RankingIndexController.Import', '导入排行榜信息', '', '100');
INSERT INTO `ph_permission` VALUES ('327', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '1', '投注排行榜配置信息', 'RankingConfigIndexController.get', '投注排行榜配置信息', '', '100');
INSERT INTO `ph_permission` VALUES ('328', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '添加排行榜配置信息', 'AddRankingConfigController.get', '添加排行榜配置信息', '', '100');
INSERT INTO `ph_permission` VALUES ('329', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '修改排行榜配置信息', 'EditRankingConfigController.get', '修改排行榜配置信息', '', '100');
INSERT INTO `ph_permission` VALUES ('330', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '删除排行榜配置信息', 'RankingConfigIndexController.Delone', '删除排行榜配置信息', '', '100');
INSERT INTO `ph_permission` VALUES ('331', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '1', '投注排行榜派奖页', 'RankingDeliverIndexController.get', '投注排行榜派奖页', '', '100');
INSERT INTO `ph_permission` VALUES ('332', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '生成派奖信息', 'RankingDeliverIndexController.CreateDelivered', '生成派奖信息', '', '100');
INSERT INTO `ph_permission` VALUES ('333', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '生成总榜派奖信息', 'RankingDeliverIndexController.CreateTotal', '生成总榜派奖信息', '', '100');
INSERT INTO `ph_permission` VALUES ('334', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '排行榜标记派奖信息', 'RankingDeliverIndexController.Delivered', '排行榜标记派奖信息', '', '100');
INSERT INTO `ph_permission` VALUES ('335', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '排行榜批量标记派奖信息', 'RankingDeliverIndexController.Deliveredbatch', '排行榜批量标记派奖信息', '', '100');
INSERT INTO `ph_permission` VALUES ('336', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '320', '1', '0', '导出排行榜信息', 'RankingDeliverIndexController.Export', '导出排行榜信息', '', '100');
INSERT INTO `ph_permission` VALUES ('341', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '电子金管家', '', '电子金管家', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('342', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '1', '电子金管家配置', 'UpgradingAttribute.get', '电子金管家配置', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('343', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '添加电子金管家配置', 'AddUpgradingAttribute.get', '添加电子金管家配置', '', '100');
INSERT INTO `ph_permission` VALUES ('344', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '修改电子金管家配置', 'EditUpgradingAttribute.get', '修改电子金管家配置', '', '100');
INSERT INTO `ph_permission` VALUES ('345', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '删除电子金管家配置', 'UpgradingAttribute.Delone', '删除电子金管家配置', '', '100');
INSERT INTO `ph_permission` VALUES ('346', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '1', '电子金管家周信息', 'UpgradingWeekController.get', '电子金管家周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('347', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '添加电子金管家周信息', 'AddUpgradingWeekController.get', '添加电子金管家周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('348', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '修改电子金管家周信息', 'EditUpgradingWeekController.get', '修改电子金管家周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('349', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '删除电子金管家周信息', 'UpgradingWeekController.Delone', '删除电子金管家周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('350', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '导入电子金管家周信息', 'UpgradingWeekController.Import', '导入电子金管家周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('351', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '删除所有周信息', 'UpgradingWeekController.Delbatch', '删除所有周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('352', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '周信息标记派送', 'UpgradingWeekController.Delivered', '周信息标记派送', '', '100');
INSERT INTO `ph_permission` VALUES ('353', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '导出周信息', 'UpgradingWeekController.Export', '导出周信息', '', '100');
INSERT INTO `ph_permission` VALUES ('354', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '批量标记周派奖信息', 'UpgradingWeekController.Deliveredbatch', '批量标记周派奖信息', '', '100');
INSERT INTO `ph_permission` VALUES ('355', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '1', '电子金管家总信息', 'UpgradingController.get', '电子金管家总信息', '', '100');
INSERT INTO `ph_permission` VALUES ('356', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '导出电子金管家总信息', 'UpgradingController.Export', '导出电子金管家总信息', '', '100');
INSERT INTO `ph_permission` VALUES ('357', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '删除所有电子金管家总信息', 'UpgradingController.Delbatch', '删除所有电子金管家总信息', '', '100');
INSERT INTO `ph_permission` VALUES ('358', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '生成电子金管家总信息', 'UpgradingController.CreateTotal', '生成电子金管家总信息', '', '100');
INSERT INTO `ph_permission` VALUES ('359', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '计算电子金管家周晋级彩金', 'UpgradingWeekController.CountGift', '计算电子金管家周晋级彩金', '', '100');
INSERT INTO `ph_permission` VALUES ('360', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '计算电子金管家周俸禄', 'UpgradingController.CountWeek', '计算电子金管家周俸禄', '', '100');
INSERT INTO `ph_permission` VALUES ('361', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '计算电子金管家月俸禄', 'UpgradingController.CountMonth', '计算电子金管家月俸禄', '', '100');
INSERT INTO `ph_permission` VALUES ('362', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '修改电子金管家总信息', 'UpgradingEditController.Get', '修改电子金管家总信息', '', '100');
INSERT INTO `ph_permission` VALUES ('363', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '341', '1', '0', '导入电子金管家总信息', 'UpgradingController.Import', '导入电子金管家总信息', '', '100');
INSERT INTO `ph_permission` VALUES ('380', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '投票活动', '', '投票活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('381', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '380', '1', '1', '选票列表(奖池因子版)', 'VoteItemIndexController.Get', '选票列表(奖池因子版)', '', '100');
INSERT INTO `ph_permission` VALUES ('382', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '381', '1', '0', '添加选票', 'VoteItemAddController.Get', '添加选票', '', '100');
INSERT INTO `ph_permission` VALUES ('383', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '381', '1', '0', '编辑选票', 'VoteItemEditController.Get', '编辑选票', '', '100');
INSERT INTO `ph_permission` VALUES ('384', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '381', '1', '0', '删除选票', 'VoteItemIndexController.Delone', '删除选票', '', '100');
INSERT INTO `ph_permission` VALUES ('385', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '381', '1', '0', '投票奖池因子', 'VoteItemIndexController.ModifyFactor', '投票奖池因子', '', '100');
INSERT INTO `ph_permission` VALUES ('386', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '381', '1', '0', '选票设置中奖标记', 'VoteItemIndexController.MarkFlag', '选票设置中奖标记', '', '100');
INSERT INTO `ph_permission` VALUES ('387', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '381', '1', '0', '投票生成中奖记录', 'VoteItemIndexController.Generate', '投票生成中奖记录', '', '100');
INSERT INTO `ph_permission` VALUES ('401', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '380', '1', '1', '选票列表(总奖池版)', 'VoteItem2IndexController.Get', '选票列表(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('402', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '401', '1', '0', '添加选票(总奖池版)', 'VoteItem2AddController.Get', '添加选票(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('403', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '401', '1', '0', '编辑选票(总奖池版)', 'VoteItem2EditController.Get', '编辑选票(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('404', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '401', '1', '0', '删除选票(总奖池版)', 'VoteItem2IndexController.Delone', '删除选票(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('405', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '401', '1', '0', '投票奖池因子(总奖池版)', 'VoteItem2IndexController.ModifyPrize', '投票奖池因子(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('406', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '401', '1', '0', '选票设置中奖标记(总奖池版)', 'VoteItem2IndexController.MarkFlag', '选票设置中奖标记(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('407', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '401', '1', '0', '投票生成中奖记录(总奖池版)', 'VoteItem2IndexController.Generate', '投票生成中奖记录(总奖池版)', '', '100');
INSERT INTO `ph_permission` VALUES ('420', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '380', '1', '1', '投票详情', 'VoteDetailIndexController.Get', '投票详情', '', '100');
INSERT INTO `ph_permission` VALUES ('421', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '420', '1', '0', '删除投票详情', 'VoteDetailIndexController.Delone', '删除投票详情', '', '100');
INSERT INTO `ph_permission` VALUES ('422', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '420', '1', '0', '导出投票详情', 'VoteDetailIndexController.Export', '导出投票详情', '', '100');
INSERT INTO `ph_permission` VALUES ('440', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '签到活动', '', '签到活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('441', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '440', '1', '1', '签到等级列表', 'SigninLevelIndexController.Get', '签到等级列表', '', '100');
INSERT INTO `ph_permission` VALUES ('442', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '441', '1', '0', '添加等级', 'SigninLevelAddController.Get', '添加等级', '', '100');
INSERT INTO `ph_permission` VALUES ('443', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '441', '1', '0', '编辑等级', 'SigninLevelEditController.Get', '编辑等级', '', '100');
INSERT INTO `ph_permission` VALUES ('444', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '441', '1', '0', '删除等级', 'SigninLevelIndexController.Delone', '删除等级', '', '100');
INSERT INTO `ph_permission` VALUES ('445', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '441', '1', '0', '修改签到活动属性', 'SigninLevelIndexController.ModifyAttr', '修改签到活动属性', '', '100');
INSERT INTO `ph_permission` VALUES ('446', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '441', '1', '0', '上传瓜分图片', 'SigninLevelIndexController.UplodImg', '上传瓜分图片', '', '100');
INSERT INTO `ph_permission` VALUES ('460', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '宝箱活动', '', '宝箱活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('461', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '460', '1', '1', '绑定宝箱', 'BoxIndexController.get', '绑定宝箱', '', '100');
INSERT INTO `ph_permission` VALUES ('462', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '460', '1', '0', '添加绑定宝箱', 'BoxAddController.get', '添加绑定宝箱', '', '100');
INSERT INTO `ph_permission` VALUES ('463', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '460', '1', '0', '删除绑定', 'BoxIndexController.Delone', '删除绑定', '', '100');
INSERT INTO `ph_permission` VALUES ('480', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', '秒杀和抢购活动', '', '秒杀和抢购活动', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('481', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '480', '1', '1', '秒杀和抢购绑定', 'SeckillAndRushIndexController.get', '秒杀和抢购绑定', '', '100');
INSERT INTO `ph_permission` VALUES ('482', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '480', '1', '0', '添加秒杀和抢购绑定', 'SeckillAndRushAddController.get', '添加秒杀和抢购绑定', '', '100');
INSERT INTO `ph_permission` VALUES ('483', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '480', '1', '0', '删除秒杀和抢购绑定', 'SeckillAndRushIndexController.Delone', '删除秒杀和抢购绑定', '', '100');
INSERT INTO `ph_permission` VALUES ('490', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '0', '1', '1', 'VIP账号价值', '', 'VIP账号价值', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('491', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '490', '1', '1', 'VIP账号价值列表', 'VipValueIndexController.get', 'VIP账号价值列表', '', '100');
INSERT INTO `ph_permission` VALUES ('492', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '490', '1', '0', '删除VIP账号价值', 'VipValueIndexController.Delone', '删除VIP账号价值', '', '100');
INSERT INTO `ph_permission` VALUES ('493', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '490', '1', '0', '导入VIP账号价值', 'VipValueIndexController.Import', '导入VIP账号价值', '', '100');
INSERT INTO `ph_permission` VALUES ('494', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '490', '1', '0', '添加VIP账号价值', 'VipValueAddController.get', '添加VIP账号价值', '', '100');
INSERT INTO `ph_permission` VALUES ('495', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '490', '1', '0', '修改VIP账号价值', 'VipValueEditController.get', '修改VIP账号价值', '', '100');
INSERT INTO `ph_permission` VALUES ('496', '2017-10-01 20:59:59', '2017-10-01 20:59:59', '1', '1', '1', '490', '1', '0', '批量VIP账号价值', 'VipValueIndexController.BatchDel', '批量VIP账号价值', '', '100');
INSERT INTO `ph_permission` VALUES ('510', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '0', '1', '1', '月签到', '', '月签到', '#xe600;', '100');
INSERT INTO `ph_permission` VALUES ('511', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '510', '1', '1', '会员投注列表', 'MonthsigninBetIndexController.get', '会员投注列表', '', '100');
INSERT INTO `ph_permission` VALUES ('512', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '510', '1', '0', '删除月签到会员投注', 'MonthsigninBetIndexController.Delone', '删除月签到会员投注', '', '100');
INSERT INTO `ph_permission` VALUES ('513', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '510', '1', '0', '批量删除月签到会员投注', 'MonthsigninBetIndexController.DelBatch', '批量删除月签到会员投注', '', '100');
INSERT INTO `ph_permission` VALUES ('514', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '510', '1', '0', '添加月签到会员投注', 'MonthsigninBetAddController.get', '添加月签到会员投注', '', '100');
INSERT INTO `ph_permission` VALUES ('515', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '510', '1', '0', '修改月签到会员投注', 'MonthsigninBetEditController.get', '修改月签到会员投注', '', '100');
INSERT INTO `ph_permission` VALUES ('516', '2019-11-02 14:59:59', '2019-11-02 14:59:59', '1', '1', '1', '510', '1', '0', '导入月签到会员投注', 'MonthsigninBetIndexController.Import', '导入月签到会员投注', '', '100');
COMMIT;


SET FOREIGN_KEY_CHECKS = 1;
-- ----------------------------
--  Table structure for `ph_role_permission`
-- ----------------------------
DROP TABLE IF EXISTS `ph_role_permission`;
CREATE TABLE `ph_role_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色',
  `permission_id` bigint(20) NOT NULL COMMENT '权限',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_permission_role` (`role_id`, `permission_id`),
  KEY `ind_permission_role_role` (`role_id`),
  KEY `ind_permission_role_permission` (`permission_id`),
  CONSTRAINT `FK_permission_role_permission` FOREIGN KEY (`permission_id`) REFERENCES `ph_permission` (`id`),
  CONSTRAINT `FK_permission_role_role` FOREIGN KEY (`role_id`) REFERENCES `ph_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `ph_role_permission`
-- ----------------------------
BEGIN;

INSERT INTO `ph_role_permission` VALUES ('1', '1', '1');
INSERT INTO `ph_role_permission` VALUES ('2', '1', '2');
INSERT INTO `ph_role_permission` VALUES ('3', '1', '3');
INSERT INTO `ph_role_permission` VALUES ('4', '1', '4');
INSERT INTO `ph_role_permission` VALUES ('5', '1', '5');
INSERT INTO `ph_role_permission` VALUES ('6', '1', '6');
INSERT INTO `ph_role_permission` VALUES ('7', '1', '7');
INSERT INTO `ph_role_permission` VALUES ('8', '1', '8');
INSERT INTO `ph_role_permission` VALUES ('9', '1', '9');
INSERT INTO `ph_role_permission` VALUES ('10', '1', '10');
INSERT INTO `ph_role_permission` VALUES ('11', '1', '11');
INSERT INTO `ph_role_permission` VALUES ('12', '1', '12');
INSERT INTO `ph_role_permission` VALUES ('13', '1', '13');
INSERT INTO `ph_role_permission` VALUES ('14', '1', '14');
INSERT INTO `ph_role_permission` VALUES ('15', '1', '15');
INSERT INTO `ph_role_permission` VALUES ('16', '1', '16');
INSERT INTO `ph_role_permission` VALUES ('17', '1', '17');
INSERT INTO `ph_role_permission` VALUES ('18', '1', '18');
INSERT INTO `ph_role_permission` VALUES ('19', '1', '19');
INSERT INTO `ph_role_permission` VALUES ('100', '2', '1');
INSERT INTO `ph_role_permission` VALUES ('101', '2', '2');
INSERT INTO `ph_role_permission` VALUES ('102', '2', '3');
INSERT INTO `ph_role_permission` VALUES ('103', '2', '4');
INSERT INTO `ph_role_permission` VALUES ('104', '2', '5');
INSERT INTO `ph_role_permission` VALUES ('105', '2', '6');
INSERT INTO `ph_role_permission` VALUES ('106', '2', '15');
INSERT INTO `ph_role_permission` VALUES ('107', '2', '16');
INSERT INTO `ph_role_permission` VALUES ('108', '2', '17');
INSERT INTO `ph_role_permission` VALUES ('109', '2', '18');
INSERT INTO `ph_role_permission` VALUES ('110', '2', '19');
INSERT INTO `ph_role_permission` VALUES ('111', '2', '20');
INSERT INTO `ph_role_permission` VALUES ('112', '2', '21');
INSERT INTO `ph_role_permission` VALUES ('200', '2', '100');
INSERT INTO `ph_role_permission` VALUES ('201', '2', '101');
INSERT INTO `ph_role_permission` VALUES ('202', '2', '102');
INSERT INTO `ph_role_permission` VALUES ('203', '2', '103');
INSERT INTO `ph_role_permission` VALUES ('204', '2', '104');
INSERT INTO `ph_role_permission` VALUES ('205', '2', '105');
INSERT INTO `ph_role_permission` VALUES ('206', '2', '106');
INSERT INTO `ph_role_permission` VALUES ('207', '2', '107');
INSERT INTO `ph_role_permission` VALUES ('208', '2', '108');
INSERT INTO `ph_role_permission` VALUES ('220', '2', '120');
INSERT INTO `ph_role_permission` VALUES ('221', '2', '121');
INSERT INTO `ph_role_permission` VALUES ('222', '2', '122');
INSERT INTO `ph_role_permission` VALUES ('223', '2', '123');
INSERT INTO `ph_role_permission` VALUES ('224', '2', '124');
INSERT INTO `ph_role_permission` VALUES ('225', '2', '125');
INSERT INTO `ph_role_permission` VALUES ('226', '2', '126');
INSERT INTO `ph_role_permission` VALUES ('227', '2', '127');
INSERT INTO `ph_role_permission` VALUES ('230', '2', '130');
INSERT INTO `ph_role_permission` VALUES ('231', '2', '131');
INSERT INTO `ph_role_permission` VALUES ('232', '2', '132');
INSERT INTO `ph_role_permission` VALUES ('235', '2', '135');
INSERT INTO `ph_role_permission` VALUES ('236', '2', '136');
INSERT INTO `ph_role_permission` VALUES ('237', '2', '137');
INSERT INTO `ph_role_permission` VALUES ('238', '2', '138');
INSERT INTO `ph_role_permission` VALUES ('240', '2', '140');
INSERT INTO `ph_role_permission` VALUES ('241', '2', '141');
INSERT INTO `ph_role_permission` VALUES ('242', '2', '142');
INSERT INTO `ph_role_permission` VALUES ('243', '2', '143');
INSERT INTO `ph_role_permission` VALUES ('244', '2', '144');
INSERT INTO `ph_role_permission` VALUES ('250', '2', '150');
INSERT INTO `ph_role_permission` VALUES ('251', '2', '151');
INSERT INTO `ph_role_permission` VALUES ('252', '2', '152');
INSERT INTO `ph_role_permission` VALUES ('253', '2', '153');
INSERT INTO `ph_role_permission` VALUES ('254', '2', '154');
INSERT INTO `ph_role_permission` VALUES ('255', '2', '155');
INSERT INTO `ph_role_permission` VALUES ('260', '2', '160');
INSERT INTO `ph_role_permission` VALUES ('261', '2', '161');
INSERT INTO `ph_role_permission` VALUES ('262', '2', '162');
INSERT INTO `ph_role_permission` VALUES ('263', '2', '163');
INSERT INTO `ph_role_permission` VALUES ('264', '2', '164');
INSERT INTO `ph_role_permission` VALUES ('265', '2', '165');
INSERT INTO `ph_role_permission` VALUES ('270', '2', '170');
INSERT INTO `ph_role_permission` VALUES ('271', '2', '171');
INSERT INTO `ph_role_permission` VALUES ('272', '2', '172');
INSERT INTO `ph_role_permission` VALUES ('273', '2', '173');
INSERT INTO `ph_role_permission` VALUES ('274', '2', '174');
INSERT INTO `ph_role_permission` VALUES ('275', '2', '175');
INSERT INTO `ph_role_permission` VALUES ('280', '2', '180');
INSERT INTO `ph_role_permission` VALUES ('281', '2', '181');
INSERT INTO `ph_role_permission` VALUES ('282', '2', '182');
INSERT INTO `ph_role_permission` VALUES ('283', '2', '183');
INSERT INTO `ph_role_permission` VALUES ('284', '2', '184');
INSERT INTO `ph_role_permission` VALUES ('285', '2', '185');
INSERT INTO `ph_role_permission` VALUES ('286', '2', '186');
INSERT INTO `ph_role_permission` VALUES ('300', '2', '200');
INSERT INTO `ph_role_permission` VALUES ('301', '2', '201');
INSERT INTO `ph_role_permission` VALUES ('302', '2', '202');
INSERT INTO `ph_role_permission` VALUES ('303', '2', '203');
INSERT INTO `ph_role_permission` VALUES ('304', '2', '204');
INSERT INTO `ph_role_permission` VALUES ('320', '2', '220');
INSERT INTO `ph_role_permission` VALUES ('321', '2', '221');
INSERT INTO `ph_role_permission` VALUES ('340', '2', '240');
INSERT INTO `ph_role_permission` VALUES ('341', '2', '241');
INSERT INTO `ph_role_permission` VALUES ('342', '2', '242');
INSERT INTO `ph_role_permission` VALUES ('360', '2', '260');
INSERT INTO `ph_role_permission` VALUES ('365', '2', '265');
INSERT INTO `ph_role_permission` VALUES ('366', '2', '266');
INSERT INTO `ph_role_permission` VALUES ('367', '2', '267');
INSERT INTO `ph_role_permission` VALUES ('368', '2', '268');
INSERT INTO `ph_role_permission` VALUES ('369', '2', '269');
INSERT INTO `ph_role_permission` VALUES ('370', '2', '270');
INSERT INTO `ph_role_permission` VALUES ('380', '2', '280');
INSERT INTO `ph_role_permission` VALUES ('381', '2', '281');
INSERT INTO `ph_role_permission` VALUES ('382', '2', '282');
INSERT INTO `ph_role_permission` VALUES ('383', '2', '283');
INSERT INTO `ph_role_permission` VALUES ('384', '2', '284');
INSERT INTO `ph_role_permission` VALUES ('400', '2', '300');
INSERT INTO `ph_role_permission` VALUES ('401', '2', '301');
INSERT INTO `ph_role_permission` VALUES ('402', '2', '302');
INSERT INTO `ph_role_permission` VALUES ('403', '2', '303');
INSERT INTO `ph_role_permission` VALUES ('404', '2', '304');
INSERT INTO `ph_role_permission` VALUES ('405', '2', '305');
INSERT INTO `ph_role_permission` VALUES ('410', '2', '320');
INSERT INTO `ph_role_permission` VALUES ('421', '2', '321');
INSERT INTO `ph_role_permission` VALUES ('422', '2', '322');
INSERT INTO `ph_role_permission` VALUES ('423', '2', '323');
INSERT INTO `ph_role_permission` VALUES ('424', '2', '324');
INSERT INTO `ph_role_permission` VALUES ('425', '2', '325');
INSERT INTO `ph_role_permission` VALUES ('426', '2', '326');
INSERT INTO `ph_role_permission` VALUES ('427', '2', '327');
INSERT INTO `ph_role_permission` VALUES ('428', '2', '328');
INSERT INTO `ph_role_permission` VALUES ('429', '2', '329');
INSERT INTO `ph_role_permission` VALUES ('430', '2', '330');
INSERT INTO `ph_role_permission` VALUES ('431', '2', '331');
INSERT INTO `ph_role_permission` VALUES ('432', '2', '332');
INSERT INTO `ph_role_permission` VALUES ('433', '2', '333');
INSERT INTO `ph_role_permission` VALUES ('434', '2', '334');
INSERT INTO `ph_role_permission` VALUES ('435', '2', '335');
INSERT INTO `ph_role_permission` VALUES ('436', '2', '336');
INSERT INTO `ph_role_permission` VALUES ('441', '2', '341');
INSERT INTO `ph_role_permission` VALUES ('442', '2', '342');
INSERT INTO `ph_role_permission` VALUES ('443', '2', '343');
INSERT INTO `ph_role_permission` VALUES ('444', '2', '344');
INSERT INTO `ph_role_permission` VALUES ('445', '2', '345');
INSERT INTO `ph_role_permission` VALUES ('446', '2', '346');
INSERT INTO `ph_role_permission` VALUES ('447', '2', '347');
INSERT INTO `ph_role_permission` VALUES ('448', '2', '348');
INSERT INTO `ph_role_permission` VALUES ('449', '2', '349');
INSERT INTO `ph_role_permission` VALUES ('450', '2', '350');
INSERT INTO `ph_role_permission` VALUES ('451', '2', '351');
INSERT INTO `ph_role_permission` VALUES ('452', '2', '352');
INSERT INTO `ph_role_permission` VALUES ('453', '2', '353');
INSERT INTO `ph_role_permission` VALUES ('454', '2', '354');
INSERT INTO `ph_role_permission` VALUES ('455', '2', '355');
INSERT INTO `ph_role_permission` VALUES ('456', '2', '356');
INSERT INTO `ph_role_permission` VALUES ('457', '2', '357');
INSERT INTO `ph_role_permission` VALUES ('458', '2', '358');
INSERT INTO `ph_role_permission` VALUES ('459', '2', '359');
INSERT INTO `ph_role_permission` VALUES ('460', '2', '360');
INSERT INTO `ph_role_permission` VALUES ('461', '2', '361');
INSERT INTO `ph_role_permission` VALUES ('462', '2', '362');
INSERT INTO `ph_role_permission` VALUES ('463', '2', '363');
INSERT INTO `ph_role_permission` VALUES ('480', '2', '380');
INSERT INTO `ph_role_permission` VALUES ('481', '2', '381');
INSERT INTO `ph_role_permission` VALUES ('482', '2', '382');
INSERT INTO `ph_role_permission` VALUES ('483', '2', '383');
INSERT INTO `ph_role_permission` VALUES ('484', '2', '384');
INSERT INTO `ph_role_permission` VALUES ('485', '2', '385');
INSERT INTO `ph_role_permission` VALUES ('486', '2', '386');
INSERT INTO `ph_role_permission` VALUES ('487', '2', '387');
INSERT INTO `ph_role_permission` VALUES ('501', '2', '401');
INSERT INTO `ph_role_permission` VALUES ('502', '2', '402');
INSERT INTO `ph_role_permission` VALUES ('503', '2', '403');
INSERT INTO `ph_role_permission` VALUES ('504', '2', '404');
INSERT INTO `ph_role_permission` VALUES ('505', '2', '405');
INSERT INTO `ph_role_permission` VALUES ('506', '2', '406');
INSERT INTO `ph_role_permission` VALUES ('507', '2', '407');
INSERT INTO `ph_role_permission` VALUES ('520', '2', '420');
INSERT INTO `ph_role_permission` VALUES ('521', '2', '421');
INSERT INTO `ph_role_permission` VALUES ('522', '2', '422');
INSERT INTO `ph_role_permission` VALUES ('540', '2', '440');
INSERT INTO `ph_role_permission` VALUES ('541', '2', '441');
INSERT INTO `ph_role_permission` VALUES ('542', '2', '442');
INSERT INTO `ph_role_permission` VALUES ('543', '2', '443');
INSERT INTO `ph_role_permission` VALUES ('544', '2', '444');
INSERT INTO `ph_role_permission` VALUES ('545', '2', '445');
INSERT INTO `ph_role_permission` VALUES ('546', '2', '446');
INSERT INTO `ph_role_permission` VALUES ('560', '2', '460');
INSERT INTO `ph_role_permission` VALUES ('561', '2', '461');
INSERT INTO `ph_role_permission` VALUES ('562', '2', '462');
INSERT INTO `ph_role_permission` VALUES ('563', '2', '463');
INSERT INTO `ph_role_permission` VALUES ('580', '2', '480');
INSERT INTO `ph_role_permission` VALUES ('581', '2', '481');
INSERT INTO `ph_role_permission` VALUES ('582', '2', '482');
INSERT INTO `ph_role_permission` VALUES ('583', '2', '483');
INSERT INTO `ph_role_permission` VALUES ('590', '2', '490');
INSERT INTO `ph_role_permission` VALUES ('591', '2', '491');
INSERT INTO `ph_role_permission` VALUES ('592', '2', '492');
INSERT INTO `ph_role_permission` VALUES ('593', '2', '493');
INSERT INTO `ph_role_permission` VALUES ('594', '2', '494');
INSERT INTO `ph_role_permission` VALUES ('595', '2', '495');
INSERT INTO `ph_role_permission` VALUES ('596', '2', '496');
INSERT INTO `ph_role_permission` VALUES ('610', '2', '510');
INSERT INTO `ph_role_permission` VALUES ('611', '2', '511');
INSERT INTO `ph_role_permission` VALUES ('612', '2', '512');
INSERT INTO `ph_role_permission` VALUES ('613', '2', '513');
INSERT INTO `ph_role_permission` VALUES ('614', '2', '514');
INSERT INTO `ph_role_permission` VALUES ('615', '2', '515');
INSERT INTO `ph_role_permission` VALUES ('616', '2', '516');

INSERT INTO `ph_role_permission` VALUES ('1000', '3', '2');
INSERT INTO `ph_role_permission` VALUES ('1001', '3', '19');
INSERT INTO `ph_role_permission` VALUES ('1002', '3', '140');
INSERT INTO `ph_role_permission` VALUES ('1003', '3', '150');
INSERT INTO `ph_role_permission` VALUES ('1004', '3', '170');
INSERT INTO `ph_role_permission` VALUES ('1005', '3', '171');
INSERT INTO `ph_role_permission` VALUES ('1006', '3', '172');
INSERT INTO `ph_role_permission` VALUES ('1007', '3', '173');
COMMIT;
