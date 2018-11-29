<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:local="http://www.local-functions.uri"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs local tei" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:import href="convertCrossRefs.xsl"/>
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:variable name="punctChars">\.,!:;?\|\-–—</xsl:variable>
    <xsl:variable name="teiHeader">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>An Electronic Edition of the Mekhilta de-Rabbi Ishmael</title>
                    <editor>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </editor>
                    <respStmt>
                        <resp>file conversion</resp>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </respStmt>
                    <respStmt>
                        <resp>transcription</resp>
                        <orgName corresp="ref.xml#mechon-mamre">Mechon Mamre</orgName>
                    </respStmt>
                    <respStmt>
                        <resp>encoding</resp>
                        <orgName corresp="ref.xml#mechon-mamre">Mechon Mamre</orgName>
                    </respStmt>
                    <sponsor n="primary">Joseph and Rebecca Meyerhoff Center for Jewish
                        Studies</sponsor>
                </titleStmt>
                <publicationStmt>
                    <publisher>eRabbinica</publisher>
                    <pubPlace>...</pubPlace>
                    <address>
                        <addrLine>...</addrLine>
                    </address>
                    <idno type="local">ref-mek</idno>
                    <availability status="restricted">
                        <p>This work is copyright Hayim Lapin and the Joseph and Rebecca Meyerhoff
                            Center for Jewish Studies and licensed under a <ref
                                target="http://creativecommons.org/licenses/by-sa/4.0//">Creative
                                Commons Attribution International 4.0 License</ref> except where
                            otherwise constrained by Mechon Mamre.</p>
                    </availability>
                    <pubPlace>College Park, MD USA</pubPlace>
                    <date>2018-09-03</date>
                </publicationStmt>
                <notesStmt>
                    <note>
                        <p>Mekhilta from <ref
                                target="http://www.daat.ac.il/daat/tanach/mehilta/tohen2.htm"
                                >Daat</ref>.</p>
                        <p>Divisions restored to Lauterbach's division of the text</p>
                        <p>Edited and converted by TEI/XML by Hayim Lapin</p>
                    </note>
                </notesStmt>
                <sourceDesc>
                    <biblStruct xml:id="tba">
                        <monogr>
                            <title xml:lang="en">Mekhilta de Rabbi Ishmael</title>
                            <title xml:lang="he">מכילתא דרבי ישמעאל</title>
                            <imprint n="1">
                                <pubPlace>...</pubPlace>
                                <publisher>...</publisher>
                                <date>...</date>
                            </imprint>
                        </monogr>
                        <note type="nli-ref">...</note>
                    </biblStruct>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <tagsDecl/>
            </encodingDesc>
            <revisionDesc>
                <change when="2018-09-02" who="ref.xml#HL">Begun editing and tagging</change>
            </revisionDesc>
        </teiHeader>
    </xsl:variable>
    <xsl:template name="startFromCollection">
        <xsl:variable name="pathIn" select="'../data/html/'"/>
        <xsl:variable name="pathOut" select="'../data/xml/'"/>
        <xsl:variable name="docs"
            select="collection(concat($pathIn, '?select=daat-mek12.xml?;recurse=no'))"/>
        <TEI xml:id="ref-mek">
            <xsl:copy-of select="$teiHeader"/>
            <text>
                <body>
                    <xsl:variable name="structure">
                        <xsl:for-each select="$docs">
                            <xsl:sort
                                select="number(substring-before(substring-after(base-uri(), 'mek'), '.xml'))"/>
                            <xsl:message select="base-uri()"/>
                            <xsl:variable name="nodes">
                                <xsl:apply-templates select="root/node()" mode="flatten"/>
                            </xsl:variable>
                            <xsl:call-template name="structure">
                                <xsl:with-param name="nodes" select="$nodes/node()"/>
                                <xsl:with-param name="massNo"
                                    select="number(substring-before(substring-after(base-uri(), 'mek'), '.xml'))"
                                />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:call-template name="restructure">
                        <xsl:with-param name="nodes" select="$structure"/>
                    </xsl:call-template>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="h2 | hr | head | meta | link | img | br | a" mode="flatten"/>
    <xsl:template match="html | body | div | b | font[@color = 'red']" mode="flatten">
        <xsl:apply-templates mode="flatten"/>
    </xsl:template>
    <xsl:template match="element()" mode="flatten">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="flatten"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text()" mode="flatten">
        <xsl:variable name="txt" select="."/>
        <xsl:variable name="rgx"
            >(מסכתא??\s+ד??\p{IsHebrew}+\s+פרשה\s+\p{IsHebrew}{1,2})</xsl:variable>
        <xsl:analyze-string select="$txt" regex="{$rgx}">
            <xsl:matching-substring>
                <head>
                    <xsl:value-of select="regex-group(1)"/>
                </head>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:text>&#x20;</xsl:text>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template name="structure">
        <xsl:param name="nodes"/>
        <xsl:param name="massNo"/>
        <xsl:for-each-group select="$nodes" group-starting-with="tei:head">
            <xsl:if test="current-group()[1][self::tei:head]">
                <xsl:variable name="div2ID"
                    select="concat('ref-mek.', $massNo, '.', 1 + count(preceding::tei:head))"/>
                <!-- use following to count IDs later -->
                <xsl:variable name="abStartsInGroup"
                    select="current-group()[self::tei:span[@id = 'hadgasha'][matches(., '\[\p{IsHebrew}{1,3},\s+\p{IsHebrew}{1,3}\]')]]"/>
                <div type="level_2"
                    n="{substring-before(current-group()[1][self::tei:head],' פרש')}">
                    <head>
                        <xsl:value-of select="current-group()[1]"/>
                    </head>
                    <xsl:for-each-group select="current-group()[position() &gt; 1]"
                        group-starting-with="tei:span[@id = 'hadgasha'][matches(., '\[\p{IsHebrew}{1,3},\s+\p{IsHebrew}{1,3}\]')]">
                        <xsl:variable name="abNum"
                            select="1 + count($abStartsInGroup[self::tei:span] intersect current-group()[1]/preceding-sibling::tei:span[@id = 'hadgasha'][matches(., '\[\p{IsHebrew}{1,3},\s+\p{IsHebrew}{1,3}\]')])"/>
                        <xsl:if test="normalize-space(string-join(current-group()))">
                            <ab n="{$abNum}">
                                <xsl:apply-templates select="current-group()"/>
                                <!--<xsl:copy-of select="current-group()"/>-->
                            </ab>
                        </xsl:if>
                    </xsl:for-each-group>
                </div>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="tei:font">
        <xsl:if test="normalize-space(.)">
            <seg type="citation">
                <xsl:apply-templates/>
            </seg>
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:span">
        <xsl:choose>
            <xsl:when test="normalize-space(.)">
                <seg type="lemma">
                    <xsl:choose>
                        <xsl:when test="matches(text(), '(\[[^\]]+\])')">
                            <xsl:analyze-string
                                regex="(\[(\p{{IsHebrew}}{{1,3}}),\s*(\p{{IsHebrew}}{{1,3}})\])"
                                select="text()">
                                <xsl:matching-substring>
                                    <ref>
                                        <xsl:attribute name="target">
                                            <xsl:text>exodus.</xsl:text>
                                            <xsl:value-of select="local:gematria(regex-group(2))"/>
                                            <xsl:text>.</xsl:text>
                                            <xsl:value-of select="local:gematria(regex-group(3))"/>
                                        </xsl:attribute>
                                        <xsl:text>שמות </xsl:text>
                                        <xsl:value-of select="translate(., '[]', '')"/>
                                    </ref>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:call-template name="regex">
                                        <xsl:with-param name="str" select="."/>
                                    </xsl:call-template>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<xsl:apply-templates/>-->
                </seg>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:call-template name="regex">
            <xsl:with-param name="str" select="."/>
        </xsl:call-template>

    </xsl:template>
    <xsl:template name="regex">
        <xsl:param name="str"/>
        <xsl:analyze-string select="." regex="\(([^\)]+)\)">

            <xsl:matching-substring>
                <xsl:variable name="returned" select="local:convertCrossRefs(regex-group(1))"/>
                <xsl:choose>
                    <xsl:when test="$returned[self::*:use]">
                        <seg type="citation" target="{$returned//text()}" n="{regex-group(1)}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <seg type="parens">
                            <xsl:value-of select="regex-group(1)"/>
                        </seg>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:call-template name="punct">
                    <xsl:with-param name="str" select="."/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template name="punct">
        <xsl:param name="str"/>
        <xsl:analyze-string select="$str" regex="([{$punctChars}]+)">
            <xsl:matching-substring>
                <pc>
                    <xsl:value-of select="regex-group(1)"/>
                </pc>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:call-template name="apos">
                    <xsl:with-param name="str" select="."/>
                </xsl:call-template>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template name="apos">
        <xsl:param name="str"/>
        <xsl:variable name="aposLetters">'"׳״</xsl:variable>
        <xsl:variable name="single">['׳]</xsl:variable>
        <xsl:variable name="double">["״]</xsl:variable>
        <xsl:analyze-string select="$str" regex="([{$aposLetters}])">
            <xsl:matching-substring>
                <am>
                    <xsl:choose>
                        <xsl:when test="matches(regex-group(1), $single)">
                            <xsl:text>׳</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches(regex-group(1), $double)">
                            <xsl:text>״</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </am>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <!-- :::::::::::::::::::::::::::::::::::::::::::: -->
    <xsl:template name="restructure">
        <xsl:param name="nodes"/>
        <xsl:variable name="tractNames" select="distinct-values($nodes/*/@n)"/>
        <xsl:for-each-group select="$nodes/*" group-adjacent="@n">
            <xsl:variable name="level_1No" select="index-of($tractNames, current-grouping-key())"/>
            <div type="level_1" xml:id="ref-mek.{index-of($tractNames,current-grouping-key())}">
                <xsl:variable name="level2elems" select="current-group()[self::tei:div]"/>
                <xsl:for-each select="current-group()[self::tei:div]">
                    <xsl:variable name="level_2Num"
                        select="
                            concat('ref-mek.', $level_1No, '.', for $i in 1 to count($level2elems)
                            return
                                $i[$level2elems[$i] is current()])"/>
                    <div xml:id="{$level_2Num}">
                        <xsl:copy-of select="@*"/>
                        <xsl:for-each select="*">
                            <xsl:choose>
                                <xsl:when test="self::tei:head">
                                    <head xml:id="{$level_2Num}.H">
                                        <xsl:apply-templates mode="pass2"/>
                                    </head>
                                </xsl:when>
                                <xsl:when test="self::tei:ab">
                                    <ab xml:id="{$level_2Num}.{@n}">
                                        <xsl:apply-templates mode="pass2"/>
                                    </ab>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="node() | @*" mode="pass2">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="pass2"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'citation'][not(@target)]" mode="pass2">
        <seg type='citation'>
            <xsl:choose>
                <xsl:when
                    test="following-sibling::*[1][self::tei:seg[@target]] 
                    (: is following-sibling::node()[1][self::text()[not(normalize-space(.))]]/following-sibling::node()[1][self::tei:seg[@target]] :)">
                    <ref>
                        <xsl:copy-of select="following-sibling::*[1]/@*"/>
                    </ref>
                    <xsl:apply-templates select="node()" mode="pass2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="pass2"/>
                </xsl:otherwise>
            </xsl:choose>
        </seg>

    </xsl:template>
    <xsl:template match="tei:seg[@type = 'citation'][@target]" mode="pass2">
        <xsl:choose>
            <xsl:when
                test="preceding-sibling::*[1][self::tei:seg[not(@target)]] (:is preceding-sibling::node()[1][self::text()[not(normalize-space(.))]]/preceding-sibling::node()[1][self::tei:seg[not(@target)]] :)"> </xsl:when>
            <xsl:otherwise>
                <ref>
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates mode="pass2"/>
                </ref>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
