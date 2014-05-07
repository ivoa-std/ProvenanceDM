<!--
  -  a stylesheet for preformatting the definitions from an XML Schema
  -  that follows the VOResource schema conventions.  The output is intended
  -  to be pasted into an IVOA specification document.
  -->
<!-- Derived from Ray Plante's stylesheet of the same name - there are differences in this  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns="http://www.w3.org/2001/XMLSchema" 
                xmlns:vm="http://www.ivoa.net/xml/VOMetadata/v0.1" 
                xmlns:vr="http://www.ivoa.net/xml/VOResource/v1.0" 
                version="1.0">

   <xsl:output method="xml"/>

   <xsl:param name="showDefaults" select="true()"/>

   <xsl:param name="xsdprefix">xs</xsl:param>

   <xsl:param name="vrprefix">vr</xsl:param>


   <xsl:param name="indentstep" select="'  '" />

   <xsl:param name="maxcodelen" select="80"/>

   <xsl:variable name="cr"><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="/">
        <spec>
        <xsl:value-of select="$cr"/>
        <xsl:text>   </xsl:text>
        <xsl:apply-templates select="/xs:schema/xs:complexType|/xs:schema/xs:simpleType" mode="def"/>
        <xsl:value-of select="$cr"/>
        <xsl:text>   </xsl:text>
        </spec>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:complexType|xs:simpleType" mode="def">
        <xsl:value-of select="$cr"/>
        <xsl:text>   </xsl:text>
        <definition name="{@name}">
          <xsl:value-of select="$cr"/>
          <xsl:apply-templates select="." mode="xsddef"/>
          <xsl:value-of select="$cr"/>
          <xsl:apply-templates select="." mode="content"/>
          <xsl:value-of select="$cr"/>
          <xsl:apply-templates select="." mode="attributes"/>
        <xsl:text>   </xsl:text>
        </definition>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:complexType|xs:simpleType" mode="xsddef">
        <xsl:text>      </xsl:text>
        <xsddef>
        <xsl:attribute namespace="" name="title">
           <xsl:apply-templates select="." mode="schemaDefTitle"/>
        </xsl:attribute>
        <xsl:value-of select="$cr"/>
        <xsl:apply-templates select="." mode="xsdcode"/>
        <xsl:text>      </xsl:text>
        </xsddef>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:complexType[xs:simpleContent]" mode="content"/>

    <xsl:template match="xs:complexType" mode="content">
      <xsl:if test=".//xs:element">
        <xsl:text>      </xsl:text>
        <content>
        <xsl:attribute namespace="" name="title">
           <xsl:apply-templates select="." mode="MetadataTitle"/>
        </xsl:attribute>
        <xsl:value-of select="$cr"/>
        <xsl:apply-templates select=".//xs:element" mode="content"/>
        <xsl:text>      </xsl:text>
        </content>
        <xsl:value-of select="$cr"/>
      </xsl:if>
    </xsl:template>

    <xsl:template match="xs:simpleType" mode="content"/>

    <xsl:template match="xs:complexType|xs:simpleType" mode="attributes">
      <xsl:if test=".//xs:attribute">
        <xsl:text>      </xsl:text>
        <attributes>
        <xsl:attribute namespace="" name="title">
           <xsl:value-of select="concat(/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix,':',@name)"/>
           <xsl:text> Attributes</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="$cr"/>
        <xsl:apply-templates select=".//xs:attribute" mode="attributes"/>
        <xsl:text>      </xsl:text>
        </attributes>
        <xsl:value-of select="$cr"/>
      </xsl:if>
    </xsl:template>

    <xsl:template match="xs:element" mode="content">
        <xsl:text>         </xsl:text>
        <element name="{@name}">
        <xsl:value-of select="$cr"/>
        <xsl:apply-templates select="." mode="nextContentItem"/>
        <xsl:text>         </xsl:text>
        </element>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:element" mode="nextContentItem">
       <xsl:param name="row" select="1"/>
       <xsl:param name="item" select="1"/>

       <xsl:variable name="type" select="@type"/>

       <xsl:choose>
          <xsl:when test="$item &lt; 2 and xs:annotation/xs:appinfo/vm:dcterm">
             <xsl:apply-templates select="." mode="content.rmname">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="2"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 3">
             <xsl:apply-templates select="." mode="content.type">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="3"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 4">
             <xsl:apply-templates select="." mode="content.meaning">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="4"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 5">
             <xsl:apply-templates select="." mode="content.occurrences">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="5"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 6 and 
                          (xs:simpleType/xs:restriction or 
                           (starts-with($type,/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix) and 
    /xs:schema/xs:simpleType[@name=substring-after($type,':')]/xs:restriction))">
             <xsl:apply-templates select="." mode="content.allowedValues">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="6"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 7 and count(xs:annotation/xs:documentation) > 1">
             <xsl:apply-templates select="." mode="content.comment">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
          </xsl:when>
       </xsl:choose>
    </xsl:template>

    <xsl:template match="xs:element" mode="content.rmname">
        <xsl:param name="row" select="1"/>

        <xsl:text>            </xsl:text>
        <rmname>
           <xsl:attribute namespace="" name="row"><xsl:value-of select="$row"/></xsl:attribute>
           <xsl:for-each select="xs:annotation/xs:appinfo/vm:dcterm">
              <xsl:if test="position()!=1">
                 <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:value-of select="."/>
           </xsl:for-each>
        </rmname>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:element|xs:attribute" mode="content.type">
        <xsl:param name="row" select="1"/>

        <xsl:variable name="type">
           <xsl:choose>
              <xsl:when test="@type">
                 <xsl:apply-templates select="@type" mode="type"/>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:apply-templates select="xs:complexType|xs:simpleType" 
                                      mode="type"/>
              </xsl:otherwise>
           </xsl:choose>
        </xsl:variable>

        <xsl:text>            </xsl:text>
        <type row="{$row}"><xsl:copy-of select="$type"/></type>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:element|xs:attribute" mode="content.meaning">
        <xsl:param name="row" select="1"/>

        <xsl:text>            </xsl:text>
        <meaning>
           <xsl:attribute namespace="" name="row"><xsl:value-of select="$row"/></xsl:attribute>
           <xsl:value-of select="xs:annotation/xs:documentation[1]"/>
        </meaning>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:attribute" mode="content.default">
        <xsl:param name="row" select="1"/>

        <xsl:text>            </xsl:text>
        <default row="{$row}">
           <xsl:value-of select="@default"/>
        </default>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:element" mode="content.occurrences">
        <xsl:param name="row" select="1"/>

        <xsl:text>            </xsl:text>
        <occurrences row="{$row}">
           <xsl:apply-templates select="." mode="occurrences"/>
        </occurrences>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:element" mode="occurrences">
        <xsl:choose>
           <xsl:when test="@minOccurs='0'">
              <xsl:text>optional</xsl:text>
              <xsl:choose>
                <xsl:when test="@maxOccurs='unbounded'">
                   <xsl:text>; multiple occurrences allowed.</xsl:text>
                </xsl:when>
                <xsl:when test="@maxOccurs and @maxOccurs!='0' and 
                                @maxOccurs!='1'">
                   <xsl:text>; up to </xsl:text>
                   <xsl:value-of select="@maxOccurs"/>
                   <xsl:text> occurrences allowed.</xsl:text>
                </xsl:when>
              </xsl:choose>
           </xsl:when>

           <xsl:when test="(not(@minOccurs) or @minOccurs='1')">
             <xsl:text>required</xsl:text>
             <xsl:choose>
               <xsl:when test="@maxOccurs='unbounded'">
                  <xsl:text>; multiple occurrences allowed.</xsl:text>
               </xsl:when>
               <xsl:when test="@maxOccurs and @maxOccurs!='0' and 
                               @maxOccurs!='1'">
                   <xsl:text>; up to </xsl:text>
                   <xsl:value-of select="@maxOccurs"/>
                   <xsl:text> occurrences allowed.</xsl:text>
               </xsl:when>
             </xsl:choose>
           </xsl:when>

           <xsl:otherwise>
             <xsl:choose>
               <xsl:when test="@minOccurs=@maxOccurs">
                 <xsl:text>exactly </xsl:text>
                 <xsl:value-of select="@minOccurs"/>
                 <xsl:text> occurrences required.</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:text>at least </xsl:text>
                 <xsl:value-of select="@minOccurs"/>
                 <xsl:text> occurrences required; </xsl:text>
                 <xsl:choose>
                   <xsl:when test="@maxOccurs='unbounded'">
                      <xsl:text>more are allowed</xsl:text>
                   </xsl:when>
                   <xsl:otherwise>
                      <xsl:text>no more than </xsl:text>
                      <xsl:value-of select="@maxOccurs"/>
                      <xsl:text> allowed.</xsl:text>
                   </xsl:otherwise>
                 </xsl:choose>
               </xsl:otherwise>
             </xsl:choose>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xs:attribute" mode="content.occurrences">
        <xsl:param name="row" select="1"/>

        <xsl:text>            </xsl:text>
        <occurrences row="{$row}">
        <xsl:apply-templates select="." mode="occurrences"/>
        </occurrences>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:attribute" mode="occurrences">
        <xsl:choose>
           <xsl:when test="@use='required'">required</xsl:when>
           <xsl:otherwise>optional</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xs:element|xs:attribute" mode="content.allowedValues">
        <xsl:param name="row" select="1"/>
        <xsl:param name="type" select="@type"/>

        <xsl:text>            </xsl:text>
        <allowedValues>
           <xsl:attribute namespace="" name="row"><xsl:value-of select="$row"/></xsl:attribute>
           <xsl:value-of select="$cr"/>
           <xsl:choose>
              <xsl:when test="$type">
                 <xsl:apply-templates select="/xs:schema/xs:simpleType[@name=substring-after($type,':')]/xs:restriction/xs:enumeration" mode="controlledVocab"/>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:apply-templates select="xs:simpleType/xs:restriction/xs:enumeration" mode="controlledVocab"/>
              </xsl:otherwise>
           </xsl:choose>
        <xsl:text>            </xsl:text>
        </allowedValues>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:element|xs:attribute" mode="content.comment">
        <xsl:param name="row" select="1"/>

        <xsl:for-each select="xs:annotation/xs:documentation[position() > 1]">
          <xsl:text>            </xsl:text>
          <comment>
             <xsl:attribute namespace="" name="row"><xsl:value-of select="$row"/></xsl:attribute>
             <xsl:value-of select="."/>
          </comment>
          <xsl:value-of select="$cr"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@type[.='xs:boolean']" priority="1" 
                  mode="type">
       <xsl:text>boolean (true/false): </xsl:text>
       <code><xsl:value-of select="."/></code>
    </xsl:template>

    <xsl:template match="@type[.=concat($vrprefix,':ResourceName')]" 
                  priority="1" mode="type">
       <xsl:text>string with ID attribute: </xsl:text>
       <code><a href="http://www.ivoa.net/Documents/REC/ReR/VOResource-20080222.html#d:ResourceName">
       <xsl:text>vr:ResourceName</xsl:text></a></code>
    </xsl:template>

    <xsl:template match="@type[.=concat($vrprefix,':IdentifierURI')]" 
                  priority="1" mode="type">
       <xsl:text>an IVOA Identifier URI: </xsl:text>
       <code><a href="http://www.ivoa.net/Documents/REC/ReR/VOResource-20080222.html#d:IdentifierURI">
       <xsl:text>vr:IdentifierURI</xsl:text></a></code>
    </xsl:template>

    <xsl:template match="@type[starts-with(., $vrprefix)]" mode="type">
       <xsl:text>composite: </xsl:text>
       <code><xsl:value-of select="."/></code>
    </xsl:template>

    <xsl:template match="@type[starts-with(., 'xs:')]" mode="type">
       <xsl:choose>
         <xsl:when test=".='xs:token' or .='xs:string'">
           <xsl:text>string: </xsl:text>
           <code><xsl:value-of select="."/></code>
         </xsl:when>
         <xsl:when test=".='xs:integer'">
           <xsl:text>integer</xsl:text>
         </xsl:when>
         <xsl:when test=".='xs:NCName'">
           <xsl:text>a prefixless XML name</xsl:text>
         </xsl:when>
         <xsl:when test=".='xs:decimal' or .='xs:float' or .='xs:double'">
           <xsl:text>floating-point number: </xsl:text>
           <code><xsl:value-of select="."/></code>
         </xsl:when>
         <xsl:when test=".='xs:anyURI'">
           <xsl:text>a URI: </xsl:text>
           <code><xsl:value-of select="."/></code>
         </xsl:when>
       </xsl:choose>
    </xsl:template>

    <xsl:template match="@type[starts-with(., /xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix)]" mode="type">
       <xsl:variable name="type" select="substring-after(.,':')"/>

       <xsl:choose>
         <xsl:when test="/xs:schema/xs:simpleType[@name=$type]">
           <xsl:apply-templates select="/xs:schema/xs:simpleType[@name=$type]" 
                                mode="type"/>
         </xsl:when>

         <xsl:when test="/xs:schema/xs:complexType[@name=$type]/xs:simpleContent/xs:extension">
           <xsl:for-each select="/xs:schema/xs:complexType[@name=$type]/xs:simpleContent/xs:extension">

             <xsl:choose>
               <xsl:when test="@base='xs:string' or @base='xs:token'">
                 <xsl:text>a string</xsl:text>
               </xsl:when>
               <xsl:when test="@base='xs:anyURI'">
                 <xsl:text>a URI</xsl:text>
               </xsl:when>
               <xsl:when test="@base='xs:NCName'">
                 <xsl:text>an XML name without a namespace prefix</xsl:text>
               </xsl:when>
               <xsl:when test="@base='xs:integer'">
                 <xsl:text>an integer</xsl:text>
               </xsl:when>
               <xsl:when test="@base='xs:nonNegativeInteger'">
                 <xsl:text>a non-negative integer (0, 1, ...)</xsl:text>
               </xsl:when>
               <xsl:when test="@base='xs:decimal' or @base='xs:float' or @base='xsdouble'">
                 <xsl:text>a floating point number (</xsl:text>
                 <code><xsl:value-of select="@base"/></code>
                 <xsl:text>)</xsl:text>
               </xsl:when>
               <xsl:when test="@base='boolean'">
                 <xsl:text>a boolean value (true, false, 0, or 1)</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                 <code><xsl:value-of select="@base"/></code>
               </xsl:otherwise>
             </xsl:choose>
             <xsl:text> with optional attributes</xsl:text>
           </xsl:for-each>
         </xsl:when>

         <xsl:otherwise>
           <xsl:text>composite: </xsl:text>
           <code><a href="#d:{substring-after(.,':')}">
           <xsl:value-of select="."/></a></code>
         </xsl:otherwise>
       </xsl:choose>
    </xsl:template>

    <xsl:template match="xs:simpleType" mode="type">
       <xsl:choose>
         <xsl:when test="xs:restriction[@base='xs:string' or @base='xs:token']/xs:enumeration">
            <xsl:text>string with controlled vocabulary</xsl:text>
         </xsl:when>

         <xsl:when test="xs:restriction[@base='xs:string' or @base='xs:token']/xs:pattern">
            <xsl:text>string of the form:</xsl:text>
            <i><xsl:value-of select="xs:restriction/xs:pattern/@value"/></i>
         </xsl:when>

         <xsl:otherwise>string</xsl:otherwise>
       </xsl:choose>
    </xsl:template>

    <xsl:template match="@type" mode="type">
       <code><xsl:value-of select="."/></code>
    </xsl:template>

    <xsl:template match="xs:enumeration" mode="controlledVocab">
       <xsl:text>               </xsl:text>
       <value name="{@value}">
          <xsl:value-of select="xs:annotation/xs:documentation"/>
       </value>
       <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:attribute" mode="attributes">
        <xsl:text>         </xsl:text>
        <attr name="{@name}">
        <xsl:value-of select="$cr"/>
        <xsl:apply-templates select="." mode="nextContentItem"/>
        <xsl:text>         </xsl:text>
        </attr>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="xs:attribute" mode="nextContentItem">
       <xsl:param name="row" select="1"/>
       <xsl:param name="item" select="1"/>

       <xsl:variable name="type" select="@type"/>

       <xsl:choose>
          <xsl:when test="$item &lt; 2">
             <xsl:apply-templates select="." mode="content.type">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="2"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 3">
             <xsl:apply-templates select="." mode="content.meaning">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="3"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 4">
             <xsl:apply-templates select="." mode="content.occurrences">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="4"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 5 and 
                          (xs:simpleType/xs:restriction or 
                           (starts-with($type,/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix) and 
   /xs:schema/xs:simpleType[@name=substring-after($type,':')]/xs:restriction))">
             <xsl:apply-templates select="." mode="content.allowedValues">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="5"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 6 and @default and $showDefaults">
             <xsl:apply-templates select="." mode="content.default">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
             <xsl:apply-templates select="." mode="nextContentItem">
                <xsl:with-param name="row" select="$row+1"/>
                <xsl:with-param name="item" select="6"/>
             </xsl:apply-templates>
          </xsl:when>

          <xsl:when test="$item &lt; 7 and count(xs:annotation/xs:documentation) > 1">
             <xsl:apply-templates select="." mode="content.comment">
                <xsl:with-param name="row" select="$row"/>
             </xsl:apply-templates>
          </xsl:when>
       </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="xsdcode">
        <xsl:param name="indent"/>
        <xsl:param name="step" select="$indentstep"/>

        <xsl:value-of select="$indent"/>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="concat($xsdprefix, ':', local-name())"/>
        <xsl:apply-templates select="." mode="formatAttrs">
           <xsl:with-param name="elindent" select="$indent"/>
        </xsl:apply-templates>
        <xsl:choose>
           <xsl:when test="*[local-name()!='annotation']">
              <xsl:text>&gt;</xsl:text>
              <xsl:value-of select="$cr"/>
              <xsl:apply-templates select="*[local-name()!='annotation']" 
                                   mode="xsdcode">
                 <xsl:with-param name="indent" select="concat($indent,$step)"/>
              </xsl:apply-templates>
              <xsl:value-of select="$indent"/>
              <xsl:text>&lt;/</xsl:text>
              <xsl:value-of select="concat($xsdprefix, ':', local-name())"/>
              <xsl:text>&gt;</xsl:text>
           </xsl:when>
           <xsl:when test="*">
              <xsl:text>/&gt;</xsl:text>
           </xsl:when>
           <xsl:when test="text()">
              <xsl:text>&gt;</xsl:text>
              <xsl:value-of select="text()"/>
              <xsl:text>&lt;/</xsl:text>
              <xsl:value-of select="concat($xsdprefix, ':', local-name())"/>
              <xsl:text>&gt;</xsl:text>
           </xsl:when>
           <xsl:otherwise>
              <xsl:text>/&gt;</xsl:text>
           </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$cr"/>
    </xsl:template>

    <xsl:template match="*" mode="formatAttrs">
        <xsl:param name="elindent"/>
        <xsl:param name="indent">
           <xsl:value-of select="$elindent"/>
           <xsl:text>  </xsl:text>
           <xsl:call-template name="indentFor">
              <xsl:with-param name="in" select="concat($xsdprefix,local-name())"/>
           </xsl:call-template>
        </xsl:param>
        <xsl:param name="c" select="count(@*)"/>
        <xsl:param name="to"/>

        <xsl:variable name="i" select="count(@*)-$c+1"/>
        <xsl:variable name="appended">
           <xsl:apply-templates select="@*[$i]" mode="appendAttr">
              <xsl:with-param name="to" select="$to"/>
              <xsl:with-param name="indent" select="$indent"/>
           </xsl:apply-templates>
        </xsl:variable>

        <xsl:choose>
           <xsl:when test="$c > 1">
             <xsl:apply-templates select="." mode="formatAttrs">
                 <xsl:with-param name="to" select="$appended"/>
                 <xsl:with-param name="c" select="$c - 1"/>
                 <xsl:with-param name="indent" select="$indent"/>
             </xsl:apply-templates>
           </xsl:when>
           <xsl:otherwise>
              <xsl:value-of select="$appended"/>
              <xsl:if test="$appended">
                  <xsl:text> </xsl:text>
              </xsl:if>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" mode="appendAttr">
        <xsl:param name="to"/>
        <xsl:param name="indent"/>
        <xsl:param name="maxlen" select="$maxcodelen"/>
        <xsl:variable name="attr">
           <xsl:apply-templates select="." mode="formatAttr"/>
        </xsl:variable>

        <xsl:value-of select="$to"/>
        <xsl:if test="string-length($attr)+string-length($to)+string-length($attr) &gt; $maxcodelen">
           <xsl:value-of select="$cr"/>
           <xsl:value-of select="$indent"/>
        </xsl:if>
        <xsl:value-of select="$attr"/>
    </xsl:template>

    <xsl:template match="@*" mode="formatAttr">
        <xsl:text> </xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>="</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template name="indentFor">
       <xsl:param name="in"/>
       <xsl:if test="$in">
          <xsl:text> </xsl:text>
          <xsl:call-template name="indentFor">
            <xsl:with-param name="in" select="substring($in,2)"/>
          </xsl:call-template>
       </xsl:if>
    </xsl:template>

    <xsl:template match="xs:complexType|xs:simpleType" mode="schemaDefTitle">
       <xsl:value-of select="concat(/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix,':',@name)"/>
       <xsl:text> Type Schema Definition</xsl:text>
    </xsl:template>

    <xsl:template match="xs:complexType|xs:simpleType" mode="attributeTitle">
       <xsl:value-of select="concat(/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix,':',@name)"/>
       <xsl:text> Attributes</xsl:text>
    </xsl:template>

    <xsl:template match="xs:complexType" mode="MetadataTitle">
       <xsl:value-of select="concat(/xs:schema/xs:annotation/xs:appinfo/vm:targetPrefix,':',@name)"/>
       <xsl:choose>
          <xsl:when test=".//xs:extension">
            <xsl:text> Extension Metadata Elements</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> Metadata Elements</xsl:text>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
