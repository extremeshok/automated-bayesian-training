#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Automated Bayesain Training Script for Spam Assassin
# Version 1.0
# 18 December 2013
# Copyright (c) Adrian Jon Kriel : root-at-extremecooling-dot-org
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
####################
#
# Train ham and spam, ignore folders with could lead to a possible false positives
# Does each directory in turn, to prevent procwatch from killing sa-learn or overloading the process
#
####################

# Train ham (ignore outgoing mail & deleted mail that may be spam or ham)
# Do each directory in turn so that procwatch doesn't kill sa-learn
#
echo "Training HAM"
find /var/vmail/vmail1/ -name cur | egrep -i -v '(.spam)|(.trash)|(.sent)|(.junk)|(.deleted)|(.drafts)|(.outbox)' | while read i; do
 /usr/bin/sa-learn --no-sync --ham "$i"
 echo -n "."
done

echo "Training SPAM"
find /var/vmail/vmail1/ -name cur | egrep -i '(.spam)|(.junk)' | while read i; do
 /usr/bin/sa-learn --no-sync --spam "$i"
 echo -n "."
done

echo "Saving"
/usr/bin/sa-learn --sync

# Delete learned spam
#mv ~/Maildir/.Spam/cur/* ~/Maildir/.Trash/cur