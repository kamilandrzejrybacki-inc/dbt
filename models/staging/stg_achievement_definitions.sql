select key, name, category, active, points
from {{ source('app','achievement_definitions') }}
