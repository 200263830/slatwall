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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.product#" edit="#rc.edit#" sRedirectAction="admin:entity.detailProduct" sRedirectQS="productID=#rc.product.getProductID()#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.product#" edit="#rc.edit#">
			<cf_HibachiActionCaller action="admin:main.createimage" queryString="productID=#rc.product.getProductID()#&directory=product&redirectAction=admin:entity.detailproduct" type="list" modal=true />
			<li class="divider"></li>
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="updateSkus" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionTerm" type="list" modal="true" />
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiDetailHeader>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
				<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
				<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
			</cf_HibachiPropertyList>
		</cf_HibachiDetailHeader>
		<cf_HibachiTabGroup object="#rc.product#" allowCustomAttributes="true">
			<cf_HibachiTab property="skus" />
			<cf_HibachiTab property="productDescription" />
			<cf_HibachiTab property="listingPages" />
			<cf_HibachiTab property="categories" />
			<cf_HibachiTab property="productReviews" />
			<cf_HibachiTab property="relatedProducts" />
			<cf_HibachiTab property="vendors" />
			<cf_HibachiTab view="admin:entity/producttabs/alternateimages" />
			<cf_HibachiTab view="admin:entity/producttabs/productsettings" />
			<cf_HibachiTab view="admin:entity/producttabs/skusettings" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>

</cfoutput>