from django.db import models
from uuid_extensions import uuid7

class Constants(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid7,
        editable=False,
        unique=True
    )
    name = models.CharField(max_length=256, null=False, blank=False)
    description = models.TextField(null=True, blank=True)
    value = models.IntegerField(null=False, blank=False)

class FixedCosts(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default= uuid7,
        editable=False,
        unique=True
    )
    name = models.CharField(max_length=256, null=False, blank=False)
    description = models.TextField(null=True, blank=True)
    value = models.IntegerField(null=False, blank=False)

class Ingredients(models.Model):
    MEASUREMENT_UNITS = (
        ("g", "g"),
        ("ml", "ml"),
    )
    id = models.UUIDField(
        primary_key=True,
        default=uuid7,
        editable=False,
        unique=True
    )
    name = models.CharField(max_length=256, null=False, blank=False)
    description = models.TextField(null=True, blank=True)
    price = models.IntegerField(null=False, blank=False)
    value = models.IntegerField(null=False, blank=False)
    measurement_unit = models.CharField(max_length=2, choices=MEASUREMENT_UNITS, null=False, blank=False)

class Menu(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid7,
        editable=False,
        unique=True
    )
    name = models.CharField(max_length=256, null=False, blank=False)
    description = models.TextField(null=True, blank=True)
    ingredients = models.JSONField(default=list, blank=False, null=False)
    price = models.IntegerField(null=False, blank=False)
    units = models.IntegerField(null=False, blank=False)
