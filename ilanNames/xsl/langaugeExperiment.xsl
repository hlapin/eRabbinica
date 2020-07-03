<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://local-functions.uri"
    exclude-result-prefixes="xs local"
    
    version="2.0">
    
    <xsl:variable name="testString" select="'– [], []() ().'"></xsl:variable>
    <xsl:variable name="chars" xmlns="http://local-functions.uri">
        <root>
        <translit>
            <char from="&#xA6;" to="&#x10D;"/>
            <char from="&#xBD;" to="&#x14D;"/>
            <char from="&#xC1;" to="&#x101;"/>
            <char from="&#xC0;" to="&#x100;"/>
            <char from="&#xC2;" to="&#x1E0C;"/>
            <char from="&#xE2;" to="&#xE2;"/>
            <char from="&#xC3;" to="&#xC3;"/>
            <char from="&#xE7;" to="&#xE7;"/>
            <char from="&#xD0;" to="&#x12B;"/>
            <char from="&#xCD;" to="&#x1E24;"/>
            <char from="&#xCE;" to="&#x1E25;"/>
            <char from="&#x134;" to="&#x134;"/>
            <char from="&#x135;" to="&#x135;"/>
            <char from="&#xD1;" to="&#x1E62;"/>
            <char from="&#xD2;" to="&#x1E63;"/>
            <char from="&#xD4;" to="&#x1E6D;"/>
            <char from="&#x161;" to="&#x161;"/>
            <char from="&#x160;" to="&#x160;"/>
            <char from="&#xDE;" to="&#x2BE;"/>
            <char from="&#xDA;" to="&#x1E92;"/>
            <char from="&#xD9;" to="&#x16B;"/>
            <char from="&#xDB;" to="&#x1E93;"/>
            <char from="&#xDD;" to="&#x2BF;"/>
            <char from="&#x178;" to="&#x112;"/>
            <char from="&#xFF;" to="&#x113;"/>
        </translit>
        <greek>
            <char from="&#xF041;" to="&#x391;"/>
            <char from="&#xF061;" to="&#x3B1;"/>
            <char from="&#xF042;" to="&#x392;"/>
            <char from="&#xF062;" to="&#x3B2;"/>
            <char from="&#xF043;" to="&#x3A7;"/>
            <char from="&#xF063;" to="&#x3C7;"/>
            <char from="&#xF044;" to="&#x394;"/>
            <char from="&#xF064;" to="&#x3B4;"/>
            <char from="&#xF045;" to="&#x395;"/>
            <char from="&#xF065;" to="&#x3B5;"/>
            <char from="&#xF046;" to="&#x3A6;"/>
            <char from="&#xF066;" to="&#x3C6;"/>
            <char from="&#xF047;" to="&#x393;"/>
            <char from="&#xF067;" to="&#x393;"/>
            <char from="&#xF048;" to="&#x397;"/>
            <char from="&#xF049;" to="&#x399;"/>
            <char from="&#xF069;" to="&#x3B9;"/>
            <char from="&#xF04B;" to="&#x39A;"/>
            <char from="&#xF06B;" to="&#x3BA;"/>
            <char from="&#xF04C;" to="&#x39B;"/>
            <char from="&#xF06C;" to="&#x3BB;"/>
            <char from="&#xF04D;" to="&#x39C;"/>
            <char from="&#xF06D;" to="&#x3BC;"/>
            <char from="&#xF04E;" to="&#x39D;"/>
            <char from="&#xF06E;" to="&#x3BD;"/>
            <char from="&#xF04F;" to="&#x39F;"/>
            <char from="&#xF06F;" to="&#x3BF;"/>
            <char from="&#xF050;" to="&#x3A0;"/>
            <char from="&#xF070;" to="&#x3C0;"/>
            <char from="&#xF051;" to="&#x398;"/>
            <char from="&#xF071;" to="&#x3B8;"/>
            <char from="&#xF052;" to="&#x3A1;"/>
            <char from="&#xF072;" to="&#x3C1;"/>
            <char from="&#xF053;" to="&#x3A3;"/>
            <char from="&#xF073;" to="&#x3C3;"/>
            <char from="&#xF055;" to="&#x3A5;"/>
            <char from="&#xF075;" to="&#x3C5;"/>
            <char from="&#xF057;" to="&#x3A9;"/>
            <char from="&#xF077;" to="&#x3C9;"/>
            <char from="&#xF058;" to="&#x39E;"/>
            <char from="&#xF078;" to="&#x3BE;"/>
            <char from="&#xF059;" to="&#x3A8;"/>
            <char from="&#xF079;" to="&#x3C8;"/>
            <char from="&#xF05A;" to="&#x396;"/>
            <char from="&#xF07A;" to="&#x3B6;"/>
            <char from="&#xF022;" to="&#x3C2;"/>
            <char from="&#xF027;" to="&#x342;"/>
            <char from="&#xF02D;" to="&#x2D;"/>
            <char from="&#xF021;" to="&#x1FBD;"/>
            <char from="&#xF023;" to="&#x1FCE;"/>
            <char from="&#xF024;" to="&#x1FDE;"/>
            <char from="&#xF025;" to="&#x1FCE;"/>
            <char from="&#xF026;" to="&#x1FCF;"/>
            <char from="&#xF02A;" to="&#x1FDF;"/>
            <char from="&#xF02C;" to="&#x2C;"/>
            <char from="&#xF02E;" to="&#x2E;"/>
            <char from="&#xF02F;" to="&#x345;"/>
            <char from="&#xF03F;" to="&#x308;&#x301;"/>
            <char from="&#xF040;" to="&#x1FFE;"/>
            <char from="&#xF05B;" to="&#x313;&#x301;"/>
            <char from="&#xF05C;" to="&#x313;&#x303;"/>
            <char from="&#xF05D;" to="&#x313;&#x300;"/>
            <char from="&#xF05E;" to="&#x1FDD;"/>
            <char from="&#xF05F;" to="&#x3B;"/>
            <char from="&#xF060;" to="&#x308;&#x340;"/>
            <char from="&#xF07B;" to="&#x314;&#x301;"/>
            <char from="&#xF07C;" to="&#x314;&#x303;"/>
            <char from="&#xF07D;" to="&#x314;&#x300;"/>
            <char from="&#xF07E;" to="&#x1FC1;"/>
            <char from="&#xF02B;" to="&#x307;"/>
            <char from="&#xF03C;" to="&#x2D;"/>
            <char from="&#xF03E;" to="&#x308;"/>
            <char from="&#xF04A;" to="&#x314;"/>
            <char from="&#xF06A;" to="&#x313;"/>
            <char from="&#xF056;" to="&#x301;"/>
            <char from="&#xF076;" to="&#x301;"/>
        </greek>
        <coptic>
            <char from="&#x61;" to="&#x2C81;"/>
            <char from="&#x41;" to="&#x2C81;"/>
            <char from="&#x62;" to="&#x2C83;"/>
            <char from="&#x42;" to="&#x2C83;"/>
            <char from="&#x63;" to="&#x2CA5;"/>
            <char from="&#x43;" to="&#x2CA5;"/>
            <char from="&#x64;" to="&#x2C87;"/>
            <char from="&#x44;" to="&#x2C87;"/>
            <char from="&#x65;" to="&#x2C89;"/>
            <char from="&#x68;" to="&#x2C8F;"/>
            <char from="&#x48;" to="&#x2C8F;"/>
            <char from="&#x66;" to="&#x3E5;"/>
            <char from="&#x46;" to="&#x3E5;"/>
            <char from="&#x67;" to="&#x2C85;"/>
            <char from="&#x47;" to="&#x2C85;"/>
            <char from="&#x69;" to="&#x2C93;"/>
            <char from="&#x49;" to="&#x2C93;"/>
            <char from="&#x6A;" to="&#x2CAD;"/>
            <char from="&#x4A;" to="&#x2CAD;"/>
            <char from="&#x6B;" to="&#x2C95;"/>
            <char from="&#x4B;" to="&#x2C95;"/>
            <char from="&#x6C;" to="&#x2C97;"/>
            <char from="&#x4C;" to="&#x2C96;"/>
            <char from="&#x6D;" to="&#x2C99;"/>
            <char from="&#x4D;" to="&#x2C99;"/>
            <char from="&#x6E;" to="&#x2C9B;"/>
            <char from="&#x4E;" to="&#x2C9B;"/>
            <char from="&#x6F;" to="&#x2C9F;"/>
            <char from="&#x4F;" to="&#x2C9F;"/>
            <char from="&#x70;" to="&#x2CA1;"/>
            <char from="&#x50;" to="&#x2CA1;"/>
            <char from="&#x71;" to="&#x2CD3;"/>
            <char from="&#x51;" to="&#x2CD3;"/>
            <char from="&#x72;" to="&#x2CA3;"/>
            <char from="&#x52;" to="&#x2CA3;"/>
            <char from="&#x73;" to="&#x3E3;"/>
            <char from="&#x53;" to="&#x3E3;"/>
            <char from="&#x74;" to="&#x2CA7;"/>
            <char from="&#x54;" to="&#x2CA7;"/>
            <char from="&#x75;" to="&#x2CA9;"/>
            <char from="&#x55;" to="&#x2CA9;"/>
            <char from="&#x76;" to="&#x2CAB;"/>
            <char from="&#x56;" to="&#x2CAB;"/>
            <char from="&#x77;" to="&#x2CB1;"/>
            <char from="&#x57;" to="&#x2CB1;"/>
            <char from="&#x78;" to="&#x3E9;"/>
            <char from="&#x58;" to="&#x3E9;"/>
            <char from="&#x7A;" to="&#x2C8D;"/>
            <char from="&#x5A;" to="&#x2C8D;"/>
            <char from="&#x33;" to="&#x2C9D;"/>
            <char from="&#x6A;" to="&#x3EB;"/>
            <char from="&#x79;" to="&#x2CAD;"/>
            <char from="&#x59;" to="&#x2CAD;"/>
        </coptic></root>
    </xsl:variable>
    <xsl:key name="greek" match="$chars/local:root/local:coptic/local:char" use="string(@from)"/>
    
    <xsl:template name="start">
        <xsl:variable name="coptic" select="$chars/local:root/local:coptic"/>y
        
        <xsl:variable name="convert">
            <xsl:for-each select="for $c in string-to-codepoints($testString) return codepoints-to-string($c)">
                <xsl:value-of select="(., for $i in $coptic/* return $i[@from eq .]/to)"/>
            </xsl:for-each>
            
        </xsl:variable>
        <xsl:value-of select="$convert"/>
        
        
    </xsl:template>
    
</xsl:stylesheet>