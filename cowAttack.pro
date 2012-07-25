# Add more folders to ship with the application, here
#folder_01.source = qml/cowAttack
#folder_01.target = qml
#DEPLOYMENTFOLDERS = folder_01 folder_02

QT += declarative

macx {
  LIBS += -framework SDL
  LIBS += -framework SDL_mixer
}
win32 {
  LIBS += -L$$PWD/SDL/ -lSDL -lSDL_mixer
#  PRE_TARGETDEPS += $$PWD/SDL/SDL.lib $$PWD/SDL/SDL_mixer.lib
}

unix {
  LIBS += -lSDL -lSDL_mixer
}

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE258663B

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
#symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    soundclip.cpp

HEADERS += soundclip.h

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qml/cowAttack/main.qml \
    qml/cowAttack/Alien.qml \
    qml/cowAttack/AliensManager.qml \
    qml/cowAttack/Cow.qml \
    qml/cowAttack/Grass.qml \
    qml/cowAttack/Light.qml \
    qml/cowAttack/LoseScreen.qml \
    qml/cowAttack/Mothership.qml \
    qml/cowAttack/Scout.qml \
    qml/cowAttack/ScoutShadow.qml \
    qml/cowAttack/Sky.qml \
    qml/cowAttack/SpaceshipManager.qml \
    qml/cowAttack/WinScreen.qml

RESOURCES += \
    cowAttack.qrc
