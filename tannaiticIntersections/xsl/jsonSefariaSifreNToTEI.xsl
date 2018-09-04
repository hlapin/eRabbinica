<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:local="http://www.local-functions.uri" xmlns:j="http://www.w3.org/2013/XSL/json"
   xpath-default-namespace="http://www.w3.org/2005/xpath-functions" version="3.0"
   exclude-result-prefixes="tei xs xlink j local">

   <xsl:output indent="yes"/>
   <xsl:param name="pathToFile" select="'../SefariaTannaitic/json/'"/>
   <xsl:param name="fName" select="'Sifrei Devarim - he - Sifrei Devarim, Hebrew.json'"/>
<xsl:param name="localID" select="'ref-sifre-d'"></xsl:param>

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
                     select="string[@key='title']"/>, <xsl:value-of
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
                  <idno type="local"><xsl:value-of select="$localID"/></idno>
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
                     <p>Sefaria <xsl:value-of select="string[@key='title']"/>,
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
                           <xsl:value-of select="string[@key='title']"/>
                        </title>
                        <title xml:lang="he">
                           <xsl:value-of select="string[@key='heTitle']"/>
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
      <xsl:variable name="divID" select="concat($localID,'.',count(preceding-sibling::*) + 1)"/>
      <div xml:id="{$divID}">
         <xsl:apply-templates select="string">
            <xsl:with-param name="idPref" select="$divID"></xsl:with-param>
         </xsl:apply-templates>
      </div>
   </xsl:template>
   
   <xsl:template match="string">
      <xsl:param name="idPref"/>
      <xsl:variable name="halakhaID" select="concat($idPref, '.', count(preceding-sibling::*) + 1)"/>
      <ab xml:id="{$halakhaID}">
         <xsl:analyze-string select="." regex="^\[(\p{{IsHebrew}}+?)\](.+$)">
            <xsl:matching-substring>
               <label><xsl:value-of select="regex-group(1)"/></label>
               <xsl:apply-templates select="regex-group(2)"></xsl:apply-templates>
            </xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
            <xsl:fallback><xsl:apply-templates/></xsl:fallback>
         </xsl:analyze-string>
      </ab>
   </xsl:template>
   
   
   
   
</xsl:stylesheet>
