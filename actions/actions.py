import requests, json
import os
import re
import openai
import pyqrcode
from bs4 import BeautifulSoup
import urllib.request
import cloudinary.uploader
from youtube_search import YoutubeSearch
from os import scandir, getcwd
from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import AllSlotsReset
from rasa_sdk.types import DomainDict


class ActionDefaultFallback(Action):

    def name(self) -> Text:
        return "action_default_fallback"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        dispatcher.utter_message("Lo siento, no entendí lo que dijiste. ¿Podrías reformular tu pregunta o proporcionar más detalles? 😅")

        return []
    
class ActionClima(Action):

    def name(self):
        return 'action_clima'

    async def run(self, dispatcher, tracker, domain):
        api_key = "a3ecc6c0ecb33299fd09ebcbba6a76fb"
        base_url = "http://api.openweathermap.org/data/2.5/weather?"
        if tracker.get_slot("cciudad") is None:
            city_name="Bogota"
        else:
            city_name =tracker.get_slot("cciudad")
        complete_url = base_url + "appid=" + api_key + "&q=" + city_name
        response = requests.get(complete_url)

        x = response.json()
        if x["cod"] == 200:
            # En “main” se encuentra la informacion principal del estado del tiempo
            y = x["main"]
            temperatura= y["temp"]
            celcios=int(temperatura-273.15)
            atmosferica= y["pressure"]
            humedad= y["humidity"]
            men="El clima actual en {} es: {}°C, humedad del: {}, presión atmosférica {} 🌎".format(city_name,celcios, atmosferica, humedad)
            dispatcher.utter_message(men)
        else:
            dispatcher.utter_message(text="Tenemos un error actualmente, vuelva intentarlo más tarde dando el nombre de la ciudad 😅")
        return[]
    
class ActionDocumentos(Action):

    def name(self):
        return 'action_documentos'

    def run(self, dispatcher, tracker, domain):
        ruta ="assets"
        list =[arch.name for arch in scandir(ruta) if arch.is_file()]
        text ="\n".join(map(str, list))
        message= "{} \n\nSi quieres decargar algun archivo en especifico usar el comando Descargar 'Nombredelarchivo'.".format(text)
        dispatcher.utter_message(message)
        return[]
    
class ActionInfo(Action):

    def name(self):
        return 'action_info'

    async def run(self, dispatcher, tracker, domain):
        q=tracker.latest_message.get("text")
        try:
            openai.api_key = "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"
            response = openai.Completion.create(
                model="text-davinci-003",
                prompt=q,
                temperature=0.7,
                max_tokens=256,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0
            )
            choices = response.get("choices", [])
            if choices:
                first_choice = choices[0]
                text = first_choice.get("text", "")
                dispatcher.utter_message(text)
            else: 
                dispatcher.utter_message("algo salio mal... 😅")
        except:
            dispatcher.utter_message("algo salio mal... 😅")
        return[]
        
class ActionQR(Action):

    def name(self):
        return 'action_qr'

    async def run(self, dispatcher, tracker, domain):
        q=tracker.latest_message.get("text")
        urls = re.findall(r'\b(?:https?://|www\.)\S+\b', q)
        if not urls:
            dispatcher.utter_message('Dame el link del cual quieres tu codig QR 🤖')
        else:
            for url in urls:
                try:
                    cloudinary.config(
                        cloud_name = "dmfvi9zut",
                        api_key = "243967755551612",
                        api_secret = "mxmvMksX6kr4LbsAGLdIt0nJOug"
                    )
                    qr = pyqrcode.create(url)
                    qr.png('assets/codigo_qr.png', scale=8)
                    image_path = 'assets/codigo_qr.png'
                    response = cloudinary.uploader.upload(image_path)
                    img= response['secure_url']
                    dispatcher.utter_message(image=img, text="Este es el tu codigo QR 🫡")
                except:
                    dispatcher.utter_message("algo salio mal... 😅")
        return[]

class ActionEnlace(Action):

    def name(self):
        return 'action_enlace'

    async def run(self, dispatcher, tracker, domain):
        q=tracker.latest_message.get("text")
        urls = re.findall(r'\b(?:https?://|www\.)\S+\b', q)
        if not urls:
            dispatcher.utter_message('No logre detectar ninguna URL o LINK 😅')
        else: 
            for url in urls:
                try:
                    api_key = 'd44ad1fcd7f736464c2305669da8a293781a5245'
                    url = tracker.get_slot("url")
                    api_url = f'https://api-ssl.bitly.com/v4/bitlinks'
                    headers = {
                        'Authorization': f'Bearer {api_key}',
                        'Content-Type': 'application/json'
                    }
                    payload = {
                        'long_url': url
                    }
                    response = requests.post(api_url, headers=headers, json=payload)
                    if response.status_code == 200:
                        short_url = response.json()['link']
                        message ='{} esta es la URL cortada {}'.format(url,short_url)
                        dispatcher.utter_message(message)
                    else:
                        dispatcher.utter_message('No se pudo acortar la URL 😅'.format(url))
                except:
                    dispatcher.utter_message("algo salio mal... 😅")
                    break
        return[]
    
class ActionYoutube(Action):

    def name(self):
        return 'action_youtube'

    async def run(self, dispatcher, tracker, domain):
        try:
            q =tracker.latest_message.get("text")
            results = YoutubeSearch(q, max_results=10).to_dict()
            for result in results:
                title = result["title"]
                url_suffix = result["url_suffix"]
                url = "https://www.youtube.com{}".format(url_suffix)
                dispatcher.utter_message(f'\n{title} {url}')
            dispatcher.utter_message('\n\nEstos son los resultados que encontre para ti 🤖')
        except:
            dispatcher.utter_message("algo salio mal... 😅")
        return[]