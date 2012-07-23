#include "soundclip.h"
#include <QDebug>

#include <QDir>

// Using SDL because I've got weird problems with QtMultimedia
#include <SDL/SDL.h>
#ifdef __APPLE__
    #include <SDL_mixer/SDL_mixer.h>
#else
    #include <SDL/SDL_mixer.h>
#endif

void musicFinished();

QString unpacked(QString filename)
{
    QString to = QDir::tempPath() + filename.mid(filename.lastIndexOf('/'));
    // already there?
    if (QFile(to).exists())
        return to;

    // copy to tmp folder
    QString from = QString(":/") + filename;
    if (QFile(from).exists()) {
        QFile::copy(from, to);
        return to;
    }
    return QString();
}

// Mixer Instance
bool StartMixer() {
    if (SDL_Init(SDL_INIT_AUDIO) != 0) {
        qDebug() << "Unable to initialize SDL:" << SDL_GetError();
        return false;
    }
    int audio_rate = 44100;
    Uint16 audio_format = AUDIO_S16SYS;
    int audio_channels = 2;
    int audio_buffers = 4096;

    if(Mix_OpenAudio(audio_rate, audio_format, audio_channels, audio_buffers) != 0) {
        qDebug() << "Unable to initialize audio:" << Mix_GetError();
        return false;
    }

    Mix_HookMusicFinished(musicFinished);
    return true;
}

void CloseMixer() {
    Mix_CloseAudio();
    SDL_Quit();
}

MixerInstance::MixerInstance()
{
    valid = StartMixer();
}

MixerInstance::~MixerInstance()
{
    if (valid) {
        CloseMixer();
    }
}

bool MixerInstance::isValid() const
{
    return valid;
}

///////////////////////////////////////////////////////////////////////////
// Sound Clip Object
class SoundClipPrivate {
public:
    QString fileName;
    Mix_Chunk *sound;
    int channel;
};

SoundClip::SoundClip(QObject *parent) : QObject(parent)
{
    d = new SoundClipPrivate;
    d->sound = 0;
    d->channel = -1;
}

SoundClip::~SoundClip()
{
    stop();
    if (d->sound) {
        Mix_FreeChunk(d->sound);
    }
    delete d;
}

QString SoundClip::source() const
{
    return d->fileName;
}

void SoundClip::setSource(const QString &newSource)
{
    if (playing())
        stop();

    if (source() != newSource) {
        if (d->sound) {
            Mix_FreeChunk(d->sound);
        }
        d->sound = Mix_LoadWAV(newSource.toLocal8Bit().data());
        if (!d->sound) {
            d->sound = Mix_LoadWAV(unpacked(newSource).toLocal8Bit().data());
            if(!d->sound) {
                qDebug() << "Unable to load WAV file" << newSource << ":" << Mix_GetError();
            }
        } else {
            d->fileName = newSource;
            emit sourceChanged();
        }
    }
}

bool SoundClip::playing() const
{
    return d->channel != -1 && Mix_Playing(d->channel);
}

void SoundClip::play()
{
    if (!d->sound)
        return;

    d->channel = Mix_PlayChannel(-1, d->sound, 0);
    if(d->channel == -1) {
        qDebug() << "Unable to play WAV file" << d->fileName << ":" << Mix_GetError();
    }
}

void SoundClip::stop()
{
    // actually we should store a list of channels and track when they're done...
    if (d->channel != -1) {
        Mix_HaltChannel(d->channel);
        d->channel = -1;
    }
}

///////////////////////////////////////////////////////////////////////////
// Music Clip Object
class MusicClipPrivate {
public:
    QString fileName;
    Mix_Music *music;
    bool isPlaying;
    int loops;
    int fadeInTime;
};

struct MusicControl {
    QList <MusicClip *> allMusicInstances;
    QList <MusicClip *> musicQueue;
    int musicCount;
} musicControl;

void musicFinished() {
    foreach (MusicClip *clip, musicControl.allMusicInstances)
        clip->notifyFinish();

    if (musicControl.musicCount == 0 && !musicControl.musicQueue.isEmpty()) {
        MusicClip *nextSong = musicControl.musicQueue.first();
        musicControl.musicQueue.removeAt(0);
        nextSong->play();
    }
}


MusicClip::MusicClip(QObject *parent) : QObject(parent)
{
    d = new MusicClipPrivate;
    d->music = 0;
    d->isPlaying = false;
    d->loops = 0;
    d->fadeInTime = 0;
    musicControl.allMusicInstances.append(this);
}

MusicClip::~MusicClip()
{
    stop();
    if (d->music) {
        Mix_FreeMusic(d->music);
        d->music = 0;
    }
    musicControl.allMusicInstances.removeOne(this);
    musicControl.musicQueue.removeOne(this);
    delete d;
}

QString MusicClip::source() const
{
    return d->fileName;
}

void MusicClip::setSource(const QString &newSource)
{
    if (playing())
        stop();

    if (source() != newSource) {
        if (d->music) {
            Mix_FreeMusic(d->music);
        }
        d->music = Mix_LoadMUS(newSource.toLocal8Bit().data());
        if (!d->music) {
            d->music = Mix_LoadMUS(unpacked(newSource).toLocal8Bit().data());
            if(!d->music) {
                qDebug() << "Unable to load Music file:" << Mix_GetError();
            }
        } else {
            d->fileName = newSource;
            emit sourceChanged();
        }
    }
}

int MusicClip::loops() const
{
    return d->loops;
}

void MusicClip::setLoops(int loops)
{
    if (d->loops != loops) {
        d->loops = loops;
        emit loopsChanged();
    }
}

int MusicClip::fadeInTime() const
{
    return d->fadeInTime;
}

void MusicClip::setFadeInTime(int ms)
{
    if (d->fadeInTime != ms) {
        d->fadeInTime = ms;
        emit fadeInTimeChanged();
    }
}

void MusicClip::notifyFinish()
{
    if (d->isPlaying) {
        d->isPlaying = false;
        musicControl.musicCount--;
        emit playingChanged();
    }
}
bool MusicClip::playing() const
{
    return d->isPlaying;
}

void MusicClip::play()
{
    if (!d->music)
        return;
    if (Mix_FadeInMusic(d->music, d->loops, d->fadeInTime) == -1) {
        qDebug() << "Unable to play Music file:" << Mix_GetError();
        return;
    }
    d->isPlaying = true;
    musicControl.musicCount++;
}

void MusicClip::stop()
{
    if (d->isPlaying) {
        Mix_HaltMusic();
        musicFinished();
    }
}

void MusicClip::enqueue()
{
    if (musicControl.musicCount == 0)
        play();
    else
        musicControl.musicQueue.append(this);
}

void MusicClip::fadeOut(int ms)
{
    if (d->isPlaying)
        Mix_FadeOutMusic(ms);
}

