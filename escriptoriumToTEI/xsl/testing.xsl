<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:local="local.functions.uri"
    xmlns="local.functions.uri">
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:include href="extractExcelCellsModifiedForPipelining.xsl"/>
    <xsl:template name="start">
        <out><xsl:call-template name="start_excel">
            <xsl:with-param name="xl-path" tunnel="yes" 
                select="'zip:file:/C:/Users/hlapin/Box%20Sync/Research/Dicta%20Alignment%20Experiments/dicta_collatex/dicta_collatex.4.1/dicta.4.1.xlsx!/xl/worksheets/sheet1.xml'"></xsl:with-param>
        </xsl:call-template></out>
    </xsl:template>
</xsl:stylesheet>