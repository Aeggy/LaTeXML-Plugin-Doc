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
<xsl:stylesheet xmlns:ltx="http://dlmf.nist.gov/LaTeXML" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" version="1.0" exclude-result-prefixes="ltx">
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
  <xsl:template match="ltx:bibtag[@class='ltx_bib_author' and @role='authors' and not(../ltx:bibtag[@role='fullauthors']) and not(contains(./text(),' and '))]" priority="0.6"><!-- I had to set priority manually, since it was being stupid. --> 
    <xsl:variable name="foo">
      <xsl:call-template name="last">
        <xsl:with-param name="list" select="./text()"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="bar">
      <xsl:call-template name="withoutlast">
        <xsl:with-param name="list" select="./text()"/>
      </xsl:call-template>
    </xsl:variable>
    <b:Author>
      <b:Author>
        <b:NameList>
          <b:Person>
            <xsl:if test="substring-after(./text(),' ')">
              <!-- There exists a first name -->
              <b:First>
                <xsl:value-of select="substring-before(./text(),' ')"/>
              </b:First>
            </xsl:if>
            <xsl:if test="substring-after(substring-after(./text(),' '),' ')">
              <!-- there exists a middle name -->
              <b:Middle>
                <xsl:value-of select="substring-after($bar,' ')"/>
              </b:Middle>
            </xsl:if>
            <b:Last>
              <xsl:value-of select="$foo"/>
            </b:Last>
          </b:Person>
        </b:NameList>
      </b:Author>
    </b:Author>
  </xsl:template>

  <xsl:template match="ltx:bibtag[@class='ltx_bib_author' and @role='authors']" priority="0.5"> <!-- I had to set priority manually because it was being stupid --> 
    <b:Author>
      <b:Author>
        <b:NameList>
          <xsl:call-template name="fullauthors">
            <xsl:with-param name="list" select="../ltx:bibtag[@role='fullauthors']/text()"/>
          </xsl:call-template>
        </b:NameList>
      </b:Author>
    </b:Author>
  </xsl:template>
  <!-- Functions -->
  <xsl:template name="last">
    <!-- this function gives the last word of a sentence that is separated by ' ' -->
    <xsl:param name="list"/>
    <xsl:variable name="first" select="substring-before(concat($list,' '), ' ')"/>
    <xsl:variable name="remaining" select="substring-after($list, ' ')"/>
    <xsl:if test="$remaining">
      <xsl:call-template name="last">
        <xsl:with-param name="list" select="$remaining"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="not($remaining)">
      <xsl:copy-of select="$first"/>
    </xsl:if>
  </xsl:template>
  <xsl:template name="withoutlast">
    <!-- this function gives everything but the last word in a sentence separated by ' '-->
    <xsl:param name="list"/>
    <xsl:variable name="first" select="substring-before(concat($list,' '), ' ')"/>
    <xsl:variable name="remaining" select="substring-after($list, ' ')"/>
    <xsl:if test="$remaining">
      <xsl:value-of select="concat($first,' ')"/>
      <xsl:call-template name="withoutlast">
        <xsl:with-param name="list" select="$remaining"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="not($remaining)">
    </xsl:if>
  </xsl:template>
  <xsl:template name="fullauthors">
    <xsl:param name="list"/>
    <xsl:variable name="first" select="substring-before($list,', ')"/>
    <xsl:variable name="remaining" select="substring-after($list,', ')"/>
    <xsl:variable name="foo">
    <ltx:bibtag class="ltx_bib_author" role="authors"><xsl:value-of select="$first"/></ltx:bibtag>
    </xsl:variable>
    <xsl:copy-of select="$foo"/>
   <!--  <xsl:apply-templates select="$foo"/> --> 
    <xsl:if test="$remaining">
      <xsl:call-template name="fullauthors">
        <xsl:with-param name="list" select="$remaining"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>