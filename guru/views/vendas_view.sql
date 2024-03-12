create or replace view `eu-medico-residente.guru.vendas_view`
OPTIONS(
description="the latest representation of each cart"
)
as
select * from `eu-medico-residente.guru.vendas` limit 15
