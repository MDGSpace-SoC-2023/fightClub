import stripe
import datetime
import os
import pandas as pd
import numpy as np
from django.utils import timezone
from .models import User, Listing, Bidder,Charities, Tag,Conversation,Messages
from .serializers import UserSerializer, ListingSerializer, BidderSerializer,CustomListingSerializer,ConversationSerializer,MessageSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from django.db.models import Q,F
from rest_framework import generics
from rest_framework import status
from dotenv import load_dotenv
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.pagination import PageNumberPagination
import pendulum

load_dotenv()
list=[]
list_user=[]
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
        list_user=request.data.get("tags")
        user_changed=User.objects.get(username=request.data.get("old_username"))
        user_changed.interactionCount=user_changed.interactionCount+request.data.get("interaction")#not using defined values liek 1 or 0 here allws patch to be used for multiple things and different interactionbs can be given different weightages
        user_changed.Dance=((user_changed.Dance)*(user_changed.interactionCount-request.data.get("interaction"))+list_user[1])/user_changed.interactionCount
        user_changed.E_Sports=((user_changed.E_Sports)*(user_changed.interactionCount-request.data.get("interaction"))+list_user[0])/user_changed.interactionCount
        user_changed.Spiritual=((user_changed.Spiritual)*(user_changed.interactionCount-request.data.get("interaction"))+list_user[3])/user_changed.interactionCount
        user_changed.Sports=((user_changed.Sports)*(user_changed.interactionCount-request.data.get("interaction"))+list_user[2])/user_changed.interactionCount
        user_changed.Education=((user_changed.Education)*(user_changed.interactionCount-request.data.get("interaction"))+list_user[5])/user_changed.interactionCount
        user_changed.Music=((user_changed.Music)*(user_changed.interactionCount-request.data.get("interaction"))+list_user[4])/user_changed.interactionCount
        user_changed.username=request.data.get("new_username",user_changed.username)#second one passed if no such field in data sent so basically passeswhat it already is
        user_changed.save()
        serializer = UserSerializer(user_changed)
        return Response(serializer.data)
    
class ListingPagination(PageNumberPagination):
    page_size=10
    page_size_query_param="page_size"#to override page size from frntend
    max_page_size=100 #doesnt give more than this even if requested

class ListingList(APIView,ListingPagination):
    

    def get(self, request):
        #days=days_to_end.value_from_object(obj:Listing)
        day=F("no_of_days")
        queryset=Listing.objects.filter(is_active=True,endDate__gte=timezone.now())
        result=self.paginate_queryset(queryset,request,view=self)#paginates data
        
        #pagination_class=ListingPagination
        #listings = Listing.objects.filter(is_active=True)#filter(id=request.Listing.id)
        serializer = ListingSerializer(result, many=True)
        
        return self.get_paginated_response(serializer.data)# formats and structures paginated data for response
        
    
    def patch(self,request):
        listing_bidded_on=Listing.objects.get(list_id=request.data.get("list_id"))
        listing_bidded_on.bid=request.data.get("bid",0)
        listing_bidded_on.bidding_user=User.objects.get(username=request.data.get("username"))
        listing_bidded_on.save()
        serializer=ListingSerializer(listing_bidded_on)
        return Response(serializer.data)
        
    
    def post(self, request):
        
        list=request.data.get("tags")
        print(list)
        print(list[0])
        
        data = {
            "user":request.data.get("user"),           #When posting alisting we won't need a bid right?
            "title": request.data.get("title"),
            "description": request.data.get("description"),
            #"bid": request.data.get("bid"),
            "mininc":request.data.get("mininc"),
            "strtbid":request.data.get("strtbid"),
            "E_Sports":list[0],
            "Dance":list[1],
            "Sports":list[2],
            "Spiritual":list[3],
            "Music":list[4],
            "Education":list[5],
            "days_to_end":request.data.get("days_to_end"),
            "endDate":datetime.datetime.fromisoformat(request.data.get("endDate"))
            
        }
        serializer = ListingSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BidderList(APIView):

    def get(self, request):
        bidders = Bidder.objects.all().order_by("-money_spent")[:10]
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

        unpaidListings=Listing.objects.filter(endDate__lte=timezone.now(),is_active=True).exclude(bidding_user=None)
        serializer=ListingSerializer(unpaidListings,many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)

class SpecificUnpaidUser(APIView):
    def get(self,request):
        specificUnpaid=Listing.objects.filter(endDate__lte=timezone.now(),is_active=True,bidding_user=User.objects.get(username=request.GET.get("username")))
        if specificUnpaid.exists():
            serializer=ListingSerializer(specificUnpaid.first())
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)
    
class selectiveListing(generics.RetrieveAPIView): #to check if the lsiting has been paid for and to nav to home page

       queryset=Listing.objects.all()
       serializer_class=ListingSerializer

class getMessages(APIView):
    def get(self,request):
        messages=Messages.objects.filter(group=request.GET.get("group")).order_by("sent_at")
        if messages.exists():
            serializer=MessageSerializer(messages,many=True)
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)

