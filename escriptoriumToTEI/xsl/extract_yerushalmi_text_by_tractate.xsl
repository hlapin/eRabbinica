<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization"
    xmlns="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs xi tei" version="3.1">
    <xsl:output method="json" indent="yes" omit-xml-declaration="1"/>
    <xsl:param name="outname" select="'qafah_03'"/>
    <!--<xsl:param name="out_mode" select="'plainText'"/>-->
    <xsl:param name="out_mode" select="'collatex'"/>

    <!-- TO DO: Implement chunking by chapter and/or folio -->
    <xsl:param name="chunkBy" select="'tractate'"/>
    <!--<xsl:param name="chunkBy" select="'chapter'"/>-->
    <!--<xsl:param name="chunkBy" select="'folio'"/>-->

    <xsl:template match="/">
        <!-- create sequence of lines and column/page breaks, etc.-->
        <xsl:variable name="lines">
            <xsl:variable name="divs" select="//tei:div/*"/>
            <xsl:copy-of
                select="$divs/(self::tei:pb | self::tei:cb | self::tei:ab[not(@type = 'Paratext')]/tei:l)"
            />
        </xsl:variable>
        <!-- group output by tractate/chapter -->
        <!--<out>-->
        <xsl:for-each-group select="$lines/*"
            group-starting-with="tei:l[tei:milestone[@unit = 'div1']]">
            <!-- we are grabbing by orders to exclude prologues later on -->
            <xsl:if test="current-group()[1]/self::tei:l[tei:milestone[@unit = 'div1']]">
                <!--<xsl:copy-of select="current-group()[1]"></xsl:copy-of>-->
                
                <xsl:for-each-group select="current-group()"
                    group-starting-with="tei:l[tei:milestone[@unit = 'div2']]">
                    <xsl:choose>
                        <xsl:when test="current-group()[1][tei:milestone[@unit = 'div2']]">
                            <xsl:choose>
                                <xsl:when test="$out_mode = 'collatex'">
                                    <xsl:call-template name="formatTokensForCollatex">
                                        <xsl:with-param name="in" select="current-group()"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="$out_mode = 'plainText'">
                                    <xsl:call-template name="formatForPlainText">
                                        <xsl:with-param name="in" select="current-group()"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:if>
        </xsl:for-each-group>
        <!--</out>-->
    </xsl:template>

    <xsl:template name="formatForPlainText">
        <xsl:param name="in"/>
        <xsl:variable name="tract" select="$in/tei:milestone[@unit = 'div2']/@n"/>
        <xsl:message select="string($tract)"/>
        <xsl:variable name="pre-text">
            <xsl:value-of
                select="string-join(($outname, $in[1]/preceding-sibling::tei:pb[1]/@n, $in[1]/preceding-sibling::tei:cb[1]/@n), '&#xa;')"/>
            <xsl:value-of select="'&#xa;'"/>
            <xsl:for-each-group select="$in"
                group-starting-with="tei:l[tei:milestone[@unit = 'div3']]">
                <xsl:choose>
                    <xsl:when
                        test="current-group()[1][tei:milestone[@unit = 'div3' and @type = 'M']]">
                        <!-- skip mishnah -->
                    </xsl:when>
                    <xsl:when
                        test="current-group()[1][tei:milestone[@unit = 'div3' and @type = 'yT']]">
                        <xsl:message
                            select="string(current-group()[1]/tei:milestone[@unit = 'div3']/@n)"/>
                        <!--<xsl:apply-templates select="current-group()" mode="plainText"/>-->
                        <xsl:apply-templates select="current-group()" mode="collatex"/>
                    </xsl:when>
                    <xsl:otherwise><!-- for errors and debugging --></xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:result-document
            href="{concat('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xsl/yWorkingtext/',$tract,'.yVenEsc.txt')}"
            encoding="UTF-8" indent="yes" method="text">
            <xsl:value-of select="$pre-text/node()"/>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="formatTokensForCollatex">
        <xsl:param name="in"/>
        <xsl:variable name="tract" select="$in/tei:milestone[@unit = 'div2']/@n"> </xsl:variable>
        <xsl:message select="string($tract)"/>
        <xsl:variable name="pre-json">
            <map>
                <string key="id">
                    <xsl:value-of select="concat('y_',$tract, '.', $outname)"/>
                </string>
                <array key="tokens">
                    <map>
                        <string key="id">
                            <xsl:value-of select="$in[1]/preceding-sibling::tei:cb[1]/@xml:id"/>
                        </string>
                        <string key="t">
                            <xsl:value-of select="$in[1]/preceding-sibling::tei:cb[1]/@n"/>
                        </string>
                    </map>
                    
                    <xsl:for-each-group select="$in"
                        group-starting-with="tei:l[tei:milestone[@unit = 'div3']]">
                        <xsl:choose>
                            <xsl:when
                                test="current-group()[1][tei:milestone[@unit = 'div3' and @type = 'M']]">
                                <!-- skip mishnah -->
                            </xsl:when>
                            <xsl:when
                                test="current-group()[1][tei:milestone[@unit = 'div3' and @type = 'yT']]">
                                <xsl:message
                                    select="string(current-group()[1]/tei:milestone[@unit = 'div3']/@n)"/>

                                <xsl:apply-templates select="current-group()" mode="collatex"/>

                            </xsl:when>
                            <xsl:otherwise><!-- for errors and debugging --></xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each-group>
                    <!--</array>-->
                </array>
            </map>
            <!--</array>-->

        </xsl:variable>
        <xsl:result-document
            href="{concat('file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xsl/yWorkingtext/',$tract,'.yVenEsc.json')}"
            encoding="UTF-8" indent="yes" method="text">
            <xsl:sequence select="xml-to-json($pre-json/*)"/>
        </xsl:result-document>

    </xsl:template>

    <xsl:template match="tei:l" mode="collatex">
        <xsl:variable name="pref" select="
                if (substring-after(@corresp, 'Page_')) then
                    (substring-after(@corresp, 'Page_'))
                else
                    @corresp"/>
        <map>
            <string key="id">
                <xsl:value-of select="concat('y_',$pref)"/>
            </string>
            <string key="t">
                <xsl:value-of select="$pref"/>
            </string>
        </map>
        <xsl:variable name="tokens" as="element()*">
            <xsl:call-template name="tokens_with_elements">
                <xsl:with-param name="line" select=".//node()"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="$tokens/node()">
            <xsl:choose>
                <xsl:when test="self::*:w">
                    <map>
                        <string key="id">
                            <xsl:value-of select="concat('y_', $pref,'_', count(preceding-sibling::*:w)+1)"/>
                        </string>
                        <string key="t">
                            <xsl:value-of select="."/>
                        </string>
                    </map>
                </xsl:when>
                <xsl:when test="self::*:milestone[@unit='div3']">
                    <map xmlns="http://www.w3.org/2005/xpath-functions">
                        <string key="id"><xsl:value-of select="concat('y_',@n)"/></string>
                        <string key="t"><xsl:value-of select="replace(@n,'\d\.\d+(\.(\d+))?','Chapter_$2_Halakhah_0')"/></string>
                    </map>
                </xsl:when>
                <xsl:when test="self::*:milestone[@unit='div2']">
                    <map xmlns="http://www.w3.org/2005/xpath-functions">
                        <string key="id"><xsl:value-of select="concat('y_',@n)"/></string>
                        <string key="t"><xsl:value-of select="replace(@n,'^(\d\.\d+)(\.\d+)*','Tractate_$1')"/></string>
                    </map>
                </xsl:when>
                <xsl:when test="self::*:milestone[@unit='div1']">
                    <map xmlns="http://www.w3.org/2005/xpath-functions">
                        <string key="id"><xsl:value-of select="concat('y_',@n)"/></string>
                        <string key="t"><xsl:value-of select="replace(@n,'(\d)(\.\d+)*','Order_$1')"/></string>
                    </map>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

