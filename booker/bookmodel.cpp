#include "bookmodel.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QDir>


BookModel::BookModel(QObject *parent) : QAbstractListModel(parent)
{
    setStrings();
    initialize();
}

//установка всех нужных строк для путей и поиска в файлах
void BookModel::setStrings()
{
    member_file = "members.txt";
    start_tag = "[Person]";
    end_tag = "[end]";
    bio_folder = "bio/";
    logo_folder = "logo/";
}

QHash<int, QByteArray> BookModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[NameRole] = "mName";
    roles[ImgRole] = "mLogo";
    roles[DateRole] = "mDate";
    roles[BioRole] = "mBio";
    return roles;
}

//добавление в коллекцию
void BookModel::add(BookMember member)
{
    beginInsertRows(QModelIndex(), m_data.size(), m_data.size());
    m_data.append(member);
    endInsertRows();
}

void BookModel::add(QString name, MyDate date, QString logo_file, QString bio_file)
{
    BookMember adding = {name, date, logo_file, bio_file};
    add(adding);
}

//добавление в коллекцию и запись в файл конфигурации
void BookModel::addAndWrite(QString name, int day, int month, int year, QString logo_file, QString bio_file)
{
    MyDate date = {day, month, year};
    QFile file(member_file);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Append)) {
        qDebug() << "Members file doesn't exist and I can't create it.";
        return;
    }
    QTextStream fout(&file);
    fout << "\n"+start_tag+"\n";
    fout << name << "\n";
    fout << day << "." << month << "." << year << "\n";
    fout << logo_file << "\n";
    fout << bio_file << "\n";
    fout << end_tag + "\n";

    file.close();
    add(name, date, logo_file, bio_file);
}

//распределение файлов (фотографию скопировать в logo/ а текст в созданный файл в bio/)
QList<QString> BookModel::manageFiles(QString name, QString logo_fullpath, QString biography)
{
    setlocale(LC_ALL,"");   //?
    QList<QString> files_to_return;

    if (logo_fullpath.indexOf("file:///") == 0)
        logo_fullpath.remove(0, 8);
    QString logo_path = logo_fullpath;
    int x = logo_path.indexOf("/");
    //получаем просто имя файла для размещения его в своей директории
    while (x != -1)
    {
        logo_path.remove(0, x + 1);
        x = logo_path.indexOf("/");
    }

    QString logo_path_short = logo_path;
    logo_path.prepend(logo_folder);
    //проверяем существует ли указанный лого файл
    QFileInfo check_file(logo_fullpath);
    if ( !check_file.exists() || !check_file.isFile() )
    {
        qDebug() << "Src img file doesnt exist";
    }
    else
    {
        //проверяем существует ли уже целевой лого файл
        check_file.setFile(logo_path);
        if ( check_file.exists() && check_file.isFile() )
        {
            qDebug() << "Dest img file already exists";
        }
        else
        {
            QFile::copy(logo_fullpath, logo_path);
        }
    }

    QString bio_file_short = name + ".txt";
    QString bio_file = bio_folder + bio_file_short;
    //проверяем есть ли уже файл биографии
    check_file.setFile(bio_file);
    if ( check_file.exists() && check_file.isFile() )
    {
        qDebug() << "Dest bio file already exists";
    }
    else    //иначе создаем и записываем в него биографию
    {
        QFile file(bio_file);
        if (!file.open(QIODevice::WriteOnly))
        {
            qDebug() << "Can't create bio file";
        }
        else
        {
            QTextStream stream(&file);
            stream << biography;
            file.close();
        }
    }
    files_to_return.append(logo_path_short);
    files_to_return.append(bio_file_short);
    return files_to_return;
}

