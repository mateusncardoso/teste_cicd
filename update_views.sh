#!/bin/bash

project="eu-medico-residente"

for dataset_dir in */ ; do
  dataset=${dataset_dir%/}  # Remove trailing slash
  
  # Update regular views
  for view_sql in "$dataset/views/"*.sql; do
    view_name=${view_sql##*/}
    view_name=${view_name%.sql}

    # Construct the full SQL command
    full_sql="CREATE OR REPLACE VIEW \`${project}.${dataset}.${view_name}\` AS $(cat ${view_sql})"

    echo "Updating view $view_name in dataset $dataset..."
    bq query --use_legacy_sql=false --replace=true --project_id=$project --dataset_id=$dataset "${full_sql}"
  done
  
  # Materialize views
  for mview_sql in "$dataset/materialized_views/"*.sql; do
    mview_name=${mview_sql##*/}
    mview_name=${mview_name%.sql}

    # Read the schedule for the current view from the JSON file
    schedule=$(jq -r ".${mview_name}" schedules.json)

    echo "Materializing view $mview_name in dataset $dataset scheduled $schedule..."
    bq query --use_legacy_sql=false --replace=true --display_name=$mview_name --schedule="$schedule" --project_id=$project --destination_table=$dataset.$mview_name "$(cat $mview_sql)"
  done
done