class checkForConversations(APIView):
    def get(self,request):
        speciGroupList=Conversation.objects.filter(Q(winner=request.GET.get("username"))|Q(seller=request.GET.get("username")))
        if speciGroupList.exists():
            serializer=ConversationSerializer(speciGroupList,many=True)
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(status=status.HTTP_404_NOT_FOUND)



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
            metadata={"id":request.data.get("list_id"),"email":request.data.get("email")},
            
            
            transfer_data={
            "destination":Charities.objects.get(charId=request.data.get("chosenAccnt")).customer_ID,},
            

        )
        return Response(status=status.HTTP_201_CREATED,data=payment_intent)

class CustomList(APIView,ListingPagination):
    #why am I getting user_id ??
    #why asking for username slug field??
    
    #try to pagination
    #json probably wont work as such since basically forming columnwise instead of rowwise
    #orient=records
    #cuz to_field=username and is not sending a user anymore just a string
    def get(self,request):
        

        user_to_custom=User.objects.get(username=request.GET.get("username"))
        listings=Listing.objects.filter(is_active=True,endDate__gte=timezone.now())
        def user_custom_score(row):
            return 1/12*((row["E_Sports"]-float(user_to_custom.E_Sports))**2+(row["Dance"]-float(user_to_custom.Dance))**2+(row["Music"]-float(user_to_custom.Music))**2+(row["Spiritual"]-float(user_to_custom.Spiritual))**2+(row["Sports"]-float(user_to_custom.Sports))**2+(row["Education"]-float(user_to_custom.Education))**2)
        
        
        df=pd.DataFrame.from_records(listings.values())#values converts to a list of dictionaries
        df["user_score"]=df.apply(user_custom_score,axis=1)#tells to be done along column
        customListings=df.sort_values(by="user_score",ascending=True)
        customListings.drop("user_score",axis=1)
        customListings.rename(columns={"user_id":"user"},inplace=True)#changed here undo if need be
        #customListings["user"]=customListings.apply(make_a_dict,axis=1)
        #json=customListings.to_json()
        unpaginatedData=customListings.to_dict(orient="records")
        result=self.paginate_queryset(unpaginatedData,request,view=self)
        serializer=CustomListingSerializer(result,many=True)
        return self.get_paginated_response(serializer.data)



def changeStatus(list_id_sent,email_sent,money_sent):
    print(list_id_sent)
    print(email_sent)
    list=Listing.objects.get(list_id=list_id_sent)
    list.is_active=False
    list.save()
    user=User.objects.get(email=email_sent)

    username=user.username
    try:
        bid_maker=Bidder.objects.get(user=user)
    
        money=bid_maker.money_spent
        money=money+money_sent
        bid_maker.money_spent=money
        bid_maker.save()
        Conversation.objects.create(
            Listingtitle=list.title,
            winner=user,
            seller=list.user
        )
    except Bidder.DoesNotExist:
        Bidder.objects.create(user=user,money_spent=money_sent,username=username)

class searchListing(APIView,ListingPagination):
    def get(self,request):
    
        user_to_custom=User.objects.get(username=request.GET.get("username"))
        listings=Listing.objects.filter(is_active=True,endDate__gte=timezone.now(),title__icontains=request.GET.get("query"))#icontains is case insensitive
        if (len(listings.values())>=1):
         def user_custom_score(row):
            return 1/12*((row["E_Sports"]-float(user_to_custom.E_Sports))**2+(row["Dance"]-float(user_to_custom.Dance))**2+(row["Music"]-float(user_to_custom.Music))**2+(row["Spiritual"]-float(user_to_custom.Spiritual))**2+(row["Sports"]-float(user_to_custom.Sports))**2+(row["Education"]-float(user_to_custom.Education))**2)
        
        
         df=pd.DataFrame.from_records(listings.values())#values converts to a list of dictionaries
         df["user_score"]=df.apply(user_custom_score,axis=1)#tells to be done along column
         customListings=df.sort_values(by="user_score",ascending=True)
         customListings.drop("user_score",axis=1)
         customListings.rename(columns={"user_id":"user"},inplace=True)#changed here undo if need be
        #customListings["user"]=customListings.apply(make_a_dict,axis=1)
        #json=customListings.to_json()
         unpaginatedData=customListings.to_dict(orient="records")
         result=self.paginate_queryset(unpaginatedData,request,view=self)
         serializer=CustomListingSerializer(result,many=True)
         return self.get_paginated_response(serializer.data)
        return Response(status=status.HTTP_204_NO_CONTENT)


    

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
        email=payment_intent.metadata["email"]
        amount=payment_intent.amount
        amountac=amount/100
        changeStatus(list_id_sent=id,email_sent=email,money_sent=amountac)
    return HttpResponse(status=200)

"""def changeStatus(a,b,c):
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
    except Bidder.DoesNotExist:
        bid_guy=Bidder.objects.create(user=user,money_spent=c,username=username)"""
"""@csrf_exempt      
def checkUnpaid(request):
    if (request.method=="POST"):
        if Listing.objects.filter(created_at__lte=timezone.now()-datetime.timedelta(days=5),is_active=True,bidding_user=User.objects.get(username="try")).exists():
           return Response.render(self=status.HTTP_200_OK)
        else:
            return Response.render(self=status.HTTP_404_NOT_FOUND)"""

    

    
        


