<?xml version="1.0" encoding="UTF-8"?>
<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform"
              xmlns:xs="http://www.w3.org/2001/XMLSchema" 
              version="2.0"
              xmlns:h="http://www.w3.org/1999/xhtml"
              xmlns="http://www.w3.org/1999/xhtml"
              xmlns:vm="http://www.ivoa.net/xml/VOMetadata/v0.1" 
              xmlns:saxon="http://saxon.sf.net/" 
              exclude-result-prefixes="saxon vm xs h"
             >
  <x:import href="vor2spec.xsl"/>
  <x:param name="docversion">0.1</x:param> <!-- document version -->
  <x:param name="pubstatus">WD</x:param> <!-- publication status WD, PR, REC, NOTE -->
  <x:param name="ivoname">unnamed</x:param> <!-- the IVOA "short" name for the document -->
  <x:param name="docdate">19700101</x:param><!-- publication date in YYYYMMDD format -->
  <x:param name="filename">filename</x:param>
  
  <x:param name="target"/>
  <!-- The parameter docbase is the location where the final document
       will be served from.  This will always have the following value
       in final versions, but draft versions may appear for a while at
       a different location, and this can be parameterised when this
       stylesheet is invoked. -->
  <x:param name='docbase'>http://www.ivoa.net/documents/</x:param>
  
  <x:param name="reloadbib"/>


  <x:character-map name="cm1">
  <!-- stop &amp; being translated -->
    <x:output-character character="&#38;" string="&amp;amp;"/> 
    <x:output-character character="&#160;" string="&amp;nbsp;"/>
    <!-- see http://www.w3.org/2003/entities/iso9573-2003/iso9573-2003map.xsl for more entity maps... -->
  </x:character-map>
  <x:output method="xml" indent="no" use-character-maps="cm1"
            encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
            exclude-result-prefixes="saxon"
            />

  <!--
  This script is designed to help with the production of IVOA standards - it is derived from a script by Norman Gray, but is different in behaviour in that the document produced by the script is 
  intended to be used as input in the next round of editing.
  
  Paul Harrison
  
      The following supports a mildly-enhanced version of XHTML.  Most
      notably, it supports sectioning via nested <div class='section'>
      elements, with the section title being given by the first 
      <h1><a name="secid"/><span class="secnum">1.1</span> Title</h1> child of the <div>.  The <div> class can also
      be 'section-nonum', with the obvious meaning, and the div can
      have an 'id' attribute which allows cross-references to it.
      Cross-references are supported by a <span class='xref'>id</span> element.

      Appendices go in a <div class='appendices'>, and an abstract in
      <div class='abstract'>

      The <div>s can be collected into a ToC, at a location marked by
      a <?toc?> PI.

      Bibliography: entries can be marked with <span
      class='cite'>ref</span>, and these can be collected into a .aux
      file by running this stylesheet with the parameter 'target'
      given as 'aux'.  The location of the bibliography is marked by a
      <?bibliography?> PI: this simply reads in a file
      $document-id.bbl, the generation of which must be managed
      externally to this script.
      
      
      xml documents can be literally included (and formatted) with the <?xmlinc href=""?> processing instruction. The <?xmlinc ?> processing instruction should be enclosed within a <div> - All text within
      the <div> will be replaced.

      There's also a <span class='url'>url</span>, which formats the
      URL appropriately, and a
      <span class='rcsinfo'>$foo: bar $</span>, which extracts the
      contents 'bar' from the string.

      The output has extra properties added to support RDFa, using
      information extracted from 'title' and 'abstract', and from
      <meta name='DC.xxx'> and <meta name='rcsdate'> fields in the <head>
  -->

  <!-- We include support for RDFa in the following, via: the output doctype,
       the 'profile' attribute in the head element, and the various 'property'
       attributes in the text.
       See <http://www.w3.org/TR/2008/WD-rdfa-syntax-20080221/#docconf>.
       We also add a GRDDL transformation which independently specifies
       the RDFa transformation. -->


  <!-- process root node -->
  <x:template match="/">
    <x:choose>
      <x:when test="$target">
        <x:message terminate="yes">Unrecognised target <x:value-of select="$target"/>
        </x:message>
      </x:when>
      <x:otherwise>
        <x:apply-templates select="child::node()"/>
      </x:otherwise>
    </x:choose>
  </x:template>


  <x:template match="h:head">
    <head profile='http://www.w3.org/1999/xhtml/vocab'>
      <x:apply-templates select="@*"/>
      <x:apply-templates select="child::node()"/>
      <link rel="stylesheet" type="text/css">
        <x:attribute name="href">
          <x:choose>
            <x:when test="$pubstatus='WD'"
            	>http://www.ivoa.net/misc/ivoa_wd.css</x:when>
            <x:when test="$pubstatus='PR'"
            	>http://www.ivoa.net/misc/ivoa_pr.css</x:when>
            <x:when test="$pubstatus='REC'"
            	>http://www.ivoa.net/misc/ivoa_rec.css</x:when>
            <x:when test="$pubstatus='NOTE'"
            	>http://www.ivoa.net/misc/ivoa_note.css</x:when>
          </x:choose>
        </x:attribute>
      </link>
    </head>
  </x:template>


  <x:template match="h:div[@class='section' or @class='section-nonum']">
    <x:copy>
      <x:apply-templates select="@*"/>
      <x:variable name='id'>
        <x:call-template name='make-section-id'/>
      </x:variable>
      <x:variable name="level">
        <x:choose>
          <x:when test="ancestor::h:div[@class='section']/ancestor::h:div[@class='section']">h4</x:when>
          <x:when test="ancestor::h:div[@class='section']">h3</x:when>
          <x:otherwise>h2</x:otherwise>
        </x:choose>
      </x:variable>
      <x:message>section <x:value-of select="$level"/></x:message>
      <x:element name='{$level}'>
        <x:element name="a">
          <x:copy-of select="./(h:h1|h:h2|h:h3|h:h4)/h:a/@*[not(name()='name')]" />   
          <x:attribute name='id' select="$id"/>  
          <x:apply-templates select="." mode="make-section-name"/>
        </x:element>
      </x:element>
      <x:apply-templates select="*[1]/following-sibling::node()"/><!-- perhaps a little dangerous perhaps better to have a template to ignore the first h1 etc after a section... -->
    </x:copy> 
  </x:template>
 
 <!-- this is not perfect either - depends how many levels down...
  <x:template match="h:div[@class='section' or @class='section-nonum']/h1[1]|h2[1]|h3[1]">
  </x:template>
   --> 
  
  <!--
  <x:template match="h:div[@class='section' or @class='section-nonum']">
    <x:variable name="id">
      <x:call-template name="make-section-id"/>
    </x:variable>
    <x:variable name="level">
      <x:choose>
        <x:when test="ancestor::h:div[@class='section']/ancestor::h:div[@class='section']">h4</x:when>
        <x:when test="ancestor::h:div[@class='section']">h3</x:when>
        <x:otherwise>h2</x:otherwise>
      </x:choose>
    </x:variable>
    <x:element name="{$level}" namespace='http://www.w3.org/1999/xhtml'>
      <x:if test="@id">
        <x:attribute name='class'>hlink</x:attribute>
      </x:if>
      <x:apply-templates select="." mode="make-section-name"/>
      <x:element name='a' namespace='http://www.w3.org/1999/xhtml'>
        <x:attribute name='name'><x:value-of select='$id'/></x:attribute>
        <x:if test="@id">
          <x:attribute name='href'>#<x:value-of select='$id'/></x:attribute>
          <x:text> [link here]</x:text>
        </x:if>
      </x:element>
    </x:element>
    <x:apply-templates/>
  </x:template>
  -->


  <x:template match="h:div[@class='appendices']">
    <x:copy>
    <x:apply-templates select="@*"/>
   
    <x:apply-templates select="child::node()"/>
    </x:copy>
  </x:template>

  <x:template match="h:div" mode="make-toc">
    <x:variable name="id">
      <x:call-template name="make-section-id"/>
    </x:variable>
    <li>
      <a href='#{$id}'>
        <x:apply-templates select='.' mode='make-section-name'/>
      </a>
      <x:if test="h:div[@class='section' or @class='section-nonum']">
        <ul>
          <x:apply-templates select="h:div[@class='section' or @class='section-nonum']" mode="make-toc"/>
        </ul>
      </x:if>
    </li>
  </x:template>
  
  <x:template match="h:div[processing-instruction()[1][count(preceding-sibling::element()) = 0]]">
  <!-- the processing instructions will replace everything with the enclosing div if they are first - used for the toc, bibliography and xmlinc processing instucctions-->
    <x:copy>
    <x:comment>The contents of this div are automatically generated from the following processing instruction when processed with ivoarestructure.xsl</x:comment>
    <x:text>
    </x:text>
    <x:choose>
      <x:when test="child::processing-instruction('bibliography') and not($reloadbib)">
         <x:apply-templates/>
      </x:when>
      <x:otherwise>
         <x:apply-templates select="child::processing-instruction()"/>
      </x:otherwise>
    </x:choose>
    <x:text>
    </x:text>
    <x:comment>end of autogenerated content</x:comment>
    </x:copy>
 </x:template>

  <x:template match="processing-instruction('toc')">
  <x:processing-instruction name="toc"/>
    <div id='toc' class='toc'>
      <ul>
      <!-- select the top-level section DIVs wherever they are...-->
         <x:apply-templates select="//h:div[@class='section' or @class='section-nonum'][count(ancestor::h:div[@class='section' or @class='section-nonum']) = 0]" mode="make-toc"/>
      </ul>
    </div>
   
  </x:template>

  <x:template name="make-section-id">
    <x:choose>
      <x:when test="child::*[1]/h:a/@id">
        <x:value-of select="child::*[1]/h:a/@id"/>
      </x:when>
      <x:when test="child::*[1]/h:a/@name"> <!-- prefer id to name, but pick up name as that is allowable in html references -->
        <x:value-of select="child::*[1]/h:a/@name"/>
      </x:when>
      <x:otherwise>
        <x:value-of select="generate-id()"/>
      </x:otherwise>
    </x:choose>
  </x:template>

  <x:template match="h:div" mode="make-section-name">
    <x:element name="span">
      <x:attribute name="class" select="'secnum'"></x:attribute>
      <x:apply-templates select="." mode="make-section-number"/>

    <x:choose>
      <x:when test="ancestor-or-self::h:div[@class='section-nonum']"/>
      <x:otherwise><x:text>. </x:text></x:otherwise>
    </x:choose>
   </x:element>
    <!-- just select the text that is the heading not the number-->
    <x:value-of select="normalize-space(string-join(child::*[1]//text()[not(parent::h:span)], ''))"/>
  </x:template>
  
  <x:template match="h:div" mode="make-section-number"><!-- would named template be better? -->
    <x:choose>
      <x:when test="ancestor-or-self::h:div[@class='section-nonum']"/>
      <x:when test="ancestor::h:div[@class='appendices']">
        <!--<x:text>Appendix </x:text> need 'Appendix/section' in both or neither-->
        <x:number count="h:div[@class='section']" level="multiple" format="A.1"/>
        <!-- no extra spacing or punctuation, since this is used in xrefs, too -->
      </x:when>
      <x:otherwise>
        <x:number count="h:div[@class='section']" level="multiple" format="1.1"/>
      </x:otherwise>
    </x:choose>
  </x:template>

  <x:template match="processing-instruction('bibliography')">
    <x:copy/>
   <!--<x:choose>
      <x:when test="contains(.,'replace')">  --> <!-- only do if the PI has a "replace" pseudo attribute -->
         <!-- base-uri() is an XPath 2.0 function (a regexp would be better 
            here, to avoid depending on the base-uri ending in .html) -->
         <x:choose>
            <x:when test="$filename eq 'filename'"> <!-- override with this variable if below is not suitable -->
               <x:copy-of select="document(concat(substring-before(base-uri(), '.html'),'.bbl'))" />
            </x:when>
            <x:otherwise>
               <x:copy-of select="document(concat($filename,'.bbl'))" />
            </x:otherwise>
         </x:choose>
     <!--  </x:when>
   </x:choose> -->
  </x:template>

	<!-- the following is a highly experimental feature to complement the
		makefile-based ivoadoc; its biblio target creates a <standardname>.bbl
		file, which is included here. 
		
		Main trouble: if the bbl file does not exist, Saxon fails.
		I'm not sure if there's a way around that. -->
  <x:template match="processing-instruction('includebibliography')">
  	<x:copy-of select="document(concat('../', $ivoname, '.bbl'))"/>
  	<x:fallback/>
  </x:template>

  <x:template match="h:cite">
    <!-- need to do this as numbered along with bibstyle... -->
    <x:copy>
      <x:variable name="ref">
        <x:choose>
          <x:when test="h:a/@href">
            <x:value-of select="substring-after(h:a/@href,'#')"/>
          </x:when>
          <x:otherwise>
            <x:value-of select="."/>
          </x:otherwise>
        </x:choose>
      </x:variable>
      <x:text>[</x:text><x:element name="a" namespace="http://www.w3.org/1999/xhtml"><x:attribute name="href" select='concat("#",$ref)'/><x:value-of select='$ref'/></x:element><x:text>]</x:text>
    </x:copy>
  </x:template>

  <x:template match="h:span[@class='url']">
    <a href='{text()}'>
      <span class='url'><x:value-of select='.'/></span>
    </a>
  </x:template>

 
  <x:key name="xrefs" match="h:div[(h:h1|h:h2|h:h3|h:h4|h:h5|h:h6)/h:a]" use="*/h:a/@id"/><!-- can only reference sections at the moment -->

  <x:template match="h:span[@class='xref']">
    <span class="xref"><x:variable name="id">
      <x:choose>
        <x:when test="h:a/@href">
          <x:value-of select="substring-after(h:a/@href, '#')"/>
        </x:when>
        <x:otherwise>
          <x:value-of select="."/> <!-- can just put in the xref span -->
        </x:otherwise>
      </x:choose>
    </x:variable>
    <x:choose>
      <x:when test="key('xrefs',$id)">
        <x:message>putting in xref <x:value-of select="$id"/></x:message>
      </x:when>
      <x:otherwise>
        <x:message >error putting in xref <x:value-of select="$id"/> - destination does not exist </x:message>
      </x:otherwise>
    </x:choose>
    <a href='#{$id}'>
      <x:apply-templates select="key('xrefs',$id)" mode="make-section-number"/>
    </a>
    </span>
  </x:template>

  <x:template match="h:span[@class='rcsinfo']">
    <x:value-of select="substring-before(substring-after(.,': '),' $')"/>
  </x:template>

  <x:template match="h:span[@class='docversion']">
      <x:element name="span">
      <x:attribute name="class">docversion</x:attribute>
      <x:value-of select="$docversion"/>
      </x:element>
  </x:template>

