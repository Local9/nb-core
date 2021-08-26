-- --------------------------------------------------------
-- 主机:                           192.168.23.128
-- 服务器版本:                        5.7.31 - MySQL Community Server (GPL)
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- 导出 nb_database 的数据库结构
CREATE DATABASE IF NOT EXISTS `nb_database` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `nb_database`;

-- 导出  表 nb_database.citizens 结构
CREATE TABLE IF NOT EXISTS `citizens` (
  `license` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `citizen_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
  `packeddata` mediumtext CHARACTER SET utf8,
  `test` varchar(50) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `License` (`license`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 正在导出表  nb_database.citizens 的数据：0 rows
/*!40000 ALTER TABLE `citizens` DISABLE KEYS */;
/*!40000 ALTER TABLE `citizens` ENABLE KEYS */;

-- 导出  表 nb_database.users 结构
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(64) NOT NULL,
  `admin_level` int(4) NOT NULL DEFAULT '0',
  `otherlicenses` varchar(256) DEFAULT NULL,
  `ip` char(16) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `last_updated` (`last_updated`) USING BTREE,
  KEY `license` (`license`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4;

-- 正在导出表  nb_database.users 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
