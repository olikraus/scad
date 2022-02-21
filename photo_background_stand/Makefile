#
#  Makefile for photo_background_stand.scad
#
#  (c) olikraus@gmail.com
#
#  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
#  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
#  
#



.suffixes: .scad .stl .png


# SCAD=ttt_straight_1.scad
SCAD=$(wildcard p*.scad)
STL=$(SCAD:.scad=.stl)
PNG=$(SCAD:.scad=.png)
GCODE=$(SCAD:.scad=.gcode)

SLIC3R_FLAGS=--gcode-flavor reprap --nozzle-diameter 0.4 --filament-diameter 1.75
SLIC3R_FLAGS+=--print-center 75,75 --start-gcode start.gcode
SLIC3R_FLAGS+=--brim-width 4
SLIC3R_FLAGS+=--fill-density 60% 
#SLIC3R_FLAGS+=--solid-infill-every-layers 1
SLIC3R_FLAGS+=--layer-height 0.2 --first-layer-height 0.3 
#SLIC3R_FLAGS+=--duplicate 1


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
