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
            "name": request.data.get("name"),
        }
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ListingList(APIView):

    def get(self, request):
        listings = Listing.objects.all()#filter(id=request.Listing.id)
        serializer = ListingSerializer(listings, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def post(self, request):
        data = {
            "title": request.data.get("title"),
            "description": request.data.get("description"),
            "bid": request.data.get("bid"),
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

