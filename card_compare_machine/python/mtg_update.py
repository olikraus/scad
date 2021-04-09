#!/usr/bin/python3
#
# mtg_update.py
#
# developend with python 3.8.5
# part of 'card compare machine' project
#
# (c) olikraus@gmail.com
# 
# This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
# To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
# 
#
# updates and creates (if required) the following files:
#
# mtg_sets.json                         JSON list of all MTG sets
# all files in cards/                   Cardlist and properties of all cards in a set
# mtg_card_dic.json                 Unique map of all card names in all languages, value is an index into mtg_card_prop.json array
# mtg_card_prop_full.json       card properties (full information)
# mtg_card_prop.json              card properties (reduced information for the card compare machine
#
# mtg_card_prop_full.json and mtg_card_prop.json will use the following attributes
# small key values for the code below
# 'x'         crossreference value [only in 'mtg_card_prop_full.json']
# 'n'         english name    (was called 'name' above) [only in 'mtg_card_prop_full.json']
# 's'         mtg set code    (was called 'code' above) [only in 'mtg_card_prop_full.json']
# 'r'         rarity, 0="Common", 1="Uncommon", 2="Rare", 3="Mythic",
# 'i'         color identity
# 't'         types         [only in 'mtg_card_prop_full.json']
# 'tc'        True: Creature, False: otherwise
# 'ts'        True: Sorcery, False: otherwise
# 'ti'        True: Instant, False: otherwise
# 'ta'        True: Artifact, False: otherwise
# 'tl'        True: Land, False: otherwise
# 'te'        True: Enchantment, False: otherwise
# 'tp'        True: Planeswalker, False: otherwise
# 'm'         converted mana cost (cmc)
#
# Whenever this script is called:
#       1. data for 'mtg_sets.json' is downloaded and file 'mtg_sets.json' newly created
#       2. files in cards/ are created if they do not exist
#       3. 'mtg_card_dic.json' is newly calculated and written
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
import gc

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
  del setlist

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
  del proplist
  del cardlist
  gc.collect()

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
    del cards
    gc.collect()
    print("cardlist append '%s': len=%i size=%i" % (setcode, len(cardlist), sys.getsizeof(cardlist)))

# create a dic from all known cards from all sets on the current cards directory
# ultimatly writes 'mtg_card_dic.json' to the current directory
def update_card_dic_json():
  query_and_write_sets()
  sets = read_sets()
  for i in sets:
    cond_query_and_write_cards(i['code'])

  # build the overall card list from all sets
  cardlist = []  
  for i in sets:
    append_cards(cardlist, i['code'])

  # small key values for the code below
  # 'x'         crossreference value [only in 'mtg_card_prop_full.json']
  # 'n'         english name    (was called 'name' above) [only in 'mtg_card_prop_full.json']
  # 's'         mtg set code    (was called 'code' above) [only in 'mtg_card_prop_full.json']
  # 'r'         rarity, 0="Common", 1="Uncommon", 2="Rare", 3="Mythic",
  # 'i'         color identity
  # 't'         types         [only in 'mtg_card_prop_full.json']
  # 'tc'        True: Creature, False: otherwise
  # 'ts'        True: Sorcery, False: otherwise
  # 'ti'        True: Instant, False: otherwise
  # 'ta'        True: Artifact, False: otherwise
  # 'tl'        True: Land, False: otherwise
  # 'te'        True: Enchantment, False: otherwise
  # 'tp'        True: Planeswalker, False: otherwise
  # 'm'         converted mana cost (cmc)

  # build a dictionary with all foreign (cardldic) card names and a dictionary with all english names (cardndic)  
  cardldic = {}         # dictionary which contains the foreign card name as key
  cardndic = {}         # key: english name, value: index into cardnlist
  cardnlist = []            # card information
  index = 0;
  for i in cardlist:
    if cardndic.get(i['name'], "") == "":
      index = len(cardnlist)
      cardndic[i['name']] = index
      cardnlist.append({'x':index, 'n':i['name'], 's':i['code']})          # we will use information from the first set in which we found the card
    if cardldic.get(i['lname'], "") == "":
      cardldic[i['lname']] = { 'n':i['name'], 's':[i['code']] }
    #else:
    #  cardldic[i['lname']]['s'].append(i['code'])            # merging the sets to which the card belongs, actually not required
    if len(cardldic) % 10000 == 0: 
      print("cardldic: len=%i size=%i" % (len(cardldic), sys.getsizeof(cardldic)))
      

  print("update foreign (and english) name card dictionary")
  for card in cardldic:
    cardldic[card] = cardndic[cardldic[card]['n']]         # replace the value with the reference to the list

  # generate a map which lists all chars, which appear in the card names
  # ignore chars above 0x2b00
  # this is just used, to derive a similarity table, which in turn was manually created
  # chardic = {}
  # for card in cardldic:
  #   for c in card:
  #     if ord(c) < 0x2b00:
  #       chardic[ord(c)] = c
  # write_json(dict(sorted(chardic.items())), 'mtg_char_usage_in_names.json')
  #print(dict(sorted(chardic.items())))
  
  print("writing 'mtg_card_dic.json'")
  write_json(cardldic, 'mtg_card_dic.json')
  del cardldic
  del cardndic
          
  gc.collect()          # clean up memory a little bit
  
  # build card property table
  print("update card properties")
  oldsetcode = ""
  props = []
  cardprop = {}
  pos = 0
  for card in cardnlist:
    setcode = card['s']
    name = card['n']
    if oldsetcode != setcode:
      props = read_json(get_props_filename(setcode))
      oldsetcode = setcode 
    cardprop = {}
    for p in props:
        if p['name'] == name:
          cardprop = p
          break
    if len(cardprop) > 0:
      card['r']  = -1                   # should be replaced by one of the rarities below
      if cardprop['rarity'] == "Common":
        card['r'] = 0
      if cardprop['rarity'] == "Uncommon":
        card['r'] = 1
      if cardprop['rarity'] == "Rare":
        card['r'] = 2
      if cardprop['rarity'] == "Mythic":
        card['r'] = 3
      card['i'] = cardprop['color_identity']
      card['t'] = cardprop['types']
      card['tc'] = "Creature" in cardprop['types']
      card['ts'] = "Sorcery" in cardprop['types']
      card['ti'] = "Instant" in cardprop['types']
      card['ta'] = "Artifact" in cardprop['types']
      card['tl'] = "Land" in cardprop['types']
      card['te'] = "Enchantment" in cardprop['types']
      card['tp'] = "Planeswalker" in cardprop['types']
      card['c'] = int(cardprop['cmc'])          # not sure why this was stored as float
    if pos % 1000 == 0: 
      print("card properties: pos=%i/%i " % (pos, len(cardnlist)))
    pos = pos+1
  write_json(cardnlist, 'mtg_card_prop_full.json')
  
  # remove some data to save memory
  print("strip card properties")
  for card in cardnlist:
    card.pop('t', None)         # remove the type list
    card.pop('x', None)         # remove the internal reference number
    card.pop('n', None)          # remove the name
    card.pop('s', None)         # remove the set code
  write_json(cardnlist, 'mtg_card_prop.json')

update_card_dic_json()

