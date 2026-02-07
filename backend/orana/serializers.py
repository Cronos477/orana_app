from rest_framework import serializers
from orana.models import *

class ConstantsSerializer(serializers.ModelSerializer):
    const_type_display = serializers.CharField(source="get_const_type_display", read_only=True)
    
    class Meta:
        model = Constants
        fields = ['id', 'name', 'description', 'value', 'const_type', 'const_type_display']

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
