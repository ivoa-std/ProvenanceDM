import argparse
from lxml import etree


def main():
    parser = argparse.ArgumentParser(description='Extract model descriptions from a vo-dml.xml file')

    parser.add_argument('vodml', metavar='vodml_file', type=str,
        default="ProvenanceDM.vo-dml.xml",
        help='name of vo-dml.xml file from which descriptions shall be extracted')

    parser.add_argument('--output', metavar='description_file', type=str,
        default=None,
        help='name of output file into which the vodml-ids and descriptions shall be written; will be constructed automatically (<model>.descriptions), if not provided')

    args = parser.parse_args()
    vodmlfilename = args.vodml

    # construct description filename, if needed
    if args.output is not None:
        descriptionfilename = args.output
    else:
        descriptionfilename = vodmlfilename.replace('.vo-dml.xml', '.descriptions')

    f = open(vodmlfilename, 'r')

    tree = etree.parse(f)
    f.close()

    root = tree.getroot()

    # find all vodml-ids and their sibling description,
    # write to file
    descfile = open(descriptionfilename, 'w')

    for e in root.xpath("//vodml-id"):

        vodml_id = e.text
        desc =  e.getparent().getparent().find("description")
        desc = desc.text.strip()

        #print("'vodml-id': '%s'" % vodml_id)
        #print("'description': '%s'" % desc)

        # replace each \n by \n and 4 whitespaces, because need to get
        # indentation right for yaml multiline string
        desc = desc.replace("\n", "\n    ")

        # print directly as yaml dictionary:
        descfile.write("%s: |\n" % vodml_id)
        descfile.write("    %s\n" % desc)

    descfile.close()

    print("File '%s' was read and descriptions for each vodml-id were written to file '%s'" % (vodmlfilename, descriptionfilename))


if __name__ == '__main__':
    main()