var ngSlatwall = angular.module('ng-slatwall', []);

/*
ngSlatwall.controller('admin-entity-preprocessaccount_addaccountpayment', function($scope) {
	$scope.totalAmountToApply = 0;
});
*/

ngSlatwall.controller('admin-entity-detailaccount', function($scope) {
	$scope.totalAmountToApply = 0;
});

ngSlatwall.controller('defaultController', ['$scope', function($scope) {
	console.log($scope);
	$scope.totalAmountToApply = 0;
	//alert($scope.ngControllerName);
}]);

