<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:param name="vol" select="'2'"/>
    <xsl:param name="name-type" select="'B/M'"/>
    <xsl:param name="path" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/'"/>
    
    <xsl:import href="langageConversion.xsl"/>
    
    <xsl:variable name="to-file-out" select="'names/'"/>
    
    <xsl:template match="/">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Vol <xsl:value-of select="$vol"/>-<xsl:value-of select="$name-type"
                            />: <xsl:value-of select="/TEI/text/body/p[1]"/></title>
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
                    <xsl:apply-templates select="/*/*/body/*"/>
                </body>
            </text>
        </TEI>

    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/TEI/text/body/p"/>
    <xsl:template match="/TEI/text/body/list | /TEI/text/body/div/list">
        <!-- cleaner way to do this? -->
        <xsl:variable name="nameTranslit" select="if (starts-with(preceding-sibling::p[1]/hi[last()],'&#x2013; ')) then substring-after(preceding-sibling::p[1]/hi[last()],'&#x2013; ')
            else preceding-sibling::p[1]/hi[last()]"/>
        <xsl:variable name="nameOrig" select="preceding-sibling::p[1]/hi[1]"/>
        <listPerson xml:id="{$nameTranslit}"
            n="{$nameOrig}">
            <xsl:apply-templates>
                <xsl:with-param name="nameTranslit" select="$nameTranslit"/>
                <xsl:with-param name="nameOrig" select="$nameOrig"></xsl:with-param>
            </xsl:apply-templates>
        </listPerson>
    </xsl:template>
    <xsl:template match="item">
        <xsl:param name="nameTranslit"/>
        <xsl:variable name="name" select="parent::list/preceding-sibling::p[1]"/>
        <xsl:variable name="namePlusSerial" select="concat($nameTranslit,'-',count(preceding-sibling::item) + 1)" />
        <xsl:variable name="path-suffix" select="concat('vol-', $vol, '-', translate($name-type, '/', '_'), '-', $namePlusSerial,'.xml')"/>
        <xsl:variable name="xid" select="concat('vol-',$vol,'-',translate($name-type,'/','_'),'-',generate-id())"/>
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
                                    select="concat('vol-', $vol, '-', translate($name-type, '/', '_'), '-', $namePlusSerial)"
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
                            <person xml:id="{$xid}-person" n="{concat('vol-', $vol, '-', translate($name-type, '/', '_'), '-', $namePlusSerial)}">
                                <sex cert="high">
                                    <xsl:value-of select="substring-after($name-type, '/')"/>
                                </sex>
                                <xsl:for-each-group select="node()"
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
                                            <xsl:for-each select="$groups">
                                                <xsl:apply-templates 
                                                    select="persName" mode="names"/>
                                            </xsl:for-each>
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
                                <xsl:apply-templates select="note" mode="fn"/>
                            </person>
                        </listPerson>
                    </body>
                </text>
            </TEI></xsl:result-document>
    </xsl:template>
    <xsl:template match="note" mode="#default">
        <ref type='note' corresp="#{generate-id()}"/>
    </xsl:template>
    <xsl:template match="persName" mode="names">
            
            <xsl:choose>
                <xsl:when test="normalize-space(string-join(text())) eq '&#x2013;'
                    or not(normalize-space(string-join(text())))">
                    <!-- just process contents when content consists of en-dash or no text -->
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:when
                    test="(some $s in hi/@style/string() 
                        satisfies matches($s, '(Coptic|Graeca|Beyrut)'))
                    or (some $t in text()|hi/text() 
                        satisfies matches($t, '(\p{IsSyriac}|\p{IsArabic}|\p{IsHebrew})'))">
                    <xsl:call-template name="lang">
                        <xsl:with-param name="elName" select="'persName'"></xsl:with-param>
                        <xsl:with-param name="nodes2check" select="."></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <persName xml:lang="checkme">
                        <xsl:apply-templates/>
                    </persName>
                </xsl:otherwise>
            </xsl:choose>
        
    </xsl:template>
    <xsl:template match="hi" mode="fn">
        <xsl:choose>
            <xsl:when
                test="matches(@style, '(Coptic|Graeca|Beyrut)') 
                or matches(text(), '(\p{IsSyriac}|\p{IsArabic}|\p{IsHebrew})')">
                    <xsl:call-template name="lang">
                        <xsl:with-param name="nodes2check" select="."/>
                        <xsl:with-param name="elName" select="'span'"></xsl:with-param>
                    </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template match="text()" mode="names">
        <persName type="orth">
            <xsl:value-of select="."/>
        </persName>
    </xsl:template>
    <xsl:template match="hi" mode="#default">
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
    

</xsl:stylesheet>
