<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:param name="vol" select="'2'"/>

    <xsl:param name="path" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/'"/>
    <!--<xsl:variable name="files" select="collection(concat($to_TEI, '?select=[PS][0-9]+?.xml;recurse=no'))"/>-->
    <xsl:variable name="files" select="collection('file:/C:/Users/hlapin/Dropbox/IlanLexiconNames/Vol%202/utf-converted/Vol-2-B_F-Biblical-Females-to-utf-TEI-P5.xml')"/>
    
    <xsl:import href="langageConversion.xsl"/>
    <xsl:variable name="to-file-out" select="'names/'"/>
    <xsl:variable name="IsCoptic" select="'[&#x2c80;-&#x2ce9;]'" as="xs:string"></xsl:variable>
    <xsl:variable name="IsGreek" select="'[&#x386;-&#x3ce;]'" as="xs:string"/>
    <xsl:template match="/">
    <xsl:variable name="parsedTitle" select ="local:parseURI(base-uri(.))"/>

        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:value-of select="$parsedTitle/local:title"/></title>
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
                    <div n="name-list"><xsl:apply-templates select="/*/*/body/*"/></div>
                    <div n="name-note"><xsl:apply-templates select="/*/*/body/p/note" mode="fn"></xsl:apply-templates></div>
                </body>
            </text>
        </TEI>

    </xsl:template>
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/TEI/text/body/p">
  <!--      <persName n="{hi[1]}-{hi[last()]}">
            <xsl:apply-templates select="note"></xsl:apply-templates>
            <xsl:apply-templates select="following-sibling::list[1]"></xsl:apply-templates>
        </persName>-->
    </xsl:template>
    <xsl:template match="/TEI/text/body/list | /TEI/text/body/div/list">
        <!-- cleaner way to do this? -->
        <!-- change to regex to exclude occasional minus sign &#x2212; -->
        <xsl:variable name="nameTranslit" select="normalize-space(if (matches(preceding-sibling::p[1]/hi[last()],'[&#x2212;&#x2013;] ')) then tokenize(preceding-sibling::p[1]/hi[last()],'[&#x2212;&#x2013;]')[2]
            else preceding-sibling::p[1]/hi[last()])"/>
        <xsl:variable name="nameWritten" select="normalize-space(replace(preceding-sibling::p[1]/hi[1],'[&#x2212;&#x2013;]',''))"/>
        <xsl:variable name="nameOrig" select="if (empty($nameWritten)) then $nameTranslit  else $nameWritten"/>
        <ab type="name" n="{$nameTranslit}-{$nameOrig}">
            <xsl:apply-templates select="preceding-sibling::p[1]/note"></xsl:apply-templates>
            <listPerson xml:id="{$nameTranslit}-{local:parseURI(base-uri(.))[3]}"
                n="{$nameOrig}">
            <xsl:apply-templates>
                <xsl:with-param name="nameTranslit" select="$nameTranslit"/>
                <xsl:with-param name="nameOrig" select="$nameOrig"></xsl:with-param>
            </xsl:apply-templates>
        </listPerson></ab>
    </xsl:template>
    <xsl:template match="item">
        <xsl:param name="nameTranslit"/>
        <xsl:variable name="parsed-URI" select="local:parseURI(base-uri())"/>
        <xsl:variable name="name" select="parent::list/preceding-sibling::p[1]"/>
        <xsl:variable name="namePlusSerial" select="concat($nameTranslit,'-',count(preceding-sibling::item) + 1)" />
        <xsl:variable name="path-suffix" select="concat($parsed-URI[3], '-', $namePlusSerial,'.xml')"/>
        <xsl:variable name="xid" select="concat($parsed-URI[3],'-',generate-id())"/>
        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="concat($to-file-out,$path-suffix)"></xsl:attribute>
            <xsl:attribute name="xpointer" select="concat($xid,'-person')"></xsl:attribute>
        </xsl:element>
        <!--    concat('vol-', $vol, '-', translate($name-type, '/', '_'), '-', $namePlusSerial)    -->
        <xsl:result-document encoding="UTF-8" href="{concat($path,$to-file-out,$path-suffix)}">
            <TEI>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Title</title>
                        </titleStmt>
                        <publicationStmt>
                            <publisher>eRabbinica.org</publisher>
                            <authority></authority>
                            <idno type="URI">http://syriaca.org/names/<xsl:value-of
                                    select="concat($parsed-URI[1], '-', $namePlusSerial)"
                                />/tei</idno>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Information about the source</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <listPerson>
                            <person xml:id="{$xid}-person" n="{concat($parsed-URI[1], '-', $namePlusSerial)}">
                                <sex cert="high">
                                    <xsl:value-of select="substring-after($parsed-URI[4], '_')"/>
                                </sex>
                                <xsl:variable name="name-groups"><xsl:for-each-group select="node()"
                                    group-starting-with="hi[matches(normalize-space(.), '(O:|Ds:|F:|S:|E:|D:)')]">
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
                                                <xsl:apply-templates
                                                  select="$name/hi[1] (:| $name/hi[1]/following-sibling::note[1]:)"
                                                />
                                            </persName>
                                            <persName type="lemma" xml:lang="en">
                                                <xsl:apply-templates
                                                  select="$name/hi[last()] | $name/hi[last()]/following-sibling::note[1]"
                                                />
                                            </persName>
                                            
                                            <!--<xsl:for-each select="$groups">
                                                <xsl:if test="some $t in .//text() satisfies contains($t,'ⲁⲛⲛⲁ')">
                                                    <xsl:message select="."></xsl:message>
                                                </xsl:if>-->
                                                <xsl:apply-templates 
                                                    select="$groups/persName" mode="names"/>
                                            <!--</xsl:for-each>-->
                                        </xsl:when>
                                        <xsl:when test="contains(current-group()[1], 'Ds:')">
                                            <state type="desc">
                                                <note>
                                                  <xsl:apply-templates
                                                  select="current-group()[not(. is current-group()[1])]"
                                                  />
                                                </note>
                                            </state>
                                        </xsl:when>
                                        <xsl:when test="contains(current-group()[1], 'F:')">
                                            <state type="provenance">
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
                                                  select="current-group()[not(. is current-group()[1])]"
                                                />
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
                                    </xsl:choose>
                                    <!--</xsl:if>-->
                                </xsl:for-each-group>
                                </xsl:variable><xsl:apply-templates select="note" mode="fn"/>
                            </person>
                        </listPerson>
                    </body>
                </text>
            </TEI></xsl:result-document>
    </xsl:template>
    <xsl:template match="note" mode="#default">
        <ref type='note' corresp="#{generate-id()}"/>
    </xsl:template>
     <xsl:template match="hi|seg" mode="#all">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="note" mode="fn">
        <!-- borrows from functx -->
        <xsl:variable name="seq" select="ancestor-or-self::list//note"/>
        <xsl:variable name="this" select="."/>
        <note xml:id="{generate-id()}"
            n="{for $i in (1 to count($seq)) return $i[$seq[$i] is $this]}" >
            <xsl:apply-templates select="p/node()" mode="fn"/>
        </note>
    </xsl:template>
    <xsl:template match="text()" priority="1">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:function name="local:parseURI">
        <xsl:param name="inURI"></xsl:param>
        <xsl:variable name="fName" select="normalize-space(substring-before(tokenize($inURI, '/')[last()],'-to-utf'))"/>
        <fName><xsl:value-of select="$fName"/></fName>
        <title><xsl:value-of select="normalize-space(replace(replace($fName,'[\-]',' '),'_','/'))"></xsl:value-of></title>
        <prefix><xsl:value-of select="normalize-space(replace($fName,'(^.+(B|G|Ha|L|P|S\-G|S\-H|A|E|I)_(M|F|Names)).+$','$1'))"></xsl:value-of></prefix>
        <name-type><xsl:value-of select="normalize-space(replace($fName,'^.+((B|G|Ha|L|P|S\-G|S\-H|A|E|I)_(M|F|Names)).+$','$1'))"/></name-type>
    </xsl:function>

</xsl:stylesheet>
