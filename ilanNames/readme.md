# Tal Ilan Lexicon of Jewish Names

## Proposed Working File Structure

Records

```xml
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader> <!-- --> </teiHeader>
   <text>
      <body>
         <listPerson xml:id="Abshalom" n="אבשלום">
            <!-- ... -->        
            <person xml:id="vol-2-B_M-d1e722" n="Abshalom-2">
               <sex cert="high">M</sex>
               <persName type="lemma">אבשלום<ref corresp="#d1e675"/>
               </persName>
               <persName type="lemma" xml:lang="en">Abshalom</persName>
               <persName xml:lang="he-or-aram">אבטולמוס<ref corresp="#d12e3"/>
               </persName>
               <persName xml:lang="he-or-aram">/אבטלמס<ref corresp="#d12e11"/>
               </persName>
               <persName xml:lang="he-or-aram">/אבטלוס<ref corresp="#d12e19"/>
               </persName>
               <persName xml:lang="he-or-aram">/אבישלום<ref corresp="#d12e27"/>
               </persName>
               <state type="desc">
                  <note>Simon (31)’s father</note>
               </state>
               <bibl>bBer7b<ref corresp="#d1e765"/>(Kosowsky,Babylonico, 1686)</bibl>
               <floruit>Pre-400<ref corresp="#d1e788"/>
               </floruit>
               <note xml:id="d1e726" n="2">So in the printed version tobBB68a, This person was obviously not well known, and his name was not stable so that the scribes of the mss were not sure how to write it, see vol. 4, Introduction 5.1.1.2.1.1, pp. 23-4. For this form see vol. 1, under Eutolmus (3) G/M, p. 279. Perhaps this was his name, and אבשלום is a scribal “correction” see vol. 4, Introduction 2.7.2, p. 18.</note>
               <note xml:id="d1e733" n="3">So in the Vatican 115 Ms tobBB68a, see previous note. On the form אבטולמוס see previous note. On the fall of the וs see vol. 4, Introduction 2.3.5.4, p. 13.</note>
               <note xml:id="d1e740" n="4">So in the Florence II-I-9 Ms tobBB68a, see above, n. 3. For this form see vol. 1, under Eutolmus (2) G/M, p. 279.</note>
               <note xml:id="d1e747" n="5">So in the printed versions ofbBer7b, see above, n. 3. For this form see vol. 1, under Abshalom (6) B/M, p. 60.</note>
               <note xml:id="d1e765" n="6">Although mentioned only in BT, his son is designated רבי in all the traditions in which he is mentioned (bBer7a;bMeg14a andbBB68a), see Introduction 5.1.3.2.2 and transmits traditions in Hebrew, see Introduction 5.1.3.2.5.</note>
               <note xml:id="d1e788" n="7">Mentioned in no chronological context, see Introduction 7.4.4.</note>
            </person>
            <!-- ... -->            
         </listPerson>
```

Possibly elsehwere
```
         <listNym>
            <!-- is a list of nyms = canonical forms necessary? -->
            <nym xml:id="nym_"><form xml:id="nym_subRef">Abraham</form></nym>
         </listNym>
         <listPlace>
            <!-- At least initially, need to maintain our own list -->
            <!-- eventually just link to authority file? -->
            <place></place>
         </listPlace>
     </body>         
  </text>         
</TEI>         
```

Note: current step doc/docx to TEI

## Workflow:
* For each volume break down into names and tne persons
* bundle by name / nym?



## Needed
Ontologies for persons, relations between persons (is SAWS sufficient?)

Standardized place names, geolocation (hamappah), relations with places

Speialized ontology for uncertainty (A is/is not B)
## Possible
VIAF?
CTS links to documents available in epidoc/tei?

