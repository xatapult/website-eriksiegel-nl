<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:local="#local.jsx_yjb_kz" version="1.0"
  xpath-version="2.0" exclude-inline-prefixes="#all" xmlns:xtlwg="http://www.xtpxlib.nl/ns/xwebgen">

  <p:documentation>
    Main XProc pipeline for creating the eriksiegel.nl website.
  </p:documentation>

  <!-- ================================================================== -->
  <!-- SETUP: -->

  <p:option name="href-specification" required="false" select="resolve-uri('../src/website-eriksiegel-nl-specification.xml', static-base-uri())">
    <p:documentation>Reference to the xwebgen specification file</p:documentation>
  </p:option>

  <p:output port="result" primary="true" sequence="false">
    <p:documentation>A small XML report about the processing</p:documentation>
  </p:output>
  <p:serialization port="result" method="xml" encoding="UTF-8" indent="true" omit-xml-declaration="false"/>

  <p:import href="../../xtpxlib-xwebgen/xplmod/create-site.mod/create-site.mod.xpl"/>

  <!-- ================================================================== -->
<!-- Create the site: -->
  
  <xtlwg:create-site>
    <p:with-option name="href-specification" select="$href-specification"/>
  </xtlwg:create-site>

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- Generate some report thingy: -->
  
  <p:wrap match="/*" wrapper="eriksiegel-nl-website-generation-results"/>
  <p:add-attribute attribute-name="timestamp" match="/*">
    <p:with-option name="attribute-value" select="current-dateTime()"/>
  </p:add-attribute>
  <p:add-attribute attribute-name="href-specification" match="/*">
    <p:with-option name="attribute-value" select="$href-specification"/>
  </p:add-attribute>

</p:declare-step>
