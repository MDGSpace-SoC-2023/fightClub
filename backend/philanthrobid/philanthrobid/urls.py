from django.contrib import admin
from django.urls import path, include
from philanthrobid_app import urls,views,routing


urlpatterns = [
    path("admin/", admin.site.urls),
    path("philanthrobid/", include(urls)),
   # path("ws/",include(routing.websocket_urlpatterns))

    
]
