with base as (
  select s.game_id, g.name,
         count(*) as plays,
         count(distinct p.user_id) as distinct_players,
         count(*) filter (where s.scheduled_at >= now() - interval '30 days') as plays_30d,
         count(*) filter (where s.scheduled_at >= now() - interval '60 days'
                            and s.scheduled_at < now() - interval '30 days') as plays_prev30
  from {{ ref('stg_sessions') }} s
  join {{ ref('stg_games') }} g on g.game_id = s.game_id
  left join {{ ref('stg_participations') }} p on p.session_id = s.session_id and p.status='approved'
  where s.game_id is not null
  group by 1,2
)
select game_id, name, plays, distinct_players, plays_30d,
       (plays_30d - plays_prev30) as trend
from base
