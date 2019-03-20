import operator
import csv
import fileinput
import shutil
import locale


#opens designated files
#splits on spaces
def openAndSplit(fName):
#better way to handle this for truly large files?
#iterate by lines, but 
#remember the n-1 words from previous line?
	with open(fName + ".txt","r") as f:
		text = f.read()
		# text =""
		# for line in f:
		# 	text += line
		splitTokens = text.split()
	
	return splitTokens



# returns n grams based on specified n
# see: http://programminghistorian.org/lessons/keywords-in-context-using-n-grams
def getNGrams (tokens, n):
	ngrams = []
	for i in range(len(tokens)-(n-1)):
		ngrams.append(tokens[i:i+n])
	
	return ngrams

#converts n-grams into single _separated strings
def join(groups):
	joined = []
	for i in range(0,len(groups)):
		joined.append('_'.join(groups[i]))

	return joined

#takes n-grams as single tokens
#stores counts number  in a dictionary
def freqDict(grams):
	nGramsFreq={}
	#creates a dictionary
	for item in grams:
		if item in nGramsFreq:
			nGramsFreq[item] += 1
		else:
			nGramsFreq[item] = 1
	
	return nGramsFreq

def freqGtN(freqList, moreThan):
	#to get the frequency greater than x
#create a dictionary that selects key values greater than moreThan
	freqGt={}
	freqGt = dict((k,v) for k, v in freqList.items() if v > moreThan)

	return freqGt


#takes frequency list as dictionary
#returns a sorted list beginning at beg and extending to end
def sortByFreq(freqList, beg, end):
	sortedGrams = []
	sortedGrams = sorted(freqList.iteritems(),\
		key = operator.itemgetter(1),\
		reverse = True)[beg:end]
		#operator.itemgetter(1) #returns the second term in [0][1]?

	return sortedGrams 


#searches and replaces nGram strings with selected single-token _ separated nGrams
#also writes new data to new file
#is it "good form" to have a single function do two different things"
def replaceNGramWToken(strFile,nGrFile):
	#empties the reduced text file to start over.
	open(strFile + "-reduced.txt","w").close()

	f1 = open(strFile + ".txt", "r")
	text = f1.read()
	f1.close()

	with open(nGrFile + ".txt", "r") as f2:
		testReader = csv.reader (f2, delimiter = ",") #where does this go?
		nGrams = list(list(row) for row in csv.reader(f2, delimiter =','))

	for nGram in nGrams:
		#replace ngrams with single token using _ for spaces
		string = ' '.join(nGram[0].split('_')) # the string as it appears in the original
		text = text.replace(string,nGram[0]) 

	#re-split on spaces
	tokens = text.split(' ')

	with open(strFile + "-reduced.txt","w") as f3:
		f3.write(text)

	return tokens


#compare plainTxtList = plain text as list to 
#idListFile = file of original tokens withID
def reducedTokenList(plainTxtList, idListF):
	with open(idListF + ".txt","rU") as idList:
		isListReader = csv.reader (idList, delimiter = ',')
		idItems = list(list(r) for r in csv.reader(idList, delimiter=','))
	


	outList = []
	j=0
	i=0


	while i <= len(idItems):
		#should use try ...
		if j < len (plainTxtList) -1 :
			compString = plainTxtList[j].split('_')
			if idItems[i][1] == compString[0]:
				idItems[i][1] = plainTxtList[j]
				outList.append(idItems[i])
				#print outList[i]
				#print str(i) + ': ' + idItems[i][1] + ' ' + plainTxtList[j]
				i= i + len(compString)
			else: i = i + 1	
			j=j+1
		else:

			i=i+1
	
	return outList