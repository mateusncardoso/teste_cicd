#!/bin/bash

# Iterate over dataset directories
for dataset_dir in */ ; do
  dataset=${dataset_dir%/}  # Remove trailing slash from dataset directory name
  
  # Check for 'views' subdirectory and process SQL files
  if [ -d "$dataset/views" ]; then
    for view_sql in "$dataset/views/"*.sql; do
      view_name=$(basename "${view_sql}" .sql)  # Extract view name from file name
      
      echo "Updating view ${view_name} in dataset ${dataset}..."
      
      # Construct the full path for the dataset and view
      full_view_path="eu-medico-residente.${dataset}.${view_name}"
      
      # Read SQL query from file
      sql=$(cat "${view_sql}")
      echo "${sql}"
      # Use bq query to execute the SQL for creating/updating the view
      bq query --use_legacy_sql=false --project_id="eu-medico-residente" --replace=true "${sql}"
      
      if [ $? -eq 0 ]; then
        echo "Successfully updated view: ${full_view_path}"
      else
        echo "Failed to update view: ${full_view_path}"
        exit 1
      fi
    done
  fi
done
