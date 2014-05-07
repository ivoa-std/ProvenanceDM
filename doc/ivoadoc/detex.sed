# Edit TeXisms in the .bbl output, to make it HTML-ready
/% *$/{N;s/% *\n//;}
s,&,&amp;,g
s,\\~n,\&#241;,g
s,\([^/]\)~,\1 ,g
s/[{}]//g
s,\\ss,\&szlig;,g
s,\\`a,\&#224;,g
s,\\`e,\&#232;,g
s,\\'a,\&#225;,g
s,\\'e,\&#233;,g
s,\\^o,\&#244;,g
s,\\^u,\&#251;,g
s+\\,c+\&231;+g
s,\\"a,\&228;,g
s,\\"o,\&246;,g
s,\\"u,\&252;,g
s,---,\&#8212;,g
s,--,\&#8211;,g
