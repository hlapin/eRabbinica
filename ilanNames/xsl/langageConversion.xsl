<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="IsCoptic" select="'[&#x2c80;-&#x2ce9;]'" as="xs:string"></xsl:variable>
    <xsl:variable name="IsGreek" select="'[&#x386;-&#x3ce;&#x1f00;-&#x1ffe;]'" as="xs:string"/>
    <xsl:variable name="IsTranslit" select="'[&#xcf;-&#x259;&#x1e00;-&#x1eff;]'" as="xs:string"/>
    
    <xsl:template name="lang">
        <xsl:param name="elName"/>
        <xsl:param name="nodes2check"/>
        <xsl:element name="{$elName}">
            <xsl:attribute name="xml:lang"
                select="
                (: transcription + greek may mean Persian :)
                if ((some $s in  $nodes2check//text() satisfies matches($s, $IsTranslit))
                and (some $g in  $nodes2check//text() satisfies matches($g, $IsGreek))) then
                'ir'
                else if (some $s in  $nodes2check//text() satisfies matches($s, $IsTranslit)) then
                'translit'
                else if (some $s in  $nodes2check//text() satisfies matches($s, '\p{IsSyriac}')) then
                'syr'
                else if (some $s in  $nodes2check//text() satisfies matches($s, $IsCoptic)) then
                'cop'
                else if (some $s in  $nodes2check//text() satisfies matches($s, $IsGreek)) then
                'gr'
                else if (some $t in $nodes2check//text() satisfies matches($t, '\p{IsArabic}')) then
                'ar'
                else if (some $t in $nodes2check//text() satisfies matches($t, '\p{IsHebrew}')) then
                'he'
                (: if it is only an roman text treat as translit :)
                else if (every $t in $nodes2check//text() satisfies matches($t, '[a-zA-Z]')) then
                'translit'
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
    <xsl:template match="persName" mode="names">
        <xsl:choose>
            <xsl:when test="normalize-space(string-join(text()|hi/text())) eq '&#x2013;'
                or not(normalize-space(string-join(text()|hi/text())))">
                <!-- just skip  contents when content consists of en-dash or no text -->
                <xsl:apply-templates select="/note"></xsl:apply-templates>
            </xsl:when>
            <xsl:when
                test="(: (some $s in hi/@style/string() 
                satisfies matches($s, '(Coptic|Graeca|Beyrut)'))
                or:) 
                (some $t in (.//text())
                satisfies matches($t,concat('(\p{IsSyriac}|\p{IsArabic}|\p{IsHebrew}|',$IsCoptic,'|',$IsGreek,'|',$IsTranslit,')'))
                (: satisfies matches($t, concat('(\p{IsSyriac}|\p{IsArabic}|\p{IsHebrew})|',$IsCoptic,'\p{IsGreek}|[&#xcf;-&#x259;&#x1e00;-&#x1eff;]')) :)
                )">
                <xsl:call-template name="lang">
                    <xsl:with-param name="elName" select="'persName'"></xsl:with-param>
                    <xsl:with-param name="nodes2check" select="."></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <persName xml:lang="checkme">
                    <xsl:apply-templates/>
                </persName>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="hi|seg" mode="fn">
        <!--  appearance of Greek in particular typed with parentheses etc. in original is too complex to handle in this way -->
        <!-- creates multiple spans that are not grouped. Not sure this is helpful -->
        <!-- eg: <span xml:lang="gr">Βοσστρ</span>[<span xml:lang="gr">ην</span>]<span xml:lang="gr">ῆς</span>.  -->
       <!-- <xsl:apply-templates></xsl:apply-templates> -->
        <xsl:choose>
            <xsl:when
                test="matches(@style, '(Gentium|Segoe|Beyrut)') 
                or   matches(text(), '(\p{IsSyriac}|\p{IsArabic}|\p{IsHebrew})|\p{IsCoptic}|\p{IsGreek}|[&#xcf;-&#x259;&#x1e00;-&#x1eff;]')">
                <xsl:call-template name="lang">
                    <xsl:with-param name="nodes2check" select="."/>
                    <xsl:with-param name="elName" select="'span'"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="text()" mode="names">
        <persName type="orth">
            <xsl:value-of select="."/>
        </persName>
    </xsl:template>
    
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