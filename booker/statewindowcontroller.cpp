#include "statewindowcontroller.h"
#include <QDebug>
#include <QQmlComponent>

StateWindowController::StateWindowController(QQmlApplicationEngine *engine) : m_engine(engine)
{

}

void StateWindowController::startAddingEvent()
{
    emit signalSleep();
}

void StateWindowController::startReadingEvent()
{
    emit signalReadingStarted();
}

void StateWindowController::startSelectingEvent()
{
    emit signalSelectingStarted();
}

void StateWindowController::endAddingEvent()
{
    emit signalSleepStop();
}

void StateWindowController::startCardViewEvent()
{
    emit signalSleep();
}

void StateWindowController::endCardViewEvent()
{
    emit signalSleepStop();
}

void StateWindowController::startSettingsEvent()
{
    emit signalSleep();
}

void StateWindowController::endSettingsEvent()
{
    emit signalSleepStop();
}


void StateWindowController::openAddWindow()
{
    QQmlComponent component(m_engine, "qrc:/AddWindow.qml");
    if( component.status() == QQmlComponent::Status::Error )
        qDebug() << "Error:" << component.errorString();
    window = component.create();
}

void StateWindowController::openSettingsWindow()
{
    QQmlComponent component(m_engine, "qrc:/SettingsWindow.qml");
    if( component.status() == QQmlComponent::Status::Error )
        qDebug() << "Error:" << component.errorString();
    window = component.create();
}
