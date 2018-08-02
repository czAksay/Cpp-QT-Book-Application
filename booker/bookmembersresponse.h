#ifndef BOOKMEMBERSRESPONSE_H
#define BOOKMEMBERSRESPONSE_H

#include <QImage>
#include <QThread>
#include <QQuickAsyncImageProvider>
#include <QNetworkReply>
#include <QEventLoop>
#include <QRunnable>
#include <QFile>
#include <sys/stat.h>
#include <string>

class BookMembersResponse : public QQuickImageResponse, public QRunnable
{
private:
    QNetworkAccessManager *manager;
    QString img_path;
    QSize img_requestedSize;
    QImage image;

public:
    BookMembersResponse(const QString &id, const QSize &requestedSize) : img_path(id), img_requestedSize(requestedSize)
    {
        manager = new QNetworkAccessManager();
        setAutoDelete(false);
    }

    QQuickTextureFactory *textureFactory() const override
    {
        return QQuickTextureFactory::textureFactoryForImage(image);
    }

    void run() override
    {
        image = QImage(50, 50, QImage::Format_RGB32);
        QUrl url;
        QFile file(img_path);
        if (!file.open(QIODevice::ReadOnly))
        {
            image = QImage(":/img/error.png");
        }
        else
        {
            image = QImage(img_path);
        }
        QThread::sleep(1);
        if (img_requestedSize.isValid())
            image = image.scaled(img_requestedSize);
        emit finished();
    }
};

#endif // BOOKMEMBERSRESPONSE_H
