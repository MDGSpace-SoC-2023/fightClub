from rest_framework import serializers
from .models import User, Listing, Bidder

# Update serializers as and when models.py is changed

class UserSerializer(serializers.Serializer):
    class Meta:
        model = User
        fields = ["username", "email", "name",]

class ListingSerializer(serializers.Serializer):
    class Meta:
        model = Listing
        fields = ["user", "title", "description", "bid",]

class BidderSerializer(serializers.Serializer):
    class Meta:
        model = Bidder
        fields = ["user", "money_spent",]
