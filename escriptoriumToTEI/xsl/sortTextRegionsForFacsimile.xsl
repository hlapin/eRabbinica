<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="http://www.local.uri"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:saxon="http://saxon.sf.net/"
    xmlns:functx="http://www.functx.com" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs PcGts xsi tei local functx saxon" version="2.0">
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:strip-space elements="*"/>
<!--    <xsl:param name="how_many_cols" select="2"></xsl:param>
    <xsl:param name="regionSelect" select="'Main Commentary'"/>
    <xsl:param name="regionSelect" select="'Main Commentary'"/> 
    <xsl:variable name="regionTypesForColumns" select="tokenize($regionSelect, '\s+')"/> -->
    
    <!-- given a list of regions in pageXML         -->
    <!-- return a list of n (1-2 for now) columns   -->
    <!-- produces: grouped set of nodes with id and coords -->
    <!-- procedure:                                 -->
    <!--    *calculate midline of main body of page -->
    <!--    *vertically sort Regions minY (top)     -->
    <!--    *group columns on whether maxY (right)  -->
    <!--        is L or R of midline                -->
    <!--    *since we are in Hebrew Col A is right  -->

    <!-- coords go from left,top                    -->
    <!-- top right of region or page is maxX, minY  -->
    
    <xsl:template match="/">
        <xsl:variable name="Regions"
            select="
            /PcGts/Page/TextRegion[TextLine/TextEquiv/Unicode]
            intersect
            (for $r in $regionTypesForColumns
            return
            /PcGts/Page/TextRegion[contains(@custom, $r)])
            "/>
        <xsl:call-template name="sortAndSplit">
            <xsl:with-param name="Regions" select="$Regions"></xsl:with-param>
            <xsl:with-param name="num_columns" select="'2'"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="sortAndSplit" xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15">
        <xsl:param name="Regions"></xsl:param>
        <xsl:param name="num_columns" select="'1'"></xsl:param>
        <xsl:variable name="allRegionsBox"
            select="local:box(string-join(($Regions/Coords/@points), ' '))"/>
        <!--<xsl:copy-of select="$allRegionsBox"></xsl:copy-of>-->
        <!--<xsl:message select="$allRegionsBox"/>-->
        <!--    get regions as a sequence of elements with ids and coordinates -->
        <xsl:variable name="regionsList" as="element()+">
            <xsl:call-template name="listRegions">
                <xsl:with-param name="regions" select="$Regions"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$num_columns eq '1'">                
                <!--    *vertically sort Regions minY (top)     -->
                <col n="body" ><xsl:for-each select="$regionsList">
                    <xsl:sort select="@minY" order="ascending" data-type="number"/>
                    <xsl:copy-of select="."></xsl:copy-of>
                </xsl:for-each></col>
            </xsl:when>
            
            <xsl:when test="$num_columns eq '2'">
                <!-- split in two -->
                <!-- should be able to generalize by finding non-overlapping ranges -->
                <!-- but that is for another day -->

                <!--    *calculate midline of main body of page -->
                <xsl:variable name="midline" select="local:midLine($allRegionsBox,0)"/>
                <xsl:message select="$midline"></xsl:message>
                <!--    *group columns on whether maxY (right) > midline -->
                <!-- should be possible to sort directly on for each group directly but did not succeed -->                
                <xsl:for-each-group select="$regionsList" group-by="boolean(@maxX &gt; $midline)">
                <!--<xsl:sort select="@minY" order="ascending" data-type="number" />-->
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <col n="A">
                            <xsl:for-each select="current-group()">
                                <xsl:sort select="@minY" order="ascending" data-type="number"/>
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </col>
                    </xsl:when>
                    <xsl:otherwise>
                        <col n="B">
                            <xsl:for-each select="current-group()">
                                <xsl:sort select="@minY" order="ascending" data-type="number"/>
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </col>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="listRegions">
        <xsl:param name="regions"/>
        <xsl:for-each select="$regions">
            <region id="{@id}" xmlns:local="http://www.local.uri">
                <xsl:copy-of select="local:box(Coords/@points)/@*"/>
            </region>
        </xsl:for-each>
    </xsl:template>


    <xsl:function name="local:box" as="element()">
        <!-- given a list of coordinate pairs, return bounding box -->
        <!-- coords go from left,top -->
        <!-- top right of region or page is maxX, minY -->
        <xsl:param name="coords"/>
        <box
            minX="{min(for $c in tokenize($coords, '\s')
                return
                number(tokenize($c, ',')[1]))}"
            maxX="{max(for $c in tokenize($coords, '\s')
                return
                number(tokenize($c, ',')[1]))}"
            minY="{min(for $c in tokenize($coords, '\s')
                return
                number(tokenize($c, ',')[2]))}"
            maxY="{max(for $c in tokenize($coords, '\s')
                return
                number(tokenize($c, ',')[2]))}"
        />
    </xsl:function>
    <xsl:function name="local:midLine">
        <!--    *calculate midline of main body of page -->
        <xsl:param name="box"/>
        <xsl:param name="pad">
            <!-- amount to move centerline to right for twisted pages -->
        </xsl:param>
        <xsl:sequence select="  (($box/@maxX - $box/@minX ) div 2) + $box/@minX + $pad" />

    </xsl:function>

</xsl:stylesheet>
