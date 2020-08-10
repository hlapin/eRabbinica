<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs local"
    version="2.0">
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="check"><xsl:call-template name="volumes"></xsl:call-template></xsl:variable>
        <xsl:copy-of select="$check/*"></xsl:copy-of>
    </xsl:template>    

    <!--  ^(.+)((B|G|Ha|L|P|S|I\-G|S\-H|A|E|I)_(M|F|Names)).+$', $1  -->
    <xsl:template name="volumes">
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
                <!-- (Ha_Names|B_[MF]|G_[MF]|L_[MF]|P_[MF]|S\-G_[MF]|S\-H_[MF]|A_[MF]|E_I[MF]|)-->
                <!-- <item><xsl:copy-of select="replace(., '(^(Vol\-\d\-)+(Ha-Names|B_[MF]|G_[MF]|L_[MF]|P_[MF]|S\-G_[MF]|S\-H_[MF]|A_[MF]|E_I[MF]|)).+-names\.xml$', '$1')"/></item> -->
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each-group select="for $i in $files/* return $i" group-by="replace(.,'^(Vol\-\d).+$','$1')">
            <list type="{replace(current-group()[1],'^(Vol\-\d).+$','$1')}"><xsl:copy-of select="for $i in current-group() return ($i)"></xsl:copy-of></list>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>