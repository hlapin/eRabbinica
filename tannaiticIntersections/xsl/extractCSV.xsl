<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:strip-space elements="*"/>
    
    <!-- note :: kinda kludgy to deal with punctuation marks and numerals in data -->
    
    <xsl:param name="pathIn" select="'../data/xml/w-sep/'"/>
    <xsl:param name="pathOut" select="'../data/txt/'"/>
    <xsl:param name="mode" select="'w2vec'">
        <!-- For now if w2vec prepares texts for gensim word2vec: -->
        <!-- each line xml:id, whole ab as string of tokens -->
        <!-- else two outputs -->
        <!-- plain: each token one line -->
        <!-- ids: each line xml:id, token -->
    </xsl:param>
    <xsl:variable name="docs" select="collection(concat($pathIn, '?select=ref-*.xml?;recurse=no'))"/>
    <xsl:template name="startFromCollection">
        <xsl:for-each select="$docs">
            <xsl:choose>
                <xsl:when test="$mode = 'w2vec'">
                    <xsl:message select="concat($pathOut,'w2vec/', tei:TEI/@xml:id, '-w2vec.txt')"/>
                    <xsl:result-document encoding="UTF-8" method="text"
                        href="{concat($pathOut,'w2vec/',tei:TEI/@xml:id,'-w2vec.txt')}" byte-order-mark="no">
                        <xsl:apply-templates select=".//tei:ab" mode="w2vec">
                            <xsl:with-param name="mode" select="'plain'" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:result-document>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message select="concat($pathOut, tei:TEI/@xml:id, '.txt')"/>
                    <xsl:result-document encoding="UTF-8" method="text"
                        href="{concat($pathOut,tei:TEI/@xml:id,'.txt')}">
                        <xsl:apply-templates select="/*/*//tei:w">
                            <xsl:with-param name="mode" select="'ids'" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:result-document>
                    <xsl:message select="concat($pathOut, tei:TEI/@xml:id, '-plain.txt')"/>
                    <xsl:result-document encoding="UTF-8" method="text"
                        href="{concat($pathOut,tei:TEI/@xml:id,'-plain.txt')}">
                        <xsl:apply-templates select="/*/*//tei:w">
                            <xsl:with-param name="mode" select="'plain'" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:result-document>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:ab" mode="w2vec">
        <xsl:param name="mode" tunnel="yes"/>
        <xsl:if test="ancestor::tei:div2/tei:div3[1]/tei:ab[1] is .">
            <xsl:message><xsl:value-of select="@xml:id"/></xsl:message>
        </xsl:if>
        <xsl:value-of select="@xml:id"/><xsl:text>,</xsl:text>
        <xsl:apply-templates select="tei:w">
            <xsl:with-param name="mode" select="'plain'" tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:text>&#xd;</xsl:text>
    </xsl:template>
    <xsl:template match="node()">
        <xsl:param name="mode" tunnel="yes"/>
        <xsl:if test="self::tei:w[parent::tei:ab]">
            <xsl:variable name="quots">
                <xsl:text>'"</xsl:text>
            </xsl:variable>
            <xsl:if test="$mode = 'ids'">
                <xsl:value-of select="@xml:id"/>
                <xsl:text>,</xsl:text>
            </xsl:if>
            <!-- some kludges to deal with messy text -->
            <xsl:variable name="outStr">
               <xsl:value-of
                   select="
                       translate(
                       if (tei:choice) then
                           tei:choice/tei:expan
                       else
                           ., $quots, '&#x5f3;&#x5f4;')"/>
            </xsl:variable>  
            <xsl:variable name="reduce" select="replace($outStr,'[A-Z\d,!?\.,:]+','')"/>
            <xsl:if test="normalize-space($reduce)">
                <xsl:value-of select="$reduce"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$mode = 'plain'">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:when>
                <xsl:when test="$mode = 'ids'">
                    <xsl:text>&#xd;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!--<xsl:template match="tei:w">
        <xsl:value-of select="."/>
    </xsl:template>-->

</xsl:stylesheet>
