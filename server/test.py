import requests

url = 'http://127.0.0.1:5000/api/evaluate'
payload = {"toppings": ["smth1", "smth2"]}

response = requests.post(url, json=payload)
print(response.text)