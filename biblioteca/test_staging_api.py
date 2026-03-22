import unittest
import requests

class StagingLiveTest(unittest.TestCase):
    URL = "https://stage-host.home.local/"

    def test_api_and_ui_on_live_server(self):
        # Trimitem request-ul către serverul care rulează deja
        response = requests.get(self.URL)
        
        print(f"\n[DEMO] Testare mediu LIVE la: {self.URL}")
        print(f"[DEMO] Status răspuns: {response.status_code}")
        
        # Verificăm dacă serverul e Online
        self.assertEqual(response.status_code, 200, "Serverul de Staging nu răspunde!")
        
        # UI Test: Verificăm dacă în HTML-ul primit există cuvinte cheie
        self.assertIn("Titlu", response.text, "Câmpul 'Titlu' nu a fost găsit în interfață!")
        self.assertIn("Autor", response.text, "Câmpul 'Autor' nu a fost găsit în interfață!")