## ********************************************************************* ##
## Copyright 2020                                                        ##
## Portland Community College                                            ##
##                                                                       ##
##
## ********************************************************************* ##


#######################
# DO NOT EDIT THIS FILE
#######################

#   1) Make a copy of Makefile.paths.original
#      as Makefile.paths, which git will ignore.
#   2) Edit Makefile.paths to provide full paths to the root folders
#      of your local clones of the project repository and the mathbook
#      repository as described below.
#   3) The files Makefile and Makefile.paths.original
#      are managed by git revision control and any edits you make to
#      these will conflict. You should only be editing Makefile.paths.

##############
# Introduction
##############

# This is not a "true" makefile, since it does not
# operate on dependencies.  It is more of a shell
# script, sharing common configurations

######################
# System Prerequisites
######################

#   install         (system tool to make directories)
#   xsltproc        (xml/xsl text processor)
#   java,jingtrang  (only for schema validation)
#   <helpers>       (PDF viewer, web browser, pager, Sage executable, etc)

#####
# Use
#####

#	A) Navigate to the location of this file
#	B) At command line:  make <some-recipe-from-the-options-below>

##################################################
# The included file contains customized versions
# of locations of the principal components of this
# project and names of various helper executables
##################################################
include Makefile.paths

###################################
# These paths are subdirectories of
# the project distribution
###################################
SRC       = $(PRJ)/src
IMGSRC    = $(SRC)/images
OUTPUT    = $(PRJ)/output
PUB       = $(PRJ)/publication
XSL       = $(PRJ)/xsl

# The project's root file
MAINFILE  = $(SRC)/index.ptx

# Local translation stylesheets
PRINT      = $(XSL)/mis-print.xsl
HTML       = $(XSL)/mis-html.xsl

# The project's styling files
PUBFILE   = $(PUB)/publication.xml

# These paths are subdirectories of
# the PreTeXt distribution
PTXXSL = $(PTX)/xsl

# These paths are subdirectories of the output
# folder for different output formats
PRINTOUT   = $(OUTPUT)/print
HTMLOUT    = $(OUTPUT)/html

pdf-nopost:
	install -d $(OUTPUT)
	-rm -r $(PRINTOUT) || :
	install -d $(PRINTOUT)
	install -d $(PRINTOUT)/images
	install -d $(IMGSRC)
	cp -a $(IMGSRC) $(PRINTOUT) || :
	cd $(PRINTOUT); \
	xsltproc -xinclude --stringparam publisher $(PUBFILE) --stringparam toc.level 2 --stringparam latex.print 'yes' --stringparam latex.pageref 'no' --stringparam latex.sides 'two' $(PRINT) $(MAINFILE) > mis.tex; \
	pdflatex mis.tex; \
	pdflatex mis.tex; \

#  HTML output
#  Output lands in the subdirectory:  $(HTMLOUT)
html:
	install -d $(OUTPUT)
	-rm -r $(HTMLOUT) || :
	install -d $(HTMLOUT)
	install -d $(HTMLOUT)/images
	install -d $(IMGSRC)
	cp -a $(IMGSRC) $(HTMLOUT) || :
	cd $(HTMLOUT); \
	xsltproc -xinclude --stringparam publisher $(PUBFILE) --stringparam exercise.inline.hint no --stringparam exercise.inline.answer no --stringparam exercise.inline.solution yes --stringparam exercise.divisional.hint no --stringparam exercise.divisional.answer no --stringparam exercise.divisional.solution no --stringparam html.knowl.exercise.inline no --stringparam html.knowl.example no $(XSL)/mis-html.xsl $(MAINFILE); \

###########
# Utilities
###########

# Verify Source integrity
#   Leaves "dtderrors.txt" in OUTPUT
#   can then grep on, e.g.
#     "element XXX:"
#     "does not follow"
#     "Element XXXX content does not follow"
#     "No declaration for"
#   Automatically invokes the "less" pager, could configure as $(PAGER)
check:
	install -d $(OUTPUT)
	-rm $(OUTPUT)/jingreport.txt
	-java -classpath ~/jing-trang/build -Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration -jar ~/jing-trang/build/jing.jar $(PTX)/schema/pretext.rng $(MAINFILE) > $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*permid.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*reseed.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*reading-questions.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*document-id.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*element .html.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*element .instruction.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*element .image. incomplete.*\n//g' $(OUTPUT)/jingreport.txt
	perl -pi -e 's/^.*attribute .pg-name.*\n//g' $(OUTPUT)/jingreport.txt
	perl -p0i -e 's/.*? .tabular. not allowed here.*?\n.*? .figure. incomplete.*?\n//g' $(OUTPUT)/jingreport.txt
	perl -p0i -e 's/.*? .interactive. not allowed anywhere.*?\n.*? .figure. incomplete.*?\n//g' $(OUTPUT)/jingreport.txt; \
	less $(OUTPUT)/jingreport.txt
