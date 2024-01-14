from django.contrib import admin
from .models import User, Listing, Bidder,Charities #maybe use * here?

admin.site.register(User)
admin.site.register(Listing)
admin.site.register(Bidder)
admin.site.register(Charities)