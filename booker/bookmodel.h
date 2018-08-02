#ifndef BOOKMODEL_H
#define BOOKMODEL_H

#include <QObject>
#include <QImage>
#include <QAbstractListModel>
#include <QMetaType>
#include <fstream>
#include <string>
#include <streambuf>
#include <sstream>

struct MyDate {
    int day;
    int month;
    int year;

    QString getStringDate()
    {
        return QString::number(day) + "." + QString::number(month) + "." + QString::number(year);
    }
};

struct BookMember {
    QString name;
    MyDate date_of_birth;
    QString logo_file;
    QString bio_file;
};

Q_DECLARE_METATYPE(MyDate)

class BookModel : public QAbstractListModel
{
    Q_OBJECT
public:
    BookModel(QObject *parent = Q_NULLPTR);

    enum Roles {
        NameRole = Qt::UserRole + 1,
        ImgRole,
        DateRole,
        BioRole
    };

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    virtual QModelIndex index(int row, int column, const QModelIndex &parent) const;
    virtual int columnCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const;

    void initialize();
    void add(BookMember member);
    void add(QString name, MyDate date, QString logo_file, QString bio_file);
    void addAndWrite(QString name, int day, int month, int year, QString logo_file, QString bio_file);
    QList<QString> manageFiles(QString name, QString logo_fullpath, QString biography);
    void remove(int index);
    void removeFromFile(int index);
    void removeBindedFiles(QString logo_file, QString bio_file);
    void setStrings();
    QList<QString> getBlocks(QString text);


private:
    QList<BookMember> m_data;
    QString member_file;
    QString start_tag;
    QString end_tag;
    QString bio_folder;
    QString logo_folder;
};

#endif // BOOKMODEL_H
