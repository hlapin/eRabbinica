<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" 
    xmlns:local="local.functions.uri"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs map array PcGts local math PcGts" version="3.0">

    <!-- assumes canonical milestone are first tokens in line -->

    <xsl:import href="extractExcelCellsModifiedForPipelining.xsl"/>
    <xsl:param name="xl-locations" as="element()+">
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0101-Ber.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0102-Pea.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0103-Dem.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0104-Kil.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0105-Shebi.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0106-Terum.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0107-Maas.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0108-MaasSh.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0109-Hal.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0110-Orla.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0111-Bik.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0301-Yeb.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0302-Ket.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0303-Ned.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0304-Naz.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0305-Sot.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0306-Git.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0401-BQ.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0402-BM.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0403-BB.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0404-San.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0406-Shebu.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0407-Ed.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0408-AZ.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0409-Abot.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0410-Hor.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0501-Zeb.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0502-men.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0503-Hul.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0504-Bekh.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0505-ArakNB.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0506-Tem.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0507-Kerit.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0508-Meil.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0509-Tam.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0510-Midd.xlsm"/>
        <f href="file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsx/0511-Qin.xlsm"/>
    </xsl:param>
    <xsl:param name="xl-location"
        select="'zip:file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xlsx/qafahAutogrSplit-xlsm/0501-Zeb.xlsm!/xl/worksheets/sheet1.xml'"/>
    <xsl:param name="pageXML-location"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/pagexml/maimon_autograph'"/>
    <xsl:param name="pageXML-out" select="concat($pageXML-location, '/out/')"/>
    <xsl:param name="target_name" select="'S990050310320205171'"/>
    <xsl:param name="compare_name" select="'Qafah-eSc'"/>
    <!--<xsl:variable name="xl-data" select="doc($xl-location)"> </xsl:variable>-->
    <xsl:variable name="pageXML-data"
        select="collection(concat($pageXML-location, '?select=*.xml;recurse=no'))"/>

    <xsl:variable name="xl">
        <xsl:for-each select="$xl-locations">
            <xsl:variable name="loc" select="concat('zip:',@href,'!/xl/worksheets/sheet1.xml')"/>
            <xsl:call-template name="start_excel">
            <xsl:with-param name="xl-path" select="$loc"></xsl:with-param>
        </xsl:call-template></xsl:for-each>
    </xsl:variable>

    <xsl:variable name="lines">
        <lines>
            <xsl:for-each-group select="$xl//*:row"
                group-starting-with=".[element()[starts-with(local-name(), $target_name)][matches(normalize-space(.), '(l\-\w+)')]]">
                <!-- to deal with errors where token attached to milestone, break up token-->
                <!-- check if element()[starts-with(local-name(), $target_name)] has milestone to keep -->
                <!-- 5/26/22 not necessary with better segmentation. -->
                <xsl:variable name="target_token" select="element()[starts-with(local-name(), $target_name)]"/>
                <xsl:variable name="compare_token" select="element()[starts-with(local-name(), $compare_name)]"/>

                <l
                    n="eSc_line_{substring-after(current-group()[1]/*[starts-with(local-name(), $target_name)],'l-')}">

                    <xsl:for-each select="current-group() except current-group()[1]">
                        <xsl:choose>
                            <xsl:when test="matches(./*[starts-with(local-name(),$target_name)], '(r|ab)-')">
                                <!-- skip -->
                            </xsl:when>
                            <xsl:when
                                test="matches(./*[starts-with(local-name(),$target_name)], '(Start|End)')">
                                <xsl:element
                                    name="{normalize-space(./*[starts-with(local-name(),$target_name)])}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="./*[starts-with(local-name(),$target_name)]"/>
                                <xsl:if test="not(. is current-group()[last()])">
                                    <xsl:value-of select="' '"/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </l>
            </xsl:for-each-group>
        </lines>
    </xsl:variable>
    <xsl:variable name="linesSplitAndTyped">
        <lines><xsl:apply-templates mode="split" select="$lines/PcGts:lines"/></lines></xsl:variable>

    <xsl:key name="line" match="*:l" use="@n"/>

    <xsl:template name="start">
        
            <!-- copy line info to pageXML -->
            <xsl:for-each select="
                    $pageXML-data[/PcGts:PcGts/PcGts:Page/PcGts:TextRegion
                    [@custom eq 'structure {type:Main;}']]">
                <!--<xsl:message select="tokenize(base-uri(.), '/')[last()]"/>-->
                <xsl:result-document href="{$pageXML-out}/new-{tokenize(base-uri(.),'/')[last()]}">
                    <xsl:apply-templates select="." mode="transform"/>
                </xsl:result-document>
            </xsl:for-each>
    </xsl:template>

    <!-- group by Main/Commentary and assign line type -->
    <xsl:template match="PcGts:lines" mode="split">
        <xsl:variable name="splitLines" as="element()+">
            <xsl:apply-templates select="PcGts:l" mode="split"/>
        </xsl:variable>
        <!--<xsl:copy-of select="$splitLines[self::PcGts:l]"/>-->
        <xsl:for-each-group select="$splitLines[self::*:l]"
            group-starting-with="self::*:l[matches(@type, '(Main|Commentary|Title)')]">
            <xsl:variable name="type" select="current-group()[1]/@type"/>
            <!--<xsl:message select="$type"></xsl:message>-->
            <xsl:for-each select="current-group()">
                <l>
                    <xsl:copy-of select="@*"/>
                    <xsl:copy-of select="
                            if (not(@type)) then
                                $type
                            else
                                ()"/>
                    <xsl:copy-of select="node()"/>
                </l>
            </xsl:for-each>
        </xsl:for-each-group>

    </xsl:template>


    <!-- split constructed lines on start, end  and also label -->
    <xsl:template match="PcGts:l" mode="split">
        <xsl:variable name="curr" select="."/>
        <xsl:variable name="nAttr" select="@n"/>
        <xsl:variable name="cLen" select="string-length(normalize-space(.))"/>
        <xsl:choose>
            <xsl:when test="PcGts:Start | PcGts:End">
                <xsl:for-each-group select="node()" group-starting-with="PcGts:Start | PcGts:End">
                    <xsl:variable 
                        name="startOffset" 
                        select="1 + string-length(normalize-space(string-join(current-group()[1][self::PcGts:Start | self::PcGts:End]/preceding-sibling::text())))"/>
                    <xsl:variable name="cLenSeg" 
                        select="string-length(normalize-space(string-join(current-group())))"/>
                    <!--<xsl:message select="string-length(normalize-space(string-join(current-group())))"></xsl:message>-->
                    <xsl:if test="not(normalize-space(string-join(current-group())) = (''))">
                        <l n="{$nAttr}" 
                        cLenSeg="{$cLenSeg}" 
                        cLen="{$cLen}" 
                        ratioPrec="{round($startOffset div $cLen * 1000) div 1000}"
                        ratioThis="{round($cLenSeg div $cLen * 1000) div 1000}">
                        <xsl:if test="current-group()[1][self::PcGts:Start | self::PcGts:End]">
                            <xsl:attribute name="type" select="
                                    if (current-group()[1][self::PcGts:Start])
                                    then
                                        'Main'
                                    else
                                        if (current-group()[1][self::PcGts:End])
                                        then
                                            'Commentary'
                                        else
                                            'Dunno'"/>
                        </xsl:if>
                        <xsl:copy-of
                            select="current-group()[not(self::PcGts:Start | self::PcGts:End)]"/>
                    </l></xsl:if>
                </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- transform, update page xml -->
    <xsl:template match="@* | node()" mode="transform">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="transform"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*:TextLine" mode="transform">
        <xsl:variable name="curr" select="."/>
        <xsl:variable name="lineID" select="@id/string()"/>
        <xsl:choose>
            <xsl:when test="count($linesSplitAndTyped/*/key('line',$lineID)) eq 0">
                <!-- retain lines that do not appear on the lookup table. -->
                <xsl:copy-of select="."></xsl:copy-of>
            </xsl:when>
            <xsl:when test="count($linesSplitAndTyped/*/key('line',$lineID)) eq 1">
                <!-- copy singleton lines -->
                <TextLine 
                    id="{@id}"
                    custom="structure {{type:{$linesSplitAndTyped/*/key('line',$lineID)/@type};}}">
                    <!--<xsl:message select="(@id/string(),$linesSplitAndTyped/*/key('line',$lineID)/@type/string())"></xsl:message>-->
                    <xsl:apply-templates mode="transform"/>
                </TextLine>
            </xsl:when>
            <xsl:otherwise>
                <!-- split and process line segments -->
                <xsl:variable name="baseLine" select="local:defineLine($curr/PcGts:Baseline/@points)" as="item()+"/>
                <xsl:variable name="segsToProcess" select="$linesSplitAndTyped/*/key('line',$lineID)[@cLenSeg &gt; 0]"/>
                <xsl:for-each select="$segsToProcess">
                    <xsl:variable name="segPts" select="local:lineSeg(.,$baseLine)"  as="item()+"></xsl:variable>
                    <xsl:variable name="box" select="local:defineBox($curr/PcGts:Coords/@points)"/>
                    <!--<xsl:copy-of select="."></xsl:copy-of>
                    <baseLine><xsl:copy-of select="$baseLine"></xsl:copy-of></baseLine>
                    <box><xsl:copy-of select="$box"></xsl:copy-of></box>-->
                    <TextLine custom="structure {{type:{@type};}}" id="{concat(@n,'_',position())}">
                        <Coords
                            points="{$segPts[3]},{$box[self::PcGts:minY]} {$segPts[1]},{$box[self::PcGts:minY]} {$segPts[1]},{$box[self::PcGts:maxY]} {$segPts[3]},{$box[self::PcGts:maxY]}"/>
                        <Baseline points="{$segPts[3]},{$segPts[4]} {$segPts[1]},{$segPts[2]}"/>
                        <TextEquiv>
                            <Unicode><xsl:value-of select="normalize-space(.)"/></Unicode>
                        </TextEquiv>
                    </TextLine>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        
        <!--<TextLine>
            <xsl:copy-of select="@*"> </xsl:copy-of>
            <xsl:apply-templates mode="transform"/>
        </TextLine>-->
    </xsl:template>

    <xsl:template match="PcGts:Unicode" mode="transform">
        <xsl:variable name="lineId" select="ancestor::PcGts:TextLine/@id/string()"/>
        <xsl:choose>
            <xsl:when test="key('line', $lineId, $linesSplitAndTyped)">
                <Unicode>
                    <xsl:copy-of select="key('line', ancestor::PcGts:TextLine/@id, $linesSplitAndTyped)/node()"/>
                </Unicode>
            </xsl:when>
            <xsl:otherwise>
                <Unicode/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="local:defineLine" as="item()*">
        <xsl:param name="in"/>
        <xsl:variable name="indivPts" select="tokenize($in,'\s+')"/>
        <xsl:variable 
            name="X" 
            select="for $p in $indivPts return xs:integer(tokenize(normalize-space($p),',')[1])"/>
        <xsl:variable 
            name="Y" 
            select="for $p in $indivPts return xs:integer(tokenize(normalize-space($p),',')[2])"/>
        <!-- because page layed out right to left, firstX is rightmost -->
        <rightX><xsl:value-of select="$X[last()]"/></rightX>
        <leftX><xsl:value-of select="$X[1]"/></leftX>
        <atRightY><xsl:value-of select="$Y[last()]"/></atRightY>
        <atLeftY><xsl:value-of select="$Y[1]"/></atLeftY>
        <horiz><xsl:value-of select="$X[1] - $X[last()]"/></horiz>
        <vert><xsl:value-of select="$Y[1] - $Y[last()]"/></vert>
        <slope><xsl:value-of select="($Y[1] - $Y[last()]) div ($X[1] - $X[last()])"/></slope>
    </xsl:function>
    <xsl:function name="local:lineSeg">
        <xsl:param name="in" as="element()"></xsl:param>
        <xsl:param name="baseLine"></xsl:param>
        <!-- len of whole line -->
        <xsl:variable name="L"
            select="math:sqrt(math:pow(xs:integer($baseLine[self::PcGts:horiz]), 2) + math:pow(xs:integer($baseLine[self::PcGts:vert]), 2))"/>
        <xsl:variable 
            name="xLeft" 
            select="$baseLine[self::PcGts:rightX] - round($L * ($in/@ratioThis + $in/@ratioPrec))"/>
        <xsl:variable 
            name="yAtLeft" 
            select="round ($baseLine[self::PcGts:slope] * ($xLeft - $baseLine[self::PcGts:rightX])) + $baseLine[self::PcGts:atRightY]"/>
        <xsl:variable 
            name="xRight" 
            select="$baseLine[self::PcGts:rightX] - round($L * $in/@ratioPrec)"/>
        <xsl:variable 
            name="yAtRight" 
            select="round ($baseLine[self::PcGts:slope] * ($xRight - $baseLine[self::PcGts:rightX])) + $baseLine[self::PcGts:atRightY]"/>
        <!--<xRight><xsl:value-of select="$xRight"/></xRight>
        <yAtRight><xsl:value-of select="$yAtRight"/></yAtRight>
        <xLeft><xsl:value-of select="$xLeft"/></xLeft>
        <yatLeft><xsl:value-of select="$yAtLeft"/></yatLeft>-->
        <xsl:sequence select="($xRight, $yAtRight, $xLeft, $yAtLeft)"/>
    </xsl:function>
    <xsl:function name="local:defineBox" as="item()*">
        <xsl:param name="in"></xsl:param>
        <xsl:variable name="indivPts" select="tokenize($in,'\s+')"/>
        <xsl:variable name="X" select="for $p in $indivPts return xs:integer(tokenize(normalize-space($p),',')[1])"/>
        <xsl:variable name="Y" select="for $p in $indivPts return xs:integer(tokenize(normalize-space($p),',')[2])"/>
        <minX><xsl:value-of select="min($X)"/></minX>
        <maxX><xsl:value-of select="max($X)"/></maxX>
        <minY><xsl:value-of select="min($Y)"/></minY>
        <maxY><xsl:value-of select="max($Y)"/></maxY>
        
    </xsl:function>
    
    <!--<xsl:function name="local:level-attribute">
        <xsl:param name="in"/>
        <xsl:choose>
            <xsl:when test="count(tokenize($in, '\.')) eq 1">
                <xsl:text>div1</xsl:text>
            </xsl:when>
            <xsl:when test="count(tokenize($in, '\.')) eq 2">
                <xsl:text>div2</xsl:text>
            </xsl:when>
            <xsl:when test="count(tokenize($in, '\.')) eq 3">
                <xsl:text>div3</xsl:text>
            </xsl:when>
            <xsl:when test="count(tokenize($in, '\.')) eq 4">
                <xsl:text>ab</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:function>-->
</xsl:stylesheet>
