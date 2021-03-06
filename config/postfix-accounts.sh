#!/bin/bash
# See also: https://github.com/TK-IT/meta/wiki/Guide:-Tilf%C3%B8j-fjern-foreningsmedlemmers-SMTP-adgang
# Run this script after running postfix-accounts/adduser.sh

set -euo pipefail

ACCOUNTS_INPUT=postfix-accounts/postfix-accounts.txt
ACCOUNTS_TMP=postfix-accounts.cf.tmp
ACCOUNTS_OUTPUT=postfix-accounts.cf

if ! [ -r "$ACCOUNTS_INPUT" ]; then
	echo "Cannot read $ACCOUNTS_INPUT; exiting" >&2
	exit
fi

if ! [ -w "$ACCOUNTS_OUTPUT" ]; then
	echo "Cannot write $ACCOUNTS_OUTPUT; exiting" >&2
	exit
fi

echo "# Se: https://github.com/tomav/docker-mailserver/wiki/Configure-Accounts" > "$ACCOUNTS_TMP"
echo "# Se også: https://github.com/TK-IT/meta/wiki/Guide:-Tilf%C3%B8j-fjern-foreningsmedlemmers-SMTP-adgang" >> "$ACCOUNTS_TMP"
while read username password; do
echo "$username|`doveadm pw -s SHA512-CRYPT -u $username -p $password`"
done < "$ACCOUNTS_INPUT" >> "$ACCOUNTS_TMP"
mv -f "$ACCOUNTS_TMP" "$ACCOUNTS_OUTPUT"
