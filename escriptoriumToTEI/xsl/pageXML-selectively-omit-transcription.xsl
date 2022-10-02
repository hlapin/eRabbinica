<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs PcGts" version="2.0">
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <!-- TODO revise to actively select rather than omit -->
    <xsl:param name="regionsToOmit" select="'eSc_dummyblock_'"/>
    <xsl:param name="lineTypeToOmit" select="'Commentary'"></xsl:param>
    <xsl:param name="projName" select="'MaimAutogrTextOnly'"></xsl:param>
    <xsl:param name="dataRoot"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/'"/>
    <xsl:param name="pageXMLIn" select="concat($dataRoot, 'pagexml/maimon_autograph/')"/>
    <xsl:param name="outpath" select="concat($dataRoot, 'pagexml/maimon_autograph/out/', $projName, '-pagexml-out/')"/>
    
    <xsl:variable name="seqRegionTypes" select="tokenize($regionsToOmit, '\s+')"/>
    <xsl:variable name="seqLineTypes" select="tokenize($lineTypeToOmit, '\s+')"/> 
    
    <!-- ideally this should flow from the metadata in escriptorium -->
    <xsl:variable name="data"
        select="collection(iri-to-uri(concat($pageXMLIn, '?select=*.xml;recurse=no')))">
        <!-- to parameterize -->
    </xsl:variable>

    <xsl:template name="start">
        <xsl:for-each select="$data">
            <xsl:variable name="fName" select="substring-before(tokenize(base-uri(.),'/')[last()],'.')"/>    
            <!--<xsl:message select="$fName"></xsl:message>-->
            <xsl:message select="concat($projName,'-',$fName)"></xsl:message>
            <xsl:result-document href="{concat($outpath,$projName,'-',$fName,'.xml')}"
                                 encoding="UTF-8" indent="yes">
                <xsl:apply-templates></xsl:apply-templates>
            </xsl:result-document>    
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="Unicode">
        <xsl:variable name="region" select="if (ancestor::TextRegion/@custom) 
            then tokenize(ancestor::TextRegion/@custom,'[:;]')[last()-1]
            else ancestor::TextRegion/@id"/>
        <xsl:variable name="line" select="if (ancestor::TextLine/@custom) 
            then tokenize(ancestor::TextLine/@custom,'[:;]')[last()-1]
            else ancestor::TextRegion/@id"/>
        <Unicode><xsl:choose>
            <xsl:when test="$region = $seqRegionTypes"></xsl:when>
            <xsl:when test="$line = $seqLineTypes"></xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose></Unicode>
    </xsl:template>

</xsl:stylesheet>
