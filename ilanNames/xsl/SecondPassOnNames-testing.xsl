<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs local"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:variable name="x-person-keys-x">
        <!-- If this overloads memory, can reduce by volume -->
            <xsl:for-each select="/TEI/text/body/div/ab/listPerson/person">
                <x-person x="{@xml:id}" n="{@n}"/>
            </xsl:for-each>
        <!--</list>-->
    </xsl:variable>
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
        <xsl:variable name="Vol-1">
            <xsl:copy-of select="$x-person-keys/*:Vol-1"></xsl:copy-of>
        </xsl:variable>
        <!--<testOut>
           <!-\- <xsl:copy-of select="$Vol-1"></xsl:copy-of>-\->
            <test><xsl:copy-of select="key('x-persons',for $s in $x-person-keys/*:Vol-1/*[matches(@n,'^Vol-1-B_F-Abigael-1$')] return $s/@n, $x-person-keys/*[name()='Vol-1'])"/></test>
            <xsl:copy-of select=" $x-person-keys/*:Vol-1"/>
        </testOut>-->
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"></xsl:apply-templates>
        </xsl:copy>
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
                        <!-- NB: uses negative lookahead, assumes java regex engine (;j flag) rather than saxon -->
                        <!--<xsl:message><xsl:copy-of select="key('x-persons',for $s in $x-person-keys/*[matches(@n,$name-to-test,';j')] return $s/@n,$x-person-keys)/@x"/></xsl:message>-->
                        <!--<xsl:message select="key('x-persons',matches(.,$name-to-test),$x-person-keys)"></xsl:message>-->
                        <!--  <test><xsl:copy-of select="key('x-persons',for $s in $x-person-keys/*:Vol-1/*[matches(@n,'^Vol-1-B_F-Abigael-1$')] return $s/@n, $x-person-keys/*[name()='Vol-1'])"/></test>                      -->
                        <!--<xsl:message select="$prefix-to-use"></xsl:message>-->
                        <ref
                            corresp="#{key('x-persons',for $s in $x-person-keys/*[name() = $prefix-to-use]/*[matches(@n,$name-to-test,';j')] 
                            return $s/@n,$x-person-keys/*[name() = $prefix-to-use])/@x}"
                            type="relation" sub-type="{regex-group(4)}-of">
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