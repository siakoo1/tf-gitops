#!/bin/bash

for file in *.yaml
do
    gcloud deploy apply --file=$file --region=us-central1
done