//this is the route controller
var app=angular.module("myapp",['ngRoute']);

app.config(["$routeProvider",function($routeProvider){
	$routeProvider.
    
    when("/",{
		templateUrl:"html/home.html",
		controller:"MarkerController"
	}).
    when("/menu",{
        templateUrl:"html/menu.html",
		controller:"mycrtl"
    }).
    when("/contacts",{
        templateUrl:"html/contacts.html",
		controller:"mycrtl"
    }).
    otherwise({
        templateUrl:"html/home.html",
		controller:"mycrtl"
    });

}]);


app.controller("mycrtl",function($scope){
	$scope.name="anshuman mund";

});

//leaflet
app.controller("MarkerController", [ '$scope', function($scope) {
    angular.extend($scope, {
        osloCenter: {
            lat: 59.91,
            lng: 10.75,
            zoom: 12
        },
        markers: {
            osloMarker: {
                lat: 59.91,
                lng: 10.75,
                message: "I want to travel here!",
                focus: true,
                draggable: false
            }
        },
        defaults: {
            scrollWheelZoom: false
        }
    });
}]);