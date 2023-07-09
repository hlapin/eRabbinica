<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="2.0">
    <xsl:output indent="yes"/>

    <!--    <xsl:param name="doc" select="doc('test.xml')"/>-->
    <xsl:param name="keepM" select="'yes'"/>

    <xsl:template name="set-milestones-start">
        <xsl:param name="doc"/>
        <xsl:variable name="by-chapter">
            <xsl:call-template name="chapter-milestones">
                <xsl:with-param name="doc" select="$doc" tunnel="yes"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mishnah-gemara">
            <xsl:call-template name="MorB">
                <xsl:with-param name="by-chapter" select="$by-chapter"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:copy-of select="$mishnah-gemara"/>
    </xsl:template>

    <xsl:template name="chapter-milestones">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:for-each-group select="$doc/tei:out/tei:data/*"
            group-ending-with="self::tei:tags[matches(., 'הדרן עלך')]">
            <xsl:variable name="seg-milestone" select="current-group()[self::tei:milestone][last()]"/>
            <xsl:if test="normalize-space(string-join(current-group()))">
                <xsl:variable name="chapter-number" select="1 + count(current-group()[last()]/preceding-sibling::tei:tags[matches(.,'הדרן עלך')])"/>
                <milestone unit="chapter"
                    xml:id="{concat('ref-b.',$doc/tei:out/tei:head/tei:id,'.',$chapter-number)}"
                    n="{$chapter-number}"/>
                <xsl:copy-of select="current-group() except current-group()[last()]"/>
                <str xml:id="{concat($seg-milestone/@n, '.', $chapter-number)}">
                    <xsl:copy-of
                        select="normalize-space(replace(current-group()[last()], '[\P{IsHebrew}]', ' '))"
                    />
                </str>
            </xsl:if>

        </xsl:for-each-group>
    </xsl:template>

    <!-- To Do: drop mishnah text -->
    <xsl:template name="MorB">
        <xsl:param name="by-chapter"/>
        <xsl:for-each-group select="$by-chapter/*"
            group-starting-with="tei:tags[matches(text(), '&lt;/strong&gt;&lt;/big&gt;')]">
            <xsl:choose>
                <xsl:when test="matches(current-group()[1], '&lt;/strong&gt;&lt;/big&gt;')">
                    <xsl:variable name="str"
                        select="normalize-space(replace(current-group()[1], '[\P{IsHebrew}]', ' '))"/>
                    <xsl:variable name="isMorB">
                        <xsl:choose>
                            <xsl:when test="matches($str, '(גמ׳)')">
                                <milestone unit="isMorB" n="talmud"/>
                                <label type="talmud">
                                    <xsl:value-of select="$str"/>
                                </label>
                            </xsl:when>
                            <xsl:otherwise>
                                <milestone unit="isMorB" n="mishnah"/>
                                <xsl:choose>
                                    <xsl:when test="matches($str, 'מתני׳')">
                                        <label type="mishnah">מתני׳</label>
                                        <str>
                                            <xsl:value-of
                                                select="normalize-space(substring-after($str, 'מתני׳'))"
                                            />
                                        </str>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <str>
                                            <xsl:value-of select="normalize-space($str)"/>
                                        </str>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!-- positioning segment milestone and mishnah/gemarah milestone -->
                    <xsl:copy-of select="$isMorB/tei:milestone"/>
                    <xsl:copy-of
                        select="current-group()[1]/preceding-sibling::*[1][self::tei:milestone]"/>
                    <xsl:copy-of select="$isMorB/tei:label"/>
                    <xsl:copy-of select="$isMorB/tei:str"/>
                    <xsl:copy-of
                        select="current-group() except (current-group()[1] | current-group()[last()])"/>
                    <!-- include last node if str element -->
                    <xsl:copy-of select="current-group()[last()][self::tei:str]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of
                        select="current-group() except current-group()[last()][self::tei:milestone[@unit = 'segment']]"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>

    </xsl:template>
</xsl:stylesheet>