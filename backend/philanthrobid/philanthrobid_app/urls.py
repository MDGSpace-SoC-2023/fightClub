from django.urls import path, include
from .views import UserList, ListingList, BidderList

urlpatterns =[
    path("users", UserList.as_view()),
    path("listings", ListingList.as_view()),
    path("bidders", BidderList.as_view()),
]
