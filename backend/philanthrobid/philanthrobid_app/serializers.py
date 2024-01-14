from rest_framework import serializers
from .models import User, Listing, Bidder

# Update serializers as and when models.py is changed
#Changed to ModelSerializer



class ListingSerializer(serializers.ModelSerializer):
    #def update(self, instance, validated_data):
     #instance.bidding_user=validated_data.get("username")
     #instance.save()
     #return instance
    
    
    class Meta:
        model = Listing
        fields = ["list_id","user", "title", "description", "bid","mininc","strtbid","created_at","bidding_user","is_active"]
        #depth=1

class BidderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bidder
        
        fields = ["user", "money_spent","username"]
class UserSerializer(serializers.ModelSerializer):
    #user_who_post=ListingSerializer(many=True)
    #user_who_bid=ListingSerializer(many=True)
    class Meta:
        model = User
        fields = ["id","username", "email"]
        depth=1#"user_who_post","user_who_bid"]"name",]

