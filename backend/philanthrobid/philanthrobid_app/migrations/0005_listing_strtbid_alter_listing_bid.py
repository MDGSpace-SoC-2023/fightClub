# Generated by Django 5.0 on 2023-12-29 22:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('philanthrobid_app', '0004_listing_mininc'),
    ]

    operations = [
        migrations.AddField(
            model_name='listing',
            name='strtbid',
            field=models.IntegerField(default=0),
        ),
        migrations.AlterField(
            model_name='listing',
            name='bid',
            field=models.IntegerField(default=0),
        ),
    ]
