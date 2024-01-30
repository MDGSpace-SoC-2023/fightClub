import json
from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import async_to_sync
from .models import Messages,Conversation,User

class ConversationConsumer(AsyncWebsocketConsumer):#each consumer instance has unique channel name multiple channels can be talked to via groups
    async def connect(self):
        print("connectedMYMAN")
        self.conv_id=self.scope["url_route"]["kwargs"]["conv_id"]#use group_id as conv id to ensure valid name as spaces not allowed
        await self.channel_layer.group_add(# all channel layer methods are async
            self.conv_id,self.channel_name
        )
        await self.accept()

    
    
    async def receive(self,text_data):
       print("receivedDATAAAA")
       
       data = json.loads(text_data)
       sender=data["sender"]
       
       message = data['message']
       await self.save_message(self.conv_id,sender,message)
       await self.channel_layer.group_send(#used to send events to groups
           self.conv_id,
           {"type":"chat.message","message":message,"sender":sender}  #type key corresponds to the method that is to be invoked on receiving said event upon replacings the '.'s with '_'
           )
       print ("YUPPPPP")
    
    async def chat_message(self,event):
        print("am getting called YAAAA")
       
        message=event["message"]
        sender=event["sender"]
        

        await self.send(text_data=json.dumps({"message":message,"sender":sender})) #must put await
        


    async def disconnect(self,close_code):
        self.channel_layer.group_discard(
            self.conv_id,self.channel_name
        )
        pass
    
    @database_sync_to_async
    def save_message(self,conv,sender,message):
        Messages.objects.create(
            group=Conversation.objects.get(group_id=conv),
            sender=User.objects.get(username=sender),
            message_data=message
        )
        print("done")
