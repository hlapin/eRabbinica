# -*- coding: utf-8 -*-
"""
Created on Wed Feb 16 09:58:59 2022

@author: hlapin
"""
import json

fpath = "C:\\Users\\hlapin\\Documents\\GitHub\\eRabbinica\\escriptoriumtotei\\python\\fred.json"
f = open(fpath, encoding="utf-8")
data = json.load(f, encoding="utf-8")
for c in data['text']:
    for h in c:
        print(h[0])
        print('______________________________')