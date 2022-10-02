<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="local.functions.uri"
    exclude-result-prefixes="xs local tei" version="3.0">
    <xsl:output indent="yes"/>

    <!-- called from template[@name = 'lines'], with $rows corresponding to rows extract  -->
    <!-- $target, $compare refer to columns of dicta output-->
    <!-- $target is the witness to which we wish to transfer canonical milestones. -->
    <!-- $compare is a canonically divided "default" text typically vilna -->
    

    <xsl:param name="line_match_pattern" select="'default'"/>
    <xsl:param name="div_match_pattern" select="'default'"/>
    <xsl:param name="ref_match_pattern" select="'default'"/>
    <xsl:param name="col_match_pattern" select="'default'"></xsl:param>
    <xsl:param name="target" select="'default'"/>
    <xsl:param name="compare1" select="'default'"/>
    <xsl:param name="compare2" select="'default'"/>

    <xsl:variable name="abbrs" select="doc('biblRabbValues.xml')"/>
    
    <xsl:template name="lines">
        <xsl:param name="rows"/>
        <xsl:variable name="target_name" select="$rows/*[1]/*[ends-with(name(), $target)]/name()"/>
        <xsl:variable name="compare_1_name"
            select="$rows/*[1]/*[ends-with(name(), $compare1)]/name()"/>
        <xsl:variable name="compare_2_name"
            select="$rows/*[1]/*[ends-with(name(), $compare2)]/name()"/>
        <xsl:variable name="aligned-lines">
            <xsl:for-each select="$rows">
                <xsl:apply-templates>
                    <xsl:with-param name="target_name" select="$target_name" tunnel="yes"/>
                    <xsl:with-param name="compare_1_name" select="$compare_1_name" tunnel="yes"/>
                    <xsl:with-param name="compare_2_name" select="$compare_2_name" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </xsl:variable>
        <xsl:call-template name="construct-lines">
            <xsl:with-param name="lines-in" select="$aligned-lines"></xsl:with-param>
            <xsl:with-param name="nodes_to_text" select="$target_name"></xsl:with-param>
        </xsl:call-template>
        <!--<xsl:copy-of select="$aligned-lines"></xsl:copy-of>-->
        
    </xsl:template>

    <xsl:template match="local:row">
        <xsl:variable name="target_token" select="*[ends-with(local-name(), $target)]"/>
        <xsl:variable name="target_name" select="$target_token/name()"/>
        <xsl:variable name="compare_1_token" select="*[ends-with(local-name(), $compare1)]"/>
        <xsl:variable name="compare_1_name" select="$compare_1_token/name()"/>
        <xsl:variable name="compare_2_token" select="*[ends-with(local-name(), $compare2)]"/>
        <xsl:variable name="compare_2_name" select="$compare_2_token/name()"/>
        <xsl:variable name="target_txt" select="normalize-space($target_token)"/>
        <xsl:variable name="has_div" select="matches($compare_2_token, $div_match_pattern)"/>
        <xsl:variable name="has_ref" select="matches($compare_1_token, $ref_match_pattern)"/>
        <xsl:choose>
            <xsl:when test="
                    not($target_txt) and
                    ($has_ref and $has_div)">
                <!-- target is blank, there are both both milestone and ref-->
                <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                <xsl:copy-of
                    select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                />
            </xsl:when>
            <xsl:when test="
                not($target_txt) and
                $has_div">
                <!-- target is blank, there are is milestone -->
                <xsl:copy-of
                    select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                />
            </xsl:when>
            <xsl:when test="
                not($target_txt) and
                $has_ref">
                <!-- target is blank, there is ref-->
                <xsl:copy-of
                    select="local:ref_attr($compare_1_token/text())"/>
            </xsl:when>
            <xsl:when test="matches($target_txt, $line_match_pattern)">
                <!-- target is a line break -->
                <xsl:if test="matches(normalize-space($compare_1_token),$ref_match_pattern)">
                    <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                </xsl:if>
                <lb xmlns="http://www.tei-c.org/ns/1.0" n="{$target_token/text()}"></lb>
                <xsl:if test="matches(normalize-space($compare_2_token),$div_match_pattern)">
                    <xsl:value-of
                        select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                    />
                </xsl:if>
            </xsl:when>
            <xsl:when test="matches($target_txt,$div_match_pattern)">
                <!-- why does $div_match_pattern not match? -->
                <!-- chapter divisions are lined up -->
                <!-- insert after the other. -->
                <xsl:variable name="tract_no" 
                    select="string-join((tokenize($target_token/name(),'[\D]+')[position() &gt; 1]),'.')"
                />
                <xsl:if test="matches(normalize-space($compare_1_token),$ref_match_pattern)">
                    <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                </xsl:if>
                <!--<milestone xmlns="http://www.tei-c.org/ns/1.0" 
                    unit="div3"
                    n="{$tract_no}{tokenize($target_token,'_')[2]}"/>-->
                <xsl:copy-of select="local:div-level($tract_no,$target_token)"></xsl:copy-of>
                <xsl:if test="matches(normalize-space($compare_2_token),$div_match_pattern)">
                    <xsl:copy-of
                        select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                    />
                </xsl:if>
                
            </xsl:when>
            <!-- to do: matches column pattern [IV]{1,2}_\d+[rv][ABCD] -->
            <xsl:when test="matches($target_token,$col_match_pattern)">
                <xsl:if test="matches(normalize-space($compare_1_token),$ref_match_pattern)">
                    <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                </xsl:if>
                <!--<xsl:copy-of select="$target_token"/>-->
                <!-- just skip? -->
                <xsl:if test="matches(normalize-space($compare_2_token),$div_match_pattern)">
                    <xsl:copy-of
                        select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                    />
                </xsl:if>
            </xsl:when>
            <xsl:when test="normalize-space($target_token)">
                <!-- any case where there is text in target, insert any refs before, milestones after -->
                <xsl:if test="matches(normalize-space($compare_1_token),$ref_match_pattern)">
                    <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                </xsl:if>
                <xsl:copy-of select="$target_token"/>
                <xsl:if test="matches(normalize-space($compare_2_token),$div_match_pattern)">
                    <xsl:copy-of
                        select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                    />
                </xsl:if>
            </xsl:when>
            
            <xsl:otherwise>
                <!-- any remaining cases? -->
                <xsl:if test="matches(normalize-space($compare_1_token),$ref_match_pattern)">
                    <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                </xsl:if>
                <xsl:copy-of select="$target_token"/>
                <xsl:if test="matches(normalize-space($compare_2_token),$div_match_pattern)">
                    <xsl:copy-of
                        select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                    />
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
    <xsl:template name="construct-lines">
        <xsl:param name="lines-in"></xsl:param>
        <xsl:param name="nodes_to_text"></xsl:param>
        <xsl:for-each-group select="$lines-in/*" group-starting-with="tei:lb">
            <l xmlns="http://www.tei-c.org/ns/1.0" n="{current-group()[1]/@n}">
                <xsl:for-each-group select="current-group()[position() &gt; 1]" group-adjacent="local-name()">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key() eq $nodes_to_text">
                            <xsl:value-of select="normalize-space(string-join((current-group()),' '))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="current-group()"></xsl:copy-of>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </l>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:function name="local:ref_attr">
        <xsl:param name="in"/>
        <xsl:variable name="gematria" select="$abbrs//*:gematria/*"/>
        <xsl:variable name="tracts" select="$abbrs//*:rabbinic/*"/>
        <xsl:variable name="namesNumbers" select="$abbrs//*:tractNameNum/*"/>

        <xsl:variable name="tract">
            <xsl:variable name="name" select="tokenize($in, '_')[2]"/>
            <xsl:value-of select="$namesNumbers[@name eq $tracts[@k eq $name]/@v]/@k"/>
        </xsl:variable>

        <xsl:variable name="ch">
            <xsl:variable name="num" select="string-to-codepoints(tokenize($in, '_')[3])"/>
            <!--<xsl:value-of select="sum(for $c in codepoints-to-string($num) return $gematria[@k eq $c]/@v)"/>-->
            <xsl:value-of select="sum(for $c in $num return $gematria[@k eq codepoints-to-string($c)]/@v)"/>
        </xsl:variable>
        
        <xsl:variable name="m">
            <xsl:variable name="num" select="string-to-codepoints(tokenize($in, '_')[4])"/>
            <xsl:value-of select="sum(for $c in $num return $gematria[@k eq codepoints-to-string($c)]/@v)"/>
        </xsl:variable>
        
        <ref xmlns="http://www.tei-c.org/ns/1.0"><xsl:value-of select="string-join(('convert-to-cts:m',$tract,$ch,$m),'.')"/></ref>


    </xsl:function>

    <xsl:function name="local:div-level">
        <xsl:param name="tract_no"/>
        <xsl:param name="in"/>
        <xsl:variable name="fix_tract_no" select="string-join((tokenize($tract_no,'\.')[position() &lt; 3]),'.')"/>
        <xsl:variable name="segs" select="tokenize($in,'\D+')[position() &gt; 1]"/>
        <!--<xsl:copy-of select="$in"></xsl:copy-of>-->
        <xsl:choose>
            <xsl:when test="matches($in,'Halakhah_0$')">
                <milestone 
                    xmlns="http://www.tei-c.org/ns/1.0" 
                    unit="div3" 
                    n="{string-join(($fix_tract_no,$segs[position() &lt; count($segs)]),'.')}"/>
            </xsl:when>
            <xsl:when test="matches($in,'Halakhah_\d+_1$')">
                <milestone 
                    xmlns="http://www.tei-c.org/ns/1.0"
                    unit="ab" 
                    n="{string-join(($fix_tract_no,$segs[position() &lt; 3]),'.')}"/>
                <milestone 
                    xmlns="http://www.tei-c.org/ns/1.0"
                    unit="segment" 
                    n="{string-join(($fix_tract_no,$segs),'.')}"/>
            </xsl:when>
            <xsl:otherwise>
                <milestone 
                    xmlns="http://www.tei-c.org/ns/1.0"  
                    unit="segment" 
                    n="{string-join(($fix_tract_no,$segs),'.')}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
