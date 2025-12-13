from backend.urls import router
from orana.views import *

router.register('constants', ConstantsViewSet, basename='constants')
router.register('fixed_costs', FixedCostsViewSet, basename='fixed_costs')
router.register('ingredients', IngredientsViewSet, basename='ingredients')
router.register('menu', MenuViewSet, basename='menu')

urlpatterns = [

]