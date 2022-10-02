<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/plain" omit-xml-declaration="yes"></xsl:output>
    <xsl:template match="/">
        <xsl:apply-templates select="//*:f"></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="*:f">
        <xsl:value-of select="concat('#',@xml:id)"/><xsl:text>,</xsl:text>
        <xsl:value-of select="concat('#',*:symbol/@value)"/><xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>