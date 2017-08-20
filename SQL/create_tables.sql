create table win_rates (
  id int(11) AUTO_INCREMENT NOT NULL,
	champion_id int(11) DEFAULT NULL,
	enemy_champion_id int(11) DEFAULT NULL,
	win_rate decimal(12,4) DEFAULT NULL,
	role varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `champion_id` (`champion_id`),
  KEY `enemy_champion_id` (`enemy_champion_id`),
  KEY `role` (`role`)
);

create table champions (
  champion_id int(11) NOT NULL,
  champion varchar(255) DEFAULT NULL,
  PRIMARY KEY (`champion_id`)
);