<!-- maybe later
  <x:template xmlns:owl="http://www.w3.org/2002/07/owl#" match="h:meta">
    <x:choose>
      <x:when test="@name='DC.rights'">
        <link about='' rel='{@name}' href='{@content}'/>
      </x:when>
      <x:when test="@name='rcsdate'">
        <meta about='' property='dcterms:modified'>
          <x:attribute name='content'>
            <x:value-of select="translate(substring(@content,8,10),'/','-')"/>
            <x:text>T</x:text>
            <x:value-of select="substring(@content,19,8)"/>
          </x:attribute>
        </meta>
      </x:when>
      <x:when test="@name='purl'">
        <link about='' rel='dc:identifier' href='{@content}'/>
        <link about='' rel='owl:sameAs'    href='{@content}'/>
      </x:when>
      <x:when test="starts-with(@name,'DC.')">
        <meta about='' content='{@content}'>
          <x:attribute name="property">dc:<x:value-of select="substring-after(@name, 'DC.')"/>
          </x:attribute>
        </meta>
      </x:when>
      <x:when test='@property and @content'>
       
        <x:copy-of select='.'/>
      </x:when>
    </x:choose>
  </x:template>
   -->

  <x:template match="h:div[@class='signature']">
    <x:copy>
      <x:apply-templates select="@*"/>
      <x:choose>
        <x:when test="h:a/@href">
          <x:attribute name="href">
            <x:value-of select="h:a/@href"/>
          </x:attribute>
        </x:when>
        <x:otherwise>
          <x:attribute name="content">
            <x:value-of select="h:a/text()"/>
          </x:attribute>
        </x:otherwise>
      </x:choose>
      <x:apply-templates/>
    </x:copy>
  </x:template>

  <x:template match="h:div[@class='abstract']">
    <x:copy>
      <x:apply-templates select="@*"/>
      <x:element name='meta' namespace='http://www.w3.org/1999/xhtml'>
        <x:attribute name='about'/>
        <x:attribute name="content">
          <x:apply-templates select="h:p[not(@class)]" mode="text-only"/>
        </x:attribute>
      </x:element>
      <x:apply-templates select="child::node()"/>
    </x:copy>
  </x:template>

