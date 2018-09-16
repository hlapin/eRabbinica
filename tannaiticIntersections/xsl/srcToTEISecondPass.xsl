<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:template match="/">
        <out>
            <xsl:apply-templates select="//ab"/></out>
        
    </xsl:template>
    <xsl:template match="ab">
        <xsl:for-each-group 
            select="node()" 
            group-adjacent="boolean(self::text()[not(normalize-space(.))]|self::quote|self::ref|self::pc[preceding-sibling::*[1][self::ref] and following-sibling::*[1][self::quote]|following-sibling::*[1][self::ref] and preceding-sibling::*[1][self::quote]])">
            <xsl:choose>
                <xsl:when test=" current-grouping-key() = true()">
                    <group><xsl:copy-of select="current-group()"></xsl:copy-of></group>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each-group>
        
    </xsl:template>
</xsl:stylesheet>