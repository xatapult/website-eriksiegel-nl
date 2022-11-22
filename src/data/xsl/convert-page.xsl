<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="#local.ndr_kch_pvb"
  xmlns:file="http://expath.org/ns/file" xmlns:xtlc="http://www.xtpxlib.nl/ns/common" xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all" expand-text="true">
  <!-- ================================================================== -->
  <!-- 
       Converts a basic page into html. XML layout:
       
        <page>
          <block layout="text-left | text-right | text-full"> (text-full is default)
          
            <text>
              ...
            </text>
            
            <image href="..." @*?/> (href relative to the images directory)
             - or - 
            <carousel dir?="(directory with images only, relative to images directory)">
              <image .../>? (when @dir is specified, these elements are ignored)
            </carousel>
            - or -
            <youtube href="..."/>
            (for a text-full page the image/carousel/youtube element is ignored)
            
          </block>
          
          (block can repeat)
        </page>
  -->
  <!-- ================================================================== -->
  <!-- SETUP: -->

  <xsl:output method="xml" indent="no" encoding="UTF-8"/>

  <xsl:mode on-no-match="fail"/>
  <xsl:mode name="mode-handle-text" on-no-match="shallow-copy"/>

  <xsl:include href="../../../../xtpxlib-common/xslmod/href.mod.xsl"/>

  <!-- ================================================================== -->

  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/page">
    <div class="container">
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/page/block">

    <xsl:variable name="layout" as="xs:string" select="(@layout, 'text-full')[1] => normalize-space() => lower-case()"/>

    <div class="row pt-5">
      <xsl:choose>
        <xsl:when test="$layout eq 'text-left'">
          <div class="col-sm-6">
            <xsl:apply-templates select="text"/>
          </div>
          <div class="col-sm-6">
            <xsl:apply-templates select="(image | carousel | youtube)[1]"/>
          </div>
        </xsl:when>
        <xsl:when test="$layout eq 'text-right'">
          <div class="col-sm-6">
            <xsl:apply-templates select="(image | carousel | youtube)[1]"/>
          </div>
          <div class="col-sm-6">
            <xsl:apply-templates select="text"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <!-- text-full (or anything unrecognizable) is a block with text only. -->
          <div class="col-sm-12">
            <xsl:apply-templates select="text"/>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/page/block/text">
    <xsl:apply-templates mode="mode-handle-text"/>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/page/block/image">
    <xsl:call-template name="handle-image"/>
  </xsl:template>
  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="/page/block/youtube">
    <div class="tutorial container text-center my-5 ratio ratio-16x9">
      <iframe class="embed-responsive-item" src="{@href}?rel=0" allowfullscreen="true"></iframe>
    </div>
  </xsl:template>
  
  <!-- ======================================================================= -->
  <!-- CAROUSEL -->

  <xsl:template match="/page/block/carousel">
    <div class="carousel slide " data-bs-ride="carousel">
      <div class="carousel-inner">
        <xsl:choose>
          <xsl:when test="exists(@dir)">
            <!-- Handle directory with images -->
            <xsl:variable name="dir" as="xs:string" select="@dir"/>
            <xsl:variable name="dir-full" as="xs:string" select="resolve-uri('../../images/' || $dir, static-base-uri())"/>
            <xsl:comment> == Directory: {@dir-full} == </xsl:comment>
            <xsl:call-template name="handle-images-for-carousel">
              <xsl:with-param name="images" as="element(image)+">
                <xsl:for-each select="file:list($dir-full, false())" >
                  <image xmlns="" href="{xtlc:href-concat(($dir, .))}"/>
                </xsl:for-each>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="handle-images-for-carousel">
              <xsl:with-param name="images" select="image"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template name="handle-images-for-carousel">
    <xsl:param name="images" as="element(image)+" required="true"/>

    <xsl:for-each select="$images">
      <xsl:variable name="div-class-parts" as="xs:string+">
        <xsl:sequence select="'carousel-item'"/>
        <xsl:if test="position() eq 1">
          <xsl:sequence select="'active'"/>
        </xsl:if>
      </xsl:variable>
      <div class="{string-join($div-class-parts, ' ')}">
        <xsl:call-template name="handle-image"/>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- ======================================================================= -->
  <!-- CHANGE STUFF IN THE TEXT HTML: -->
  
  <xsl:template match="*" mode="mode-handle-text">
    <!-- Put in xhtml namespace -->
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="p[empty(@class)]" mode="mode-handle-text">
    <!-- Adds a class="lead" so the font is enhanced. -->
    <xsl:element name="{local-name()}">
      <xsl:attribute name="class" select="'lead'"/>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:element>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="a[empty(@style)]" mode="mode-handle-text">
    <!-- Removes the ugly underline from links -->
    <xsl:element name="{local-name()}">
      <xsl:attribute name="style" select="'text-decoration: none;'"/>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="processing-instruction() | comment()" mode="mode-handle-text">
    <!-- Discard -->
  </xsl:template>
  
  <!-- ======================================================================= -->
  <!-- GENERAL SUPPORT: -->

  <xsl:template name="handle-image">
    <xsl:param name="image" as="element(image)" required="false" select="."/>
    <img src="images/{$image/@href}" class="rounded img-fluid">
      <xsl:copy-of select="$image/@* except $image/@href"/>
    </img>
  </xsl:template>

</xsl:stylesheet>