<!--  <x:template match="h:q">
    <x:text>“</x:text>
    <x:apply-templates/>
    <x:text>”</x:text>
  </x:template> --> 

  <x:template match="h:p" mode="text-only">
    <x:value-of select="normalize-space(.)"/>
    <x:text>  </x:text>
  </x:template>

  <x:template match="processing-instruction('incxml')">
      <x:copy/>
      <h:div class="viewxml">
        <x:analyze-string regex="href=[&quot;]([^&quot;]+)[&quot;] +select=[&quot;]([^&quot;]+)[&quot;]"  select=".">
          <x:matching-substring>
                <!-- crude ability to select an element and children - needs to be smartened up to more xpath like, but namespaces are a problem -->
                   <x:message>Including only <x:value-of select="regex-group(2)"/> element xml from <x:value-of select="regex-group(1)"/> </x:message>
                   <x:apply-templates select="document(regex-group(1))//saxon:evaluate(regex-group(2))" mode="printxml"></x:apply-templates>
           </x:matching-substring>
          <x:non-matching-substring>
        <x:analyze-string regex="href=[&quot;]([^&quot;]+)[&quot;]" select=".">
          <x:matching-substring>
          <x:message>Including xml from <x:value-of select="regex-group(1)"/></x:message>
            <x:apply-templates select="document(regex-group(1))" mode="printxml"></x:apply-templates>
          </x:matching-substring>
        </x:analyze-string>
          </x:non-matching-substring>
        </x:analyze-string>
       </h:div>
  </x:template>
  
  <x:template match="processing-instruction('schemadef')">
      <x:copy/>
      <x:message>schemadef <x:value-of select="."/></x:message>
      <x:choose>
        <x:when test="starts-with(., 'href')">
        <x:analyze-string regex="href=['&quot;]([^'&quot;]+)['&quot;] +defn=['&quot;]([^'&quot;]+)['&quot;]" select=".">
          <x:matching-substring>
          <x:message>Including schema from <x:value-of select="regex-group(1)"/> element <x:value-of select="regex-group(2)"/></x:message>
             <x:apply-templates select="document(regex-group(1))/saxon:evaluate('/xs:schema/(xs:complexType|xs:simpleType)[@name=$p1]',regex-group(2))" mode="def">
              <x:with-param name="thisprefix" select="document(regex-group(1))/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix" ></x:with-param>
            </x:apply-templates>
          </x:matching-substring>
          <x:non-matching-substring>
          <x:message>did not match <x:value-of select="."/></x:message>
          </x:non-matching-substring>
        </x:analyze-string>
        </x:when>
        
      </x:choose>
  </x:template>

   <!-- default identity transformation -->
  <x:template match="node()|@*">
    <x:copy>
      <x:apply-templates select="node()|@*"/>
    </x:copy>
  </x:template>
 
 <!-- printxml stuff -->

  <x:template match="/" mode="printxml" >
  
  <x:apply-templates select="child::node()" mode="printxml"/>
  
   </x:template>
  
