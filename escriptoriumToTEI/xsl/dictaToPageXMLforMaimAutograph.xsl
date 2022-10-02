<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:saxon="http://saxon.sf.net/"
    xmlns:file="http://expath.org/ns/file" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs map array tei local saxon file" version="3.0">
    <xsl:output indent="yes"/>
    
    
    <!--
        tasks for this version:
        1. iterate and convert all? xlsx to aggregate simple xml
        2. in xl data for target: group starting with start|end
                assign line types
                * special handling of first line
                * all but first first line
        4. in pagexml            
                
    -->
    
    <xsl:import href="extractExcelCellsModifiedForPipelining.xsl"/>
    <xsl:import href="dictaAligmnmentToXMLLines.xsl"/>
    
    <xsl:param name="xl-root"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsm/'"/>
    <xsl:param name="xml-root"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/tei-facs/P000308265/pages'"/>
    <xsl:param name="merge-format" select="'tei-facs'">
        <!-- alt value: pagexml -->
    </xsl:param>
    <xsl:param name="milestone_lines_only" select="0"></xsl:param>
    
    <xsl:variable name="target" select="'S990050310320205171-eSc'"/>
    <xsl:variable name="compare1" select="'qafah-eSc'"/>
    <!--<xsl:variable name="compare2" select="'yVenSefaria'"/>
    <xsl:variable name="line_match_pattern" select="'^l-'"/>
    <xsl:variable name="div_match_pattern" select="'^Chapter_\d+_Halakhah(_\d+)?'"/>
    <xsl:variable name="ref_match_pattern" select="'^משנה_'"/>
    <xsl:variable name="col_match_pattern" select="'[IV]{1,2}_\d+[rv][ABCD]'"/>-->
    
    <xsl:variable name="files" select="file:list($xl-root, true(),'*.xlsm')"/>
    
    <xsl:variable name="pathToWorksheets" select="'!/xl/worksheets/'"/>
    <xsl:variable name="suffixToSheet" select="'sheet1.xml'"/>
    
    <!--<xsl:variable name="xml-data" select="collection(concat($xml-root, '?select=*-facs.xml;recurse=no'))"/>-->
    <xsl:variable name="xml-out" select="concat($xml-root, '/out/')"/>
    <xsl:variable name="lines-to-use">
        <xsl:variable name="lines">
            <xsl:for-each select="$files">
                <xsl:variable name="path-to-xl-sheet"
                    select="concat('zip:', $xl-root, ., $pathToWorksheets, $suffixToSheet)"/>
                <xsl:message select="concat('zip:', $xl-root, ., $pathToWorksheets, $suffixToSheet)"></xsl:message>
                <xsl:call-template name="lines-from-xl">
                    <xsl:with-param name="xl-path" tunnel="yes" select="$path-to-xl-sheet"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="if ($milestone_lines_only eq 1) then $lines/tei:l[tei:milestone|tei:ref] else $lines"/>
        
    </xsl:variable>
    
    <xsl:key name="line" match="*:l" use="@n"/>
    
    <xsl:template name="start">
        
        <out>
            <xsl:copy-of select="$lines-to-use"/>
        </out>
        
    </xsl:template>
    
    <xsl:template name="lines-from-xl">
        <xsl:param name="xl-path" tunnel="yes"></xsl:param>
        <!--<xsl:message select="tokenize($xl-path,'[!/\\]+')[last()-3]"></xsl:message>-->
        
        <xsl:variable name="rows" as="element()+">
            <xsl:call-template name="start_excel"/>
        </xsl:variable>
        <!--<!-\-<xsl:copy-of select="$rows"></xsl:copy-of>-\->
        <xsl:call-template name="lines">
            <xsl:with-param name="rows" select="$rows"/>
        </xsl:call-template>-->
        <xsl:call-template name="create-target-line-from-alignment">
            <xsl:with-param name="rows" select="$rows"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template mode="transform" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="transform"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:l" mode="transform">
        <xsl:variable name="id" select="if (contains(@corresp, '_Page')) 
            then substring-after(@corresp, 'Page_') else @corresp"/>
        <!--<xsl:copy-of select="key('line',$id,$lines-to-use)"></xsl:copy-of>-->
        <xsl:choose>
            <xsl:when test="key('line', $id, $lines-to-use)">
                <!-- replace line in tei with line with milestone -->
                <!--<xsl:message select="$id"/>-->
                <l>
                    <xsl:copy-of select="@*"/>
                    <xsl:copy-of select="key('line', $id, $lines-to-use)/node()"/>
                </l>
            </xsl:when>
            <xsl:otherwise>
                <!-- just copy the element -->
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>
