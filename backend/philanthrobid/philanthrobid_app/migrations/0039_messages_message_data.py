# Generated by Django 5.0 on 2024-01-25 19:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('philanthrobid_app', '0038_conversation_messages'),
    ]

    operations = [
        migrations.AddField(
            model_name='messages',
            name='message_data',
            field=models.CharField(default='hi', max_length=1024),
            preserve_default=False,
        ),
    ]
