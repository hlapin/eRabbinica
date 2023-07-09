<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:x="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="x">
    <xsl:output indent="yes"></xsl:output>
    
    <!-- Sefaria JSON input of Bavli tractate  -->
    <!-- Calculates folios -->
    <!-- Returns xml as follows:  -->
    <!--    milestone mars folios, sub-segments of folios as relected in Sefaria (Steinzaltz?) -->
    <!--    str the units of sub sections text -->
    <!--    tags the starting html tags that begin Mishnah/Talmud or end Chapters/Tractates-->
    
    
    <!-- The input JSON file -->
    <xsl:param name="inputLocal" select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/tannaiticIntersections/data/json/bavli/0509_Tamid_Sefaria.json'"/>
    
    <!-- The initial template that process the JSON -->
    <xsl:template name="json-to-XML-initial-template">
        <xsl:param name="input"/>
        <xsl:variable name="tract" 
            select="replace(tokenize(tokenize($input, '/')[last()],'_')[1],'(\d{2})(\d{2})','$1.$2')"/>
        <xsl:variable name="src" 
            select="json-to-xml(unparsed-text($input))"/>
        <out>
            <head>
                <name>
                    <xsl:value-of select="$src/x:map/x:string[@key='title']"/>
                </name>
                <name_he><xsl:value-of select="$src/x:map/x:string[@key='heTitle']"/></name_he>
                <id><xsl:value-of select="$tract"/></id>
                <source><xsl:value-of select="$src/x:map/x:string[@key='versionSource']"/></source>
            </head>
            <data><xsl:apply-templates  select="$src//x:array[@key = 'text']/*">
                <xsl:with-param name="id" select="$tract" tunnel="yes"/>
            </xsl:apply-templates></data>
        </out>
    </xsl:template>
    
    <xsl:template match="x:array">
        <xsl:param name="id" tunnel="yes"></xsl:param>
        <xsl:if test="normalize-space()">
            <xsl:variable name="ab" select="
                concat(floor((position() + 1) div 2), if (position() mod 2 = 0) then
                'b'
                else
                'a')"/>
            <milestone unit="ab" n="{concat($id,'.',$ab)}"/>
            <xsl:apply-templates select="x:string">
                <xsl:with-param name="ab" select="$ab"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    <xsl:template match="x:string">
        <xsl:param name="ab"/>
        <xsl:param name="id" tunnel="yes"></xsl:param>
        <xsl:variable name="segNo" select="count(preceding-sibling::x:string) + 1"/>
        <milestone unit="segment" n="{concat($id, '.', $ab,'.',$segNo)}"/>
        <xsl:call-template name="strip-strings"/>
    </xsl:template>
    <xsl:template name="strip-strings">
        <!-- vocalization and punctuation -->
        <xsl:variable name="no-punct" select="replace(.,'[,:!—\.\?&#x591;-&#x5C7;]','')"/>
        <!-- retain contents of of square brackets, but remove bracket                                        s -->
        <xsl:variable name="no-brackets" select="replace($no-punct,'[\[\]]','')"/>
        <!-- remove parens and contents -->
        <xsl:variable name="no-parens" select="replace($no-brackets,'\([^\)]*\)','')" />
        <!-- remove quotes/gershayyim around text, leaving text -->
        <!-- unfortunately inconsistent about use of quotes vs gershayyim 
             so convert all gershayyim to quotes and all single apostrophe to geresh-->
        
        <xsl:variable name="apos-to-geresh" select="translate($no-parens,'&apos;'','&#x5F3;')"></xsl:variable>
        <xsl:variable name="gershayyim-to-quotes" select="translate($apos-to-geresh,'&#x5F4;','&quot;' )"/>
        
        <!-- spot quote marks belonging to abbreviations and convert to gershayyim -->
        <xsl:variable 
            name="fixed-abbrev">
            <xsl:analyze-string 
                select="$gershayyim-to-quotes" 
                regex="(\s+\p{{IsHebrew}}+)&quot;(\p{{IsHebrew}}{{1}}[$\s*])">
                <xsl:matching-substring>
                    <xsl:value-of
                        select="concat(regex-group(1), '&#x5F4;', regex-group(2))"/>
                </xsl:matching-substring>
                
                <!-- remove remaining quotes -->
                <xsl:non-matching-substring>
                    <xsl:value-of select="replace(.,'&quot;','')"/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <!--split off html tags at beginning of sections--> 
        <xsl:analyze-string select="$fixed-abbrev" regex="(^.*&lt;/strong&gt;&lt;/big&gt;)(.*$)">
            <xsl:matching-substring>
                <tags><xsl:value-of select="normalize-space(regex-group(1))"/></tags>
                <str>
                    <xsl:if test="matches(regex-group(2), '\p{IsHebrew}')">
                        <xsl:value-of select="normalize-space(regex-group(2))"/>
                    </xsl:if>
                </str>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:if test="matches(., '\p{IsHebrew}')">
                    <str>
                        <xsl:value-of select="normalize-space(.)"/>
                    </str>
                </xsl:if>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        <!--<str><xsl:copy-of select="$fixed-abbrev"></xsl:copy-of></str>-->
    </xsl:template>
</xsl:stylesheet>