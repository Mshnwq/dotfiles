#!/usr/bin/env bash

pkill -f dolphin
pkill -f kactivitymanagerd
pkill -f kded6
pkill -f kiod6
pkill -f ksecretd
pkill -f kwalletd

# samba
pkill -f wsdd
