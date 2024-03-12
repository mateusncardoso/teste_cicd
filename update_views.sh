#!/bin/bash

project="eu-medico-residente"

for dataset_dir in */ ; do
  dataset=${dataset_dir%/}  # Remove trailing slash
  
  # Update regular views
  for view_sql in "$dataset/views/"*.sql; do
    view_name=${view_sql##*/}
    view_name=${view_name%.sql}
    echo "Updating view $view_name in dataset $dataset..."
    bq query --use_legacy_sql=false --replace=true --project_id=$project --dataset_id=$dataset --view="$(cat $view_sql)"
  done
  
  # Materialize views
  for mview_sql in "$dataset/materialized_views/"*.sql; do
    mview_name=${mview_sql##*/}
    mview_name=${mview_name%.sql}
    echo "Materializing view $mview_name in dataset $dataset..."
    bq query --use_legacy_sql=false --replace=true --display_name=$mview_name --schedule='every 24 hours' --project_id=$project --destination_table=$dataset.$mview_name "$(cat $mview_sql)"
  done
done
