<?xml version="1.0" encoding="UTF-8"?>
<!-- $Header: /usr/cvs/Sharef/Sharef/bibconvert/xslt/topic2keyword.xsl,v 1.2 2005/12/14 14:53:17 dret Exp $ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sharef="http://dret.net/xmlns/sharef" xmlns="http://dret.net/xmlns/sharef" xmlns:rfc="http://www.rfc-editor.org/rfc-index" exclude-result-prefixes="sharef">
	<xsl:variable name="document" select="."/>
	<xsl:variable name="topicmap" select="doc('wwww.xml')"/>
	<xsl:variable name="rfc-index" select="doc('rfc-index.xml')"/>
	<xsl:variable name="keywords" select="for $i in /sharef:bibliography/sharef:reference/sharef:field[@type eq 'bibtex:topic'] return for $j in tokenize($i/text(), '\s+') return substring-before($j, '[')"/>
	<xsl:key name="topic" match="topic" use="@TID"/>
	<xsl:key name="reference" match="sharef:reference" use="@name"/>
	<xsl:key name="rfc" match="rfc:rfc-entry" use="rfc:doc-id/text()"/>
	<xsl:template match="/ | * | text() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sharef:bibliography">
		<xsl:copy>
			<!-- first process the attributes ... -->
			<xsl:apply-templates select="@*"/>
			<!-- ... then insert the 'drettest' attribute ... -->
			<xsl:attribute xmlns:drettest="http://dret.net/xmlns/drettest" name="drettest:drettest" select="'drettest'"/>
			<!-- ... then create the only association definition we need ... -->
			<associationdef id="updates">
				<association>Updates</association>
				<forward>updates</forward>
				<reverse>is updated by</reverse>
			</associationdef>
			<!-- ... then insert all keyword definitions ... -->
			<xsl:for-each select="$topicmap/topicmap/topics/topic[@TID = $keywords]">
				<keyworddef id="topic-{@TID}">
					<keyword>
						<xsl:value-of select="name/text()"/>
					</keyword>
					<xsl:if test="exists(alias)">
						<alias>
							<xsl:value-of select="alias/text()"/>
						</alias>
					</xsl:if>
					<xsl:if test="exists(desc)">
						<description>
							<richtext>
								<p>
									<xsl:apply-templates select="desc/node()"/>
								</p>
							</richtext>
						</description>
					</xsl:if>
				</keyworddef>
			</xsl:for-each>
			<!-- ... and finally process the children of the bibliography element -->
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="topicref">
		<xsl:choose>
			<xsl:when test="@TID = $keywords">
				<!-- the keyword is referenced from a reference, so it is copied across and can be referenced -->
				<keywordref type="{@TID}"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="key('topic', @TID)/name/text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text">
		<xsl:value-of select="@date"/>
	</xsl:template>
	<xsl:template match="sharef:field[@type eq 'bibtex:topic']">
		<xsl:variable name="name" select="../@name"/>
		<annotation>
			<richtext>
				<p>
					<xsl:text>Keywords: </xsl:text>
					<xsl:for-each select="tokenize(text(), '\s+')">
						<xsl:choose>
							<xsl:when test="not(matches(., '\i\c*\[\d(\.\d)?\]'))">
								<xsl:message>
									<xsl:value-of select="concat('Syntax error for topic &quot;', ., '&quot; in reference ', $name)"/>
								</xsl:message>
							</xsl:when>
							<xsl:when test="(number(replace(., '\i\c*\[(\d(\.\d)?)\]', '$1')) gt 1) or (number(replace(., '\i\c*\[(\d(\.\d)?)\]', '$1')) lt 0)">
								<xsl:message>
									<xsl:value-of select="concat('Illegal weight &quot;', ., '&quot;for topic in reference ', $name)"/>
								</xsl:message>
							</xsl:when>
							<xsl:when test="not(exists(key('topic', substring-before(., '['), $topicmap)))">
								<xsl:message>
									<xsl:value-of select="concat('Undefined topic &quot;', . ,'&quot; in reference ', $name)"/>
								</xsl:message>
								<xsl:value-of select="concat('(undefined keyword: ', substring-before(., '['), '); ')"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- everything looks good, create a keyword reference -->
								<keywordref type="topic-{substring-before(., '[')}">
									<xsl:if test="number(substring-before(substring-after(., '['), ']')) ne 1">
										<xsl:attribute name="weight" select="number(substring-before(substring-after(., '['), ']'))"/>
									</xsl:if>
								</keywordref>
								<xsl:text>; </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</p>
			</richtext>
		</annotation>
	</xsl:template>
	<xsl:template match="sharef:field[@type eq 'bibtex:updates']">
		<xsl:variable name="name" select="../@name"/>
		<associations>
			<xsl:for-each select="tokenize(text(), '\s+')">
				<xsl:choose>
					<xsl:when test="not(exists(key('reference', ., $document)))">
						<xsl:message>
							<xsl:value-of select="concat('Updates xref to unknown reference &quot;', . ,'&quot; in reference ', $name)"/>
						</xsl:message>
					</xsl:when>
					<xsl:otherwise>
						<xref type="updates" target="{.}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</associations>
	</xsl:template>
	<xsl:template match="sharef:reference">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*[not(local-name() eq 'id')]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sharef:reference[matches(@name, '^rfc\d+$')]">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*[not(local-name() eq 'id')]"/>
			<xsl:variable name="rfc-name" select="concat('RFC', format-number(number(substring-after(@name, 'rfc')), '0000'))"/>
			<identifier type="sharef:uri" resourceType="text/plain">
				<xsl:value-of select="concat('http://dret.net/rfc-index/reference/', $rfc-name)"/>
			</identifier>
			<xsl:variable name="abstract" select="normalize-space(key('rfc', $rfc-name, $rfc-index)/rfc:abstract/text())"/>
			<xsl:if test="string-length($abstract) > 0">
				<abstract>
					<richtext>
						<p>
							<xsl:value-of select="$abstract"/>
						</p>
					</richtext>
				</abstract>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
