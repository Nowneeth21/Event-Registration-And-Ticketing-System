from django.contrib import admin
from django.urls import path, include

from django.conf import settings
from django.conf.urls.static import static
from django.urls import re_path
from django.views.static import serve
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('event.urls')), 
    path('api/', include('api.urls')),
    path('user/', include('user.urls')), 
    path('accounts/profile/', views.profile),
    path('prometheus/', include('django_prometheus.urls')),
]

urlpatterns += [
    re_path(r'^images/(?P<path>.*)$', serve, {'document_root': settings.MEDIA_ROOT}),
]
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
