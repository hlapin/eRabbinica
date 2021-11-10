<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:local="local.functions.uri"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns="local.functions.uri"
    exclude-result-prefixes="xs map array PcGts local" version="3.0">
    <xsl:output indent="yes"></xsl:output>
    <!-- "compare" = text (e.g. Vilna used to provide canonical milestones)  -->
    <!-- "base" = text to be updated with canonical milestones -->

<!-- start over, begin by grouping on lines, process individual nodes -->

    <xsl:import href="extractExcelCells.xsl"/>
    <xsl:param name="xl-location"
        select="'zip:file:/C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/0404-TestVilnaNaples.xlsx!/xl/worksheets/sheet1.xml'"/>
    <xsl:param name="pageXML-location"
        select="'file:///C:/Users/hlapin/Documents/Maim_Auto_Zevahim'"/>
    <xsl:param name="pageXML-out" select="concat($pageXML-location, '/out/')"/>
    <xsl:param name="target_name" select="'P1143297-eSc-04.04'"/>
    <xsl:param name="compare_name" select="'vilna-plain-4.4'"/>
    <xsl:variable name="xl-data" select="doc($xl-location)"> </xsl:variable>
    <xsl:variable name="pageXML-data"
        select="collection(concat($pageXML-location, '?select=*.xml;recurse=no'))"/>

    <xsl:variable name="xl">
        <xsl:apply-templates select="$xl-data"/>
    </xsl:variable>

    <xsl:template name="start">
        <xsl:variable name="extracted_text" as="element()+">
            <xsl:variable name="data">
                <xsl:apply-templates select="$xl-data"/>
            </xsl:variable>
            <xsl:for-each-group select="$data/local:rows/*"
                group-ending-with=".[matches(*[local-name() eq $compare_name], '\d+\.\d+(\.\d+\.\d+)*')]">
                <xsl:copy-of
                    select="(current-group() except current-group()[last()])/*[name() eq $target_name]"/>
                <xsl:variable name="current_compare"
                    select="current-group()[last()]/*[name() eq $compare_name]"/>
                <xsl:variable name="current_target"
                    select="current-group()[last()]/*[name() eq $target_name]"/>
                <xsl:variable name="compare_tkn"
                    select="normalize-space(current-group()[last()][name() eq $compare_name]/text())"/>
                <xsl:variable name="target_tkn"
                    select="normalize-space(current-group()[last()][name() eq $target_name]/text())"/>
                <xsl:choose>
                    <!-- to do: insert logic that looks back to line and region breaks, matching '(l|ab)-' -->
                    <xsl:when test="not(matches($current_compare, '\d\.\d+(\.\d+\.\d+)*'))">
                        <!-- should we need this? -->
                        <!-- just pass through text -->
                        <xsl:copy-of select="$current_target"/>
                    </xsl:when>
                    <xsl:when test="matches($current_target, '\d\.\d+(\.\d+\.\d+)*')">
                        <!-- replace for consistent number pattern -->
                        <milestone
                           unit="{local:level-attribute(normalize-space($current_compare))}"
                           n="{$current_compare}"/>
                    </xsl:when>
                    <xsl:when test="normalize-space($current_target)">
                        <!-- corresponding cell has text. -->
                        <!-- pass text through and then insert marker-->
                        <xsl:copy-of select="$current_target"></xsl:copy-of>
                        <milestone
                            unit="{local:level-attribute(normalize-space($current_compare))}"
                            n="{$current_compare}"/>
                    </xsl:when>
                    <xsl:when test="not(normalize-space($current_target))">
                        <!-- corresponding cell is empty -->
                        <milestone
                            unit="{local:level-attribute(normalize-space($current_compare))}"
                            n="{$current_compare}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <milestone unit="XXX" n="check me, I should not exist"></milestone>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each-group>
        </xsl:variable>
        <xsl:variable name="grouped_on_l">
        <xsl:for-each-group select="$extracted_text" group-starting-with="*[starts-with(normalize-space(.),'l-')]">
           
                    <l n="{current-group()[1]}">
                        <xsl:copy-of select="current-group() except current-group()[1]"></xsl:copy-of>
                    </l>
           </xsl:for-each-group></xsl:variable>
        <xsl:apply-templates select="$grouped_on_l" mode="re-group"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*:milestone" mode="re-group">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
    <xsl:template  match="*[starts-with(normalize-space(.),'ab-')]" mode="re-group">
        <!-- skip -->
    </xsl:template>
    <xsl:template match="*[starts-with(.,'l-')]" mode="re-group">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
    <xsl:template match="*" mode="re-group">
        <xsl:value-of select="."/><xsl:text>
            
        </xsl:text>
    </xsl:template>
    
    <xsl:function name="local:level-attribute">
        <xsl:param name="in"></xsl:param>
        <xsl:choose>
            <xsl:when test="count(tokenize($in, '\.')) eq 1">
                <xsl:text>div1</xsl:text>
            </xsl:when>
            <xsl:when test="count(tokenize($in, '\.')) eq 2">
                <xsl:text>div2</xsl:text>
            </xsl:when>
            <xsl:when test="count(tokenize($in, '\.')) eq 3">
                <xsl:text>div3</xsl:text>
            </xsl:when>
            <xsl:when test="count(tokenize($in, '\.')) eq 4">
                <xsl:text>ab</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:function>


</xsl:stylesheet>
