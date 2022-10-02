<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://www.local-functions.uri" xmlns:j="http://www.w3.org/2013/XSL/json"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions" version="3.0"
    exclude-result-prefixes="tei xs j local">
    
    <xsl:output indent="yes"/>
    <xsl:variable name="data" select="uri-collection('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/json/sefaria_venice_json')"/>
    
    
    <xsl:template name="start">
        <xsl:for-each select="$data[ends-with(.,'_bikkurim.json')]">
            <xsl:copy-of select="json-to-xml(unparsed-text(.))//array[@key='text']"/><xsl:text>
                
            </xsl:text>
        </xsl:for-each>
        <!--<xsl:copy-of select="json-to-xml(unparsed-text('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/json/sefaria_venice_json/0405_venice_makkot.json')))"></xsl:copy-of>
        <!-\-<xsl:apply-templates
            select="json-to-xml(unparsed-text(encode-for-uri(concat($pathToFile, $fName))))/*"/>-\->
        -->
    </xsl:template>
    
</xsl:stylesheet>