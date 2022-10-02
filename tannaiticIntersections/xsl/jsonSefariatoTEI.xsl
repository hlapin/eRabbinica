<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
   xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:local="http://www.local-functions.uri" xmlns:j="http://www.w3.org/2013/XSL/json"
   xpath-default-namespace="http://www.w3.org/2005/xpath-functions" version="3.0"
   exclude-result-prefixes="tei xs j local">

   <xsl:output indent="yes"/>
   <xsl:param name="pathToFile" select="'../data/json/'"/>
   <xsl:param name="fName" select="'Sifra - he - Venice 1545.json'"/>


   <xsl:template name="startSingle">
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
                  <title>An Electronic Edition of the <xsl:value-of
                     select="map[@key = 'schema']/string[@key = 'key']"/>, <xsl:value-of
                     select="string[@key = 'versionTitle']"/></title>
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
                  <idno type="local">ref-<xsl:value-of
                     select="map[@key = 'schema']/string[@key = 'key']"/></idno>
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
                     <p>Sefaria <xsl:value-of select="map[@key = 'schema']/string[@key = 'key']"/>,
                        <xsl:value-of select="string[@key = 'versionTitle']"/>. Text generously
                        provided by <ref target="http://www.sefaria.org">Sefaria</ref> under a <ref
                        target="https://creativecommons.org/licenses/by-sa/3.0/">Creative Commons
                        Attribution-ShareAlike 3.0 Unported License (CC BY-SA)</ref>.</p>
                     <p>Edited and converted by TEI/XML by Hayim Lapin</p>
                  </note>
               </notesStmt>
               <sourceDesc>
                  <biblStruct xml:id="tba">
                     <monogr>
                        <title xml:lang="en">
                           <xsl:value-of select="map[@key = 'schema']/string[@key = 'enTitle']"/>
                        </title>
                        <title xml:lang="he">
                           <xsl:value-of select="map[@key = 'schema']/string[@key = 'heTitle']"/>
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
               <xsl:apply-templates select="map[@key = 'schema']/*/map">
                  <xsl:with-param name="workID" select="map[@key = 'schema']/string[@key = 'key']"/>
               </xsl:apply-templates>
            </body>
         </text>
      </TEI>
   </xsl:template>
   <xsl:template match="map[@key='schema']/array/map">
      <xsl:param name="workID"></xsl:param>
      <xsl:variable name="divID" select="concat('ref-',$workID, '.',count(preceding-sibling::map) + 1)"/>
      <div xml:id="{concat('ref-',$workID,'.',count(preceding-sibling::*) + 1)}"
         type="level_1" 
         n="{string-join(string,'|')}">
         <xsl:choose>
            <xsl:when test="array[@key='nodes']">
               <xsl:apply-templates select="array[@key='nodes']/map">
                  <xsl:with-param name="idPref" select="$divID"/>
                  <xsl:with-param name="ancestorChunkName" select="string[@key='enTitle']"/>
               </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="title" select="string[@key='enTitle']"/>
               <xsl:apply-templates select="ancestor::map[@key='schema']/following-sibling::map[@key='text']/array[@key=$title]/*">
                  <xsl:with-param name="idPref" select="$divID"/>
               </xsl:apply-templates>
            </xsl:otherwise>
         </xsl:choose>
      </div>
   </xsl:template>
   <xsl:template match="map[../../../..[@key='schema']]">
      <xsl:param name="ancestorChunkName"></xsl:param>
      <xsl:param name="idPref"/>
      <xsl:message select="$ancestorChunkName"></xsl:message>
      <xsl:variable name="enTitle" select="string[@key='enTitle']"/>
      <xsl:variable name="divID">
         <xsl:value-of select="$idPref"/>
         <xsl:text>.</xsl:text>
         <xsl:choose>
            <xsl:when test="contains($enTitle,'Chapter')">
               <xsl:variable name="thisPereq" select="if (string-length(substring-after($enTitle,' ')) = 2) 
                  then substring-after($enTitle,' ')
                  else concat('0',substring-after($enTitle,' '))"/>
               <xsl:variable name="parashaNo" select="if (preceding-sibling::map/string[@key='enTitle'][contains(.,'Section')]) 
                  then substring-after(preceding-sibling::map[contains(string[@key='enTitle'],'Section')][1]/string[@key='enTitle'],' ') 
                  else number(substring-after(following-sibling::map[contains(string[@key='enTitle'],'Section')][1]/string[@key='enTitle'],' '))-1"/>
               <xsl:value-of select="concat(
                  if (string-length(string($parashaNo)) = 2) 
                     then $parashaNo 
                  else concat('0',$parashaNo),'-',substring-after($enTitle,' '))"/>
            </xsl:when>
            <xsl:when test="contains($enTitle,'Section')">
               <xsl:variable name="parashaNo" select="substring-after(string[@key='enTitle'],' ')"/>
               <xsl:value-of select="if (string-length($parashaNo) = 2) then $parashaNo else concat('0',$parashaNo)"/>
               <xsl:text>-00</xsl:text>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="count(preceding-sibling::*) + 1"/></xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <div xml:id="{$divID}"
         type="level_2"
         n="{if (contains($enTitle,'Section')) 
         then concat('parashah_',substring-after($enTitle,' '))
            else if (contains($enTitle,'Chapter'))
            then concat('pereq_',substring-after($enTitle,' '))
            else translate(normalize-space($enTitle),' ','_')}">
         <xsl:apply-templates select="../../../../following-sibling::map[@key='text']/map[@key=$ancestorChunkName]/array[@key=$enTitle]/*">
            <xsl:with-param name="idPref" select="$divID"></xsl:with-param>
         </xsl:apply-templates>
      </div>
   </xsl:template>
   <xsl:template match="string">
      <xsl:param name="idPref"/>
      <xsl:variable name="halakhaID" select="concat($idPref, '.', count(preceding-sibling::*) + 1)"/>
      <ab xml:id="{$halakhaID}">
         <xsl:apply-templates/>
      </ab>
   </xsl:template>
   
   
   
   
   
  <!-- <xsl:template match="array[parent::map[@key = 'text']] | map[parent::map[@key = 'text']]">
      <xsl:param name="workID"/>
      <xsl:variable name="divID"
         select="concat('ref-', $workID, '.', count(preceding-sibling::*) + 1)"/>
      <div type="level_1" xml:id="{$divID}" n="{@key}">
         <xsl:choose>
            <xsl:when test="string">
               <xsl:apply-templates select="string">
                  <xsl:with-param name="idPref" select="$divID"/>
               </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="array">
               <xsl:apply-templates select="array">
                  <xsl:with-param name="idPref" select="$divID"/>
               </xsl:apply-templates>
            </xsl:when>
         </xsl:choose>
      </div>
   </xsl:template>
   <xsl:template match="array">
      <xsl:param name="idPref"/>
      <xsl:variable name="chapNo">
         <xsl:choose>
            <xsl:when test="contains(@key, 'Chapter')">
               <xsl:choose>
                  <xsl:when test="not(preceding-sibling::array[contains(@key, 'Section')])">
                     <xsl:text>00-</xsl:text>
                     <xsl:value-of select="substring-after(@key, ' ')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:variable name="precParasha"
                        select="preceding-sibling::array[contains(@key, 'Section')][1]/substring-after(., '  ')"/>
                     <xsl:value-of
                        select="
                           if (string-length($precParasha) = 2) then
                              $precParasha
                           else
                              concat('0', $precParasha)"/>
                     <xsl:text>-</xsl:text>
                     <xsl:value-of select="substring-after(@key, ' ')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(@key, 'Section')">
               <xsl:value-of
                  select="
                     if (string-length(substring-after(@key, ' ')) = 2) then
                        substring-after(@key, ' ')
                     else
                        concat('0', substring-after(@key, ' '))"/>
               <xsl:text>-00</xsl:text>

            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:message select="$chapNo"/>
      <xsl:variable name="divID" select="concat($idPref, '.', $chapNo)"/>
      <div xml:id="{$divID}" type="level_2" n="{concat(if (contains(@key, 'Section')) then 'Parashah-' else 'Pereq-',substring-after(@key,' '))}">
         <xsl:apply-templates select="string">
            <xsl:with-param name="idPref" select="$divID"/>
         </xsl:apply-templates>
      </div>
   </xsl:template>
-->

</xsl:stylesheet>
