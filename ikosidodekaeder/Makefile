
.suffixes: .scad .stl .png


#SCAD=$(wildcard *.scad)
SCAD=ikosidodekaeder_connector.scad 
SCAD+=light_connector.scad light_connector_4x5.scad light_connector_2x2.scad
SCAD+=light_matrix.scad light_frame.scad
SCAD+=pentagon.scad
STL=$(SCAD:.scad=.stl)
PNG=$(SCAD:.scad=.png)
GCODE=$(SCAD:.scad=.gcode)

SLIC3R_FLAGS+=--temperature 208
SLIC3R_FLAGS=--gcode-flavor reprap --nozzle-diameter 0.4 --filament-diameter 1.75
SLIC3R_FLAGS+=--start-gcode start.gcode
SLIC3R_FLAGS+=--brim-width 4
SLIC3R_FLAGS+=--fill-density 20% 
#SLIC3R_FLAGS+=--solid-infill-every-layers 1
SLIC3R_FLAGS+=--layer-height 0.2 --first-layer-height 0.3 
#SLIC3R_FLAGS+=--print-center 40,40 --duplicate-grid 5,4 --duplicate-distance 25 
SLIC3R_FLAGS+=--print-center 60,75 


%.stl: %.scad
	openscad $< -o tmp.stl
	admesh tmp.stl -b $@
	rm tmp.stl

%.gcode: %.stl start.gcode
	slic3r $(SLIC3R_FLAGS) $< -o $@
	
%.png: %.scad
	openscad $<  --render --autocenter --viewall --imgsize=640,480 -o $@



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
