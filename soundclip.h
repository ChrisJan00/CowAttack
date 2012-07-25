/***************************************************************************/
/* This file is part of Attack of the Cows from outer Space.               */
/*                                                                         */
/*    Attack of the Cows from outer Space is free software: you can        */
/*    redistribute it and/or modify it under the terms of the GNU General  */
/*    Public License as published by the Free Software Foundation, either  */
/*    version 3 of the License, or (at your option) any later version.     */
/*                                                                         */
/*    Attack of the Cows from outer Space is distributed in the hope that  */
/*    it will be useful, but WITHOUT ANY WARRANTY; without even the        */
/*    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      */
/*    PURPOSE.  See the GNU General Public License for more details.       */
/*                                                                         */
/*    You should have received a copy of the GNU General Public License    */
/*    along with Attack of the Cows from outer Space.  If not,             */
/*    see <http://www.gnu.org/licenses/>.                                  */
/***************************************************************************/

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
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
public:
    explicit SoundClip(QObject *parent = 0);
    ~SoundClip();

    QString source() const;
    void setSource(const QString &newSource);
    bool playing() const;
    int volume() const;
    void setVolume(int newVolume);

    Q_INVOKABLE void play();
    Q_INVOKABLE void stop();


signals:
    void sourceChanged();
    void playingChanged();
    void volumeChanged();

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
    Q_PROPERTY(bool repeating READ repeating WRITE setRepeating NOTIFY repeatingChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
public:
    explicit MusicClip(QObject *parent = 0);
    ~MusicClip();

    QString source() const;
    void setSource(const QString &newSource);
    bool playing() const;
    int loops() const;
    bool repeating() const;
    void setLoops(int loops);
    int fadeInTime() const;
    void setFadeInTime(int ms);
    void setRepeating(bool repeating);
    int volume() const;
    void setVolume(int newVolume);

    // used internally
    void notifyFinish();

    Q_INVOKABLE void play();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void enqueue();
    Q_INVOKABLE void unqueue();
    Q_INVOKABLE void fadeOut(int ms);

signals:
    void sourceChanged();
    void playingChanged();
    void loopsChanged();
    void fadeInTimeChanged();
    void repeatingChanged();
    void volumeChanged();

private:
    MusicClipPrivate *d;
};

#endif // SOUNDCLIP_H
