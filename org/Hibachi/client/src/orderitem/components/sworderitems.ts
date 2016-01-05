class SWOrderItems{
	public static Factory(){
		var directive = (
			$log,
			$timeout,
			$location,
			$slatwall,
			formService,
			orderItemPartialsPath,
			pathBuilderConfig,
			paginationService
		)=> new SWOrderItems(
			$log,
			$timeout,
			$location,
			$slatwall,
			formService,
			orderItemPartialsPath,
			pathBuilderConfig,
			paginationService
		);
		directive.$inject = [
			'$log',
			'$timeout',
			'$location',
			'$slatwall',
			'formService',
			'orderItemPartialsPath',
			'pathBuilderConfig',
			'paginationService'
		];
		return directive;
	}
	constructor(
		$log,
		$timeout,
		$location,
		$slatwall,
		formService,
		orderItemPartialsPath,
		pathBuilderConfig,
		paginationService
	){
		return {
			restrict: 'E',
			scope:{
				orderId:"@"
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(orderItemPartialsPath)+"orderitems.html",

			link: function(scope, element, attrs){
				var options:any = {};
				scope.keywords = "";
				scope.loadingCollection = false;
				var searchPromise;
				scope.searchCollection = function(){
					if(searchPromise) {
						$timeout.cancel(searchPromise);
					}

					searchPromise = $timeout(function(){
						$log.debug('search with keywords');
						$log.debug(scope.keywords);
						//Set current page here so that the pagination does not break when getting collection
						scope.paginator.setCurrentPage(1);
						scope.loadingCollection = true;
						scope.getCollection();
					}, 500);
				};

				$log.debug('Init Order Item');
				$log.debug(scope.orderId);

				//Setup the data needed for each order item object.
				scope.getCollection = function(){
					if(scope.pageShow === 'Auto'){
						scope.pageShow = 50;
					}

					var columnsConfig =[
					{
					   "isDeletable":false,
					   "isExportable":true,
					   "propertyIdentifier":"_orderitem.orderItemID",
					   "ormtype":"id",
					   "isVisible":true,

					   "title":"Order Item ID",
					    "isSearchable":true
					},
                    {
                        "isVisible":false,
                        "ormtype":"string",
                        "propertyIdentifier":"_orderitem.currencyCode"
                    },
					{
					   "title":"Order Item Type",
					   "propertyIdentifier":"_orderitem.orderItemType",
					   "isVisible":true,
					},
					{
					   "title":"Order Item Price",
					   "propertyIdentifier":"_orderitem.price",
					   "isVisible":true,

					},
					{
					   "title":"Sku Name",
					   "propertyIdentifier":"_orderitem.sku.skuName",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Sku Price",
					   "propertyIdentifier":"_orderitem.skuPrice",
					   "isVisible":true,

					},
					{
					   "title":"Sku ID",
					   "propertyIdentifier":"_orderitem.sku.skuID",
					   "isVisible":true,

					},
					{
					   "title":"SKU Code",
					   "propertyIdentifier":"_orderitem.sku.skuCode",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Product Bundle Group",
					   "propertyIdentifier":"_orderitem.productBundleGroup.productBundleGroupID",
					   "isVisible":true,

					},
					{
					   "title":"Product ID",
					   "propertyIdentifier":"_orderitem.sku.product.productID",
					   "isVisible":true,

					},
					{
					   "title":"Product Name",
					   "propertyIdentifier":"_orderitem.sku.product.productName",
					   "isVisible":true,

					},
					{
					   "title":"Product Type",
					   "propertyIdentifier":"_orderitem.sku.product.productType",
					   "isVisible":true
					},
                     {
                        "propertyIdentifier":"_orderitem.sku.baseProductType",
                        "persistent":false
                     },
					{
					   "title":"Product Description",
					   "propertyIdentifier":"_orderitem.sku.product.productDescription",
					   "isVisible":true,

					},
					{
					   "title":"Event Start Date Time",
					   "propertyIdentifier":"_orderitem.sku.eventStartDateTime",
					   "isVisible":true,

					},
					{
					   "title":"Product Description",
					   "propertyIdentifier":"_orderitem.sku.options",
					   "isVisible":true,

					},
					{
						   "title":"Sku Location",
						   "propertyIdentifier":"_orderitem.sku.locations",
						   "isVisible":true,

						   "persistent":false
					},
					{
						   "title":"Subscription Term",
						   "propertyIdentifier":"_orderitem.sku.subscriptionTerm.subscriptionTermName",
						   "isVisible":true,

					},
					{
						   "title":"Subscription Benefits",
						   "propertyIdentifier":"_orderitem.sku.subscriptionBenefits",
						   "isVisible":true,

					},
					{
					   "title":"Qty.",
					   "propertyIdentifier":"_orderitem.quantity",
					   "isVisible":true,

					},
					{
					   "title":"Fulfillment Method Name",
					   "propertyIdentifier":"_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
					   "isVisible":true,

					},
					{
					   "title":"Fulfillment ID",
					   "propertyIdentifier":"_orderitem.orderFulfillment.orderFulfillmentID",
					   "isVisible":true,

					},
					{
					   "title":"Fulfillment Method Type",
					   "propertyIdentifier":"_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
					   "isVisible":true,

					},
					{
					   "title":"Street Address",
					   "propertyIdentifier":"_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Street Address",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.streetAddress",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Street Address 2",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.street2Address",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Postal Code",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.postalCode",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"City",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.city",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"State",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.stateCode",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Country",
					   "propertyIdentifier":"_orderitem.orderFulfillment.shippingAddress.countryCode",
					   "isVisible":true,

					   "ormtype":"string",
					    "isSearchable":true
					},
					{
					   "title":"Image File Name",
					   "propertyIdentifier":"_orderitem.sku.imageFile",
					   "isVisible":true,

					},
					{
					   "title":"Total",
					   "propertyIdentifier":"_orderitem.itemTotal",
					   "persistent":false
					},
					{
					   "title":"Discount Amount",
					   "propertyIdentifier":"_orderitem.discountAmount",
					   "persistent":false
					},
					{
					   "title":"Tax Amount",
					   "propertyIdentifier":"_orderitem.taxAmount",
					   "persistent":false
					},
					{
					   "propertyIdentifier":"_orderitem.extendedPrice",
					   "persistent":false
					},
					{
					   "propertyIdentifier":"_orderitem.productBundlePrice",
					   "persistent":false
					}


 				  ];

					//add attributes to the column config
					angular.forEach(scope.attributes,function(attribute){
						var attributeColumn:any = {
							propertyIdentifier:"_orderitem."+attribute.attributeCode,
							attributeID:attribute.attributeID,
					         attributeSetObject:"orderItem"
						};
						columnsConfig.push(attributeColumn);
					});

					var filterGroupsConfig =[
					    {
					      "filterGroup": [
					        {
					          "propertyIdentifier": "_orderitem.order.orderID",
					          "comparisonOperator": "=",
					          "value": scope.orderId,
					        },
					        {
					        	"logicalOperator":"AND",
					          "propertyIdentifier": "_orderitem.parentOrderItem",
					          "comparisonOperator": "is",
					          "value": "null",
					        }
					      ]
					    }
					  ];

					options = {
						columnsConfig:angular.toJson(columnsConfig),
						filterGroupsConfig:angular.toJson(filterGroupsConfig),
						currentPage:scope.paginator.getCurrentPage(),
						pageShow:scope.paginator.getPageShow(),
						keywords:scope.keywords
					};
					//Create a list of order items.
					//scope.orderItems = [];
					scope.orderAttributes = [];
					scope.attributeValues = [];
					var orderItemsPromise = $slatwall.getEntity('orderItem', options);
					orderItemsPromise.then(function(value){
						scope.collection = value;
						var collectionConfig:any = {};
						collectionConfig.columns = columnsConfig;
						collectionConfig.baseEntityName = 'SlatwallOrderItem';
						collectionConfig.baseEntityAlias = '_orderitem';
						scope.orderItems = $slatwall.populateCollection(value.pageRecords,collectionConfig);
                         for (var orderItem in scope.orderItems){
                             $log.debug("OrderItem Product Type");
                             $log.debug(scope.orderItems);
                             //orderItem.productType = orderItem.data.sku.data.product.data.productType.$$getParentProductType();

                         }
                        scope.paginator.setPageRecordsInfo(scope.collection);

						scope.loadingCollection = false;
					},function(value){
                         scope.orderItems = [];
                    });
				};
				//get all possible attributes
				var attributesConfig = [
                    {
                        "propertyIdentifier":"_attribute.attributeID",
                        "ormtype":"id",
                        "title":"attributeID",
                     },
                     {
                        "propertyIdentifier":"_attribute.attributeCode",
                        "ormtype":"string",
                        "title":"Attribute Code",
                     },
                     {
                         "propertyIdentifier":"_attribute.attributeName",
                         "ormtype":"string",
                         "title":"Attribute Name",
                      }
                  ];

				var attributesFilters =[
				    {
					    "filterGroup": [
	     			        {
	     			          "propertyIdentifier": "_attribute.displayOnOrderDetailFlag",
	     			          "comparisonOperator": "=",
	     			          "value": true
	     			        },
	     			       {
	     			        	"logicalOperator":"AND",
	     			          "propertyIdentifier": "_attribute.activeFlag",
	     			          "comparisonOperator": "=",
	     			          "value": true
	     			        }
     			      ]
     			    }
     			];
				var attributeOptions = {
						columnsConfig:angular.toJson(attributesConfig),
						filterGroupsConfig:angular.toJson(attributesFilters),
						allRecords:true
					};
				var attItemsPromise = $slatwall.getEntity('attribute', attributeOptions);
				attItemsPromise.then(function(value){
					scope.attributes = [];
					angular.forEach(value.records, function(attributeItemData){
						//Use that custom attribute name to get the value.
						scope.attributes.push(attributeItemData);

					});
					scope.getCollection();
				});

				//Add claim function and cancel function

				scope.appendToCollection = function(){
					if(scope.pageShow === 'Auto'){
						$log.debug('AppendToCollection');
						if(scope.paginator.autoScrollPage < scope.collection.totalPages){
							scope.paginator.autoScrollDisabled = true;
							scope.paginator.autoScrollPage++;

							var appendOptions:any = {};
							angular.extend(appendOptions,options);
							appendOptions.pageShow = 50;
							appendOptions.currentPage = scope.paginator.autoScrollPage;

							var collectionListingPromise = $slatwall.getEntity('orderItem', appendOptions);
							collectionListingPromise.then(function(value){
								scope.collection.pageRecords = scope.collection.pageRecords.concat(value.pageRecords);
								scope.autoScrollDisabled = false;
							},function(reason){
                                scope.collection.pageRecords = [];
							});
						}
					}
				};

                scope.paginator = paginationService.createPagination();
                scope.paginator.collection = scope.collection;
                scope.paginator.getCollection = scope.getCollection;

			}//<--End link
		};
	}
}
export{
	SWOrderItems
}