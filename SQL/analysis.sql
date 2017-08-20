

















select champion1, champion2, champion3, enemy_champion_id,
max(win_rate) highest_win_rate from win_rates fact
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

where role = 'MIDDLE' group by 1,2,3,4 order by 1;










  SELECT
  a.champion AS champion1,
  b.champion AS champion2,
  c.champion AS champion3

  FROM
  (select x.champion_id champ1, y.champion_id champ2, z.champion_id champ3
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
    a.champion_id = champ1
  INNER JOIN
    champions b on
    b.champion_id = champ2
  INNER JOIN
    champions c on
    c.champion_id = champ3
-- join with best chance for win rate

-- alphabetical order
where a.champion <= b.champion
and b.champion <= c.champion
order by 1,2,3
;
