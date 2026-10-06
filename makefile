TYPST = typst
src = main.typ template.typ details.yml

output.pdf : $(src)
	$(TYPST) compile main.typ $@

.PHONY: clean
clean :
	rm -f output.pdf
