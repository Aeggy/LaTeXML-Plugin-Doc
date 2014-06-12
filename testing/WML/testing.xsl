
<xsl:stylesheet
    version     = "1.0"
    xmlns:ltx   = "http://dlmf.nist.gov/LaTeXML"
    xmlns:xsl   = "http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes = "ltx">
    <xsl:output method="xml" indent="yes"/>
<xsl:template match="ltx:document">
<root>
 <xsl:apply-templates/> </root>
 </xsl:template>
    <xsl:template match="text()"/>
    <xsl:variable name="foo">
    <ltx:bibtag class="ltx_bib_author" role="authors">asdfasdfasf</ltx:bibtag>
    </xsl:variable>
    <xsl:template match="ltx:resource">
    <xsl:apply-templates select="$foo"/>
    </xsl:template>
    <xsl:template match="ltx:bibtag">
    <xsl:copy-of select="."/>
    </xsl:template>
    </xsl:stylesheet>


