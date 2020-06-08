<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="table">
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates select="cell"/>
        </tr>
    </xsl:template>
    <xsl:template match="cell">
        <td>
            <xsl:apply-templates/>
            <xsl:if test="@n">-<xsl:value-of select="@n"/></xsl:if>
        </td>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:text>[*]</xsl:text>
    </xsl:template>
    <xsl:template match="div[@type='notes']">
        <!-- omit -->
    </xsl:template>
</xsl:stylesheet>