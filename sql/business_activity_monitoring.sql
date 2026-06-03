----MONITORING DB DAY ACTIVIT

------stage operations by Saccos 

SELECT pr.name, ae.full_name, pe.start_time, stage, pe.end_time
FROM period pr INNER JOIN prd_period_execution pe ON pr.id = pe.period_id
INNER JOIN adm_admin_entity ae ON ae.id = pe.entity_id
--INNER JOIN prd_stage_execution se ON se.
WHERE pr.start_date ='2021-09-01' ORDER by end_time

------operation done by day

SELECT  count(*) FROM op_operation WHERE value_date ='2021-09-1'

-------operation done  by types

SELECT operation_type,  count(*) FROM op_operation WHERE value_date ='2021-09-1'
group by operation_type

-----operation by type and   institution

SELECT ad.full_name,operation_type,  count(*) FROM op_operation op
inner join adm_admin_entity ad 
on op.branch_id=ad.id
WHERE value_date ='2021-09-2'
group by full_name, operation_type



-----TRANSACTION BY HOUR


SELECT operation_type, extract(HOUR FROM operation_date) as hour, count(*) as cash_operaton FROM op_operation WHERE value_date ='2021-09-1'
AND operation_type IN ('WITHDRAW', 'DEPOSIT')
GROUP BY operation_type,  hour