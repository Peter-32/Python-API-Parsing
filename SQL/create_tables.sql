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


create table agg_win_rates (
  role varchar(255) DEFAULT NULL,
  champion1 varchar(255) DEFAULT NULL,
  champion2 varchar(255) DEFAULT NULL,
  champion3 varchar(255) DEFAULT NULL,
  avg_win_rate_best_pick decimal(12,4) DEFAULT NULL,
  number_of_champions_in_role int(11) DEFAULT NULL,
  matchups_considered int(11) DEFAULT NULL,
  avg_champ1_winrate decimal(12,4) DEFAULT NULL,
  avg_champ2_winrate decimal(12,4) DEFAULT NULL,
  avg_champ3_winrate decimal(12,4) DEFAULT NULL
);



-- insert into win_rates with main.py
-- insert into champions with read_in_champions.py
-- insert into agg_win_rates next with the code below




INSERT INTO agg_win_rates (role, champion1, champion2, champion3, avg_win_rate_best_pick,
number_of_champions_in_role, matchups_considered, avg_champ1_winrate, avg_champ2_winrate, avg_champ3_winrate)
select 'MIDDLE' AS role, champion1, champion2, champion3,
    avg(highest_win_rate) AS avg_win_rate_best_pick, max(number_of_champions_in_role) number_of_champions_in_role,
    count(distinct enemy_champion_id) AS matchups_considered,
    sum(champ1_winrate)/SUM(IF(champ1_winrate!=0,1,0)) AS avg_champ1_winrate,
    sum(champ2_winrate)/SUM(IF(champ2_winrate!=0,1,0)) AS avg_champ2_winrate,
    sum(champ3_winrate)/SUM(IF(champ3_winrate!=0,1,0)) AS avg_champ3_winrate from
    (
    select champion1, champion2, champion3, enemy_champion_id,
    max(win_rate) highest_win_rate, MAX(IF(fact.champion_id = champion1_id, win_rate, 0)) AS champ1_winrate,
    MAX(IF(fact.champion_id = champion2_id, win_rate, 0)) AS champ2_winrate,
    MAX(IF(fact.champion_id = champion3_id, win_rate, 0)) AS champ3_winrate from win_rates fact
    INNER JOIN
        (  SELECT
          a.champion AS champion1,
          b.champion AS champion2,
          c.champion AS champion3,
          champion1_id AS champion1_id,
          champion2_id AS champion2_id,
          champion3_id AS champion3_id

          FROM
          (select x.champion_id champion1_id, y.champion_id champion2_id, z.champion_id champion3_id
          FROM
          (select distinct champion_id from win_rates where role = 'MIDDLE') x
          INNER JOIN
          (select distinct champion_id from win_rates where role = 'MIDDLE') y on
          x.champion_id != y.champion_id
          INNER JOIN
          (select distinct champion_id from win_rates where role = 'MIDDLE') z on
          x.champion_id != z.champion_id and y.champion_id != z.champion_id
          ) three_champions
          INNER JOIN
            champions a on
            a.champion_id = champion1_id
          INNER JOIN
            champions b on
            b.champion_id = champion2_id
          INNER JOIN
            champions c on
            c.champion_id = champion3_id
        -- join with best chance for win rate

        -- alphabetical order
        where a.champion <= b.champion
        and b.champion <= c.champion
        order by 1,2,3) all_combinations on
        fact.champion_id IN (all_combinations.champion1_id,all_combinations.champion2_id,all_combinations.champion3_id)

    where role = 'MIDDLE' group by 1,2,3,4 order by 1
    ) x
