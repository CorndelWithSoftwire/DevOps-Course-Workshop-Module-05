#!/bin/bash

newData=`curl -s https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson`
echo $newData | jq '.features[]' | jq '[.properties.place, .geometry.coordinates[0,1], .properties.mag]' | jq '((.[2]|tostring) + "|" + (.[1]|tostring) + "|" + .[0] + "|" + (.[3]|tostring))' | jq -r . > hour.chi
./cliapp -i hour.chi --dataset-name 'all_hour'
rm hour.chi
echo "Dataset 'all_hour' created."

newData=`curl -s https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson`
echo $newData | jq '.features[]' | jq '[.properties.place, .geometry.coordinates[0,1], .properties.mag]' | jq '((.[2]|tostring) + "|" + (.[1]|tostring) + "|" + .[0] + "|" + (.[3]|tostring))' | jq -r . > hour.chi
./cliapp -i hour.chi --dataset-name 'all_day'
rm hour.chi
echo "Dataset 'all_day' created."

newData=`curl -s https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson`
echo $newData | jq '.features[]' | jq '[.properties.place, .geometry.coordinates[0,1], .properties.mag]' | jq '((.[2]|tostring) + "|" + (.[1]|tostring) + "|" + .[0] + "|" + (.[3]|tostring))' | jq -r . > hour.chi
./cliapp -i hour.chi --dataset-name 'all_week'
rm hour.chi
echo "Dataset 'all_week' created."