from django.urls import path, include
from .views import UserList, ListingList, BidderList,UnpaidUserListBackend,StripePaymentIntent,selectiveListing#my_webhook_view
from philanthrobid_app import views

urlpatterns =[
    path("users", UserList.as_view()),
    path("listings", ListingList.as_view()),
    path("bidders", BidderList.as_view()),
    path("UnpaidUserListBackend", UnpaidUserListBackend.as_view()),
    path("paymentIntent",StripePaymentIntent.as_view()),
    path("selectiveListing/<int:pk>",selectiveListing.as_view()),
    #path("webhook",my_webhook_view.as_view())
    path("stripe_webhook",views.my_webhook_view,name="stripe_webhook")
    
]
