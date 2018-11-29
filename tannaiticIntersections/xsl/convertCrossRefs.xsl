<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://www.local-functions.uri" 
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:variable name="k-vPairs" select="document('../data/xml/biblRabbValues.xml')"
        as="document-node()"/>
    <xsl:key name="biblRabb" match="local:item" use="@k"/>
    <xsl:key name="gematria" match="local:letter" use="@k"/>
    <xsl:function name="local:convertCrossRefs">
        <xsl:param name="str"/>
                <!-- could do this more compactly -->
                <xsl:variable name="removeMe">'"’“”‟׳״</xsl:variable>
                <xsl:variable name="strippedTkns" select="translate(normalize-space($str),$removeMe,'')"/>
                <xsl:variable name="tkns"
                    select="
                    if (starts-with($str, 'משנה') or contains(substring-before($str,' '), 'ראה'))
                    then
                    tokenize(normalize-space(substring-after($strippedTkns, ' ')), '\s')
                    else
                    tokenize(normalize-space($strippedTkns), '\s')"/>
                <xsl:variable name="shamNisman"
                    select="
                    for $t in 2 to 6
                    return
                    $t[contains($tkns[position() = number(.)], 'ש&quot;נ')]"/>
                <xsl:variable name="tkns3"
                    select="
                    string-join(for $i in 1 to 3
                    return
                    $tkns[position() = $i], ' ')"/>
                <xsl:variable name="tkns2"
                    select="
                    string-join(for $i in 1 to 2
                    return
                    $tkns[position() = $i], ' ')"/>
                <xsl:variable name="tkns1" select="$tkns[1]"/>
                <xsl:variable name="tknsToUse">
                    <xsl:choose>
                        <xsl:when test="$k-vPairs//local:item[@k eq $tkns3]">
                            <xsl:value-of
                                select="translate(lower-case($k-vPairs/key('biblRabb', $tkns3)/@v), ' ', '_')"
                            />
                        </xsl:when>
                        <xsl:when test="$k-vPairs//local:item[@k eq $tkns2]">
                            <xsl:value-of
                                select="translate(lower-case($k-vPairs/key('biblRabb', $tkns2)/@v), ' ', '_')"
                            />
                        </xsl:when>
                        <xsl:when test="$k-vPairs//local:item[@k eq $tkns1]">
                            <xsl:value-of
                                select="translate(lower-case($k-vPairs/key('biblRabb', $tkns1)/@v), ' ', '_')"
                            />
                        </xsl:when>
                        <xsl:otherwise>useDel</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="refExtension">
                    <xsl:variable name="next"
                        select="
                        if ($tknsToUse = $tkns3) then
                        4
                        else
                        if ($tknsToUse = $tkns2) then
                        3
                        else
                        2"/>
                    <xsl:variable name="nextPlusOne" select="$next + 1"/>
                    <xsl:value-of
                        select="
                        if ($next = $shamNisman) then
                        '-plus'
                        else
                        if (normalize-space($tkns[position() = $next])) then
                        concat('.', local:gematria($tkns[position() = $next]))
                        else
                        ()"/>
                    <xsl:value-of
                        select="
                        if ($next = $shamNisman) then
                        '-plus'
                        else
                        if (normalize-space($tkns[position() = $nextPlusOne])) then
                        concat('.', local:gematria($tkns[position() = $nextPlusOne]))
                        else
                        ()"/>
                    <xsl:value-of
                        select="
                        if ($shamNisman &gt; $nextPlusOne) then
                        '-plus'
                        else
                        ()"
                    />
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$tknsToUse = 'useDel' or string-length($str) &gt; 20">
                        <skip><xsl:value-of select="regex-group(1)"/></skip>
                    </xsl:when>
                    <xsl:otherwise>
                        <use><xsl:value-of
                            select="normalize-space(concat(if (starts-with($str,'משנה')) 
                            then 'mishnah:' 
                            else if (contains(substring-before($str,' '),'ראה')) then 'cf. ' else (),$tknsToUse,$refExtension))"/></use>
                    </xsl:otherwise>
                </xsl:choose>
    </xsl:function>
    <xsl:function name="local:gematria">
        <xsl:param name="str"/>
        <xsl:value-of
            select="
            if (not(normalize-space($str))) then
            '-'
            else
            sum(for $c in string-to-codepoints($str)
            return
            xs:integer($k-vPairs//local:letter[@k = codepoints-to-string($c)]/@v))"
        />
    </xsl:function>
</xsl:stylesheet>