<x:template match="/*" mode="printxml" priority="1"><!-- try to add the namespaces for the root element -->
<!--  <x:message>in root element <x:value-of select="name(.)"/></x:message> -->
          <div class="element">
          <span class="markup">&lt;</span><span class="start-tag"><x:value-of select="name(.)"/></span><x:apply-templates select="@*" mode="printxml"/>
          <x:variable  name="v" select="."/> 
          <x:for-each select="in-scope-prefixes(.)">
             <x:text> </x:text><span class="attribute-name"><x:text>xmlns:</x:text><x:value-of select="."/></span><span class="markup">=</span><span class="attribute-value">"<x:value-of select="namespace-uri-for-prefix(., $v)"/>"</span>
          </x:for-each>
          <span class="markup">&gt;</span>
          <div class="indent">
          <x:apply-templates select="child::node()"  mode="printxml"/>
          </div>
          <span class="markup">&lt;/</span><span class="end-tag"><x:value-of select="name(.)"/></span><span class="markup">&gt;</span>
          </div>
  </x:template>
  
  
  <x:template match="processing-instruction()" mode="printxml">
<!--   <x:message>printxml: pi <x:value-of select="name(.)"/></x:message>-->
    <div class="pi">
      <x:text>&lt;?</x:text>
      <x:value-of select="name(.)"/>
      <x:text> </x:text>
      <x:value-of select="."/>
      <x:text>?&gt;</x:text>
    </div>
  </x:template>
  
  <x:template match="comment()"  mode="printxml">
  <!-- comment 
  <x:message>printxml: comment</x:message>-->
    <div class="comment"><x:text>&lt;!--</x:text><x:value-of select="."/><x:text>--&gt;</x:text></div>
  </x:template>

  <x:template match="*[every $x in node() satisfies $x[self::text()]]" mode="printxml">
  <!-- just text in element (will also match empty element, so empty element template priority increased) 
   <x:message>printxml:just with text <x:value-of select="name(.)"/></x:message>-->
    <div class="element">
      <span class="markup">&lt;</span>
      <span class="start-tag"><x:value-of select="name(.)"/></span>
      <x:apply-templates select="@*"  mode="printxml"/>
      <span class="markup">&gt;</span>
      <span class="text"><x:value-of select="."  /></span>
      <span class="markup">&lt;/</span>
      <span class="end-tag"><x:value-of select="name(.)"/></span>
      <span class="markup">&gt;</span>
    </div>
  </x:template>


 <x:template match="*[element()|processing-instruction()]" mode="printxml" >
 <!--  element with sub-elements 
  <x:message>printxml: with elements <x:value-of select="name(.)"/></x:message>-->
          <div class="element">
          <span class="markup">&lt;</span><span class="start-tag"><x:value-of select="name(.)"/></span><x:apply-templates select="@*" mode="printxml"/><span class="markup">&gt;</span>
          <div class="indent">
          <x:apply-templates select="child::node()"  mode="printxml"/>
          </div>
          <span class="markup">&lt;/</span><span class="end-tag"><x:value-of select="name(.)"/></span><span class="markup">&gt;</span>
          </div>
  </x:template>

 <x:template match="*[not(node())]" mode="printxml" priority="5">
 <!-- empty element 
  <x:message>printxml:empty <x:value-of select="name(.)"/></x:message>-->
    <div class="element">
      <span class="markup">&lt;</span>
      <span class="start-tag"><x:value-of select="name(.)"/></span>
      <x:apply-templates select="@*"  mode="printxml"/>
      <span class="markup">/&gt;</span>
    </div>
  </x:template>
 

  <x:template match="@*"  mode="printxml">
    <x:text> </x:text><span class="attribute-name"><x:value-of select="name(.)"/></span><span class="markup">=</span><span class="attribute-value">"<x:value-of select="."/>"</span>
  </x:template>
  
 
  <x:template match="text()"  mode="printxml">
    <x:if test="normalize-space(.)">
      <div class="text"><x:value-of select="."/></div>
    </x:if>
  </x:template>

