CREATE TABLE `registrations` (
  `username` varchar(255) NOT NULL,
  `id` varchar(255) DEFAULT NULL,
  `updatetime` datetime DEFAULT NULL,
  `partner` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  PRIMARY KEY (`username`) USING BTREE,
  KEY `idx_updatetime` (`updatetime`),
  KEY `idx_partner` (`partner`(255)),
  KEY `idx_username` (`username`(255)),
  KEY `idx_find_partner` (`username`(100),`updatetime`,`partner`(100),`status`(20))
);
--
--
--
CREATE TABLE `reports` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userip` varchar(255) NOT NULL,
  `reporteruserip` varchar(255) NOT NULL,
  `timestamp` datetime NOT NULL,
  `username` varchar(255) NOT NULL,
  `reporterusername` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);