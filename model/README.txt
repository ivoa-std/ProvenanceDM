VODML-version of Provenance Data Model.

This version may still change at any time, also see the current working draft in ../description/

For recreating the vodml-xml, html documentation etc., do the following (usual) steps:

* copy latest xmi version to this directory:
  cp ../datamodel-diagrams/provenance.xmi .

* switch to the vo-dml directory, tools/
  cd ../../vo-dml/tools/

* adjust build.properties:
  vi build.properties

  -> set here "models=../../provenance/vo-dml"

* create the provenancedm.vo-dml.xml file by running from the tools-directory::
  ant run_xmi2vo-dml

  - if error: No uml:Model found, edit the provenance.xmi-file directly and patch the xmi namespace:
    xmlns:uml="http://www.omg.org/spec/UML/20100901/"

* create the html documentation:
  ant run_vo-dml2html
 
- if there are a lot of TODO-strings, the descriptions for each class/attribute are not stored in Modelio
  and thus not in the xmi-file.
- just add them to the vo-dml.xml file like this:
	- extract descriptions for each element using extract_descriptions.py
	- edit the created Provenance.descriptions file
	- add the descriptions from this file back into ProvenanceDM.vo-dml.xml:

	python add_descriptions.py xml/ProvenanceDM.vo-dml.xml ProvenanceDM.descriptions
        mv xml/ProvenanceDM-new.vo-dml.xml xml/ProvenanceDM.vo-dml.xml
- regenerate html docu:
  ant run_vo-dml2html

Now the descriptions are included!



