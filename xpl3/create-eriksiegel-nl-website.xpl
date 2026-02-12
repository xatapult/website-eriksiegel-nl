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

  <p:option name="cname" as="xs:string" required="false" select="'www.eriksiegel.nl'">
    <p:documentation> </p:documentation>
  </p:option>

  <!-- ================================================================== -->
  <!-- MAIN: -->

  <!-- Create the sites: -->
  <xtlwg:create-site name="step-create-site">
    <p:with-input href="{$href-specification}"/>
  </xtlwg:create-site>

  <!-- Create a CNAME document (for the GitHub pages): -->
  <p:variable name="base-output-dir" as="xs:string" select="/*/@base-output-dir"/>
  <p:if test="exists($cname)">
    <p:store serialization="map{'method': 'text'}" message="  * CNAME: {$cname}">
      <p:with-input>
        <p:inline xml:space="preserve" content-type="text/plain">{$cname}</p:inline>
      </p:with-input>
      <p:with-option name="href" select="string-join(($base-output-dir, 'CNAME'), '/')"/>
    </p:store>
  </p:if>

  <!-- Create a report thingy: -->
  <p:wrap match="/*" wrapper="eriksiegel-nl-website-generation-results">
    <p:with-input pipe="@step-create-site"/>
  </p:wrap>
  <p:add-attribute attribute-name="timestamp" match="/*">
    <p:with-option name="attribute-value" select="string(current-dateTime())"/>
  </p:add-attribute>
  <p:add-attribute attribute-name="href-specification" match="/*">
    <p:with-option name="attribute-value" select="$href-specification"/>
  </p:add-attribute>

</p:declare-step>
