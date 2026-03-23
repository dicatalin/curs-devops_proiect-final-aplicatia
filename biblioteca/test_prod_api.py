import os
import unittest
import requests
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

class StagingLiveTest(unittest.TestCase):
    def setUp(self):
        # Citim variabilele trimise de Jenkins
        # Dacă rulăm local și nu le avem, punem niște default-uri
        self.host = os.getenv("TEST_HOST", "192.168.122.76")
        self.port = os.getenv("TEST_PORT", "8081") # default blue
        
        # Construim URL-ul către instanța specifică (Green)
        # Atenție: Folosim IP:Port pentru a ocoli Load Balancer-ul/Nginx dacă e nevoie
        self.url = f"http://{self.host}:{self.port}/"

    def test_api_and_ui_on_live_server(self):
        # Folosim Header-ul de 'Host' pentru ca Nginx/Django să știe ce site cerem
        # chiar dacă mergem direct pe IP și Port
        headers = {'Host': 'prod-host.home.local'}
        
        print(f"\n[SMOKE TEST] Testare mediu NOU (GREEN) la: {self.url}")
        response = requests.get(self.url, headers=headers, verify=False)
        
        print(f"[SMOKE TEST] Status răspuns: {response.status_code}")
        
        self.assertEqual(response.status_code, 200, f"Mediul Green ({self.url}) nu răspunde!")
        self.assertIn("Titlu", response.text)
        self.assertIn("Autor", response.text)