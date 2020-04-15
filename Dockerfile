# -- Stage 1 - Use the build image for 2.2 sdk --
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 as build
ARG DOTNET_USE_POLLING_FILE_WATCHER=true
ENV DOTNET_RUNNING_IN_CONTAINER true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE true
#ARG ASPNETCORE_ENVIRONMENT=Development

WORKDIR /services

# Install Dependency Libraries
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated \
        libc6-dev \
        libgdiplus \
        libx11-dev \
        apt-transport-https \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/*
    
RUN wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
    && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
    && wget https://packages.microsoft.com/config/debian/9/prod.list \
    && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
    && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Install legacy dotnet 3.1 sdk
RUN apt-get update \
    && apt-get install dotnet-sdk-3.1

RUN dotnet new console -f netcoreapp3.1

RUN dotnet new console -f netcoreapp2.1 --force
