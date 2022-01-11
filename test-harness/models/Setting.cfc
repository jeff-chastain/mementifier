/**
 * A Setting
 */
component 	persistent="true"
			table="settings"
			extends="BaseEntity"{


	/* *********************************************************************
	**						PROPERTIES
	********************************************************************* */

	property 	name="settingId"
				fieldtype="id"
				generator="uuid"
				length   ="36"
				ormtype="string";

	property 	name="name"
				notnull="true";

	property 	name="description"
				default=""
				notnull="false";

	property 	name="isConfirmed"
				ormtype="boolean"
				default="false"
				notnull="false";

	/* *********************************************************************
	**						STATIC PROPERTIES & CONSTRAINTS
	********************************************************************* */

	// pk
	this.pk = "settingId";

	// Mementofication Settings
	this.memento = {
		// Default properties to serialize
		defaultIncludes = [
			"name",
			"isConfirmed",
			"description"
		],
		// Default Exclusions
		defaultExcludes = [
		],
		neverInclude = [
		],
		// Defaults
		defaults = {
		}
	};

	/**
	 * Constructor
	 */
	function init(){
		super.init();
		return this;
	}

}
