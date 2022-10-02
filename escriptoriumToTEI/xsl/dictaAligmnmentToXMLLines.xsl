<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="local.functions.uri"
    exclude-result-prefixes="xs local tei" version="3.0">
    <xsl:output indent="yes"/>

    <!-- called from template[@name = 'lines'], with $rows corresponding to rows extract  -->
    <!-- $target, $compare refer to columns of dicta output-->
    <!-- $target is the witness to which we wish to transfer canonical milestones. -->
    <!-- $compare is a canonically divided "default" text typically vilna -->
    

    <xsl:param name="target" select="'default'"/>
    <xsl:param name="rows" select="'default'"/>
    <xsl:param name="xl-data" select="'default'"></xsl:param>
    
    <xsl:param name="line_match_pattern" select="'default'"/>
    <!--<xsl:param name="div_match_pattern" select="'default'"/>
    <xsl:param name="ref_match_pattern" select="'default'"/>
    <xsl:param name="col_match_pattern" select="'default'"></xsl:param>
    <xsl:param name="compare1" select="'default'"/>
    <xsl:param name="compare2" select="'default'"/>
    <xsl:variable name="abbrs" select="doc('biblRabbValues.xml')"/>
-->
    
    <xsl:template name="create-target-line-from-alignment">
        <xsl:param name="rows" select="$xl-data"></xsl:param>
        <xsl:copy-of select="$rows//local:row"></xsl:copy-of>
    </xsl:template>
    
</xsl:stylesheet>
