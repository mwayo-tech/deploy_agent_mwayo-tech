# Student Attendance Tracker Deployment Project

## Project Overview

This project automates the deployment and configuration of a Student Attendance Tracker system using a Bash shell script. The script creates the required directory structure, generates the necessary files, updates attendance thresholds, validates the environment, and handles interruptions gracefully through signal trapping.

## Repository Name

deploy_agent_mwayo-tech

## Files Included

* setup_project.sh
* attendance_checker.py
* assets.csv
* config.json
* reports.log
* README.md
* .gitignore

## Directory Structure Created

attendance_tracker_<suffix>/

├── attendance_checker.py

├── Helpers/

│   ├── assets.csv

│   └── config.json

└── reports/

```
└── reports.log
```

## How to Run the Script

1. Make the script executable:

```bash
chmod +x setup_project.sh
```

2. Run the script:

```bash
./setup_project.sh
```

3. Enter a project suffix when prompted.

Example:

```text
Enter project suffix: v1
```

The script will create:

```text
attendance_tracker_v1
```

## Configuration Updates

The script prompts the user to update attendance thresholds:

* Warning Threshold (default: 75)
* Failure Threshold (default: 50)

The values are updated automatically inside the generated config.json file using the sed command.

## Environment Validation

Before completion, the script performs a health check by:

* Verifying that Python 3 is installed using:

```bash
python3 --version
```

* Validating that all required files and folders were created successfully.

## Signal Handling and Archiving

The script uses the trap command to handle SIGINT (Ctrl+C).

If the user interrupts the script:

1. The current project directory is archived into a compressed file.
2. The incomplete project directory is removed.
3. A confirmation message is displayed.

### Testing the Archive Feature

Run:

```bash
./setup_project.sh
```

While the script is running, press:

```text
Ctrl + C
```

Expected result:

* Archive file created:

```text
attendance_tracker_<suffix>_archive.tar.gz
```

* Incomplete project directory removed.

## Technologies Used

* Bash Shell Scripting
* Linux Commands
* sed
* trap
* tar
* Python 3

## Author

Mwayo Tech

## Assignment Objectives Achieved

* Dynamic directory creation
* Automated file generation
* Configuration management using sed
* Environment validation
* Signal trapping and cleanup
* Archive generation
* Git version control integration
Project overview video link:
https://youtu.be/AuPbo8L2cyA
