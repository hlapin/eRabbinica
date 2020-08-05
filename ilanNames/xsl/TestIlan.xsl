<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- assumes input format: tables preceded by head -->
    <!-- because of inconsistencies in word styling, cannot assume consistent nesting of elements -->
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <root>
            <div type="name-list">
                <xsl:for-each select="//table">
                    <xsl:variable name="name"
                        select="string-join(preceding-sibling::*[1]/(text() | hi))"/>
                    <ab type="name">
                        <xsl:attribute name="n"
                            select="normalize-space(replace($name, '\s*[&#x2212;&#x2013;]\s*', '-'))"> </xsl:attribute>
                        <xsl:apply-templates select="preceding-sibling::*[1]//note"/>
                        <xsl:apply-templates select="."/>
                    </ab>
                </xsl:for-each>
            </div>
            <div type="notes">
                <xsl:apply-templates select="//table/preceding-sibling::head[1]//note" mode="fn"/>
            </div>
        </root>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="table">
        <!-- copying contents so that all the generate-ids operate on copy, not *some* on original -->
        <xsl:variable select="." name="table"></xsl:variable>
        <listPerson>
            <xsl:apply-templates select="$table/*"/>
        </listPerson>
    </xsl:template>
    <xsl:template match="row">
        <person>
            <xsl:apply-templates select="cell"/>
            <xsl:apply-templates select=".//note" mode="fn"></xsl:apply-templates> 
        </person>
    </xsl:template>
    <xsl:template match="cell">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::cell)">
                <!-- skip me -->
            </xsl:when>
            <!-- 1.	O: abidwn  Ds: High priest  F: – S: Pseudo-Cyril of Jerusalem, The Cross, 29b II E: – D: -->
            <xsl:when test="count(preceding-sibling::cell) = 1">
                    <xsl:variable name="nameTkns" as="node()+">
                        <xsl:apply-templates mode="nameTkns" ></xsl:apply-templates>
                    </xsl:variable>
                    <xsl:for-each-group select="$nameTkns" group-starting-with="*:sep">
                        <persName><xsl:apply-templates select="current-group()[not(self::*:sep)]"/></persName>
                    </xsl:for-each-group>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 2">
                <!--Ds-->
                <desc>
                    <xsl:apply-templates/>
                </desc>
            </xsl:when>
            <xsl:when test="count(preceding-sibling::cell) = 3">
                <!--F-->
                <state type="provenance">
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
        </xsl:choose>
    </xsl:template>
    <xsl:template match="note">
        <ref spanTo="#{generate-id()}"/>
    </xsl:template>
    <xsl:template match="head">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hi | p">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="list">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="item">
            <xsl:apply-templates/><xsl:value-of select="if(following-sibling::item) then '; ' else '.'"/>
    </xsl:template>
    <xsl:template match="note" mode="fn">
        <!-- if headings before tables are inconsistent re number of notes will need to adjust -->
         <!-- borrows from functx -->
        <xsl:variable name="seq" select="(.[not(ancestor::table)]/(ancestor::head|p)//note|ancestor-or-self::table//note)"/>
        <xsl:variable name="this" select="."/>
        <note xml:id="{generate-id()}">
            <xsl:attribute name="n">
                <!-- if headings before tables are inconsistent re number of notes will need to adjust -->
                <xsl:choose>
                    <xsl:when test="not(ancestor::table)">
                        <xsl:value-of select="count(preceding-sibling::note) + 1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(for $i in (1 to count($seq)) return $i[$seq[$i] is $this]) "></xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="p/node()" mode="fn"/>
        </note>
    </xsl:template>
    <xsl:template match="text()" priority="1">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="text()" mode="nameTkns">
        <xsl:analyze-string select="." regex="/">
            <xsl:matching-substring><sep/></xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="element()" mode="nameTkns">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
</xsl:stylesheet>