</xsl:template>
    
    <xsl:template name="tokens_with_elements">
        <xsl:param name="line" as="node()*"/>
        <tokens><xsl:for-each select="$line">
            <!--<seg><xsl:copy-of select="."></xsl:copy-of></seg>-->
            <xsl:choose>
                <xsl:when test="self::text()">
                    <xsl:analyze-string select="." regex="\s+">
                        <xsl:matching-substring>
                            
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <w><xsl:value-of select="."/></w>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:when test="self::element()">
                    <xsl:copy-of select="."></xsl:copy-of>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        </tokens>
    </xsl:template>

    <xsl:template match="tei:pb" mode="collatex">
        <!-- use only one token to mark page/column break -->
        <!-- do nothing here -->
    </xsl:template>
    <xsl:template match="tei:cb" mode="collatex">
        <map>
            <string key="id">
                <xsl:value-of select="@xml:id"/>
            </string>
            <string key="t">
                <xsl:value-of select="@n"/>
            </string>
        </map>
    </xsl:template>

    <xsl:template match="tei:l" mode="plainText">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:value-of select="'&#xa;'"/>
    </xsl:template>

    <xsl:template match="tei:pb | tei:cb" mode="plainText">
        <xsl:value-of select="@n"/>
        <xsl:value-of select="'&#xa;'"/>
    </xsl:template>

</xsl:stylesheet>
