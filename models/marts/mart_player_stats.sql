with hosted as (
  select host_id as user_id, count(*) as sessions_hosted
  from {{ ref('stg_sessions') }} where state in ('started','closed') group by 1
),
attended as (
  select user_id, count(*) as sessions_attended
  from {{ ref('stg_participations') }} where status='approved' group by 1
),
gms as (
  select p.user_id, count(distinct s.game_id) as distinct_games
  from {{ ref('stg_participations') }} p join {{ ref('stg_sessions') }} s on s.session_id=p.session_id
  where p.status='approved' and s.game_id is not null group by 1
),
ach as (select user_id, count(*) as achievements_count from {{ ref('stg_user_achievements') }} group by 1),
active_days as (
  select p.user_id, count(distinct s.scheduled_at::date) as streak_days
  from {{ ref('stg_participations') }} p join {{ ref('stg_sessions') }} s on s.session_id=p.session_id
  where p.status='approved' and s.scheduled_at >= now() - interval '30 days'
  group by 1
)
select pr.user_id,
       coalesce(h.sessions_hosted,0) as sessions_hosted,
       coalesce(a.sessions_attended,0) as sessions_attended,
       coalesce(h.sessions_hosted,0)+coalesce(a.sessions_attended,0) as sessions_played,
       coalesce(g.distinct_games,0) as distinct_games,
       coalesce(ac.achievements_count,0) as achievements_count,
       coalesce(ad.streak_days,0) as streak_days
from {{ ref('stg_profiles') }} pr
left join hosted h on h.user_id=pr.user_id
left join attended a on a.user_id=pr.user_id
left join gms g on g.user_id=pr.user_id
left join ach ac on ac.user_id=pr.user_id
left join active_days ad on ad.user_id=pr.user_id
