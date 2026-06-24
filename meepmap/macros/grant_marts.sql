{% macro grant_marts() %}
  {% set marts = ['mart_achievement_rarity','mart_leaderboard','mart_game_popularity','mart_venue_popularity','mart_player_stats'] %}
  {% for m in marts %}
    grant select on analytics.{{ m }} to anon, authenticated;
    alter table analytics.{{ m }} enable row level security;
    drop policy if exists {{ m }}_read on analytics.{{ m }};
    create policy {{ m }}_read on analytics.{{ m }} for select using (true);
  {% endfor %}
{% endmacro %}
