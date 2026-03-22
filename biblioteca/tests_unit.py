
# Create your tests here.
from django.test import TestCase
from django.db.utils import IntegrityError
from .models import Book

class BookModelTest(TestCase):

    def setUp(self):
        """
        Setup: Creăm un obiect de bază pe care îl vom folosi în mai multe teste.
        Acesta se rulează înainte de fiecare metodă de test.
        """
        self.book = Book.objects.create(
            title="Micul Print",
            author="Antoine de Saint-Exupery",
            isbn="1234567890123",
            publish_year=1943
        )

    def test_book_creation(self):
        """Verificăm dacă obiectul a fost creat corect în baza de date."""
        self.assertTrue(isinstance(self.book, Book))
        self.assertEqual(self.book.title, "Micul Print")

    def test_str_representation(self):
        """Verificăm dacă metoda __str__ returnează titlul, așa cum am definit-o."""
        self.assertEqual(str(self.book), "Micul Print")

    def test_isbn_uniqueness(self):
        """
        Testăm constrângerea 'unique=True' pentru ISBN.
        Încercarea de a crea o a doua carte cu același ISBN trebuie să dea eroare.
        """
        with self.assertRaises(IntegrityError):
            Book.objects.create(
                title="Alta Carte",
                author="Alt Autor",
                isbn="1234567890123",  # Același ISBN ca în setUp
                publish_year=2024
            )

    def test_verbose_name(self):
        """Verificăm dacă etichetele (verbose_name) sunt setate corect."""
        field_label = self.book._meta.get_field('publish_year').verbose_name
        self.assertEqual(field_label, "An Apariție")
