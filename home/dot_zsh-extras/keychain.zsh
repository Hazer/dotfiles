function keychain-environment-variable() {
    security find-generic-password -w -a ${USER} -D "environment variable" -s "${1}"
}

function set-keychain-environment-variable() {
    [ -n "$1" ] || print "Missing environment variable name"

    read -s "?Enter Value for ${1}: " secret

    ( [ -n "$1" ] && [ -n "$secret" ] ) || return 1
    security add-generic-password -U -a ${USER} -D "environment variable" -s "${1}" -w "${secret}"
}
