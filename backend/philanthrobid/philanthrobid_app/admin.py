from django.contrib import admin
from .models import User, Listing, Bidder,Charities,Tag,Conversation,   Messages #maybe use * here?

admin.site.register(User)
admin.site.register(Listing)
admin.site.register(Bidder)
admin.site.register(Charities)
admin.site.register(Tag)
admin.site.register(Conversation)
admin.site.register(Messages)
