<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0"
    xmlns:local="local.functions.uri"
    xmlns="local.functions.uri">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- Operates on a zipped excel worksheet. -->
    <!-- Creates a simpler XML in which elements are named by the column head and their value the cell value in the spreadsheet -->
    <!-- For now, ignores any formatting in the cells -->
    <!--<xsl:param name="xl-data"></xsl:param>-->
    <xsl:template match="* | @* | text()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:variable name="colNames">
        <xsl:for-each select="$xl-data/worksheet/sheetData/row[1]/c">
            <xsl:element name="{normalize-space(translate(@r,'1',''))}">
                <xsl:choose>
                    <xsl:when test="@t='s'">
                        <xsl:variable name="string-index" select="number(normalize-space(v)) + 1"/>
                        <xsl:value-of select="document('../sharedStrings.xml',.)/sst/si[position() =  $string-index]/t"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="v"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>
    
    
    <xsl:template match="sheetData">
        <rows>
            <xsl:apply-templates/>
        </rows>
    </xsl:template>
    <xsl:template match="row[1]"></xsl:template>
    <xsl:template match="row[position() > 1]">
        <row n="{number(@r) - 1}">
            <xsl:apply-templates/>
        </row>
    </xsl:template>
    <xsl:template match="c">
        <xsl:variable name="colID" select="normalize-space(translate(@r,'0123456789',''))"></xsl:variable>
        <xsl:element name="{$colNames/*[name()=$colID]}">
            <xsl:choose>
                <xsl:when test="@t='s'">
                    <xsl:variable name="string-index" select="number(normalize-space(v)) + 1"/>
                    <xsl:value-of select="document('../sharedStrings.xml',.)/sst/si[position() =  $string-index]/t"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="v"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*[descendant::sheetData]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[following-sibling::sheetData|preceding-sibling::sheetData]"/>
</xsl:stylesheet>