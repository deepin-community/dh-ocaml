
MP := $(shell ls -1 dom-*.xml)

all: $(patsubst %.xml,%.1, $(MP))

%.1: %.xml
	-xmllint --nonet --noout --postvalid --xinclude $<
	xsltproc --output $@ --nonet --xinclude \
	  /usr/share/xml/docbook/stylesheet/nwalsh/manpages/docbook.xsl \
	  $<
	sed -i 's/CopyrightCopyright/Copyright/' $@

clean:
	rm -f *.1
