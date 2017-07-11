import argparse
import yaml
from lxml import etree

def main():
    parser = argparse.ArgumentParser(description='Add model descriptions to a vo-dml.xml file, using a descriptions-file')

    parser.add_argument('vodml', metavar='vodml_file', type=str,
        default="ProvenanceDM.vo-dml.xml",
        help='name of vo-dml.xml file from which descriptions shall be updated')

    parser.add_argument('description', metavar='description_file', type=str,
        #default=None,
        help='name of description file which contains model descriptions for given vodml-ids')

    parser.add_argument('-o', '--output', metavar='output_file', type=str,
        default=None,
        help='name of output file into which the updated vo-dml.xml shall be written')

    args = parser.parse_args()
    vodmlfilename = args.vodml

    # vodmlfilename = "ProvenanceDM.vo-dml.xml"
    descriptionfilename = args.description
    if args.output is not None:
        outputfilename = args.output
    else:
        # construct filename based on vodmlfilename
        outputfilename = vodmlfilename.replace('.vo-dml.xml', '-new.vo-dml.xml')

    # read in vodml-file
    f = open(vodmlfilename, 'r')
    tree = etree.parse(f)
    f.close()

    # read descriptions from a separate yaml file
    with open(descriptionfilename, 'r') as fdesc:
        try:
            descriptions = yaml.load(fdesc)
        except yaml.YAMLError as exc:
            print(exc)

    # get the tree root
    root = tree.getroot()

    # find all vodml-ids (recursively) and their sibling description
    for e in root.xpath(".//vodml-id"):

        vodml_id = e
        parent = e.getparent()
        desc = parent.find("description")

        if desc is not None:
            # replace with read model descriptions, if exists; remove final \n
            if vodml_id.text in descriptions:
                desc.text = descriptions[vodml_id.text].rstrip("\n")
            # else: leave it as it is


    outputfile = open(outputfilename, 'wb')
    xml = etree.tostring(root)
    outputfile.write(xml)
    outputfile.close()
    print("File '%s' was read, descriptions from '%s' were added and written to file '%s'" % (vodmlfilename, descriptionfilename, outputfilename))


if __name__ == '__main__':
    main()