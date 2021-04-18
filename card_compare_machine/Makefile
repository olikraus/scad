
.suffixes: .scad .stl .png


CCM=$(wildcard scad/ccm*.scad)
SHOW==$(wildcard scad/show*.scad)

SCAD=$(CCM)
PNGSCAD=$(CCM) $(SHOW)
STL=$(addprefix stl/, $(notdir $(SCAD:.scad=.stl)))
PNG=$(addprefix png/, $(notdir $(PNGSCAD:.scad=.png)))
GCODE=$(addprefix gcode/, $(notdir $(SCAD:.scad=.gcode)))

# SCAD=$(wildcard *print.scad)
# STL=$(SCAD:.scad=.stl)
# PNG=$(SCAD:.scad=.png)
# GCODE=$(SCAD:.scad=.gcode)

SLIC3R_FLAGS=--gcode-flavor reprap --nozzle-diameter 0.4 --filament-diameter 1.75
SLIC3R_FLAGS+=--print-center 75,75 --start-gcode start.gcode
SLIC3R_FLAGS+=--brim-width 2
# 80%: ca 2mm löcher
SLIC3R_FLAGS+=--fill-density 30%
#SLIC3R_FLAGS+=--solid-infill-every-layers 1
#SLIC3R_FLAGS+=--layer-height 0.25 --first-layer-height 0.3 
SLIC3R_FLAGS+=--layer-height 0.3 --first-layer-height 0.3 --avoid-crossing-perimeters --perimeters 2
SLIC3R_FLAGS+=--duplicate 1


stl/%.stl: scad/%.scad scad/card_compare_machine.scad
	openscad $< -o tmp.stl
	admesh tmp.stl -b $@
	rm tmp.stl

gcode/%.gcode: stl/%.stl start.gcode scad/card_compare_machine.scad
	slic3r $(SLIC3R_FLAGS) $< -o $@
	
png/%.png: scad/%.scad scad/card_compare_machine.scad
	# openscad $<  --camera=0,-60,0,0,0,0,800  --imgsize=800,600 -o $@
	openscad $<  --autocenter --viewall --imgsize=800,600 -o $@
	#openscad $<  --render --autocenter --viewall --imgsize=800,600 -o $@



.PHONY: all
all: $(STL) $(GCODE) $(PNG) png/show_all_top.png png/show_all_front_right.png

png/show_all_top.png: scad/show_all.scad
	openscad $<  --camera=0,-60,0,0,0,0,800  --imgsize=800,600 -o $@
        
png/show_all_front_right.png: scad/show_all.scad
	openscad $<  --camera=-20,-30,0,50,0,20,920  --imgsize=800,600 -o $@
        

start.gcode:
	echo "G28 ; Home all axes" >$@
	echo "G32 ;"  >>$@
	echo "G28 ; Home all axes" >>$@
	echo "G1 Z5 F5000 ; lift nozzle" >>$@

.PHONY: clean
clean: 
	-rm $(STL) $(PNG) $(GCODE) start.gcode
