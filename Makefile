TEX_DIR  := tex
PDF_DIR  := pdf
SPEC_DIR := spec

# tex → pdf (pdflatex, двойной проход); исключаем pandoc-header
TEX_SOURCES := $(filter-out $(TEX_DIR)/pandoc-header.tex, $(wildcard $(TEX_DIR)/*.tex))
TEX_PDFS    := $(patsubst $(TEX_DIR)/%.tex,$(PDF_DIR)/%.pdf,$(TEX_SOURCES))

# spec md → pdf (pandoc + xelatex)
SPEC_FILES  := $(SPEC_DIR)/00-overview.md $(SPEC_DIR)/01-lexical.md \
               $(SPEC_DIR)/02-core.md $(SPEC_DIR)/03-extended.md \
               $(SPEC_DIR)/04-execution-model.md $(SPEC_DIR)/05-structured-output.md \
               $(SPEC_DIR)/06-templates.md $(SPEC_DIR)/07-streams.md \
               $(SPEC_DIR)/08-errors-budget.md $(SPEC_DIR)/09-os-integration.md \
               $(SPEC_DIR)/10-terminology.md \
               $(SPEC_DIR)/11-coil-h.md

PANDOC_HDR  := $(TEX_DIR)/pandoc-header.tex
LANG_REF    := $(PDF_DIR)/lang-reference.pdf

.PHONY: all clean

all: $(TEX_PDFS) $(LANG_REF)

$(PDF_DIR)/%.pdf: $(TEX_DIR)/%.tex | $(PDF_DIR)
	pdflatex -output-directory=$(PDF_DIR) $<
	pdflatex -output-directory=$(PDF_DIR) $<
	@rm -f $(PDF_DIR)/*.aux $(PDF_DIR)/*.log $(PDF_DIR)/*.out $(PDF_DIR)/*.toc $(PDF_DIR)/*.listing

$(LANG_REF): $(SPEC_FILES) $(PANDOC_HDR) | $(PDF_DIR)
	pandoc $(SPEC_FILES) -o $@ \
	  --pdf-engine=xelatex \
	  -V mainfont="PT Serif" \
	  -V monofont="JetBrains Mono" \
	  --toc \
	  -V geometry:margin=2.5cm \
	  --include-in-header=$(PANDOC_HDR)

$(PDF_DIR):
	mkdir -p $(PDF_DIR)

clean:
	rm -f $(PDF_DIR)/*.pdf $(PDF_DIR)/*.aux $(PDF_DIR)/*.log $(PDF_DIR)/*.out $(PDF_DIR)/*.toc $(PDF_DIR)/*.listing
