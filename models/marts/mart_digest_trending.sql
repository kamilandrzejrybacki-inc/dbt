{{ config(schema='content', materialized='table', alias='digest_trending') }}

-- The current week's BGG trending games, ranked. The digest-send route reads
-- this mart. Limited to 8 — the email shows the top of the hotness list.
select
  bgg_id, name, year, min_players, max_players, playing_time,
  weight, bgg_rank, hot_rank, image_url, thumbnail_url
from {{ source('catalog', 'bgg_games') }}
where hot_rank is not null
order by hot_rank
limit 8