<!-- from Ray's schema formatting via Markus -->
 
<x:template match="xs:complexType|xs:simpleType" mode="xsddef" xml:space="preserve">
<div class="schemaOuter">
<a name="s:{@name}">
</a><div class="schemaHeader"><x:apply-templates select="." mode="schemaDefTitle"/></div>
<div class="schemaInner">
<pre><x:apply-templates select="." mode="xsdcode"/></pre>
</div></div>
    </x:template>

    <x:template match="xs:complexType[xs:simpleContent]" mode="content"/>

    <x:template match="xs:complexType" mode="content" xml:space="preserve">
      <x:if test=".//xs:element">
<p>
<table border="2" width="100%" id="d:{@name}">
<colgroup>
  <col width="20%"/>
  <col width="80%"/>
</colgroup>
<thead>
  <tr><th colspan="2" align="left"><x:apply-templates select="." mode="MetadataTitle"/></th>
  </tr><tr><th>Element</th><th>Definition</th>
</tr></thead>
<tbody>
<x:apply-templates select=".//xs:element" mode="content"/>
</tbody>
</table>
</p>
      </x:if>
    </x:template>

    <x:template match="xs:simpleType" mode="content"/>

    <x:template match="xs:complexType|xs:simpleType" mode="attributes">
      <x:if test=".//xs:attribute" xml:space="preserve">
