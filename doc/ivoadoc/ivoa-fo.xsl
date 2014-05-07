<?xml version="1.0" encoding="UTF-8"?>
<!-- Derived from W3-REC stype from antenna house  - it still needs much work to make it really production quality. 

Is being targeted at the apache-fop implementation - consequently has some tweaks from ideal (e.g. in table handling)

Paul Harrison
-->
<!--

Copyright Antenna House, Inc. (http://www.antennahouse.com) 2001, 2002.

Since this stylesheet is originally developed by Antenna House to be used with XSL Formatter, it may not be compatible with another XSL-FO processors.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, provided that the above copyright notice(s) and this permission notice appear in all copies of the Software and that both the above copyright notice(s) and this permission notice appear in supporting documentation.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml"
                >

  <xsl:import href="xhtml2fo.xsl"/>

  <xsl:output method="xml"
              version="1.0"
              encoding="UTF-8"
              indent="no"/>

  <!--======================================================================
      Parameters
  =======================================================================-->
  
  <xsl:param name="global-font-size">10pt</xsl:param>

  <!-- page size -->
  <xsl:param name="page-width">auto</xsl:param>
  <xsl:param name="page-height">auto</xsl:param>
  <xsl:param name="page-margin-top">1in</xsl:param>
  <xsl:param name="page-margin-bottom">1in</xsl:param>
  <xsl:param name="page-margin-left">0.8in</xsl:param>
  <xsl:param name="page-margin-right">0.8in</xsl:param>

  <!-- page header and footer -->
  <xsl:param name="page-header-margin">0.5in</xsl:param>
  <xsl:param name="page-footer-margin">0.5in</xsl:param>
  <xsl:param name="title-print-in-header">true</xsl:param>
  <xsl:param name="page-number-print-in-footer">true</xsl:param>

  <!-- multi column -->
  <xsl:param name="column-count">1</xsl:param>
  <xsl:param name="column-gap">12pt</xsl:param>

  <!-- writing-mode: lr-tb | rl-tb | tb-rl -->
  <xsl:param name="writing-mode">lr-tb</xsl:param>

  <!-- text-align: justify | start -->
  <xsl:param name="text-align">justify</xsl:param>

  <!-- hyphenate: true | false -->
  <xsl:param name="hyphenate">true</xsl:param>


  <!--======================================================================
      Attribute Sets
  =======================================================================-->

  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Root
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:attribute-set name="root">
    <xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
    <xsl:attribute name="hyphenate"><xsl:value-of select="$hyphenate"/></xsl:attribute>
    <xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
    <xsl:attribute name="language"><xsl:text>en</xsl:text></xsl:attribute>
    <xsl:attribute name="font-size"><xsl:value-of select="$global-font-size"/></xsl:attribute>
    
    <!-- specified on fo:root to change the properties' initial values -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page">
    <xsl:attribute name="page-width"><xsl:value-of select="$page-width"/></xsl:attribute>
    <xsl:attribute name="page-height"><xsl:value-of select="$page-height"/></xsl:attribute>
    <!-- specified on fo:simple-page-master -->
  </xsl:attribute-set>

  <xsl:attribute-set name="body">
    <!-- specified on fo:flow's only child fo:block -->
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="page-header">
    <!-- specified on (page-header)fo:static-content's only child fo:block -->
    <xsl:attribute name="font-size">small</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="page-footer">
    <!-- specified on (page-footer)fo:static-content's only child fo:block -->
    <xsl:attribute name="font-size">small</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>


  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Inline-level
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:attribute-set name="strong">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>


  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Block-level
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:attribute-set name="h1">
    <xsl:attribute name="font-size">170%</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#005A9C</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h2">
    <xsl:attribute name="font-size">140%</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#005A9C</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h3">
    <xsl:attribute name="font-size">120%</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#005A9C</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h4">
    <xsl:attribute name="font-size">100%</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#005A9C</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h5">
    <xsl:attribute name="font-size">100%</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#005A9C</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h6">
    <xsl:attribute name="font-size">100%</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-variant">small-caps</xsl:attribute>
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#005A9C</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="p">
  </xsl:attribute-set>

  <xsl:attribute-set name="blockquote">
  </xsl:attribute-set>

  <xsl:attribute-set name="pre">
    <xsl:attribute name="start-indent">inherited-property-value(start-indent) + 2em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="address">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="hr">
  </xsl:attribute-set>

  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       List
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->
  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Table
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->
  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Inline-level
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->
  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Link
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->
  <!-- default attributes are defined in xhtml2fo.xsl -->


  <!--======================================================================
      misc. additional
  =======================================================================-->

  <!-- .hide { display: none } -->
  <xsl:template match="*[@class = 'hide']"/>

  <!-- div.head { margin-bottom: 1em } -->
  <xsl:template match="html:div[@class = 'head']">
    <fo:block space-after="1em">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <!-- div.head h1 { margin-top: 2em; clear: both } -->
  <xsl:template match="html:div[@class = 'head']//html:h1">
    <fo:block xsl:use-attribute-sets="h1"
              space-before="2em" space-before.conditionality="retain">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <!-- div.head table { margin-left: 2em; margin-top: 2em } -->
  <xsl:template match="html:div[@class = 'head']//html:table">
  <!-- pah removed table caption from here - apache FOP does not do this... -->
      <fo:table xsl:use-attribute-sets="table">
        <xsl:call-template name="process-table"/>
      </fo:table>
   </xsl:template>

  <!-- div.head img { color: white; border: none } /* remove border from top image */ -->
  <xsl:template match="html:div[@class = 'head']//html:img">
    <fo:external-graphic xsl:use-attribute-sets="img"
                         color="white" border="none">
      <xsl:call-template name="process-img"/>
    </fo:external-graphic>
  </xsl:template>

  <!-- p.copyright { font-size: small } -->
  <xsl:template match="html:p[@class = 'copyright']">
    <fo:block xsl:use-attribute-sets="p" font-size="small">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <!-- p.copyright small { font-size: small } -->
  <xsl:template match="html:p[@class = 'copyright']//html:small">
    <fo:inline font-size="small">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <!-- ul.toc { list-style: none; } -->
  <xsl:template match="html:div[@class='toc']//html:ul/html:li">
    <fo:list-item xsl:use-attribute-sets="ul-li">
      <xsl:call-template name="process-common-attributes"/>
      <fo:list-item-label>
        <fo:block/>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block text-align-last="justify">
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- ul { list-style: none; } -->
  <xsl:template match="html:ul[@class='nonestylelist']/html:li">
    <fo:list-item xsl:use-attribute-sets="ul-li">
      <xsl:call-template name="process-common-attributes"/>
      <fo:list-item-label>
        <fo:block/>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="html:strong">
    <fo:inline xsl:use-attribute-sets="strong">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>


  <!-- special raw xml markup -->
  
    
  <xsl:template match="html:div[@class='viewxml']">
  <!-- perhaps put a border? -->
  <fo:block font-size="80%" text-align="left"  font-stretch="narrower" >
     <fo:list-block>
    <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:list-block>
  </fo:block>  
  </xsl:template>
   <xsl:template match="html:span[@class]" priority="1">
      <fo:inline>
         <xsl:choose>
            <xsl:when test="@class='start-tag'">
               <xsl:attribute name="font-weight">bold</xsl:attribute>
               <xsl:attribute name="color">#009999</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='end-tag'">
               <xsl:attribute name="font-weight">bold</xsl:attribute>
               <xsl:attribute name="color">#009999</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='cdata'">
               <xsl:attribute name="color">#CC0066</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='doctype'">
               <xsl:attribute name="font-style">italic</xsl:attribute>
               <xsl:attribute name="color">steelblue</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='pi'">
               <xsl:attribute name="font-style">italic</xsl:attribute>
               <xsl:attribute name="color">orchid</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='entity'">
               <xsl:attribute name="font-weight">normal</xsl:attribute>
               <xsl:attribute name="color">#FF4500</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='attribute-name'">
               <xsl:attribute name="font-weight">bold</xsl:attribute>
               <xsl:attribute name="color">#E88CA4</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='attribute-value'">
               <xsl:attribute name="font-weight">normal</xsl:attribute>
               <xsl:attribute name="color">blue</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='attribute-value'">
               <xsl:attribute name="font-weight">normal</xsl:attribute>
            </xsl:when>
            <xsl:when test="@class='markup'">
               <xsl:attribute name="font-weight">normal</xsl:attribute>
               <xsl:attribute name="color">#009933</xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <xsl:call-template name="process-common-attributes-and-children" />
      </fo:inline>
  </xsl:template>
   <xsl:attribute-set name="xmlinc">
      <xsl:attribute name="provisional-distance-between-starts">1.0em</xsl:attribute>
      <xsl:attribute name="font-family">Monaco, monospace</xsl:attribute>
   </xsl:attribute-set>
   <xsl:template
      match="html:div[@class='element']|html:div[@class='text']|html:div[@class='pi']|html:div[@class='comment']"
   >
      <fo:list-item>
         <fo:list-item-label>
            <fo:block />
         </fo:list-item-label>
         <fo:list-item-body start-indent="body-start()">
            <xsl:choose>
            <xsl:when test="@class='comment'">
             <fo:block>
               <xsl:attribute name="font-family">Courier, monospace</xsl:attribute>
               <!-- <xsl:attribute name="white-space">pre</xsl:attribute> -->
              <xsl:attribute name="font-style">italic</xsl:attribute>
              <xsl:attribute name="color">green</xsl:attribute>
              <xsl:attribute name="background-color">#D4EA8D</xsl:attribute>
               <xsl:apply-templates />
            </fo:block>   
            </xsl:when>         
            <xsl:when test="@class='pi'">
             <fo:block>
               <xsl:attribute name="font-style">italic</xsl:attribute>
               <xsl:attribute name="color">orchid</xsl:attribute>
               <xsl:apply-templates />
            </fo:block>   
            </xsl:when>         
            <xsl:otherwise>
            <fo:block xsl:use-attribute-sets="xmlinc">
               <xsl:apply-templates />
            </fo:block>
            </xsl:otherwise>
            </xsl:choose>
         </fo:list-item-body>
      </fo:list-item>
   </xsl:template>
   <xsl:template match="html:div[@class='indent']">
      <fo:list-block xsl:use-attribute-sets="xmlinc">
         <xsl:apply-templates />
      </fo:list-block>
   </xsl:template> 
   <xsl:template match="html:div[@id='titlehead']">
               <fo:block-container role="html:div" id="titlehead" position="relative" height="4cm" width="500px">
                  <fo:block start-indent="0pt" end-indent="0pt">
                     <fo:block-container role="html:div" id="logo" position="absolute" width="8cm" 
                                         left="5mm"
                                         top="0px">
                        <fo:block start-indent="0pt" end-indent="0pt">
	                          <fo:external-graphic color="white" border="none" content-width="8cm" scaling="uniform"
                                                src="url('http://www.ivoa.net/pub/images/ivoa_logoc.jpg')"
                                                />
                        </fo:block>
                     </fo:block-container>
                     <fo:block-container role="html:div" id="logo-title" position="absolute" left="7.5cm" top="1.05cm">
                        <fo:block start-indent="0pt" end-indent="0pt" font-style="italic">
    
                           <fo:block space-before="1em" space-after="1em" role="html:p">
                              <fo:inline font-weight="bold" >I</fo:inline>nternational
                           </fo:block>
                           <fo:block space-before="1em" space-after="1em" role="html:p" start-indent="1.4em">
                             <fo:inline font-weight="bold" >V</fo:inline>irtual
                           </fo:block>
                           <fo:block space-before="1em" space-after="1em" role="html:p" start-indent="1.4em">
                             <fo:inline font-weight="bold" >O</fo:inline>bservatory
                           </fo:block>
                           <fo:block space-before="1em" space-after="1em" role="html:p">
                             <fo:inline font-weight="bold" >A</fo:inline>ssociation
                           </fo:block>
                        </fo:block>
                     </fo:block-container>
                  </fo:block>
               </fo:block-container>    </xsl:template> 
               
    <xsl:template name="page-header">
       <fo:block space-before.conditionality="retain" 
                  text-align-last="right"
                  space-before="{$page-header-margin}"
                  xsl:use-attribute-sets="page-header">
          <xsl:if test="$title-print-in-header = 'true'">
            <xsl:value-of select="/html:html/html:head/html:title"/>
          </xsl:if>
          <fo:leader leader-pattern="space" leader-length="4cm"/>
         <fo:external-graphic color="white" border="none" content-width="1cm" scaling="uniform" 
                         src="url('http://www.ivoa.net/pub/images/ivoa_logoc.jpg')" />
       </fo:block> 
    </xsl:template>

</xsl:stylesheet>
