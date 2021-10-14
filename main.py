from flask import Flask
from requests import Request ,Session
import json
app = Flask(__name__)

@app.route('/')
def hello_world():
   answer = ""
   url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest'
   parameters = {
      'slug': 'bitcoin',
      'convert': 'USD'
   }
   headers = {
      'Accepts': 'application/json',  # i want a json format from the api
      'X-CMC_PRO_API_KEY': 'Your access key... ^_^'
   }
   session = Session()
   session.headers.update(headers)

   response = session.get(url, params=parameters)

   answer += "the price now is "
   answer +=str(json.loads(response.text)['data']['1']['quote']['USD']['price'])
   return answer
if __name__ == '__main__':
   app.run(host="0.0.0.0")
   