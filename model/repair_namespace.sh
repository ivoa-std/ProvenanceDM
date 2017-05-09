#!/bin/bash
# Tiny script to put the necessary namespace in the header of the Modelio-exported provenance.xmi file
# NOTE: must be run from the VODML base directory (or adjust the path to the provenance.xmi file)

if [ $# -lt 1 ]
then
    echo "Need file name as command line argument"
    exit
fi

filename=$1

# the "magic" line
sed -i 's;xmlns:uml=\"[a-zA-Z0-9:/\.]*\";xmlns:uml=\"http://www.omg.org/spec/UML/20100901\";g' $1

echo "Done."

exit
