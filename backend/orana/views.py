from rest_framework.authentication import TokenAuthentication
from rest_framework import viewsets
from orana.serializers import *
from orana.models import *

class ConstantsViewSet(viewsets.ModelViewSet):
    queryset = Constants.objects.all().order_by("id")
    serializer_class = ConstantsSerializer
    http_method_names = ['get', 'post', 'put', 'delete']

class FixedCostsViewSet(viewsets.ModelViewSet):
    queryset = FixedCosts.objects.all().order_by("id")
    serializer_class = FixedCostsSerializer
    http_method_names = ['get', 'post', 'put', 'delete']

class IngredientsViewSet(viewsets.ModelViewSet):
    queryset = Ingredients.objects.all().order_by("id")
    serializer_class = IngredientsSerializer
    http_method_names = ['get', 'post', 'put', 'delete']

class MenuViewSet(viewsets.ModelViewSet):
    queryset = Menu.objects.all().order_by("id")
    serializer_class = MenuSerializer
    http_method_names = ['get', 'post', 'put', 'delete']
