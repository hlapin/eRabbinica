<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" media-type="text/plain" method="text"/>

    <xsl:param name="data" select="'../data/xml/ref-b/ref-b.06.07.xml'"/>
    <xsl:param name="corpus" select="'b'"/>

    <xsl:template name="start">
        <xsl:choose>
            <xsl:when test="$corpus = 'b'">
                <xsl:variable name="doc" select="doc($data)//*:ab/node()"/>
                <xsl:variable name="text">
                    <xsl:for-each-group select="$doc"
                        group-starting-with="*:milestone[@unit = 'chapter']">
                        <xsl:if test="current-group()[1][@n eq '01']">
                            <xsl:for-each-group select="current-group()"
                                group-starting-with="*:milestone[@type = 'talmud']">
                                <xsl:if test="current-group()[1][@type eq 'talmud'] and normalize-space(string-join(current-group()))">
                                    <xsl:value-of
                                        select="concat($corpus,',',current-group()[1]/@xml:id, ',', string-join(current-group()[self::text()]), '&#xa;')"
                                    />
                                </xsl:if>
                            </xsl:for-each-group>
                        </xsl:if>
                    </xsl:for-each-group>
                </xsl:variable>
                <xsl:value-of select="$text"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
