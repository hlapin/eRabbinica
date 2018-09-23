<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:local="http://www.local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xi xs local" version="2.0">
    <xsl:variable name="docs" select="collection('../data/xml/?select=ref-*.xml;recurse=yes;on-error=warning')"/>
    <xsl:template name="start">
        <xsl:for-each select="$docs">
           <xsl:message select="substring-after(document-uri(.), 'xml/')"></xsl:message>
           <xsl:variable name="finalSegment" 
                select="substring-before(substring-after(document-uri(.),'xml/'),'.xml')"/>
            <xsl:variable name="out">
                <xsl:apply-templates select="*"/>
            </xsl:variable>
            <xsl:result-document encoding="UTF-8" href="{concat('../data/xml/w-sep/',$finalSegment,'-w-sep.xml')}" indent="yes">
                <xsl:copy-of select="$out"/>
            </xsl:result-document><!--</xsl:otherwise></xsl:choose>-->
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="am" priority="1.5">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="label | pc | ref" priority="1.5">
        <w/><xsl:copy-of select="."/><w/>
    </xsl:template>
    <xsl:template match="element()[ancestor::ab]">
        <xsl:choose>
            <xsl:when test="self::del | self::add | self::damage">
                <xsl:element name="{name()}Span">
                    <xsl:attribute name="type" select="name()"/>
                    <xsl:attribute name="spanTo"
                        select="concat('#', ancestor::ab/@xml:id, '-', generate-id())"/>
                </xsl:element>
                <xsl:apply-templates select="node()"/>
                <anchor type="{name()}" xml:id="{ancestor::ab/@xml:id}-{generate-id()}"/>
            </xsl:when>
            <xsl:otherwise>
                <span type="{name()}" to="#{ancestor::ab/@xml:id}-{generate-id()}">
                    <xsl:if test="@type">
                        <xsl:attribute name="subtype" select="@type"></xsl:attribute>
                    </xsl:if>
                </span>
                <xsl:apply-templates select="node()"/>
                <anchor type="{name()}" xml:id="{ancestor::ab/@xml:id}-{generate-id()}">
                    <xsl:attribute name="subtype" select="@type"></xsl:attribute>
                </anchor>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text()[ancestor::ab]">
        <xsl:analyze-string select="." regex="\s+">
            <xsl:matching-substring>
                <w/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="ab">
        <xsl:variable name="tokenized">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="id" select="@xml:id"/>
        <!-- could perhaps combine next step with following? -->
        <xsl:variable name="w-segments">
            <xsl:for-each-group select="$tokenized/node()" group-starting-with="w">
                <w><xsl:copy-of select="current-group()[not(self::w)]"/></w>
            </xsl:for-each-group>
        </xsl:variable>
        <ab xml:id="{$id}">
            <!-- to insert count of only certain elements, use sibling recursion -->
            <!-- Because of the length of some of the units of text, -->
            <!--other methods that found/calculated position  at each case, had terrible performance -->
            <xsl:apply-templates select="$w-segments/*[1]"  mode="w-seg">
                <xsl:with-param name="id" select="$id"/>
                <xsl:with-param name="count" select="1"/>
            </xsl:apply-templates>
        </ab>
    </xsl:template>
    
    <xsl:template match="w" mode="w-seg">
       <xsl:param name="id"/>
       <xsl:param name="count"/> 
        
            <xsl:choose>
                <xsl:when test="text()[normalize-space(.)]">
                    <xsl:variable name="firstElems" 
                        select="*[not(self::am)][not(preceding-sibling::text()[normalize-space(.)])]"/>
                    <xsl:variable name="lastElems" 
                        select="*[not(self::am)][not(following-sibling::text()[normalize-space(.)])]"/>
                    <xsl:copy-of select="$firstElems"></xsl:copy-of>
                    <w xml:id="{$id}.{$count}">
                        <xsl:copy-of select="node() except ($firstElems|$lastElems)"></xsl:copy-of>
                    </w>
                    <xsl:copy-of select="$lastElems"></xsl:copy-of>
                    <xsl:apply-templates select="following-sibling::*[1]" mode="w-seg">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="count" select="$count + 1"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="self::w">
                    <xsl:copy-of select="*"/>
                    <xsl:apply-templates select="following-sibling::*[1]" mode="w-seg">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="count" select="$count"/>
                    </xsl:apply-templates>
                </xsl:when>
            </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="w-seg">
        <!-- This should never be called because of the way the doc fragment is constructed -->
        <xsl:param name="id"></xsl:param>
        <xsl:param name="count"></xsl:param>
        <xsl:copy-of select="."></xsl:copy-of>
        <xsl:apply-templates select="following-sibling::*[1]" mode="w-seg">
            <xsl:with-param name="id" select="$id"/>
            <xsl:with-param name="count" select="$count"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="xi:include">
        <xi:include href="{concat(substring-before(@href,'.xml'),'-w-sep.xml')}"/>
    </xsl:template>
</xsl:stylesheet>
