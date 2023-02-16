<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:cx="http://xmlcalabash.com/ns/extensions"
  xmlns:tr="http://transpect.io"
  version="1.0" 
  name="dir-eval" 
  type="tr:dir-eval">
  
  <p:output port="result"/>
  
  <p:option name="path" required="true"/>
  <p:option name="debug" select="'no'"/>
  <p:option name="debug-dir-uri" select="'debug'"/>
  <p:option name="exclude-filter" select="''"/>
  
  <p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>
  <p:import href="http://transpect.io/xproc-util/recursive-directory-list/xpl/recursive-directory-list.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl" />
  
  <p:variable name="xml-ext-regex" select="'\.x(pl|sl)$'"/>
  
  <tr:recursive-directory-list name="list-a9s">
    <p:with-option name="path" select="$path"/>
    <p:with-option name="exclude-filter" select="string-join(('proj-eval', $exclude-filter), '|')"/>
  </tr:recursive-directory-list>
  
  <cx:message>
    <p:with-option name="message" select="'[info] count xproc/xslt elements in ', $path"/>
  </cx:message>
  
  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('proj-eval/dir-listing__', replace(replace($path, '^.+/(.+?/.+?/.+?)/?$', '$1'), '/', '--'))"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:viewport match="c:file[matches(@name, '\.x(pl|sl)$')]" name="code-viewport">
    <p:output port="result"/>
    <p:variable name="filename" select="c:file/@name"/>
    <p:variable name="ext" select="replace($filename, '^.+\.([a-z]+)$', '$1')"/>
    
    <p:load>
      <p:with-option name="href" select="concat(base-uri(c:file), $filename)"/>
    </p:load>
    
    <p:wrap match="/*" wrapper="xml"/>
    
    <p:add-attribute attribute-name="elm-count" match="/*">
      <p:with-option name="attribute-value" select="count(//*)"/>
    </p:add-attribute>
    
  </p:viewport>
  
  
  
  <p:group>
    <p:variable name="elm-count" select="sum(//xml/@elm-count)"/>
    
    <p:sink/>
    
    <p:add-attribute match="/result" attribute-name="path">
      <p:with-option name="attribute-value" select="$path"/>
      <p:input port="source">
        <p:inline>
          <result/>
        </p:inline>
      </p:input>
    </p:add-attribute>
    
    <p:add-attribute attribute-name="elm-count" match="/result">
      <p:with-option name="attribute-value" select="$elm-count"/>
    </p:add-attribute>    
  </p:group>
    
  
</p:declare-step>
