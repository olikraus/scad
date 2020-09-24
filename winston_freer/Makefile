
.suffixes: .scad .stl .png


SCAD=$(wildcard scad/puzzle*.scad)
STL=$(addprefix stl/, $(notdir $(SCAD:.scad=.stl)))
PNG=$(addprefix png/, $(notdir $(SCAD:.scad=.png)))
GCODE=$(addprefix gcode/, $(notdir $(SCAD:.scad=.gcode)))

# SCAD=$(wildcard *print.scad)
# STL=$(SCAD:.scad=.stl)
# PNG=$(SCAD:.scad=.png)
# GCODE=$(SCAD:.scad=.gcode)

SLIC3R_FLAGS=--gcode-flavor reprap --nozzle-diameter 0.4 --filament-diameter 1.75
SLIC3R_FLAGS+=--print-center 75,75 --start-gcode start.gcode
SLIC3R_FLAGS+=--brim-width 4
SLIC3R_FLAGS+=--fill-density 80%
#SLIC3R_FLAGS+=--solid-infill-every-layers 1
SLIC3R_FLAGS+=--layer-height 0.2 --first-layer-height 0.3 
SLIC3R_FLAGS+=--duplicate 1


stl/%.stl: scad/%.scad
	openscad $< -o tmp.stl
	admesh tmp.stl -b $@
	rm tmp.stl

gcode/%.gcode: stl/%.stl start.gcode
	slic3r $(SLIC3R_FLAGS) $< -o $@
	
png/%.png: scad/%.scad
	openscad $<  --render --autocenter --viewall --imgsize=800,600 -o $@



.PHONY: all
all: $(STL) $(GCODE) $(PNG)

start.gcode:
	echo "G28 ; Home all axes" >$@
	echo "G32 ;"  >>$@
	echo "G28 ; Home all axes" >>$@
	echo "G1 Z5 F5000 ; lift nozzle" >>$@

.PHONY: clean
clean: 
	-rm $(STL) $(PNG) $(GCODE) start.gcode
