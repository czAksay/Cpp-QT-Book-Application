#ifndef SETTINGSCONTROLLER_H
#define SETTINGSCONTROLLER_H

#include <QObject>

struct SettingValue {
    Q_GADGET
public:
    Q_PROPERTY(int value MEMBER value)
    Q_PROPERTY(int maxValue MEMBER max_value)
    Q_PROPERTY(int minValue MEMBER min_value)
    SettingValue() : min_value(0), value(0), max_value(0), alias("none") {}
    SettingValue(int _min_value, int _value, int _max_value, QString _alias) : min_value(_min_value), value(_value), max_value(_max_value), alias(_alias) {}
    void setValue(int _value)
    {
        if (_value < min_value)
            value = min_value;
        else if (_value > max_value)
            value = max_value;
        else
            value = _value;
    }
    int min_value;
    int value;
    int max_value;
    QString alias;

signals:
};
Q_DECLARE_METATYPE(SettingValue)

class SettingsController : public QObject
{
    Q_OBJECT
public:
    SettingsController(QObject *parent = Q_NULLPTR);
    Q_PROPERTY(SettingValue fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(SettingValue tileSize READ tileSize WRITE setTileSize NOTIFY tileSizeChanged)
    Q_PROPERTY(SettingValue rotateTiles READ rotateTiles WRITE setRotateTiles NOTIFY rotateTilesChanged)

public:
    void initialize();
    void setData();
    bool createSettingsFile();
    int getValueByAlias(QString alias, QString text);

    SettingValue fontSize() const
    {
        return m_fontSize;
    }

    SettingValue tileSize() const
    {
        return m_tileSize;
    }

    SettingValue rotateTiles() const
    {
        return m_rotateTiles;
    }

    Q_INVOKABLE void setSettings(int _fontSize, int _tileSize, int _rotateTiles);
    void replaceSettings();

public slots:

    void setFontSize(SettingValue fontSize)
    {
        m_fontSize = fontSize;
        emit fontSizeChanged(m_fontSize);
    }

    void setTileSize(SettingValue tileSize)
    {
        m_tileSize = tileSize;
        emit tileSizeChanged(m_tileSize);
    }

    void setRotateTiles(SettingValue rotateTiles)
    {
        m_rotateTiles = rotateTiles;
        emit rotateTilesChanged(m_rotateTiles);
    }

signals:

    void fontSizeChanged(SettingValue fontSize);

    void tileSizeChanged(SettingValue tileSize);

    void rotateTilesChanged(SettingValue rotateTiles);

    void settingsChanged();

private:
    QString settings_file;
    SettingValue m_fontSize;
    SettingValue m_tileSize;
    SettingValue m_rotateTiles;
};

#endif // SETTINGSCONTROLLER_H
