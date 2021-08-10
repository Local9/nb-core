-- --------------------------------------------------------
-- 主机:                           192.168.23.128
-- 服务器版本:                        5.7.31 - MySQL Community Server (GPL)
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- 导出 nbgfv 的数据库结构
CREATE DATABASE IF NOT EXISTS `nbgfv` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `nbgfv`;

-- 导出  表 nbgfv.characters 结构
CREATE TABLE IF NOT EXISTS `characters` (
  `license` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `citizen_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
  `position` text,
  `skin` mediumtext,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `License` (`license`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 正在导出表  nbgfv.characters 的数据：0 rows
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- 导出  表 nbgfv.users 结构
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(64) NOT NULL,
  `admin_level` int(4) NOT NULL DEFAULT '0',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `last_updated` (`last_updated`) USING BTREE,
  KEY `license` (`license`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4240 DEFAULT CHARSET=utf8mb4;

-- 正在导出表  nbgfv.users 的数据：~1 rows (大约)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
