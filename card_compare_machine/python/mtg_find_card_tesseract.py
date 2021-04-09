
import io
import json
import jellyfish

def read_json(filename):
  f = io.open(filename, "r", encoding=None)
  obj = json.load(f)
  f.close()
  return obj
  
def find_card(carddic, s):
  t = { 
  8209: 45, 8211:45, # convert dash
  48: 111, 79: 111, # convert zero and uppercase O to small o
  211: 111, 212: 111, 214: 111, # other chars similar to o
  242: 111, 243: 111, 244: 111, 245: 111, 246: 111, # other chars similar to o
  959:111, 1086:111, 8009:111, 1054:111,    # other chars similar to o
  73:105, 74:105, 106:105, 108:105, 124:105, # convert upper i, upper j, small j, small l and pipe symbol to small i
  161:105, 205:105, 206:105, 236:105, 237:105, 238:105, 239:105, 1575:105,  # convert other chars to i
  192: 65, 193: 65, 194: 65, 196: 65, 1040:65, 1044:65,         # upper A
  200: 69, 201: 69, 202: 69, 1045:69,   # upper E
  85:117,  # convert upper U to small u
  218: 117, 220: 117,  # other conversions to small u
  249: 117, 250: 117, 251: 117, 252: 117, # other conversions to small u
  956: 117, 1094: 117,
  224: 97, 225: 97, 226: 97, 227: 97, 228: 97, 229: 97, # small a conversion
  232: 101, 233: 101, 234: 101, 235: 101 # small e conversion
  }

  d = 999
  dmin = 999
  smin = ""
  for c in carddic:
    d = jellyfish.levenshtein_distance(c.translate(t), s.translate(t))
    if dmin > d:
      dmin = d
      smin = c
      print(c.translate(t) + "/"+ s.translate(t))
  return [carddic[smin], smin, dmin]


carddic = read_json('mtg_card_dic.json')
cardprop = read_json('mtg_card_prop_full.json')


r = find_card(carddic, "fin-Clade Fugitives 3 Se");
print(r)
print(cardprop[r[0]])