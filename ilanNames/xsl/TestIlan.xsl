<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <div type="table">
            <table>
                <xsl:apply-templates select="TEI/text/body//table"/>
            </table>
            <div type="notes">
                <xsl:apply-templates mode="fn" select="//note"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="table">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="row">
        <row>
            <cell type="lemma" n="{count(preceding-sibling::row) + 1}">
                <xsl:apply-templates select="./preceding::head[1]/node()"/>
            </cell>
            <xsl:apply-templates/>
        </row>
    </xsl:template>
    <xsl:template match="cell">
        <cell>
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::cell)"/>
                <xsl:otherwise>
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <!-- 1.	O: abidwn  Ds: High priest  F: – S: Pseudo-Cyril of Jerusalem, The Cross, 29b II E: – D: -->
                            <xsl:when test="count(preceding-sibling::cell) = 1">O</xsl:when>
                            <xsl:when test="count(preceding-sibling::cell) = 2">Ds</xsl:when>
                            <xsl:when test="count(preceding-sibling::cell) = 3">F</xsl:when>
                            <xsl:when test="count(preceding-sibling::cell) = 4">S</xsl:when>
                            <xsl:when test="count(preceding-sibling::cell) = 5">E</xsl:when>
                            <xsl:when test="count(preceding-sibling::cell) = 6">D</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </cell>
    </xsl:template>
    <xsl:template match="note">
        <ref spanTo="#{generate-id()}"/>
    </xsl:template>
    <xsl:template match="hi">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="list">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="item">
        <ab>
            <xsl:apply-templates/>
        </ab>
    </xsl:template>
    <xsl:template match="note" mode="fn">
        <p xml:id="{generate-id()}">
            <xsl:apply-templates select="p/node()"/>
        </p>
    </xsl:template>
    <xsl:template match="text()" priority="1">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
</xsl:stylesheet>
