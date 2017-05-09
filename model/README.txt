VODML-version of Provenance Data Model.

This version may still change at any time, also see the current working draft in ../../../provenance/description/

For recreating the vodml-xml, html documentation etc., do the following (usual) steps:

* copy latest xmi version to this directory:
  cp ../../../provenance/datamodel-diagrams/provenance.xmi .

* adjust build.properties in vo-dml's base directory:
  cd ../../
  vi build.properties

  -> set here "models=./models/provenancedm"

* create the provenancedm.vo-dml.xml file:
  ant run_xmi2vo-dml

  - if error: No uml:Model found, edit the provenance.xmi-file directly and patch the xmi namespace:
    xmlns:uml="http://www.omg.org/spec/UML/20100901/"

* create the html documentation:
  ant run_vo-dml2html

