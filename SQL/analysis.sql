select
  champion_id,
  enemy_champion_id,
  win_rate
from
  win_rates
where
  role = 'MIDDLE'


  SELECT
  a.champion,
  b.champion,
  c.champion

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
