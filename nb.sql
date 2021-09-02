CREATE DATABASE IF NOT EXISTS `yourdatabase` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `yourdatabase`;
CREATE TABLE IF NOT EXISTS `citizens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `citizen_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
  `packeddata` mediumtext CHARACTER SET utf8,
  `statusdata` mediumtext CHARACTER SET utf8,
  `inventory` longtext CHARACTER SET utf8,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `License` (`license`) USING BTREE,
  KEY `last_updated` (`last_updated`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(64) NOT NULL,
  `playername` varchar(64) NOT NULL,
  `admin_level` int(4) NOT NULL DEFAULT '0',
  `otherlicenses` varchar(256) DEFAULT NULL,
  `ip` char(16) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `last_updated` (`last_updated`) USING BTREE,
  KEY `license` (`license`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `vehicle_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
  `packeddata` mediumtext CHARACTER SET utf8,
  `statusdata` mediumtext CHARACTER SET utf8,
  `moddata` longtext CHARACTER SET utf8,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `License` (`citizen_id`) USING BTREE,
  KEY `last_updated` (`last_updated`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;