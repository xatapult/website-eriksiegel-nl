<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xtlwg="http://www.xtpxlib.nl/ns/xwebgen" xmlns:local="#local.ax1_hck_sxb" version="3.0" exclude-inline-prefixes="#all" name="this">

  <p:documentation>
    Main XProc 3.0 pipeline for creating the eriksiegel.nl website.
  </p:documentation>

  <!-- ======================================================================= -->
  <!-- IMPORTS: -->

  <p:import href="../../xtpxlib-xwebgen/xpl3/create-site.xpl"/>

  <!-- ======================================================================= -->
  <!-- PORTS: -->

  <p:output port="result" primary="true" sequence="false" content-types="xml" serialization="map{'method': 'xml', 'indent': true()}">
    <p:documentation>A small XML report about the processing</p:documentation>
  </p:output>

  <!-- ======================================================================= -->
  <!-- OPTIONS: -->

  <p:option name="href-specification" as="xs:string" required="false"
    select="resolve-uri('../src/website-eriksiegel-nl-specification.xml', static-base-uri())">
    <p:documentation>Reference to the xwebgen specification file</p:documentation>
  </p:option>

  <!-- ================================================================== -->
  <!-- MAIN: -->

  <!-- Create the sites: -->
  <xtlwg:create-site>
    <p:with-input href="{$href-specification}"/>
  </xtlwg:create-site>

  <!-- Create a report thingy: -->
  <p:wrap match="/*" wrapper="eriksiegel-nl-website-generation-results"/>
  <p:add-attribute attribute-name="timestamp" match="/*">
    <p:with-option name="attribute-value" select="string(current-dateTime())"/>
  </p:add-attribute>
  <p:add-attribute attribute-name="href-specification" match="/*">
    <p:with-option name="attribute-value" select="$href-specification"/>
  </p:add-attribute>

</p:declare-step>
