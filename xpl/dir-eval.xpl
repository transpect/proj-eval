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
    <p:with-option name="exclude-filter" select="string-join(('proj-eval', 'makelib', $exclude-filter), '|')"/>
  </tr:recursive-directory-list>
  
  <cx:message>
    <p:with-option name="message" select="'[info] subdir: ', $path"/>
  </cx:message>
  
  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('proj-eval/dir-listing__', replace(replace($path, '^.+/(.+?/.+?/.+?)/?$', '$1'), '/', '--'))"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:viewport match="c:file[matches(@name, '\.(cls|css|conf\.xml|sch\.xml|sty|xpl|xsl)$')]" name="xml-viewport">
    <p:output port="result"/>
    <p:variable name="filename" select="c:file/@name"/>
    <p:variable name="filepath" select="concat(base-uri(c:file), $filename)"/>
    <p:variable name="ext" select="replace($filename, '^.+\.([a-z]+)$', '$1')"/>
    
    <cx:message>
      <p:with-option name="message" select="'[info] load: ', $filename"/>
    </cx:message>
    
    <p:choose name="analyze-text-or-xml">
      <p:when test="$ext = ('cls', 'css', 'sty')">
        
        <p:template name="create-request">
          <p:input port="template">
            <p:inline>
              <c:request href="{$filepath}" method="GET"/>
            </p:inline>
          </p:input>
          <p:with-param name="filepath" select="$filepath"/>
        </p:template>
        
        <p:http-request name="request" method="text" cx:timeout="5000"/>
        
        <p:rename match="c:body" new-name="text" name="wrap-text"/>
        
        <p:add-attribute attribute-name="line-count" match="/*">
          <p:with-option name="attribute-value" select="count(tokenize(., '\n', 'm')[normalize-space()])"/>
        </p:add-attribute>
        
      </p:when>
      <p:otherwise>
        
        <p:load name="load-xml">
          <p:with-option name="href" select="$filepath"/>
        </p:load>
        
        <p:wrap match="/*" wrapper="xml" name="wrap-xml"/>
        
        <p:add-attribute attribute-name="elm-count" match="/*">
          <p:with-option name="attribute-value" select="count(//*)"/>
        </p:add-attribute>
        
      </p:otherwise>
    </p:choose>
    
    <p:add-attribute attribute-name="name" name="add-filename" match="/*">
      <p:with-option name="attribute-value" select="$filename"/>
    </p:add-attribute>
        
  </p:viewport>
  
  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('proj-eval/dir-listing-expanded__', replace(replace($path, '^.+/(.+?/.+?/.+?)/?$', '$1'), '/', '--'))"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:group>
    <p:variable name="elm-count" select="sum(//xml/@elm-count)"/>
    <p:variable name="line-count" select="sum(//text/@line-count)"/>
    
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

    <p:add-attribute attribute-name="line-count" match="/result">
      <p:with-option name="attribute-value" select="$line-count"/>
    </p:add-attribute>
  </p:group>
  
</p:declare-step>
