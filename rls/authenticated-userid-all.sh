#!/bin/bash

echo "Hi, Im RLS generator, which database that you want to generate?"

read database

echo "What permission(s) that you want to grant? (select, insert, update, delete, all)"

read permission

user_tables=(  )
catalogue_tables=(  )
trade_tables=(  )
common_tables=(  )
notification_tables=(  )

generate() {
  rm output/*
  echo "Generating RLS for ${database} database..."
  tables=("$@")
  PERM=""

  if [[ ${permission} == "update" || ${permission} == "all" ]]
  then
    PERM="using ( auth.uid() = buyer_account_id ) with check ( auth.uid() = buyer_account_id );"
  elif [[ ${permission} == "insert" ]]
  then
    PERM="with check ( auth.uid() = buyer_account_id );"
  else
    PERM="using ( auth.uid() = buyer_account_id );"
  fi

  echo ${PERM}
  echo "${tables[@]}"

  for i in "${tables[@]}"
  do
  echo "alter table public.${i}
enable row level security;

create policy \"${permission} permission to their own ${i}.\"
on public.${i} for ${permission}
to anon, authenticated
${PERM}" >> output/${database}-authenticated-userid-${permission}.sql
  done

  echo "RLS generated!"
}

if [[ ${database} == "user" ]]
then
  generate "${user_tables[@]}"
elif [[ ${database} == "catalogue" ]]
then
  generate "${catalogue_tables[@]}"
elif [[ ${database} == "trade" ]]
then
  generate "${trade_tables[@]}"
elif [[ ${database} == "common" ]]
then
  generate "${common_tables[@]}"
elif [[ ${database} == "notification" ]]
then
  generate "${notification_tables[@]}"
else
  echo "Sorry, Database not found!"
fi