<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs local tei xi map" version="3.0">
    <xsl:output indent="yes"/>


    <!-- 9/4/21 need to incorporate function to create folio line numbers. -->
    <!-- Variability chapter headers, trailers, and mishnah labels means that there is a fair -->
    <!-- amount of error at this point -->
    <!--<xsl:include href="renumberPbCbtoInclude.xsl"/> -->

    <xsl:param name="img-name-ext" select="'png'"/>
    <!-- for refDecl in header -->
    <xsl:param name="path-to-pagexml" select="('http://www.placeholder.uri', 'pxml')"/>
    <xsl:param name="path-to-facs" select="('http://www.placeholder.uri', 'tei-facs')"/>
    <xsl:param name="path-out"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/xsl/'"/>
    <xsl:param name="headers" select="doc('HeadersTemplateYerushalmi.xml')"/>
    <xsl:param name="w-sep" select="1"/>

    <xsl:variable name="base" select="tokenize(base-uri(/), '/')[last()]"/>
    <xsl:variable name="witID" select="substring-before(/teiCorpus/@xml:id, '-')"/>
    <xsl:variable name="dir-path" select="
            concat($witID, if ($w-sep eq 1) then
                '-w-sep'
            else
                ())"/>

    <!-- flatten TEI Facs, retaining pb, cb, l ==> lb and their IDs -->
    <!-- iterate on milestones to create canonical structure -->
    <!--    For each unit within canonical structure create w-sep, id'd text -->
    <!--    ***Will need to create head, label, possibly trailer, from text between milestones. -->
    <!-- Update new format with values from index of pages, columns, lines -->


    <xsl:template match="/">
        <xsl:message select="$base"/>
        <xsl:message select="$witID"/>

        <xsl:variable name="flattened" as="node()+">
            <xsl:apply-templates select="teiCorpus/TEI/text/body"/>
        </xsl:variable>

        <xsl:variable name="grouped-by-milestone">
            <xsl:call-template name="group-on-milestones">
                <xsl:with-param name="toGroup" select="$flattened"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- at this point a full text organized by divs/abs -->
        
        <!-- produce output -->
        <xsl:result-document href="{concat($path-out,$dir-path,'/',$witID, 
                if($w-sep eq 1) then '-w-sep' else (),
                '.xml')}">
            <TEI xml:id="yt.{$witID}">
                <xsl:copy-of select="$headers/teiCorpus/teiHeader"/>
                <text>
                    <body>
                        <xsl:apply-templates select="$grouped-by-milestone" mode="production"/>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>

    <!-- flatten -->
    <xsl:template match="cb | pb">
        <xsl:element name="{name()}">
            <xsl:attribute name="corresp"
                select="concat($path-to-facs[2], ':', $base, '#', @xml:id)"/>
            <xsl:attribute name="n" select="@n"/>
            <xsl:attribute name="xml:id" select="concat($witID, '.', @n)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l[normalize-space()]">
        <xsl:variable name="prec_cb" select="preceding::cb[1]"/>
        <xsl:variable name="line_no">
            <xsl:choose>
                <xsl:when test="./parent::ab[@type='Paratext']">
                    <xsl:value-of select="1 + count(preceding-sibling::l)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1 + count(ancestor-or-self::*[ancestor::div]/preceding-sibling::*/descendant-or-self::l[preceding::cb[1] is $prec_cb])"></xsl:value-of>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <lb n="{$line_no}">
            <xsl:attribute name="corresp"
                select="concat($path-to-pagexml[2], ':', local:cref(@corresp))"/>
        </lb>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ab[@type = 'Commentary']">
        <gap reason="Maimonides" extent="{count(l)}" unit="lines"
            corresp="{concat($path-to-pagexml[2],':',local:cref(@corresp))}"/>
    </xsl:template>

    <xsl:template match="ab[contains(@type,'aratext')][l[normalize-space()]]">
        <xsl:variable name="prec_pb" select="preceding::pb[1]"/>
        <!-- ancestor-or-self::*[ancestor::div]/preceding-sibling::*/descendant-or-self::l -->
        <xsl:variable name="fw-no"
            select="1 + count(ancestor-or-self::*[ancestor::body]/preceding-sibling::*/descendant-or-self::ab[@type = 'Paratext'][preceding::pb[1] is $prec_pb])"/>
        <fw xml:id="{concat($witID,'.',preceding::pb[1]/@xml:id,'_fw_',$fw-no)}" type="paratext"
            corresp="{concat($path-to-pagexml[2],':',local:cref(@corresp))}">
            <xsl:apply-templates/>
        </fw>
    </xsl:template>

    <xsl:template match="ab[@type = 'Margin']">
        <add type="Not-specified" corresp="{concat($path-to-pagexml[2],':',local:cref(@corresp))}"
            location="margin" extent="{count(l)}" unit="lines"/>
        <xsl:apply-templates/>
    </xsl:template>    
    
    <xsl:template match="ref">
        <ptr xmlns="http://www.tei-c.org/ns/1.0" target="{text()}"></ptr>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:variable name="t" select="normalize-space(.)"/>
        <xsl:variable name="singleQuot">
            <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="doubleQuot">
            <xsl:text>"</xsl:text>
        </xsl:variable>
        <xsl:variable name="regexPattern"
            select="concat('(', $singleQuot, ׳, '|', $doubleQuot, '|\.|:)')"/>
        <!-- '(',$singleQuot,'|',$doubleQuot,'|\s+|\.|:',')' -->
        <xsl:analyze-string select="$t" regex="{$regexPattern}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". eq $singleQuot">
                        <am>׳</am>
                    </xsl:when>
                    <xsl:when test=". eq '׳'">
                        <am>׳</am>
                    </xsl:when>
                    <xsl:when test=". eq $doubleQuot">
                        <am>״</am>
                    </xsl:when>
                    <xsl:when test=". eq '.'">
                        <pc unit="stop">.</pc>
                    </xsl:when>
                    <xsl:when test=". eq ':'">
                        <pc unit="unitEnd">:</pc>
                    </xsl:when>
                    <!--<xsl:when test="matches(., '\s+')"><w/></xsl:when>-->
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!--<xsl:template match="ref" mode="production">
        <xsl:copy-of select="."/>
    </xsl:template>-->

    <xsl:template match="milestone">
        <milestone xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
        </milestone>
        <!--<xsl:copy-of select="."></xsl:copy-of>-->
    </xsl:template>

    <!-- group on milestones and clean up-->
    <xsl:template name="group-on-milestones">
        <xsl:param name="toGroup"/>

        <xsl:for-each-group select="$toGroup" group-starting-with="milestone[@unit = 'div1']">
            <xsl:choose>
                <xsl:when test="current-group()[1]/self::milestone[@unit = 'div1']">
                    <xsl:variable name="div1_no" select="concat($witID, '.', current-group()[1]/@n)"/>
                    <div1 xml:id="{$div1_no}">
                        <xsl:for-each-group
                            select="current-group()[not(self::milestone[@unit = 'div1'])]"
                            group-starting-with="milestone[@unit = 'div2']">
                            <xsl:choose>
                                <xsl:when test="current-group()[1]/self::milestone[@unit = 'div2']">
                                    <xsl:call-template name="build-tractates">
                                        <!--<xsl:with-param name="tract_group" select="not(self::milestone[@unit = 'div2'])"/>-->
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <head xml:id="{concat($div1_no,'.H')}">
                                        <xsl:copy-of select="current-group()"/>
                                    </head>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </div1>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="current-group()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template mode="restructure production" match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="build-tractates">
        <xsl:param name="tract_group"/>
        <xsl:variable name="div2_no" select="concat($witID, '.', current-group()[1]/@n)"/>
        <div2 xml:id="{$div2_no}">
            <xsl:for-each-group select="current-group()[not(self::milestone[@unit = 'div2'])]"
                group-starting-with="milestone[@unit = 'div3']">
                <xsl:choose>
                    <xsl:when test="current-group()[1][self::milestone[@n and @type = 'M']]">
                        <gap reason="Mishnah"
                            corresp="{concat('path_to_m#',tokenize($witID,'\-')[1],'.',current-group()[1]/@n)}"
                        />
                    </xsl:when>
                    <xsl:when test="current-group()[1][self::milestone[@n and not(@type = 'M')]]">
                        <xsl:variable name="div3_no"
                            select="concat($witID, '.', current-group()[1]/@n)"/>
                        <div3 xml:id="{$div3_no}">
                            <xsl:for-each-group
                                select="current-group()[not(self::milestone[@unit = 'div3'])]"
                                group-starting-with="milestone[@unit = 'ab']">
                                <xsl:choose>
                                    <xsl:when
                                        test="current-group()[1][self::*:milestone[@unit = 'ab']]">
                                        <xsl:variable name="ab_no" select="current-group()[1]/@n"/>
                                        <ab xml:id="{concat($witID,'.',$ab_no)}">
                                            <xsl:copy-of
                                                select="current-group()[not(self::milestone[@unit = 'ab'])]"
                                            />
                                        </ab>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each-group>
                        </div3>
                    </xsl:when>
                    <xsl:otherwise>
                        <head xml:id="{concat($div2_no,'.H')}">
                            <xsl:copy-of select="current-group()"/>
                        </head>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </div2>
    </xsl:template>

    <!-- could deal with this earlier in process and not redo -->

    <xsl:template match="div1" mode="production">
        <div type="order">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="production"/>
        </div>
    </xsl:template>

    <xsl:template match="div2" mode="production">
        <xsl:element name="xi:include">
            <xsl:attribute name="href" select="concat('tractates/', @xml:id, '.xml')"/>
            <xsl:attribute name="xpointer" select="@xml:id"/>
        </xsl:element>
        <xsl:result-document href="{concat($path-out,$dir-path,'/tractates/',@xml:id,'.xml')}">
            <TEI n="{@xml:id}">
                <xsl:apply-templates select="$headers/teiCorpus/TEI/teiHeader" mode="production">
                    <xsl:with-param name="div2_no" tunnel="yes" select="@xml:id"/>
                </xsl:apply-templates>
                <text>
                    <body>
                        <div type="tractate">
                            <xsl:copy-of select="@*"/>
                            <xsl:apply-templates mode="production"/>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="div3" mode="production">
        <div type="chapter">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="production"/>
        </div>
    </xsl:template>

    <xsl:template match="idno[@type = 'local']" mode="production">
        <xsl:param name="div2_no" tunnel="yes"/>
        <idno type="local">
            <xsl:value-of select="concat('yT', '.', $div2_no)"/>
        </idno>
        <xsl:message select="concat('yT', '.', $div2_no)"/>
    </xsl:template>

    <xsl:template match="span" mode="production">
        <xsl:param name="div2_no" tunnel="yes"/>
        <xsl:variable name="num" select="replace($div2_no, '.*\.(\d+\.\d+)', '$1')"/>
        <xsl:text>, Tractate </xsl:text>
        <xsl:value-of select="map:get($tractates, $num)"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$num"/>
        <xsl:text>)</xsl:text>
    </xsl:template>


    <xsl:template match="(head | trailer | ab | pc (:|fw:))[not(ancestor::teiHeader)]"
        mode="production">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:choose>
                <xsl:when test="$w-sep = 1">
                    <xsl:call-template name="tokenize-and-wrap">
                        <xsl:with-param name="nodes" select="node()"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="production"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="tokenize-and-wrap">
        <xsl:param name="nodes"/>
            <xsl:variable name="id" select="$nodes/parent::*/@xml:id"/>            
        <xsl:variable name="segmented">
            <xsl:for-each select="$nodes">
                <xsl:choose>
                    <xsl:when test="self::text()">
                        <xsl:analyze-string select="." regex="\s+">
                            <xsl:matching-substring/>
                            <xsl:non-matching-substring>
                                <w>
                                    <xsl:value-of select="."/>
                                </w>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:when test="self::*">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="production"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$segmented/*">
            <xsl:choose>
                <xsl:when test="self::w">
                    <w xml:id="{concat($id,'.',count(preceding-sibling::w) +1)}">
                        <xsl:apply-templates mode="production"></xsl:apply-templates>
                    </w>
                </xsl:when>
                <xsl:otherwise><xsl:copy-of select="."></xsl:copy-of></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:function name="local:cref">
        <xsl:param name="corresp"/>
        <xsl:variable name="no-prefix" select="replace($corresp, '^#[lpr]_(.+)$', '$1')"/>
        <xsl:value-of select="replace($corresp, '^#[lpr]_(.+)[\-_](eSc.+)$', '$1.xml#$2')"/>
    </xsl:function>

    <xsl:variable name="tractates" as="map(xs:string, xs:string)" select="
            map {
                '1': 'Zeraim',
                '1.1': 'Berakhot',
                '1.2': 'Peah',
                '1.3': 'Demai',
                '1.4': 'Kilayim',
                '1.5': 'Sheviit',
                '1.6': 'Terumot',
                '1.7': 'Maaserot',
                '1.8': 'Maaser Sheni',
                '1.9': 'Hallah',
                '1.10': 'Orla',
                '1.11': 'Bikkurim',
                '2': 'Moed',
                '2.1': 'Shabbat',
                '2.2': 'Eruvin',
                '2.3': 'Pesahim',
                '2.4': 'Sheqalim',
                '2.5': 'Yoma',
                '2.6': 'Sukkah',
                '2.7': 'Besah',
                '2.8': 'Rosh Hashanah',
                '2.9': 'Taanit',
                '2.10': 'Megillah',
                '2.11': 'Moed Qatan',
                '212': 'Hagigah',
                '3': 'Nashim',
                '3.1': 'Yebamot',
                '3.2': 'Ketubot',
                '3.3': 'Nedarim',
                '3.4': 'Nazir',
                '3.5': 'Sotah',
                '3.6': 'Gitin',
                '3.7': 'Qiddushin',
                '4': 'Nezikin',
                '4.1': 'Bava Qama',
                '4.2': 'Bava Metsia',
                '4.3': 'Bava Batra',
                '4.4': 'Sanhedrin',
                '4.5': 'Makkot',
                '4.6': 'Shevuot',
                '4.7': 'Eduyot',
                '4.8': 'Avodah Zarah',
                '4.9': 'Avot',
                '4.10': 'Horayot',
                '5': 'Qodashim',
                '5.1': 'Zevahim',
                '5.2': 'Menahot',
                '5.3': 'Hulin',
                '5.4': 'Bekhorot',
                '5.5': 'Arakhin',
                '5.6': 'Temurah',
                '5.7': 'Keritot',
                '5.8': 'Meilah',
                '5.9': 'Tamid',
                '5.10': 'Middot',
                '5.11': 'Qinnim',
                '6': 'Toharot',
                '6.1': 'Kelim',
                '6.2': 'Ohalot',
                '6.3': 'Negaim',
                '6.4': 'Parah',
                '6.5': 'Toharot',
                '6.6': 'Miqvaot',
                '6.7': 'Niddah',
                '6.8': 'Makhshirin',
                '6.9': 'Zabim',
                '6.10': 'Tevul Yom',
                '6.11': 'Yadayim',
                '6.12': 'Uqtsim'
            }"/>
</xsl:stylesheet>