//удалить элемент из файла конфигурации
void BookModel::removeFromFile(int index)
{
    QFile file(member_file);
    if(!file.open(QIODevice::ReadOnly)) {
        qDebug() << "No members file";
        return;
    }
    QTextStream fin(&file);
    QString str = fin.readAll();
    file.close();
    QString name = m_data.at(index).name;
    removeBindedFiles(m_data.at(index).logo_file, m_data.at(index).bio_file);
    int x = str.indexOf(start_tag+"\n"+name);
    if (x == -1)
        return;
    int y = str.indexOf(end_tag, x);
    if (y == -1)
        return;
    str.remove(x, (y + 5 - x));

    file.setFileName(member_file);
    if(!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Members file doesn't exist and I can't create it.";
        return;
    }
    QTextStream stream(&file);
    stream << str;
    file.close();
}

//удалить связанные с элементов файлы (фото и текст)
void BookModel::removeBindedFiles(QString logo_file, QString bio_file)
{
    QFile file(logo_folder + logo_file);
    file.remove();
    file.setFileName(bio_folder+bio_file);
    file.remove();
    file.close();
}

//удаление из коллекции
void BookModel::remove(int index)
{
    if(!hasIndex(index,0))
    {
        return;
    }
    removeFromFile(index);
    beginRemoveRows(QModelIndex(),index, index);
    m_data.removeAt(index);
    endRemoveRows();
}

//вернуть блоки из файла конфигурации, по шаблону: [Person] ...данные... [end]
QList<QString> BookModel::getBlocks(QString text)
{
    QList<QString> blocks;
    int x,y;
    x = text.indexOf(start_tag);
    while (x != -1)
    {
        y = text.indexOf(end_tag);
        if (y == -1)
            break;
        int length = y - x + end_tag.length();
        QStringRef sub(&text, x, length);
        blocks.append(sub.toString());
        text.remove(x, length);
        x = text.indexOf(start_tag);
    }
    return blocks;
}

//инициализация
void BookModel::initialize()
{
    setlocale(LC_ALL,""); // ??

    if (!QDir(bio_folder).exists())
        QDir().mkdir(bio_folder);
    if (!QDir(logo_folder).exists())
        QDir().mkdir(logo_folder);

    QFile file(member_file);
    if(!file.open(QIODevice::ReadWrite)) {
        qDebug() << "Members file doesn't exist and I can't create it.";
        return;
    }
    QTextStream fin(&file);
    QString all_text = fin.readAll();
    QList<QString> blocks = getBlocks(all_text);
    file.close();
    foreach (QString block, blocks) {
        QStringList list = block.split('\n', QString::SkipEmptyParts);
        if (list.length() < 4)
            continue;
        QString name = list.at(1);
        QStringList l_tmp = list.at(2).split('.');
        int date[3];
        if (l_tmp.length() != 3)
        {
            for (int i = 0; i < 3; i ++ )
            {
                date[i] = 0;
            }
        }
        else
        {
            for (int i = 0; i < 3; i ++ )
            {
                date[i] = l_tmp[i].toInt();
            }
        }
        QString logo_file = list.at(3);
        QString bio_file = list.at(4);
        MyDate mdate = {date[0], date[1], date[2]};
        add(name, mdate, logo_file, bio_file);
    }
}

int BookModel::rowCount(const QModelIndex &parent) const
{
    return m_data.size();
}

//в зависимости от затребованной роли возвращаем поля структуры или данные из файла
QVariant BookModel::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case NameRole:
        return m_data.at(index.row()).name;
        break;
    case ImgRole:
        return logo_folder + m_data.at(index.row()).logo_file;
        break;
    case DateRole:
    {
        MyDate d = m_data.at(index.row()).date_of_birth;
        return d.getStringDate();
        break;
    }
    case BioRole:
    {
        QString bio_path = m_data.at(index.row()).bio_file;
        QFile file(bio_folder + bio_path);
        if(!file.open(QIODevice::ReadOnly)) {
            qDebug() << "cant find bio file";
            return QString("[Error]");
        }
        QTextStream fin(&file);
        return fin.readAll();
        break;
    }
    default:
        return m_data.at(index.row()).name;
        break;
    }
    return QVariant();
}

QModelIndex BookModel::index(int row, int column, const QModelIndex &parent) const
{
    return createIndex(row, column);
}

int BookModel::columnCount(const QModelIndex &parent) const
{
    return 1;
}
