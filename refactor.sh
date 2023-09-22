#!/bin/sh

YESNOCASE () {
  while true; do
      read -p "Do you wish to continue? (y/n)" yn
      case $yn in
          [Yy]* ) break;;
          [Nn]* ) exit;;
          * ) echo "Please answer y or n.";;
      esac
  done
}

INCREMENT_STEP_COUNTER=0;
MAX_STEP_COUNT=2;
INCREMENT_STEP() {INCREMENT_STEP_COUNTER=$(($INCREMENT_STEP_COUNTER + 1)); echo Step $INCREMENT_STEP_COUNTER/$MAX_STEP_COUNT;}

echo Preparing to refactor project...
INCREMENT_STEP
echo This will overwrite gradle.properties!
YESNOCASE
echo

echo o DisplayName:
read projectName
projectName=${projectName:-SampleProject}
projectId=${projectName// /_}
projectId=${projectId,,}

echo o Author:
read projectAuthor
projectAuthor=${projectAuthor:-StoneTrench}
projectAuthor=${projectAuthor// /_}
projectAuthor=${projectAuthor,,}

echo o Description:
read projectDescription
projectDescription=${projectDescription:-...}

echo "version = 2.8.1_04-1.0
id = $projectId
name = $projectName
desc = $projectDescription
author = $projectAuthor
" > gradle.properties

echo
echo Preparing to create folders...
INCREMENT_STEP
echo This will delete preexisting folders corresponding to: main, client, server
echo
YESNOCASE
echo

# Main Portion
rm -rf ./src/main/java/
mkdir -p ./src/main/java/me/$projectAuthor/$projectId
echo "package me.$projectAuthor.$projectId;

import com.fox2code.foxloader.loader.Mod;

public class MainMod extends Mod {

    @Override
    public void onPreInit() {

    }
}
" > ./src/main/java/me/$projectAuthor/$projectId/MainMod.java

# Client Portion
rm -rf ./src/client/java/
mkdir -p ./src/client/java/me/$projectAuthor/$projectId
echo "package me.$projectAuthor.$projectId;

import com.fox2code.foxloader.loader.ClientMod;

public class ModClient extends MainMod implements ClientMod {
    @Override
    public void onInit() {
        // Client specific code

    }
}
" > ./src/client/java/me/$projectAuthor/$projectId/ModClient.java

# Server Portion
rm -rf ./src/server/java/
mkdir -p ./src/server/java/me/$projectAuthor/$projectId
echo "package me.$projectAuthor.$projectId;

import com.fox2code.foxloader.loader.ServerMod;

public class ModServer extends MainMod implements ServerMod {
    @Override
    public void onInit() {
        // Server specific code
    }
}

" > ./src/server/java/me/$projectAuthor/$projectId/ModServer.java

# Refactor main resources
rm -rf ./src/main/resources/assets/
mkdir -p ./src/main/resources/assets/$projectId/lang/
echo "
" > ./src/main/resources/assets/$projectId/lang/en_US.lang

echo Done.
read -p "Press any key to continue ..."
