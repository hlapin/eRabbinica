<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:functx="http://www.functx.com"
    xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs local functx"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:variable name="x-person-keys">
        <xsl:variable name="persons" select="/TEI/text/body/div/ab/listPerson/person"/>
        <xsl:for-each-group select="/TEI/text/body/div/ab/listPerson/person" group-by="replace(@n,'^(Vol-[1-4]).+','$1')">
            <xsl:element name="{current-grouping-key()}">
                <xsl:for-each select="current-group()">
                    <x-person x="{@xml:id}" n="{@n}"/>    
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:variable>
    <xsl:key name="x-persons" match="*:x-person" use="string(@n)"/>
    <xsl:template match="/">
       <!-- <testOut>
            <!-\-<xsl:copy-of select="$x-person-keys/*[1]"></xsl:copy-of>
            <test><xsl:copy-of select="key('x-persons',matches('Vol-1-B_F-Abigael-1','Vol-1+?Abigael-1'),$x-person-keys)/@x"/></test>-\->
          <xsl:variable name="check"><xsl:call-template name="volumes"></xsl:call-template></xsl:variable>
          <xsl:copy-of select="$check/*"></xsl:copy-of>
        </testOut>-->
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="ab">
        <xsl:variable name="idToUse" select="substring-before(tokenize(@corresp, '[#/]')[last()],'Vol-')"/>
        <!--<xsl:message select="concat($idToUse, position())"></xsl:message>-->
