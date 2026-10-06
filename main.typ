// CV entrypoint — loads structured data and applies the template.
// Build with: typst compile main.typ output.pdf (see makefile)

#import "template.typ": cv

#let data = yaml("details.yml")
#cv(data)
