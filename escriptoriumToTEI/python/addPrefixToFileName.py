# -*- coding: utf-8 -*-
"""
Created on Wed Feb 16 09:58:59 2022

@author: hlapin
"""
import os

pagexml_root = "C://Users//hlapin//Downloads//"
dir_name = "export_doc499_maimonides_nli_4_5703_split_page_pagexml_202209282115//"
path = pagexml_root+dir_name

curr = os.getcwd()

pre="02_nli_"

os.chdir(path)

print(os.getcwd())

for f in os.listdir():
    print(f)
    base_n = os.path.splitext(f)[0]
    split_n = base_n.split('_')
    split_n = [s.zfill(3) if s.isdigit() else s for s in split_n]
    new_name = pre+'_'.join(split_n)+'.xml'
    print(new_name) 
    os.rename(f,new_name)
    
os.chdir(curr)
print(os.getcwd())