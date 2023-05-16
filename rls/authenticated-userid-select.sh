#!/bin/bash

tables=( role_admin feature_permission )

for i in "${tables[@]}"
do
echo "alter table public.${i}
  enable row level security;

create policy "Individuals have read permission to their own ${i}."
    on public.${i} for select
    to anon, authenticated
    using ( auth.uid() = user_id );
    " >> output/authenticated-userid-read.sql
done