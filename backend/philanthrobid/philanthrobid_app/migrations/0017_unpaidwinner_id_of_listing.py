# Generated by Django 5.0 on 2024-01-09 18:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('philanthrobid_app', '0016_remove_unpaidwinner_id_of_listing'),
    ]

    operations = [
        migrations.AddField(
            model_name='unpaidwinner',
            name='id_of_listing',
            field=models.IntegerField(default=0, unique=True),
            preserve_default=False,
        ),
    ]