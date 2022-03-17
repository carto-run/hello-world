ARG BUILDER_IMAGE=golang
ARG RUNTIME_IMAGE=gcr.io/distroless/static


FROM $BUILDER_IMAGE as builder

        WORKDIR /workspace

        COPY go.mod   go.mod
        COPY main.go  main.go

        RUN set -x && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on \
                go build -a -v \
                        -trimpath \
                        -tags osusergo,netgo,static_build \
                        -o app .


FROM $RUNTIME_IMAGE

        WORKDIR /
        COPY --chown=nonroot:nonroot --from=builder /workspace/app .
        USER nonroot:nonroot

        ENTRYPOINT ["/app"]
