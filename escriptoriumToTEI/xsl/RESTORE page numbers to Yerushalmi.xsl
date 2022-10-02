<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="http://www.local.uri"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:functx="http://www.functx.com"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs PcGts xsi tei local functx" version="2.0">
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="pageXMLIn" select="'file:/C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/pagexml/YerushalmiVenice/'"/>
    <xsl:variable name="currentFacsSource" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/tei-facs/P000308265/P000308265-facs.xml'"/>
    <xsl:variable name="currentFacsbyPage" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/tei-facs/P000308265/pages/'"/>
    
    <xsl:variable name="pbcbInPageXML">
        <xsl:variable name="page_data"
            select="collection(iri-to-uri(concat($pageXMLIn, '?select=*.xml;recurse=no')))">
            <!-- to parameterize -->
        </xsl:variable>
        <xsl:for-each select="$page_data">
            <pb>
                <xsl:variable name="fname"
                    select="substring-before(tokenize(base-uri(.), '/')[last()], '.xml')"/>
                <xsl:attribute name="corresp" select="$fname"></xsl:attribute>
                <xsl:variable name="folio_no" select="//PcGts:TextRegion[@custom = 'structure {type:Paratext;}']//Unicode/text()[matches(., '/\d{1,2}/')]"/>
                
                <xsl:attribute name="vr" select="if($folio_no) then 'r' else 'v'"></xsl:attribute>
            </pb>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="pbcbInFacs">
        <xsl:for-each select="//tei:div">
            <xsl:variable name="vol" 
                select="if (count(.[@n='0']|preceding::tei:div[@n='0']) eq 1) then 'I' 
                else if (count(.[@n='0']|preceding::tei:div[@n='0']) eq 2) then 'II' 
                else if (count(.[@n='0']|preceding::tei:div[@n='0']) eq 3) then 'III'
                else if (count(.[@n='0']|preceding::tei:div[@n='0']) eq 4) then 'IV' 
                else ()"/>
                <xsl:for-each select="tei:pb|tei:cb">
                    <xsl:element name="{name()}">
                        <xsl:copy-of select="@*"></xsl:copy-of>
                        <xsl:attribute name="vol" select="$vol"></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="update_list">
        <xsl:for-each select="$pbcbInFacs/(tei:pb|tei:cb)">
            <xsl:variable name="curr_vol" select="@vol"/>
            <xsl:variable name="idx" select="substring-after(tokenize(@xml:id,'\-')[1],'_')" />
            <xsl:variable name="vr" select="string(key('pagexml',$idx,$pbcbInPageXML)/@vr)"></xsl:variable>
            <xsl:variable name="page_no" 
                select="if (self::tei:cb) 
                then count(preceding-sibling::tei:pb[@vol=$curr_vol])
                else if (self::tei:pb) 
                then count(.|preceding-sibling::tei:pb[@vol=$curr_vol])
                else 'PROBLEM'"/>
            <xsl:variable name="folio_no" select="floor($page_no div 2)+1"/>
            <xsl:variable name="col" 
                select="if ($vr eq 'v' and substring-after(@xml:id,'-') eq 'A') then 'C' 
                else if ($vr eq 'v' and substring-after(@xml:id,'-') eq 'B') then 'D' 
                else substring-after(@xml:id,'-')"/>
            <xsl:element name="{name()}" >
                <xsl:copy-of select="@xml:id"></xsl:copy-of>
                <xsl:attribute name="n" select="concat(@vol,'_',$folio_no,$vr, if (self::tei:cb) then $col else ())"></xsl:attribute >
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:key name="pagexml" match="tei:pb" use="@corresp"></xsl:key>
    <xsl:key name="update" match="tei:pb|tei:cb" use="@xml:id"/>
    
    <xsl:template name="start">
            
            <xsl:for-each select="collection(iri-to-uri(concat($currentFacsbyPage, '?select=*.xml;recurse=no')))">
                <xsl:variable name="out_fname" select="tokenize(document-uri(/),'/')[last()]"></xsl:variable>
                <xsl:message select="$out_fname"/>
                <xsl:result-document href="{concat($currentFacsbyPage,'new_pb_cb/',$out_fname)}">
                    <xsl:apply-templates select="/"/>
                </xsl:result-document>
            </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:pb|tei:cb" priority="3">
        <xsl:copy-of select="key('update',@xml:id,$update_list)"/>
    </xsl:template>
    

</xsl:stylesheet>