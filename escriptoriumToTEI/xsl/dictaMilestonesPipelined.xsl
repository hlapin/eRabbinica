<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="local.functions.uri"
    exclude-result-prefixes="xs local tei" version="3.0">

    <!-- called from template[@name = 'lines'], with $rows corresponding to rows extract  -->
    <!-- $target, $compare refer to columns of dicta output-->
    <!-- $target is the witness to which we wish to transfer canonical milestones. -->
    <!-- $compare is a canonically divided "default" text typically vilna -->

    

    <xsl:template name="lines">
        <xsl:param name="rows"/>
        <xsl:param name="target"/>
        <xsl:param name="compare"/>
        <xsl:variable name="target_name" select="$rows[1]/*[starts-with(name(), $target)]/name()"/>
        <xsl:variable name="compare_name" select="$rows[1]/*[starts-with(name(), $compare)]/name()"/>
        <xsl:variable name="lines" as="element()+">
            <xsl:for-each-group select="$rows"
            group-starting-with=".[element()[local-name() eq $target_name][matches(normalize-space(.), '(.*)(l\-\w+)(\W*)')]]">
            <!-- to deal with errors where token attached to milestone, break up token-->
            <!-- check if element()[local-name() eq $target_name] has milestone to keep -->
            <xsl:variable name="regex-parts" select="(
                    (: replace(current-group()[1]/*[local-name() eq $target_name],'^(.*)(l\-\w+)(\W*)','$1'),:)
                    replace(current-group()[1]/*[local-name() eq $target_name], '^(.*)(l\-\w+)(\W*)', '$2'),
                    replace(current-group()[1]/*[local-name() eq $target_name], '^(.*)(l\-\w+)(\W*)', '$3')
                    )"> </xsl:variable>
            <xsl:variable name="target_token" select="$regex-parts[2]"/>
            <xsl:variable name="compare_token" select="element()[local-name() eq $compare_name]"/>

            <xsl:if test="starts-with(current-group()[1]/*[name() eq $target_name], 'l-')">
                <!-- Only keep group if first item starts with a target line break -->
                <!-- In theory only row >= 1; are there others?  -->

                <l xmlns="http://www.tei-c.org/ns/1.0"
                    n="eSc_line_{substring-after(current-group()[1]/*[local-name() eq $target_name],'l-')}">

                    <xsl:if
                        test="not(preceding-sibling::local:row/*[name() eq $target_name][starts-with(., 'l-')])">
                        <xsl:for-each
                            select="preceding-sibling::local:row/*[name() eq $compare_name]">
                            <xsl:if test="matches(., '^\d+\.\d+(\.^\d+\.\d+)*')">
                                <milestone 
                                    xmlns="http://www.tei-c.org/ns/1.0"
                                    unit="{local:level-attribute((normalize-space(.)))}"
                                    n="{normalize-space(.)}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>

                    <!-- if first token of line in target corresponds to a milestone to keep -->
                    <!-- insert tei:milestone -->
                    <xsl:if
                        test="matches(current-group()[1]/*[local-name() eq $compare_name], '^\d+\.\d+(\.^\d+\.\d+)*')">
                        <milestone
                            xmlns="http://www.tei-c.org/ns/1.0"
                            unit="{local:level-attribute((normalize-space($compare_token)))}"
                            n="{normalize-space($compare_token)}"/>
                    </xsl:if>

                    <xsl:if test="$regex-parts[2]">
                        <xsl:value-of select="string-join(($regex-parts[2], ' '))"/>
                    </xsl:if>

                    <xsl:apply-templates select="(current-group() except current-group()[1])">
                        <xsl:with-param name="compare_name" select="$compare_name" tunnel="yes"/>
                        <xsl:with-param name="target_name" select="$target_name" tunnel="yes"/>
                    </xsl:apply-templates>

                    <!-- to deal with line, region accidentally merged with text token -->
                    <xsl:variable name="next_line_token" select="
                            replace(current-group()[last()]/
                            following-sibling::*[1]/*[local-name() eq $target_name], '(.*)(l\-\w+)(\W*)', '$1')"/>
                    <xsl:if test="normalize-space($next_line_token)">
                        <xsl:value-of select="string-join((' ', $next_line_token))"/>
                    </xsl:if>
                </l>
            
            </xsl:if>
        </xsl:for-each-group></xsl:variable>
        <xsl:copy-of select="$lines[*:milestone]"></xsl:copy-of>
    </xsl:template>

    <xsl:template match="local:row">
        <xsl:param name="target_name" tunnel="yes"/>
        <xsl:param name="compare_name" tunnel="yes"/>
        
        
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[parent::local:row]">
        <xsl:param name="target_name" tunnel="yes"/>
        <xsl:param name="compare_name" tunnel="yes"/>
        <xsl:variable name="target_token" select="self::*[local-name() eq $target_name]"/>
        <xsl:variable name="compare_token" select="self::*[local-name() eq $compare_name]"/>
        <xsl:choose>
            <xsl:when test="matches(normalize-space($compare_token), '^\d+\.\d+(\.^\d+\.\d+)*')">
                <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="{local:level-attribute((normalize-space($compare_token)))}"
                    n="{normalize-space($compare_token)}"/>
                <xsl:choose>
                    <xsl:when test="matches(normalize-space($target_token), '^(ab-|r-).*')">
                        <!-- skip -->
                    </xsl:when>
                    <xsl:when test="normalize-space($target_token)">
                        <xsl:value-of select="$target_token"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="matches(normalize-space($target_token), '^(ab-|r-).*')">
                <!-- skip -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="string($target_token)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="local:level-attribute">
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
    </xsl:function>
</xsl:stylesheet>
