declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
(: en gr checkme he:)

declare variable $nymloc := 'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/nyms.xml'; 
declare variable $nyms:=doc($nymloc);

let $persons := collection(iri-to-uri('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/persons'))//*:person
return 
    ('person:nym,person:lemma_en,person:lemma_ancient,person:orthography,person:sex,person:hebrew,person:greek,person:checkme,person:id,person:pointer_in_volume,name:id,name:form,name:language_type,name:gender_type&#xd;',
    for $p in $persons
    return (string-join(($p/parent::tei:listPerson/@n/string(),
                        $p/tei:persName[@xml:lang eq 'en' and @type='lemma']/string(),
                         if ($p/tei:persName[not(@xml:lang) and @type='lemma']/text())
                                then normalize-space(string-join($p/tei:persName[not(@xml:lang) and @type='lemma']/text())) 
                                else '',
                        normalize-space(string-join($p/tei:persName[not(@*)]/text())),
                         $p/tei:sex,
                         (:if ($p/tei:persName[@xml:lang='en' and not(@type='lemma')]) 
                                then normalize-space(string-join($p/tei:persName[@xml:lang='en' and not(@type='lemma')]))
                                else '',:)
                         if ($p/tei:persName[@xml:lang='he' and not(@type='lemma')]) 
                                then normalize-space(string-join($p/tei:persName[@xml:lang='he' and not(@type='lemma')]))
                                else '',       
                         if ($p/tei:persName[@xml:lang='gr' and not(@type='lemma')]) 
                                then normalize-space(string-join($p/tei:persName[@xml:lang='gr' and not(@type='lemma')]))
                                else '',
                         if ($p/tei:persName[@xml:lang='checkme' and not(@type='lemma')]) 
                                then normalize-space(string-join($p/tei:persName[@xml:lang='checkme' and not(@type='lemma')]))
                                else '',
                         $p/@xml:id/string(),
                         $p/@n/string(),
                        $nyms/id(tokenize($p/parent::tei:listPerson/@corresp,'#')[2])/@xml:id/string(),
                        normalize-space(string-join($nyms/id(tokenize($p/parent::tei:listPerson/@corresp,'#')[2])/tei:form)),
                        substring-before($nyms/id(tokenize($p/parent::tei:listPerson/@corresp,'#')[2])/@type/string(),'_'),
                        substring-after($nyms/id(tokenize($p/parent::tei:listPerson/@corresp,'#')[2])/@type/string(),'_')
                         ),','),'&#xd;'))