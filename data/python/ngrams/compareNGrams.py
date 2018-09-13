import csv
import os
import itertools
import jellyfish
#why this syntax?
from operator  import itemgetter


#read list of nGrams from file,
#sort by frequency, truncate after largest 10%

nGrams = []
with open('consolidated_nGrams.txt','r') as f:
	readObj = csv.reader(f,delimiter = ',')
	nGrams = list(list(row) for row in csv.reader(f, delimiter=','))

#sort by size
nGrams.sort(key=lambda x: int(x[1]), reverse=True)
#lambda creates an inline function, 
#which sets x = to the integer value of item[1], i.e. freq of list

#reduce to unique items
checkUnique = set()
nGramsUnique=[]
for record in nGrams:
	if record[0] not in checkUnique:
		checkUnique.add(record[0])
		nGramsUnique.append(record)

listLen = len(nGramsUnique)/10


#truncate list
nGramsUnique = nGramsUnique[:listLen]
nGramsUnique.sort(key=itemgetter(0))




out = []

#http://stackoverflow.com/questions/16603282/how-to-compare-each-item-in-a-list-with-the-rest-only-once
for a, b in itertools.combinations(nGramsUnique, 2):
	jd = jellyfish.jaro_distance(unicode(a[0],'utf-8'),unicode(b[0],'utf-8'))
	out.append([a[0], b[0], jd])


#Output
#listing of uniqe nGrams maong the top 10%
with open("uniqueNGramsTop10Pct.txt", "w") as uniqeList:
	row = csv.writer(uniqeList)
	row.writerows(nGramsUnique)



#similarity and difference tables
head = [['str1','str2','dist']]

#similarities
with open("similarities.txt", "w") as f2:
	row = csv.writer(f2)
	row.writerows(head)
with open("similarities.txt", "a") as f2:
	row = csv.writer(f2)
	row.writerows(out)

#distances
#convert distance to 1 - distance
for record in out:
	record[2] = 1 - record[2]

with open("distances.txt", "w") as f3:
	row = csv.writer(f3)
	row.writerows(head)
with open("distances.txt", "a") as f3:
	row = csv.writer(f3)
	row.writerows(out)

#truncated list of ngrams
with open("truncatedNGrams.txt","w") as f4:
	row = csv.writer(f4)
	row.writerows(nGramsUnique)