## Bash Script (for Linux/macOS)
#!/bin/bash

# Function to build and push Docker images
build_and_push() {
    echo "Building Docker image..."
    docker build -t $1 .
    echo "Pushing Docker image to Docker Hub..."
    docker push $1
}

# Ask whether to run locally or use Docker
echo "Do you want to run the app locally or using Docker?"
echo "1. Run locally"
echo "2. Use Docker"
read -p "Choose 1 or 2: " run_mode

if [ "$run_mode" == "1" ]; then
    echo "Select a language to run locally:"
    echo "1. C# version"
    echo "2. Python version"
    echo "3. JavaScript version"
    read -p "Choose 1, 2, or 3: " choice

    if [ "$choice" == "1" ]; then
        echo "Running C# version..."
        dotnet run "../artefakter"
    elif [ "$choice" == "2" ]; then
        echo "Running Python version..."
        python3 challenge.py "../artefakter"
    elif [ "$choice" == "3" ]; then
        echo "Running JavaScript version..."
        node challenge.js "../artefakter"
    else
        echo "Invalid choice. Exiting."
    fi

elif [ "$run_mode" == "2" ]; then
    echo "Select a language for Docker:"
    echo "1. C# version"
    echo "2. Python version"
    echo "3. JavaScript version"
    read -p "Choose 1, 2, or 3: " docker_choice

    echo "Do you want to build and push the Docker image to Docker Hub?"
    read -p "Type 'build', 'push', or 'compose' for docker-compose: " action

    case $docker_choice in
        1)
            if [ "$action" == "build" ]; then
                echo "Building C# version Docker image..."
                docker build -f Dockerfile.csharp -t itsyst/csharp-challenge .
            elif [ "$action" == "push" ]; then
                echo "Pushing C# version Docker image to Docker Hub..."
                build_and_push itsyst/csharp-challenge
            elif [ "$action" == "compose" ]; then
                echo "Running C# version in Docker using docker-compose..."
                docker-compose up csharp-challenge
            else
                echo "Invalid action. Exiting."
            fi
            ;;
        2)
            if [ "$action" == "build" ]; then
                echo "Building Python version Docker image..."
                docker build -f Dockerfile.python -t itsyst/python-challenge .
            elif [ "$action" == "push" ]; then
                echo "Pushing Python version Docker image to Docker Hub..."
                build_and_push itsyst/python-challenge
            elif [ "$action" == "compose" ]; then
                echo "Running Python version in Docker using docker-compose..."
                docker-compose up python-challenge
            else
                echo "Invalid action. Exiting."
            fi
            ;;
        3)
            if [ "$action" == "build" ]; then
                echo "Building JavaScript version Docker image..."
                docker build -f Dockerfile.javascript -t itsyst/javascript-challenge .
            elif [ "$action" == "push" ]; then
                echo "Pushing JavaScript version Docker image to Docker Hub..."
                build_and_push itsyst/javascript-challenge
            elif [ "$action" == "compose" ]; then
                echo "Running JavaScript version in Docker using docker-compose..."
                docker-compose up javascript-challenge
            else
                echo "Invalid action. Exiting."
            fi
            ;;
        *)
            echo "Invalid Docker choice. Exiting."
            ;;
    esac
else
    echo "Invalid mode. Exiting."
fi

# execution permission to the shell script with:
# chmod +x run.sh

# execute it in the terminal:
# ./run.sh


 