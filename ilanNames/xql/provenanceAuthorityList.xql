declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
(: en gr checkme he:)

declare variable $nymloc := 'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/nyms.xml'; 
(:declare variable $nyms:=doc($nymloc); :)
let $persons := collection(iri-to-uri('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/persons'))//*:person
return 
    ('lemma,pointer_in_volume,provenance&#xd;',
    for $p in $persons
    return 
                       (string-join((
                       string-join($p/tei:persName[@type='lemma']),
                            $p/@n,
                            if ($p/tei:state[@type='provenance']/tei:note)
                            then 
                                 normalize-space($p/tei:state[@type='provenance']/tei:note)
                            else ('[Palestine?]')
                                 ),
                       ','), 
                       '&#xd;'))