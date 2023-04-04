# proj-eval
Simple approach to evaluate the complexity of a transpect project

This XProc script can be checked out in a transpect project directory and evaluate the complexity of a project by analyzing the number of XML elements in XML files and lines in text files. The result is an XML file showing the number as function points.

You can invoke the script with an XProc processor, e.g. XML Calabash:

```shell
$ ./calabash/calabash.sh -o result=out.xml proj-eval/xpl/proj-eval.xpl debug=yes debug-dir-uri=file:/home/myUser/myProject/trunk/debug
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<results points="22956" module-elm-count="56804" a9s-line-count="954" module-line-count="437" a9s-elm-count="16278">
  <result line-count="954" path="file:/home/myUser/myProject/trunk/a9s" elm-count="16278"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/ace-daisy" elm-count="217"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/cascade" elm-count="1138"/>
  <result line-count="126" path="file:/home/myUser/myProject/trunk/css-tools" elm-count="7345"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/docxtools" elm-count="14661"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/epubcheck" elm-count="317"/>
  <result line-count="47" path="file:/home/myUser/myProject/trunk/epubtools" elm-count="4132"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/evolve-hub" elm-count="4291"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/fontlib" elm-count="0"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/fontmaps" elm-count="0"/>
  <result line-count="146" path="file:/home/myUser/myProject/trunk/htmlreports" elm-count="2048"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/htmltables" elm-count="194"/>
  <result line-count="89" path="file:/home/myUser/myProject/trunk/htmltemplates" elm-count="236"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/hub2html" elm-count="995"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/hub2tei" elm-count="1003"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/idml2xml" elm-count="5841"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/infrastructure" elm-count="0"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/kindlegen" elm-count="178"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/map-style-names" elm-count="435"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/proj-eval" elm-count="110"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/schema" elm-count="0"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/schematron" elm-count="2156"/>
  <result line-count="28" path="file:/home/myUser/myProject/trunk/tei2html" elm-count="1448"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/tei2hub" elm-count="622"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/use-css-decorator-classes" elm-count="101"/>
  <result line-count="1" path="file:/home/myUser/myProject/trunk/xproc-util" elm-count="3394"/>
  <result line-count="0" path="file:/home/myUser/myProject/trunk/xslt-util" elm-count="5942"/>
</results>
```
