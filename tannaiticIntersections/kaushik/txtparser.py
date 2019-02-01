# -*- coding: utf-8 -*-
"""
Created on Wed Nov 14 13:24:26 2018
RA-Dr.Lapin
@author: kaush
"""
import re
import pandas as pd

"""function to extract ranges"""


def getRanges(txt):
    catch = re.findall(r'\[(.*?)\]', txt)[1]
    return catch


"""function to get Start and End bits"""



def getStartEnd(txt):
    catch  = re.sub('ref.', '', txt)
    maketrans = catch.maketrans
    final = catch.translate(maketrans('.', '0'))
    start, end = re.split('-', final)
    return (start, end)


"""function for compare range adjustment"""


def editRef(txt):
    txt = re.sub('ref-t', 'ref', txt)
    return txt


"""getting input from file"""

file = open("LapinResults2018-09-07.txt",encoding= 'utf-8')
line = file.read()
line = line.split("\n")

"""creating a list for each item"""

baserange = line[1::6]
comprange = line[2::6]
basetext = line[3::6]
comptext = line[4::6]

del line

""""get base start and end range"""

baserange = list(map(getRanges, baserange))


temp = list(map(getStartEnd, baserange))
base_start, base_end = zip(*temp)

base_start = list(base_start)
base_end = list(base_end)


""""get compare start and end range"""


comprange = list(map(getRanges, comprange))
comprange_t = list(map(editRef, comprange))

temp = list(map(getStartEnd, comprange_t))
comp_start, comp_end = zip(*temp)

comp_start = list(comp_start)
comp_end = list(comp_end)

del temp, comprange_t

"""creating the dataframe"""

CompData = pd.DataFrame({'BaseText': basetext, 'CompText': comptext,
                        'BaseRange':baserange,'CompRange': comprange,
                        'BaseStart':base_start,'BaseEnd':base_end,
                        'CompStart':comp_start,'CompEnd':comp_end})



"""deleting intermediate steps"""

    
del base_end,base_start, baserange, basetext, comp_end, comp_start
del comprange, comptext


"""output to csv"""    

CompData.to_csv("Output.csv", encoding='utf-8')

"""************************************************************************"""
