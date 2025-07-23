# 1. Сборка в отдельном этапе, чтобы финальный образ был пустой и минимальный
FROM crystallang/crystal:1.17.1-alpine AS builder
WORKDIR /app
COPY small_http_serv.cr .
# Обращаем внимание на опцию --static
RUN shards build --release --static --no-debug --progress=false || \
    crystal build --release --static small_http_serv.cr

# 2. Финальный "пустой" образ
FROM scratch
WORKDIR /app
# Только бинарь, никаких библиотек/зависимостей!
COPY --from=builder /app/small_http_serv /app/
EXPOSE 8080
CMD ["./small_http_serv"]

