<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    
	<cfoutput>
    	<meta name="description" content="">
    	<meta name="author" content="">
    	<title>${site.siteName}</title>
	</cfoutput>
	
	<!--- Styles --->
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300italic,300,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script> 
    <script src="/org/hibachi/client/src/slatwall_frontend.js"></script>
    <!--- This will contain all needed files for the frontend directives --->
    <script>
        var slatwallAngular = {
            slatwallConfig:{
                baseUrl:'/'
            }
        };
        
        /** Overwrite the partialPath and baseUrl for this application */
        angular.module('frontend')
            .config(['pathBuilderConfig', '$sceDelegateProvider', function(pathBuilderConfig, $sceDelegateProvider){
                //configure partials path properties
                pathBuilderConfig.setBaseURL('/'); 
                pathBuilderConfig.setBasePartialsPath('custom/assets/');
                $sceDelegateProvider.resourceUrlWhitelist(['self','http://#cgi.server_name#/**']);
            }]).constant('frontendPartialsPath','frontend/');
            
    </script>
      
</head>
<body role="document">

<header>
	<div class="container"></div>
</header>

<div class="container"> 
	<!--- body_container start --->
