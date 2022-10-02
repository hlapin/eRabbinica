<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="local.functions.uri"
    exclude-result-prefixes="xs local tei" version="3.0">

    <!-- called from template[@name = 'lines'], with $rows corresponding to rows extract  -->
    <!-- $target, $compare refer to columns of dicta output-->
    <!-- $target is the witness to which we wish to transfer canonical milestones. -->
    <!-- $compare is a canonically divided "default" text typically vilna -->a

    <xsl:param name="line_match_pattern" select="'default'"/>
    <xsl:param name="div_match_pattern" select="'default'"/>
    <xsl:param name="ref_match_pattern" select="'default'"/>
    <xsl:param name="target" select="'default'"/>
    <xsl:param name="compare1" select="'default'"/>
    <xsl:param name="compare2" select="'default'"/>

    <xsl:variable name="abbrs" select="doc('biblRabbValues.xml')"/>


    <xsl:template name="lines">
        <xsl:param name="rows" tunnel="yes"/>
        <xsl:variable name="target_name" select="$rows/*[1]/*[starts-with(name(), $target)]/name()"/>
        <xsl:variable name="compare_1_name"
            select="$rows/*[1]/*[starts-with(name(), $compare1)]/name()"/>
        <xsl:variable name="compare_2_name"
            select="$rows/*[1]/*[starts-with(name(), $compare2)]/name()"/>
        <xsl:variable name="lines">

            <xsl:for-each select="$rows">
                <xsl:apply-templates>
                    <xsl:with-param name="target_name" select="$target_name" tunnel="yes"/>
                    <xsl:with-param name="compare_1_name" select="$compare_1_name" tunnel="yes"/>
                    <xsl:with-param name="compare_2_name" select="$compare_2_name" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$lines"/>




        <!--<xsl:variable name="lines" as="element()+">
            <xsl:for-each-group select="$rows"
            group-starting-with=".[element()[local-name() eq $target_name][matches(normalize-space(.), $line_match_pattern)]]">
            <!-\- to deal with errors where token attached to milestone, break up token-\->
            <!-\- check if element()[local-name() eq $target_name] has milestone to keep -\->
            <xsl:variable name="regex-parts" select="(
                    (: replace(current-group()[1]/*[local-name() eq $target_name],'^(.*)(l\-\w+)(\W*)','$1'),:)
                    replace(current-group()[1]/*[local-name() eq $target_name], '^(.*)(l\-\w+)(\W*)', '$2'),
                    replace(current-group()[1]/*[local-name() eq $target_name], '^(.*)(l\-\w+)(\W*)', '$3')
                    )"> </xsl:variable>
            <xsl:variable name="target_token" select="$regex-parts[2]"/>
            <xsl:variable name="compare_token" select="element()[local-name() eq $compare_1_name]"/>

            <xsl:if test="starts-with(current-group()[1]/*[name() eq $target_name], 'l-')">
                <!-\- Only keep group if first item starts with a target line break -\->
                <!-\- In theory only row >= 1; are there others?  -\->

                <l xmlns="http://www.tei-c.org/ns/1.0"
                    n="eSc_line_{substring-after(current-group()[1]/*[local-name() eq $target_name],'l-')}">

                    <xsl:if
                        test="not(preceding-sibling::local:row/*[name() eq $target_name][starts-with(., 'l-')])">
                        <xsl:for-each
                            select="preceding-sibling::local:row/*[name() eq $compare_2_name]">
                            <xsl:if test="matches(., '^\d+\.\d+(\.^\d+\.\d+)*')">
                                <milestone 
                                    xmlns="http://www.tei-c.org/ns/1.0"
                                    unit="{local:level-attribute((normalize-space(.)))}"
                                    n="{normalize-space(.)}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>

                    <!-\- if first token of line in target corresponds to a milestone to keep -\->
                    <!-\- insert tei:milestone -\->
                    <xsl:if
                        test="matches(current-group()[1]/*[local-name() eq $compare_1_name], '^\d+\.\d+(\.^\d+\.\d+)*')">
                        <milestone
                            xmlns="http://www.tei-c.org/ns/1.0"
                            unit="{local:level-attribute((normalize-space($compare_token)))}"
                            n="{normalize-space($compare_token)}"/>
                    </xsl:if>

                    <xsl:if test="$regex-parts[2]">
                        <xsl:value-of select="string-join(($regex-parts[2], ' '))"/>
                    </xsl:if>

                    <xsl:apply-templates select="(current-group() except current-group()[1])">
                        <xsl:with-param name="compare_name" select="$compare_1_name" tunnel="yes"/>
                        <xsl:with-param name="target_name" select="$target_name" tunnel="yes"/>
                    </xsl:apply-templates>

                    <!-\- to deal with line, region accidentally merged with text token -\->
                    <xsl:variable name="next_line_token" select="
                            replace(current-group()[last()]/
                            following-sibling::*[1]/*[local-name() eq $target_name], '(.*)(l\-\w+)(\W*)', '$1')"/>
                    <xsl:if test="normalize-space($next_line_token)">
                        <xsl:value-of select="string-join((' ', $next_line_token))"/>
                    </xsl:if>
                </l>
            
            </xsl:if>
        </xsl:for-each-group></xsl:variable>
        <xsl:copy-of select="$lines[*:milestone]"></xsl:copy-of>-->
    </xsl:template>

    <xsl:template match="local:row">
        <!--<xsl:param name="rows" tunnel="yes"></xsl:param>-->
        <xsl:variable name="target_token" select="*[starts-with(local-name(), $target)]"/>
        <xsl:variable name="target_name" select="$target_token/name()"/>
        <xsl:variable name="compare_1_token" select="*[starts-with(local-name(), $compare1)]"/>
        <xsl:variable name="compare_1_name" select="$compare_1_token/name()"/>
        <xsl:variable name="compare_2_token" select="*[starts-with(local-name(), $compare2)]"/>
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
                <xsl:copy-of select="."></xsl:copy-of>
            </xsl:when>
            <xsl:when test="
                not($target_txt) and
                $has_div">
                <!-- target is blank, there is milestone -->
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
                <xsl:if test="normalize-space($compare_1_token)">
                    <xsl:copy-of select="local:ref_attr($compare_1_token/text())"/>
                </xsl:if>
                <xsl:copy-of select="$target_token"/>
                <xsl:if test="normalize-space($compare_2_token)">
                    <xsl:copy-of
                        select="local:div-level(tokenize($target_name, '_')[last()], $compare_2_token)"
                    />
                </xsl:if>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>

    </xsl:template>
    <!--<xsl:template match="*[parent::local:row]">
        <xsl:param name="rows" tunnel="yes"></xsl:param>
        <xsl:variable name="target_token" select="self::*[starts-with(local-name(), $target)]/name()"/>
        <xsl:variable name="compare_1_token" select="self::*[starts-with(local-name(), $compare1)]"/>
        <xsl:variable name="compare_2_token" select="self::*[starts-with(local-name(), $target)]"/>

        <!-\-<xsl:choose>
            <!-\\- target is blank, there both both milestone and ref-\\->
            <xsl:when test="not(normalize-space($target_token)) and 
                (matches($compare_1_token,$ref_match_pattern) and $compare_1_token,$div_match_pattern)">
                <xsl:copy select="parent::*"></xsl:copy>
                
            </xsl:when>
            </xsl:choose>-\->
        <!-\-<xsl:choose>
            <xsl:when test="matches(normalize-space($compare_token), '^\d+\.\d+(\.^\d+\.\d+)*')">
                <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="{local:level-attribute((normalize-space($compare_token)))}"
                    n="{normalize-space($compare_token)}"/>
                <xsl:choose>
                    <xsl:when test="matches(normalize-space($target_token), '^(ab-|r-).*')">
                        <!-\\- skip -\\->
                    </xsl:when>
                    <xsl:when test="normalize-space($target_token)">
                        <xsl:value-of select="$target_token"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="matches(normalize-space($target_token), '^(ab-|r-).*')">
                <!-\\- skip -\\->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="string($target_token)"/>
            </xsl:otherwise>
        </xsl:choose>-\->
    </xsl:template>-->

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
            <xsl:value-of select="sum(for $c in $num return string($gematria[@k eq codepoints-to-string($c)]/@v))"/>
        </xsl:variable>
        
        <xsl:variable name="m">
            <xsl:variable name="num" select="string-to-codepoints(tokenize($in, '_')[4])"/>
            <xsl:value-of select="sum(for $c in codepoints-to-string($num) return $gematria[@k eq $c]/@v)"/>
        </xsl:variable>
        
        <ref xmlns="http://www.tei-c.org/ns/1.0"><xsl:value-of select="string-join(('convert-to-cts:m',$tract,$ch,$m),'.')"/></ref>


    </xsl:function>

    <xsl:function name="local:div-level">
        <xsl:param name="tract_no"/>
        <xsl:param name="in"/>
        <xsl:variable name="segs" select="tokenize($in,'\D+')[position() &gt; 1]"/>
        <milestone unit="segs" n="{string-join(($tract_no,$segs),'.')}"/>
    </xsl:function>
</xsl:stylesheet>
