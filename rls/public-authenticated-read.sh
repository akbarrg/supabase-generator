#!/bin/bash

tables=( role_admin feature_permission )

for i in "${tables[@]}"
do
echo "alter table public.${i}
  enable row level security;

create policy "All logged in users can read ${i}"
    on public.${i} for select
    to anon, authenticated
    using ( true );
    " >> output/public-authenticated-read.sql
done