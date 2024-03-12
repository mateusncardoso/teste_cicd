#!/bin/bash

for dataset_dir in */ ; do
  dataset=${dataset_dir%/}  # Remove trailing slash
  for view_sql in "$dataset/views"/*.sql; do
    view_name=${view_sql##*/}  # Extract the filename
    view_name=${view_name%.sql}  # Remove the .sql extension
    echo "Updating view $view_name in dataset $dataset..."
    bq query --use_legacy_sql=false --replace=true --project_id=eu-medico-residente --dataset_id=$dataset --view="$(cat $view_sql)"
  done
done
