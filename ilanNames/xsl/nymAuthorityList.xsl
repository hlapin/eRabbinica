<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://www.local-functions.uri" xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" encoding="UTF-8" method="text"/>
    <xsl:mode on-no-match="shallow-copy">
        <!-- replaces identity transformation -->
    </xsl:mode>
    <xsl:template match="/">
        <xsl:text>Lemma,Transcribed,Transliterated,Lang Gender Class,ID,&#xa;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="teiHeader"/>
    <xsl:template match="*[descendant::nym]">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="nym">
        <xsl:value-of select="translate(form,',',';')"/><xsl:text>,</xsl:text>
        <xsl:value-of select="translate(tokenize(form,'\-')[2],',',';')"/><xsl:text>,</xsl:text>
        <xsl:value-of select="translate(tokenize(form,'\-')[1],',',';')"/><xsl:text>,</xsl:text>
        <xsl:value-of select="@type"/><xsl:text>,</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>