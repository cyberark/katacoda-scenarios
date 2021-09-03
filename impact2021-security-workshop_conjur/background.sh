cat > conjur.bak << EOF
- !policy
  id: db

- !policy
  id: frontend
EOF

cat > db1.bak << EOF
# Declare the secrets which are used to access the database
- &variables
  - !variable password

# Define a group which will be able to fetch the secrets
- !group secrets-users

- !permit
  resource: *variables
  # "read" privilege allows the client to read metadata.
  # "execute" privilege allows the client to read the secret data.
  # These are normally granted together, but they are distinct
  #   just like read and execute bits on a filesystem.
  privileges: [ read, execute ]
  roles: !group secrets-users
EOF

cat > db2.bak << EOF
- &variables
  - !variable password

- !group secrets-users

- !permit
  resource: *variables
  privileges: [ read, execute ]
  roles: !group secrets-users

# Entitlements

- !grant
  role: !group secrets-users
  member: !layer /frontend
EOF

cat > frontend.bak << EOF
- !layer

- !host frontend-01

- !grant
  role: !layer
  member: !host frontend-01
EOF

clear
