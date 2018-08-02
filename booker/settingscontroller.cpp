#include "settingscontroller.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

SettingsController::SettingsController(QObject *parent) : QObject(parent)
{
    setData();
    initialize();
}

//получаем значение настройки по названию из файла по шаблону  alias: value
//к примеру,  fontsize: 15
int SettingsController::getValueByAlias(QString alias, QString text)
{
    int x = text.indexOf(alias + ":");
    if (x != -1)
    {
        x += alias.length() + 1;
        int y = text.indexOf("\n", x);
        if (y == -1)
            y = text.length();
        QStringRef sub(&text, x, y-x);
        return sub.toInt();
    }
}

//устанавливаем настройки из View и заменяем ими старые
void SettingsController::setSettings(int _fontSize, int _tileSize, int _rotateTiles)
{
    m_fontSize.setValue(_fontSize);
    m_tileSize.setValue(_tileSize);
    m_rotateTiles.setValue(_rotateTiles);
    replaceSettings();
    emit settingsChanged();
}

//заменяем файл настроек новым
void SettingsController::replaceSettings()
{
    QFile file(settings_file);
    if (!file.remove())
    {
        qDebug() << "Problems with replacing settings file.";
        return;
    }
    initialize();
}

//инициализация
void SettingsController::initialize()
{
    QFile file(settings_file);
    if(!file.open(QIODevice::ReadOnly))
    {
        file.close();
        createSettingsFile();
        file.open(QIODevice::ReadOnly);
    }
    QString text = file.readAll();
    while(text.indexOf(' ') != -1)
    {
        text.remove(text.indexOf(' '), 1);
    }
    m_fontSize.setValue(getValueByAlias(m_fontSize.alias, text));
    m_tileSize.setValue(getValueByAlias(m_tileSize.alias, text));
    m_rotateTiles.setValue(getValueByAlias(m_rotateTiles.alias, text));
}

//устанавливаем дефолтные данные и путь к настройкам
void SettingsController::setData()
{
    settings_file = "settings.txt";
    m_fontSize = {6, 12, 24, "fontsize"};
    m_tileSize = { 65, 95, 125, "tilesize"};
    m_rotateTiles = {0, 1, 1, "rotatetiles"};
}

//создаем чистый файл настроек и заносим в него их значения
bool SettingsController::createSettingsFile()
{
    QFile file(settings_file);
    if (!file.open(QIODevice::WriteOnly))
        return false;
    QTextStream fout(&file);
    fout << m_fontSize.alias << ": " << m_fontSize.value << "\n";
    fout << m_tileSize.alias << ": " << m_tileSize.value << "\n";
    fout << m_rotateTiles.alias << ": " << m_rotateTiles.value << "\n";
    file.close();
    return true;
}
