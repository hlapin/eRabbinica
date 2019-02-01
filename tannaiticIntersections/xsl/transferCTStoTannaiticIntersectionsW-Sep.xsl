<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://www.local-functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs local tei xi" version="2.0">
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="src" select="'bible'"><!-- bible or talmud --></xsl:param>
    <xsl:param name="pathIn" select="'file:///C:/Users/hlapin/Documents/GitHub/ancJewLitCTS/data/'"/>
    <xsl:param name="pathOut"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/tannaiticIntersections/data/xml/w-sep/'"/>
    <xsl:variable name="ref-name"
        select="
        if ($src = 'bible') then
        'ref-bible'
        else
        if ($src = 'talmud') then
        'ref-b'
        else
        ()"/>
    <xsl:variable name="teiHeader-bible">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>An Electronic Edition of the Leningrad Codex of the Hebrew Bibl</title>
                    <editor>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </editor>
                    <respStmt>
                        <resp>file conversion</resp>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </respStmt>
                    <respStmt>
                        <resp>transcription</resp>
                        <orgName corresp="ref.xml#allanGroves">Alan Groves Center for Advanced
                            Biblical Research</orgName>
                    </respStmt>
                    <respStmt>
                        <resp>encoding</resp>
                        <orgName corresp="ref.xml#HL">Hayim Lapin</orgName>
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
                            otherwise constrained by the original transcribers.</p>
                    </availability>
                    <pubPlace>College Park, MD USA</pubPlace>
                    <date>2018-11-29</date>
                </publicationStmt>
                <notesStmt>
                    <note>
                        <p>This header is a placeholder and needs expansion.</p>
                        <p>Edited and converted by TEI/XML by Hayim Lapin</p>
                    </note>
                </notesStmt>
                <sourceDesc>
                    <biblStruct xml:id="tba">
                        <monogr>
                            <title xml:lang="en">Bible According to the Lenindgrad Codex</title>
                            <title xml:lang="he">מקרא ע"פ כ"י לנינגרד</title>
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
    <xsl:variable name="teiHeader-talmud">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>An Electronic Edition of the Babylonian Talmud</title>
                    <editor>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </editor>
                    <respStmt>
                        <resp>file conversion</resp>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </respStmt>
                    <respStmt>
                        <resp>transcription</resp>
                        <orgName corresp="ref.xml#Responsa">Responsa Project</orgName>
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
                                Commons Attribution International 4.0 License</ref>.</p>
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
                            <title xml:lang="en">Babylonian Talmud based on the Vilna
                                Printing</title>
                            <title xml:lang="he">תלמוד בבלי ע"פ דפוס וילנא</title>
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
    <xsl:template match="/">
        <TEI>
            <xsl:choose>
                <xsl:when test="$src = 'bible'">
                    <xsl:attribute name="xml:id" select="'ref-bible'"/>
                    <xsl:copy-of select="$teiHeader-bible"/>
                </xsl:when>
                <xsl:when test="$src = 'talmud'">
                    <xsl:attribute name="xml:id" select="'ref-b'"/>
                    <xsl:copy-of select="$teiHeader-talmud"/>
                </xsl:when>
            </xsl:choose>
            <text>
                <body>
                    <xsl:variable name="elemstoProcess"
                        select="
                        if ($src = 'bible') then
                        /local:bibleRabbRefValues/local:bibBookNameNum
                        else
                        if ($src = 'talmud') then
                        /local:bibleRabbRefValues/local:tractNameNum
                        else
                        ()"/>
                    <xsl:for-each select="$elemstoProcess/local:item">
                        <xsl:variable name="pathToTake">
                            <xsl:choose>
                                <xsl:when test="$src = 'bible'">
                                    <xsl:value-of
                                        select="concat($pathIn, 'hebBible/', @v, '/hebBible.', @v, '.leningrad-cons.xml')"
                                    />
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="$src = 'talmud'">
                                    <xsl:value-of
                                        select="concat($pathIn, 'babTalmud/', @v, '/babTalmud.', @v, '.dicta.xml')"
                                    />
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="doc-available($pathToTake)">
                                <xsl:message>yes-<xsl:value-of select="$pathToTake"/></xsl:message>
                                <xsl:element name="xi:include">
                                    <xsl:attribute name="href"
                                        select="concat($ref-name, '/', $ref-name, '-', @k, '-w-sep.xml')"/>
                                    <xsl:call-template name="includedFile">
                                        <xsl:with-param name="path" select="$pathToTake"/>
                                        <xsl:with-param name="item" select="."/>
                                        <xsl:with-param name="targetFolderName"
                                            select="concat($ref-name, '/', $ref-name, '-', @k, '-w-sep.xml')"
                                        />
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message>no-<xsl:value-of select="$pathToTake"/></xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template name="includedFile">
        <xsl:param name="path"/>
        <xsl:param name="item"/>
        <xsl:param name="targetFolderName"/>
        <xsl:message select="$path"/>
        <xsl:message select="$pathOut,$targetFolderName"/>
        <xsl:result-document encoding="UTF-8" indent="yes"
            href="{concat($pathOut,$targetFolderName)}">
            <div xml:id="{$ref-name}.{$item/@k}">
                <xsl:apply-templates
                    select="doc($path)/tei:TEI/tei:text/tei:body/tei:div[@type = 'edition']/*">
                    <xsl:with-param name="prefix" tunnel="yes" select="concat($ref-name,'.',$item/@k)"/>
                </xsl:apply-templates>
            </div>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="tei:div[@subtype = 'folio' or @subtype = 'chapter']">
        <xsl:param name="prefix" tunnel="yes"/>
        <div xml:id="{concat($prefix,'.',@n)}">
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:ab[tei:w and not(text()[normalize-space(.)])]">
        <xsl:param name="prefix" tunnel="yes"/>
        <xsl:variable name="abID"
            select="concat($prefix, '.', ancestor::tei:div[@subtype = 'chapter' or @subtype = 'folio']/@n)"/>
        <ab xml:id="{concat($abID,'.',@n)}">
            <xsl:apply-templates> 
                <xsl:with-param name="wPrefix" select="concat($abID,'.',@n)"/>
            </xsl:apply-templates>
            
        </ab>
    </xsl:template>
    <xsl:template match="tei:ab[not(tei:w)]">
        <xsl:param name="prefix" tunnel="yes"/>
        <xsl:variable name="abID"
            select="concat($prefix, '.', ancestor::tei:div[@subtype = 'chapter' or @subtype = 'folio']/@n)"/>
        <xsl:variable name="toTokenize">
            <xsl:analyze-string select="node()" regex="(\s+)">
                <xsl:matching-substring>
                    <w/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <ab
            xml:id="{concat($abID,.,@n)}">
            <xsl:variable name="tokens">
                <xsl:for-each-group select="$toTokenize/node()" group-starting-with="tei:w">
                    <w>
                        <xsl:copy-of select="current-group()[not(self::tei:w)]"/>
                    </w>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:apply-templates select="$tokens">
                <xsl:with-param name="wPrefix" select="concat($abID,'.',@n)"/>
            </xsl:apply-templates>
        </ab>
    </xsl:template>
    <xsl:template match="tei:ab[@subtype = 'mishnah']"/>
    <xsl:template match="tei:w">
        <xsl:param name="wPrefix"/>
        <xsl:choose>
            <xsl:when test="normalize-space(.)">
                <w xml:id="{concat($wPrefix,'.',1 + count(preceding-sibling::tei:w))}">
                    <xsl:copy-of select="node()"/>
                </w>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:*[ancestor::tei:ab]">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
</xsl:stylesheet>
