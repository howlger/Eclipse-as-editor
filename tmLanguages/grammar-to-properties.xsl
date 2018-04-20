<!-- Copyright (c) 2018 Holger Voormann.
Permission to copy, use, modify, sell and distribute this software is granted.
This software is provided "as is" without express or implied warranty,
and with no claim as to its suitability for any purpose. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:variable name="name"
            select="plist/dict/key[text()='name']/following-sibling::string[1]/text()"/>
        <xsl:text>name=</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>&#xA;id=</xsl:text>
        <xsl:value-of select="translate($name,
                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ _#!?',
                                        'abcdefghijklmnopqrstuvwxyz--s')"/>
        <xsl:text>&#xA;extensions=</xsl:text>
        <xsl:for-each select="plist/dict/key[text()='fileTypes']/following-sibling::array[1]/string">
	        <xsl:if test="position() > 1"><xsl:text>,</xsl:text></xsl:if>
	        <xsl:value-of select="text()"/>
        </xsl:for-each>
        <xsl:text>&#xA;extensions.label=</xsl:text>
        <xsl:for-each select="plist/dict/key[text()='fileTypes']/following-sibling::array[1]/string">
	        <xsl:if test="position() > 1"><xsl:text>, </xsl:text></xsl:if>
	        <xsl:value-of select="concat('*.', text())"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>