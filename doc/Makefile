# ivoatex Makefile.  The ivoatex/README for the targets available.

# short name of your document (edit $DOCNAME.tex; would be like RegTAP)
DOCNAME = ProvenanceDM

# count up; you probably do not want to bother with versions <1.0
DOCVERSION = 1.0

# Publication date, ISO format; update manually for "releases"
date := $(shell date +"%Y-%m-%d")
DOCDATE = $(date)

# What is it you're writing: NOTE, WD, PR, or REC
DOCTYPE = WD

# Source files for the TeX document (but the main file must always
# be called $(DOCNAME).tex
SOURCES = $(DOCNAME).tex 

# List of pixel image files to be included in submitted package 
FIGURES = VOArchitecture-Prov2016.png CTA_DM_high_level.png CTA_prov.png usecase_Pollux_example1.png
#updated the architecture diag . Mireille

# List of PDF figures (for vector graphics)
VECTORFIGURES = workflow-backwards.pdf
#classes-overview.pdf classes-core-w3c entity-details activity-details.pdf provgraph-activityflow agent-relations.pdf classes-relations-dms

# Additional files to distribute (e.g., CSS, schema files, examples...)
AUX_FILES = 

include ivoatex/Makefile
