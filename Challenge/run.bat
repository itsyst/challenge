@REM ## Batch Script (for Windows) 

@REM ## Batch Script (for Windows) 

@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:START
REM Ask whether to run the app locally or using Docker
echo Do you want to run the app locally or using Docker?
echo 1. Run locally
echo 2. Use Docker
set run_mode=

REM Loop until a valid option is entered
:RUN_MODE
set /p run_mode="Choose 1 or 2: "
if "%run_mode%"=="1" goto LOCAL
if "%run_mode%"=="2" goto DOCKER
echo Invalid choice. Please try again.
goto RUN_MODE

:LOCAL
echo Select a language to run locally:
echo 1. C# version
echo 2. Python version
echo 3. JavaScript version
set choice=

REM Loop until a valid option is entered
:LOCAL_CHOICE
set /p choice="Choose 1, 2, or 3: "
if "%choice%"=="1" (
    echo Running C# version...
    dotnet run "../artefakter"
    goto END
) else if "%choice%"=="2" (
    echo Running Python version...
    python challenge.py "../artefakter"
    goto END
) else if "%choice%"=="3" (
    echo Running JavaScript version...
    node challenge.js "../artefakter"
    goto END
) else (
    echo Invalid choice. Please try again.
    goto LOCAL_CHOICE
)

:DOCKER
echo Select a language for Docker:
echo 1. C# version
echo 2. Python version
echo 3. JavaScript version
set docker_choice=

REM Loop until a valid option is entered
:DOCKER_CHOICE
set /p docker_choice="Choose 1, 2, or 3: "
if "%docker_choice%"=="1" goto DOCKER_CSHARP
if "%docker_choice%"=="2" goto DOCKER_PYTHON
if "%docker_choice%"=="3" goto DOCKER_JAVASCRIPT
echo Invalid choice. Please try again.
goto DOCKER_CHOICE

:DOCKER_CSHARP
echo Do you want to:
echo B. Build the Docker image
echo P. Push the Docker image to Docker Hub
echo C. Use docker-compose to run the container
set action=

REM Loop until a valid action is entered
:DOCKER_CSHARP_ACTION
set /p action="Choose B, P, or C: "
if /I "%action%"=="B" (
    echo Building C# version Docker image...
    docker build -f Dockerfile.csharp -t itsyst/csharp-challenge .
    if ERRORLEVEL 1 (
        echo Failed to build the Docker image. Exiting.
        goto END
    )
    goto END
) else if /I "%action%"=="P" (
    echo Pushing C# version Docker image to Docker Hub...
    docker push itsyst/csharp-challenge
    if ERRORLEVEL 1 (
        echo Failed to push the Docker image. Exiting.
        goto END
    )
    goto END
) else if /I "%action%"=="C" (
    echo Running C# version in Docker using docker-compose...
    docker-compose up csharp-challenge
    if ERRORLEVEL 1 (
        echo Failed to run docker-compose. Exiting.
        goto END
    )
    goto END
) else (
    echo Invalid action. Please try again.
    goto DOCKER_CSHARP_ACTION
)

:DOCKER_PYTHON
echo Do you want to:
echo B. Build the Docker image
echo P. Push the Docker image to Docker Hub
echo C. Use docker-compose to run the container
set action=

REM Loop until a valid action is entered
:DOCKER_PYTHON_ACTION
set /p action="Choose B, P, or C: "
if /I "%action%"=="B" (
    echo Building Python version Docker image...
    docker build -f Dockerfile.python -t itsyst/python-challenge .
    if ERRORLEVEL 1 (
        echo Failed to build the Docker image. Exiting.
        goto END
    )
    goto END
) else if /I "%action%"=="P" (
    echo Pushing Python version Docker image to Docker Hub...
    docker push itsyst/python-challenge
    if ERRORLEVEL 1 (
        echo Failed to push the Docker image. Exiting.
        goto END
    )
    goto END
) else if /I "%action%"=="C" (
    echo Running Python version in Docker using docker-compose...
    docker-compose up python-challenge
    if ERRORLEVEL 1 (
        echo Failed to run docker-compose. Exiting.
        goto END
    )
    goto END
) else (
    echo Invalid action. Please try again.
    goto DOCKER_PYTHON_ACTION
)

:DOCKER_JAVASCRIPT
echo Do you want to:
echo B. Build the Docker image
echo P. Push the Docker image to Docker Hub
echo C. Use docker-compose to run the container
set action=

REM Loop until a valid action is entered
:DOCKER_JAVASCRIPT_ACTION
set /p action="Choose B, P, or C: "
if /I "%action%"=="B" (
    echo Building JavaScript version Docker image...
    docker build -f Dockerfile.javascript -t itsyst/javascript-challenge .
    if ERRORLEVEL 1 (
        echo Failed to build the Docker image. Exiting.
        goto END
    )
    goto END
) else if /I "%action%"=="P" (
    echo Pushing JavaScript version Docker image to Docker Hub...
    docker push itsyst/javascript-challenge
    if ERRORLEVEL 1 (
        echo Failed to push the Docker image. Exiting.
        goto END
    )
    goto END
) else if /I "%action%"=="C" (
    echo Running JavaScript version in Docker using docker-compose...
    docker-compose up javascript-challenge
    if ERRORLEVEL 1 (
        echo Failed to run docker-compose. Exiting.
        goto END
    )
    goto END
) else (
    echo Invalid action. Please try again.
    goto DOCKER_JAVASCRIPT_ACTION
)

:END
echo Exiting the script.
ENDLOCAL
exit /b


@REM ## execute it in the terminal:
@REM ## .\run.bat
