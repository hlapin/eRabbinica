<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:variable name="docs" select="collection('../data/xml/?select=*ref-sifre-n.xml')"/>
    <xsl:template name="start">
        <xsl:for-each select="$docs">
            <xsl:apply-templates select="*">
            </xsl:apply-templates>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="element()[ancestor::ab]">
        <xsl:choose>
            <xsl:when test="self::del|self::add|self::damage">
                <xsl:element name="{name()}Span">
                    <xsl:attribute name="type" select="name()"></xsl:attribute>
                    <xsl:attribute name="spanTo" select="concat('#',ancestor::ab/@xml:id,'-',generate-id())"></xsl:attribute>
                </xsl:element>
                <xsl:apply-templates select="node()"/>
                <anchor type="{name()}" xml:id="{ancestor::ab/@xml:id}-{generate-id()}"/>
            </xsl:when>
            <xsl:otherwise>
                <span type="{name()}" xml:id="#{ancestor::ab/@xml:id}-{generate-id()}"/>
                <xsl:apply-templates select="node()"/>
                <anchor type="{name()}" xml:id="{ancestor::ab/@xml:id}-{generate-id()}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>