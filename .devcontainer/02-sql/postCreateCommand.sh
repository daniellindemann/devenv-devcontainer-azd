#!/bin/bash

script_dir=$(dirname "$0")

echo "THE SCRIPT DIR IS: $script_dir"

# call mssql postCreateCommand.sh
# postCreateCommand.sh parameters: $1=host, $2=SA password, $3=dacpac path, $4=sql script(s) path
"$script_dir/mssql/postCreateCommand.sh" 'db' 'P@ssw0rd' './bin/Debug' "$script_dir/mssql"

# dotnet tools install
dotnet tool install --global dotnet-ef

# do a dotnet workload update - if it's required do it ...
# dotnet workload update

# set user secrets in backend project to use sql server
# and apply ef migrations
pushd "$script_dir/../../src/Demo.BeerVoting.Backend"
dotnet user-secrets set "Database:UseInMemoryDatabase" "false"
dotnet user-secrets set "ConnectionStrings:Beer" "Server=tcp:db,1433;Database=ApplicationDB;User ID=sa;Password=P@ssw0rd;Trusted_Connection=False;Encrypt=False;"
dotnet ef database update
popd
