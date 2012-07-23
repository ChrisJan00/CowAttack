#ifndef SOUNDCLIP_H
#define SOUNDCLIP_H

#include <QString>
#include <QUrl>
#include <QObject>

class SoundClipPrivate;
class MusicClipPrivate;

class MixerInstance {
public:
    explicit MixerInstance();
    ~MixerInstance();
    bool isValid() const;
private:
    bool valid;
};

class SoundClip : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
public:
    explicit SoundClip(QObject *parent = 0);
    ~SoundClip();

    QString source() const;
    void setSource(const QString &newSource);
    bool playing() const;

    Q_INVOKABLE void play();
    Q_INVOKABLE void stop();

signals:
    void sourceChanged();
    void playingChanged();

private:
    SoundClipPrivate *d;
};

class MusicClip : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
    Q_PROPERTY(int loops READ loops WRITE setLoops NOTIFY loopsChanged)
    Q_PROPERTY(int fadeInTime READ fadeInTime WRITE setFadeInTime NOTIFY fadeInTimeChanged)
public:
    explicit MusicClip(QObject *parent = 0);
    ~MusicClip();

    QString source() const;
    void setSource(const QString &newSource);
    bool playing() const;
    int loops() const;
    void setLoops(int loops);
    int fadeInTime() const;
    void setFadeInTime(int ms);

    // used internally
    void notifyFinish();

    Q_INVOKABLE void play();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void enqueue();
    Q_INVOKABLE void fadeOut(int ms);

signals:
    void sourceChanged();
    void playingChanged();
    void loopsChanged();
    void fadeInTimeChanged();

private:
    MusicClipPrivate *d;
};

#endif // SOUNDCLIP_H
