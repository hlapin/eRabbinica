<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="mode" select="'list'">
        <!-- possible values are 'list' and 'table' -->
        <!-- vol 1 is in table  -->
    </xsl:param>
    <xsl:param name="to_TEI" select="'file:///C:/Users/hlapin/Dropbox/IlanLexiconNames/Vol%202/utf-converted'"/>

    <!-- can update all doc-uri and base-uri calls with this string -->
    <xsl:variable name="doc-uri" select="document-uri(/)" as="xs:string"/>
    <xsl:param name="path"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/'"/>
    
    <xsl:variable name="collect-files" select="collection(concat($to_TEI, '?select=*-to-utf-TEI-P5.xml;recurse=no'))"/>
    
    <xsl:include href="langageConversion.xsl"/>
    <xsl:variable name="to-file-out" select="'names/'"/>
    
    <!--start from xml-->
    <xsl:template match="/">
        
            <xsl:message><xsl:value-of select="base-uri(.)"/><xsl:text> 
           </xsl:text></xsl:message>
        <!--<!-\- this pass is a kludge to provide notes with IDs despite inconsistencies in the base word files and the way they convert to TEI -\->
        <xsl:variable name="firstPass">
            <xsl:apply-templates mode="firstPass"></xsl:apply-templates>
        </xsl:variable>   -->
            <xsl:variable name="parsedTitle" select="local:parseURI(base-uri(.))"/>
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>
                                    <xsl:value-of select="$parsedTitle/local:title"/>
                                </title>
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
                        <xsl:choose>
                            <xsl:when test="$mode='list'">
                                <xsl:apply-templates select="./*/*/body" mode="list"/>
                            </xsl:when>
                            <xsl:when test="$mode='table'">
                                <xsl:apply-templates select="./*/*/body" mode="table"/>
                            </xsl:when>
                        </xsl:choose>
                    </text>
                </TEI>
            <!--</xsl:result-document>-->
    </xsl:template>
    
    <!--start from template-->
    <xsl:template name="start">
       <xsl:for-each select="$collect-files">
           <xsl:message><xsl:value-of select="document-uri(.)"/><xsl:text>
           </xsl:text></xsl:message>
           <xsl:variable name="parsedTitle" select="local:parseURI(document-uri(.))"/>
           <xsl:copy-of select="$parsedTitle[3]"></xsl:copy-of>
           <xsl:result-document encoding="UTF-8" href="{concat($path,$parsedTitle[3],'.xml')}">
               <TEI>
                   <teiHeader>
                       <fileDesc>
                           <titleStmt>
                               <title>
                                   <xsl:value-of select="$parsedTitle/local:title"/>
                               </title>
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
                       <xsl:call-template name="fromList">
                           <xsl:with-param name="body" select=".//body"></xsl:with-param>
                       </xsl:call-template>
                   </text>
               </TEI>
           </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- next two templates a kludge to deal with inconsistencies in underlying word files and how they transfer to TEI -->
    <xsl:template match="node() | @*" mode="firstPass" priority="5">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="firstPass"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="note" mode="firstPass">
        <note>
            <xsl:copy-of select="@*"/>
            <xsl:if test="not(@xml:id)"><xsl:attribute name="xml:id" select="generate-id(.)"></xsl:attribute></xsl:if>
            <xsl:apply-templates mode="firstPass"></xsl:apply-templates>
        </note>
    </xsl:template>
    
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- list based transformations -->
    <xsl:template match="body" mode="list">
        
        <xsl:variable name="names">
            <xsl:for-each-group select=".[list]/*| .//div[list]/*"
                group-starting-with="p[following-sibling::*[1][self::list]]">
                <name>
                    <xsl:copy-of select="current-group()"/>
                </name>
            </xsl:for-each-group>
        </xsl:variable>
        <body>
            <div type="name-list">
                <xsl:apply-templates select="$names/name/list">
                    <xsl:with-param name="parsed-URI" tunnel="yes" select="local:parseURI(base-uri(.))"></xsl:with-param>
                </xsl:apply-templates>
            </div>
            <div type="notes">
                <xsl:apply-templates select="$names/name/list/preceding-sibling::p[1]/note" mode="fn"></xsl:apply-templates>
            </div>
        </body>
    </xsl:template>

    <!-- alternate version of above for starting from template -->
    <xsl:template name="fromList">
        <xsl:param name="body"></xsl:param>
       
        <xsl:variable name="names">
            <xsl:for-each-group select="$body/* | $body/div[list]/*"
                group-starting-with="p[following-sibling::*[1][self::list]]">
                <name>
                    <xsl:copy-of select="current-group()"/>
                </name>
            </xsl:for-each-group>
        </xsl:variable>
        <body>
            <div type="name-list">
                <xsl:apply-templates select="$names/name/list">
                    <xsl:with-param name="parsed-URI" tunnel="yes" select="local:parseURI(document-uri(.))"></xsl:with-param>
                </xsl:apply-templates>
            </div>
            <div type="notes">
                <xsl:apply-templates select="$names/name/list/preceding-sibling::p[1]/note" mode="fn"></xsl:apply-templates>
            </div>
        </body>
    </xsl:template>
    
    <xsl:template match="body" mode="table">
        <body>
            <div type="name-list">
                <xsl:for-each select=".//table">
                    
                    <!-- This could be done more sensibly consistently and in function to remove duplication -->
                    
                    <xsl:variable name="nameTranslit"
                        select="if (preceding-sibling::*/note[1]/following-sibling::node()[normalize-space(.)]) then
                        normalize-space(replace(string-join(preceding-sibling::*/note[1]/(following-sibling::text() | following-sibling::hi)), '[&#x2d;&#x2212;&#x2013;]', ''))
                        else normalize-space(replace(string-join(preceding-sibling::*/note[1]/(preceding-sibling::text() | preceding-sibling::*)), '[&#x2d;&#x2212;&#x2013;]', ''))
                        "/>
                    
                    <xsl:variable name="nameWritten"
                        select="normalize-space(replace(string-join(preceding-sibling::*/note[1]/(preceding-sibling::text() | preceding-sibling::*)), '[&#x2d;&#x2212;&#x2013;]', ''))"/>
                    <xsl:variable name="nameOrig" select="if (empty($nameWritten)) then $nameTranslit  else $nameWritten"/>
                    
                    <ab type="name" n="{$nameTranslit}-{$nameOrig}">
                        <!--<note><xsl:copy-of select="./preceding-sibling::*[last()]//note/@*"></xsl:copy-of></note>-->
                        <xsl:apply-templates select="./preceding-sibling::*[1]//note"/>
                        <xsl:apply-templates select="." mode="table">
                            <xsl:with-param name="nameTranslit" select="$nameTranslit" tunnel="yes"/>
                            <xsl:with-param name="nameOrig" select="$nameOrig" tunnel="yes"></xsl:with-param>
                        </xsl:apply-templates>
                    </ab>
                </xsl:for-each>
            </div>
            <div type="notes">
                <xsl:apply-templates select="//table/preceding-sibling::*[1]//note" mode="fn"/>
            </div>
        </body>
    </xsl:template>
    
    
    <xsl:template match="/TEI/text/body/p">
        <!--      <persName n="{hi[1]}-{hi[last()]}">
            <xsl:apply-templates select="note"></xsl:apply-templates>
            <xsl:apply-templates select="following-sibling::list[1]"></xsl:apply-templates>
        </persName>-->
    </xsl:template>
    <xsl:template match="list[not(ancestor::cell)]">
       <xsl:param  name="parsed-URI" tunnel="yes"></xsl:param>
        <!-- This could be done more sensibly consistently and in function to remove duplication -->
        <xsl:variable name="nameTranslit"
            select="if (normalize-space(string-join(preceding-sibling::p[1]/note[1]/(following-sibling::text()|following-sibling::hi)))) then
            normalize-space(replace(string-join(preceding-sibling::p[1]/note[1]/(following-sibling::text()|following-sibling::hi)), '[&#x2d;&#x2212;&#x2013;]',''))
            else normalize-space(replace(string-join(preceding-sibling::p[1]/note[1]/(preceding-sibling::text()|preceding-sibling::hi)), '[&#x2d;&#x2212;&#x2013;]', ''))"/>
        <xsl:variable name="nameWritten"
            select="normalize-space(replace(string-join(preceding-sibling::p[1]/note[1]/(preceding-sibling::text()|preceding-sibling::hi)), '[&#x2d;&#x2212;&#x2013;]', ''))"/>
        <xsl:variable name="nameOrig" select="if (empty($nameWritten)) then $nameTranslit  else $nameWritten"/>
        
        <ab type="name" n="{$nameTranslit}-{$nameOrig}">
            <xsl:apply-templates select="preceding-sibling::p[1]/note"/>
            <listPerson xml:id="{translate(local:stripChars($nameTranslit),' ','_')}-{$parsed-URI[self::prefix]}" n="{$nameOrig}">
                <xsl:apply-templates select="item">
                    <!--<xsl:with-param name="parsed-URI" tunnel="yes"></xsl:with-param>-->
                    <xsl:with-param name="nameTranslit" select="$nameTranslit"/>
                    <xsl:with-param name="nameOrig" select="$nameOrig"/>
                </xsl:apply-templates>
            </listPerson>
        </ab>
    </xsl:template>
    <xsl:template match="item">
        <xsl:param name="nameTranslit"/>
        <xsl:param name="nameOrig"></xsl:param>
        <xsl:param name="parsed-URI" tunnel="yes"/>
        <xsl:variable name="name" select="parent::list/preceding-sibling::p[1]"/>
        <xsl:variable name="namePlusSerial"
            select="concat($nameTranslit, '-', count(preceding-sibling::item) + 1)"/>
        <xsl:variable name="path-suffix"
            select="concat($parsed-URI[self::prefix], '-', $namePlusSerial, '.xml')"/>
        <xsl:variable name="xid" select="concat($parsed-URI[self::prefix], '-', generate-id())"/>
                            <person xml:id="{$xid}-person"
                                n="{concat($parsed-URI[1], '-', $namePlusSerial)}">
                                <sex cert="high">
                                    <xsl:value-of select="substring-after($parsed-URI[4], '_')"/>
                                </sex>
                                <xsl:variable name="name-groups">
                                    <xsl:for-each-group select="node()"
                                        group-starting-with="hi[matches(normalize-space(.), '(O:|Ds:|F:|S:|E:|D:|P:)')]">
                                        <!-- keeping empty fields for now. uncommenting below, skips them -->
                                        <!--<xsl:if test="not(normalize-space(string-join(current-group()[not(. is current-group()[1])])) eq '&#x2013;')">-->
                                        <xsl:choose>
                                            <!-- modularize in templates -->
                                            <xsl:when test="contains(current-group()[1], 'O:')">
                                                <xsl:variable name="groups">
                                                  <xsl:for-each-group
                                                  select="current-group()[not(. is current-group()[1])]"
                                                  group-ending-with="note">
                                                  <persName>
                                                  <xsl:copy-of select="current-group()"/>
                                                  </persName>
                                                  </xsl:for-each-group>
                                                </xsl:variable>
                                                <persName type="lemma">
                                                  <xsl:value-of
                                                  select="$nameOrig"
                                                  />
                                                </persName>
                                                <persName type="lemma" xml:lang="en">
                                                    <xsl:value-of select="$nameTranslit"/>
                                                </persName>
                                                <xsl:apply-templates select="$groups/persName"/>
                                            </xsl:when>
                                            <xsl:when test="contains(current-group()[1], 'Ds:')">
                                                <state type="desc">
                                                  <note>
                                                  <xsl:apply-templates
                                                  select="current-group()[not(. is current-group()[1])]"/>
                                                  </note>
                                                </state>
                                            </xsl:when>
                                            <xsl:when test="contains(current-group()[1], 'F:')">
                                                <state type="findspot">
                                                  <note>
                                                  <xsl:apply-templates
                                                  select="current-group()[not(. is current-group()[1])]"
                                                  />
                                                  </note>
                                                </state>
                                            </xsl:when>
                                            <xsl:when test="contains(current-group()[1], 'S:')">
                                                <bibl>
                                                  <xsl:apply-templates
                                                  select="current-group()[not(. is current-group()[1])]"/>
                                                </bibl>
                                            </xsl:when>
                                            <xsl:when test="contains(current-group()[1], 'E:')">
                                                <state type="addl-Descr">
                                                  <note>
                                                  <!-- could be subspecified further -->
                                                  <xsl:apply-templates
                                                  select="current-group()[not(. is current-group()[1])]"
                                                  />
                                                  </note>
                                                </state>
                                            </xsl:when>
                                            <xsl:when test="contains(current-group()[1], 'D:')">
                                                <floruit>
                                                  <xsl:apply-templates
                                                  select="current-group()[not(. is current-group()[1])]"
                                                  />
                                                </floruit>
                                            </xsl:when>
                                            <xsl:when test="contains(current-group()[1], 'P:')">
                                                <state type="provenance">
                                                    <note>
                                                        <xsl:apply-templates
                                                            select="current-group()[not(. is current-group()[1])]"/>
                                                    </note>
                                                </state>
                                            </xsl:when>
                                        </xsl:choose>
                                        <!--</xsl:if>-->
                                    </xsl:for-each-group>
                                </xsl:variable>
                                <xsl:copy-of select="$name-groups"></xsl:copy-of>
                                <xsl:apply-templates select=".//note" mode="fn"/>
                            </person>
    </xsl:template>
    
    <!-- for table based files -->
    <xsl:template match="table" mode="table">
        <xsl:param name="nameTranslit" tunnel="yes"></xsl:param>
        <xsl:param name="nameOrig" tunnel="yes"></xsl:param>
        <xsl:variable name="parsedfileName" select="local:parseURI(base-uri(.))[3]"/>
        
        <listPerson xml:id="{translate(local:stripChars($nameTranslit),' ','_')}-{$parsedfileName}" n="{$nameOrig}">
            <xsl:apply-templates select="*"></xsl:apply-templates>
        </listPerson>
    </xsl:template>
    <xsl:template match="row">
        <xsl:param name="nameTranslit" tunnel="yes"></xsl:param>
        <xsl:param name="nameOrig" tunnel="yes"></xsl:param>
        <xsl:variable name="parsedfileName" select="local:parseURI(base-uri(.))"/>
        <xsl:variable name="name" select="translate($nameTranslit,' ','_')"/>
        <person xml:id="{concat($parsedfileName[3],'-',generate-id(.),'-person')}"
            n="{concat($parsedfileName[3],'-',$name,'-',count(preceding-sibling::row) + 1)}">
            <persName type="lemma"><xsl:value-of select="$nameOrig"/></persName>
            <persName type="lemma" xml:lang="en"><xsl:value-of select="$nameTranslit"/></persName>
            <sex cert="high"><xsl:value-of select="substring-after($parsedfileName[4],'_')"/></sex>
            <xsl:apply-templates select="cell"/>
            <xsl:apply-templates select=".//note" mode="fn"></xsl:apply-templates> 
        </person>
    </xsl:template>
    
    <xsl:template match="cell">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::cell)">
                <!-- skip me -->
            </xsl:when>
            <!-- 1. O: orthography abidwn  
                       Ds: description High priest  
                       F: find location– 
                       S: bibl Pseudo-Cyril of Jerusalem, The Cross, 29b II 
                       E: ethnicity? -> addlDesc – 
                       D: floruit -->
            <xsl:when test="count(preceding-sibling::cell) = 1">
                <xsl:variable name="nameTkns" as="node()*">
                    <xsl:apply-templates mode="nameTkns" select="if (./div|./p) then (./div|./p)/node() else node()"></xsl:apply-templates>
                </xsl:variable>
                <!--<xsl:copy-of select="$nameTkns"></xsl:copy-of>-->
                <xsl:for-each-group select="$nameTkns" group-adjacent="not(self::*:sep)">
                    <xsl:variable name="pname">
                        <persName>
                            <xsl:apply-templates select="current-group()"/>
                        </persName>
                    </xsl:variable>
                    <xsl:apply-templates select="$pname/*" mode="names"></xsl:apply-templates>
                </xsl:for-each-group>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 2">
                <!--Ds-->
                <state type="desc">
                    <note><xsl:apply-templates/></note>
                </state>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 3">
                <!--F-->
                <state type="findspot">
                    <note>
                        <xsl:apply-templates/>
                    </note>
                </state>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 4">
                <!--S-->
                <bibl>
                    <xsl:apply-templates/>
                </bibl>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 5">
                <!--E-->
                <state type="addl-Descr">
                    <note>
                        <!-- could be subspecified further -->
                        <xsl:apply-templates/>
                    </note>
                </state>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 6">
                <!--D-->
                <floruit>
                    <xsl:apply-templates/>
                </floruit>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) >= 7">
                <!--D-->
                <state>
                    <note type="prob-in-source"><xsl:apply-templates/></note>
                </state>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text()[ancestor::cell]" mode="nameTkns">
        <xsl:analyze-string select="." regex="/">
            <xsl:matching-substring><sep/></xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="element()[ancestor-or-self::cell]" mode="nameTkns">
        <xsl:choose>
            <xsl:when test="self::hi[not(ancestor::note)]">
                    <xsl:apply-templates mode="nameTkns"> </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{name()}">
                    <xsl:copy-of select="@*"></xsl:copy-of>
                    <xsl:apply-templates mode="nameTkns"> </xsl:apply-templates>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        <xsl:template match="list[ancestor::cell]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="item[ancestor::cell]">
        <xsl:apply-templates/><xsl:value-of select="if(following-sibling::item) then '; ' else '.'"/>
    </xsl:template>
    <xsl:template match="p[ancestor::cell]">
        <xsl:apply-templates/><xsl:value-of select="if(following-sibling::node()) then '; ' else '.'"/>
    </xsl:template>
    <xsl:template match="div[ancestor::cell]">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="head">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="note" mode="#default">
        <ref type="note" corresp="#{local:parseURI($doc-uri)[3]}-{@xml:id}"/>
    </xsl:template>
    <xsl:template match="hi | seg" mode="#default">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template match="note" mode="fn">
        <!-- could be streamlied -->
        <!-- borrows from functx -->
        <xsl:choose>
            <xsl:when test="$mode = 'list'">
                <xsl:variable name="seq"
                    select="(ancestor-or-self::list//note | ancestor-or-self::list/preceding-sibling::p[1]/note | ancestor-or-self::p[1]/note)"/>
                <xsl:variable name="this" select="."/>
                <note xml:id="{local:parseURI($doc-uri)[3]}-{@xml:id}"
                    n="{for $i in (1 to count($seq)) return $i[$seq[$i] is $this]}">
                    <xsl:apply-templates select="p/node()" mode="fn"/>
                </note>
            </xsl:when>
            <xsl:when test="$mode = 'table'">
                <xsl:variable name="seq"
                    select="(.[not(ancestor::table)]/(ancestor::head | p)//note | ancestor-or-self::table//note)"/>
                <xsl:variable name="this" select="."/>
                <note xml:id="{local:parseURI($doc-uri)[3]}-{@xml:id}">
                    <xsl:attribute name="n">
                        <!-- if headings before tables are inconsistent re number of notes will need to adjust -->
                        <xsl:choose>
                            <xsl:when test="not(ancestor::table)">
                                <xsl:value-of select="count(preceding-sibling::note) + 1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="
                                        number(for $i in (1 to count($seq))
                                        return
                                            $i[$seq[$i] is $this]) + 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="p/node()" mode="fn"/>
                </note>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text()" priority="1">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:function name="local:stripChars">
        <xsl:param name="str"></xsl:param>
        <!-- remove illegal characters from xml:id -->
        <xsl:value-of select="replace($str,'[^a-zA-Z0-9\s]','')"/>
    </xsl:function>
    <xsl:function name="local:parseURI">
        <xsl:param name="inURI"/>
        <xsl:variable name="fName"
            select="normalize-space(substring-before(tokenize($inURI, '/')[last()], '-to-utf'))"/>
        <fName>
            <xsl:value-of select="$fName"/>
        </fName>
        <title>
            <xsl:value-of select="normalize-space(replace(replace($fName, '[\-]', ' '), '_', '/'))"
            />
        </title>
        <prefix>
            <xsl:value-of
                select="normalize-space(replace($fName, '(^.+(B|G|Ha|L|P|S\-G|S\-H|A|E|I)_(M|F|Names)).+$', '$1'))"
            />
        </prefix>
        <name-type>
            <xsl:value-of
                select="normalize-space(replace($fName, '^.+((B|G|Ha|L|P|S\-G|S\-H|A|E|I)_(M|F|Names)).+$', '$1'))"
            />
        </name-type>
        <vol-no>
            <xsl:value-of
                select="normalize-space(replace($fName, '(^.+)(B|G|Ha|L|P|S\-G|S\-H|A|E|I)_(M|F|Names).+$', '$1'))"
            />
        </vol-no>
    </xsl:function>
</xsl:stylesheet>
