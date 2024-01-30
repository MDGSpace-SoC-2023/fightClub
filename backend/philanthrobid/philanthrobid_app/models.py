import datetime
from django.db import models
from django.utils import timezone
# Update serializers.py and admin.py when a model is added, deleted or updated
#if changing tags remember to update both listing and user also the empty lists in add a listing and change username and in interaction on tap part
class User(models.Model):   #No need for name
    username = models.CharField(max_length=256,unique=True,)
    email = models.EmailField(max_length=256,unique=True)

    #name = models.CharField(max_length=256)
    E_Sports=models.DecimalField(default=0.25,max_digits=6,decimal_places=5)
    Dance=models.DecimalField(default=0.25,max_digits=6,decimal_places=5)
    Sports=models.DecimalField(default=0.25,max_digits=6,decimal_places=5)
    Spiritual=models.DecimalField(default=0.25,max_digits=6,decimal_places=5)
    Music=models.DecimalField(default=0.25,max_digits=6,decimal_places=5)
    Education=models.DecimalField(default=0.25,max_digits=6,decimal_places=5)
    interactionCount=models.IntegerField(default=1)
    def __str__(self):
        return self.username

class Tag(models.Model):
    tag_name=models.CharField(max_length=30,primary_key=True)

    def __str__(self):
        return self.tag_name


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
    #tags=models.ManyToManyField("Tag",blank=True)                                                    #related_name for reverse accessor
    is_active=models.BooleanField(default=True)
    E_Sports=models.IntegerField(default=0)
    Dance=models.IntegerField(default=0)
    Sports=models.IntegerField(default=0)
    Spiritual=models.IntegerField(default=0)
    Music=models.IntegerField(default=0)
    Education=models.IntegerField(default=0)
    days_to_end=models.PositiveIntegerField(default=5)
    endDate=models.DateTimeField(default=timezone.now()+datetime.timedelta(days=5))
   # time_end=created_at+datetime.timedelta(days=days_to_end.value_from_object(Listing))
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

class Conversation(models.Model):
    Listingtitle=models.CharField(max_length=256)
    group_id=models.AutoField(primary_key=True)
    winner=models.ForeignKey(User,to_field="username",on_delete=models.CASCADE,related_name="winner")
    seller=models.ForeignKey(User,to_field="username",on_delete=models.CASCADE,related_name="seller")
    created_at=models.DateTimeField(auto_now_add=True)

class Messages(models.Model):
    message_id=models.AutoField(primary_key=True)
    group=models.ForeignKey(Conversation,on_delete=models.CASCADE)
    sender=models.ForeignKey(User,on_delete=models.CASCADE,to_field="username")
    #receiver=models.ForeignKey(User,on_delete=models.CASCADE,to_field="username",related_name="receiver")
    sent_at=models.DateTimeField(auto_now_add=True)
    is_read=models.BooleanField(default=False)
    message_data=models.TextField()

    
    

