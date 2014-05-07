#!/usr/bin/env python
# script to take "standard" html and wrap the various headers in <div> sections for use with the main ivoarestructure script
# - will need customization to specifics of input file
#
from xml.sax.saxutils import XMLGenerator
from xml.sax import make_parser
import sys
from io import open
from xml.sax.handler import EntityResolver
from xml.sax.handler import feature_external_ges
import xml.etree.ElementTree as ET
import os.path

#set this to the top level html header number that you want to sectionize
tophead = 2
#the number of levels to sectionize
numlevels = 2
here = os.path.dirname(__file__)
#read from catalogue
ents = ET.parse(here + "/xmlcatalog/catalog.xml")
entdict = {}

for el in ents.getiterator("{urn:oasis:names:tc:entity:xmlns:xml:catalog}public"):
    entdict[el.attrib['publicId']] = el.attrib['uri']
    


class entreso (EntityResolver):
    def resolveEntity(self, publicId, systemId):
        if publicId in entdict:
            return   here + "/xmlcatalog/" + entdict[publicId]
        else: # should raise an exception
            print "ENTITY not found", publicId


class aHandler(XMLGenerator):
    def __init__(self):
        self.inh = 0
        self.inmain = False
        self.divlevel = 0
        XMLGenerator.__init__(self)

    def startElement(self, name, attrs):
        if name=="div" and  'id' in attrs and attrs['id']=="main":
            self.inmain = True
            self.divlevel = 1
        elif name=="div" and self.inmain:
            self.divlevel += 1
        
        for level in range(tophead,tophead+numlevels):    
            if (name == ('h'+str(level)) and self.inmain):
                for i in range(level, self.inh):
                    print "</div>\n"
                print "<div class='section'>\n"
                self.inh = level + 1
        
            
            
        XMLGenerator.startElement(self, name, attrs)

    def endElement(self,name):
       if name == "div" and self.inmain:
           self.divlevel -= 1
           if self.divlevel == 0:
               for i in range(tophead, self.inh):
                   print "</div>"
       XMLGenerator.endElement(self, name)
    
 

handler = aHandler()
saxparser = make_parser()
saxparser.setContentHandler(handler)
saxparser.setEntityResolver(entreso())
saxparser.setFeature(feature_external_ges,False)

datasource = open(sys.argv[1],"r")
saxparser.parse(datasource)