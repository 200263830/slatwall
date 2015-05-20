/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
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
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/

component  extends="HibachiService" accessors="true" {
	variables.skeletonSitePath = expandPath('/integrationServices/slatwallcms/skeletonsite');
	
	// ===================== START: Logical Methods ===========================
	
	public any function getCurrentRequestSite() {
		var domain = cgi.HTTP_HOST;
		return getDAO('siteDAO').getSiteByDomainName(domain);
	}
	
	public string function getSkeletonSitePath(){
		return variables.skeletonSitePath;
	}
	
	public void function createSlatwallTemplatesChildren(required any slatwallTemplatesContent, required any site){
		var slatwallTemplatesChildren = [
			{
				name='Barrier Template Page',
				templateType=getService("typeService").getTypeBySystemCode("cttBarrierPage"),
				settingName='contentRestrictedContent',
				contentTemplateFile='slatwall-barrier-page.cfm'
			},
			{
				name='Product Type Template',
				templateType=getService("typeService").getTypeBySystemCode("cttProductType"),
				settingName='productType',
				contentTemplateFile='slatwall-producttype.cfm'
			},
			{
				name='Product Template',
				templateType=getService("typeService").getTypeBySystemCode("cttProduct"),
				settingName='product',
				contentTemplateFile='slatwall-product.cfm'
			},
			{
				name='Brand Template',
				templateType=getService("typeService").getTypeBySystemCode("cttBrand"),
				settingName='brand',
				contentTemplateFile='slatwall-brand.cfm'
			}
		];
		
		for(var slatwallTemplatesChild in slatwallTemplatesChildren){
			var slatwallTemplatesChildContentData = {
				contentID='',
				contentPathID='',
				activeFlag=true,
				title=slatwallTemplatesChild.name,
				allowPurchaseFlag=false,
				productListingPageFlag=false
			};
			var slatwallTemplatesChildContent = getService('contentService').newContent();
			slatwallTemplatesChildContent.setURLTitle(ReReplace(slatwallTemplatesChild.name, "[[:space:]]","","ALL"));
			slatwallTemplatesChildContent.setSite(arguments.site);
			slatwallTemplatesChildContent.setParentContent(arguments.slatwallTemplatesContent);
			slatwallTemplatesChildContent.setContentTemplateType(slatwallTemplatesChild.templateType);
			slatwallTemplatesChildContent = getService('contentService').saveContent(slatwallTemplatesChildContent,slatwallTemplatesChildContentData);
			
			var templateSetting = getService("settingService").newSetting();
			templateSetting.setSettingName( slatwallTemplatesChild.settingName & 'DisplayTemplate' );
			templateSetting.setSettingValue( slatwallTemplatesChildContent.getContentID() );
			templateSetting.setSite( arguments.site );
			getService("settingService").saveSetting( templateSetting );
			
			var contentTemplateSetting = getService("settingService").newSetting();
			contentTemplateSetting.setSettingName( 'contentTemplateFile' );
			contentTemplateSetting.setSettingValue( slatwallTemplatesChild.contentTemplateFile );
			contentTemplateSetting.setContent( slatwallTemplatesChildContent );
			getService("settingService").saveSetting( contentTemplateSetting );
		}
	}
	
	public void function createHomePageChildrenContent(required any homePageContent, required any site){
		var homePageChildren = [
			{
				name='My Account',
				contentTemplateFile='slatwall-account.cfm'	
			},
			{
				name='Shopping Cart',
				contentTemplateFile="slatwall-shoppingcart.cfm"	
			},
			{
				name='Product Listing',
				contentTemplateFile="slatwall-productlisting.cfm"
			},
			{
				name='Checkout',
				contentTemplateFile="slatwall-checkout.cfm"
			},
			{
				name='Order Confirmation',
				contentTemplateFile="slatwall-orderconfirmation.cfm"
			}
		];
		
		for(var homePageChild in homePageChildren){
			productListingPageValue = false;
			if(homePageChild.name == 'Product Listing'){
				productListingPageValue = true;
			}
			var homePageChildContentData = {
				contentID='',
				contentPathID='',
				activeFlag=true,
				title=homePageChild.name,
				allowPurchaseFlag=false,
				productListingPageFlag=productListingPageValue
			};
			var homePageChildContent = getService('contentService').newContent();
			homePageChildContent.setSite(arguments.site);
			homePageChildContent.setURLTitle(ReReplace(homePageChild.name, "[[:space:]]","","ALL"));
			homePageChildContent.setParentContent(arguments.homePageContent);
			homePageChildContent = getService('contentService').saveContent(homePageChildContent,homePageChildContentData);
			
			var contentTemplateSetting = getService("settingService").newSetting();
			contentTemplateSetting.setSettingName( 'contentTemplateFile' );
			contentTemplateSetting.setSettingValue( homePageChild.contentTemplateFile );
			contentTemplateSetting.setContent( homePageChildContent );
			getService("settingService").saveSetting( contentTemplateSetting );
		}
	}
	
	public void function createDefaultContentPages(required any site){
		var homePageContentData = {
			contentID='',
			contentPathID='',
			activeFlag=true,
			title='Home',
			allowPurchaseFlag=false,
			productListingPageFlag=false
		};
		var homePageContent = getService('contentService').newContent();
		homePageContent.setSite(arguments.site);
		createHomePageChildrenContent(homePageContent,arguments.site);
		homePageContent = getService('contentService').saveContent(homePageContent,homePageContentData);
		
		var contentTemplateSetting = getService("settingService").newSetting();
		contentTemplateSetting.setSettingName( 'contentTemplateFile' );
		contentTemplateSetting.setSettingValue( 'default.cfm' );
		contentTemplateSetting.setContent( homePageContent );
		getService("settingService").saveSetting( contentTemplateSetting );
		
		var slatwallTemplatesContentData = {
			contentID='',
			contentPathID='',
			activeFlag=true,
			title='Slatwall Templates',
			allowPurchaseFlag=false,
			productListingPageFlag=false
		};
		var slatwallTemplatesContent = getService('contentService').newContent();
		slatwallTemplatesContent.setURLTitle('SlatwallTemplates');
		slatwallTemplatesContent.setSite(arguments.site);
		slatwallTemplatesContent.setParentContent(homePageContent);
		slatwallTemplatesContent = getService('contentService').saveContent(slatwallTemplatesContent,slatwallTemplatesContentData);
		createSlatwallTemplatesChildren(slatwallTemplatesContent,arguments.site);
	}
	
	public void function deploySite(required any site) {
		// copy skeletonsite to /apps/{applicationCodeOrID}/{siteCodeOrID}/
		if(!directoryExists(arguments.site.getSitePath())){
			createDirectory(arguments.site.getSitePath());
		}
		getService("hibachiUtilityService").duplicateDirectory(
			source=getSkeletonSitePath(), 
			destination=arguments.site.getSitePath(), 
			overwrite=false, 
			recurse=true, 
			copyContentExclusionList=".svn,.git"
		);
		createDefaultContentPages(arguments.site);
		
		
		// create 6 content nodes for this site, and map to the appropriate templates
			// home (urlTitle == '') -> /custom/apps/slatwallcms/site1/templates/home.cfm
				// product listing -> /custom/apps/slatwallcms/site1/templates/product-listing.cfm
				// shopping cart -> /custom/apps/slatwallcms/site1/templates/shopping-cart.cfm
				// my account -> /custom/apps/slatwallcms/site1/templates/my-account.cfm
				// checkout
				// order confirmation
				// templates
					// default product template
					// default product type template
					// default brand template
			
		// Update the site specific settings for product/brand/productType display template to be the corrisponding content nodes
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	public any function processSite_create(required any site, required any processObject){
		arguments.site.setApp(arguments.processObject.getApp());
		saveSite(arguments.site,arguments.data);
		return arguments.site;
	}
	
	public any function saveSite(required any site, struct data={}){
		
		if(	
			arguments.site.getNewFlag() 
			&& (
				!isnull(arguments.site.getApp())
				&& !isnull(arguments.site.getApp().getIntegration()) 
				&& arguments.site.getApp().getIntegration().getIntegrationPackage() == 'slatwallcms'
			)
		){
			
			//create directory for site
			if(!directoryExists(arguments.site.getSitePath())){
				directoryCreate(arguments.site.getSitePath());
			}
			arguments.site = super.save(arguments.site, arguments.data);
			//deploy skeletonSite
			deploySite(arguments.site);
		}
		arguments.site = super.save(arguments.site, arguments.data);
		return arguments.site;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}
