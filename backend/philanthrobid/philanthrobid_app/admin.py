from django.contrib import admin
from .models import User, Listing, Bidder #maybe use * here?

admin.site.register(User)
admin.site.register(Listing)
admin.site.register(Bidder)