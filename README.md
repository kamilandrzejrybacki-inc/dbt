# dbt — homelab

dbt project for homelab business metrics. Currently: MeepMap marts → Supabase `analytics` schema
(prod + test targets). Opens directly in the dbt-ui at dbt.kamilandrzejrybacki.dpdns.org.

`dbt deps && dbt build --target <prod|test>`. Connections from env (`DBT_<ENV>_HOST/USER/PASSWORD`).
Built daily by the `meepmap-dbt` k8s CronJob (helm `charts/dbt-job`).
