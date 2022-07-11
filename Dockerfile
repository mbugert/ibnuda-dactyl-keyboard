ARG BUILD_IMAGE=clojure:temurin-18-lein-alpine
ARG PROD_IMAGE=eclipse-temurin:18-jre-alpine

FROM $BUILD_IMAGE as build
WORKDIR /root
COPY project.clj /root/
RUN lein deps
COPY . /root
RUN mv "$(lein ring uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')" app.jar

FROM $PROD_IMAGE as prod
WORKDIR /root
COPY --from=build /root/app.jar /root
EXPOSE 3030
CMD ["java", "-jar", "app.jar"]
