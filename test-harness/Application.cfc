/**
 * *******************************************************************************
 * *******************************************************************************
 */
component {

	// UPDATE THE NAME OF THE MODULE IN TESTING BELOW
	request.MODULE_NAME = "mementifier";
	request.MODULE_PATH = "mementifier";

	// Application properties
	this.name              = hash( getCurrentTemplatePath() );
	this.sessionManagement = true;
	this.sessionTimeout    = createTimespan( 0, 0, 15, 0 );
	this.setClientCookies  = true;

	/**************************************
	 **************************************/
	// buffer the output of a tag/function body to output in case of a exception
	this.bufferOutput                   = true;
	// Activate Gzip Compression
	this.compression                    = false;
	// Turn on/off white space managemetn
	this.whiteSpaceManagement           = "smart";
	// Turn on/off remote cfc content whitespace
	this.suppressRemoteComponentContent = false;

	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING   = "";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE   = "";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY       = "";

	// Mappings
	this.mappings[ "/root" ]  = COLDBOX_APP_ROOT_PATH;
	this.mappings[ "/cborm" ] = COLDBOX_APP_ROOT_PATH & "/modules/cborm";

	// Map back to its root
	moduleRootPath = reReplaceNoCase(
		this.mappings[ "/root" ],
		"#request.MODULE_NAME#(\\|/)test-harness(\\|/)",
		""
	);
	modulePath = reReplaceNoCase(
		this.mappings[ "/root" ],
		"test-harness(\\|/)",
		""
	);

	// Module Root + Path Mappings
	this.mappings[ "/moduleroot" ]            = moduleRootPath;
	this.mappings[ "/#request.MODULE_NAME#" ] = modulePath;

	// ORM definitions: ENABLE IF NEEDED
	this.datasource = "mementifier";
	this.ormEnabled = "true";

	this.ormSettings = {
		cfclocation           : [ "models" ],
		logSQL                : true,
		dbcreate              : "update",
		dialect               : "org.hibernate.dialect.MySQL5InnoDBDialect",
		secondarycacheenabled : false,
		cacheProvider         : "ehcache",
		automanageSession     : false,
		flushAtRequestEnd     : false,
		eventhandling         : true,
		eventHandler          : "cborm.models.EventHandler",
		skipcfcWithError      : false
	};

	// applicationstop();abort;
	// ormReload();

	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new coldbox.system.Bootstrap(
			COLDBOX_CONFIG_FILE,
			COLDBOX_APP_ROOT_PATH,
			COLDBOX_APP_KEY,
			COLDBOX_APP_MAPPING
		);
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart( String targetPage ){
		if ( !structKeyExists( application, "cbBootstrap" ) ) {
			onApplicationStart();
		}

		if ( url.keyExists( "fwreinit" ) ) {
			if ( server.keyExists( "lucee" ) ) {
				pagePoolClear();
			}
			ormReload();
		}

		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );

		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection = arguments );
	}

	public boolean function onMissingTemplate( template ){
		return application.cbBootstrap.onMissingTemplate( argumentCollection = arguments );
	}

}
