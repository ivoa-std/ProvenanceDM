<?xml version="1.0" encoding="UTF-8"?>
<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform"
	version="2.0" xmlns:h="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml">
	<x:output method="text"  indent="no"/>

	<x:template match="/">
    	<x:apply-templates select="//processing-instruction('bibliography')"
			mode="extract-aux" />
			
	</x:template>
	
	<x:template match="processing-instruction('bibliography')"
		mode="extract-aux">
		<x:choose>
        
        <x:when test="normalize-space(.) ne 'end'">
		
		<x:text>\relax
</x:text>
		<x:apply-templates select="//h:cite"
			mode="extract-aux" />
		<x:if test="string-length(.) &gt; 0">
			<x:call-template name="make-tex-command">
				<x:with-param name="command">bibdata</x:with-param>
            <!-- note lack of newlines... don't want them in output-->
				<x:with-param name="content"><x:value-of select="normalize-space(.)" /></x:with-param>
			</x:call-template>
		</x:if>
		<x:call-template name="make-tex-command">
		  <x:with-param name="command">bibstyle</x:with-param>
		  <x:with-param name="content">ivoadoc/plainhtml</x:with-param>
		</x:call-template>
		</x:when>
		</x:choose>
	</x:template>

<x:template match="h:cite" mode="extract-aux">
    <x:variable name="ref">
      <x:choose>
         <x:when test="starts-with(h:a/@href,'#')"><x:value-of select="substring-after(h:a/@href,'#')"/></x:when>
         <x:otherwise>
           <x:value-of select="."/><!-- initial mode just use <cite> content -->
         </x:otherwise>
      </x:choose>
    </x:variable>
     <x:message>citation <x:value-of select="$ref"/></x:message>
		<x:call-template name="make-tex-command">
			<x:with-param name="command">citation</x:with-param>
			<x:with-param name="content"><x:value-of select="normalize-space($ref)" /></x:with-param>
		</x:call-template>
	</x:template>

	<x:template name="make-tex-command">
		<x:param name="command" />
		<x:param name="content" />
       <!-- note lack of newlines... don't want them in output-->
		<x:text>\</x:text><x:value-of select="$command" /><x:text>{</x:text><x:value-of select="$content" /><x:text>}
</x:text>
	</x:template>
	<!-- default identity transformation -->
	<x:template match="node()|@*">
		<x:copy>
			<x:apply-templates select="node()|@*" />
		</x:copy>
	</x:template>


</x:stylesheet>