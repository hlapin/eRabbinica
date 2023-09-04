<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://www.local-functions.uri" xmlns:j="http://www.w3.org/2013/XSL/json"
    xmlns:functx="http://www.functx.com"
    xmlns:expath="http://expath.org/ns/file" version="3.0"
    exclude-result-prefixes="tei xs j local expath functx">


    <!-- TO DO: final pass to assign chapter to IDs -->

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
            <xsl:variable name="build-TEI-body">
                <xsl:apply-templates select="$set-milestones"/>
            </xsl:variable>
            <xsl:variable name="fix-ids">
                <xsl:apply-templates select="$build-TEI-body" mode="fix-ids"/>
            </xsl:variable>
            
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
                                
                                <xsl:copy-of select="$fix-ids"></xsl:copy-of>
                                
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
    
    <!-- fix ids to add chapters -->
    <xsl:template match="@*|node()" mode="fix-ids">
        <xsl:copy>
            <xsl:apply-templates 
                select="@*|node()" 
                mode="fix-ids"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:ab" mode="fix-ids">
        <xsl:variable name="ch_no" select="
                functx:pad-integer-to-length((if (*[1][@unit = 'chapter']) then
                    *[1]
                else
                    preceding::tei:milestone[@unit = 'chapter'][1])/@n, 2)"/>
        <xsl:variable name="new_id" select="local:insert_ch_no($ch_no,@xml:id)"/>
        
        <ab xml:id="{$new_id}" n="{substring-after($new_id,'ref-b.')}">
            <xsl:copy-of select="@* except (@xml:id|@n)"></xsl:copy-of>
            <xsl:apply-templates 
                select="@*|node()" 
                mode="fix-ids">
                <xsl:with-param name="ch_no" select="$ch_no" tunnel="yes"/>
            </xsl:apply-templates>
        </ab>
    </xsl:template>

    <xsl:template match="tei:milestone[@unit='chapter']" mode="fix-ids">
        <xsl:variable name="ch_no" select="functx:pad-integer-to-length(@n,2)"/>
        <xsl:variable name="id_tokens" select="tokenize(@xml:id,'\.')"/>
        <milestone 
            xml:id="{string-join((for $i in 1 to count($id_tokens) - 1 return $id_tokens[$i],$ch_no),'.')}"
            n="{$ch_no}">
            <xsl:copy-of select="@* except (@xml:id|@n)"/>
        </milestone>
    </xsl:template>
    
    <xsl:template match="tei:seg" mode="fix-ids">
        <xsl:param name="ch_no" tunnel="yes"/>
        <xsl:variable name="id_tokens" select="tokenize(@xml:id,'\.')"/>
        <xsl:variable name="new_id" select="string-join((for $i in 1 to count($id_tokens) - 2 return $id_tokens[$i],$ch_no,'T'),'.')"/>
        <seg 
            xml:id="ref-b.{$new_id}"
            n="{$new_id}">
            <xsl:copy-of select="@* except (@xml:id|@n)"/>
            <xsl:apply-templates mode="fix-ids"></xsl:apply-templates>
        </seg>
    </xsl:template>

    <xsl:template match="tei:*[@xml:id][ancestor::tei:ab][not(@unit='chapter')]" mode="fix-ids">
        <xsl:param name="ch_no" tunnel="yes"/>
        <xsl:variable name="new_id" select="local:insert_ch_no($ch_no,@xml:id)"/>
        <xsl:element name="{name()}">
            <xsl:attribute name="xml:id" select="$new_id"></xsl:attribute>
            <xsl:attribute name="n" select="substring-after($new_id,'ref-b.')"></xsl:attribute>
            <xsl:copy-of select="@* except (@xml:id|@n)"></xsl:copy-of>
        </xsl:element>
    </xsl:template>

    <xsl:function name="functx:pad-integer-to-length" as="xs:string">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        
        <xsl:sequence select="
            if ($length &lt; string-length(string($integerToPad)))
            then error(xs:QName('functx:Integer_Longer_Than_Length'))
            else concat
            (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
            string($integerToPad))
            "/>
        
    </xsl:function>
    <xsl:function name="functx:repeat-string" as="xs:string">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:sequence select="
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "/>
        
    </xsl:function>
    <xsl:function name="local:insert_ch_no">
        <xsl:param name="ch_no"></xsl:param>
        <xsl:param name="id_str"></xsl:param>
        <xsl:variable name="before" select="substring($id_str,1,11)"/>
        <xsl:variable name="after" select="substring($id_str,13)"/>
        <xsl:value-of select="string-join(($before,$ch_no,$after),'.')"></xsl:value-of>
        
    </xsl:function>
    
    
</xsl:stylesheet>