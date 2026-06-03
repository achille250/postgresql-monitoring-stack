--- check active vs idle connection on db
SELECT count(*),state FROM pg_stat_activity GROUP BY 2;

----- check used and and reselved connections for users

select max_conn, used, res_for_super, max_conn - used - res_for_super res_for_normal 
from (
  select count(*) used from pg_stat_activity
) t1,
(select setting::int res_for_super 
 from pg_settings 
 where name=$$superuser_reserved_connections$$
) t2,
(select setting::int max_conn 
 from pg_settings 
 where name=$$max_connections$$) t3;
 SELECT count(*),state FROM pg_stat_activity GROUP BY 2;
 --- drop idle connection on db
 SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE datname = 'sacco_migration'
  AND pid <> pg_backend_pid()
  and state='idle';