<p>
<table border="2" width="100%">
<colgroup>
  <col width="20%"/>
  <col width="80%"/>
</colgroup>
<thead>
  <tr><th colspan="2" align="left"><x:apply-templates select="." mode="attributeTitle"/></th>
  </tr><tr><th>Attribute</th><th>Definition</th>
</tr></thead>
<tbody>
<x:apply-templates select=".//xs:attribute" mode="attributes"/>
</tbody>
</table>
</p>
      </x:if>
    </x:template>

    <x:template match="xs:element" mode="content" xml:space="preserve">
  <tr><td valign="top"><x:value-of select="@name"/></td>
      <td valign="top"><table border="0" width="100%">
      <colgroup><col width="20%"/><col width="80%"/></colgroup><tbody>
<x:apply-templates select="." mode="nextContentItem"/>      </tbody></table>
  </td></tr>
    </x:template>

    <x:template match="xs:attribute" mode="attributes" xml:space="preserve">
  <tr><td valign="top"><x:value-of select="@name"/></td>
      <td valign="top"><table border="0" width="100%">
      <colgroup><col width="20%"/><col width="80%"/></colgroup><tbody>
<x:apply-templates select="." mode="nextContentItem"/>      </tbody></table>
  </td></tr>
    </x:template>

    <x:template match="xs:element" mode="content.rmname">
        <x:param name="row" select="1"/>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="#dddddd"><td nowrap="nowrap" valign="top"><em>RM Name:</em></td>
              <td valign="top"><x:for-each select="xs:annotation/xs:appinfo/vm:dcterm" xml:space="default">
              <x:if test="position()!=1">
                 <x:text>, </x:text>
              </x:if>
              <x:value-of select="."/>
            </x:for-each></td>
          </tr>
</x:for-each>
    </x:template>

    <x:template match="xs:element|xs:attribute" mode="content.type">
        <x:param name="row" select="1"/>

        <x:variable name="type">
           <x:choose>
              <x:when test="@type">
                 <x:apply-templates select="@type" mode="type"/>
              </x:when>
              <x:otherwise>
                 <x:apply-templates select="xs:complexType|xs:simpleType" 
                                      mode="type"/>
              </x:otherwise>
           </x:choose>
        </x:variable>

        <x:variable name="color">
           <x:call-template name="rowBgColor">
              <x:with-param name="row" select="$row"/>
           </x:call-template>
        </x:variable>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="{$color}"><td nowrap="nowrap" valign="top"><em>Value type:</em></td>
              <td valign="top"><x:copy-of select="$type"/></td>
          </tr>
</x:for-each>
    </x:template>

    <x:template match="xs:element|xs:attribute" mode="content.meaning">
        <x:param name="row" select="1"/>

        <x:variable name="color">
           <x:call-template name="rowBgColor">
              <x:with-param name="row" select="$row"/>
           </x:call-template>
        </x:variable>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="{$color}"><td nowrap="nowrap" valign="top"><em>Semantic Meaning:</em></td>
              <td valign="top" width="90%"><x:copy-of select="xs:annotation/xs:documentation[1]/node()"/></td>
          </tr>
