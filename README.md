# dbt — homelab monorepo

General dbt project repository. Each business domain is a subdirectory holding its own dbt project
(`dbt_project.yml`, `models/`, `profiles.yml`, `requirements.txt`).

## Projects
- **`meepmap/`** — MeepMap business-metric marts → Supabase `analytics` schema (prod + test targets).

## Running
Per-project: `cd <project> && dbt deps && dbt build --target <prod|test>`.
Connections come from env (`DBT_<ENV>_HOST/USER/PASSWORD`); see each project's `profiles.yml`.
Built daily by the `dbt-job` k8s CronJob (one app per project, `projectDir` = the subdir), and editable
in the shared dbt-ui at dbt.kamilandrzejrybacki.dpdns.org.
