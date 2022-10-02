<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="local.functions.uri"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei local" version="2.0">
    <xsl:output indent="yes"/>

    <xsl:param name="dict-source"
        select="'zip:file:/C:/Users/hlapin/Documents/GitHub/mishnah/xsl-external/dicta-to-maf-values.xlsx!/xl/worksheets/sheet1.xml'"/>
    <xsl:param name="morph-source"
        select="'zip:file:/C:/Users/hlapin/Documents/GitHub/mishnah/xsl-external/IntermediateMekMorph-extract.xlsx!/xl/worksheets/sheet1.xml'"/>

    <xsl:import href="extractExcelCellsModifiedForPipelining.xsl"/>

    <xsl:key name="dict" match="local:row" use="local:Dicta"/>

    <xsl:variable name="dict-data">
        <xsl:call-template name="start_excel">
            <xsl:with-param name="xl-path" tunnel="yes" select="$dict-source"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="morph-data">
        <xsl:call-template name="start_excel">
            <xsl:with-param name="xl-path" tunnel="yes" select="$morph-source"/>
        </xsl:call-template>
    </xsl:variable>
    
    
    <xsl:variable name="niqqud" select="'[&#x591;-&#x5c7;]+'"/>

    <xsl:template name="start">
        <TEI>
            <xsl:copy-of select="$tei_Header"/>
            <text>
                <xsl:copy-of select="$feats"/>
                <body>
                    <div>
                        <xsl:for-each-group select="$morph-data//*:row"
                            group-by="translate(concat(local:surface, '_', *:bitmap), '&apos;&apos;&quot;&quot;', '')">
                            <xsl:variable name="first" select="current-group()[1]"/>
                            <xsl:variable name="surf-voc"
                                select="replace($first/local:tokenized, '\|', '')"/>
                            <entryFree
                                xml:id="{translate(concat(local:translit($first/local:surface),'_',$first/local:bitmap),'''&quot;&quot;','')}">
                                <w lemma="{local:translit($first/local:lexeme)}">
                                    <seg type="uncorrected-surface-values">
                                        <xsl:for-each
                                            select="distinct-values(current-group()/*:surface)">
                                            <span n="some_identifier">
                                                <xsl:value-of select="."/>
                                            </span>
                                        </xsl:for-each>
                                    </seg>
                                    <span type="lemma">
                                        <xsl:value-of select="$first/local:lexeme"/>
                                    </span>
                                    <span type="vocalized-surface">
                                        <xsl:value-of select="$surf-voc"/>
                                    </span>
                                    <span type="unvocalized-surface">
                                        <xsl:value-of select="replace($surf-voc, $niqqud, '')"/>
                                    </span>
                                    <choice>
                                        <xsl:variable name="prefixes" select="
                                                $first/(local:waw | article | local:interrogat |
                                                local:preposition | local:relative | local:temporal |
                                                local:adverbial)"/>
                                        <seg>
                                            <xsl:if test="$prefixes">
                                                <m function="pref" select="{for $p in $prefixes 
                                                    return key('dict',$p/text(),$dict-data)/local:values}">
                                                  <xsl:value-of
                                                  select="substring-before($first/local:tokenized, '|')"
                                                  />
                                                </m>
                                            </xsl:if>
                                            <m function="main"
                                                ana="{for $m in $first/(local:POS|local:POS/following-sibling::*[preceding-sibling::local:suffix_function]) 
                                                    return key('dict',$m/text(),$dict-data)/local:values}">
                                                <xsl:value-of select="
                                                        if (not(contains($first/local:tokenized, '|'))) then
                                                            $first/local:tokenized
                                                        else
                                                        substring-after($first/local:tokenized, '|')"/>
                                            </m>
                                            <xsl:if
                                                test="$first/local:suffix_function/normalize-space()">
                                                <m function="suff"
                                                  ana="{for $s in $first/(local:suffix_function|local:suffix_function/following-sibling::*)[normalize-space()]
                                                        return  key('dict',$s/text(),$dict-data)/local:values}"
                                                />
                                            </xsl:if>
                                        </seg>
                                    </choice>

                                </w>
                                <ptr
                                    target="{for $v in distinct-values(current-group()/local:eRab_ID) return concat('path-to-file#MekhY.M117.',$v)}"
                                />
                            </entryFree>
                            <!--<raw><xsl:copy-of select="current-group()[1]"></xsl:copy-of></raw>-->
                        </xsl:for-each-group>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>

    <xsl:function name="local:translit">
        <xsl:param name="in"/>
        <xsl:value-of
            select="replace(translate($in, 'אבגדהוזחטיכךלמםנןסעפףצץקרששׁשׂת', 'abgdhwzHTykKlmMnNsepPcCqrSSZt'),$niqqud,'')"
        />
    </xsl:function>
    <xsl:variable name="tei_Header">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Title</title>
                </titleStmt>
                <publicationStmt>
                    <p>Publication Information</p>
                </publicationStmt>
                <sourceDesc>
                    <p>Information about the source</p>
                </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:variable>

    <xsl:variable name="feats">
        <fLib n="parts_of_speech" xml:id="POS">
            <f name="POS" xml:id="POS.v">
                <symbol value="VERB"/>
            </f>
            <f name="POS" xml:id="POS.n">
                <symbol value="NOUN"/>
            </f>
            <f name="POS" xml:id="POS.pNoun">
                <symbol value="PROPERNAME"/>
            </f>
            <f name="POS" xml:id="POS.pron">
                <symbol value="PRONOUN"/>
            </f>
            <f name="POS" xml:id="POS.ptcpl">
                <symbol value="PARTICIPLE"/>
            </f>
            <f name="POS" xml:id="POS.adj">
                <symbol value="ADJECTIVE"/>
            </f>
            <f name="POS" xml:id="POS.adv">
                <symbol value="ADVERB"/>
            </f>
            <f name="POS" xml:id="POS.prep">
                <symbol value="PREPOSITION"/>
            </f>
            <f name="POS" xml:id="POS.numer.num">
                <symbol value="NUMERAL"/>
            </f>
            <f name="POS" xml:id="POS.numer.card">
                <symbol value="CARDINAL"/>
            </f>
            <f name="POS" xml:id="POS.numer.ord">
                <symbol value="ORDINAL"/>
            </f>
            <f name="POS" xml:id="POS.numer.other">
                <symbol value="OTHER_NUMERICAL"/>
            </f>
            <f name="POS" xml:id="POS.conj">
                <symbol value="CONJUNCTION"/>
            </f>
            <f name="POS" xml:id="POS.interj">
                <symbol value="INTERJECTION"/>
            </f>
            <f name="POS" xml:id="POS.interr">
                <symbol value="INTERROGATIVE"/>
            </f>
            <!-- listed under POS, because excel data does -->
            <f name="POS" fVal="#vb.type.copul">
                <symbol value="COPULA"/>
            </f>
            <f name="POS" fVal="#vb.type.exist">
                <symbol value="EXISTENTIAL"/>
            </f>
            <f name="POS" fVal="#vb.type.modal"/>
            <f name="POS" xml:id="POS.neg">
                <symbol value="NEGATION"/>
            </f>
            <f name="POS" xml:id="POS.quant">
                <symbol value="QUANTIFIER"/>
            </f>
            <f name="POS" xml:id="POS.AT">
                <!-- Hebrew particle et -->
                <symbol value="AT_PREP"/>
            </f>
            <f name="POS" xml:id="POS.shel">
                <symbol value="SHEL_PREP"/>
            </f>
            <f name="POS" xml:id="POS.titul">
                <symbol value="TITULAR"/>
            </f>
            <f name="POS" xml:id="POS.pref" ana="#prefType">
                <!-- redirected to prefix types for analysis -->
                <!-- Not currently an independent POS in our encoding -->
                <!-- But exists in data from Dicta? -->
                <symbol value="PREFIX"/>
            </f>

            <f name="POS" xml:id="POS.for">
                <!--<symbol value="FOR"/>-->
                <symbol value="FOREIGN"/>
            </f>

            <!-- some issues need to be sorted out -->

            <f name="POS" xml:id="POS.other">
                <symbol value="other" ana="#otherStuff"/>
            </f>
        </fLib>

        <fLib n="morphological_features" xml:id="morph">
            <f name="morphFeat" xml:id="pref">
                <symbol value="prefix"/>
            </f>
            <f name="morphFeat" xml:id="suff">
                <symbol value="suffix"/>
            </f>
            <f name="morphFeat" xml:id="rt" xmlns:dcr="http://www.isocat.org/ns/dcr"
                dcr:valueDatcat="http://www.isocat.org/ns/dcr/DC-2231">
                <symbol value="root"/>
            </f>
            <f name="morphFeat" xml:id="stem" xmlns:dcr="http://www.isocat.org/ns/dcr"
                dcr:valueDatcat="http://www.isocat.org/ns/dcr/DC-1389">
                <symbol value="stem"/>
            </f>
            <f name="morphFeat" xml:id="base" xmlns:local="http://localhost.uri"
                fVal="http://localhost.uri#base">
                <!-- Documentation here or in header-->
                <!-- Does this need a local URI -->
                <symbol value="base"/>
            </f>
        </fLib>

        <fLib n="stems" corresp="#stem">
            <f name="stem" xml:id="stm.paal">
                <symbol value="paal"/>
            </f>
            <f name="stem" xml:id="stm.nif">
                <symbol value="nifal"/>
            </f>
            <f name="stem" xml:id="stm.piel">
                <symbol value="piel"/>
            </f>
            <f name="stem" xml:id="stm.pual">
                <symbol value="pual"/>
            </f>
            <f name="stem" xml:id="stm.hifil">
                <symbol value="hifil"/>
            </f>
            <f name="stem" xml:id="stm.hofal">
                <symbol value="hofal"/>
            </f>
            <f name="stem" xml:id="stm.hufal">
                <symbol value="hufal"/>
            </f>
            <f name="stem" xml:id="stm.hitp">
                <symbol value="hitpael"/>
            </f>
            <f name="stem" xml:id="stm.nitp">
                <symbol value="nitpael"/>
            </f>
        </fLib>

        <fLib n="person" xml:id="pers">
            <!-- person -->
            <f name="person" xml:id="pers.1">
                <!-- corresponds to Dicta: 1 -->
                <symbol value="first"/>
            </f>
            <f name="person" xml:id="pers.2">
                <!-- corresponds to Dicta: 2 -->
                <symbol value="second"/>
            </f>
            <f name="person" xml:id="pers.3">
                <!-- corresponds to Dicta: 3 -->
                <symbol value="third"/>
            </f>
            <f name="person" xml:id="pers.any">
                <!-- corresponds to Dicta: ANY -->
                <symbol value="any"/>
            </f>

        </fLib>
        <fLib n="number" xml:id="num">
            <f name="number" xml:id="num.sg">
                <!-- corresponds to Dicta: sg -->
                <symbol value="singular"/>
            </f>
            <f name="number" xml:id="num.d">
                <!-- corresponds to Dicta: d -->
                <symbol value="dual"/>
            </f>
            <f name="number" xml:id="num.pl">
                <!-- corresponds to Dicta: pl -->
                <symbol value="plural"/>
            </f>
            <f name="number" xml:id="num.sgpl">
                <!-- corresponds to Dicta: sgpl -->
                <symbol value="singular_or_plural"/>
            </f>
            <f name="number" xml:id="num.dpl">
                <symbol value="dual_or_plural"/>
            </f>
        </fLib>
        <fLib n="gender" xml:id="gend">
            <f name="gender" xml:id="gend.m">
                <!-- corresponds to Dicta: m -->
                <symbol value="masculine"/>
            </f>
            <f name="gender" xml:id="gend.f">
                <!-- corresponds to Dicta: f -->
                <symbol value="feminine"/>
            </f>
            <f name="gender" xml:id="gend.mf">
                <!-- corresponds to Dicta: mf -->
                <symbol value="masculine_or_feminine"/>
            </f>
        </fLib>

        <!-- verbs -->
        <fLib n="tense_mood" xml:id="vb.tm">
            <!-- Tense and mood -->
            <f name="tenseMood" xml:id="vb.tm.any">
                <!-- corresponds to Dicta "ALLTIME" -->
                <symbol value="perfect"/>
            </f>
            <f name="tenseMood" xml:id="vb.tm.perf">
                <!-- corresponds to Dicta "PAST" -->
                <symbol value="perfect"/>
            </f>
            <f name="tenseMood" xml:id="vb.tm.impf">
                <!-- corresponds to Dicta "FUTURE" -->
                <symbol value="imperfect"/>
            </f>
            <f name="tenseMood" xml:id="vb.tm.ptcpl">
                <!-- corresponds to Dicta "PRESENT" -->
                <symbol value="participial_present"/>
            </f>
            <f name="tenseMood" xml:id="vb.tm.imptv">
                <!-- corresponds to Dicta "IMP" -->
                <symbol value="imperative"/>
            </f>
            <!-- not properly a tense or mood but ... -->
            <f name="tenseMood" xml:id="vb.tm.constr_infin">
                <!-- corrresponds to Daniel's classification "TOINF" -->
                <symbol value="constr_infin"/>
            </f>
            <f name="tenseMood" xml:id="vb.tm.abs_infin">
                <!-- Corresponds to Daniel's classification "BARINF" -->
                <symbol value="abs_infin"/>
            </f>

        </fLib>
        <fLib n="type" xml:id="vb.type">
            <!-- Verb type -->
            <f name="vType" xml:id="vb.type.exist">
                <symbol value="existential"/>
            </f>
            <f name="vType" xml:id="vb.type.copul">
                <symbol value="copula"/>
            </f>
            <f name="vType" xml:id="vb.type.modal">
                <symbol value="modal"/>
            </f>
            <!-- following should be incorporated into #vb.copul -->
            <!-- not currently in dicta output -->
            <!-- polarity (with copula and existential verbs) -->
            <f name="polarity" xml:id="posit">
                <symbol value="positive"/>
            </f>
            <f name="polarity" xml:id="neg">
                <symbol value="negative"/>
            </f>
        </fLib>

        <!-- Nouns, adjectives, participles -->
        <fLib n="state" xml:id="stt" corresp="#POS.n #POS.adj #POS.ptcpl">
            <f name="state" xml:id="stt.abs">
                <symbol value="abs"/>
            </f>
            <f name="state" xml:id="stt.constr">
                <symbol value="cstr"/>
            </f>
            <f name="state" xml:id="stt.abs_or_cstr">
                <symbol value="abscstr"/>
            </f>
        </fLib>
        <fLib n="definiteness" xml:id="def" ana="#POS.n #POS.adj #POS.ptcpl">
            <f name="definiteness" xml:id="def.y">
                <symbol value="definite"/>
            </f>
            <f name="definiteness" xml:id="def.n">
                <symbol value="indefinite"/>
            </f>
        </fLib>

        <!-- pronouns -->
        <fLib n="pronoun_type" xml:id="pron.type">
            <f name="pronType" xml:id="pron.type.poss">
                <symbol value="possessive"/>
            </f>
            <f name="pronType" xml:id="pron.type.pronom">
                <symbol value="pronomial"/>
            </f>
            <f name="pronType" xml:id="pron.type.accnom">
                <symbol value="accusative_or_nominative"/>
            </f>
        </fLib>

        <!-- participles -->
        <fLib n="participle_functions" xml:id="funct">
            <f name="participleFunction" xml:id="verbal">
                <symbol value="verbal"/>
            </f>
            <f name="participleFunction" xml:id="subst">
                <symbol value="substantive"/>
            </f>
        </fLib>

    </xsl:variable>




</xsl:stylesheet>
