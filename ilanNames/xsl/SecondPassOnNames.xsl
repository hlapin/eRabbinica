<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs local"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:variable name="x-person-keys">
        <xsl:variable name="persons" select="/TEI/text/body/div/ab/listPerson/person"/>
        <xsl:for-each-group select="/TEI/text/body/div/ab/listPerson/person" group-by="replace(@n,'^(Vol-[1-4]).+','$1')">
            <xsl:element name="{current-grouping-key()}">
                <xsl:for-each select="current-group()">
                    <x-person x="{@xml:id}" n="{@n}"/>    
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each-group>
    </xsl:variable>
    <xsl:key name="x-persons" match="*:x-person" use="string(@n)"/>
    <xsl:template match="/">
       <!-- <testOut>
            <!-\-<xsl:copy-of select="$x-person-keys/*[1]"></xsl:copy-of>
            <test><xsl:copy-of select="key('x-persons',matches('Vol-1-B_F-Abigael-1','Vol-1+?Abigael-1'),$x-person-keys)/@x"/></test>-\->
          <xsl:variable name="check"><xsl:call-template name="volumes"></xsl:call-template></xsl:variable>
          <xsl:copy-of select="$check/*"></xsl:copy-of>
        </testOut>-->
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="ab">
        <xsl:variable name="idToUse" select="substring-before(tokenize(@corresp, '[#/]')[last()],'Vol-')"/>
        <!--<xsl:message select="concat($idToUse, position())"></xsl:message>-->
        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="replace(concat('names-xr/name-',$idToUse, position(),'.xml'),'\s','')"></xsl:attribute>
            <xsl:attribute name="xpointer" select="replace(concat('name-',$idToUse,generate-id() ),'\s','')"></xsl:attribute>
        </xsl:element>
        <xsl:result-document encoding="utf-8" href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/ilanNames/xml/names-xr/{concat('name-',$idToUse, position())}.xml">
            <TEI >
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>Tal Ilan Lexicon, Master List -- <xsl:value-of select="@n"/></title>
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
                        <div type='name'>
                            <ab>
                                <xsl:copy-of select="@*"></xsl:copy-of>
                                <xsl:attribute name="xml:id" select="replace(concat('name-',$idToUse,generate-id() ),'\s','')"></xsl:attribute>
                                <xsl:apply-templates></xsl:apply-templates>
                            </ab>
                        </div>
                    </body>
                </text>
            </TEI>
           
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="text()[ancestor::state[@type='desc']]">
            <xsl:choose>
                <xsl:when
                    test="matches(., '([^,.\s\d]+)\s+(\((\d+)\)[''’]s)\s+([^?,.\s\d]+)')">
                    <xsl:variable name="prefix-to-use" select="substring(ancestor::person/@n,0,6)"/>
                    <xsl:variable name="prefix-to-test"
                        select="concat('^', replace(ancestor::person/@n, '^(Vol-[1234]).+', '$1'),'(?!(-Vol)).+?')">
                        <!-- NB: uses negative lookahead, assumes java regex engine rather than saxon -->
                    </xsl:variable>
                    <xsl:analyze-string select="."
                        regex="([^,.\s\d]+)\s+(\((\d+)\)[''’]s)\s+([^?,.\s\d]+)">
                    <xsl:matching-substring>
                        <xsl:variable name="name-to-test"
                            select="concat($prefix-to-test, regex-group(1), '-', regex-group(3), '$')"/>
                        <ref
                            corresp="#{key('x-persons',for $s in $x-person-keys/*[name() = $prefix-to-use]/*[matches(@n,$name-to-test,';j')] 
                            return $s/@n,$x-person-keys/*[name() = $prefix-to-use])/@x}"
                            type="relation" n="{regex-group(4)}-of">
                            <xsl:value-of
                                select="."/>
                        </ref>
                    </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                        <xsl:fallback>
                            <problemhere>
                                <xsl:value-of select="."/>
                            </problemhere>
                        </xsl:fallback>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <!--  ^(.+)((B|G|Ha|L|P|S|I\-G|S\-H|A|E|I)_(M|F|Names)).+$', $1  -->
    <xsl:template name="volumes">
        <!-- returns a list of  chapters grouped by volume-->
        <xsl:variable name="files">
            <xsl:for-each
                select="
                    distinct-values(for $c in /TEI/text/body/div/ab/@corresp
                    return
                        for $f in tokenize($c, '\s')
                        return
                            tokenize($f, '/')[2])">
                <xsl:sort select="replace(., '^(Vol\-[\d]\-).+$', '$1')"/>
                <item><xsl:copy-of select="replace(., '(^.+(Ha|A|E|I|B|G|L|P|S\-G|S\-H)_(Names|M|F)).+-names\.xml$', '$1')"/></item>
            </xsl:for-each>
        </xsl:variable>
        <!-- put chs into volumes and workable order, longest to shortest -->
        <xsl:for-each-group select="for $i in $files/* return $i" group-by="replace(.,'^(Vol\-\d).+$','$1')">
            <list type="{replace(current-group()[1],'^(Vol\-\d).+$','$1')}">
                <xsl:for-each select="for $i in current-group() return ($i)">
                <xsl:sort select="string-length(.)" order="descending"  data-type="number"></xsl:sort>
                    <xsl:copy-of select="."></xsl:copy-of>
                </xsl:for-each></list>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>