<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output indent="yes"></xsl:output>
    
    <xsl:template name="start">
        <xsl:variable name="json" select="unparsed-text('../data/json/bavli/merged.json')"/>
        
      <fred><xsl:copy-of select="parse-json($json)"></xsl:copy-of></fred>
    </xsl:template>
    
</xsl:stylesheet>