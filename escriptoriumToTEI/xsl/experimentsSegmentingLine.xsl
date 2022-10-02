<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:local="local.functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <!--<xsl:variable name="boxPts" select="'220,2630 233,2596 323,2613 527,2596 607,2610 710,2606 727,2590 793,2600 843,2583 883,2600 900,2586 924,2603 947,2590 977,2603 1107,2603 1130,2590 1140,2600 1164,2576 1194,2593 1260,2576 1330,2600 1367,2583 1511,2596 1531,2580 1574,2586 1601,2570 1637,2583 1687,2570 1707,2586 1777,2586 1797,2573 1848,2590 1891,2573 1924,2590 2001,2590 2028,2566 2074,2583 2091,2570 2134,2580 2154,2563 2228,2560 2231,2600 2231,2640 2171,2670 2104,2670 2041,2643 2004,2673 1834,2673 1811,2656 1751,2670 1734,2653 1717,2663 1697,2646 1637,2646 1624,2660 1591,2650 1557,2680 1431,2650 1391,2680 1361,2663 1330,2683 1280,2683 1247,2656 1197,2680 1114,2660 1074,2670 1060,2656 967,2656 927,2670 890,2656 857,2690 793,2676 780,2690 753,2673 723,2686 707,2670 660,2676 633,2663 593,2693 527,2693 500,2673 453,2670 406,2696 383,2676 336,2683 300,2666 270,2696 220,2696'"/>
    <xsl:variable name="pts" select="'221,2630 2234,2600'"/>-->
    <xsl:variable name="splitLines" as="element()+">
        <l n="eSc_line_8050f5bb"
            cLenSeg="45"
            cLen="68"
            ratioPrec="0.015"
            ratioThis="0.662"
            type="Commentary">מן קולה כיהון ובגדי שרת וכו וכדא בין אלהלמוד: </l>
        <l n="eSc_line_8050f5bb"
            cLenSeg="22"
            cLen="68"
            ratioPrec="0.676"
            ratioThis="0.324"
            type="Main">בריך רחמנא רסייע בהרן: </l>
        <l n="eSc_line_68d521f6" type="Commentary"/>
    </xsl:variable>
    <xsl:variable name="origLine" as="element()">
        <TextLine id="eSc_line_8050f5bb" >
            <Coords points="220,2630 233,2596 323,2613 527,2596 607,2610 710,2606 727,2590 793,2600 843,2583 883,2600 900,2586 924,2603 947,2590 977,2603 1107,2603 1130,2590 1140,2600 1164,2576 1194,2593 1260,2576 1330,2600 1367,2583 1511,2596 1531,2580 1574,2586 1601,2570 1637,2583 1687,2570 1707,2586 1777,2586 1797,2573 1848,2590 1891,2573 1924,2590 2001,2590 2028,2566 2074,2583 2091,2570 2134,2580 2154,2563 2228,2560 2231,2600 2231,2640 2171,2670 2104,2670 2041,2643 2004,2673 1834,2673 1811,2656 1751,2670 1734,2653 1717,2663 1697,2646 1637,2646 1624,2660 1591,2650 1557,2680 1431,2650 1391,2680 1361,2663 1330,2683 1280,2683 1247,2656 1197,2680 1114,2660 1074,2670 1060,2656 967,2656 927,2670 890,2656 857,2690 793,2676 780,2690 753,2673 723,2686 707,2670 660,2676 633,2663 593,2693 527,2693 500,2673 453,2670 406,2696 383,2676 336,2683 300,2666 270,2696 220,2696"/>
            <Baseline points="221,2630 2234,2600"/>
            <TextEquiv>
                <Unicode>מן קולה כיהון ובגדי שרת וכו וכדא בין אלהלמוד: בריך רחמנא רסייע בהרן:</Unicode>
            </TextEquiv>
        </TextLine>
    </xsl:variable> 
    <xsl:template name="start">
        <out>
            <xsl:variable name="baseLine" select="local:defineLine($origLine//*:Baseline/@points)"/>
            <!--<xsl:copy-of select="$baseLine"></xsl:copy-of>-->
            <xsl:for-each select="$splitLines[@cLenSeg &gt; 0]">
                <!--<xsl:copy-of select="."/>-->
                <xsl:variable name="segPts" select="local:lineSeg(.,$baseLine)"  as="item()+"></xsl:variable>
                <xsl:variable name="box" select="local:defineBox($origLine//*:Coords/@points)"/>
                
                <TextLine custom="structure {{type:{@type}}}">
                    <Coords
                        points="{$segPts[1]},{$box[self::minY]} {$segPts[3]},{$box[self::minY]} {$segPts[3]},{$box[self::maxY]} {$segPts[1]},{$box[self::maxY]}"/>
                    <Baseline points="{$segPts[1]},{$segPts[2]} {$segPts[3]},{$segPts[4]}"/>
                    <TextEquiv>
                        <Unicode><xsl:value-of select="normalize-space(.)"/></Unicode>
                    </TextEquiv>
                </TextLine>
            </xsl:for-each>
        </out>
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
        <!-- minX,minY maxY,minY maxY,maxY -->
        <firstX><xsl:value-of select="$X[1]"/></firstX>
        <lastX><xsl:value-of select="$X[last()]"/></lastX>
        <firstY><xsl:value-of select="$Y[1]"/></firstY>
        <lastY><xsl:value-of select="$Y[last()]"/></lastY>
        <horiz><xsl:value-of select="$X[last()] - $X[1]"/></horiz>
        <vert><xsl:value-of select="$Y[last()] - $Y[1]"/></vert>
        <slope><xsl:value-of select="($Y[last()] - $Y[1]) div ($X[last()] - $X[1])"/></slope>
    </xsl:function>
    <xsl:function name="local:lineSeg">
        <xsl:param name="in" as="element()"></xsl:param>
        <xsl:param name="baseLine"></xsl:param>
        <xsl:message select="$baseLine"></xsl:message>
        <!-- len of whole line -->
        <xsl:variable name="L"
            select="math:sqrt(math:pow(xs:integer($baseLine[self::horiz]), 2) + math:pow(xs:integer($baseLine[self::vert]), 2))"/>
        <!-- y2 = m(x2-x1) + y1 -->
        <!-- x2 = x1 + (y2-y1)/m -->
        <xsl:variable name="xStart" select="$baseLine[self::firstX] + round($L * $in/@ratioPrec)"/>
        <xsl:variable name="yStart"
            select="round($baseLine[self::firstY] + $baseLine[self::slope] * ($xStart - $baseLine[self::firstX]))"/>
        <xsl:variable name="xEnd" select="$baseLine[self::firstX] + round($L * ($in/@ratioThis + $in/@ratioPrec))"/>
        <xsl:variable name="yEnd"
            select="round($yStart + $baseLine[self::slope] * ($xEnd - $xStart))"/>
        <xsl:sequence select="($xStart,$yStart,$xEnd,$yEnd)"></xsl:sequence>
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


</xsl:stylesheet>