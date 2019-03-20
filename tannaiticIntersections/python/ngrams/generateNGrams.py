import nGrams #my functions in nGrams.py
import csv

# "parameters"
n = 3
nEnd = 6
inFName = "ref-sifrei-d-plain"
moreThan = 5 #use to get above threshold
#topN = 0 #use to set n most frequent

if nEnd == None or nEnd <= n:
	nEnd = n

for i in range(nEnd,n-1, -1):
	print i

	tokens = []
	tokens = nGrams.openAndSplit(inFName)

	myNGrams=[]
	myNGrams = nGrams.getNGrams(tokens,i)

	joined = nGrams.join(myNGrams)

	#get a frequency list of n-grams
	nGramsFreq = {}
	nGramsFreq = nGrams.freqDict(joined)

	#to get the frequency greater than moreThan
	#create a dictionary that selects key values greater than nEnd
	d = {}
	d = nGrams.freqGtN(nGramsFreq, moreThan)

	#to return the m most frequent in a sorted list
	#use in below: nGrams.sortByFreq(nGramsFreq, len(nGramsFreq)-m, len(nGramsFreq))
	sorted=[]
	sorted = nGrams.sortByFreq(d, 0, len(d))

	outFile = open(inFName + "_" + str(i) + "_grams" + "_gt_" + str(moreThan) + ".txt",'w+')
	with outFile as f:
		row = csv.writer(f)
		row.writerows(sorted)
	outFile.close()




