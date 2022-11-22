<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="#local.vnz_4vg_pvb"
  xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" expand-text="true">
  <!-- ================================================================== -->
  <!-- 
    Converts the menu structure into Bootstrap 5 HTML (for inside a <nav>).
    
    Remark: This stylesheet is designed to fail when the input menu structure is incorrect.
  -->
  <!-- ================================================================== -->
  <!-- SETUP: -->

  <xsl:output method="xml" indent="no" encoding="UTF-8"/>

  <xsl:mode on-no-match="fail"/>

  <!-- ================================================================== -->

  <xsl:template match="/">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/mainmenu">
    <div class="container-fluid">
      <ul class="nav justify-content-end nav-pills text-light">
        <xsl:apply-templates select="*"/>
      </ul>
    </div>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/mainmenu/menu">
    <xsl:choose>
      <xsl:when test="exists(submenu)">
        <li class="nav-item dropdown lead">
          <a class="nav-link dropdown-toggle text-light" data-bs-toggle="dropdown" href="#">{@caption}</a>
          <ul class="dropdown-menu">
            <xsl:apply-templates select="*"/>
          </ul>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <li class="nav-item lead">
          <a class="nav-link text-light" href="{@href}">{@caption}</a>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

  <xsl:template match="/mainmenu/menu/submenu">
    <li class="lead">
      <a class="dropdown-item" href="{@href}">{@caption}</a>
    </li>
  </xsl:template>

</xsl:stylesheet>
