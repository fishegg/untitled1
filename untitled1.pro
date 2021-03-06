# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
QT += sql

TARGET = untitled1

CONFIG += sailfishapp

SOURCES += src/untitled1.cpp \
    src/databaseconnector.cpp \
    src/station.cpp \
    src/stationmodel.cpp \
    src/databasequery.cpp \
    src/routesearch.cpp \
    src/graphm.cpp

OTHER_FILES += qml/untitled1.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/untitled1.changes.in \
    rpm/untitled1.spec \
    rpm/untitled1.yaml \
    translations/*.ts \
    untitled1.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/untitled1-de.ts

DISTFILES += \
    qml/TestModel.qml \
    testdata/test.sqlite \
    qml/pages/StationsListDialog.qml \
    qml/components/RouteListViewDelegate.qml \
    qml/components/CoverListViewDelegate.qml \
    translations/untitled1-en.ts \
    qml/pages/InformationPage.qml \
    qml/pages/SettingDialog.qml

HEADERS += \
    src/databaseconnector.h \
    src/station.h \
    src/stationmodel.h \
    src/databasequery.h \
    src/routesearch.h \
    src/graphm.h

#database
db.path = /home/nemo/testdata
db.files += $$PWD/testdata/test.sqlite
INSTALLS += db

