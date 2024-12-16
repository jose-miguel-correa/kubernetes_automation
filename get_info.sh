#!/bin/bash

# Namespaces to process
NAMESPACES=("ms-mf" "nwp" "pu" "mobile" "internet" "ingfraude" "compartidoms" "billetera" )  # Add more namespaces as needed

# Resource types to process
RESOURCE_TYPES=("deployments" "secrets" "hpa" "services" "ingress" "cm")  # List of resources

# Base output directory
BASE_DIR="coquena_03"

# Iterate over each namespace
for NAMESPACE in "${NAMESPACES[@]}"; do
  echo "Processing namespace: $NAMESPACE"

  # Define namespace-specific directories
  NAMESPACE_DIR="${BASE_DIR}/${NAMESPACE}"
  mkdir -p "$NAMESPACE_DIR"

  # Iterate over each resource type
  for RESOURCE in "${RESOURCE_TYPES[@]}"; do
    echo "  - Exporting ${RESOURCE} for namespace: $NAMESPACE"

    # Define resource-specific directory
    RESOURCE_DIR="${NAMESPACE_DIR}/${RESOURCE}"
    mkdir -p "$RESOURCE_DIR"

    # Retrieve resource names and export YAML
for ITEM in $(kubectl get "$RESOURCE" -n "$NAMESPACE" -o custom-columns=":metadata.name" --no-headers 2>/dev/null); do
      echo "    - Saving ${RESOURCE}: $ITEM"
      kubectl get "$RESOURCE" "$ITEM" -n "$NAMESPACE" -o json > "${RESOURCE_DIR}/${ITEM}.json"
    done
  done

  echo "Finished processing namespace: $NAMESPACE"
done

echo "All namespaces processed. Exported resources saved in '${BASE_DIR}'"
