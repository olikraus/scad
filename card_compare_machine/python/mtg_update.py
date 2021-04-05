# mtg_update.py
#
# updates and creates (if required) the following files
#
# mtg_sets.json                 JSON list of all MTG sets
# all files in cards/           Cardlist and properties of all cards in a set
# mtg_card_dic.json         Unique map of all card names in all languages
#
# Whenever this script is called:
#       1. mtg_sets.json is newly created
#       2. files in cards/ are created if they do not exist
#       3. mtg_card_dic.json is newly calculated and written
#
#


from mtgsdk import Card
from mtgsdk import Set
from mtgsdk import Type
from mtgsdk import Supertype
from mtgsdk import Subtype
from mtgsdk import Changelog
import sys
import io
import json
import os
import time

def write_json(obj, filename):
#  f = io.open(filename, "w+", encoding="utf-8")
  f = io.open(filename, "w", encoding=None)
  json.dump(obj, f, indent=1)
  f.close()
  
def read_json(filename):
  f = io.open(filename, "r", encoding=None)
  obj = json.load(f)
  f.close()
  return obj

def query_and_write_sets():
  setlist = []
  print("query all sets")
  sets = Set.all()
  print("number of sets: " + str(len(sets)))
  for set in sets:
    dic = { 'name':set.name, 'code':set.code}
    setlist.append(dic)
  write_json(setlist, "mtg_sets.json")
  print("all sets written to 'mtg_sets.json'")

def read_sets():
  return read_json("mtg_sets.json")

def get_props_filename(setcode):
  return "cards/mtg_"+setcode.lower()+"_props.json"

def get_cards_filename(setcode):
  return "cards/mtg_"+setcode.lower()+"_cards.json"

def query_and_write_cards(setcode):
  cardlist = []
  proplist = []
  cards = Card.where(set=setcode).all()
  print("set '%s' with %i cards" % (setcode, len(cards)) )
  for card in cards:
    prop = { 
      'name':card.name, 
      'set':card.set, 
      'cmc':card.cmc , 
      'mana_cost':card.mana_cost, 
      'color_identity':card.color_identity, 
      'rarity':card.rarity, 
      'supertypes':card.supertypes,
      'types':card.types,
      'subtypes':card.subtypes,
      'legalities':card.legalities
      }
    proplist.append(prop)
    dic = { 
      'name':card.name, 
      'set':card.set, 
      'lname':card.name,
      'text':card.text, 
      'flavor':card.flavor, 
      'type':card.type, 
      'multiverse_id':card.multiverse_id, 
      'language':''}
    cardlist.append(dic)
    if isinstance(card.foreign_names, list):
      for l in card.foreign_names:
        dic = {
          'name':card.name, 
          'set':card.set, 
          'lname':l['name'],
          'type':l.get('type', ''), 
          'text':l.get('text', ''), 
          'flavor':l.get('flavor', ''), 
          'multiverse_id':l['multiverseid'], 
          'language':l['language']
        }
        cardlist.append(dic)
        
        
  write_json(proplist, get_props_filename(setcode))
  write_json(cardlist, get_cards_filename(setcode))

def cond_query_and_write_cards(setcode):
  if os.path.exists("cards") == False:
      os.mkdir("cards")
  iscards = os.path.exists(get_cards_filename(setcode))
  isprops = os.path.exists(get_props_filename(setcode))
  if iscards == False or isprops == False:
    time.sleep(3)
    query_and_write_cards(setcode)
  else:
    print("set '%s' skipped" % (setcode) )

def append_cards(cardlist, setcode):
  if os.path.exists(get_cards_filename(setcode)):
    cards = read_json(get_cards_filename(setcode))
    for c in cards:
      dic = { 'name':c['name'], 'lname':c['lname'], 'code':setcode }
      cardlist.append(dic)
    print("cardlist append '%s': len=%i size=%i" % (setcode, len(cardlist), sys.getsizeof(cardlist)))

# create a dic from all known cards from all sets on the current cards directory
# ultimatly writes 'mtg_card_dic.json' to the current directory
def update_card_dic_json():
  query_and_write_sets()
  sets = read_sets()
  for i in sets:
    cond_query_and_write_cards(i['code'])

  cardlist = []  
  for i in sets:
    append_cards(cardlist, i['code'])

  carddic = {} 
  for i in cardlist:
    if carddic.get(i['lname'], "") == "":
      carddic[i['lname']] = { 'name':i['name'], 'code':[i['code']] }
    else:
      carddic[i['lname']]['code'].append(i['code'])
    if len(carddic) % 10000 == 0: 
      print("carddic: len=%i size=%i" % (len(carddic), sys.getsizeof(carddic)))
  print("writing 'mtg_card_dic.json'")
  write_json(carddic, 'mtg_card_dic.json')


update_card_dic_json()

