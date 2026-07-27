#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# pylint: skip-file

ALL_2G_CHANNELS = list(range(1, 14))
ALL_5G_CHANNELS = list(range(36, 166))


def get_channels_for_band(band):
    if band == "5g":
        return ALL_5G_CHANNELS.copy()
    return ALL_2G_CHANNELS.copy()


def channel_to_band(channel):
    if int(channel) >= 36:
        return "5g"
    return "2g"


def channel_to_hw_mode(channel):
    if int(channel) >= 36:
        return "a"
    return "g"
