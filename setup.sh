#!/usr/bin/bash

echo "for file in ~/bin/cmds/util/*.sh; do [ -r \"$file\" ] && source \"$file\" done" >> ~/.bashrc

echo "source ~/bin/cmds/util/eutils.sh" >> ~/.bashrc
echo "source ~/bin/cmds/util/colors.sh" >> ~/.bashrc
echo "[SETUP] Eutils installed."
