select user_id, key, unlocked_at
from {{ source('app','user_achievements') }}
