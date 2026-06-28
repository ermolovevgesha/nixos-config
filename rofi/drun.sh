#!/usr/bin/env bash

pid=$(pidof rofi)
if [[ $pid > 0 ]]; then
  kill $pid
else
  rofi -show drun -config "$HOME/.config/rofi-themes/config.rasi"
fi
