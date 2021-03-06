<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xi="http://www.w3.org/2001/XInclude" xmlns="http://www.tei-c.org/ns/1.0"
   xmlns:local="http://www.local-functions.uri" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="xs local" version="2.0">
   <xsl:import href="convertCrossRefs.xsl"/>
   <xsl:output encoding="UTF-8" indent="yes"/>


   <xsl:variable name="teiHeader">
      <teiHeader>

         <fileDesc>
            <titleStmt>
               <title>An Electronic Edition of the Talmud Yerushalmi</title>
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
               <sponsor n="primary">Joseph and Rebecca Meyerhoff Center for Jewish Studies</sponsor>
            </titleStmt>
            <publicationStmt>
               <publisher>eRabbinica</publisher>
               <pubPlace>...</pubPlace>
               <address>
                  <addrLine>...</addrLine>
               </address>
               <idno type="local">ref-y</idno>
               <availability status="restricted">
                  <p>This work is copyright Hayim Lapin and the Joseph and Rebecca Meyerhoff Center
                     for Jewish Studies and licensed under a <ref
                        target="http://creativecommons.org/licenses/by-sa/4.0//">Creative Commons
                        Attribution International 4.0 License</ref> except where otherwise
                     constrained by Mechon Mamre.</p>
               </availability>
               <pubPlace>College Park, MD USA</pubPlace>
               <date>2018-09-03</date>
            </publicationStmt>
            <notesStmt>
               <note>
                  <p>Talmud Yerushalmi from <ref target="http://www.mechon-mamre.org"
                        >mechon-mamre</ref>. Rights reserved by organization.</p>
                  <p>Based on the 1898 Piotrokow Edition</p>
                  <p>Edited and converted by TEI/XML by Hayim Lapin</p>
               </note>
            </notesStmt>

            <sourceDesc>
               <biblStruct xml:id="tba">
                  <monogr>
                     <title xml:lang="en">Talmud Yerushalmi</title>
                     <title xml:lang="he">תלמוד ירושליי</title>
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
      <!-- sub documents -->
      <xsl:variable name="pathIn" select="'../data/html/'"/>
      <xsl:variable name="pathOut" select="'../data/xml/ref-y/'"/>
      <xsl:variable name="docs"
         select="collection(concat($pathIn, '?select=ref-y*.xml?;recurse=yes'))"/>
      <xsl:for-each select="$docs">
         <xsl:sort select="root/@id" order="ascending"/>
         <xsl:result-document href="{concat($pathOut,'ref-y-',/root/@id,'.xml')}" method="xml"
            encoding="UTF-8">
            <xsl:apply-templates select="/"/>
         </xsl:result-document>
      </xsl:for-each>

      <!-- containing documents -->

      <TEI xml:id="ref-y" xmlns:xi="http://www.w3.org/2001/XInclude">
         <xsl:copy-of select="$teiHeader"/>
         <text>
            <body>
               <xsl:variable name="tracts" select="$docs/root/@id"/>
               <div type="order" xml:id="ref-y.01" n="Zeraim">
                  <xsl:for-each select="$tracts[starts-with(., '01')]">
                     <xsl:sort order="ascending"/>
                     <xsl:element name="xi:include">
                        <xsl:attribute name="href">ref-y/ref-y-<xsl:value-of select="."
                           />.xml</xsl:attribute>
                     </xsl:element>
                  </xsl:for-each>
               </div>
               <div type="order" xml:id="ref-y.02" n="Moed">
                  <xsl:for-each select="$tracts[starts-with(., '02')]">
                     <xsl:sort order="ascending"/>
                     <xsl:element name="xi:include">
                        <xsl:attribute name="href">ref-y/ref-y-<xsl:value-of select="."
                           />.xml</xsl:attribute>
                     </xsl:element>
                  </xsl:for-each>
               </div>
               <div type="order" xml:id="ref-y.03" n="Nashim">
                  <xsl:for-each select="$tracts[starts-with(., '03')]">
                     <xsl:sort order="ascending"/>
                     <xsl:element name="xi:include">
                        <xsl:attribute name="href">ref-y/ref-y-<xsl:value-of select="."
                           />.xml</xsl:attribute>
                     </xsl:element>
                  </xsl:for-each>
               </div>
               <div type="order" xml:id="ref-y.04" n="Neziqin">
                  <xsl:for-each select="$tracts[starts-with(., '04')]">
                     <xsl:sort order="ascending"/>
                     <xsl:element name="xi:include">
                        <xsl:attribute name="href">ref-y/ref-y-<xsl:value-of select="."
                           />.xml</xsl:attribute>
                     </xsl:element>
                  </xsl:for-each>
               </div>
               <div type="order" xml:id="ref-y.06" n="Toharot">
                  <xsl:for-each select="$tracts[starts-with(., '06')]">
                     <xsl:element name="xi:include">
                        <xsl:attribute name="href">ref-y/ref-y-<xsl:value-of select="."
                           />.xml</xsl:attribute>
                     </xsl:element>
                  </xsl:for-each>
               </div>
            </body>
         </text>

      </TEI>
   </xsl:template>

   <xsl:template match="/">
      <xsl:variable name="docRoot" select="/"/>
      <xsl:variable name="id" select="root/@id"/>
      <xsl:variable name="name" select="root/@name"/>
      <xsl:variable name="tractID"
         select="concat('ref-y.', substring($id, 1, 2), '.', substring($id, 3, 2))"/>
      <xsl:message>
         <xsl:value-of select="root/@*"/>
      </xsl:message>
      <xsl:variable name="regex" select="'.*(פרק [א-ת]{1,2}\s+.*הלכה\s+א\s+גמרא.*).*'"/>
      <xsl:variable name="chaptersHeads" as="element()*">
         <xsl:for-each select="root/body/div/p/b[not(contains(., 'משנה'))]">
            <xsl:choose>
               <xsl:when test="not(preceding::b)">
                  <xsl:sequence select="."/>
               </xsl:when>
               <xsl:when
                  test="matches(., $regex) and replace(., $regex, '$1') ne replace(preceding::b[not(contains(., 'משנה'))][1], $regex, '$1')">
                  <xsl:sequence select="."/>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <div type="tractate" xml:id="{$tractID}" n="{$name}"
         xmlns:xi="http://www.w3.org/2001/XInclude">
         <xsl:for-each-group select="/root/body/div/p"
            group-starting-with="p[exists(b intersect $chaptersHeads)]">
            <xsl:variable name="chaptID"
               select="
                  concat($tractID, '.', for $i in 1 to count($chaptersHeads)
                  return
                     $i[$chaptersHeads[$i] is current-group()[1]/b[1]])"/>
            <xsl:if test="matches(current-group()[1], $regex)">
               <div type="chapter" xml:id="{$chaptID}">
                  <ab xml:id="{$chaptID}.00">
                     <xsl:apply-templates
                        select="current-group()[not(self::p[contains(b, 'משנה')])]"
                     />
                  </ab>
               </div>
            </xsl:if>
         </xsl:for-each-group>
      </div>
      <!--<div type="tractate" xml:id="{$tractID}" n="{$name}"
         xmlns:xi="http://www.w3.org/2001/XInclude">
         <xsl:for-each select="$chaptersHeads/b">
            <xsl:variable name="this" select="."/>
            <xsl:variable name="chaptID"
               select="concat($tractID, '.', count(preceding-sibling::b) + 1)"/>
            <xsl:choose>
               <xsl:when test="position() = last()">
                  <div type="chapter" xml:id="{$chaptID}">
                     <ab xml:id="{$chaptID}.00">
                        <xsl:apply-templates
                           select="$docRoot/*/*/*/p[b eq $this] | ($docRoot/*/*/*/p[b eq $this]/following-sibling::p)[not(contains(b, 'משנה'))]"
                        />
                     </ab>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="next" select="following::b[1]"/>
                  <div type="chapter" xml:id="{$chaptID}">
                     <ab xml:id="{$chaptID}.00">
                        <xsl:apply-templates
                           select="$docRoot/*/*/*/p[b eq $this] | ($docRoot/*/*/*/p[b eq $this]/following::p[following::p[b &lt;&lt; $next]])[not(contains(b, 'משנה'))]"
                        />
                     </ab>
                  </div>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </div>-->
   </xsl:template>
   <xsl:template match="p">
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="b">
      <label type="mechon-mamre-Piotrokow">
         <xsl:value-of select="normalize-space(.)"/>
      </label>
   </xsl:template>
   <xsl:template match="text()">
      <xsl:call-template name="angular">
         <xsl:with-param name="str" select="."/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="angular">
      <xsl:param name="str"/>
      <xsl:analyze-string select="$str" regex="&lt;([^&lt;]+?)&gt;">
         <xsl:matching-substring>
            <seg type="type-2" rend="angle_brackets">
               <xsl:call-template name="squBrackets">
                  <xsl:with-param name="str" select="regex-group(1)"/>
               </xsl:call-template>
            </seg>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:call-template name="squBrackets">
               <xsl:with-param name="str" select="."/>
            </xsl:call-template>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   <xsl:template name="squBrackets">
      <xsl:param name="str"/>
      <xsl:analyze-string select="$str" regex="\[([^\]]+?)\]">
         <xsl:matching-substring>
            <seg type="type-1" rend="square_brackets">
               <!--<xsl:value-of select="regex-group(1)"/>-->
               <xsl:call-template name="parens">
                  <xsl:with-param name="str" select="regex-group(1)"/>
               </xsl:call-template>
            </seg>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:call-template name="parens">
               <xsl:with-param name="str" select="."/>
            </xsl:call-template>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   <xsl:template name="parens">
      <xsl:param name="str"/>
      <xsl:analyze-string regex="\(([^\)]+?)\)" select="$str">
         <xsl:matching-substring>
            <xsl:variable name="toTest" select="normalize-space(regex-group(1))"/>
            <xsl:variable name="results"
               select="
                  for $t in tokenize($toTest, ';')
                  return
                     local:convertCrossRefs($t)"/>
            <xsl:choose>
               <xsl:when test="$results[self::*:use]">
                  <ref target="{string-join($results[self::*:use],' ')}"
                     n="{translate(normalize-space(regex-group(1)),' ','_')}"/>
               </xsl:when>
               <xsl:otherwise>
                  <seg type="checkMe">
                     <xsl:call-template name="punct">
                        <xsl:with-param name="str" select="$results"/>
                     </xsl:call-template>
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
      <xsl:analyze-string select="$str" regex="[\.,:]">
         <xsl:matching-substring>
            <pc type="{if (. = ':') then 'unitEnd' else 'stop'}">
               <xsl:value-of select="."/>
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
      <xsl:variable name="apos">['"]</xsl:variable>
      <xsl:analyze-string select="$str" regex="{$apos}">
         <xsl:matching-substring>
            <am type="{if (. = '''') then 'geresh' else 'gershayyim'}">
               <xsl:value-of select="."/>
            </am>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:value-of select="."/>
            <!--<xsl:call-template name="wrap">
               <xsl:with-param name="str" select="."/>-->
            <!--</xsl:call-template>-->
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   <xsl:template name="wrap">
      <xsl:param name="str"/>
      <!--<xsl:value-of select="replace(concat(normalize-space($str),' '),
         '(.{0,60}) ',
         '$1&#xA;')"/>-->
      <xsl:value-of select="normalize-space(.)"/>
   </xsl:template>
</xsl:stylesheet>
