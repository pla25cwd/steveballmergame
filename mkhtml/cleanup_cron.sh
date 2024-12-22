#/bin/bash
sort -n -t"," -k2,2 absolutelyNeverAnySQL.csv | head -n 50 > tmp
cat tmp > absolutelyNeverAnySQL.csv
rm tmp
