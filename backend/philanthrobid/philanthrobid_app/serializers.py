from rest_framework import serializers
from .models import User, Listing, Bidder,Tag,Conversation,Messages

# Update serializers as and when models.py is changed
#Changed to ModelSerializer

class CustomListingSerializer(serializers.ModelSerializer):
    user=serializers.CharField()
    class Meta:
        model = Listing
        fields = ["list_id","user", "title", "description", "bid","mininc","strtbid","created_at","bidding_user","is_active","E_Sports","Dance","Sports","Spiritual","Music","Education","days_to_end","endDate"]

class ListingSerializer(serializers.ModelSerializer):
    #def update(self, instance, validated_data):
     #instance.bidding_user=validated_data.get("username")
     #instance.save()
     #return instance
    #chk if this breaks anything
    #maybe bcuz of this have to change from user as request.data.get("user")to user refrenced by username bcuz
    #user=serializers.CharField()
    
    #something else broke post a listing
    
    class Meta:
        model = Listing
        fields = ["list_id","user", "title", "description", "bid","mininc","strtbid","created_at","bidding_user","is_active","E_Sports","Dance","Sports","Spiritual","Music","Education","days_to_end","endDate"]
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
        fields = ["id","username", "email","E_Sports","Dance","Sports","Spiritual","Music","Education","interactionCount"]
        depth=1#"user_who_post","user_who_bid"]"name",]

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model=Tag
        fields=["tag_name"]

class ConversationSerializer(serializers.ModelSerializer):
    class Meta:
        model=Conversation
        fields=["group_id","winner","seller","created_at","Listingtitle"]
class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model=Messages
        fields=["message_id","group","sender","sent_at","is_read","message_data"]
