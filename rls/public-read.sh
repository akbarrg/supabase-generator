#!/bin/bash

tables=( role_admin feature_permission )

for i in "${tables[@]}"
do
echo "alter table public.${i}
  enable row level security;

create policy "All users can read ${i}"
    on public.${i} for select
    using ( true );
    " >> output/public-read.sql
done