from django.contrib import admin
from django.urls import path, include
from philanthrobid_app import urls

urlpatterns = [
    path("admin/", admin.site.urls),
    path("philanthrobid/", include(urls))
]
