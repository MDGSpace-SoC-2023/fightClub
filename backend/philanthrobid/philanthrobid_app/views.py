import stripe
import datetime
import os
from django.utils import timezone
from .models import User, Listing, Bidder,Charities
from .serializers import UserSerializer, ListingSerializer, BidderSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework import status
from dotenv import load_dotenv
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
load_dotenv()

stripe.api_key=os.environ["stripeSecretKey"]
endpoint_secret=os.environ["webhook_secret"]

class UserList(APIView):

    def get(self, request):
        users = User.objects.all()#filter(id=request.User.id).values()
        serializer = UserSerializer(users, many=True)
        
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    
    def post(self, request):
        data = {
            "username": request.data.get("username"),
            "email": request.data.get("email"),
            #"name": request.data.get("name"),
        }
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    def patch(self,request):
        user_changed=User.objects.get(username=request.data.get("old_username"))
        
        user_changed.username=request.data.get("new_username",user_changed.username)#second one passed if no such field in data sent so basically passeswhat it already is
        user_changed.save()
        serializer = UserSerializer(user_changed)
        return Response(serializer.data)

class ListingList(APIView):

    def get(self, request):
        listings = Listing.objects.filter(is_active=True)#filter(id=request.Listing.id)
        serializer = ListingSerializer(listings, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def patch(self,request):
        listing_bidded_on=Listing.objects.get(list_id=request.data.get("list_id"))
        listing_bidded_on.bid=request.data.get("bid",0)
        listing_bidded_on.bidding_user=User.objects.get(username=request.data.get("username"))
        listing_bidded_on.save()
        serializer=ListingSerializer(listing_bidded_on)
        return Response(serializer.data)
        
    
    def post(self, request):
        data = {
            "user":request.data.get("user"),           #When posting alisting we won't need a bid right?
            "title": request.data.get("title"),
            "description": request.data.get("description"),
            #"bid": request.data.get("bid"),
            "mininc":request.data.get("mininc"),
            "strtbid":request.data.get("strtbid"),
            
        }
        serializer = ListingSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BidderList(APIView):

    def get(self, request):
        bidders = Bidder.objects.order_by("-money_spent")[:10]
        serializer = BidderSerializer(bidders, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def post(self, request):
        data = {
            "money_spent": request.data.get("money_spent"),
        }
        serializer = BidderSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


        
class UnpaidUserListBackend(APIView):
    def get(self,request):
        unpaidListings=Listing.objects.filter(created_at__lte=timezone.now()-datetime.timedelta(days=5),is_active=True).exclude(bidding_user=None)
        serializer=ListingSerializer(unpaidListings,many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)
    
class selectiveListing(generics.RetrieveAPIView):

       queryset=Listing.objects.all()
       serializer_class=ListingSerializer


class StripePaymentIntent(APIView):
    def post(self,request):
        payment_intent=stripe.PaymentIntent.create(
            
            amount=Listing.objects.get(list_id=request.data.get("list_id")).bid*100,
            currency="inr",
            automatic_payment_methods={"enabled":True},
            receipt_email=request.data.get("email"),
            description="Philanthrobid donation.",
            ##address={
                #"city":"city",
                #"line1":"line1",
                #"line2":"line2"},
            metadata={"id":request.data.get("list_id")},
            
            
            transfer_data={
            "destination":Charities.objects.get(charId=request.data.get("chosenAccnt")).customer_ID,},
            

        )
        return Response(status=status.HTTP_201_CREATED,data=payment_intent)

@csrf_exempt
def my_webhook_view(request):
    print("webhook")
    payload=request.body
    sig_header=request.META.get("HTTP_STRIPE_SIGNATURE")
    event=None
    try:
        event=stripe.Webhook.construct_event(
            payload,sig_header,endpoint_secret
        )
    except ValueError as e:
        return HttpResponse(status=400)
    except stripe.error.SignatureVerificationError as e:
        return HttpResponse(status=400)
    
    if event["type"]=="payment_intent.succeeded":
        payment_intent=event.data.object
        id=payment_intent.metadata["id"]
        email=payment_intent.receipt_email
        amount=payment_intent.amount
        amountac=amount/100
        changeStatus(id,email,amountac)
    return HttpResponse(status=200)

def changeStatus(a,b,c):
    print(a)
    list=Listing.objects.get(list_id=a)
    list.is_active=False
    list.save()
    user=User.objects.get(email=b)
    username=user.username
    try:
        bid_maker=Bidder.objects.get(user=user)
    
        money=bid_maker.money_spent
        money=money+c
        bid_maker.money_spent=money
        bid_maker.save()
    except:
        bid_guy=Bidder.objects.create(user=user,money_spent=c,username=username)
        bid_guy.save()

    

    
        


