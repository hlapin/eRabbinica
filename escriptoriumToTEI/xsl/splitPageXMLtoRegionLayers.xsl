<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="http://www.local.uri"
    exclude-result-prefixes="xs PcGts xsi local" version="2.0">
    <xsl:output indent="yes"/>
    

    <!-- 2021-08-11 -->
    <!-- takes on or two lists of region types and produces one or two copies of XML -->
    <!-- second list can be empty. If it is, create one layer only -->
    <!-- for omitted transcription, remove text, leaving <Unicode/> empty -->
    <!-- skip any regions not on the two lists -->

    <xsl:param name="regionsForLayer1" select="'Commentary Margin Illustration'">
        <!-- create a layer that includes metadata and retain transcriptions these region types -->
    </xsl:param>
    <xsl:param name="regionsForLayer2"/>
    <!--<xsl:param name="regionsForLayer2" select="'Commentary Margin Illustration'">-->
        <!-- create a second layer that includes metadata and retain transcription of these region types -->
        <!-- if empty do not create layer 
    </xsl:param>-->
    <xsl:param name="dataRoot"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/pagexml/export_bnf_328_329_maimonides/'"/>
    <xsl:param name="inData" select="'commentary-raw/'"/>
    <xsl:param name="outData" select="''"/>


    <xsl:variable name="pageXMLIn" select="string-join(($dataRoot, $inData), '/')"/>
    <xsl:variable name="data"
        select="collection(iri-to-uri(concat($pageXMLIn, '?select=*.xml;recurse=yes')))"/>

    <xsl:template name="start">
        <xsl:for-each select="$data">
            <xsl:apply-templates select="/"/>
        </xsl:for-each>
        
    </xsl:template>
    <xsl:template match="/">
        <xsl:variable name="seqLayer1" as="xs:string*" select="tokenize($regionsForLayer1, '\s+')"/>
        <xsl:variable name="seqLayer2" select="tokenize($regionsForLayer2, '\s+')"/>
        <xsl:variable name="docName" select="tokenize(base-uri(.), '[/\.]')[last() - 1]"/>
        <xsl:message select="$docName"/>
        <!-- Layer 1 -->
        <xsl:choose>
            <xsl:when test="$seqLayer1 = ()">
                <xsl:message>Parameter $regionsForLayer1 is empty</xsl:message>
                <xsl:message>Exiting without creating new layer</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Creating first layer of <xsl:value-of select="$docName"/>.xml, with
                    regions <xsl:value-of select="$seqLayer1" separator=", "/></xsl:message>
                <xsl:result-document
                    href="{concat($dataRoot,$outData,string-join(($seqLayer1),'_'),'/',$docName,'.xml')}"
                    encoding="UTF-8" indent="yes">

                    <xsl:apply-templates>
                        <xsl:with-param name="regions" select="$seqLayer1" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Layer 2 -->
        <xsl:choose>
            <xsl:when test="$seqLayer2 = () or not($seqLayer2)">
                <xsl:message>Parameter $regionsForLayer2 is empty</xsl:message>
                <xsl:message>Exiting without creating second layer</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Creating second layer of <xsl:value-of select="$docName"/>.xml, with
                    regions <xsl:value-of select="$seqLayer2" separator=", "/></xsl:message>
                <xsl:result-document
                    href="{concat($dataRoot,$outData,string-join(($seqLayer2),'_'),'/',$docName,'.xml')}"
                    encoding="UTF-8" indent="yes">

                    <xsl:apply-templates>
                        <xsl:with-param name="regions" select="$seqLayer2" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="Unicode">
        <xsl:param name="regions" tunnel="yes"></xsl:param>
        <xsl:variable name="test" select="tokenize(ancestor::TextRegion/@custom, '[:;]')[last() - 1]"/>
        <Unicode><xsl:choose>
            <xsl:when test="$test = $regions">
                <xsl:apply-templates></xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- retain comments that define text divisions; omit other descendants -->
                <xsl:copy-of select="comment()"/>
            </xsl:otherwise>
        </xsl:choose></Unicode>
       
            
        
    </xsl:template>


</xsl:stylesheet>
