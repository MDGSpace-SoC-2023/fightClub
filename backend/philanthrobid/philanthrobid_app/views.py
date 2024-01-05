from .models import User, Listing, Bidder
from .serializers import UserSerializer, ListingSerializer, BidderSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status



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
        listings = Listing.objects.all()#filter(id=request.Listing.id)
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
        bidders = Bidder.objects.all().order_by("money_spent")
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

