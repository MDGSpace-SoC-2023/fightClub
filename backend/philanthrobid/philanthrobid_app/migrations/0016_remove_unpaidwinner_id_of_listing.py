# Generated by Django 5.0 on 2024-01-09 09:09

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('philanthrobid_app', '0015_unpaidwinner_id_of_listing'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='unpaidwinner',
            name='id_of_listing',
        ),
    ]