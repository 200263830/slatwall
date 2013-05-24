<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="HibachiDAO">
	
	<cffunction name="getContentByCMSContentIDAndCMSSiteID" access="public">
		<cfargument name="cmsContentID" type="string" required="true">
		<cfargument name="cmsSiteID" type="string" required="true">
		
		<cfset var contents = ormExecuteQuery(" FROM SlatwallContent c WHERE c.cmsContentID = ? AND c.site.cmsSiteID = ?", [ arguments.cmsContentID, arguments.cmsSiteID ] ) />
		
		<cfif arrayLen(contents)>
			<cfreturn contents[1] />
		</cfif>
		
		<cfreturn entityNew("SlatwallContent") />
	</cffunction>
	
	<cffunction name="getCategoriesByCmsCategoryIDs" access="public">
		<cfargument name="CmsCategoryIDs" type="string" />
			
		<cfset var hql = " FROM SlatwallCategory sc
							WHERE sc.cmsCategoryID IN (:CmsCategoryIDs) " />
			
		<cfreturn ormExecuteQuery(hql, {CmsCategoryIDs=listToArray(arguments.CmsCategoryIDs)}) />
	</cffunction>
	
	<cffunction name="getCmsCategoriesByCmsContentID" access="public">
		<cfargument name="cmsContentID" type="string" />
			
		<cfquery name="local.returnQuery">
			SELECT categoryID
			FROM tcontentcategoryassign 
			INNER JOIN tcontent ON tcontentcategoryassign.contentHistID = tcontent.contentHistID
			WHERE tcontent.active = 1
			AND tcontent.contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cmsContentID#" />
		</cfquery>
		<cfreturn valueList(returnQuery.categoryID) />
	</cffunction>
	
	<cffunction name="getDisplayTemplates" access="public">
		<cfargument name="templateType" type="string" />
		<cfargument name="siteID" type="string" />
		
		<cfif structKeyExists(arguments, "siteID")>
			<cfreturn ormExecuteQuery(" FROM SlatwallContent WHERE contentTemplateType.systemCode = ? AND site.siteID = ?", ["ctt#arguments.templateType#", arguments.siteID]) />
		</cfif>
		
		<cfreturn ormExecuteQuery(" FROM SlatwallContent WHERE contentTemplateType.systemCode = ?", ["ctt#arguments.templateType#"]) />
	</cffunction>
</cfcomponent>