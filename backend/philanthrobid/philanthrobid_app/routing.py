from django.urls import path
from . import consumers

websocket_urlpatterns=[
    path(r'ws/chat/conv_id=<conv_id>', consumers.ConversationConsumer.as_asgi()),
]
