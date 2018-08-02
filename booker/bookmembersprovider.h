#ifndef BOOKMEMBERSPROVIDER_H
#define BOOKMEMBERSPROVIDER_H

#include <QObject>
#include <QThreadPool>
#include <QQuickAsyncImageProvider>
#include "bookmembersresponse.h"

class BookMembersProvider : public QQuickAsyncImageProvider
{
private:
    QThreadPool pool;   //Reserves a thread and uses it to run runnable

public:
    BookMembersProvider();
    QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requestedSize) override
    {
        BookMembersResponse *response = new BookMembersResponse(id, requestedSize);
        pool.start(response);
        return response;
    }
};

#endif // BOOKMEMBERSPROVIDER_H
