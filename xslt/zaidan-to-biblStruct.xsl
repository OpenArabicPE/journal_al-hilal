<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:include href="/Volumes/Dessau HD/BachUni/projekte/XML/Functions/BachFunctions v3.xsl"/>
    
    
    <xsl:template match="/">
        <tei:listBibl>
            <xsl:apply-templates/>
        </tei:listBibl>
    </xsl:template>

    <xsl:template match="Document">
        <tei:biblStruct xml:lang="ar">
            <!-- provide the article level information -->
            <tei:analytic>
                <xsl:apply-templates select="child::Title | child::Author"/>
            </tei:analytic>
            <!-- provide information on the issue level -->
            <tei:monogr>
                <tei:title level="j">الهلال</tei:title>
                <!-- the subtitle changed repeatedly. I established the following changes based on the facsimile on HathiTrust -->
                <xsl:choose>
                    <xsl:when test="child::Year &lt;= 15">
                        <tei:title level="j" type="sub">مجلة علمية تاريخية صحية أدبية</tei:title>
                    </xsl:when>
                    <xsl:when test="child::Year &lt;= 29">
                        <tei:title level="j" type="sub">مجلة تاريخية اجتماعية علمية أدبية صحية</tei:title>
                    </xsl:when>
                    <xsl:when test="child::Year &gt;= 30">
                        <tei:title level="j" type="sub">مجلة شهرية مطورة</tei:title>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test=" year-from-date(child::Date/@when) &lt; 1915">
                        <tei:editor ref="viaf:76496271">
                            <tei:persName>
                                <tei:forename>جرجي</tei:forename>
                                <tei:surname>زيدان</tei:surname>
                            </tei:persName>
                        </tei:editor>
                    </xsl:when>
                    <!-- who was the editor after 1914? -->
                    <xsl:when test="child::Year &gt;= 24 and child::Year &lt;= 29">
                        <tei:editor ref="viaf:53091461">
                            <tei:persName>
                                <tei:forename>اميل</tei:forename>
                                <tei:surname>زيدان</tei:surname>
                            </tei:persName>
                        </tei:editor>
                    </xsl:when>
                    <xsl:when test="child::Year &gt;= 30">
                        <tei:editor ref="viaf:53091461">
                            <tei:persName>
                                <tei:forename>اميل</tei:forename>
                                <tei:surname>زيدان</tei:surname>
                            </tei:persName>
                        </tei:editor>
                        <tei:editor>
                            <tei:persName>
                                <tei:forename>شكري</tei:forename>
                                <tei:surname>زيدان</tei:surname>
                            </tei:persName>
                        </tei:editor>
                    </xsl:when>
                </xsl:choose>
                <tei:imprint>
                    <tei:publisher>
                        <tei:orgName>مطبعة الهلال</tei:orgName>
                       <!-- <xsl:choose>
                            <xsl:when test=" year-from-date(child::Date/@when) &lt; 1915">
                                <tei:orgName>دار الهلال</tei:orgName>
                            </xsl:when>
                            <xsl:when test="child::Year &gt;= 23">
                                <tei:orgName>مطبعة الهلال</tei:orgName>
                            </xsl:when>
                        </xsl:choose>-->
                    </tei:publisher>
                    <tei:pubPlace>
                        <tei:placeName>القاهرة</tei:placeName>
                    </tei:pubPlace>
                    <xsl:apply-templates select="child::Date"/>
                </tei:imprint>
                <xsl:apply-templates select="child::Year | child::Volume | child::StartPage"/>
            </tei:monogr>
            <!-- Unfortunately the ID is not unique across the entire Database from zaidanfoundation -->
            <!-- <tei:idno type="zaidanfoundation">
                <xsl:apply-templates select="child::ID"/>
            </tei:idno> -->
            <tei:idno type="oclc">1639361</tei:idno>
            <tei:idno type="oclc">183194011</tei:idno>
            <tei:idno type="issn">1110-8908</tei:idno>
            <xsl:apply-templates select="child::TitleSub"/>
        </tei:biblStruct>
    </xsl:template>
    
    <xsl:template match="Date">
        <!-- has been normalized with regex -->
       <tei:date when="{@when}">
           <xsl:apply-templates/>
       </tei:date>
    </xsl:template>
    
    <xsl:template match="Year">
        <tei:biblScope unit="volume">
            <xsl:attribute name="n" select="."/>
            <xsl:value-of select=" following-sibling::YearString"/>
        </tei:biblScope>
    </xsl:template>
    <xsl:template match="Volume">
    <tei:biblScope unit="issue">
        <xsl:attribute name="n" select="."/>
        <xsl:value-of select=" following-sibling::VolumeStr"/>
    </tei:biblScope>
    </xsl:template>
    <xsl:template match="StartPage">
        <tei:biblScope unit="page">
            <xsl:choose>
                <xsl:when test=". = EndPage">
                    <xsl:attribute name="n" select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="from" select="."/>
                    <xsl:attribute name="to" select="following-sibling::EndPage"/>
                </xsl:otherwise>
            </xsl:choose>
        </tei:biblScope>
    </xsl:template>
    
    <xsl:template match="Title">
        <tei:title level="a">
            <xsl:apply-templates/>
        </tei:title>
    </xsl:template>
    <xsl:template match="Author">
        <xsl:if test="not(.='NULL')">
            <tei:author>
                <tei:persName>
                    <xsl:apply-templates/>
                </tei:persName>
            </tei:author>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TitleSub">
        <tei:note><xsl:apply-templates/></tei:note>
    </xsl:template>
    
    <!-- normalise text input -->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
</xsl:stylesheet>