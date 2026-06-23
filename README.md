# meepmap-dbt

dbt project building MeepMap business-metric marts into the Supabase `analytics` schema.
Run daily by the `meepmap-dbt` k8s CronJob (helm). Targets: `prod` + `test` (both eu-west-1 pooler).

Marts: `mart_achievement_rarity`, `mart_leaderboard`, `mart_game_popularity`,
`mart_venue_popularity`, `mart_player_stats`. App reads via `supabase.schema('analytics')`.

`dbt build --target prod` (or `test`). Connection from env: `DBT_<ENV>_HOST/USER/PASSWORD`.
