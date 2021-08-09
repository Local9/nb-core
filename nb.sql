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


-- 导出 databaseName 的数据库结构
CREATE DATABASE IF NOT EXISTS `databaseName` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `databaseName`;

-- 导出  表 databaseName.characters 结构
CREATE TABLE IF NOT EXISTS `characters` (
  `License` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `CitizenID` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
  `Position` text,
  `Skin` mediumtext,
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `License` (`License`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 正在导出表  databaseName.characters 的数据：1 rows
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- 导出  表 databaseName.users 结构
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `License` varchar(64) NOT NULL,
  `AdminLevel` int(4) NOT NULL DEFAULT '0',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `last_updated` (`LastUpdated`) USING BTREE,
  KEY `license` (`License`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4238 DEFAULT CHARSET=utf8mb4;

-- 正在导出表  databaseName.users 的数据：~1 rows (大约)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
