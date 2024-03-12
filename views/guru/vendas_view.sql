create or replace view `<project_id>.guru.view_vendas_teste`
OPTIONS(
description="the latest representation of each cart"
)
as
select * from `<project_id>.guru.vendas` limit 100
