<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:import href="xsl2.xsl"/>
    <xsl:variable name="test" select="'test'"/>
    <xsl:template name="start">
        <xsl:call-template name="start2"></xsl:call-template>
    </xsl:template>
</xsl:stylesheet>