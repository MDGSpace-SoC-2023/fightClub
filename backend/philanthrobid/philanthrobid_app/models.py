import datetime
from django.db import models
from django.utils import timezone
# Update serializers.py and admin.py when a model is added, deleted or updated

class User(models.Model):   #No need for name
    username = models.CharField(max_length=256,unique=True,)
    email = models.EmailField(max_length=256,unique=True)
    #name = models.CharField(max_length=256)

    def __str__(self):
        return self.username


class Listing(models.Model):
    list_id=models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete = models.CASCADE,related_name="user_who_post",to_field="username")
    title = models.CharField(max_length=256)
    description = models.CharField(max_length=1024)
    bid = models.IntegerField(default=0)
    strtbid=models.IntegerField(default=0)
    mininc = models.IntegerField(default=0)
    created_at= models.DateTimeField(auto_now_add=True)
    bidding_user= models.ForeignKey(User,on_delete=models.SET_NULL,default=None,blank=True,null=True,related_name="user_who_bid",to_field="username") #blank allws it 2 pass null,null allows dbase 2 take null 
                                                        #related_name for reverse accessor
    is_active=models.BooleanField(default=True)
    def __str__(self):
        return self.title
    
    

class Bidder(models.Model):             
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    money_spent = models.IntegerField()
    username=models.CharField(max_length=100,blank=True,null=True)
    

    def __str__(self):
        return self.user.username
    
class Charities(models.Model):
    customer_ID=models.CharField(max_length=200,unique=True)
    charId=models.IntegerField(primary_key=True)