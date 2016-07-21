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
component displayname="CampaignActivity" entityname="SlatwallCampaignActivity" table="SwCampaignActivity" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_permission="this" hb_parentPropertyName="parentCampaignActivity" hb_childPropertyName="childCampaignActivities"{

	// Persistent Properties
	property name="campaignActivityID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="campaignActivityIDPath" ormtype="string" length="4000";
	property name="campaignActivityName" ormtype="string";
	property name="campaignActivityDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="collectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json";

	property name="emailSubject" ormtype="string";
	property name="emailFromName" ormtype="string";
	property name="emailFromEmail" ormtype="string";
	property name="emailReplyTo" ormtype="string";
	property name="emailStyle" ormtype="string";
	property name="emailBodyHTML" ormtype="string" hb_auditable="false";
	property name="emailBodyText" ormtype="string" hb_auditable="false";
	property name="emailSendDateTime" ormtype="timestamp";

	property name="send24EmailID" ormtype="string";
	property name="send24BroadcastID" ormType="string";


	// Related Object Properties (many-to-one)
	property name="campaign" cfc="Campaign" fieldtype="many-to-one" fkcolumn="campaignID";
	property name="parentCampaignActivity" cfc="CampaignActivity" fieldtype="many-to-one" fkcolumn="parentCampaignActivityID";

	// Related Object Properties (one-to-many)
	property name="childCampaignActivities" singularname="childCampaignActivity" cfc="CampaignActivity" type="array" fieldtype="one-to-many" fkcolumn="parentCampaignActivityID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote properties
	property name="remoteID" ormtype="string" hint="Only used when integrated with a remote system";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties


	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
