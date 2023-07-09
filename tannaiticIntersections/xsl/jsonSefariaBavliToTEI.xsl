<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://www.local-functions.uri" xmlns:j="http://www.w3.org/2013/XSL/json"
    xmlns:expath="http://expath.org/ns/file" version="3.0"
    exclude-result-prefixes="tei xs j local expath">

    <xsl:output indent="yes"/>
    <!--<xsl:param name="input" select="'../data/json/bavli/0509%20Tamid%20-%20he%20-%20merged.json'"/>-->

    <xsl:param name="jsonLoc"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/tannaiticIntersections/data/json/bavli'"/>
    <xsl:param name="targetLoc"
        select="'ref-b/'"/>
    <xsl:param name="header" select="doc('SefariaBavliHeaderMaster.xml')"></xsl:param>

    <xsl:import href="sefariaBavliJSONtoSimpleXML.xsl"/>
    <xsl:import href="xmlSefariaBavliSetMilestones.xsl"/>
    <xsl:import href="jsonSefariaBavliToMapToTEIBody.xsl"/>

    <xsl:variable name="jsonFiles" select="expath:list($jsonLoc)"/>

    <!-- file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/tannaiticIntersections/data/json/bavli -->
    <xsl:template name="start">
        <xsl:variable name="fnames-by-div">
            <xsl:call-template name="group-fnames-by-target-div"/>
        </xsl:variable>

        <!-- create the including document -->
        <TEI>
            <teiHeader><xsl:copy-of select="$header/*/tei:teiHeader/*"></xsl:copy-of></teiHeader>
            <text>
                <body>
                    <xsl:apply-templates select="$fnames-by-div//tei:div[@type='order']" mode="main-doc"/>
                </body>
            </text>

        </TEI>
        <!-- create the indluded docs -->
        <xsl:apply-templates select="$fnames-by-div//tei:div[@type='tractate']" mode="included"/>
            
    </xsl:template>

    <!-- used in building the including document -->
    <xsl:template match="tei:div[@type = 'order']" mode="main-doc">
        <div>
            <xsl:copy-of select="@*"></xsl:copy-of>
            <xsl:apply-templates mode="main-doc"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'tractate']" mode="main-doc">
        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="concat($targetLoc,@xml:id,'.xml')"></xsl:attribute>
            <xsl:attribute name="xpointer" select="@xml:id"/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- build result docs to be included -->
    <xsl:template match="tei:div[@type = 'tractate']" mode="included">
        <xsl:variable name="id-elements" select="tokenize(@xml:id,'\.')"/>
        <xsl:message select="string(.)"/>
        <xsl:result-document href="{concat($targetLoc,@xml:id,'.xml')}">
                
            <xsl:message select="'json of tractate to XML'"></xsl:message>
                <xsl:variable name="jsonToXML"><xsl:call-template name="json-to-XML-initial-template">
                    <xsl:with-param name="input" select="concat($jsonLoc,'/',.)"/>
                </xsl:call-template>
                </xsl:variable>
                
                <xsl:message select="'set grouping milestones for TEI'"></xsl:message>
                <xsl:variable name="set-milestones">
                    <xsl:call-template name="set-milestones-start">
                        <xsl:with-param name="doc" select="$jsonToXML"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:message select="'create body of included TEI doc'"></xsl:message>
                <xsl:variable name="build-TEI-body"><xsl:apply-templates  select="$set-milestones"/></xsl:variable>
            <TEI>
                <teiHeader>
                    <xsl:apply-templates 
                        select="$header/*/tei:teiHeader/*" 
                        mode="doc-headers">
                        <xsl:with-param 
                            name="meta" 
                            select="$jsonToXML/*/tei:head/*" 
                            tunnel="yes"
                            as="node()+"/>
                    </xsl:apply-templates>
                </teiHeader>
                <text>
                    <body>
                        <div type="order" xml:id="{parent::tei:div/@xml:id}">
                            <div type="tractate">
                                <xsl:copy-of select="@xml:id"></xsl:copy-of>
                                
                                <xsl:copy-of select="$build-TEI-body"></xsl:copy-of>
                                
                            </div>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template mode="doc-headers" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates mode="doc-headers" select="@*|node()">
                <!--<xsl:with-param name="meta" tunnel="yes"></xsl:with-param>-->
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:title" mode="doc-headers">
        <xsl:param name="meta" tunnel="yes"/>
        <title>A TEI publication of the Babylonian Talmud tractate <xsl:value-of select="$meta[self::tei:name]"/> from Sefaria</title>
    </xsl:template>
    
    <xsl:template mode="doc-headers" match="tei:ref[contains(@target,'sefaria')]">
        <xsl:param name="meta" tunnel="yes"/>
        <ref target="{$meta[self::tei:source]}"><xsl:value-of select="."/></ref>
    </xsl:template>
    <xsl:template match="tei:idno" mode="doc-headers">
        <xsl:param name="meta" tunnel="yes"/>
        <idno type="local"><xsl:copy-of select="concat('ref-b.',$meta[self::tei:id])"/></idno>
    </xsl:template>
    
    <!--<xsl:template match="*" mode="doc-headers">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>-->
    
    
    <xsl:template name="group-fnames-by-target-div">
            <xsl:variable name="files">
                <xsl:for-each select="$jsonFiles">
                    <div type="tractate" xml:id="{concat('ref-b.',replace(.,'^(\d{2})(\d{2}).*','$1.$2'))}">
                       <xsl:value-of select="."></xsl:value-of> 
                    </div>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each-group group-adjacent="substring(., 1, 2)" select="$files//tei:div">
                <div type="order" xml:id="{concat('ref-b.',current-grouping-key())}">
                    <xsl:copy-of select="current-group()"/>
                </div>
            </xsl:for-each-group>        
    </xsl:template>
    
</xsl:stylesheet>