<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xi tei" 
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <!-- Mark div of each facsimile xml file with folio, ABCD -->
    <!-- through xincluded whole: look up table imagename | folio number -->
    <!-- iterate individual facs xml files update div (folio), pb (folio r/v) cb (folio r/v ABCD) of each -->
    <!-- also update text hierarchy comments to milestones -->
    <!-- Milestone pattern <milestone unit="div3" n="unitId" type = "wkID(yT, M)" -->
    
    
    <xsl:param name="indexLoc" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/tei-facs2/P000308265/P000308265-facs.xml'"></xsl:param>
    <xsl:param name="dataLoc" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/tei-facs/P000308265/'"></xsl:param>
    
    <xsl:variable name="pbs"> 
            <pbs >
        <xsl:for-each select="doc($indexLoc)//tei:TEI">
                <pb>
                <xsl:attribute name="id" select="tei:text/tei:body/tei:div/tei:pb[1]/@xml:id"/>
                <!--<xsl:attribute name="n">-->
                    <xsl:variable name="vol">
                        <xsl:variable name="count"
                            select="count(tei:text/tei:body/tei:div[@type = 'folio' and @n = '0'] | preceding::tei:TEI/tei:text/tei:body/tei:div[@type = 'folio' and @n = '0'])"/>
                        <xsl:value-of select="
                                if ($count = 1) then
                                    'I'
                                else
                                    if ($count = 2) then
                                        'II'
                                    else
                                        if ($count = 3) then
                                            'III'
                                        else
                                            if ($count = 4) then
                                                'IV'
                                            else
                                                ()"/>
                    </xsl:variable>
                    <xsl:choose>
                        
                        <xsl:when
                            test="tei:text/tei:body/tei:div/tei:ab[@type = 'Paratext']/tei:l[matches(., '^\s*\d{1,2}(\.\d{1,2})?\s*$')]">
                            <xsl:attribute name="n" select="
                                    concat($vol, '_',
                                    normalize-space(tei:text/tei:body/tei:div/tei:ab[@type = 'Paratext']/tei:l/comment()[matches(., '^\s*\d{1,2}(\.\d{1,2})?\s*$')]))"/>
                            <xsl:attribute name="rv" select="'r'"></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="n" select="
                                    concat($vol, '_',
                                    normalize-space(preceding::tei:TEI[1]/tei:text/tei:body/tei:div/tei:ab[@type = 'Paratext']/tei:l/comment()[matches(., '^\s*\d{1,2}(\.\d{1,2})?\s*$')]))"/>
                            <xsl:attribute name="rv" select="'v'"></xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                <!--</xsl:attribute>-->
            </pb>
        </xsl:for-each>
        </pbs>
    </xsl:variable>
    
    <xsl:key name="pbkey" match="tei:pb" use="@corresp"></xsl:key>
    <xsl:template name="start">
        <out><xsl:copy-of select="$pbs"></xsl:copy-of></out>
        
        <!--<xsl:for-each select="collection(concat($dataLoc,'pages/?select=*.xml;recurse=no'))">
            
            <xsl:variable name="fname" select="tokenize( base-uri(.),'/')[last()]"/>
            
            <xsl:result-document href="{concat($dataLoc,'updated/',$fname)}" encoding="UTF-8" method="xml">
                <xsl:apply-templates></xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
        <!-\-<out>
            <xsl:for-each  select="doc($indexLoc)//tei:pb/@xml:id">
                <xsl:copy-of select="key('pbkey', ., $pbs)"></xsl:copy-of>
            </xsl:for-each>

            
        </out>-\->-->
    </xsl:template>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <!--<xsl:copy-of select="key('pbkey',@xml:id,$pbs)"></xsl:copy-of>-->
        <xsl:variable name="page" select="key('pbkey',@xml:id,$pbs)"/>
        <pb xml:id="{@xml:id}" 
            n="{concat($page/@n,$page/@rv)}">
        </pb>
    </xsl:template>
    <xsl:template match="tei:cb">
        <xsl:variable name="page" select="key('pbkey',preceding-sibling::tei:pb/@xml:id,$pbs)"/>
        <!--<!-\- Why did this not work? -\->
            <xsl:variable name="column" select="
            if (key('pbkey',@xml:id,$pbs)/@rv eq 'r') then () 
                (if (following-sibling::tei:cb) then concat($page,'A')
                else concat($page,'B'))
            else 
                (if (following-sibling::tei:cb) then concat($page,'C')
                else concat($page,'D'))"/>-->
        <xsl:variable name="column">
            <xsl:choose>
                <xsl:when test="$page/@rv eq 'r'">
                    <xsl:value-of select="concat($page/@n,$page/@rv,
                        if (following-sibling::tei:cb) then 'A' else 'B')"/>
                </xsl:when>
                <xsl:when test="$page/@rv eq 'v'">
                    <xsl:value-of select="concat($page/@n,$page/@rv,
                        if (following-sibling::tei:cb) then 'C' else 'D')"/>
                </xsl:when>
            </xsl:choose>
            
        </xsl:variable>
        <cb xml:id="{@xml:id}" n="{$column}">
            
        </cb>
    </xsl:template>
    <xsl:template match="comment()" priority="1">
        <xsl:choose>
            <xsl:when test="ancestor::tei:ab[@type = 'Paratext']"/>
            
            <xsl:otherwise>
                <xsl:variable name="milestoneData" as="element()+">
                    <order><xsl:value-of select="number(replace(.,'^\s*(\d{1,2})(\d{2})?([MY])?(\d{1,2})?\s*$','$1'))"/>
                    </order>
                    <tract>
                        <xsl:value-of select="number(replace(.,'^\s*(\d{1,2})(\d{2})?([MY])?(\d{1,2})?\s*$','$2'))"/>
                    </tract>
                    <chapt>
                        <xsl:value-of select="number(replace(.,'^\s*(\d{1,2})(\d{2})?([MY])?(\d{1,2})?\s*$','$4'))"/>
                    </chapt>
                    <work>
                        <xsl:value-of select="if (replace(.,'^\s*(\d{1,2})(\d{2})?([MY])?(\d{1,2})?\s*$','$3') eq 'M') 
                            then 'M' 
                            else 'yT'"/>
                    </work>
                </xsl:variable>
                
                    <milestone 
                    unit="{if (number($milestoneData[3]) = number($milestoneData[3])) 
                        then 'div3'
                    else if (number($milestoneData[2]) = number($milestoneData[2])) 
                        then 'div2'
                    else 'div1'}"
                    n="{string-join(($milestoneData[1],
                    if (number($milestoneData[2]) = number($milestoneData[2])) 
                        then $milestoneData[2]
                        else (), 
                        if (number($milestoneData[3]) = number($milestoneData[3])) 
                         then $milestoneData[3]
                         else ()),
                    '.')}"
                    type="{$milestoneData[4]}" />
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>