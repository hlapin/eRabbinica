<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei xi"
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <xsl:param name="outPath" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/'"></xsl:param>
    <xsl:variable name="footnotes" select="/tei:TEI/tei:text/tei:body/tei:div[@type='notes']/tei:note"/>
    <xsl:template match="/">
        <xsl:message select="'Building Nym List'"></xsl:message>
        <xsl:call-template name="nyms"></xsl:call-template>
        <xsl:message select="'Building Person Files'"></xsl:message>
        <xsl:call-template name="persons"></xsl:call-template>
        <xsl:message select="'Exporting Notes to notes.xml'">
            <xsl:call-template name="notes"></xsl:call-template>    
        </xsl:message>
    </xsl:template>
    <xsl:template match="@*|node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:ab[@type='name']" mode="nyms">
        <nym type="{replace(tokenize(@corresp,'Vol-\d+-')[last()],'ADD-','')}">
            <xsl:copy-of select="@corresp|@xml:id"/>
            <form><xsl:value-of select="@n"/>
                <xsl:if test="tei:ref[@type='note']/@corresp"><ref target="{tei:ref[@type='note']/@corresp}"></ref></xsl:if>
            </form>
        </nym>
    </xsl:template>
    <xsl:template name="nyms">
        <xsl:result-document href="{concat('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/','nyms.xml')}" encoding="UTF-8" method="xml">
            <TEI xmlns="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Name List for Lexicon of Jewish Names</title>
                        </titleStmt>
                        <publicationStmt>
                            <p>Publication Information</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Information about the source</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <listNym>
                            <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div/tei:ab" mode="nyms"></xsl:apply-templates>
                        </listNym>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="tei:ab" mode="persons">
        <xsl:result-document href="{concat($outPath,'/persons/',@xml:id,'.xml')}">
            <TEI xmlns="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Lexicon of Jewish Names - <xsl:value-of select="@n"/></title>
                        </titleStmt>
                        <publicationStmt>
                            <p>Publication Information</p>
                        </publicationStmt>
                        <sourceDesc>
                            <p>Information about the source</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <listPerson corresp="{concat('../nyms.xml#',@xml:id)}"
                            n="{@n}">
                                 <xsl:apply-templates select="tei:listPerson/*" mode="persons"/>
                        </listPerson>
                    </body>
                </text>
            </TEI>
            
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="tei:floruit" mode="persons">
        <floruit>
            <xsl:apply-templates  select="@*" mode="persons"></xsl:apply-templates>
            <xsl:apply-templates mode="persons"></xsl:apply-templates>
        </floruit>
    </xsl:template>
    <xsl:template match="@notBefore|@notAfter" mode="persons">
        <xsl:attribute name="{name()}" select="if (matches(.,'(\-?)0000')) then replace(.,'(\-?)0000','$10001') else ."></xsl:attribute>
    </xsl:template>
    <xsl:template match="tei:listPerson" mode="persons">
        
    </xsl:template>
    <xsl:template name="persons">
       <xsl:apply-templates select="/tei:TEI/tei:text/tei:body/tei:div/tei:ab" mode="persons"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template name="notes">
        <xsl:result-document href="{concat($outPath,'notes.xml')}"><TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Footntes for Lexicon of Jewish Names</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="notes">
                        <xsl:copy-of select="$footnotes"></xsl:copy-of>
                    </div>
                </body>
            </text>
        </TEI></xsl:result-document>
    </xsl:template>
</xsl:stylesheet>