with players as (select count(*)::numeric as total from {{ ref('stg_profiles') }}),
held as (
  select key, count(distinct user_id) as holders
  from {{ ref('stg_user_achievements') }} group by 1
)
select d.key, d.name,
       coalesce(h.holders, 0) as holders,
       p.total::int as total_players,
       round(100.0 * coalesce(h.holders,0) / nullif(p.total,0), 2) as rarity_pct
from {{ ref('stg_achievement_definitions') }} d
cross join players p
left join held h on h.key = d.key
where d.active is true
