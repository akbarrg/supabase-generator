#!/bin/bash

tables=( role_admin feature_permission )

for i in "${tables[@]}"
do
echo "alter table public.${i}
  enable row level security;

create policy "Individuals have all update to their own ${i}."
    on public.${i} for update
    to anon, authenticated
    using ( auth.uid() = user_id )
    with check ( auth.uid() = user_id );
    " >> output/authenticated-userid-update.sql
done