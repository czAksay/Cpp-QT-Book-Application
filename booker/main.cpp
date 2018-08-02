#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "bookcontroller.h"
#include "bookmembersprovider.h"
#include "statewindowcontroller.h"
#include "settingscontroller.h"
#include <QTextCodec>

int main(int argc, char *argv[])
{
    QTextCodec* codec = QTextCodec::codecForName("ASCII");
    QTextCodec::setCodecForLocale(codec);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //для корректного отображения кириллицы в файлах

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //контроллер для модели
    QSharedPointer<BookController> ptr(new BookController());
    //контроллер для состояний главного окна при открытии других окон
    QSharedPointer<StateWindowController> ptr2(new StateWindowController(&engine));
    //контроллер настроек
    QSharedPointer<SettingsController> ptr3(new SettingsController(&engine));

    engine.rootContext()->setContextProperty("bookcontroller", ptr.data());
    engine.rootContext()->setContextProperty("statecontroller", ptr2.data());
    engine.rootContext()->setContextProperty("settingscontroller", ptr3.data());
    engine.addImageProvider(QStringLiteral("bookmembersprovider"), new BookMembersProvider());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    //engine.load(QUrl(QStringLiteral("qrc:/AddWindow.qml")));
    //engine.rootObjects().at(1)->setProperty("visible", false);
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
