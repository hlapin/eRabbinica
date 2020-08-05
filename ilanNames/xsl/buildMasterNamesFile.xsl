<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <xsl:variable name="src" select="collection('file:/C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/names/?select=*-to-utf-TEI-P5-names.xml;recurse=no')"/>

    <xsl:template name="start">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Tal Ilan Lexicon, Master List</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text><body><div type="name-list">
            <xsl:for-each-group select="$src//ab" group-by="@n" >
                <ab corresp="{for $id in current-group()/listPerson return concat('names/#',$id/@xml:id)}">
                    <xsl:copy-of select="current-group()[1]/@*"></xsl:copy-of>
                    <xsl:copy-of select="current-group()/ref"></xsl:copy-of>
                    <listPerson>
                    <xsl:apply-templates select="current-group()/listPerson/*"/>
                    </listPerson>
                </ab>
            </xsl:for-each-group>
        </div>
            <div type="notes">
                <xsl:for-each select="$src">
                    
                    <xsl:copy-of select="./TEI/text/body/div/note[@xml:id] | ./TEI/text/body/div/ab/listPerson/person/note[@xml:id] "/></xsl:for-each>
            </div></body></text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="note">
        <!-- omit on this pass -->
    </xsl:template>
</xsl:stylesheet>