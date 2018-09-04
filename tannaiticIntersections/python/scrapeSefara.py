# coding=utf-8
import os
import urllib3
import re
from bs4 import BeautifulSoup



# gave up on more complicated editing in python. 
# prettify in beautifulsoup easily gave xml compliant output
# can then transform in xslt

docs = {
	"r11" : ["Berakhot","0101"],
	"r12" : ["Peah", "0102"],
	"r13" : ["Demai", "0103"],
	"r14" : ["Kilaim", "0104"],
	"r15" : ["Sheviit", "0105"],
	"r16" : ["Terumot", "0106"],
	"r17" : ["Maasrot", "0107"],
	"r18" : ["Maaser_Sheni", "0108"],
	"r19" : ["Hallah", "0109"],
	"r1a" : ["Orlah", "0110"],
	"r1b" : ["Bikkurim", "0111"],
	"r21" : ["Shabbat", "0201"],
	"r22" : ["Eruvin", "0202"],
	"r23" : ["Pesahim", "0203"],
	"r24" : ["Yoma", "0205"],
	"r25" : ["Sheqalim", "0204"],
	"r26" : ["Rosh_Hashanah", "0208"],
	"r27" : ["Sukkah", "0206"],
	"r28" : ["Betsah", "0207"],
	"r29" : ["Taanit", "0209"],
	"r2a" : ["Megilah", "0210"],
	"r2b" : ["Hagigah", "0212"],
	"r2c" : ["Moed_Qatan", "0211"],
	"r31" : ["Yevamot", "0301"],
	"r32" : ["Ketubot", "0302"],
	"r33" : ["Nedarim", "0303"],
	"r34" : ["Nazir", "0304"],
	"r35" : ["Gittin", "0306"],
	"r36" : ["Qiddushin", "0307"],
	"r37" : ["Sotah", "0305"],
	"r41" : ["Bava_Qamma", "0401"],
	"r42" : ["Bava_Metsiah", "0402"],
	"r43" : ["Bava_Batra", "0403"],
	"r44" : ["Shevuot", "0404"],
	"r45" : ["Makkot", "0405"],
	"r46" : ["Sanhedrin", "0404"],
	"r47" : ["Avodah_Zarah", "0408"],
	"r48" : ["Horayot", "0410"],
	"r61" : ["Niddah", "0601"],
	}





# This works
http = urllib3.PoolManager()
path = "http://www.mechon-mamre.org/b/r/"
for doc in docs.items():
	fName = path + doc[0] + ".htm"
	print (fName)
	html_doc = http.request('GET',fName)
	soup = BeautifulSoup(html_doc.data, 'html.parser')
	root = soup.find('html')
	root.name = 'root'

	root['name'] = doc[1][0]
	print(doc[1][0])
	root['id'] = doc[1][1]
	print(doc[1][1])

	out = soup.prettify()
	lines = out.splitlines()
	lines[0] = ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")

	out = '\n'.join(lines)
	outPath = "C:\\Users\\hlapin\\Documents\\tannaiticIntersections\\SefariaTannaitic\\html\\"
	outf = outPath + "ref-y-" + doc[1][1] + ".xml"
	print (outf)
	with open (outf, "w", encoding='utf-8') as file:
		file.write(out)

	

# pereq = re.compile('^.*(פרק [א-ת]{1,2}\s+הלכה\s+א\s+גמרא).*$')
# div = soup
# notMHeadings = []
# for  b  in soup.find_all('b'):
# 	t = b.get_text()
# 	if not "משנה" in t:
# 		m1 = pereq.match(t).group(1)
# 		try: 
# 			if "משנה" in b.find_previous('b').get_text():
# 				# preceding[1] is a mishnah, go one more previous
# 				m0 = pereq.match(b.find_previous('b').find_previous('b').get_text()).group(1)
# 				if m1 != m0:
# 					notMHeadings.append(b)
# 			else:
# 				# use preceding[2]
# 				m0 =pereq.match(b.find_previous('b').get_text()).group(1)
# 				if m1 != m0:
# 					notMHeadings.append(b)
# 		except AttributeError:
# 			# should this use some sort of null or empty value?
# 			m0 ='xxxxx'
# 			print(m0)
# for i in range(len(notMHeadings)):
# 	print (notMHeadings[i])



# # s ='df yg, a prq yb gmra'
# # m1 = pereq.match(s)
# # print (m1.group(1))




