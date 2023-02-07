<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" 
  xmlns:tr="http://transpect.io"
  version="1.0" 
  name="dir-eval" 
  type="tr:dir-eval">
  
  <p:output port="result"/>
  
  <p:option name="path" required="true"/>
  
  <p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>
  <p:import href="http://transpect.io/xproc-util/recursive-directory-list/xpl/recursive-directory-list.xpl"/>
  
  <tr:recursive-directory-list name="list-a9s">
    <p:with-option name="path" select="$path"/>
    <p:with-option name="exclude-filter" select="'proj-eval'"/>
  </tr:recursive-directory-list>
  
  <p:group>
    <p:variable name="xproc-count" select="count(//c:file[ends-with(@name, '.xpl')])"/>
    <p:variable name="xslt-count"  select="count(//c:file[ends-with(@name, '.xsl')])"/>
    
    <p:viewport match="c:file[matches(@name, '\.(xpl|xsl)$')]" name="code-viewport">
      <p:output port="result"/>
      <p:variable name="filename" select="c:file/@name"/>
      <p:variable name="ext" select="replace($filename, '^.+\.([a-z]+)$', '$1')"/>
      
      <p:load>
        <p:with-option name="href" select="concat(base-uri(c:file), $filename)"/>
      </p:load>
      
      <p:wrap match="/*">
        <p:with-option name="wrapper" select="if($ext = 'xpl') then 'xproc' else 'xslt'"/>
      </p:wrap>
      
      <p:choose>
        <p:when test="xproc">
          <p:add-attribute attribute-name="count" match="/*">
            <p:with-option name="attribute-value" select="count(//*)"/>
          </p:add-attribute>
        </p:when>
        <p:otherwise>
          <p:add-attribute attribute-name="count" match="/*">
            <p:with-option name="attribute-value" select="count(//*)"/>
          </p:add-attribute>
        </p:otherwise>
      </p:choose>
      
    </p:viewport>
    
    <p:group>
      <p:variable name="xproc-elm-count" select="sum(//xproc/@count)"/>
      <p:variable name="xslt-elm-count"  select="sum(//xslt/@count)"/>
      
      <p:sink/>
      
      <p:add-attribute match="/result" attribute-name="path">
        <p:with-option name="attribute-value" select="$path"/>
        <p:input port="source">
          <p:inline>
            <result/>
          </p:inline>
        </p:input>
      </p:add-attribute>
      
      <p:add-attribute attribute-name="xproc-count" match="/result">
        <p:with-option name="attribute-value" select="$xproc-count"/>
      </p:add-attribute>
      
      <p:add-attribute attribute-name="xproc-elm-count" match="/result">
        <p:with-option name="attribute-value" select="$xproc-elm-count"/>
      </p:add-attribute>
      
      <p:add-attribute attribute-name="xslt-count" match="/result">
        <p:with-option name="attribute-value" select="$xslt-count"/>
      </p:add-attribute>
      
      <p:add-attribute attribute-name="xslt-elm-count" match="/result">
        <p:with-option name="attribute-value" select="$xslt-elm-count"/>
      </p:add-attribute>
      
    </p:group>
    
  </p:group>
  
</p:declare-step>