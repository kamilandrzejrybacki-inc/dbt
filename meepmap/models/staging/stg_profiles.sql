select id as user_id, display_name, created_at
from {{ source('app','profiles') }}
