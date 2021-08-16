<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:PcGts="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="http://www.local.uri"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:functx="http://www.functx.com"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://schema.primaresearch.org/PAGE/gts/pagecontent/2019-07-15"
    exclude-result-prefixes="xs PcGts xsi tei local functx" version="2.0">
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:include href="sortTextRegionsForFacsimile.xsl"/>

     <xsl:param name="regionSelect" select="'Main Paratext'"/> 
     <xsl:variable name="regionTypesForColumns" select="tokenize($regionSelect, '\s+')"/>
    <xsl:param name="how_many_cols" select="'2'"></xsl:param>
    <xsl:param name="dataRoot"
        select="'file:///C:/Users/hlapin/Documents/GitHub/eRabbinica/escriptoriumToTEI/'"/>
    <xsl:param name="pageXMLIn" select="concat($dataRoot, 'pagexml/export_naples_ed_princ/Main_Paratext/')"/>
    <xsl:param name="outpath" select="concat($dataRoot, 'tei-facs/')"/>
    
    
    <!-- ideally this should flow from the metadata in escriptorium -->
    <xsl:param name="reposInfo" as="xs:string+"
        select="(
                (: project name :)
                'Naples ed. princ. of the Mishnah',
                (:our internal ID number:)
                'P1143297',
                (: Institution :)
                'NLI',
                (: Place :)
                'Jerusalem',
                (: shelfmark at institution :)
                '328-329',
                (: link to NLI catalog :)
                'https://www.nli.org.il/en/books/NNL_ALEPH001143297/NLI?volumeItem=3', 
                (: if print bibliography of Hebrew Book; if in Ktiv, Ktiv link :)
                'http://uli.nli.org.il:80/F/?func=direct&amp;doc_number=000150614&amp;local_base=MBI01'
                )"/> 

    <xsl:variable name="data"
        select="collection(iri-to-uri(concat($pageXMLIn, '?select=*.xml;recurse=no')))">
        <!-- to parameterize -->
    </xsl:variable>

    <xsl:template name="start">
        <xsl:result-document
            href="{concat($outpath,'/',$reposInfo[2],'/', $reposInfo[2],'-facs.xml' )}">
            <teiCorpus xml:id="{$reposInfo[2]}-eSc">
                <xsl:call-template name="corpusTeiHeader"/>
                <!-- only include pages that have text regions and string -->
                <xsl:apply-templates mode="reorder"
                    select="
                        for $page in $data
                        return
                            $page/PcGts/Page[//*:TextRegion/Coords and //Unicode[normalize-space(.)]]"
                />
            </teiCorpus>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="Page" mode="reorder">
        <xsl:message select="concat('processing xml for ',@imageFilename/string())"/>
        <xsl:variable name="current" select=".">
        </xsl:variable>
        <xsl:variable name="inMainText"
            select="
                TextRegion[TextLine/TextEquiv/Unicode[normalize-space(.)]]
                intersect
                (for $r in $regionTypesForColumns
                return
                    TextRegion[contains(@custom, $r)])
                "
        />
        <xsl:variable name="inMainTextSortedGrouped">
            <xsl:call-template name="sortAndSplit">
                <xsl:with-param name="Regions" select="$inMainText"/>
                <xsl:with-param name="num_columns" select="$how_many_cols"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="notInMainText"
            select="
                TextRegion[TextLine/TextEquiv/Unicode[normalize-space(.)]]
                except
                $inMainText
                " />
        
        
            <xsl:element name="xi:include">
                <xsl:attribute name="href" select="concat('pages/',$reposInfo[2],'_',@imageFilename,'-facs.xml')"></xsl:attribute>
            </xsl:element>
        
        <xsl:result-document href="{$outpath}{$reposInfo[2]}/pages/{$reposInfo[2]}_{@imageFilename}-facs.xml">
            <TEI>
                <!-- output link and result-document to be xincluded -->
                <!-- teiHeader -->
                <xsl:call-template name="teiHeader"/>
                <!-- facsimile -->
                <facsimile>
                    <surface ulx="0" uly="0" lrx="{@imageWidth}" lry="{@imageHeight}">
                        <graphic url="{@imageFilename}"/>
                        <!-- Regions in main body -->
                        <!-- note change in namespace -->
                        <xsl:apply-templates mode="facs"
                            select="
                                for $r in $inMainTextSortedGrouped/*/*
                                return
                                    TextRegion[@id eq $r/@id]"/>
                        <!-- regions not in main body -->
                        <xsl:apply-templates mode="facs" select="$notInMainText"/>
                    </surface>
                </facsimile>
                <!-- text / body / div ... -->
                <text>
                    <body>
                        <div>
                            <!-- Regions in main body -->
                                <pb xml:id="p_{$current/@imageFilename}"/>
                            <xsl:for-each select="$inMainTextSortedGrouped/tei:col">
                                <xsl:sort select="@n" order="ascending"></xsl:sort>
                                <cb xml:id="c_{$current/@imageFilename}-{@n}"></cb>
                                <xsl:apply-templates 
                                    mode="text"
                                    select="for $r in * return $current/TextRegion[./@id eq $r/@id]"/>
                            </xsl:for-each>
                            
                            <!-- regions not in main body -->
                            <milestone unit="pageSection" type="notInMain"/>
                            <xsl:apply-templates mode="text" select="$notInMainText"/>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
        
        </xsl:template>

    <xsl:template match="Page" mode="dummy">
        <Page>
            <image>
                <xsl:copy-of select="@*"/>
            </image>
            <xsl:copy-of select="../Metadata"/>
            <xsl:variable name="pageAvgRegXMax" select="local:avgRegXMax(.)[1]"/>

            <!-- split into column groups by rightmost points-->

            <xsl:variable name="regionsToColumnBlocks">
                <xsl:for-each-group
                    select="
                        for $r in //TextRegion
                        return
                            for $s in $regionTypesForColumns
                            return
                                $r[contains(@custom, $s)]"
                    group-by="local:minMaxX(Coords/@points)[2] lt number($pageAvgRegXMax[2])">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <column n="A">
                                <xsl:for-each select="current-group()">
                                    <xsl:sort order="ascending"
                                        select="number(local:minMaxY(Coords/@points)[2])"/>
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                                <!-- sort contents of column by largest y value in each region -->
                                <!--<xsl:apply-templates mode="reorder" select="current-group()">
                                    <xsl:sort order="ascending"
                                        select="number(local:minMaxY(Coords/@points)[2])"></xsl:sort>
                                </xsl:apply-templates>-->
                            </column>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- sort contents of column by largest y value in each region -->
                            <column n="B">
                                <xsl:apply-templates mode="reorder" select="current-group()">
                                    <xsl:sort order="ascending"
                                        select="number(tokenize(tokenize(Coords/@points, '\s')[1], ',')[2])"
                                    />
                                </xsl:apply-templates>
                            </column>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            <!--<xsl:variable name="sortedRegions" as="node()+">
                <xsl:apply-templates
                    select="$regionsToColumnBlocks/*:column"
                    mode="reorder">
                    <!-\- sort regions by y of first x,y pair -\->
                    <!-\-<xsl:sort order="ascending"
                        select="number(tokenize(tokenize(Coords/@points, '\s')[1], ',')[2])"/>-\->
                </xsl:apply-templates>
            </xsl:variable>-->
            <xsl:copy-of select="$regionsToColumnBlocks"/>
            <xsl:for-each-group
                select="
                    //TextRegion[@custom] except
                    (for $r in //TextRegion
                    return
                        for $s in $regionTypesForColumns
                        return
                            $r[contains(@custom, $s)])"
                group-by="@custom">
                <xsl:choose>
                    <xsl:when test="current-grouping-key()">
                        <milestone unit="{replace(current-grouping-key(),'.*\{type:(\w+);\}','$1')}">
                            <xsl:copy-of select="current-group()"/>
                        </milestone>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each-group>

            <milestone unit="fw">
                <xsl:copy-of select="TextRegion[not(@custom) or @id eq 'eSc_dummyblock_']"/>
            </milestone>
        </Page>
    </xsl:template>
<!--
    <xsl:template match="*:TextRegion" mode="reorder">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template mode="reorder" match="*:column">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="TextRegion" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>-->
    
    <xsl:function name="local:avgRegXMax" as="element()+">
        <!-- could not get this to return sequence of numerals, so shifted elements -->
        <xsl:param name="page"/>
        <xsl:variable name="regXMax" as="xs:double+">
            <xsl:for-each select="$page/Coords">
                <xsl:sequence
                    select="
                        max(for $xy in tokenize(@points, ' ')
                        return
                            for $x in tokenize($xy, ',')[2]
                            return
                                number($x))"
                />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sortedRegXMax" as="xs:double+">
            <xsl:perform-sort select="$regXMax">
                <xsl:sort order="ascending"/>
            </xsl:perform-sort>
        </xsl:variable>

        <!-- first value is mean, second value is median -->
        <mean>
            <xsl:sequence select="round(avg($sortedRegXMax))"/>
        </mean>
        <median>
            <xsl:sequence select="$sortedRegXMax[round(count($sortedRegXMax) div 2)]"/>
        </median>
    </xsl:function>

    <!-- header for corpus/master document -->
    <xsl:template name="corpusTeiHeader">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>
                        <xsl:text>An automatic transcription of </xsl:text>
                        <xsl:value-of select="$reposInfo[1]"/>
                        <xsl:text> using
                        escriptorium</xsl:text>
                    </title>
                    <editor>
                        <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                    </editor>
                    <respStmt>
                        <name/>
                        <resp/>
                    </respStmt>
                </titleStmt>
                <publicationStmt>

                    <publisher>eRabbinica/Digital Mishnah Project</publisher>
                    <pubPlace>What Place are We Saying?</pubPlace>
                    <address>
                        <addrLine>Blah Blah</addrLine>
                    </address>
                    <idno type="local">
                        <xsl:value-of select="$reposInfo[2]"/>
                    </idno>
                    <availability status="restricted">
                        <p>This work is copyright Hayim lapin and Daniel Stoekl ben Ezra and
                            licensed under a <ref
                                target="http://creativecommons.org/licensesby/4.0//">Creative
                                Commons Attribution International 4.0 License</ref>.</p>
                    </availability>
                    <pubPlace>PLACE</pubPlace>
                    <date>
                        <xsl:value-of select="current-dateTime()"/>
                    </date>
                </publicationStmt>
                <notesStmt>
                    <note>Automated transcription using <ref
                            target="https://gitlab.com/scripta/escriptorium"
                        >escriptorium</ref></note>
                </notesStmt>
                <sourceDesc>
                    <msDesc>
                        <!-- dynamic content during transformation -->
                        <!-- ideally should pull from project specific metadata in escriptorium -->
                        <!-- but not very much of the metada is exported in pagexml -->
                        <msIdentifier>
                            <settlement>
                                <xsl:value-of select="$reposInfo[4]"/>
                            </settlement>
                            <repository>
                                <xsl:value-of
                                    select="string-join(($reposInfo[3], $reposInfo[5]), ', ')"/>
                            </repository>
                            <idno type="nli" corresp="{$reposInfo[6]}">
                                <xsl:value-of
                                    select="replace($reposInfo[6],'.*doc_number=0+(\d+)&amp;*','$1')"
                                />
                            </idno>
                            <altIdentifier>
                                <xsl:choose>
                                    <xsl:when test="contains($reposInfo[7], 'PNX_MANUSCRIPTS')">
                                        <collection>KTIV: Digitized Hebrew Manuscripts</collection>
                                        <idno type="ktiv" corresp="{$reposInfo[7]}">
                                            <xsl:value-of
                                                select="substring-after($reposInfo[7], 'PNX_MANUSCRIPTS')"
                                            />
                                        </idno>

                                    </xsl:when>
                                    <xsl:when test="$reposInfo[7]">
                                        <collection>Bibliography of the Hebrew Book</collection>
                                        <idno type="bhb" corresp="{$reposInfo[7]}">
                                            <xsl:value-of
                                                select="replace($reposInfo[7],'.*doc_number=0+(\d+)&amp;*','$1')"
                                            />
                                        </idno>
                                    </xsl:when>
                                </xsl:choose>
                            </altIdentifier>
                        </msIdentifier>

                    </msDesc>

                </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:template>
    
    <xsl:template name="teiHeader-test">
        <tempHeader><xsl:copy-of select="@imageFilename"></xsl:copy-of>
        <xsl:copy-of select="ancestor::*:PcGts/*:Metadata"></xsl:copy-of></tempHeader>
    </xsl:template>
    <!-- Header for individual tei docs -->
    <xsl:template name="teiHeader">
        <xsl:variable name="image" select="@imageFilename/string()"/>
        <xsl:variable name="metadata" select="ancestor::PcGts/Metadata"/>
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <!-- dynamic -->
                    <title>Automated Transcription of <xsl:value-of
                            select="string-join(($reposInfo[2], $image), ' ')"/>
                        using Escriptorium</title>
                    <respStmt>
                        <resp>Placeholder</resp>
                        <name>Placeholder</name>
                    </respStmt>
                </titleStmt>
                <publicationStmt>
                    <p>Publication Information</p>
                </publicationStmt>
                <sourceDesc>
                    <p>Information about the source</p>
                </sourceDesc>

            </fileDesc>
            <xenoData>
                <!-- dynamic from Page XML -->
                <xsl:copy-of select="$metadata"/>
            </xenoData>
        </teiHeader>
    </xsl:template>

    <!-- facsimile -->
    <xsl:template name="facsimile">
        <!--<xsl:param name="image"/>-->
        
    </xsl:template>

    <xsl:template match="*:column" mode="facs">
        <!-- this is not part of the pagexml, so I skip it here -->
        <!--<xsl:comment>Columns would go here. </xsl:comment>
        <xsl:comment>Generate derived columns [and @points] for from embedded regions?</xsl:comment>-->
        <xsl:apply-templates mode="facs"/>
    </xsl:template>

    <xsl:template match="TextRegion" mode="facs">
        <!-- insert image name to avoid id clash across corpus -->
        <xsl:variable name="imageName" select="substring-before(ancestor::Page/@imageFilename,'.')"/>
        <!--<xsl:variable name="imageName"
            select="substring-before(ancestor::Page/@imageFilename, '.')"/>-->
        <zone xml:id="{concat('r_',$imageName,'-',@id)}" type="region"
            points="{if (count(tokenize(Coords/@points, '\s')) &gt;= 3) 
                    then
                        Coords/@points 
                    else if (count(tokenize(Coords/@points, '\s')) &lt; 3 )  
                    then 
                    string-join((Coords/@points,
                    for $n in 1 to 3 - count(tokenize(Coords/@points, '\s')) return '99999,99999'),' ')
                        else ()    }">
            <xsl:apply-templates mode="facs"/>
        </zone>
    </xsl:template>

    <xsl:template match="TextLine" mode="facs">

        <!-- insert image name to avoid id clash across corpus -->
        <xsl:variable name="imageName"
            select="substring-before(ancestor::Page/@imageFilename, '.')"/>
        <zone xml:id="{concat('l_',$imageName,'-',@id)}" type="line"
            points="{if (count(tokenize(Coords/@points, '\s')) &gt; 2) 
                    then
                        Coords/@points 
                    else if (count(tokenize(Coords/@points, '\s')) &lt;=3 )  
                    then 
                        string-join((Coords/@points,'99999,99999'),' ')
                    else ()    }"/>
    </xsl:template>


    <!-- transcription -->
    <xsl:template name="text">
        <text>
            <div type="page">
                <xsl:apply-templates mode="text"/>
            </div>
        </text>
    </xsl:template>

    <xsl:template match="Metadata | image" mode="text"/>

    <xsl:template match="*:column" mode="text">
        <xsl:param name="imageFilename"/>
        <cb xml:id="f_{$imageFilename}-x-eq-{@n}"/>
        <xsl:apply-templates mode="text"/>
    </xsl:template>
    <xsl:template match="*:milestone" mode="text">
        <xsl:param name="imageFilename"/>
        <milestone xml:id="f_{$imageFilename}-{@unit}" unit="{@unit}"/>
        <xsl:apply-templates select="*:TextRegion" mode="text"/>
    </xsl:template>

    <xsl:template match="TextRegion" mode="text">
        <!-- insert image name to avoid id clash across corpus -->
        <xsl:variable name="imageName"
            select="substring-before(ancestor::*:Page/@imageFilename, '.')"/>
        <ab corresp="#{concat('r_',$imageName,'-',@id)}"
            type="{if (@custom) then replace(@custom,'.*\{type:(\w+);\}','$1') else '-fw'}">
            <xsl:apply-templates mode="text"/>
        </ab>
    </xsl:template>

    <xsl:template match="TextLine" mode="text">
        <!-- better way to enforce returns ...? -->
        <xsl:value-of select="'&#xa;'"/>

        <!-- insert image name to avoid id clash across corpus -->
        <xsl:variable name="imageName"
            select="substring-before(ancestor::Page/@imageFilename, '.')"/>
        <l corresp="#{concat('l_',$imageName,'-',@id)}">
            <xsl:copy-of select="TextEquiv/Unicode/comment()"/>
            <xsl:value-of select="normalize-space(TextEquiv/Unicode)"/>
        </l>
    </xsl:template>

    <xsl:function name="local:minMaxX">
        <!-- takes sequence of xy points -->
        <!-- returns (minx, max) from sequence -->
        <xsl:param name="points"/>
        <xsl:sequence
            select="
                (for $xy in $points
                return
                    min(for $x in tokenize($xy, ' ')
                    return
                        number(substring-before($x, ','))),
                max(for $xy in $points
                return
                    for $x in tokenize($xy, ' ')
                    return
                        number(substring-before($x, ','))))"
        />
    </xsl:function>

    <xsl:function name="local:minMaxY">
        <!-- takes sequence of xy points -->
        <!-- returns (miny, maxy) from sequence -->
        <xsl:param name="points"/>
        <xsl:sequence
            select="
                (for $xy in $points
                return
                    min(for $y in tokenize($xy, ' ')
                    return
                        number(substring-after($y, ','))),
                max(for $xy in $points
                return
                    for $y in tokenize($xy, ' ')
                    return
                        number(substring-after($y, ','))))"
        />
    </xsl:function>

    <xsl:function name="functx:is-value-in-sequence" as="xs:boolean">
        <xsl:param name="value" as="xs:anyAtomicType?"/>
        <xsl:param name="seq" as="xs:anyAtomicType*"/>

        <xsl:sequence select="
                $value = $seq
                "/>

    </xsl:function>

    <xsl:function name="functx:pad-integer-to-length" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>

        <xsl:sequence
            select="
                if ($length &lt; string-length(string($integerToPad)))
                then
                    error(xs:QName('functx:Integer_Longer_Than_Length'))
                else
                    concat
                    (functx:repeat-string(
                    '0', $length - string-length(string($integerToPad))),
                    string($integerToPad))
                "/>

    </xsl:function>

    <xsl:function name="functx:repeat-string" as="xs:string" xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>

        <xsl:sequence
            select="
                string-join((for $i in 1 to $count
                return
                    $stringToRepeat),
                '')
                "/>

    </xsl:function>



</xsl:stylesheet>
