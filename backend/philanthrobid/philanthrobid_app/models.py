from django.db import models

# Update serializers.py and admin.py when a model is added, deleted or updated

class User(models.Model):   #No need for name
    username = models.CharField(max_length=256)
    email = models.CharField(max_length=256)
    name = models.CharField(max_length=256)

    def __str__(self):
        return self.username


class Listing(models.Model):
    user = models.ForeignKey(User, on_delete = models.CASCADE)
    title = models.CharField(max_length=256)
    description = models.CharField(max_length=1024)
    bid = models.IntegerField()

    def __str__(self):
        return self.title


class Bidder(models.Model):             
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    money_spent = models.IntegerField()
    

    def __str__(self):
        return self.user.username