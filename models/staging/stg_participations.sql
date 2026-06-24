select id as participation_id, user_id, session_id, status, created_at
from {{ source('app','participations') }}