CROSS JOIN (select count(distinct enemy_champion_id) number_of_champions_in_role from win_rates where role = 'MIDDLE') z
 group by 1,2,3,4
 having matchups_considered > (.90 * number_of_champions_in_role) -- 90% matchups found at least
 order by avg_win_rate_best_pick desc
 ;




 INSERT INTO agg_win_rates (role, champion1, champion2, champion3, avg_win_rate_best_pick,
 number_of_champions_in_role, matchups_considered, avg_champ1_winrate, avg_champ2_winrate, avg_champ3_winrate)
 select 'JUNGLE' AS role, champion1, champion2, champion3,
     avg(highest_win_rate) AS avg_win_rate_best_pick, max(number_of_champions_in_role) number_of_champions_in_role,
     count(distinct enemy_champion_id) AS matchups_considered,
     sum(champ1_winrate)/SUM(IF(champ1_winrate!=0,1,0)) AS avg_champ1_winrate,
     sum(champ2_winrate)/SUM(IF(champ2_winrate!=0,1,0)) AS avg_champ2_winrate,
     sum(champ3_winrate)/SUM(IF(champ3_winrate!=0,1,0)) AS avg_champ3_winrate from
     (
     select champion1, champion2, champion3, enemy_champion_id,
     max(win_rate) highest_win_rate, MAX(IF(fact.champion_id = champion1_id, win_rate, 0)) AS champ1_winrate,
     MAX(IF(fact.champion_id = champion2_id, win_rate, 0)) AS champ2_winrate,
     MAX(IF(fact.champion_id = champion3_id, win_rate, 0)) AS champ3_winrate from win_rates fact
     INNER JOIN
         (  SELECT
           a.champion AS champion1,
           b.champion AS champion2,
           c.champion AS champion3,
           champion1_id AS champion1_id,
           champion2_id AS champion2_id,
           champion3_id AS champion3_id

           FROM
           (select x.champion_id champion1_id, y.champion_id champion2_id, z.champion_id champion3_id
           FROM
           (select distinct champion_id from win_rates where role = 'JUNGLE') x
           INNER JOIN
           (select distinct champion_id from win_rates where role = 'JUNGLE') y on
           x.champion_id != y.champion_id
           INNER JOIN
           (select distinct champion_id from win_rates where role = 'JUNGLE') z on
           x.champion_id != z.champion_id and y.champion_id != z.champion_id
           ) three_champions
           INNER JOIN
             champions a on
             a.champion_id = champion1_id
           INNER JOIN
             champions b on
             b.champion_id = champion2_id
           INNER JOIN
             champions c on
             c.champion_id = champion3_id
         -- join with best chance for win rate

         -- alphabetical order
         where a.champion <= b.champion
         and b.champion <= c.champion
         order by 1,2,3) all_combinations on
         fact.champion_id IN (all_combinations.champion1_id,all_combinations.champion2_id,all_combinations.champion3_id)

     where role = 'JUNGLE' group by 1,2,3,4 order by 1
     ) x
 CROSS JOIN (select count(distinct enemy_champion_id) number_of_champions_in_role from win_rates where role = 'JUNGLE') z
  group by 1,2,3,4
  having matchups_considered > (.90 * number_of_champions_in_role) -- 90% matchups found at least
  order by avg_win_rate_best_pick desc
  ;




  INSERT INTO agg_win_rates (role, champion1, champion2, champion3, avg_win_rate_best_pick,
  number_of_champions_in_role, matchups_considered, avg_champ1_winrate, avg_champ2_winrate, avg_champ3_winrate)
  select 'TOP' AS role, champion1, champion2, champion3,
      avg(highest_win_rate) AS avg_win_rate_best_pick, max(number_of_champions_in_role) number_of_champions_in_role,
      count(distinct enemy_champion_id) AS matchups_considered,
      sum(champ1_winrate)/SUM(IF(champ1_winrate!=0,1,0)) AS avg_champ1_winrate,
      sum(champ2_winrate)/SUM(IF(champ2_winrate!=0,1,0)) AS avg_champ2_winrate,
      sum(champ3_winrate)/SUM(IF(champ3_winrate!=0,1,0)) AS avg_champ3_winrate from
      (
      select champion1, champion2, champion3, enemy_champion_id,
      max(win_rate) highest_win_rate, MAX(IF(fact.champion_id = champion1_id, win_rate, 0)) AS champ1_winrate,
      MAX(IF(fact.champion_id = champion2_id, win_rate, 0)) AS champ2_winrate,
      MAX(IF(fact.champion_id = champion3_id, win_rate, 0)) AS champ3_winrate from win_rates fact
      INNER JOIN
          (  SELECT
            a.champion AS champion1,
            b.champion AS champion2,
            c.champion AS champion3,
            champion1_id AS champion1_id,
            champion2_id AS champion2_id,
            champion3_id AS champion3_id

            FROM
            (select x.champion_id champion1_id, y.champion_id champion2_id, z.champion_id champion3_id
            FROM
            (select distinct champion_id from win_rates where role = 'TOP') x
            INNER JOIN
            (select distinct champion_id from win_rates where role = 'TOP') y on
            x.champion_id != y.champion_id
            INNER JOIN
            (select distinct champion_id from win_rates where role = 'TOP') z on
            x.champion_id != z.champion_id and y.champion_id != z.champion_id
            ) three_champions
            INNER JOIN
              champions a on
              a.champion_id = champion1_id
            INNER JOIN
              champions b on
              b.champion_id = champion2_id
            INNER JOIN
              champions c on
              c.champion_id = champion3_id
          -- join with best chance for win rate

          -- alphabetical order
          where a.champion <= b.champion
          and b.champion <= c.champion
          order by 1,2,3) all_combinations on
          fact.champion_id IN (all_combinations.champion1_id,all_combinations.champion2_id,all_combinations.champion3_id)

      where role = 'TOP' group by 1,2,3,4 order by 1
      ) x
  CROSS JOIN (select count(distinct enemy_champion_id) number_of_champions_in_role from win_rates where role = 'TOP') z
   group by 1,2,3,4
   having matchups_considered > (.90 * number_of_champions_in_role) -- 90% matchups found at least
   order by avg_win_rate_best_pick desc
   ;
