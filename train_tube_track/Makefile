
.suffixes: .scad .stl .png


# SCAD=ttt_straight_1.scad
SCAD=$(wildcard ttt*.scad)
STL=$(SCAD:.scad=.stl)
PNG=$(SCAD:.scad=.png)


%.stl: %.scad
	openscad $< -o tmp.stl
	admesh tmp.stl -b $@
	rm tmp.stl

%.png: %.scad
	openscad $<  --render --autocenter --viewall --imgsize=320,240 -o $@

.PHONY: all
all: $(STL) $(PNG)

.PHONY: clean
clean: 
	-rm $(STL) $(PNG)
