CREATE TABLE `social_grid_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) DEFAULT NULL,
  `text` varchar(160) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `approved` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `social_id` varchar(30) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `social_id` (`social_id`)
);
CREATE TABLE `social_grid_shown` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `par_ind` (`parent_id`),
  CONSTRAINT `social_grid_shown_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `social_grid_data` (`id`) ON DELETE CASCADE
);