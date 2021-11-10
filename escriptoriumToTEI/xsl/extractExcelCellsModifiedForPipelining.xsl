<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:local="local.functions.uri"
    xmlns="local.functions.uri">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- Operates on a zipped excel worksheet. -->
    <!-- Creates a simpler XML in which elements are named by the column head and their value the cell value in the spreadsheet -->
    <!-- For now, ignores any formatting in the cells -->
    <!-- 8/28/21 Modified with assumption that called from start-excel with parameters xl-location passed in and utilized in templates below-->
    <xsl:param name="xl-root"/>
    <xsl:template match="* | @* | text()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="start_excel">
        <xsl:param name="xl-path" tunnel="yes"></xsl:param>
        <xsl:variable name="xl-data" select="saxon:discard-document(doc($xl-path))"/>
        <xsl:variable name="uri" select="substring-before($xl-path,'worksheets')"></xsl:variable>
        <xsl:apply-templates select="$xl-data">
            <xsl:with-param name="document-uri" select="$uri" tunnel="yes"></xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
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
        <xsl:param name="document-uri" tunnel="yes"></xsl:param>
        <xsl:variable name="count" select="count(preceding-sibling::c) + 1"/>
        <xsl:variable name="colID" select="if (normalize-space(@r)) then normalize-space(translate(@r,'0123456789','')) 
            else ancestor::sheetData/row[1]/c[$count]"/>
        <xsl:variable name="colNames">
            <xsl:call-template name="colNames"/>
        </xsl:variable>
        <xsl:element name="{$colNames/*[name()=$colID]}">
            <xsl:choose>
                <xsl:when test="@t='s'">
                    <xsl:variable name="string-index" select="number(normalize-space(v)) + 1"/>
                    <xsl:value-of select="doc(concat($document-uri,'sharedStrings.xml'))/sst/si[position() =  $string-index]/t"/>
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
    
    <xsl:template name="colNames">
        <xsl:param name="document-uri" tunnel="yes"></xsl:param>
        
        <xsl:for-each select="./ancestor::worksheet/sheetData/row[1]/c">
            <xsl:element name="{normalize-space(translate(@r,'1',''))}">
                <xsl:choose>
                    <xsl:when test="not(v)">
                        <xsl:value-of select="@r"/>
                    </xsl:when>
                    <xsl:when test="@t='s'">
                        <xsl:variable name="string-index" select="number(normalize-space(v)) + 1"/>
                        <xsl:value-of select="doc(concat($document-uri,'sharedStrings.xml'))/sst/si[position() =  $string-index]/t"/>
                        <!--<xsl:value-of select="../sharedStrings.xml/sst/si[position() =  $string-index]/t"/>-->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="v"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
