<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" 
    xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:file="http://expath.org/ns/file" 
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs map array tei local saxon file" version="3.0">
    <xsl:output indent="yes"/>


    <!-- probably could be pipelined in ant or xproc but ... -->
    <!-- iterate over excel files  -->
    <!--    Transfer canonical milestones from $compare to $target column -->
    <!--    create a MASTER LIST of lines to replace existing lines -->
    <!-- Process TEI-Facs files -->
    <!--    ??[parent document with xincludes, or individual per page xml files? -->
    <!--    match lines to be replaced:      -->
    <!--    *** tokenize(tei:l/@corresp,'_')[last()] eq tokenize(local:l/@n, '_')[last()]  -->

    <xsl:import href="extractExcelCellsModifiedForPipelining.xsl"/>
    <xsl:import href="dictaMilestonesPipelined.xsl"/>

    <xsl:param name="xl-root"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/vilna_paris/'"/>
    <xsl:param name="target" select="'S08174-'"/>
    <xsl:param name="compare" select="'vilna-'"/>
    <xsl:param name="xml-root" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/tei-facs/S08174/pages'"></xsl:param>
   

    <xsl:variable name="files"
        select="file:list($xl-root)"> </xsl:variable>
    <xsl:variable name="pathToWorksheets" select="'!/xl/worksheets/'"/>
    <xsl:variable name="suffixToSheet" select="'sheet1.xml'"/>

    <xsl:variable name="xml-data" select="collection(concat($xml-root,'?select=*.xml;recurse=no'))"/>
    <xsl:variable name="xml-out" select="concat($xml-root,'/out/')"/>

    <xsl:variable name="lines_w_milestones">
        <!-- step 1, iterate through each excel documents and extract cells-->
        <!-- step 2, for each of excel documents transfer canonical milestones from $transfer to $compare  -->
        <!-- step 3, retain only lines with milestones. -->
        <xsl:for-each select="$files">
            <xsl:message select="concat('zip:', $xl-root, ., $pathToWorksheets, $suffixToSheet)"></xsl:message>
            <xsl:variable name="xl-path">
                <xsl:copy-of
                    select="concat('zip:', $xl-root, ., $pathToWorksheets, $suffixToSheet)"/>
            </xsl:variable>
            <xsl:variable name="test-out" as="node()*">
                <xsl:call-template name="start_excel">
                    <xsl:with-param name="xl-path" select="$xl-path" tunnel="yes"/>
                    <!--<xsl:with-param name="document-uri" select="$document-uri" tunnel="yes"/>-->
                </xsl:call-template>
            </xsl:variable>
            <!--<xsl:copy-of select="$test-out/*"/>-->
            <xsl:call-template name="lines">
                <xsl:with-param name="rows" select="$test-out/*"/>
                <xsl:with-param name="target" select="$target"/>
                <xsl:with-param name="compare" select="$compare"/>
            </xsl:call-template>
        </xsl:for-each>
        
    </xsl:variable>
    <xsl:key name="line" match="*:l" use="@n"></xsl:key>
    
   
    <xsl:template name="start">
        <out>
            <!-- step 1, iterate through each excel documents and extract cells-->
            <!-- step 2, for each of excel documents transfer canonical milestones from $transfer to $compare  -->
            <!-- step 3, retain only lines with milestones. -->
            <!--<xsl:copy-of select="$lines_w_milestones"></xsl:copy-of>-->
            
            <!-- step 4, update [tei-facs or pagexml] -->
            <!--<xsl:copy-of select="key('line','eSc_line_11617a08',$lines_w_milestones)"/>-->
            <xsl:for-each select="$xml-data">
                <xsl:message select="document-uri(.)"></xsl:message>
                <xsl:variable name="fName" select="tokenize(document-uri(.),'/')[last()]"/>
                <xsl:result-document href="{concat($xml-out,$fName)}" indent="yes" encoding="UTF-8">
                    <xsl:apply-templates mode="transform" select="."></xsl:apply-templates>
                </xsl:result-document>
            </xsl:for-each>

        </out>
    </xsl:template>


    <!-- move this to own template? modularize for pageXML as well? -->
    <xsl:template match="@*|node()" mode="transform">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="transform"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:l" mode="transform">
        <xsl:variable name="id" select="substring-after(@corresp, '-')"/>
        <xsl:choose>
            <xsl:when test="key('line', $id, $lines_w_milestones)">
                <!-- replace line in tei with line with milestone -->
                <xsl:message select="$id"/>
                <l>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates 
                        select="key('line', $id, $lines_w_milestones)/node()"
                        mode="transform"/>
                </l>
            </xsl:when>
            <xsl:otherwise>
                <!-- just copy the element -->
                <xsl:copy-of select="."></xsl:copy-of>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    <xsl:template match="text()[parent::local:l]" mode="transform">
        <xsl:value-of select="normalize-unicode(.)"/>
    </xsl:template>
    
    <xsl:template match="local:milestone" mode="transform">
        <milestone>
            <xsl:copy-of select="@*|node()"></xsl:copy-of>
        </milestone>
    </xsl:template>

</xsl:stylesheet>
