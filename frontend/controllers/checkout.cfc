/*

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

*/
component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="accountService" type="any";
	property name="addressService" type="any";
	property name="orderService" type="any";
	property name="paymentService" type="any";
	property name="settingService" type="any";
	property name="userUtility" type="any";
	
	property name="hibachiSessionService" type="any";
	
	public any function init(required any fw) {
		return super.init(arguments.fw);
	}
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="";
		param name="rc.orderRequirementsList" default="";
		param name="rc.guestAccountOK" default="false";
		
		// Insure that the cart is not new, and that it has order items in it.  otherwise redirect to the shopping cart
		if(!arrayLen(rc.$.slatwall.cart().getOrderItems())) {
			getFW().redirectSetting( settingName='globalPageShoppingCart' );
		}
		
		// Insure that all items in the cart are within their max constraint
		if(!rc.$.slatwall.cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getFW().redirectSetting( settingName='globalPageShoppingCart', queryString='slatAction=frontend:cart.forceItemQuantityUpdate' );
		}
		
		// Recaluclate Order Totals In Case something has changed
		getOrderService().recalculateOrderAmounts(rc.$.slatwall.cart());
		
		// get the list of requirements left for this order to be processed
		rc.orderRequirementsList = getOrderService().getOrderRequirementsList(rc.$.slatwall.cart());
		
		// LEGACY SUPPORT
		if(listFindNoCase(rc.orderRequirementsList, "fulfillment")) {
			rc.orderRequirementsList = listAppend(rc.orderRequirementsList, rc.$.slatwall.cart().getOrderFulfillments()[1].getOrderFulfillmentID());
		}
		
		// Account Setup Logic
		if(!structKeyExists(rc, "account")) {
			if ( isNull(rc.$.slatwall.cart().getAccount()) ) {
				// When no account is in the order then just set a new account in the rc so it works
				// We don't need to put account in the rc.orderRequirementsList because it will already be there
				rc.account = getAccountService().newAccount();
			} else {
				// If the account on cart is the same as the one logged in then set the rc.account from cart
				// OR If the cart is using a guest account, and this method was called from a different controller that says guest accounts are ok, then pass in the cart account
				if( rc.$.slatwall.cart().getAccount().getAccountID() == rc.$.slatwall.account().getAccountID() || (rc.$.slatwall.cart().getAccount().isGuestAccount() && rc.guestAccountOK) ) {
					rc.account = rc.$.slatwall.cart().getAccount();
				} else {
					rc.account = getAccountService().newAccount();
					// Here we need to add it to the requirements list because the cart might have already had an account
					rc.orderRequirementsList = listPrepend(rc.orderRequirementsList,"account");
				}
			}
		}
		
		// Setup some elements to be used by different views
		rc.eligiblePaymentMethodDetails = getPaymentService().getEligiblePaymentMethodDetailsForOrder(order=rc.$.slatwall.cart());
		
		// This RC Key is deprecated
		rc.activePaymentMethods = getPaymentService().listPaymentMethodFilterByActiveFlag(1);
	}
	
	public void function confirmation(required struct rc) {
		param name="rc.orderID" default="";
		
		rc.order = getOrderService().getOrder(rc.orderID, true);
		
	}
	
	public void function loginAccount(required struct rc) {
		param name="rc.username" default="";
		param name="rc.password" default="";
		param name="rc.returnURL" default="";
		param name="rc.forgotPasswordEmail" default="";
		
		if(rc.forgotPasswordEmail != "") {
			rc.forgotPasswordResult = rc.$.getBean('userUtility').sendLoginByEmail(email=rc.forgotPasswordEmail, siteid=rc.$.event('siteID'));
		} else {
			var loginSuccess = rc.$.getBean('userUtility').login(username=arguments.rc.username, password=arguments.rc.password, siteID=rc.$.event('siteid'));
			
			if(!loginSuccess) {
				request.status = "failed";
			}
		}
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function saveOrderAccount(required struct rc) {
		
		// Format the account data to work
		var accountData = {};
		if(structKeyExists(rc, "account") && isStruct(rc.account)) {
			var accountData = structCopy(rc.account);
			if(structKeyExists(accountData, "password") && !structKeyExists(accountData, "passwordConfirm")) {
				accountData.passwordConfirm = accountData.password;
			}
			if(structKeyExists(accountData, "emailAddress") && !structKeyExists(accountData, "emailAddressConfirm")) {
				accountData.emailAddressConfirm = accountData.emailAddress;
			}
		}
		
		// Call the new processing methods
		if(rc.$.slatwall.getAccount().getNewFlag()) {
			
			arguments.rc.account = getAccountService().processAccount( rc.$.slatwall.getAccount(), accountData, 'create');
			
			// If there were errors creating an account
			if(arguments.rc.account.getProcessObject('create').hasErrors()) {
				arguments.rc.account.addErrors(arguments.rc.account.getProcessObject('create').getErrors());
				
				if(!isNull(arguments.rc.account.getProcessObject('create').getFirstName())) {
					arguments.rc.account.setFirstName(arguments.rc.account.getProcessObject('create').getFirstName());	
				}
				if(!isNull(arguments.rc.account.getProcessObject('create').getLastName())) {
					arguments.rc.account.setLastName(arguments.rc.account.getProcessObject('create').getLastName());	
				}
				if(!isNull(arguments.rc.account.getProcessObject('create').getEmailAddress())) {
					arguments.rc.account.getPrimaryEmailAddress().setEmailAddress(arguments.rc.account.getProcessObject('create').getEmailAddress());	
				}
				if(!isNull(arguments.rc.account.getProcessObject('create').getPhoneNumber())) {
					arguments.rc.account.getPrimaryPhoneNumber().setPhoneNumber(arguments.rc.account.getProcessObject('create').getPhoneNumber());	
				}
				
			// If there were no errors, then we can create a mura account with the same info
			} else {
				var newMuraUser = request.muraScope.getBean('userBean');
				newMuraUser.setFName( nullReplace(rc.$.slatwall.getAccount().getFirstName(), '') );
				newMuraUser.setLName( nullReplace(rc.$.slatwall.getAccount().getLastName(), '') );
				newMuraUser.setCompany( nullReplace(rc.$.slatwall.getAccount().getCompany(), '') );
				newMuraUser.setUsername( rc.$.slatwall.getAccount().getEmailAddress() );
				newMuraUser.setEmail( rc.$.slatwall.getAccount().getEmailAddress() );
				newMuraUser.setPassword( accountData.password );
				newMuraUser.setSiteID( request.muraScope.event('siteID') );
				newMuraUser.save();
			}	
		} else {
			arguments.rc.account = getAccountService().saveAccount( rc.$.slatwall.getAccount(), accountData );
		}
		
		// Get the response in order
		if( !arguments.rc.account.hasErrors() ) {
			rc.$.slatwall.getCart().setAccount( arguments.rc.account );
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestCheckout", false );
		} else {
			arguments.rc.$.slatwall.addActionResult( "public:cart.guestCheckout", true );	
		}
		
		
		rc.guestAccountOK = true;
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function saveOrderFulfillments(required struct rc) {
		rc.guestAccountOK = true;
		
		getOrderService().saveOrder(rc.$.slatwall.cart(), rc);
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function saveOrderPayments(required struct rc) {
		rc.guestAccountOK = true;
		
		getOrderService().updateAndVerifyOrderPayments(order=rc.$.slatwall.cart(), data=rc);
		
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
	public void function processOrder(required struct rc) {
		param name="rc.orderID" default="";
		
		rc.guestAccountOK = true;
		
		// Insure that all items in the cart are within their max constraint
		if(!rc.$.slatwall.cart().hasItemsQuantityWithinMaxOrderQuantity()) {
			getFW().redirectExact(rc.$.createHREF(filename='shopping-cart',queryString='slatAction=frontend:cart.forceItemQuantityUpdate'));
		}
		
		// Setup the order
		var order = getOrderService().getOrder(rc.orderID);
		
		// Attemp to process the order 
		order = getOrderService().processOrder(order, rc, "placeOrder");
		
		if(!order.hasErrors()) {
			
			// Save the order ID temporarily in the session for the confirmation page.  It will be removed by that controller
			rc.$.slatwall.setSessionValue("orderConfirmationID", rc.orderID);
			
			// Redirect to order Confirmation
			getFW().redirectExact(rc.$.createHREF(filename='order-confirmation'), false);
			
		}
			
		detail(rc);
		getFW().setView("frontend:checkout.detail");
	}
	
}