</x:for-each>
    </x:template>

    <x:template match="xs:attribute" mode="content.default">
        <x:param name="row" select="1"/>

        <x:variable name="color">
           <x:call-template name="rowBgColor">
              <x:with-param name="row" select="$row"/>
           </x:call-template>
        </x:variable>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="{$color}"><td nowrap="nowrap"
              valign="top"><em>Default Value:</em></td>
              <td valign="top" width="90%"><code><x:value-of select="@default"/></code></td> 
          </tr>
</x:for-each>
    </x:template>

    <x:template match="xs:element|xs:attribute" mode="content.occurrences">
        <x:param name="row" select="1"/>

        <x:variable name="color">
           <x:call-template name="rowBgColor">
              <x:with-param name="row" select="$row"/>
           </x:call-template>
        </x:variable>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="{$color}"><td nowrap="nowrap" valign="top"><em>Occurrences:</em></td>
              <td valign="top"><x:apply-templates select="." mode="occurrences"/></td>
          </tr>
</x:for-each>
    </x:template>

    <x:template match="xs:element|xs:attribute" mode="content.allowedValues">
        <x:param name="row" select="1"/>
        <x:param name="type" select="@type"/>

        <x:variable name="color">
           <x:call-template name="rowBgColor">
              <x:with-param name="row" select="$row"/>
           </x:call-template>
        </x:variable>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="{$color}"><td nowrap="nowrap" valign="top"><em>Allowed Values:</em></td>
              <td valign="top"><x:apply-templates select="xs:simpleType/xs:restriction|/xs:schema/xs:simpleType[@name=substring-after($type,':')]/xs:restriction" mode="howtolist" /></td> 
          </tr>
</x:for-each>
    </x:template>

    <x:template match="xs:restriction[xs:enumeration]" mode="howtolist">
      <x:choose>
        <x:when test="xs:enumeration/xs:annotation/xs:documentation"
                  xml:space="preserve"><table border="0" width="100%">
        <colgroup><col width="20%"/><col width="80%"/></colgroup><tbody>
<x:apply-templates select="xs:enumeration" mode="controlledVocab" />
              </tbody></table></x:when>
        <x:otherwise>
           <x:for-each select="xs:enumeration">
              <code><x:value-of select="@value"/></code>
              <x:if test="position()!=last()">
                 <x:text>, </x:text>
              </x:if>
</x:for-each>
        </x:otherwise>
      </x:choose>
    </x:template>

    <x:template match="xs:enumeration" mode="controlledVocab" xml:space="preserve">
                 <tr><td valign="top"><code><x:value-of select="@value"/></code> </td>
                     <td><x:value-of select="xs:annotation/xs:documentation"/></td></tr>
    </x:template>

    <x:template match="xs:element|xs:attribute" mode="content.comment">
        <x:param name="row" select="1"/>

        <x:variable name="color">
           <x:call-template name="rowBgColor">
              <x:with-param name="row" select="$row"/>
           </x:call-template>
        </x:variable>

        <x:for-each select="." xml:space="preserve">          <tr bgcolor="{$color}"><td nowrap="nowrap" valign="top"><em>Comments:</em></td>
              <td valign="top"><x:for-each select="xs:annotation/xs:documentation[position() > 1]">
<p><x:copy-of select="./node()"/></p>
              </x:for-each></td> 
          </tr>
