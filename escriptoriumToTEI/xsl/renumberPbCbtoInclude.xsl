<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="local.functions.uri"
    xmlns:functx="http://www.functx.com"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs local tei xi" version="3.0">
    <xsl:output indent="yes"/>

    <!-- this should be generalizable but I gave up and dealt with specific instances -->

    <!-- Naples     pattern tei-facs:P1143297-facs.xml#p_jpg_0021 -->
    <!-- Paris 328  pattern tei-facs:S08174-facs.xml#p_328_031_a0f71_default -->
    <!-- Paris 329  pattern tei-facs:S08174-facs.xml#p_329_443_6c355_default -->


    <!--<xsl:variable name="witID" select="/TEI/@xml:id"/>-->
    <xsl:template match="pb | cb" mode="production">
        <xsl:variable name="corresp-tkns" select="tokenize(@corresp,'_')"/>
        <xsl:variable name="pColData" as="item()+">
            <xsl:choose>
                <xsl:when test="matches(@corresp, '[cp]_328')">
                    <xsl:copy-of select="('328_',
                        for $n in local:assign-folio-no(9, $corresp-tkns[3]) return $n)"/>
                </xsl:when>
                <xsl:when test="matches(@corresp, '[cp]_329')">
                    <xsl:copy-of select="('329_',
                        for $n in local:assign-folio-no(6, $corresp-tkns[3]) return $n)"/>
                </xsl:when>
                <xsl:when test="matches(@corresp, 'P1143297')">
                    <xsl:message select="replace($corresp-tkns[last()],'(\d+)(\D.*$)*','$1')"></xsl:message>
                    <xsl:copy-of select="('',
                        for $n in local:assign-folio-no(5, number(replace($corresp-tkns[last()],'(\d+)(\D.*$)*','$1'))) return $n)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"></xsl:copy-of>
            <xsl:variable name="column" select="if(self::cb) then substring(@corresp,string-length(@corresp)) else ()"/>
            <xsl:attribute name="xml:id" select="concat($witID, $pColData[1], $pColData[3],$pColData[4],$column)"/>
            <xsl:attribute name="n" select="concat($pColData[1], $pColData[2],$pColData[4],$column)"/>
        </xsl:element>
    </xsl:template>


    
    <xsl:function name="local:assign-folio-no">
        <xsl:param name="subtractor"/>
        <xsl:param name="img"/>
        
        <xsl:variable name="base" select="(number($img) - number($subtractor)) div 2"/>
        <xsl:variable name="floor" select="floor($base)"/>
        <!--<xsl:if test="floor($base) = $base"><xsl:value-of select="floor($base)"/>r</xsl:if>
        <xsl:if test="floor($base) &lt; $base"><xsl:value-of select="floor($base)"/>v</xsl:if>-->
        <xsl:copy-of select="($floor, functx:pad-integer-to-length($floor,4),if($floor eq $base) then 'r' else 'v')"/>
    </xsl:function>
    
    <xsl:function name="functx:pad-integer-to-length" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        
        <xsl:sequence
            select="
            if ($length &lt; string-length(string($integerToPad)))
            then
            error(xs:QName('functx:Integer_Longer_Than_Length'))
            else
            concat
            (functx:repeat-string(
            '0', $length - string-length(string($integerToPad))),
            string($integerToPad))
            "/>
        
    </xsl:function>
    
    <xsl:function name="functx:repeat-string" as="xs:string" xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:sequence
            select="
            string-join((for $i in 1 to $count
            return
            $stringToRepeat),
            '')
            "/>
        
    </xsl:function>
    
</xsl:stylesheet>
