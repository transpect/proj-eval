<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:cx="http://xmlcalabash.com/ns/extensions"
  xmlns:tr="http://transpect.io"
  version="1.0"
  name="proj-eval" exclude-inline-prefixes="#all">
  
  <p:input port="catalog">
    <p:document href="../../xmlcatalog/catalog.xml"/>
  </p:input>
  
  <p:output port="result"/>
  
  <p:option name="path"  select="'http://this.transpect.io/'"/>
  <p:option name="module-factor" select="10"/>
  <p:option name="debug" select="'no'"/>
  <p:option name="debug-dir-uri" select="'debug'"/>
  <p:option name="exclude-filter" select="'(proj-eval|test_(before|after)|debug|makelib)'"/>
  
  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
  <p:import href="dir-eval.xpl"/>
  
  <p:xslt template-name="resolve" name="catalog-resolver">
    <p:input port="stylesheet">
      <p:document href="http://transpect.io/xslt-util/xslt-based-catalog-resolver/xsl/resolve-uri-by-catalog.xsl"/>
    </p:input>
    <p:with-param name="uri" select="$path"/>
  </p:xslt>
  
  <p:group>
    <p:variable name="proj-path" select="/result/@href"/>
  
    <tr:dir-eval name="eval-a9s">
      <p:with-option name="path" select="concat($proj-path, 'a9s')"/>
      <p:with-option name="exclude-filter" select="$exclude-filter"/>
    </tr:dir-eval>
  
    <p:directory-list name="dir-list">
      <p:with-option name="path" select="$proj-path"/>
    </p:directory-list>
    
    <p:for-each name="module-iteration">
      <p:iteration-source select="c:directory//c:directory[not(@name = ('.svn', 'a9s', 'calabash', 'conf', 'xmlcatalog'))]"/>
      
      <tr:dir-eval name="eval-module">
        <p:with-option name="path" select="concat($proj-path, c:directory/@name)"/>
        <p:with-option name="debug" select="$debug"/>
        <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/>
      </tr:dir-eval>
      
    </p:for-each>
    
    <p:wrap-sequence wrapper="results"/>
    
    <p:insert match="/results" position="first-child">
      <p:input port="insertion">
        <p:pipe port="result" step="eval-a9s"/>
      </p:input>
    </p:insert>
    
    <p:add-attribute match="/results" attribute-name="a9s-elm-count">
      <p:with-option name="attribute-value" select="/results/result[1]/@elm-count"/>
    </p:add-attribute>
    
    <p:add-attribute match="/results" attribute-name="a9s-line-count">
      <p:with-option name="attribute-value" select="/results/result[1]/@line-count"/>
    </p:add-attribute>
    
    <p:add-attribute match="/results" attribute-name="module-elm-count">
      <p:with-option name="attribute-value" select="sum(/results/result[position() ne 1]/@elm-count)"/>
    </p:add-attribute>
    
    <p:add-attribute match="/results" attribute-name="module-line-count">
      <p:with-option name="attribute-value" select="sum(/results/result[position() ne 1]/@line-count)"/>
    </p:add-attribute>
    
    <p:add-attribute match="/results" attribute-name="points">
      <p:with-option name="attribute-value" 
                     select="sum((/results/result[1]/@elm-count,
                                  /results/result[1]/@line-count,
                                  round-half-to-even(sum(/results/result[position() ne 1]/@elm-count) div $module-factor),
                                  round-half-to-even(sum(/results/result[position() ne 1]/@line-count) div $module-factor)))"/>
    </p:add-attribute>
    
    <tr:store-debug pipeline-step="proj-eval/results">
      <p:with-option name="active" select="$debug"/>
      <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>

  </p:group>
  
</p:declare-step>
