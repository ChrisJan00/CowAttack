#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "soundclip.h"
#include <QtDeclarative>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    MixerInstance mI;
    if (!mI.isValid())
        return -1;

    qmlRegisterType<SoundClip>("SDLMixerWrapper",1,0,"SoundClip");
    qmlRegisterType<MusicClip>("SDLMixerWrapper",1,0,"MusicClip");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setSource(QUrl("qrc:/qml/cowAttack/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
