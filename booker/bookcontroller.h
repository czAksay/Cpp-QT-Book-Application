#ifndef BOOKCONTROLLER_H
#define BOOKCONTROLLER_H

#include <QObject>
#include "bookmodel.h"
#include <fstream>
#include <unistd.h>

class BookController : public QObject
{
    Q_OBJECT
public:
    BookController(QObject *parent = Q_NULLPTR);
    ~BookController();

    Q_PROPERTY(BookModel* model READ model WRITE setModel NOTIFY onModelChanged)

    Q_INVOKABLE void add(QString name, int day, int month, int year, QString logo_fullpath, QString biography);
    Q_INVOKABLE void remove(int index);

    BookModel* model() const
    {
        return m_model;
    }

public slots:
    void setModel(BookModel* model)
    {
        if (m_model != model)
        {
            m_model = model;
            emit onModelChanged(m_model);
        }
    }

signals:
    void onModelChanged(BookModel* model);

private:
    BookModel* m_model;
};

#endif // BOOKCONTROLLER_H
