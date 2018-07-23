# knife_inspec
A sample drop-in knife plugin that executes inspec commands via SSH.

# Syntax
```
knife inspec -q <query> -c <command> [-u <user> -k <keyfile>]
```
  
# Arguments
```
  <query> - A Chef search query.  Defaults to *, so overriding this is highly recommended.
  <command> - The InSpec command to run.  Defaults to 'detect'.
  <user> - The SSH user to connect as.  Defaults to 'chef'.
  <keyfile> - The SSH keyfile to use.  Defaults to '~/.ssh/id_dsa'.
```
