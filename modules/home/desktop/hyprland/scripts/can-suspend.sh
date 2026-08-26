#!/usr/bin/env bash

systemd-inhibit --list --mode=block | tail -n +2 | grep -q "sleep" && exit 1
exit 0

