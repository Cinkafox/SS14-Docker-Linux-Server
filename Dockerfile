# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

ENV SS14_HOME=/ss14
ENV SS14_PUBLISH=${SS14_HOME}/publish

# Update and install necessary tools
RUN apt-get -y update && \
    apt-get -y install curl unzip wget && \
    rm -rf /var/lib/apt/lists/*  

# Download and build Watchdog
RUN wget https://github.com/space-wizards/SS14.Watchdog/archive/5f4735563302ce8163b8685440f411b8426367ed.zip -O Watchdog.zip && \
    unzip Watchdog.zip -d Watchdog && \
    cd Watchdog/SS14* && \
    dotnet publish -c Release -r linux-x64 --no-self-contained && \
    cp -rn SS14.Watchdog/bin/Release/net9.0/linux-x64/publish ${SS14_HOME}

WORKDIR ${SS14_HOME}

# Set the entry point for the container
ENTRYPOINT ["sh", "-c", "exec ./SS14.Watchdog \"$@\"", "--"]