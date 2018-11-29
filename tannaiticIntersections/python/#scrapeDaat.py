#coding utf-8

import os
import urllib3
import re
from bs4 import BeautifulSoup

filePath = "C:\\Users\\hlapin\\Documents\\GitHub\\eRabbinica\\tannaiticIntersections\\data\\html\\"

for filename in os.listdir(filePath):
	if filename.startswith('daat-mek') and filename.endswith('html'):
		with open(os.path.join(filePath,filename), encoding="cp1255") as f:
			print (filename)
			contents = f.read()
			soup = BeautifulSoup(contents, "html.parser")
			# have to deal with the fact that the documents are poorly constructed
			# root = soup.find('html')
			# root.name = 'root'
			# out = soup.prettify()
			# lines = out.splitlines()
			# lines[0] = ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
			# out = '\n'.join(lines)
			out = soup.prettify()
			shortName = str(filename.split(".")[0])
			outf = filePath + shortName + ".xml"
			print (outf)
			with open (outf, "w", encoding='utf-8') as fOut:
				fOut.write ('<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>')
				fOut.write(out)
				fOut.write('</root>')
