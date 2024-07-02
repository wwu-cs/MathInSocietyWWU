<?xml version='1.0'?>

<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "./core/entities.ent">
    %entities;
]>

<!-- Identify as a stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:exsl="http://exslt.org/common"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    xmlns:pi="http://pretextbook.org/2020/pretext/internal"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="exsl date str"
    exclude-result-prefixes="pi"
>

<!-- import official pretext-latex style sheet -->
<xsl:import href="./core/pretext-latex.xsl"/>

<xsl:output method="text"/>

<xsl:param name="latex.preamble.early" select="'
    \usepackage{xcolor,euler,xurl}&#xa;
'"/>

<xsl:param name="latex.preamble.late" select="'
    \let\oldsection\section&#xa;
    \renewcommand\section{\znewpage\oldsection}&#xa;
    \let\oldchapter\chapter&#xa;
    \renewcommand\chapter{\clearpage\gdef\znewpage{\global\let\znewpage\clearpage}\oldchapter}&#xa;
    \global\let\znewpage\clearpage&#xa;
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{0.5pc}&#xa;
    \colorlet{blue}{black}&#xa;
    \colorlet{red}{black}&#xa;
    \colorlet{cyan}{black}&#xa;
    \colorlet{green}{black!15!white}&#xa;
    \colorlet{orange}{black!25!white}&#xa;
    \colorlet{brown}{black!35!white}&#xa;
    \colorlet{magenta}{gray}&#xa;
    \hypersetup{colorlinks=false}&#xa;
    \hypersetup{breaklinks=true}&#xa;
    \newtcolorbox[use counter from=block]{qrptx}[4]{width=2.5cm, lower separated=false, before lower={{\textbf{#1~\thetcbcounter}\space#2}}, phantomlabel={#3}, unbreakable, figureptxstyle, }
'"/>

<!-- QR code only for videos (no thumbnail) -->
<xsl:template match="video" mode="representations">
    <xsl:variable name="the-url">
        <xsl:apply-templates select="." mode="static-url"/>
    </xsl:variable>
    <!-- youtube variable already defined but seems to be needed again -->
    <xsl:variable name="youtube">
        <xsl:choose>
            <xsl:when test="@youtubeplaylist">
                <xsl:value-of select="normalize-space(@youtubeplaylist)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(str:replace(@youtube, ',', ' '))" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- give video a new name so it escapes assembly -->
    <margin-video>
        <image width="15%">
          <xsl:attribute name="pi:generated">
              <xsl:text>qrcode/</xsl:text>
              <xsl:apply-templates select="." mode="assembly-id"/>
              <xsl:text>.png</xsl:text>
          </xsl:attribute>
        </image>
    </margin-video>
</xsl:template>

<!-- video solutions go in the margin -->
<xsl:template match="figure[descendant::margin-video]">
    <xsl:param name="b-original" />
    <xsl:param name="purpose" />
    <xsl:param name="b-component-heading"/>
    <xsl:text>\noindent\tikz[overlay, remember picture]%&#xa;</xsl:text>
    <xsl:text>\node[anchor=north east, xshift=-1cm, yshift=-2cm] at (current page.north east) {%&#xa;</xsl:text>
    <xsl:text>\begin{qrptx}{}{%&#xa;</xsl:text>
    <xsl:text>}{}{}%&#xa;</xsl:text>
    <xsl:text>\end{qrptx}&#xa;</xsl:text>
    <xsl:apply-templates select="margin-video">
        <xsl:with-param name="b-original" select="$b-original" />
    </xsl:apply-templates>
    <xsl:text>};</xsl:text>
</xsl:template>

</xsl:stylesheet>
