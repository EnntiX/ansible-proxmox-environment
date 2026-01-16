#!/bin/bash

DATE=$(date +%F)

{% for item in backup_sources %}
DEST="{{ backup_base_dir }}/{{ item.name }}/$DATE"

mkdir -p "$DEST"

rsync -av --delete --rsync-path="sudo rsync" ansible@{{ item.host }}:{{ item.path }}/ "$DEST/"
{% endfor %}

