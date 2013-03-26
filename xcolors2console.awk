#!/bin/awk -f

BEGIN {
	FS = "[[:blank:]:]+"
}

$1 == "#define" && NR >= 3 {
	define[$2] = $3
}

$1 ~ /[.*]color([0-9]|1[0-5])/ && NR >= 2 {
	color[$1] = $2
}

END {
	for (i in color) {
		c = color[i]
		if (c in define) c = define[color[i]]
		i = substr(i, index(i, "color") + 5)
		printf("]P%x%s", i, substr(c, 2))
	}
}

