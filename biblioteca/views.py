from django.shortcuts import render
from .models import Book

# Create your views here.
def lista_carti(request):
    carti = Book.objects.all() # Extrage tot din MariaDB
    return render(request, 'biblioteca/lista.html', {'carti': carti})