</x:for-each>
    </x:template>



    <x:template name="rowBgColor">
       <x:param name="row" select="1"/>
       <x:choose>
          <x:when test="$row mod 2 = 1">#dddddd</x:when>
          <x:otherwise>#f5f5f5</x:otherwise>
       </x:choose>
    </x:template>    

    <!-- remove a publication date that may be present at the end of the 
        current element's content (actually, we remove any number of
        those) -->
    <x:template name="removeTrailingDate">
            <x:analyze-string
                select="."
                regex="{'( [0-9]{1,2} +(January|February|March|April|May|June|July|August|September|October|November|December) +[0-9]{4})+$'}">
                <x:non-matching-substring>
                    <x:value-of select="."/>
                </x:non-matching-substring>
            </x:analyze-string>
    </x:template>

    <x:template name="appendDocDate">
            <x:text> </x:text> 
            <!--could perhaps use regex here to accept yyyy-mm-dd also-->                        
            <x:value-of select="format-date(xs:date(concat(substring($docdate,1,4),'-',substring($docdate,5,2),'-',substring($docdate,7,2))), '[D] [MNn] [Y]', 'en', (), ())"/>
    </x:template>

    <x:template name="longDocClass">
        <x:choose>
            <x:when test="$pubstatus='WD'">
                <x:text>IVOA Working Draft </x:text>
            </x:when>
            <x:when test="$pubstatus='PR'">
                <x:text>IVOA Proposed Recommendation </x:text>
            </x:when>
            <x:when test="$pubstatus='REC'">
                <x:text>IVOA Recommendation </x:text>
            </x:when>
            <x:when test="$pubstatus='NOTE'">
                <x:text>IVOA Note </x:text>
            </x:when>
            <x:otherwise>
                <x:message terminate='yes'>pubstatus must be one of
                    WD, PR, REC, NOTE</x:message>
            </x:otherwise>
        </x:choose>
    </x:template>

    <x:template match="h:title">
        <title>
            <x:call-template name="removeTrailingDate"/>
            <x:text> </x:text>
            <x:call-template name="longDocClass"/>
            <x:call-template name="appendDocDate"/>
        </title>
    </x:template>

    <x:template match="h:h2[@class='subtitle']">
        <h2 class="subtitle">
            <x:call-template name="longDocClass"/>
            <x:call-template name="appendDocDate"/>
        </h2>
    </x:template>

    <!-- create a base name for the current document according to
    SDP WG rules; this is not currently used -->
    <x:function name="vm:getBaseName">
            <x:value-of select="$ivoname"/>
            <x:text>-</x:text>
            <x:value-of select="$pubstatus"/>
            <x:text>-</x:text>
            <x:value-of select="$docversion"/>
            <x:if test="$pubstatus!='REC'">
                <x:text>/</x:text>
                <x:value-of select="replace($docdate, '-', '')"/>
            </x:if>
    </x:function>

    <!-- Make a link to the current version on the ivoa doc server.
         The format of the URI here is as mandated by the IVOA
         Document Standards Standard Document (ahem). -->
    <x:template match="h:a[@class='currentlink']">
        <x:variable name="currenturl">
            <x:value-of select="$docbase"/>
            <x:value-of select="$ivoname"/>
            <x:text>/</x:text>
            <x:value-of select="replace($docdate, '-', '')"/>
        </x:variable>
        <x:element name="a">
            <x:attribute name="class">currentlink</x:attribute>
            <x:attribute name="href">
                <x:value-of select="$currenturl"/>
            </x:attribute>
            <x:value-of select="$currenturl"/>
        </x:element>
    </x:template>

    <!-- Make a link to the LATEST version on the ivoa doc server.
         This is a URL without a version, which will redirect, on the
         doc server, to the versioned URL. -->
    <x:template match="h:a[@class='latestlink']">
        <x:variable name="currenturl">
            <x:value-of select="$docbase"/>
            <x:value-of select="$ivoname"/>
        </x:variable>
        <x:element name="a">
            <x:attribute name="class">latestlink</x:attribute>
            <x:attribute name="href">
                <x:value-of select="$currenturl"/>
            </x:attribute>
            <x:value-of select="$currenturl"/>
        </x:element>
    </x:template>

    <x:template match="h:p[@id='statusdecl']">
        <p id="statusdecl"><em>
            <x:choose>
                <x:when test="$pubstatus='NOTE'">
                    This is an IVOA Note expressing suggestions from and
                    opinions of the authors. It is intended to share best
                    practices, possible approaches, or other perspectives on
                    interoperability with the Virtual Observatory. It should
                    not be referenced or otherwise interpreted as a standard
                    specification.
                </x:when>
                <x:when test="$pubstatus='WD'">
                    This is an IVOA Working Draft for review by IVOA members
                    and other interested parties.  It is a draft document and
                    may be updated, replaced, or obsoleted by other documents
                    at any time. It is inappropriate to use IVOA Working Drafts
                    as reference materials or to cite them as other than "work
                    in progress".
                </x:when>
                <x:when test="$pubstatus='PR'">
                    This is an IVOA Proposed Recommendation made available for
                    public review. It is appropriate to reference this document
                    only as a recommended standard that is under review and
                    which may be changed before it is accepted as a full
                    Recommendation.
                </x:when>
                <x:when test="$pubstatus='REC'">
                    This document has been reviewed by IVOA Members and other
                    interested parties, and has been endorsed by the IVOA
                    Executive Committee as an IVOA Recommendation. It is a
                    stable document and may be used as reference material or
                    cited as a normative reference from another document.
                    IVOA's role in making the Recommendation is to draw
                    attention to the specification and to promote its
                    widespread deployment. This enhances the functionality and
                    interoperability inside the Astronomical Community.
                </x:when>
                <x:otherwise>
                    <x:message terminate='yes'>pubstatus must be one of
                        WD, PR, REC, NOTE</x:message>
                </x:otherwise>
            </x:choose>
        </em></p>
    </x:template>
</x:stylesheet>
