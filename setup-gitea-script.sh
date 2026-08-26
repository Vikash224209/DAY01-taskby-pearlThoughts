#!/bin/bash


#Script to build and run Gitea locally without using docker.

#Author: Vikash Yadav

echo "========== Gitea Local Setup Automation Start =========="

echo "STEP 1: Checking project directory....."

if [ ! -f "go.mod" ] || [ ! -f "Makefile" ]; then
	echo "ERROR: This does not look like the the Gitea project folder"
	exit 1
fi

echo "OK - foung go.mod and Makefile, looks like the Gitea folder"


echo "STEP 2 : Checking Required Tools(go, node, pnpm, make, git)..." 

command -v go >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "ERROR: 'go' is not installed"
	exit 1
fi

command -v node >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "ERROR: 'node' is not installed"
	exit 1
fi

command -v pnpm >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "ERROR: 'pnpm' is not installed"
	exit 1
fi

command -v make >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "ERROR: 'make' is not installed"
	exit 1
fi

echo "All required tools are installed"


echo "Step 3: Showing installed version...."

echo "Go version:"
go --version
echo "make version:"
make --version
echo "pnpm version:"
pnpm --version
echo "node version:"
node --version
echo "git version:"
git --version


echo "Step 4 : Building Gitea from source. This may take a few minutes..."
make build

if [ $? -ne 0 ]; then 
	echo "ERROE: Build failed"
	exit 1
fi

echo "Build finished successfully"



echo "Step 5 : Check if the binary is created...."
if [ ! -f "gitea" ]; then
	echo "ERROE: gitea binary not found"
	exit 1
fi

echo "gitea binary found"


echo "Step 6: Checking the port 3000 is free...."

PORT_CHECK=$(lsof -i :3000 2>/dev/null)
if [ -n "$PORT_CHECK" ]; then
	echo "ERROR: Port 3000 is already in use"
	exit 1
fi

echo "Port 3000 is free"


echo "========== Starting Gitea server ==========="

./gitea web

