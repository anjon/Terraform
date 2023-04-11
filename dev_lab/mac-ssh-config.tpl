cat << EOF >> /Users/anjon/.ssh/config

Host ${hostname}
    Hostname ${hostname}
    User ${user}
    IdentityFile ${identityfile}
EOF