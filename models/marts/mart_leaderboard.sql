with hosted as (
  select host_id as user_id, count(*) as hosted
  from {{ ref('stg_sessions') }} where state in ('started','closed') group by 1
),
attended as (
  select user_id, count(*) as attended
  from {{ ref('stg_participations') }} where status = 'approved' group by 1
),
ach as (
  select user_id, count(*) as achievements from {{ ref('stg_user_achievements') }} group by 1
),
gms as (
  select p.user_id, count(distinct s.game_id) as distinct_games
  from {{ ref('stg_participations') }} p
  join {{ ref('stg_sessions') }} s on s.session_id = p.session_id
  where p.status = 'approved' and s.game_id is not null
  group by 1
)
select pr.user_id, pr.display_name,
       coalesce(h.hosted,0) + coalesce(a.attended,0) as sessions_played,
       coalesce(ac.achievements,0) as achievements_count,
       coalesce(g.distinct_games,0) as distinct_games,
       row_number() over (
         order by coalesce(ac.achievements,0) desc,
                  coalesce(h.hosted,0)+coalesce(a.attended,0) desc
       ) as rank
from {{ ref('stg_profiles') }} pr
left join hosted h on h.user_id = pr.user_id
left join attended a on a.user_id = pr.user_id
left join ach ac on ac.user_id = pr.user_id
left join gms g on g.user_id = pr.user_id
