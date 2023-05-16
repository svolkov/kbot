FROM quay.io/projectquay/golang:1.20 as builder
WORKDIR /go/src/app
COPY . .
ARG CONFIGURATION=linux
RUN make build_for_$CONFIGURATION

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
ENTRYPOINT ["./kbot","version"]