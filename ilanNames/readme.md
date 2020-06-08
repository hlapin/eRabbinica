# Tal Ilan Lexicon of Jewish Names

## Proposed Working File Structure

Records

```
         <listPerson xml:id="eg_Abraham">
            <!-- use @corresp rather than nymRef on individual names? -->
            <person xml:id="ID" n="eg_Abraham_1" corresp="#some_key_to_original_publication_by_vol_ch_entry?">
               <!-- as many as necessary to cover different spellings, renderings, transcriptions -->
               <sex cert="may_be_useful_to_indicate"></sex>
               <persName type="full" xml:lang="en">Full name as cited in English</persName>
               <persName type="full" xml:lang="original_language_code">Full name as cited in source language</persName>
               <persName nymRef="#nym_main_or_form">
                  <name></name>
                  <addName type="eg_toponym">
                     <placeName></placeName>
                  </addName>
                  <addName type="eg_Patronymic"></addName>
               </persName>
               <persName> ... </persName>
               <floruit notBefore="2019" notAfter="2020"></floruit>
               <listRelation> <!-- NB: invalid here under default TEI-all -->
                  <!-- as many as necessary to cover family, associates, disciples etc. -->
                  <relation key="is-related-by_some_key"></relation>
               </listRelation>
               <bibl><!-- for the most part field "S[ource]" from the original --></bibl>
               <!-- may make sense to keep notes elsewere at some point but for now keep with record. -->
               <note></note>
               <note></note>
               
               <!-- one or more of these as needed, or @xml:id -->
               <idno></idno>
            </person>
            <person xml:id="ID2" n="eg_Abraham_2" corresp="#some_key_to_original_publication_by_vol_ch_entry?"></person>
         </listPerson>
         <listPerson xml:id="eg_Abshalom">
            <person>
               <persName></persName></person>
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

