<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:gxsl="alias:namespace" exclude-result-prefixes="xs">
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- the base directory for all output files, must be a valid absolute or relative URI (no trailing slash required) -->
	<xsl:param name="output-base-dir" select="'.'"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:variable name="tex2unicode-xml-version" select="substring-before(substring-after(/tex2unicode/@version, '&#x24;Id: '), ' &#x24;')"/>
	<xsl:variable name="tex2unicode-xsl-version" select="substring-before(substring-after('$Id$', '&#x24;Id: '), ' &#x24;')"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:output name="xhtml" method="xhtml" omit-xml-declaration="yes" exclude-result-prefixes="xsl xs gxsl"/>
	<xsl:output name="sed-script" method="text" encoding="UTF-8" use-character-maps="unix-regex"/>
	<xsl:output name="xml" method="xml" encoding="US-ASCII" indent="yes"/>
	<xsl:namespace-alias stylesheet-prefix="gxsl" result-prefix="xsl"/>
	<xsl:character-map name="unix-regex">
		<!-- this map lists all characters that are special to solaris sed, according to the solaris regex man page -->
		<xsl:output-character character="\" string="\\"/>
		<xsl:output-character character="[" string="\["/>
		<xsl:output-character character="]" string="\]"/>
		<xsl:output-character character="*" string="\*"/>
		<xsl:output-character character="." string="\."/>
		<xsl:output-character character="^" string="\^"/>
		<xsl:output-character character="$" string="\$"/>
		<xsl:output-character character="-" string="\-"/>
		<xsl:output-character character="+" string="\+"/>
		<xsl:output-character character="{" string="\{"/>
		<xsl:output-character character="}" string="\}"/>
		<xsl:output-character character="(" string="\("/>
		<xsl:output-character character=")" string="\)"/>
	</xsl:character-map>
	<xsl:template match="/">
		<xsl:result-document href="{$output-base-dir}/tex2unicode.xhtml" format="xhtml">
			<xsl:message>generating tex2unicode.xhtml</xsl:message>
			<xsl:comment> generated from tex2unicode.xml (version <xsl:value-of select="$tex2unicode-xml-version"/>), do not edit by hand </xsl:comment>
			<table rules="groups" cellpadding="4">
				<thead>
					<tr>
						<th align="center" valign="bottom">Hex</th>
						<th align="center" valign="bottom">Decimal</th>
						<th align="center" valign="bottom">Character</th>
						<th align="center" valign="bottom">TeX Code</th>
						<th align="center" valign="bottom">TeX Code Variations</th>
						<th align="center" valign="bottom">XML Character Reference</th>
						<th align="center" valign="bottom">Part of ...</th>
						<th align="center" valign="bottom">Comment</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="/tex2unicode/map">
						<xsl:variable name="decunicode">
							<xsl:call-template name="Hex2Dec">
								<xsl:with-param name="value" select="unicode"/>
							</xsl:call-template>
						</xsl:variable>
						<tr>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="(position() div 2) != (floor(position() div 2))">l1</xsl:when>
									<xsl:otherwise>l2</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<td align="right">
								<xsl:value-of select="unicode"/>
							</td>
							<td align="right">
								<xsl:value-of select="$decunicode"/>
							</td>
							<td align="center">
								<xsl:value-of select="codepoints-to-string(xs:integer($decunicode))"/>
							</td>
							<td align="center">
								<code>
									<xsl:value-of select="tex[1]"/>
								</code>
							</td>
							<td align="center">
								<xsl:for-each select="tex[position() != 1]">
									<code>
										<xsl:value-of select="."/>
										<xsl:text> </xsl:text>
									</code>
								</xsl:for-each>
							</td>
							<td align="center">
								<code>
									<xsl:value-of select="concat('&amp;#x',unicode,';')"/>
								</code>
							</td>
							<td align="center">
								<xsl:value-of select="@charset"/>
							</td>
							<td align="left">
								<xsl:value-of select="comment"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:result-document>
		<xsl:result-document href="{$output-base-dir}/unicode2tex.sed" format="sed-script">
			<xsl:message>generating unicode2tex.sed</xsl:message>
			<xsl:text disable-output-escaping="yes"># generated from tex2unicode.xml (version </xsl:text>
			<xsl:value-of disable-output-escaping="yes" select="$tex2unicode-xml-version"/>
			<xsl:text disable-output-escaping="yes">), do not edit by hand&#xA;</xsl:text>
			<xsl:for-each select="/tex2unicode/map[not(@charset = 'US-ASCII')]">
				<!-- select only the mappings which are not US-ASCII chars -->
				<xsl:variable name="decunicode">
					<xsl:call-template name="Hex2Dec">
						<xsl:with-param name="value" select="unicode"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat('s/',codepoints-to-string(xs:integer($decunicode)),'/',tex[1],'/g&#xA;')"/>
			</xsl:for-each>
		</xsl:result-document>
		<xsl:result-document href="{$output-base-dir}/unicode2tex.xsl" format="xml">
			<xsl:message>generating unicode2tex.xsl</xsl:message>
			<gxsl:stylesheet version="2.0">
				<xsl:text>&#xA;</xsl:text>
				<xsl:comment> generated from tex2unicode.xml, do not edit by hand </xsl:comment>
				<xsl:text>&#xA;</xsl:text>
				<gxsl:variable name="tex2unicode-xml-version" select="'{$tex2unicode-xml-version}'"/>
				<gxsl:variable name="tex2unicode-xsl-version" select="'{$tex2unicode-xsl-version}'"/>
				<gxsl:variable name="US-ASCII-chars">
					<xsl:attribute name="select">
						<xsl:value-of select="'concat($ISO-8859-1-chars,&quot;'"/>
						<xsl:for-each select="/tex2unicode/map[@charset='US-ASCII']">
							<xsl:variable name="decunicode">
								<xsl:call-template name="Hex2Dec">
									<xsl:with-param name="value" select="unicode"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="codepoints-to-string(xs:integer($decunicode))"/>
						</xsl:for-each>
						<xsl:value-of select="'&quot;)'"/>
					</xsl:attribute>
				</gxsl:variable>
				<gxsl:character-map name="US-ASCII" use-character-maps="ISO-8859-1">
					<xsl:for-each select="/tex2unicode/map[@charset='US-ASCII']">
						<xsl:variable name="decunicode">
							<xsl:call-template name="Hex2Dec">
								<xsl:with-param name="value" select="unicode"/>
							</xsl:call-template>
						</xsl:variable>
						<gxsl:output-character character="{codepoints-to-string(xs:integer($decunicode))}" string="{tex[1]}"/>
					</xsl:for-each>
				</gxsl:character-map>
				<gxsl:variable name="ISO-8859-1-chars">
					<xsl:attribute name="select">
						<xsl:value-of select="'concat($all-chars,&quot;'"/>
						<xsl:for-each select="/tex2unicode/map[@charset='ISO-8859-1']">
							<xsl:variable name="decunicode">
								<xsl:call-template name="Hex2Dec">
									<xsl:with-param name="value" select="unicode"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="codepoints-to-string(xs:integer($decunicode))"/>
						</xsl:for-each>
						<xsl:value-of select="'&quot;)'"/>
					</xsl:attribute>
				</gxsl:variable>
				<gxsl:character-map name="ISO-8859-1" use-character-maps="all">
					<xsl:for-each select="/tex2unicode/map[@charset='ISO-8859-1']">
						<xsl:variable name="decunicode">
							<xsl:call-template name="Hex2Dec">
								<xsl:with-param name="value" select="unicode"/>
							</xsl:call-template>
						</xsl:variable>
						<gxsl:output-character character="{codepoints-to-string(xs:integer($decunicode))}" string="{tex[1]}"/>
					</xsl:for-each>
				</gxsl:character-map>
				<gxsl:variable name="all-chars">
					<xsl:attribute name="select">
						<xsl:value-of select="'&quot;'"/>
						<xsl:for-each select="/tex2unicode/map[not(@charset)]">
							<xsl:variable name="decunicode">
								<xsl:call-template name="Hex2Dec">
									<xsl:with-param name="value" select="unicode"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="codepoints-to-string(xs:integer($decunicode))"/>
						</xsl:for-each>
						<xsl:value-of select="'&quot;'"/>
					</xsl:attribute>
				</gxsl:variable>
				<gxsl:character-map name="all">
					<xsl:for-each select="/tex2unicode/map[not(@charset)]">
						<!-- select only the mappings which are not part of ISO 8859-1 -->
						<xsl:variable name="decunicode">
							<xsl:call-template name="Hex2Dec">
								<xsl:with-param name="value" select="unicode"/>
							</xsl:call-template>
						</xsl:variable>
						<gxsl:output-character character="{codepoints-to-string(xs:integer($decunicode))}" string="{tex[1]}"/>
					</xsl:for-each>
				</gxsl:character-map>
			</gxsl:stylesheet>
		</xsl:result-document>
	</xsl:template>
	<xsl:template name="Hex2Dec">
		<xsl:param name="value" select="'0'"/>
		<!-- the following paremeters are used only during recursion -->
		<xsl:param name="hex-power" select="number(1)"/>
		<xsl:param name="accum" select="number(0)"/>
		<!-- isolate last hex digit (and convert it to upper case) -->
		<xsl:variable name="hex-digit" select="translate(substring($value,string-length($value),1),'abcdef','ABCDEF')"/>
		<!-- check that hex digit is valid -->
		<xsl:choose>
			<xsl:when test="not(contains('0123456789ABCDEF',$hex-digit))">
				<!-- not a hex digit! -->
				<xsl:text>NaN</xsl:text>
			</xsl:when>
			<xsl:when test="string-length($hex-digit) = 0">
				<!-- unexpected end of hex string -->
				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- OK so far -->
				<xsl:variable name="remainder" select="substring($value,1,string-length($value)-1)"/>
				<xsl:variable name="this-digit-value" select="string-length(substring-before('0123456789ABCDEF',$hex-digit)) * $hex-power"/>
				<!-- determine whether this is the end of the hex string -->
				<xsl:choose>
					<xsl:when test="string-length($remainder) = 0">
						<!-- end - output final result -->
						<xsl:value-of select="$accum + $this-digit-value"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- recurse to self for next digit -->
						<xsl:call-template name="Hex2Dec">
							<xsl:with-param name="value" select="$remainder"/>
							<xsl:with-param name="hex-power" select="$hex-power * 16"/>
							<xsl:with-param name="accum" select="$accum + $this-digit-value"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
