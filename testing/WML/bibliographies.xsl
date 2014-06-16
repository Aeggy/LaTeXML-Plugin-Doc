<?xml version="1.0" encoding="utf-8"?>
<!--
/=====================================================================\ 
|  ltx2word.xsl                                                       |
|  Stylesheet for converting LaTeXML documents to OOXML          |
|=====================================================================|
| not yet Part of LaTeXML: http://dlmf.nist.gov/LaTeXML/              |
|=====================================================================|
| Michael Kohlhase http://kwarc.info/kohlhase                 #_#     |
| Public domain software                                     (o o)    |
\=========================================================ooo==U==ooo=/
-->
<xsl:stylesheet xmlns:ltx="http://dlmf.nist.gov/LaTeXML" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" xmlns:exsl="http://exslt.org/common" version="1.0" exclude-result-prefixes="ltx">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="/">
    <b:Sources xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" xmlns="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" SelectedStyle="\APA.XSL" StyleName="APA">
      <xsl:apply-templates/>
    </b:Sources>
  </xsl:template>
  <xsl:template match="text()"/>
  <xsl:template match="ltx:bibtag[@class='ltx_bib_year' and @role='year']">
    <b:Year>
      <xsl:value-of select="./text()"/>
    </b:Year>
  </xsl:template>
  <xsl:template match="ltx:bibitem">
    <b:source>
      <b:SourceType>
        <xsl:value-of select="./@type"/>
      </b:SourceType>
      <xsl:apply-templates/>
    </b:source>
  </xsl:template>
  <xsl:template match="ltx:bibtag[@class='ltx_bib_number' and @role='number' ]">
    <b:Tag>
      <xsl:value-of select="./text()"/>
    </b:Tag>
  </xsl:template>
  <xsl:template match="ltx:bibtag[@class='ltx_bib_title' and @role='title']">
    <b:Title>
      <xsl:value-of select="./text()"/>
    </b:Title>
  </xsl:template>
  <xsl:template match="ltx:bibtag[@class='ltx_bib_author' and @role='authors' and not(../ltx:bibtag[@role='fullauthors'])]">
<xsl:variable name="foo">
<xsl:call-template name="output-tokens">
	<xsl:with-param name="list" select="./text()"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="bar">
<xsl:call-template name="without-last">
	<xsl:with-param name="list" select="./text()"/>
</xsl:call-template>
</xsl:variable>
<b:Author>
      <b:Author>
        <b:NameList>
          <b:Person>
          <xsl:for-each select="exsl:node-set($foo)/id[not(./text()='and ')]">
          <xsl:if test="position()=last()">
          	<b:Last><xsl:value-of select="./text()"/></b:Last>
          </xsl:if>
          <xsl:if test="position()=1 and not(position()=last())">
          	<b:First><xsl:value-of select="./text()"/></b:First>
          </xsl:if>
          </xsl:for-each>
          	<xsl:if test="substring-after($bar,' ')">
		<b:Middle>
		<xsl:value-of select="substring-after($bar,' ')"/>
		</b:Middle>
	</xsl:if>
          </b:Person>
        </b:NameList>
      </b:Author>
    </b:Author>
  </xsl:template>
  <!--========================================================== Functions ==============================================================-->
  <xsl:template name="without-last"> <!-- Outputs a sentence without the last word. --> 
    <xsl:param name="list"/>
    <xsl:variable name="first" select="substring-before(concat($list,' '),' ')"/>
    <xsl:variable name="remaining" select="substring-after($list,' ')"/>
    <xsl:if test="$remaining">
      <xsl:value-of select="concat($first,' ')"/>
      <xsl:call-template name="without-last">
        <xsl:with-param name="list" select="$remaining"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
   <xsl:template name="output-tokens"> <!-- Outputs a sentence without the last word. --> 
    <xsl:param name="list"/>
    <xsl:variable name="first" select="substring-before(concat($list,' '),' ')"/>
    <xsl:variable name="remaining" select="substring-after($list,' ')"/>
            <id>
      <xsl:value-of select="$first"/>
    </id>
    <xsl:if test="$remaining">
      <xsl:call-template name="output-tokens">
        <xsl:with-param name="list" select="$remaining"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
