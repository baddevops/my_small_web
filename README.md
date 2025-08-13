# my_small_web
запуск
docker run -e PORT=8080 -p 8080:8080 scratch_mini_http_server 

использование:
curl -H "X-Forwarded-For: 1.2.3.4, 8.7.7.7, da hot bykvi peredavaj" http://localhost:8080 -d "мой запрос"

