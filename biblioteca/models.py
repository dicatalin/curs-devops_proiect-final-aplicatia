from django.db import models

# Create your models here.
class Book(models.Model):
    title = models.CharField(max_length=200, verbose_name="Titlu")
    author = models.CharField(max_length=100, verbose_name="Autor")
    isbn = models.CharField(max_length=13, unique=True, verbose_name="ISBN")
    publish_year = models.IntegerField(verbose_name="An Apariție")

    def __str__(self):
        return self.title