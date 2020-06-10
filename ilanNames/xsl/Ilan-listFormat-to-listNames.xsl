<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:param name="vol" select="'2'"/>
    <xsl:param name="name-type" select="'B/M'"/>
    <xsl:template match="/">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Vol: <xsl:value-of select="$vol"/>-<xsl:value-of select="$name-type"
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
        <xsl:message select="preceding-sibling::p[1]/hi[last()]/text()[starts-with(.,'– ')]"></xsl:message>
        <listPerson xml:id="{if (starts-with(preceding-sibling::p[1]/hi[last()],'– ')) then substring-after(preceding-sibling::p[1]/hi[last()],'– ')
            else preceding-sibling::p[1]/hi[last()]}"
            n="{preceding-sibling::p[1]/hi[1]}">
            <xsl:apply-templates/>
        </listPerson>
    </xsl:template>
    <xsl:template match="item">
        <xsl:variable name="name" select="parent::list/preceding-sibling::p[1]"/>
        <person xml:id="vol-{$vol}-{translate($name-type,'/','_')}-{generate-id()}"
            n="{$name/hi[last()]}-{count(preceding-sibling::item) + 1}">
            <sex cert="high">
                <xsl:value-of select="substring-after($name-type, '/')"/>
            </sex>
            <xsl:for-each-group select="node()"
                group-starting-with="hi[matches(normalize-space(.), '(O:|Ds:|F:|S:|E:|D:)')]">
                <!-- keeping empty fields for now. uncommenting below, skips them -->
                <xsl:if test="not(normalize-space(string-join(current-group()[not(. is current-group()[1])])) eq '&#x2013;')">
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
                                select="$name/hi[1] | $name/hi[1]/following-sibling::note[1]"/>
                        </persName>
                        <persName type="lemma" xml:lang="en">
                            <xsl:apply-templates
                                select="$name/hi[last()] | $name/hi[last()]/following-sibling::note[1]"
                            />
                        </persName>
                            <xsl:for-each select="$groups">
                                <xsl:apply-templates select="persName" mode="names"/>
                            </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="contains(current-group()[1], 'Ds:')">
                        <state type="desc">
                            <note><xsl:apply-templates
                                select="current-group()[not(. is current-group()[1])]"/></note>
                        </state>
                    </xsl:when>
                    <xsl:when test="contains(current-group()[1], 'F:')">
                        <state type="provenance">
                            <note><xsl:apply-templates
                                select="current-group()[not(. is current-group()[1])]"/></note>
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
                            <note><!-- could be subspecified further -->
                            <xsl:apply-templates
                                select="current-group()[not(. is current-group()[1])]"/></note>
                        </state>
                    </xsl:when>
                    <xsl:when test="contains(current-group()[1], 'D:')">
                        <floruit>
                            <xsl:apply-templates
                                select="current-group()[not(. is current-group()[1])]"/>
                        </floruit>
                    </xsl:when>
                </xsl:choose>
                </xsl:if>
            </xsl:for-each-group>
            <xsl:apply-templates select="note" mode="fn"></xsl:apply-templates>
        </person>
    </xsl:template>
    <xsl:template match="note" mode="#default">
        <ref corresp="#{generate-id()}"/>
    </xsl:template>
    <xsl:template match="persName" mode="names">
        <persName>
            <xsl:choose>
                <xsl:when
                    test="(some $s in hi/@style 
                        satisfies matches($s, '(Coptic|Graeca)'))
                    or (some $t in text()|hi/text() 
                        satisfies matches($t, '(\p{IsArabic}|\p{IsHebrew})'))">
                    <xsl:attribute name="xml:lang" select="
                        if (some $s in hi/@style satisfies matches($s, 'Graeca')) then
                        'gr'
                        else if (some $s in hi/@style satisfies matches($s, 'Coptic')) then
                        'cop'
                        else if (some $t in text()|hi/text() satisfies matches($t, '\p{IsArabic}')) then
                        'ar'
                        else if (some $t in text()|hi/text() satisfies matches($t, '\p{IsHebrew}')) then
                        'he-or-aram'
                        else 'checkme'"></xsl:attribute>
                    <xsl:apply-templates></xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates></xsl:apply-templates></xsl:otherwise>
            </xsl:choose>
        </persName>
    </xsl:template>
    <!--<xsl:template match="hi" mode="names">
        <persName type="orthographic">
            <xsl:if
                test="matches(@style, '(Coptic|Graeca)') or matches(text(), '(\p{IsArabic}|\p{IsHebrew})')">

                <xsl:call-template name="lang"/>

            </xsl:if>
            <xsl:apply-templates/>
        </persName>
    </xsl:template>-->
    <xsl:template match="text()" mode="names">
        <persName type="orth">
            <xsl:value-of select="."/>
        </persName>
    </xsl:template>
    <xsl:template match="hi" mode="#default">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template name="lang">
        <xsl:attribute name="xml:lang"
            select="
                if (matches(@style, 'Graeca')) then
                    'gr'
                else if (matches(@style, 'Coptic')) then
                        'cop'
                else if (matches(text(), '\p{IsArabic}')) then
                            'ar'
                else if (matches(text(), '\p{IsHebrew}')) then
                                'he-or-aram'
                else 'checkme'"> </xsl:attribute>
    </xsl:template>
    <!--<xsl:template match="list">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="item">
        <ab>
        </ab>
    </xsl:template>-->
    <xsl:template match="note" mode="fn">
        <!-- borrows from functx -->
        <xsl:variable name="seq" select="ancestor-or-self::list//note"/>
        <xsl:variable name="this" select="."/>
        <note xml:id="{generate-id()}"
            n="{for $i in (1 to count($seq)) return $i[$seq[$i] is $this]}" >
            <xsl:apply-templates select="p/node()"/>
        </note>
    </xsl:template>
    <xsl:template match="text()" priority="1">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    

</xsl:stylesheet>
