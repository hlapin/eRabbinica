import csv
import fileinput
import nGrams
import os
import shutil

#'parameters'
plainTxtF = "ref-b-plain"
tokensListWIds = "ref-b"
nGramsList = ""

print "starting"
#these go into file name
n = 3 			#smaller n in tested range of nGrams
nEnd = 6 		#larger n for nGrams
moreThan = 5 	#where prior processing saved nGrams appearing more than threshold

#clear the consolidated list of 
#location for the consolidated list:
consolid = tokensListWIds +  "_Consolid"

open(consolid + ".txt","w").close()

#pass over multiple files in sequence
if nEnd == None or nEnd <= n:
	nEnd = n

outList = []

for i in range(nEnd, n - 1, -1):
	print i
	nGramsList = plainTxtF + "_" + str(i) + "_grams_gt_" + str(moreThan)
	with open(nGramsList + ".txt", "r") as fIn:
		tempTest = fIn.read()
		with open(consolid + ".txt","a") as f2:
			f2.write(tempTest)

tokens = nGrams.replaceNGramWToken(plainTxtF, consolid)

outList = nGrams.reducedTokenList(tokens, tokensListWIds)
		
with open(tokensListWIds + "-reduced.txt",'w+') as outFile :
	row = csv.writer(outFile)
	row.writerows(outList)

