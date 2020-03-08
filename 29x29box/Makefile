
.suffixes: .scad .stl .png


# SCAD=ttt_straight_1.scad
SCAD=$(wildcard scad/[hf]*.scad)
STL=$(addprefix stl/, $(notdir $(SCAD:.scad=.stl)))
PNG=$(addprefix png/, $(notdir $(SCAD:.scad=.png)))


stl/%.stl: scad/%.scad
	openscad $< -o tmp.stl
	admesh tmp.stl -b $@
	rm tmp.stl

png/%.png: scad/%.scad
	openscad $<  --render --autocenter --viewall --imgsize=640,480 -o $@

.PHONY: all
all: $(STL) $(PNG)
#	-echo $(STL) $(PNG)
  

.PHONY: clean
clean: 
	-rm $(STL) $(PNG)
