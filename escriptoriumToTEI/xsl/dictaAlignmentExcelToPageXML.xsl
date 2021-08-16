<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" 
    xmlns:local="local.functions.uri"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs map array PcGts local" version="3.0">
    <!-- Not a generic approach -->
    <!-- In this case, transfering line markers to compare and using compare for new pageXML text -->


    <xsl:import href="extractExcelCells.xsl"/>
    <xsl:param name="xl-location"
        select="'zip:file:/C:/Users/hlapin/Documents/GitHub/mishnah/xsl-external/Maim_Qafah-05.01.xlsx!/xl/worksheets/sheet1.xml'"/>
    <xsl:param name="pageXML-location" select="'file:///C:/Users/hlapin/Documents/Maim_Auto_Zevahim'"/>
    <xsl:param name="pageXML-out" select="concat($pageXML-location,'/out/')"></xsl:param>
    <xsl:param name="target_name" select="'S990050310320205171-eSc-05.01'"/>
    <xsl:param name="compare_name" select="'Qafah-0501'"/>
    <xsl:variable name="xl-data" select="doc($xl-location)"> </xsl:variable>
    <xsl:variable name="pageXML-data" select="collection(concat($pageXML-location, '?select=*.xml;recurse=no'))"/>
    
    <xsl:variable name="xl">
        <xsl:apply-templates select="$xl-data"/>
    </xsl:variable>
    
    <xsl:variable name="lines">
        <xsl:for-each-group select="$xl/*:rows/*:row"
            group-starting-with=".[element()[local-name() eq $target_name][starts-with(., 'l-')]]">
            <l n="eSc_line_{substring-after(current-group()[1]/*[local-name() eq $target_name],'l-')}">
                <!--<xsl:copy-of select="current-group() except current-group()[1]"/>-->
                <str>
                    <xsl:apply-templates select="(current-group() except current-group()[1])"/>
                </str>
            </l>

        </xsl:for-each-group>
    </xsl:variable>
    <xsl:key name="line" match="*:l" use="@n"></xsl:key>
    <xsl:template name="start">
        <xsl:copy-of select="key('line','eSc_line_11617a08',$lines)"/>
        <!--<xsl:copy-of select="key('line','esc_line_6ef8b8b6',$lines)/string()"/>
        <xsl:copy-of select="if(key('line','zork',$lines)) then 'zork' else 'pork'"></xsl:copy-of>-->
        <out>
            
            <xsl:copy-of select="$lines"></xsl:copy-of>
            <!--<xsl:copy-of select="$pageXML-data"></xsl:copy-of>-->
            <xsl:for-each select="$pageXML-data[/PcGts:PcGts/PcGts:Page/PcGts:TextRegion
                                [@custom eq 'structure {type:Main;}']]">
                <xsl:message select="tokenize(base-uri(.),'/')[last()]"/>
                <xsl:result-document href="{$pageXML-out}/new-{tokenize(base-uri(.),'/')[last()]}">
                    <xsl:apply-templates select="." mode="transform"></xsl:apply-templates>
                </xsl:result-document>
            </xsl:for-each>
        </out>
    </xsl:template>
    
    <xsl:template match="local:row">
        <xsl:variable name="tokens" select="element()[local-name() eq $compare_name]"/>
<!--        <xsl:copy-of select="$tokens"></xsl:copy-of>-->
        <xsl:for-each select="$tokens">
            <xsl:choose>
                <xsl:when test="matches(.,'^\d+\.\d+')">
                    <xsl:comment><xsl:value-of select="."/></xsl:comment>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="if (self::* is $tokens[last()]
                                              (:or not(normalize-space(.)):)) 
                                          then () else ' '"/>
                    <xsl:copy-of select="string(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <!-- tranform, update page xml -->
    <xsl:template match="@*|node()" mode="transform">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" 
                mode="transform"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:TextLine" mode="transform">
        <TextLine>
            <xsl:copy-of select="@*">
            </xsl:copy-of>
                <xsl:apply-templates mode="transform"/>
        </TextLine>
    </xsl:template>
    <xsl:template match="PcGts:Unicode" mode="transform">
        <xsl:variable name="lineId" select="ancestor::PcGts:TextLine/@id/string()"/>
        <xsl:choose>
            <xsl:when test="key('line',$lineId,$lines)">
                <Unicode><xsl:value-of select="key('line',ancestor::PcGts:TextLine/@id,$lines)/string()"/></Unicode>
            </xsl:when>
            <xsl:otherwise><Unicode/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

</xsl:stylesheet>
