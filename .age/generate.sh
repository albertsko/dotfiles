#!/usr/bin/env bash
set -euo pipefail

age-keygen -o /tmp/key-plaintext.txt
age -p -a -o identity.age /tmp/key-plaintext.txt
age-keygen -y /tmp/key-plaintext.txt >recipient.txt
rm -f /tmp/key-plaintext.txt
