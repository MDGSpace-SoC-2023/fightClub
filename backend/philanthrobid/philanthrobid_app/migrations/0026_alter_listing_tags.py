# Generated by Django 5.0 on 2024-01-19 11:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('philanthrobid_app', '0025_tag_listing_tags'),
    ]

    operations = [
        migrations.AlterField(
            model_name='listing',
            name='tags',
            field=models.ManyToManyField(blank=True, to='philanthrobid_app.tag'),
        ),
    ]