<!--        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="replace(concat('names-xr/name-',$idToUse, position(),'.xml'),'\s','')"></xsl:attribute>
            <xsl:attribute name="xpointer" select="replace(concat('name-',$idToUse,generate-id() ),'\s','')"></xsl:attribute>
        </xsl:element>
        <xsl:result-document encoding="utf-8" href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/names-xr/{concat('name-',$idToUse, position())}.xml">
            <TEI >
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Tal Ilan Lexicon, Master List -\- <xsl:value-of select="@n"/></title>
                        </titleStmt>
                        <publicationStmt>
                            <p>Publication Information</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Information about the source</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <div type='name'>-->
                            <ab>
                                <xsl:copy-of select="@*"></xsl:copy-of>
                                <xsl:attribute name="xml:id" select="replace(concat('name-',$idToUse,generate-id() ),'\s','')"></xsl:attribute>
                                <xsl:apply-templates></xsl:apply-templates>
                            </ab>
    <!--                    </div>
                    </body>
                </text>
            </TEI>
           
        </xsl:result-document>-->
    </xsl:template>
    
    <!-- parent::floruit matches cases where D: Ds: was mis matched from original. -->
    <xsl:template match="text()[parent::floruit|ancestor::state[@type='desc']]">
            <xsl:choose>
                <xsl:when
                    test="matches(., '([^,.\s\d]+)\s+(\((\d+)\)[''’]s)\s+([^?,.\s\d]+)')">
                    <xsl:variable name="prefix-to-use" select="substring(ancestor::person/@n,0,6)"/>
                    <xsl:variable name="prefix-to-test"
                        select="concat('^', replace(ancestor::person/@n, '^(Vol-[1234]).+', '$1'),'(?!(-Vol)).+?')">
                        <!-- NB: uses negative lookahead, assumes java regex engine rather than saxon -->
                    </xsl:variable>
                    <xsl:analyze-string select="."
                        regex="([^,.\s\d]+)\s+(\((\d+)\)[''’]s)\s+([^?,.\s\d]+)">
                    <xsl:matching-substring>
                        <xsl:variable name="name-to-test"
                            select="concat($prefix-to-test, regex-group(1), '-', regex-group(3), '$')"/>
                        <ref
                            corresp="#{key('x-persons',for $s in $x-person-keys/*[name() = $prefix-to-use]/*[matches(@n,$name-to-test,';j')] 
                            return $s/@n,$x-person-keys/*[name() = $prefix-to-use])/@x}"
                            type="relation" n="{regex-group(4)}-of">
                            <xsl:value-of
                                select="."/>
                        </ref>
                    </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                        <xsl:fallback>
                            <problemhere>
                                <xsl:value-of select="."/>
                            </problemhere>
                        </xsl:fallback>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    
    <!-- occasional floruit which are really descriptions - error in matching D: vs Ds: in source? -->
    <!-- am trying to capture those that include "relations"  -->
    <xsl:template match="floruit[matches(., '([^,.\s\d]+)\s+(\((\d+)\)[''’]s)\s+([^?,.\s\d]+)')]">
        <state type="desc">
            <note><xsl:apply-templates/></note>
        </state>
    </xsl:template>
    
    <!--  dates in floruit; matching ONLY those examples that end in BC/BCE only -->
    <xsl:template match="cell">
        <xsl:element name="{name()}">
                <!-- less repetitive way to do this? -->
                <xsl:choose>
                    <!-- Patterns of yy B*CE -->
                    <xsl:when test="matches(normalize-space(.),'^[\s&#xa0;]*(\d+)[\s&#xa0;]*(B*CE)[\s&#xa0;]*$')">
                        <xsl:analyze-string select="normalize-space(.)" regex="^[\s&#xa0;]*(\d+)[\s&#xa0;]*(B*CE)[\s&#xa0;]*$">
                            <xsl:matching-substring>
                                <xsl:variable name="bceCe" select="if (regex-group(2) eq 'BCE') then '-' else ''"/>
                                <xsl:variable name="notBefore" select="regex-group(1)"/>
                                <xsl:variable name="notAfter" select="regex-group(1)"/>
                                <xsl:attribute name="notBefore" select="concat($bceCe,functx:pad-integer-to-length($notBefore,4))"></xsl:attribute>
                                <xsl:attribute name="notAfter" select="concat($bceCe,functx:pad-integer-to-length($notAfter,4))"></xsl:attribute>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <!-- Patterns: variants of 2nd C BCE-3rd C CE -->
                    <xsl:when test="matches(normalize-space(.), '^[\s&#xa0;]*((\d+)*(nd|st|th|rd)[\s&#xa0;]*C*[\s&#xa0;]*(B*CE)*[\s&#xa0;]*[&#x2013;\-])*[\s&#xa0;]*(\d+)(nd|st|th|rd)[\s&#xa0;]*C*[\s&#xa0;]*(B*CE)[\s&#xa0;]*$')">
                        <xsl:analyze-string select="." regex="^[\s&#xa0;]*((\d+)*(nd|st|th|rd)[\s&#xa0;]*C*[\s&#xa0;]*(B*CE)*[\s&#xa0;]*[&#x2013;\-])*[\s&#xa0;]*(\d+)(nd|st|th|rd)[\s&#xa0;]*C*[\s&#xa0;]*(B*CE)[\s&#xa0;]*$">
                            <xsl:matching-substring>
                                <!--<xsl:message select="string-join((regex-group(1),regex-group(2),regex-group(3),regex-group(4),regex-group(5),regex-group(6),regex-group(7)),' | ')"/>-->
                                <xsl:variable name="notBeforeBceCe" select="
                                    if (normalize-space(regex-group(4))) then 
                                            if (regex-group(4) eq 'BCE') then '-'
                                            else '' 
                                   else  if (normalize-space(regex-group(7))) then 
                                            if (regex-group(7) eq 'BCE') then '-' else ''    
                                    else ()"/>
                                    <!-- 3rd  CE =  >=  200  - 299 --> 
                                    <!-- 3rd BCE = >= -299 - -200-->
                                <xsl:variable name="notAfterBceCe" select="if (regex-group(7) eq 'BCE') then '-' else '' "/>
                                <xsl:variable name="notBefore" select="
                                        if (number(regex-group(2))) then 
                                            (: has two number separated by hyphen/dash :)
                                             if ($notBeforeBceCe eq '-') then (: BCE :)
                                                (number(regex-group(2)) * 100) - 1 
                                             else (number(regex-group(2)) - 1)  * 100
                                          else   (: if not number(regex-group(2)) - single number :)
                                            if ($notAfterBceCe eq '-') then
                                                (number(regex-group(5)) * 100) - 1 
                                            else (number(regex-group(5)) - 1)  * 100    
                                       ">
                                </xsl:variable>
                                <!-- 3rd  CE =  >=  200  - 299 --> 
                                <!-- 3rd BCE = >= -299 - -200-->
                                <xsl:variable name="notAfter" select="
                                    if ($notAfterBceCe eq '-') then
                                        (number(regex-group(5)) - 1) * 100
                                    else (number(regex-group(5))  * 100 ) - 1   
                                    "/>
                                <xsl:attribute name="notBefore" select="concat($notBeforeBceCe,functx:pad-integer-to-length($notBefore,4))"></xsl:attribute>
                                <xsl:attribute name="notAfter" select="concat($notAfterBceCe,functx:pad-integer-to-length($notAfter,4))"></xsl:attribute>
                            </xsl:matching-substring>
                           
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^[\s&#xa0;]*(Pre[&#x2013;\-]|Post[&#x2013;\-]|Late\-*)*[\s&#xa0;]*(\d+)(nd|st|th|rd)*[\s&#xa0;]*C*[\s&#xa0;]*(B*CE)[\s&#xa0;]*$')">
                        <xsl:analyze-string select="normalize-space(.)" regex="^[\s&#xa0;]*(Post[&#x2013;\-]|Pre[&#x2013;\-]|Late)[\s&#xa0;]*(\d+)(nd|st|th|rd)*[\s&#xa0;]*C*[\s&#xa0;]*(B*CE)[\s&#xa0;]*$">
                            <xsl:matching-substring>
                                <xsl:variable name="bceCe"  select="if (regex-group(4) eq 'BCE') then '-' else '' "/>
                                <xsl:variable name="notBefore" select="
                                    if (normalize-space(regex-group(3))) then
                                        (: a century ref :)
                                        if ($bceCe eq '-' ) then (:BCE:)
                                             (: pre-4th C BCE = not before = '', not after = -399 :)
                                             (: post-4th C BCE = not before -300, not after = '' :)
                                             (: late-4th BCE = not before -350, not after -300:)
                                            if (regex-group(1) eq 'Post-') then (number(regex-group(2)) -1 ) * 100
                                            else if (regex-group(1) eq 'Pre-') then ()
                                            else if (matches(regex-group(1), 'Late')) then (number(regex-group(2)) *100) - 50 
                                            else ()
                                        else (: CE :) 
                                        (: pre-4th C CE = not before = '', not after = 300 :)
                                        (: post-4th C CE = not before 399, not after = '' :)
                                        (: late-4th CE = not before 350, not after 399:)
                                             if (regex-group(1) eq 'Post-') then (number(regex-group(2))  * 100) - 1
                                             else if (regex-group(1) eq 'Pre-') then ()
                                             else if (matches(regex-group(1), 'Late')) then (number(regex-group(2)) *100) - 50 
                                             else ()                                            
                                    else  
                                        (: a year reference :)
                                        (: 320 BCE = not before -321, not after -320 :)
                                        (: 320 CE = not before 320, not after 321 :)
                                        if ($bceCe = '-') then (: BCE :)
                                            number(regex-group(2)) + 1
                                        else number(regex-group(2))    
                                            "/>
                                <xsl:variable name="notAfter" select="
                                    if (normalize-space(regex-group(3))) then
                                    (: a century ref :)
                                    if ($bceCe eq '-' ) then (:BCE:)
                                    (: pre-4th C BCE = not before = '', not after = -399 :)
                                    (: post-4th C BCE = not before -300, not after = '' :)
                                    (: late-4th BCE = not before -350, not after -300:)
                                    if (regex-group(1) eq 'Post-') then ()
                                    else if (regex-group(1) eq 'Pre-') then (number(regex-group(2))  * 100 ) - 1
                                    else if (matches(regex-group(1), 'Late')) then (number(regex-group(2)) -1 ) * 100 
                                    else ()
                                    else (: CE :) 
                                    (: pre-4th C CE = not before = '', not after = 300 :)
                                    (: post-4th C CE = not before 399, not after = '' :)
                                    (: late-4th CE = not before 350, not after 399 :)
                                    if (regex-group(1) eq 'Post-') then ()
                                    else if (regex-group(1) eq 'Pre-') then (number(regex-group(2)) * 100) - 1
                                    else if (matches(regex-group(1), 'Late')) then (number(regex-group(2)) *100) - 1 
                                    else ()                                            
                                    else  
                                    (: a year reference :)
                                    (: 320 BCE = not before -321, not after -320 :)
                                    (: 320 CE = not before 320, not after 321 :)
                                    if ($bceCe = '-') then (: BCE :)
                                        number(regex-group(2)) + 1
                                    else number(regex-group(2))    
                                    "/>
                                <xsl:if test="$notBefore"><xsl:attribute name="notBefore" select="concat($bceCe, functx:pad-integer-to-length($notBefore, 4))"></xsl:attribute></xsl:if>
                                <xsl:if test="$notAfter"><xsl:attribute name="notAfter" select="concat($bceCe, functx:pad-integer-to-length($notAfter,4))"></xsl:attribute></xsl:if>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.), '^(\d+)[/&#x2013;\-](\d+)[\s&#xa0;]*(B*CE)[\s&#xa0;]*$')">
                        <xsl:analyze-string select="normalize-space(.)"
                            regex="^(\d+)[/&#x2013;\-](\d+)[\s&#xa0;]*(B*CE)[\s&#xa0;]*$">
                            <xsl:matching-substring>
                                <xsl:variable name="bceCe"
                                    select="if (regex-group(3) eq 'BCE') then '-' else  ''"/>
                                <xsl:variable name="notBefore" select="regex-group(1)"/>
                                <xsl:variable name="notAfter">
                                    <xsl:choose>
                                        <xsl:when test="$bceCe eq '-'">
                                            <!-- BCE -->
                                            <!-- 102/1 BCE:  assume second integer is truncated  vs 102-1 BCE:  assume second integer is complete-->
                                            <xsl:variable name="prefix" select="substring(regex-group(1), 1, string-length(regex-group(2)))"/>
                                            <xsl:value-of select="concat(if(regex-group(2) eq '/') then $prefix else '',regex-group(2)) "/>
                                            <!--  -->
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- CE -->
                                            <xsl:choose>
                                                <xsl:when test="string-length(regex-group(3)) &lt; string-length(regex-group(1)) ">
                                                    <xsl:variable name="prefix" select="substring(regex-group(1),1,string-length(regex-group(1)) - string-length (regex-group(2)))"/>
                                                    <xsl:value-of select="concat($prefix,regex-group(2))"/>
                                                </xsl:when>
                                                <xsl:otherwise><xsl:value-of select="regex-group(2)"/></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:if test="$notBefore">
                                    <xsl:attribute name="notBefore" select="concat($bceCe, functx:pad-integer-to-length($notBefore, 4))"/>
                                </xsl:if>
                                <xsl:if test="$notAfter">
                                    <xsl:attribute name="notAfter" select="concat($bceCe, functx:pad-integer-to-length($notAfter, 4))" />
                                </xsl:if>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:when test="matches(normalize-space(.),'^(\d+)s[&#x2013;\-](\d+)s[\s&#xa0;]*(B*CE)[\s&#xa0;]*$')">
                        <xsl:analyze-string select="normalize-space(.)" regex="^(\d+)s[&#x2013;\-](\d+)s[\s&#xa0;]*(B*CE)[\s&#xa0;]*$"><xsl:matching-substring>
                        <xsl:variable name="bceCe" select="if (regex-group(3) eq  'BCE') then '-' else '' "/>
                        <xsl:variable name="numZerosOnFirst" select="string-length(regex-group(1)) - string-length(tokenize(regex-group(1),'0+')[1])"/>
                        <xsl:variable name="numZerosOnSecond" select="string-length(regex-group(2)) - string-length(tokenize(regex-group(2),'0+')[1])"/>
                        <xsl:variable name="notBefore" select="
                            if ($bceCe eq '-') then (number(regex-group(1))) + math:pow(10,$numZerosOnFirst) - 1
                            else regex-group(1)"/>
                        <xsl:variable name="notAfter" select="
                            if ($bceCe eq '-') then regex-group(2)
                            else (number(regex-group(2))) + math:pow(10,$numZerosOnSecond) - 1"/>
                        <xsl:attribute name="notBefore" select="concat($bceCe, functx:pad-integer-to-length($notBefore,4)) "/>
                        <xsl:attribute name="notAfter" select="concat($bceCe, functx:pad-integer-to-length($notAfter,4))" />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring></xsl:analyze-string></xsl:when>
                    <!--<xsl:otherwise>
                        <!-\- other string gets passed through -\->
                        <!-\- child elements (tei:ref) get processed  -\->
                        <xsl:apply-templates/>
                    </xsl:otherwise>-->
                </xsl:choose>
            <!-- what does this not work? -->
            <!--<xsl:apply-templates></xsl:apply-templates>-->
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::element()"><xsl:apply-templates select="."></xsl:apply-templates></xsl:when>
                    <xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!--  ^(.+)((B|G|Ha|L|P|S|I\-G|S\-H|A|E|I)_(M|F|Names)).+$', $1  -->
    <xsl:template name="volumes">
        <!-- returns a list of  chapters grouped by volume-->
        <xsl:variable name="files">
            <xsl:for-each
                select="
                    distinct-values(for $c in /TEI/text/body/div/ab/@corresp
                    return
                        for $f in tokenize($c, '\s')
                        return
                            tokenize($f, '/')[2])">
                <xsl:sort select="replace(., '^(Vol\-[\d]\-).+$', '$1')"/>
                <item><xsl:copy-of select="replace(., '(^.+(Ha|A|E|I|B|G|L|P|S\-G|S\-H)_(Names|M|F)).+-names\.xml$', '$1')"/></item>
            </xsl:for-each>
        </xsl:variable>
        <!-- put chs into volumes and workable order, longest to shortest -->
        <xsl:for-each-group select="for $i in $files/* return $i" group-by="replace(.,'^(Vol\-\d).+$','$1')">
            <list type="{replace(current-group()[1],'^(Vol\-\d).+$','$1')}">
                <xsl:for-each select="for $i in current-group() return ($i)">
                <xsl:sort select="string-length(.)" order="descending"  data-type="number"></xsl:sort>
                    <xsl:copy-of select="."></xsl:copy-of>
                </xsl:for-each></list>
        </xsl:for-each-group>
    </xsl:template>
    <!-- ******************************************************************************** -->
    <xsl:function name="functx:pad-integer-to-length" as="xs:string">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        
        <xsl:sequence select="
            if ($length &lt; string-length(string($integerToPad)))
            then error(xs:QName('functx:Integer_Longer_Than_Length'))
            else concat
            (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
            string($integerToPad))
            "/>
        
    </xsl:function>
    <xsl:function name="functx:repeat-string" as="xs:string">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:sequence select="
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "/>
        
    </xsl:function>
    
</xsl:stylesheet>