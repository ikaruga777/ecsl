# ECSL (ECS Login)

A tool to generate commands for logging into ECS containers.

## Features

- Interactive selection of clusters, services, tasks, and containers
- Command generation for container login
- Incremental search for quick selection
- Efficient resource retrieval using AWS SDK

## Usage

```bash
ecsl -p your-profile [-f filter] [-r region]
```

### Options

- `-p, --profile PROFILE`: AWS profile name
- `-f, --filter FILTER`: Cluster name filter
- `-r, --region REGION`: AWS region

### Examples

```bash
# Basic usage
ecsl -p my-profile

# Filter by cluster name
ecsl -p my-profile -f production

# Specify region
ecsl -p my-profile -r us-west-2
```

## Workflow

1. Cluster Selection
   - Shows only clusters containing the filter string if specified
   - Auto-selects if only one cluster exists

2. Service Selection
   - Select from services in the chosen cluster
   - Auto-selects if only one service exists

3. Task Selection
   - Select from tasks in the chosen service
   - Auto-selects if only one task exists

4. Container Selection
   - Select from containers in the chosen task
   - Auto-selects if only one container exists

5. Command Generation
   - Displays the command to execute for the selected cluster, task, and container

## Notes

- This tool only generates commands and does not execute them
- Copy and execute the generated command manually
- AWS credentials must be configured in advance

## License

MIT
