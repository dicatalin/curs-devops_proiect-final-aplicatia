import unittest
import requests
# Importăm asta pentru a scăpa de mesajele de avertizare (InsecureRequestWarning) din consolă
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

class StagingLiveTest(unittest.TestCase):
    URL = "https://stage-host.home.local/"

    def test_api_and_ui_on_live_server(self):
        # Folosim verify=False pentru a ignora certificatul auto-semnat
        response = requests.get(self.URL, verify=False)
        
        print(f"\n[DEMO] Testare mediu LIVE la: {self.URL}")
        print(f"[DEMO] Status răspuns: {response.status_code}")
        
        # Verificăm dacă serverul e Online
        self.assertEqual(response.status_code, 200, "Serverul de Staging nu răspunde!")
        
        # UI Test: Verificăm dacă în HTML-ul primit există cuvinte cheie
        self.assertIn("Titlu", response.text, "Câmpul 'Titlu' nu a fost găsit în interfață!")
        self.assertIn("Autor", response.text, "Câmpul 'Autor' nu a fost găsit în interfață!")