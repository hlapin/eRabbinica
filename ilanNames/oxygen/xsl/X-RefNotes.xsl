<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://local-functions.uri" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs local" version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()[ancestor-or-self::ab and matches(.,'[Ss]ee above,*\s+n\.\s+\d+[\.,]')]">
        <xsl:variable name="ab" select="ancestor-or-self::ab"/>
        <xsl:analyze-string select="." regex="[Ss]ee above,*\s+n\.\s+(\d+)[\.,]">
            <xsl:matching-substring>
                <xsl:variable name="xr" select="local:getNoteIds($ab, regex-group(1))"/>
                <ref type="x-ref" corresp="#{$xr[1]}"><xsl:value-of select="."/><xsl:text> </xsl:text><span><xsl:value-of select="$xr[2]"/></span></ref>
            </xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
   <!-- <xsl:template match="ref">
        <xsl:param name="notes" tunnel="yes"/>
        <xsl:variable name="ref" select="substring-after(@corresp,'#')"/>
        <xsl:copy-of select="$notes[self::*:note[@xml:id eq $ref]]"></xsl:copy-of>-->
    <!--</xsl:template>-->
    <xsl:function name="local:getNoteIds">
        <xsl:param name="in" as="element()"/>
        <xsl:param name="n" as="xs:string"/>
        <xsl:sequence select="for $i in $in//@corresp return $in/id((substring-after($i, '#')))[@n = $n]/(@xml:id, node())"/>
        <!--<xsl:for-each select="$in/ancestor-or-self::ab//@corresp">
            <xsl:copy-of select="id(substring-after(., '#'))"/>
        </xsl:for-each>-->
    </xsl:function>
</xsl:stylesheet>
