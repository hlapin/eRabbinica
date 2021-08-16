<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <!--<xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="ab l"/>-->
    <xsl:output encoding="UTF-8" method="text"></xsl:output>
    
    <xsl:param name="regiontype-to-extract" select="'Main'">
    </xsl:param>
    <xsl:param name="milestones" select="1"></xsl:param>
    <xsl:variable name="id" select="teiCorpus/@xml:id"/>
    <xsl:variable name="data" as="element()+">
        <xsl:choose>
            <xsl:when test="$regiontype-to-extract">
                <xsl:sequence select="//ab[@type eq $regiontype-to-extract][normalize-space(string-join(l))]"></xsl:sequence>
            </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="//ab[normalize-space(string-join(l))]"></xsl:sequence>
                </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:message select="$id/string()"></xsl:message>
        <xsl:variable name="extracted" as="node()+"><xsl:apply-templates select="$data"/></xsl:variable>
        <!--<out><xsl:copy-of select="$extracted"></xsl:copy-of></out>-->
        <xsl:for-each-group select="$extracted" group-starting-with="comment()" >
            <!--<xsl:message select="current-group()[1][self::comment()]"></xsl:message>-->
            <xsl:if test="current-group()[1][self::comment()]">
                <xsl:message select="current-group()[1]/string()"></xsl:message>
                <xsl:result-document href="{$id/string()}-{normalize-space(current-group()[1]/string())}.txt"
                     method="text" encoding="UTF-8">
                    <xsl:value-of select="current-group()[1]/string()"/>
                    <xsl:copy-of select="current-group()"></xsl:copy-of>
                </xsl:result-document>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="ab">
        <xsl:value-of select="l/comment()[matches(string(), '\d{2}\.\d{2}')]"></xsl:value-of>
        <xsl:text>&#xd;</xsl:text>
        <xsl:value-of select="concat('ab-',tokenize(@corresp/string(), '_')[last()])"/>
        <xsl:text>&#xd;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="l">
        <xsl:text>&#xd;</xsl:text>
        <xsl:value-of select="concat('l-',tokenize(@corresp/string(), '_')[last()])"/>
        <xsl:text>&#xd;</xsl:text>
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="comment()">
        <!-- for placing tractates with ranges -->
        <xsl:variable name="precLineStart"
                select="parent::l/@corresp"/>
        <xsl:variable name="precRegionStart"
                select="ancestor::ab/@corresp"/>
        <xsl:copy-of select="."></xsl:copy-of>
        <xsl:text>&#xd;</xsl:text>
        <xsl:value-of select="concat('r-',tokenize($precRegionStart, '_')[last()])"/>
        <xsl:text>&#xd;</xsl:text>
        <xsl:value-of select="concat('l-',tokenize($precLineStart, '_')[last()])"/>
        <xsl:text>&#xd;</xsl:text>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:text> </xsl:text><xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
</xsl:stylesheet>


