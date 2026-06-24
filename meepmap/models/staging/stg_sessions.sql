select id as session_id, host_id, game_id, title, scheduled_at, venue_name, state, created_at
from {{ source('app','sessions') }}
