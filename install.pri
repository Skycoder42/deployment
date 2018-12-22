# installing
isEmpty(PREFIX) {
	PREFIX = $$[QT_INSTALL_PREFIX]
	install_log: message("installing without prefix into Qt installation at: $$PREFIX")
	isEmpty(INSTALL_BINS): INSTALL_BINS = $$[QT_INSTALL_BINS]
	isEmpty(INSTALL_LIBS): INSTALL_LIBS = $$[QT_INSTALL_LIBS]
	isEmpty(INSTALL_HEADERS): INSTALL_HEADERS = $$[QT_INSTALL_HEADERS]
	isEmpty(INSTALL_PLUGINS): INSTALL_PLUGINS = $$[QT_INSTALL_PLUGINS]
	isEmpty(INSTALL_TRANSLATIONS): INSTALL_TRANSLATIONS = $$[QT_INSTALL_TRANSLATIONS]
	CONFIG += no_deploy_qt_qm
} else:!no_bundle_deploy {
	install_log: message("installing in deployment mode to prefix: $$PREFIX")
	mac:app_bundle {
		APP_PREFIX = $${PROJECT_NAME}.app/Contents
		isEmpty(INSTALL_APPS): INSTALL_APPS = $${PREFIX}/.app-tmp
		isEmpty(INSTALL_BINS): INSTALL_BINS = $${PREFIX}/$${APP_PREFIX}/MacOS
		isEmpty(INSTALL_LIBS): INSTALL_LIBS = $${PREFIX}/$${APP_PREFIX}/Frameworks
		isEmpty(INSTALL_HEADERS): INSTALL_HEADERS = $${PREFIX}/$${APP_PREFIX}/Headers
		isEmpty(INSTALL_PLUGINS): INSTALL_PLUGINS = $${PREFIX}/$${APP_PREFIX}/PlugIns
		isEmpty(INSTALL_TRANSLATIONS): INSTALL_TRANSLATIONS = $${PREFIX}/$${APP_PREFIX}/Resources/translations
		isEmpty(INSTALL_SHARE): INSTALL_SHARE = $${PREFIX}/$${APP_PREFIX}/Resources
	} else:win32 {
		isEmpty(INSTALL_BINS): INSTALL_BINS = $$PREFIX
		isEmpty(INSTALL_PLUGINS): INSTALL_PLUGINS = $$INSTALL_BINS
	} else:android {
		isEmpty(INSTALL_TRANSLATIONS): INSTALL_TRANSLATIONS = /assets/translations
	} else:flatpak_build {
		isEmpty(INSTALL_LIBS): INSTALL_LIBS = $${PREFIX}/lib
		isEmpty(INSTALL_PLUGINS): INSTALL_PLUGINS = $${INSTALL_LIBS}/plugins
	}
} else:install_log: message("installing in normal mode to prefix: $$PREFIX")

isEmpty(INSTALL_BINS): INSTALL_BINS = $${PREFIX}/bin
isEmpty(INSTALL_APPS): INSTALL_APPS = $$INSTALL_BINS
isEmpty(INSTALL_LIBS): INSTALL_LIBS = $${PREFIX}/lib
isEmpty(INSTALL_HEADERS): INSTALL_HEADERS = $${PREFIX}/include
isEmpty(INSTALL_PLUGINS): INSTALL_PLUGINS = $${PREFIX}/plugins
isEmpty(INSTALL_TRANSLATIONS): INSTALL_TRANSLATIONS = $${PREFIX}/translations
isEmpty(INSTALL_SHARE): INSTALL_SHARE = $${PREFIX}/share
isEmpty(INSTALL_PKGCONFIG): INSTALL_PKGCONFIG = $${INSTALL_LIBS}/pkgconfig
isEmpty(INSTALL_WWW): INSTALL_WWW = $${INSTALL_SHARE}/www

auto_lrelease: PRE_TARGETDEPS += lrelease
android: CONFIG += no_headers_install

CONFIG += deployment_install_pri_included
