#include "bookcontroller.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>

BookController::BookController(QObject *parent) : QObject(parent)
{
    m_model = new BookModel();
}

BookController::~BookController()
{
    delete m_model;
}

void BookController::add(QString name, int day, int month, int year, QString logo_fullpath, QString biography)
{
    QList<QString> files = m_model->manageFiles(name, logo_fullpath, biography);
    if (files.length() >= 2)
        m_model->addAndWrite(name, day, month, year, files.at(0), files.at(1));
}

void BookController::remove(int index)
{
    m_model->remove(index);
}
