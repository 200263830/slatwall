/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//controllers

//directives
import {SWCampaign} from "./components/swcampaign";
import {SWCampaignStats} from "./components/swcampaignstats";
import {SWCampaignActivityStats} from "./components/swcampaignactivitystats";
import {SWCampaignWizard} from "./components/swcampaignwizard";
import {SWCampaignWizardStep} from "./components/swcampaignwizardstep";
import {SWUpcomingActivity} from "./components/swupcomingactivity";
import {SWSchedule} from "./components/swschedule";
import {SWCampaignActivity} from "./components/swcampaignactivity";
import {SWCampaignActivityStatus} from "./components/swcampaignactivitystatus";
import {SWCreateFollowUp} from "./components/swcreatefollowup";
import {SWCreateCampaignList} from "./components/swcreatecampaignlist";

//models

var marketingautomationmodule = angular.module('marketingautomation',[coremodule.name])
        .config([()=>{

        }]).run([()=>{

        }])
//constants
        .constant('marketignAutomationPartialsPath','marketingautomation/components/')
//controllers

//directives
        .directive('swCampaign', SWCampaign.Factory())
        .directive('swCampaignStats', SWCampaignStats.Factory())
        .directive('swCampaignActivityStats', SWCampaignActivityStats.Factory())
        .directive('swCampaignWizard', SWCampaignWizard.Factory())
        .directive('swUpcomingActivity', SWUpcomingActivity.Factory())
        .directive('swCampaignWizardStep', SWCampaignWizardStep.Factory())
        .directive('swSchedule', SWSchedule.Factory())
        .directive('swCampaignActivity', SWCampaignActivity.Factory())
        .directive('swCampaignActivityStatus', SWCampaignActivityStatus.Factory())
        .directive('swCreateFollowUp', SWCreateFollowUp.Factory())
        .directive('swCreateCampaignList', SWCreateCampaignList.Factory())
    ;
export{
    marketingautomationmodule
};