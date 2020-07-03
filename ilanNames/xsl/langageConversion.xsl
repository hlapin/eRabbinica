<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:variable name="graeca-str" select="''"/>
    <xsl:variable name="utf-8-gr" select="'ςΑαΒβΧχΔδΕεΦφΓΓΗἹ̓ΚκΛλΜμΝνΟοΠπΘθΡρΣσΥύ΄ΩωΞξΨψΖζ'"/>
    <xsl:variable name="times-beyrut-str" select="'¦½ÁÀÂâÃçÐÍÎĴĵÑÒÔšŠÞÚÙÛÝŸÿ'"/>
    <xsl:variable name="utf-8-translit" select="'čō āĀÂâÃÇī Ḥ ḥ ĴĴṢ ṣṭš Šʾ	Ẓū ẓʿĒ ē '"/>
    <xsl:variable name="coptic-str" select="'aAbBcCdDeHfFgGiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ'"/>
    <xsl:variable name="utf-8-copt" select="'ⲁⲁⲃⲃⲥⲥⲇⲇⲉϩϥϥⲅⲅⲓⲓⲭⲭⲕⲕⲗⲖⲙⲙⲛⲛⲟⲟⲡⲡϧϧⲣⲣϣϣⲧⲧⲩⲩⲫⲫⲱⲱⲝⲝⲏⲏⲍⲍ'"/>

    <xsl:template name="lang">
        <xsl:param name="elName"/>
        <xsl:param name="nodes2check"/>
        <xsl:element name="{$elName}">
            <xsl:attribute name="xml:lang"
                select="
                (: transcription + greek may mean Persian :)
                if ((some $s in $nodes2check//@style satisfies matches($s, 'Beyrut'))
                    and (some $g in $nodes2check//@style satisfies matches($g, 'Graeca'))) then
                'ir'
                else if (some $s in $nodes2check//@style satisfies matches($s, 'Beyrut')) then
                'translit'
                else if (some $s in $nodes2check//@style satisfies matches($s, 'Graeca')) then
                'gr'
                else if (some $s in $nodes2check//@style satisfies matches($s, 'Coptic')) then
                'cop'
                else if (some $t in $nodes2check//text() satisfies matches($t, '\p{IsArabic}')) then
                'ar'
                else if (some $t in $nodes2check//text() satisfies matches($t, '\p{IsHebrew}')) then
                'he'
                else 'checkme'">
            </xsl:attribute>
            <!--      Problems with mode="lang"      -->
            <!--<xsl:apply-templates select="$nodes2check/node()" mode="lang">
                <xsl:with-param name="lang" select="'gr'"></xsl:with-param>
            </xsl:apply-templates>-->
            <xsl:apply-templates select="$nodes2check/node()">
                
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <!--<xsl:template match="*" mode="lang">
        <xsl:param name="lang" select="'gr'"></xsl:param>
        
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="lang"></xsl:apply-templates>
        </xsl:element>
    </xsl:template>-->
    <xsl:template match="text()" mode="lang">
        <xsl:param name="lang" select="'gr'"></xsl:param>
        <!--<xsl:choose>
            <xsl:when test="$lang eq 'gr'">
                <xsl:value-of select="translate(.,$graeca-str,$utf-8-gr)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>-->
        <xsl:value-of select="."></xsl:value-of>
    </xsl:template>


</xsl:stylesheet>