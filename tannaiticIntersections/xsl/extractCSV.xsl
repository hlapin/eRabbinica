<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:param name="pathIn" select="'../data/xml/w-sep/'"/>
    <xsl:param name="pathOut" select="'../data/txt/'"/>
    <xsl:variable name="docs" select="collection(concat($pathIn, '?select=ref*.xml?;recurse=no'))"/>
    <xsl:template name="startFromCollection">
        <xsl:for-each select="$docs">
            <xsl:message select="concat($pathOut, tei:TEI/@xml:id, '.txt')"/>
            <xsl:result-document encoding="UTF-8" method="text"
                href="{concat($pathOut,tei:TEI/@xml:id,'.txt')}">
                <xsl:apply-templates select="/*/*/*/node()"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="node()">
        <xsl:if test="self::tei:w[parent::tei:ab]">
            <xsl:variable name="quots"><xsl:text>'"</xsl:text></xsl:variable>
            <xsl:value-of
                select="
                    if (tei:choice) then
                        tei:choice/tei:expan
                    else
                        ."
                />,<xsl:value-of select="translate(@xml:id, $quots, '&#x5f3;&#x5f4;')"
            /><xsl:text>&#xd;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!--<xsl:template match="tei:w">
        <xsl:value-of select="."/>
    </xsl:template>-->

</xsl:stylesheet>
