#!/usr/bin/env bash
vagrant up \
&& ./ping.sh \
&& ./getroles.sh \
&& ./converge.sh
