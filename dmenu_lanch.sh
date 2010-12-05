#!/usr/bin/env bash
$(dmenu_path | dmenu -i -nb 'black' -nf 'white' -sb 'orange' -sf 'black') && eval “exec $exe”

