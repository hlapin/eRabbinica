<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:expath="http://expath.org/ns/file"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei expath"
    version="2.0">
    <xsl:output indent="yes"/>

    <xsl:param name="keepM" select="'no'">
        <!-- need to write code for keepM = yes -->
    </xsl:param>

    <xsl:template match="/">
        <xsl:variable name="orderAndTract" select="substring(tei:milestone[@unit='ab'][1]/@n,1,5)"/>
        
            <xsl:for-each-group select="*" group-starting-with="tei:milestone[@unit = 'ab']">
                   <xsl:choose>
                <xsl:when test="current-group()[1][self::*[@unit eq 'ab']]">
                    <ab xml:id="{concat('ref-b.',current-group()[1]/@n)}"
                        n="{current-group()[1]/@n}">
                        <xsl:variable name="all-text">
                            <!-- get "prologue" -->
                            <xsl:if
                                test="not(current-group()[1]/preceding-sibling::tei:milestone[@unit = 'ab'])">
                                <xsl:copy-of select="preceding-sibling::*"/>
                            </xsl:if>
                            <xsl:apply-templates select="current-group() except current-group()[1]"
                                mode="map-to-body">
                                <xsl:with-param name="orderAndTract" select="$orderAndTract"/>
                            </xsl:apply-templates>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$keepM eq 'no'">
                                <xsl:call-template name="strip-m">
                                    <xsl:with-param name="text" select="$all-text"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$all-text"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ab>
                </xsl:when>
                </xsl:choose>
            </xsl:for-each-group>
    </xsl:template>
   
    <xsl:template match="tei:label" mode="map-to-body">
        <xsl:variable name="preceding-ab" select="preceding-sibling::tei:milestone[@unit = 'ab'][1]"/>
        <tei:label
            xml:id="ref-b.{$preceding-ab/@n}-label-{1 + count(preceding-sibling::tei:label[preceding-sibling::tei:milestone[@unit = 'ab'][1] is $preceding-ab])}">
            <xsl:copy-of select="@*"/>
                <xsl:copy-of select="node()"></xsl:copy-of>
        </tei:label>
    </xsl:template>
    <xsl:template match="tei:str[not(@xml:id)]" mode="map-to-body">
        <xsl:if test="preceding-sibling::*[1][self::tei:str]">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="tei:str[@xml:id]" mode="map-to-body">
        <xsl:param name="orderAndTract"></xsl:param>
        <seg xml:id="{concat('ref-b.',$orderAndTract,'.',preceding::tei:milestone[@unit='chapter'][1]/@n,'.T' )}">
            <xsl:copy-of select="@* except (@xml:id) | node()"></xsl:copy-of>
        </seg>
    </xsl:template>
    <xsl:template match="tei:milestone" mode="map-to-body">
        <xsl:choose>
            <xsl:when test="@unit = 'segment'">
                <milestone xml:id="{concat('ref-b','.',@n)}"
                    type="{preceding-sibling::tei:milestone[@unit='isMorB'][1]/@n}" unit="{@unit}"
                    n="{@n}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="strip-m">
        <xsl:param name="text"></xsl:param>
        <xsl:for-each-group select="$text/node()" group-starting-with="tei:milestone[@unit='segment']">
            <xsl:choose>
                <xsl:when test="current-group()[1][@type='mishnah']">
                    <xsl:apply-templates  select="current-group()[self::tei:milestone]" mode="strip-m"></xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates select="current-group()" mode="strip-m"/></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="node()" mode="strip-m" priority="-5">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
    <xsl:template match="tei:milestone[@unit='isMorB']" mode="strip-m" priority="5">
        <!-- do nothing -->
    </xsl:template>
    <xsl:template match="tei:milestone[@unit='segment' and @type='mishnah']" mode="strip-m" priority="5">
        <!-- do nothing -->
    </xsl:template>


</xsl:stylesheet>
