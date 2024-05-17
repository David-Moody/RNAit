# Docker commands

## Build db_builder container

    docker build . -t harbor.peak.scot/public/rnait:db-builder --target=db-builder

## Create BLAST databases

    docker run -it --rm --mount type=bind,source=%cd%/fastas,target=/app/fastas --mount type=bind,source=%cd%/databases,target=/app/databases --mount type=bind,source=%cd%/app,target=/app harbor.peak.scot/public/rnait:db-builder

## Build final container

    docker build . -t harbor.peak.scot/public/rnait:latest --target=final --push

### NEW

## Build via compose

    docker compose build
    docker compose push
