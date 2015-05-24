SOURCES:=$(shell find . -type f -iname "*.epub" -or -iname "*.mobi" -or -iname "*.pdf" 2>/dev/null | sed 's/ /\*/g')

TARGETS_EPUB:=$(SOURCES:%.mobi=%.epub) $(SOURCES:%.pdf=%.epub)
TARGETS_MOBI:=$(SOURCES:%.epub=%.mobi) $(SOURCES:%.pdf=%.mobi)
TARGETS_PDF:=$(SOURCES:%.epub=%.pdf) $(SOURCES:%.mobi=%.pdf)

%.epub: %.mobi
	ebook-convert '$(subst *, ,$^)' '$(subst *, ,$@)'

%.epub: %.pdf
	ebook-convert '$(subst *, ,$^)' '$(subst *, ,$@)'

%.mobi: %.epub
	ebook-convert '$(subst *, ,$^)' '$(subst *, ,$@)'

%.mobi: %.pdf
	ebook-convert '$(subst *, ,$^)' '$(subst *, ,$@)'

%.pdf: %.epub
	ebook-convert '$(subst *, ,$^)' '$(subst *, ,$@)'

%.pdf: %.mobi
	ebook-convert '$(subst *, ,$^)' '$(subst *, ,$@)'

all: epub mobi pdf

epub: ${TARGETS_EPUB}
mobi: ${TARGETS_MOBI}
pdf: ${TARGETS_PDF}

