from rest_framework import serializers
from orana.models import *

class ConstantsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Constants
        fields = '__all__'

class FixedCostsSerializer(serializers.ModelSerializer):
    class Meta:
        model = FixedCosts
        fields = '__all__'

class IngredientsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ingredients
        fields = '__all__'

class MenuSerializer(serializers.ModelSerializer):
    class Meta:
        model = Menu
        fields = '__all__'
