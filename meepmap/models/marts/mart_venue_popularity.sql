select s.venue_name,
       count(*) as plays,
       count(distinct p.user_id) as distinct_players,
       count(*) filter (where s.scheduled_at >= now() - interval '30 days') as plays_30d,
       (count(*) filter (where s.scheduled_at >= now() - interval '30 days')
        - count(*) filter (where s.scheduled_at >= now() - interval '60 days'
                             and s.scheduled_at < now() - interval '30 days')) as trend
from {{ ref('stg_sessions') }} s
left join {{ ref('stg_participations') }} p on p.session_id = s.session_id and p.status='approved'
where coalesce(s.venue_name,'') <> ''
group by 1
