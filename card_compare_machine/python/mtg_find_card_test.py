
import io
import json
import jellyfish

def read_json(filename):
  f = io.open(filename, "r", encoding=None)
  obj = json.load(f)
  f.close()
  return obj


carddic = read_json('mtg_card_dic.json')

while True:
  s = """
emnnamnnminnaneeneineeeeanee ee ee

& Tendrils of Corruption Se  
"""
  d = 999
  dmin = 999
  smin = ""
  for c in carddic:
    d = jellyfish.levenshtein_distance(c, s)
    if dmin > d:
      dmin = d
      smin = c
      print(smin, dmin)
