<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:local="local.functions.uri"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs map array PcGts local" version="3.0">


    <!-- to do  -->
    <!-- split cells that have combined line or region marker and text into two. -->
    <!-- test target column for what is opposite milestone -->

    <xsl:import href="extractExcelCells.xsl"/>
    <xsl:param name="xl-location"
        select="'zip:file:/C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/0404-TestVilnaNaples.xlsx!/xl/worksheets/sheet1.xml'"/>
    <xsl:param name="pageXML-location" select="'file:///C:/Users/hlapin/Documents/Naples_Sanhedrin'"/>
    <xsl:param name="pageXML-out" select="concat($pageXML-location, '/out/')"/>
    <xsl:param name="target_name" select="'P1143297-eSc-04.04'"/>
    <xsl:param name="compare_name" select="'vilna-plain-4.4'"/>
    <xsl:variable name="xl-data" select="doc($xl-location)"> </xsl:variable>
    <xsl:variable name="pageXML-data"
        select="collection(concat($pageXML-location, '?select=*.xml;recurse=no'))"/>

    <xsl:variable name="xl">
        <xsl:apply-templates select="$xl-data"/>
    </xsl:variable>

    <xsl:variable name="lines">
        <xsl:for-each-group select="$xl/*:rows/*:row"
            group-starting-with=".[element()[local-name() eq $target_name][matches(normalize-space(.), '(.*)(l\-\w+)(\W*)')]]">
            <!-- to deal with errors where token attached to milestone, break up token-->
            <!-- check if element()[local-name() eq $compare_name] has milestone to keep -->
            <xsl:variable name="regex-parts" select="
                    (
                    (: replace(current-group()[1]/*[local-name() eq $target_name],'^(.*)(l\-\w+)(\W*)','$1'),:)
                    replace(current-group()[1]/*[local-name() eq $target_name], '^(.*)(l\-\w+)(\W*)', '$2'),
                    replace(current-group()[1]/*[local-name() eq $target_name], '^(.*)(l\-\w+)(\W*)', '$3')
                    )"> </xsl:variable>
            <xsl:variable name="target_token" select="$regex-parts[2]"/>
            <xsl:variable name="compare_token" select="element()[local-name() eq $compare_name]"/>

            <l n="eSc_line_{substring-after(current-group()[1]/*[local-name() eq $target_name],'l-')}">
                <!--<xsl:copy-of select="current-group() except current-group()[1]"/>-->
                <str>
                    <xsl:if
                        test="matches(current-group()[1]/*[local-name() eq $compare_name], '^\d+\.\d+(\.^\d+\.\d+)*')">
                        <xsl:comment>
                    <xsl:value-of select="string-join((local:level-attribute((normalize-space($compare_token))), normalize-space($compare_token)), '_')"/>
                    </xsl:comment>
                    </xsl:if>
                    <xsl:if test="$regex-parts[2]"><xsl:value-of select="string-join(($regex-parts[2],' '))"/></xsl:if>
                    <xsl:apply-templates select="(current-group() except current-group()[1])"/>
                    <!-- to deal with line, region accidentally merged with text token -->
                    <xsl:variable name="next_line_token" 
                        select="replace(current-group()[last()]/
                        following-sibling::*[1]/*[local-name() eq $target_name],'(.*)(l\-\w+)(\W*)','$1')"/>
                    <xsl:if test="normalize-space($next_line_token)">
                        <xsl:value-of select="string-join((' ',$next_line_token))"/>
                    </xsl:if>
                </str>
            </l>
        </xsl:for-each-group>
    </xsl:variable>
    <xsl:key name="line" match="*:l" use="@n"/>
    <xsl:template name="start">
        <!--<xsl:copy-of select="key('line','esc_line_6ef8b8b6',$lines)/string()"/>
        <xsl:copy-of select="if(key('line','zork',$lines)) then 'zork' else 'pork'"></xsl:copy-of>-->
        <out>
            <xsl:copy-of select="$lines"/>
            <!--<xsl:copy-of select="$pageXML-data"></xsl:copy-of>-->
            <xsl:for-each select="
                    $pageXML-data[/PcGts:PcGts/PcGts:Page/PcGts:TextRegion
                    [@custom eq 'structure {type:Main;}']]">
                <xsl:message select="tokenize(base-uri(.), '/')[last()]"/>
                <xsl:result-document href="{$pageXML-out}/new-{tokenize(base-uri(.),'/')[last()]}">
                    <xsl:apply-templates select="." mode="transform"/>
                </xsl:result-document>
            </xsl:for-each>
        </out>
    </xsl:template>

    <xsl:template match="local:row">
        <xsl:variable name="target_token" select="element()[local-name() eq $target_name]"/>
        <xsl:variable name="compare_token" select="element()[local-name() eq $compare_name]"/>
        <!--<xsl:copy-of select="$tokens"></xsl:copy-of>-->
        <xsl:choose>
            <xsl:when test="matches(normalize-space($compare_token), '^\d+\.\d+(\.^\d+\.\d+)*')">
                <xsl:comment>
                        <xsl:value-of select="string-join((local:level-attribute((normalize-space($compare_token))), normalize-space($compare_token)), '_')"/></xsl:comment>
                <xsl:choose>
                    <xsl:when test="matches(normalize-space($target_token), '^(ab-|r-).*')">
                        <!-- skip -->
                    </xsl:when>
                    <xsl:when test="normalize-space($target_token)">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$target_token"/>
                    <xsl:text> </xsl:text>
                </xsl:when></xsl:choose>
            </xsl:when>
            <xsl:when test="matches(normalize-space($target_token), '^(ab-|r-).*')">
                <!-- skip -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="string($target_token)"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--</xsl:for-each>-->
    </xsl:template>
    
<!--    <xsl:template match="*[name() eq $target_name][starts-with(normalize-space(.),'ab-')]">
        <!-\- skip -\->
    </xsl:template>-->

    <!-- tranform, update page xml -->
    <xsl:template match="@* | node()" mode="transform">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="transform"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:TextLine" mode="transform">
        <TextLine>
            <xsl:copy-of select="@*"> </xsl:copy-of>
            <xsl:apply-templates mode="transform"/>
        </TextLine>
    </xsl:template>
    <xsl:template match="PcGts:Unicode" mode="transform">
        <xsl:variable name="lineId" select="ancestor::PcGts:TextLine/@id/string()"/>
        <xsl:choose>
            <xsl:when test="key('line', $lineId, $lines)">
                <Unicode>
                    <xsl:copy-of
                        select="key('line', ancestor::PcGts:TextLine/@id, $lines)/*:str/node()"/>
                </Unicode>
            </xsl:when>
            <xsl:otherwise>
                <Unicode/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="local:level-attribute">
        <xsl:param name="in"/>
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
