# Generated by Django 5.0 on 2023-12-30 20:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('philanthrobid_app', '0008_alter_listing_user_alter_user_username'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='email',
            field=models.CharField(max_length=256, unique=True),
        ),
    ]
