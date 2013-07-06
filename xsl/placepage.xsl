<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:t="http://www.tei-c.org/ns/1.0" 
 xmlns:s="http://syriaca.org"
 xmlns:saxon="http://saxon.sf.net/" 
 xmlns="http://www.w3.org/1999/xhtml"
 exclude-result-prefixes="xs t s" version="2.0">

 <!-- =================================================================== -->
 <!-- import component stylesheets for HTML page portions -->
 <!-- =================================================================== -->

 <xsl:import href="boilerplate-head.xsl"/>
 <xsl:import href="boilerplate-bottom.xsl"/>
 <xsl:import href="boilerplate-badbrowser.xsl"/>
 <xsl:import href="boilerplate-nav.xsl"/>
 <xsl:import href="boilerplate-footer.xsl"/>
 <xsl:import href="collations.xsl"/>
 <xsl:import href="langattr.xsl"/>
 <xsl:import href="log.xsl"/>
 <xsl:import href="normalization.xsl"/>
 

 <!-- =================================================================== -->
 <!-- set output so we get (mostly) indented HTML -->
 <!-- =================================================================== -->

 <xsl:output name="html" encoding="UTF-8" method="html" indent="yes"/>


 <!-- =================================================================== -->
 <!-- initialize top-level variables and transform parameters -->
 <!--  sourcedir: where to look for XML files to summarize/link to -->
 <!--  description: a meta description for the HTML page we will output -->
 <!--  name-app: name of the application (for use in head/title) -->
 <!--  name-page-short: short name of the page (for use in head/title) -->
 <!--  colquery: constructed variable with query for collection fn. -->
 <!-- =================================================================== -->

 <xsl:param name="idxdir">../places/</xsl:param> 
 <xsl:param name="sourcedir">../../places/xml/</xsl:param>
 <xsl:param name="destdir">../places/</xsl:param>
 <xsl:param name="name-app">The Syriac Gazetteer</xsl:param>
 <xsl:param name="copyright-holders">CHANGE THE COPYRIGHT HOLDERS PARAMETER</xsl:param>
 <xsl:param name="copyright-year">2013</xsl:param>
 <xsl:param name="xmlbase">https://github.com/srophe/places/blob/master/xml/</xsl:param>
 <xsl:param name="uribase">http://syriaca.org/place/</xsl:param>
 <xsl:param name="normalization">NFKC</xsl:param>

 <xsl:variable name="idxquery"><xsl:value-of select="$idxdir"/>index.xml</xsl:variable>
 

 <!-- =================================================================== -->
 <!-- TEMPLATES -->
 <!-- =================================================================== -->


 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
 <!-- |||| do-places: creates all individual place pages -->
 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

 <xsl:template name="do-places">
  
  <xsl:variable name="idx" select="document($idxquery)"/>
  <!-- loop through all page XML and write a corresponding HTML page -->
  <xsl:for-each select="$idx/descendant-or-self::t:place">
   
   <!-- determine descriptions and page names -->
   <xsl:variable name="description">
    <xsl:choose>
     <xsl:when test="t:desc[@type='abstract'][1]">
      <xsl:apply-templates select="t:desc[@type='abstract'][1]" mode="text-normal"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>no description available</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <xsl:variable name="name-page-short">
    <xsl:choose>
     <xsl:when test="t:placeName[@xml:lang='en']">
      <xsl:value-of select="t:placeName[@xml:lang='en']"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:text>Place no. </xsl:text>
      <xsl:value-of select="t:idno[@type='placeId']"/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   
   <xsl:variable name="placenum" select="t:idno[@type='placeID']"/>
   <xsl:choose>
    
    <!-- make sure we have a valid placeid -->
    <xsl:when test="matches($placenum, '^\d+$')">
     
     <!-- determine what the output filename will be -->
     <xsl:variable name="outfilename">
      <xsl:value-of select="$placenum"/>
      <xsl:text>.html</xsl:text>
     </xsl:variable>
     
     <!-- open a new output document for reading -->
     <xsl:result-document format="html" href="{$destdir}{$outfilename}">
      
      <!-- write the opening of the HTML page -->
      <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
      <xsl:comment>[if lt IE 7]>      &lt;html class="no-js lt-ie9 lt-ie8 lt-ie7"> &lt;![endif]</xsl:comment>
      <xsl:comment>[if IE 7]>         &lt;html class="no-js lt-ie9 lt-ie8"> &lt;![endif]</xsl:comment>
      <xsl:comment>[if IE 8]>         &lt;html class="no-js lt-ie9"> &lt;![endif]</xsl:comment>
      <xsl:comment>[if gt IE 8]></xsl:comment>
      <html class="no-js">
       <xsl:comment>&lt;![endif]</xsl:comment>
    
       <!-- write the page head element and its contents -->
       <xsl:variable name="sourcedoc">
        <xsl:value-of select="$sourcedir"/>
        <xsl:value-of select="$placenum"/>
        <xsl:text>.xml</xsl:text>
       </xsl:variable>
       
       <xsl:call-template name="boilerplate-head">
        <xsl:with-param name="description" select="$description"/>
        <xsl:with-param name="name-app" select="$name-app"/>
        <xsl:with-param name="name-page-short" select="$name-page-short"/>
        <xsl:with-param name="basepath">..</xsl:with-param>
        <xsl:with-param name="titleStmt" select="document($sourcedoc)/descendant-or-self::t:TEI/descendant-or-self::t:titleStmt"/>
       </xsl:call-template>
    
       <!-- write the body element and its contents -->
       <body xml:lang="en" lang="en">
        
        <!-- add an upgrade urging for users of old IE versions -->
        <xsl:call-template name="boilerplate-badbrowser"/>
        
        <xsl:call-template name="boilerplate-nav">
         <xsl:with-param name="active">browse</xsl:with-param>
         <xsl:with-param name="app-name" select="$name-app"/>
         <xsl:with-param name="basepath">..</xsl:with-param>
        </xsl:call-template>
        
        <!-- ADD: breadcrumbs -->
        
        <!-- create the main content portion of the page -->
        <div class="container-fluid">
         <div class="row-fluid">
          <div class="span7" xml:id="place-content">
           
           <h2>
            <xsl:for-each select="t:placeName[@xml:lang='en'][1]">
             <bdi dir="ltr" lang="{@xml:lang}">
              <xsl:copy-of select="@xml:lang"/>
              <xsl:value-of select="."/>
             </bdi>
            </xsl:for-each>
            <xsl:if test="t:placeName[@xml:lang='en'] and t:placeName[@xml:lang='syr']">
             <xsl:text> — </xsl:text>
            </xsl:if>
            <xsl:for-each select="t:placeName[@xml:lang='syr'][1]">
             <bdi dir="rtl" lang="{@xml:lang}">
              <xsl:copy-of select="@xml:lang"/>
              <xsl:value-of select="."/>
             </bdi>
            </xsl:for-each>
           </h2>
           <div id="link-icons">
            <xsl:for-each select="t:idno[@type='Pleiades']">
             <a href="{.}"><img src="../img/circle-pi-25.png" alt="Image of the Greek letter pi in blue; small icon of the Pleiades project" title="{../t:placeName[@xml:lang='en'][1]} in Pleiades"/></a>
            </xsl:for-each>
            <xsl:for-each select="t:idno[@type='Wikipedia']">
             <a href="{.}"><img src="../img/Wikipedia-25.png" alt="The Wikipedia globe icon" title="{../t:placeName[@xml:lang='en'][1]} in Wikipedia"/></a>
            </xsl:for-each>
            
           </div>
           <xsl:for-each select="t:idno[@type='SRP']">
            <div>
             <a href="../help/terms.html#place-uri" title="Click to read more about Place URIs"><div class="helper circle">
              <p>i</p>
             </div></a>
            <p><span class="label label-info">Place URI</span>
             <xsl:text>: </xsl:text><xsl:value-of select="."/></p>
            </div>
           </xsl:for-each>
           <xsl:for-each select="t:desc[@type='abstract'][1]">
            <p><xsl:apply-templates mode="cleanout"/></p>
           </xsl:for-each>
    
           <!-- ADD: page content here -->
           <div class="tabbable">
            <ul class="nav nav-tabs" id="nametabs">
             <li class="active"><a href="#summary" data-toggle="tab">summary</a></li>
             <li><a href="#full" data-toggle="tab">full record</a></li>
            </ul>
            <xsl:for-each select="document($sourcedoc)/descendant-or-self::t:place[1]">
             <div class="tab-content">
              <div class="tab-pane active" id="summary">
               <xsl:apply-templates select="." mode="summary"/>
              </div>
              <div class="tab-pane" id="full">
               <xsl:apply-templates select=".">
                <xsl:with-param name="idx" select="$idx"/>
               </xsl:apply-templates>
              </div>
             </div>
            </xsl:for-each>
           </div>
           <div id="externals">
           <p><span class="label">Other formats</span> 
            <xsl:text> </xsl:text>
           <a href="{$xmlbase}/{$placenum}.xml">tei xml (source)</a></p>
           </div>
          </div>
         </div>
         
         <!-- write the standard page footer -->
         <xsl:call-template name="boilerplate-footer">
          <xsl:with-param name="copyright-year" select="$copyright-year"/>
          <xsl:with-param name="copyright-holders" select="$copyright-holders"/>
         </xsl:call-template>
         
        </div>
    
        <!-- write scripts etc. that belong at the bottom of the body -->
        <xsl:call-template name="boilerplate-bottom">
         <xsl:with-param name="basepath">..</xsl:with-param>
        </xsl:call-template>
       </body>
      </html>
     </xsl:result-document>
     
    </xsl:when>
    <xsl:otherwise>
     <xsl:message>WARNING: placepage.xsl didn't find proper place id in file <xsl:value-of select="document-uri(.)"/></xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template match="t:place" mode="summary">
  <p>Alternate names
  <xsl:for-each-group select="t:placeName" group-by="@xml:lang">
   <xsl:sort select="current-grouping-key()"/>
   <xsl:apply-templates select="." mode="summary">
    <xsl:sort select="."/>
   </xsl:apply-templates>
  </xsl:for-each-group></p>
  <p>Place type: <xsl:value-of select="@type"/></p>
 </xsl:template>
 
 <xsl:template match="t:place">
  <xsl:param name="idx"/>
  <xsl:variable name="thistype" select="@type"/>
  <xsl:variable name="thisid" select="@xml:id"/>
  <div id="type">
   <h3>Place Type</h3>
   <ul class="dropdown">
    <li><a data-toggle="dropdown" href="#">
     <xsl:value-of select="$thistype"/>
    </a>
    <ul class="dropdown-menu">
     <xsl:for-each select="$idx/descendant-or-self::t:place[@type=$thistype and not(@xml:id=$thisid)]">
      <xsl:sort collation="mixed" select="t:placeName[@xml:lang='en'][1]/@reg"/>
      <li><a href="{t:idno[@type='placeID']}.html"><xsl:value-of select="t:placeName[@xml:lang='en'][1]"/></a></li>
     </xsl:for-each>
    </ul></li>
   </ul>
  </div>
  <div id="placenames">
   <h3>Names</h3>
   <ul>
    <xsl:apply-templates select="t:placeName[@syriaca-tags='#syriaca-headword' and @xml:lang='en']">
     <xsl:with-param name="idx" select="$idx"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="t:placeName[@syriaca-tags='#syriaca-headword' and @xml:lang!='en']">
     <xsl:with-param name="idx" select="$idx"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="t:placeName[not(@syriaca-tags) or @syriaca-tags!='#syriaca-headword']">
     <xsl:with-param name="idx" select="$idx"/>
    </xsl:apply-templates>
   </ul>
  </div>
  <div id="location">
   <h3>Location</h3>
   <ul><xsl:apply-templates select="t:location"/></ul>
  </div>
  <div id="sources">
   <h3>Sources</h3>
   <ul>
    <xsl:apply-templates select="t:bibl" mode="footnote"/>
   </ul>
  </div>
 </xsl:template>
 
 <xsl:template match="t:location[@type='geopolitical']">
  <li><xsl:apply-templates/>
  <xsl:call-template name="do-refs"/></li>
 </xsl:template>
 
 <xsl:template match="t:location[@type='gps' and t:geo]">
  <li>Coordinates: <xsl:value-of select="t:geo"/><xsl:call-template name="do-refs"/></li>
 </xsl:template>
 
 <xsl:template match="t:region">
  <xsl:choose>
   <xsl:when test="@ref">
    <a href="{@ref}"><xsl:apply-templates select="." mode="out-normal"/></a>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="." mode="out-normal"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="t:placeName" mode="summary">
  <xsl:text> : </xsl:text>
  <span class="placeName">
   <xsl:call-template name="langattr"/>
   <xsl:apply-templates select="." mode="out-normal"/>
  </span>
 </xsl:template>
 <xsl:template match="t:placeName">
  <xsl:param name="idx"/>
  <li dir="ltr">
   
   <!-- write out the placename itself, with appropriate language and directionality indicia -->
   <span class="placeName">
    <xsl:call-template name="langattr"/>
    <xsl:apply-templates select="." mode="out-normal"/>
   </span>
   
   <!-- if there is language info, make it explicit for readers -->
   <xsl:if test="@xml:lang">
    <xsl:variable name="thislang" select="@xml:lang"/>
    <xsl:text> </xsl:text>
    <xsl:for-each select="./ancestor::t:TEI/descendant::t:language[@ident=current()/@xml:lang][1]">
     <bdi dir="ltr">
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="." mode="out-normal"/>
      <xsl:text>)</xsl:text>
     </bdi>
    </xsl:for-each>
   </xsl:if>
   
   <xsl:call-template name="do-refs"/>
  </li>
 </xsl:template>
 
 <xsl:template name="do-refs">
  <!-- credit sources for data -->
  <xsl:if test="@source">
   <xsl:variable name="root" select="ancestor::t:TEI" as="node()"/>
   <xsl:variable name="biblids" select="tokenize(@source, ' ')"/>
   <xsl:variable name="last" select="$biblids[last()]"/>
   <bdi class="footnote-refs" dir="ltr">
    <xsl:for-each select="$biblids">
     <xsl:variable name="sought" select="substring-after(., '#')"/>
     <xsl:apply-templates select="$root/descendant::t:bibl[@xml:id=$sought]" mode="footnote-ref">
      <xsl:with-param name="footnote-number" select="substring-after(., '-')"/>
     </xsl:apply-templates>
     <xsl:if test="count($biblids) &gt; 1 and . != $last">
      <xsl:text>,</xsl:text>
     </xsl:if>
    </xsl:for-each>
   </bdi>
  </xsl:if>
 </xsl:template>

 <xsl:template match="t:bibl" mode="footnote">
  <xsl:param name="footnote-number">-1</xsl:param>
  <xsl:variable name="thisnum">
   <xsl:choose>
    <xsl:when test="$footnote-number='-1'">
     <xsl:value-of select="substring-after(@xml:id, '-')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$footnote-number"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <li xml:id="{@xml:id}">
   <span class="footnote-tgt"><xsl:value-of select="$thisnum"/></span>
   <span class="footnote-content">
    <xsl:apply-templates mode="footnote"/>
   </span>
  </li>
 </xsl:template>
 
 <xsl:template match="t:author[ancestor::t:bibl]" mode="footnote">
  <xsl:apply-templates select="." mode="out-normal"/>
  <xsl:text>. </xsl:text>
 </xsl:template>
 
 <xsl:template match="t:title[ancestor::t:bibl]" mode="footnote">
  <span class="title">
   <xsl:call-template name="langattr"/>
   <xsl:apply-templates select="." mode="out-normal"/>
   <xsl:text>. </xsl:text>
  </span>
 </xsl:template>
 
 <xsl:template match="t:citedRange[ancestor::t:bibl]" mode="footnote">
  <xsl:choose>
   <xsl:when test="@unit='pp' and contains(., '-')">
    <xsl:text>pp. </xsl:text>
   </xsl:when>
   <xsl:when test="@unit='pp' and not(contains(., '-'))">
    <xsl:text>p. </xsl:text>
   </xsl:when>
  </xsl:choose>
  <xsl:apply-templates select="." mode="out-normal"/>
  <xsl:text>.</xsl:text>
 </xsl:template>

 <xsl:template match="t:bibl" mode="footnote-ref">
  <xsl:param name="footnote-number">1</xsl:param>
  <span class="footnote-ref">
   <a href="#{@xml:id}"><xsl:value-of select="$footnote-number"/></a>
  </span>
 </xsl:template>
 
 <xsl:template name="get-headword-ele" as="element()*">
  <xsl:choose>
   <xsl:when test="./descendant-or-self::t:listPlace/t:place/t:placeName[@syriaca-tags='#syriaca-headword']">
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:placeName[@syriaca-tags='#syriaca-headword']"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:message>WARNING: placepage.xsl unable to find placeName tagged with '#syriaca-headword' in <xsl:value-of select="document-uri(.)"/></xsl:message>
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:placeName[1]"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 <xsl:template name="get-description-ele" as="element()*">
  <xsl:choose>
   <xsl:when test="./descendant-or-self::t:listPlace/t:place/t:desc[starts-with(@xml:id, 'abstract-en')]">
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:desc[starts-with(@xml:id, 'abstract-en')]"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:message>WARNING: placepage.xsl unable to find desc with id that starts with 'abstract-en' in <xsl:value-of select="document-uri(.)"/></xsl:message>
    <xsl:sequence select="./descendant-or-self::t:listPlace/t:place/t:desc[1]"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
 
 <xsl:template match="text()" mode="cleanout">
  <xsl:value-of select="normalize-space(.)"/>
 </xsl:template>
 
 <xsl:template match="t:*" mode="cleanout">
  <xsl:apply-templates mode="cleanout"/>
  <xsl:call-template name="log">
   <xsl:with-param name="msg">
    <xsl:text>untrapped element for mode="cleanout" passed through</xsl:text>
   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
 <!-- |||| match=t:*: suppress all TEI elements not otherwise handled -->
 <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
 
 <xsl:template match="t:*">
  <xsl:call-template name="log">
   <xsl:with-param name="msg">
    <xsl:text>untrapped element suppressed</xsl:text>
   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>
 
 
</xsl:stylesheet>
