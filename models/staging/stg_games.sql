select id as game_id, slug, name, bgg_id, cover_url
from {{ source('app','games') }}
