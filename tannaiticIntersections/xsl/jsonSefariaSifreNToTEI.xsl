<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.tei-c.org/ns/1.0"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:local="http://www.local-functions.uri"
   xmlns:j="http://www.w3.org/2013/XSL/json"
   xpath-default-namespace="http://www.w3.org/2005/xpath-functions" version="3.0"
   exclude-result-prefixes="tei xs j local">

   <xsl:output indent="yes"/>
   <xsl:param name="pathToFile" select="'../SefariaTannaitic/json/'"/>
   <xsl:param name="fName" select="'Sifrei Bamidbar - he - Wikisource.json'"/>
   <xsl:param name="localID" select="'ref-sifre-n'"/>
   <xsl:variable name="k-vPairs" select="document('../SefariaTannaitic/xml/biblRabbValues.xml')"
      as="document-node()"/>
   <xsl:key name="biblRabb" match="local:item" use="@k"/>
   <xsl:key name="gematria" match="local:letter" use="@k"/>
   <xsl:variable name="punctChars">\.,!:;?-</xsl:variable>

   <xsl:template name="startSingle">
      <!--<xsl:message select="string($k-vPairs/key('biblRabb','חולין')/@v)"/>
      <xsl:message select="$k-vPairs/key('gematria','א')/@v"/>-->
      <!--<xsl:copy-of select="json-to-xml(unparsed-text(encode-for-uri(concat($pathToFile, $fName))))"></xsl:copy-of>-->
      <xsl:apply-templates
         select="json-to-xml(unparsed-text(encode-for-uri(concat($pathToFile, $fName))))/*"/>

   </xsl:template>
   <xsl:template match="node() | @*">
      <xsl:copy>
         <xsl:apply-templates select="node() | @*"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="map[not(ancestor::*)]">
      <xsl:processing-instruction name="xml-model">
                <xsl:text>type="application/xml" </xsl:text>
  <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" </xsl:text>
                <xsl:text>schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
            </xsl:processing-instruction>
      <xsl:processing-instruction name="xml-model">
                <xsl:text>type="application/xml" </xsl:text>
  <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng"</xsl:text>
                 <xsl:text>schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
            </xsl:processing-instruction>
      <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="ref-{substring-before($fName,' ')}">
         <teiHeader>
            <fileDesc>
               <titleStmt>
                  <title>An Electronic Edition of the <xsl:value-of select="string[@key = 'title']"
                     />, <xsl:value-of select="string[@key = 'versionTitle']"/></title>
                  <editor>
                     <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                  </editor>
                  <respStmt>
                     <resp>file conversion</resp>
                     <persName corresp="ref.xml#HL">Hayim Lapin</persName>
                  </respStmt>
                  <respStmt>
                     <resp>transcription</resp>
                     <orgName corresp="ref.xml#sefaria">Sefaria</orgName>
                  </respStmt>
                  <respStmt>
                     <resp>encoding</resp>
                     <orgName corresp="ref.xml#sefaria">Sefaria</orgName>
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
                  <idno type="local">
                     <xsl:value-of select="$localID"/>
                  </idno>
                  <availability status="restricted">
                     <p>This work is copyright Hayim lapin and the Joseph and Rebecca Meyerhoff
                        Center for Jewish Studies and licensed under a <ref
                           target="http://creativecommons.org/licenses/by-sa/4.0//">Creative Commons
                           Attribution International 4.0 License</ref>.</p>
                  </availability>
                  <pubPlace>College Park, MD USA</pubPlace>
                  <date>2012-01-03</date>
               </publicationStmt>
               <notesStmt>
                  <note>
                     <p>Sefaria <xsl:value-of select="string[@key = 'title']"/>, <xsl:value-of
                           select="string[@key = 'versionTitle']"/>. Text generously provided by
                           <ref target="http://www.sefaria.org">Sefaria</ref> under a <ref
                           target="https://creativecommons.org/licenses/by-sa/3.0/">Creative Commons
                           Attribution-ShareAlike 3.0 Unported License (CC BY-SA)</ref>.</p>
                     <p>Edited and converted by TEI/XML by Hayim Lapin</p>
                  </note>
               </notesStmt>
               <sourceDesc>
                  <biblStruct xml:id="tba">
                     <monogr>
                        <title xml:lang="en">
                           <xsl:value-of select="string[@key = 'title']"/>
                        </title>
                        <title xml:lang="he">
                           <xsl:value-of select="string[@key = 'heTitle']"/>
                        </title>
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
               <tagsDecl> </tagsDecl>
            </encodingDesc>
            <revisionDesc>
               <change when="2018-09-02" who="ref.xml#HL">Begun editing and tagging</change>

            </revisionDesc>
         </teiHeader>
         <text>
            <body>
               <xsl:apply-templates select="array[@key = 'text']/*">
                  <xsl:with-param name="workID" select="$localID"/>
               </xsl:apply-templates>
            </body>
         </text>
      </TEI>
   </xsl:template>
   <xsl:template match="array[not(@*)]">
      <xsl:variable name="divID" select="concat($localID, '.', count(preceding-sibling::*) + 1)"/>
      <div xml:id="{$divID}">
         <xsl:apply-templates select="string">
            <xsl:with-param name="idPref" select="$divID"/>
         </xsl:apply-templates>
      </div>
   </xsl:template>

   <xsl:template match="string">
      <xsl:param name="idPref"/>
      <xsl:variable name="halakhaID" select="concat($idPref, '.', count(preceding-sibling::*) + 1)"/>
      <ab xml:id="{$halakhaID}">
         <xsl:analyze-string select="." regex="^\[(\p{{IsHebrew}}+?)\](.+)$">
            <xsl:matching-substring>
               <label>
                  <xsl:call-template name="thingsLabeledSmall">
                     <xsl:with-param name="str" select="regex-group(1)"/>
                  </xsl:call-template>
               </label>
               <xsl:call-template name="thingsLabeledSmall">
                  <xsl:with-param name="str" select="regex-group(2)"/>
               </xsl:call-template>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
               <xsl:call-template name="thingsLabeledSmall">
                  <xsl:with-param name="str" select="."/>
               </xsl:call-template>
            </xsl:non-matching-substring>
         </xsl:analyze-string>
      </ab>
   </xsl:template>

   <!-- regex patterns to address typographical markup of text in these files  -->
   <xsl:template name="thingsLabeledSmall">
      <xsl:param name="str"/>
      <xsl:analyze-string select="$str" regex="&lt;small&gt;([^&lt;]+)&lt;/small&gt;">
         <xsl:matching-substring>
            <gloss resp="source">
               <xsl:value-of select="normalize-space(translate(regex-group(1), '()', ''))"/>
            </gloss>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:call-template name="quotes">
               <xsl:with-param name="str" select="."/>
            </xsl:call-template>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>

   <xsl:template name="quotes">
      <xsl:param name="str"/>
      <xsl:analyze-string select="normalize-space($str)" regex="([^\p{{IsHebrew}}]*)&quot;(.+?)&quot;([^\p{{IsHebrew}}]*)">
         <xsl:matching-substring>
            <xsl:choose><xsl:when test="regex-group(1)"><xsl:call-template name="parens">
               <xsl:with-param name="str" select="regex-group(1)"></xsl:with-param>
            </xsl:call-template><quote>
               <xsl:call-template name="parens">
               <xsl:with-param name="str" select="regex-group(2)"></xsl:with-param>
            </xsl:call-template>
            </quote><xsl:call-template name="parens">
               <xsl:with-param name="str" select="regex-group(3)"></xsl:with-param>
            </xsl:call-template></xsl:when></xsl:choose>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:call-template name="parens">
               <xsl:with-param name="str" select="."></xsl:with-param>
            </xsl:call-template>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   <xsl:template name="parens">
      <xsl:param name="str"/>
      <xsl:analyze-string select="$str" regex="\(([^\)]+)\)">
         <xsl:matching-substring>
            <xsl:message select="regex-group(1)"></xsl:message>
            <!-- could do this more compactly -->
            <xsl:variable name="tkns"
               select="
                  if (starts-with(regex-group(1), 'משנה'))
                  then
                     tokenize(normalize-space(substring-after(regex-group(1), 'משנה')), '\s')
                  else
                     tokenize(normalize-space(regex-group(1)), '\s')"/>
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
               <xsl:when test="$tknsToUse = 'useDel' or string-length(regex-group(1)) &gt; 20">
                  <del resp="#source">
                     <xsl:call-template name="sqBrackets"><xsl:with-param name="str" select="regex-group(1)"/></xsl:call-template>
                  </del>
               </xsl:when>
               <xsl:otherwise>
                  <ref
                     target="{normalize-space(concat(if (starts-with(regex-group(1),'משנה')) then 'mishnah:' else (),$tknsToUse,$refExtension))}"
                     n="{regex-group(1)}"/>
               </xsl:otherwise>
            </xsl:choose>

         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:call-template name="sqBrackets"><xsl:with-param name="str" select="."/></xsl:call-template>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   <xsl:template name="sqBrackets">
      <xsl:param name="str"></xsl:param>
      <xsl:analyze-string select="$str" regex="\[([^\]]+)\]">
         <xsl:matching-substring>
            <add resp="#source"><xsl:call-template name="apos"><xsl:with-param name="str" select="regex-group(1)"/></xsl:call-template></add>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:call-template name="apos">
               <xsl:with-param name="str" select="."/>
            </xsl:call-template>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
      
   </xsl:template>
   
   <!-- this now duplicates some tests in template apos -->
   <!-- could be simplified? -->
   <xsl:template name="apos">
      <xsl:param name="str"></xsl:param>
 
      <!--<xsl:variable name="regex">([&quot;&apos;])</xsl:variable>-->
      <xsl:analyze-string select="$str" regex="(\p{{IsHebrew}}*)([&apos;&quot;׳״])(\p{{IsHebrew}}*)">
         <xsl:matching-substring>
         <xsl:message select="(regex-group(1),regex-group(3))"/>
            <xsl:choose>
               <xsl:when test="string-length(regex-group(1))&gt;=1 and regex-group(2)='&quot;' and string-length(regex-group(3))&gt;=1">
                  <xsl:value-of select="regex-group(1)"/><am rend="gershayyim"><xsl:value-of select="'״'"/></am><xsl:value-of select="regex-group(3)"/>
               </xsl:when>
               <xsl:when test="(string-length(regex-group(1))&gt;=0  or string-length(regex-group(3))&gt;=0) and regex-group(2)='&quot;'">
                  <xsl:value-of select="regex-group(1)"/><pc type="quote"><xsl:value-of select="'״'"/></pc><xsl:value-of select="regex-group(3)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="regex-group(1)"/><am rend="{if (matches(regex-group(2),'[''׳]')) then 'geresh' else 'gershayyim'}"><xsl:value-of select="'׳'"/></am><xsl:value-of select="regex-group(3)"/>
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
      <xsl:analyze-string select="$str" regex="{concat('([',$punctChars,']+)')}">
         <xsl:matching-substring><pc type="source-supplied"><xsl:value-of select="regex-group(1)"/></pc></xsl:matching-substring>
      <xsl:non-matching-substring>
         <xsl:value-of select="."/>
      </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   
   <xsl:function name="local:gematria">
      <xsl:param name="str"/>
      <xsl:value-of
         select="
            if (not(normalize-space($str))) then
               '-'
            else
               sum(for $c in string-to-codepoints($str)
               return
                  xs:integer($k-vPairs//local:letter[@k = codepoints-to-string($c)]/@v))"/>
   </xsl:function>
</xsl:stylesheet>
