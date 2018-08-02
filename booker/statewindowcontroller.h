#ifndef STATEWINDOWCONTROLLER_H
#define STATEWINDOWCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

class StateWindowController : public QObject
{
    Q_OBJECT
private:
    QQmlApplicationEngine *m_engine;
    QObject *window;
public:
    StateWindowController(QQmlApplicationEngine *engine); //QObject *parent = Q_NULLPTR);
    Q_INVOKABLE void startAddingEvent();
    Q_INVOKABLE void startReadingEvent();
    Q_INVOKABLE void startSelectingEvent();
    Q_INVOKABLE void openAddWindow();
    Q_INVOKABLE void openSettingsWindow();
    Q_INVOKABLE void endAddingEvent();
    Q_INVOKABLE void startCardViewEvent();
    Q_INVOKABLE void endCardViewEvent();
    Q_INVOKABLE void startSettingsEvent();
    Q_INVOKABLE void endSettingsEvent();

signals:
    void signalSleep();
    void signalSelectingStarted();
    void signalReadingStarted();
    void signalSleepStop();
};

#endif // STATEWINDOWCONTROLLER_H
