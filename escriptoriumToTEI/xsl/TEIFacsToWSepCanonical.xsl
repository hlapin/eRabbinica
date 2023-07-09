<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="local.functions.uri" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs local tei xi"
    version="3.0">
    <xsl:output indent="yes"/>
    
    
    <!-- 9/4/21 need to incorporate function to create folio line numbers. -->
    <!-- Variability chapter headers, trailers, and mishnah labels means that there is a fair -->
    <!-- amount of error at this point -->
    <xsl:include href="renumberPbCbtoInclude.xsl"/>
    
    
    <xsl:param name="img-name-ext" select="'jpg'"/>
    <!-- for refDecl in header -->
    <xsl:param name="path-to-pagexml" select="('http://www.placeholder.uri','pxml')"></xsl:param>
    <xsl:param name="path-to-facs" select="('http://www.placeholder.uri','tei-facs')"></xsl:param>
    
    <xsl:variable name="base" select="tokenize(base-uri(/),'/')[last()]"/>
    <xsl:variable name="witID" select="/teiCorpus/@xml:id"/>
    <!-- flatten TEI Facs, retaining pb, cb, l ==> lb and their IDs -->
    <!--  -->
    <!-- iterate on milestones to create canonical structure -->
    <!--    For each unit within canonical structure create w-sep, id'd text -->
    <!--    ***Will need to create head, label, possibly trailer, from text between milestones. -->
    <!-- Update new format with values from index of pages, columns, lines -->
    
    
    <xsl:template match="/">
        <xsl:message select="$base"/>
        <xsl:message select="$witID"/>
        <TEI>
            <xsl:variable name="folderURI"
                select="substring-before(base-uri(), tokenize(base-uri(), '/')[last()])"/>
            <xsl:copy-of select="doc(concat($folderURI, $witID, '-teiHeader.xml'))/TEI/teiHeader"/>
            
            <text>
                <body>
                    <xsl:variable name="flattened" as="node()+">
                        <xsl:apply-templates select="teiCorpus/TEI/text/body"/>
                    </xsl:variable>

                    <xsl:variable name="grouped-by-milestone">
                        <xsl:call-template name="group-on-milestones">
                            <xsl:with-param name="toGroup" select="$flattened"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="structured">
                        <xsl:for-each-group select="$grouped-by-milestone/div2"
                            group-adjacent="string(@div1)">
                            <!-- what to do with prefaces currently labeled div1? -->
                            <!-- for now, I drop this out in next pass -->
                            <div1 xml:id="{concat($witID,'.',current-group()[1]/@div1)}">
                                <xsl:apply-templates select="current-group()" mode="restructure"/>
                            </div1>
                        </xsl:for-each-group>
                    </xsl:variable>
                    <!-- tokenize and wrap words -->
                    <xsl:variable name="tokenize-and-wrap">
                        <xsl:apply-templates mode="cleanup" select="$structured"/>
                    </xsl:variable>
                    <xsl:apply-templates select="$tokenize-and-wrap" mode="production"/>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    
    <!-- flatten -->
    <xsl:template match="cb|pb">
        <xsl:element name="{name()}">
            <xsl:attribute name="corresp" select="concat($path-to-facs[2],':',$base,'#',@xml:id)"></xsl:attribute>
            <!--<xsl:attribute name="xml:id" select=""></xsl:attribute>
            <xsl:attribute name="n" select="base-uri()"></xsl:attribute>-->
        </xsl:element>
    </xsl:template>
    <xsl:template match="l">
        <xsl:variable name="prec_cb" select="preceding::cb[1]"/>
        <!-- ancestor-or-self::*[ancestor::div]/preceding-sibling::*/descendant-or-self::l -->
        <xsl:variable 
            name="line_no" 
            select="1 + count(ancestor-or-self::*[ancestor::div]/preceding-sibling::*/descendant-or-self::l[preceding::cb[1] is $prec_cb])"/>
        <lb n="{$line_no}">
            <xsl:attribute name="corresp" select="concat($path-to-pagexml[2],':',local:cref(@corresp))"></xsl:attribute>
        </lb>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ab[@type='Commentary']">
        <gap 
            reason="Maimonides" 
            extent="{count(l)}" 
            unit="lines" 
            corresp="{concat($path-to-pagexml[2],':',local:cref(@corresp))}"></gap>
    </xsl:template>
    <xsl:template match="ab[@type='Paratext']">
        <xsl:variable name="prec_pb" select="preceding::pb[1]"/>
        <!-- ancestor-or-self::*[ancestor::div]/preceding-sibling::*/descendant-or-self::l -->
        <xsl:variable 
            name="fw-no" 
            select="1 + count(ancestor-or-self::*[ancestor::body]/preceding-sibling::*/descendant-or-self::ab[@type='Paratext'][preceding::pb[1] is $prec_pb])"/>
       
        <fw
            xml:id="{concat($witID,'.',preceding::pb[1]/@xml:id,'_fw_',$fw-no)}"
            type="paratext"
            corresp="{concat($path-to-pagexml[2],':',local:cref(@corresp))}">
            <xsl:apply-templates/>
        </fw>
    </xsl:template>
    <xsl:template match="ab[@type='Margin']">
        <add 
            type="Not-specified"
            corresp="{concat($path-to-pagexml[2],':',local:cref(@corresp))}"
            location="margin"
            extent="{count(l)}" 
            unit="lines"></add>
    </xsl:template>
    <xsl:template match="*[descendant::l]" priority="-1">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:variable name="t" select="normalize-space(.)"></xsl:variable>
        <xsl:variable name="singleQuot"><xsl:text>'</xsl:text></xsl:variable>
        <xsl:variable name="doubleQuot"><xsl:text>"</xsl:text></xsl:variable>
        <xsl:variable name="regexPattern" select="concat('(',$singleQuot,׳,'|',$doubleQuot,'|\.|:)')"/>
        <!-- '(',$singleQuot,'|',$doubleQuot,'|\s+|\.|:',')' -->
        <xsl:analyze-string select="$t" regex="{$regexPattern}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". eq $singleQuot"><am>׳</am></xsl:when>
                    <xsl:when test=". eq '׳'"><am>׳</am></xsl:when>
                    <xsl:when test=". eq $doubleQuot"><am>״</am></xsl:when>
                    <xsl:when test=". eq '.'"><pc unit="stop">.</pc></xsl:when>
                    <xsl:when test=". eq ':'"><pc unit="unitEnd">:</pc></xsl:when>
                    <!--<xsl:when test="matches(., '\s+')"><w/></xsl:when>-->
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="normalize-space(.)"/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="milestone">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:copy-of select="."></xsl:copy-of>
    </xsl:template>
    
    <!-- group on milestones and clean up-->
    <xsl:template name="group-on-milestones">
        <xsl:param name="toGroup"/>
        <xsl:for-each-group select="$toGroup" 
            group-starting-with="milestone[@unit='div2']">
            <xsl:variable name="level" select="current-group()[1]/@n"/>
            <xsl:choose>
                <xsl:when test="not($level)">
                    <div1 xml:id="{concat($witID,'.0')}">
                        <xsl:copy-of select="current-group()"></xsl:copy-of>
                    </div1>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="level" select="current-group()[1]/@n"/>
                    <div2 
                        div1="{substring-before(current-group()[1]/@n, '.')}" 
                        xml:id="{concat($witID,'.',$level)}">
                        <xsl:for-each-group select="current-group()[not(self::milestone[@n = $level])]" 
                            group-starting-with="milestone[@unit='div3']">
                            <xsl:choose>
                                <xsl:when test="not(current-group()[1]/self::milestone[@unit='div3'])">
                                    <head>
                                        <xsl:copy-of select="current-group()"></xsl:copy-of>
                                    </head>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="level" select="current-group()[1]/@n"/>
                                    <div3 xml:id="{concat($witID,'.',current-group()[1]/@n)}">
                                        <xsl:for-each-group 
                                            select="current-group()[not(self::milestone[@n=$level])]"
                                            group-starting-with="milestone[@unit='ab']" >
                                            <xsl:choose>
                                                <xsl:when test="not(current-group()[1]/self::milestone[@unit='ab'])">
                                                    <head>
                                                        <xsl:copy-of select="current-group()"></xsl:copy-of></head>
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <ab xml:id="{concat($witID,'.',current-group()[1]/@n)}">
                                                        <xsl:copy-of select="current-group()[not(self::milestone[@unit='ab'])]"/>
                                                    </ab>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each-group>
                                    </div3>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </div2>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template mode="restructure cleanup production" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="div1" mode="restructure">
    </xsl:template>
    
    <xsl:template match="div2" mode="restructure">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@xml:id"/>
            <xsl:apply-templates mode="restructure"></xsl:apply-templates>
        <trailer xml:id="{concat(@xml:id,'.T')}">
            <xsl:copy-of select="(.//gap)[last()]/following-sibling::node()"></xsl:copy-of>
        </trailer>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div3" mode="restructure">
        <xsl:variable name="toProcessAsHead" 
            select="(preceding-sibling::*[1]//gap)[last()]/following-sibling::node()|head/node()"/>
        <xsl:element name="{name()}">
            <xsl:copy-of select="@xml:id"/>
        <xsl:if test="string-join($toProcessAsHead/normalize-space()) or $toProcessAsHead/node()">
            <head xml:id="{concat(@xml:id,'.H')}">
                <!-- kludge to prevent concatenation of strings -->
                <!-- better way to do this? -->
            <xsl:copy-of select="for $n in $toProcessAsHead return ($n,' ')"></xsl:copy-of>
        </head>
        </xsl:if>
            <xsl:apply-templates mode="restructure"/>
       </xsl:element>
    </xsl:template>
    <xsl:template match="ab" mode="restructure">
        <xsl:variable name="toProcessAsLabel" 
            select="preceding-sibling::ab[1]/gap[last()]/following-sibling::node()|gap[last()]/node()"/>
        <ab>
            <xsl:copy-of select="@xml:id"/>    
            <xsl:choose>
                <!-- since this is label, want to capture only short strings. -->
                <!-- could be refined further to avoid putting fw into label-->
                <xsl:when test="string-length(normalize-space(string-join($toProcessAsLabel))) &lt; 5
                    and string-length(normalize-space(string-join($toProcessAsLabel))) &gt;= 1">
                    <label>
                        <xsl:copy-of select="$toProcessAsLabel"></xsl:copy-of>
                    </label>
                </xsl:when>
            </xsl:choose>
            <xsl:variable name="exclude_from_end"  as="node()*"> 
            <xsl:variable name="toCheck" select="
                (gap[last()]/following-sibling::node())"/>
                <!-- since this is for label of next ab, want to capture only short strings. -->
                <!-- but also need to capture chapter trailers appended -->
                <xsl:sequence select="
                        if (
                        (string-length(normalize-space(string-join($toCheck))) &lt; 5 and
                        string-length(normalize-space(string-join($toCheck))) &gt;= 1)
                        or 
                        (matches(string-join($toCheck),'פרק')
                        or
                        (gap[last()]/following-sibling::fw))
                        ) then
                            $toCheck
                        else
                            ()"/>
        </xsl:variable>
            <xsl:copy-of select="node() except $exclude_from_end"/>
        </ab>
    </xsl:template>
    
    <xsl:template match="head[not(@xml:id)][parent::div3]" mode="restructure">
        <!-- omit -->
        <!-- processed as with div3 -->
    </xsl:template>
    
    <xsl:template match="head[parent::div2]" mode="restructure">
        <head xml:id="{concat(parent::*/@xml:id,'.H')}">
            <xsl:apply-templates select="node()" mode="restructure"></xsl:apply-templates>
        </head>
    </xsl:template>
   
    
    
    <xsl:template match="milestone" mode="cleanup"/>
    
    <xsl:template match="ab|fw|head|trailer|label" mode="cleanup">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            
            <!-- label needs xml:id -->
            <xsl:if test="self::label">
                <xsl:attribute name="xml:id" select="concat(parent::ab/@xml:id,'_lbl_', string(1 + count(preceding-sibling::label)))"></xsl:attribute>
            </xsl:if>
            
            <xsl:variable name="to-tokenize" as="node()*">
                <xsl:for-each-group select="node()"
                    group-adjacent="boolean(self::text() | self::am | self::pc | self::lb)">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:for-each-group select="current-group()"
                                group-adjacent="boolean(self::text() | self::am)">
                                <xsl:choose>
                                    <xsl:when test="current-grouping-key()">
                                        <xsl:call-template name="tokenize">
                                            <xsl:with-param name="in" select="current-group()"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="current-group()" mode="cleanup"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- pass child nodes containing text to next step -->
                            <xsl:apply-templates select="current-group()" mode="cleanup"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:call-template name="wrap-tokens">
                <xsl:with-param name="in" select="$to-tokenize"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="tokenize">
        <xsl:param name="in"/>
        <xsl:for-each select="$in/self::node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <xsl:analyze-string select="." regex="\s+">
                        <xsl:matching-substring>
                            <w/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="wrap-tokens">
        <xsl:param name="in" as="node()*"/>
        <xsl:for-each-group select="$in" group-adjacent="boolean(self::am|self::w|self::text())">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <xsl:for-each-group 
                        select="current-group()"
                        group-starting-with="lb|w">
                        
                        <xsl:choose>
                            <xsl:when test="current-group()[1][self::w]">
                                <w><xsl:copy-of select="current-group()[not(self::w)]"/></w>
                            </xsl:when>
                            <xsl:when test="current-group()[1][self::text()]">
                                <w><xsl:copy-of select="current-group()"/></w>
                            </xsl:when>
                            <xsl:when test="current-group()[1][self::lb]">
                                <!-- needs to be fixed for Paris, hyphenated text? -->
                                <xsl:copy-of select="current-group()[self::lb]"></xsl:copy-of>
                                <xsl:if test="count(current-group()[self::text()]) &gt; 0">
                                    <w><xsl:copy-of select="current-group()[not(self::lb)]"></xsl:copy-of></w>
                                </xsl:if>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each-group>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="current-group()"></xsl:copy-of>
                </xsl:otherwise>
                
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="w" mode="production">
        <w xml:id="{parent::*/@xml:id}.{count(preceding-sibling::w) + 1}">
            <xsl:apply-templates select="node()" mode="production"/>
        </w>
    </xsl:template>
    
    <!--<xsl:template match="fw" mode="production">
        <fw xml:id="{concat(@xml:id,count(preceding-sibling::fw) + 1)}">
            <xsl:apply-templates mode="production"></xsl:apply-templates>
        </fw>
    </xsl:template>-->
    
    <xsl:function name="local:cref">
        <xsl:param name="corresp"></xsl:param>
        <xsl:variable name="no-prefix" select="replace($corresp,'^#[lpr]_(.+)$','$1')"></xsl:variable>
        <xsl:value-of select="replace($corresp,'^#[lpr]_(.+)-(eSc.+)$','$1.xml#$2')"/>
    </xsl:function>
    
    
    
</xsl:stylesheet>
