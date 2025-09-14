#!/bin/bash

# Image Signature Verification Script
# This script verifies container image signatures using Cosign

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
REGISTRY="ghcr.io"
REPOSITORY=""
TAG="latest"
VERBOSE=false

# Function to print usage
usage() {
    cat << EOF
Container Image Signature Verification Script

Usage: $0 [OPTIONS] REPOSITORY

OPTIONS:
    -r, --registry REGISTRY    Container registry (default: ghcr.io)
    -t, --tag TAG             Image tag to verify (default: latest)
    -v, --verbose             Enable verbose output
    -h, --help                Show this help message

EXAMPLES:
    $0 myorg/myapp
    $0 -r docker.io -t v1.2.3 myorg/myapp
    $0 --registry ghcr.io --tag latest myorg/web-app

REQUIREMENTS:
    - cosign (for signature verification)
    - docker or podman (for image inspection)

The script will verify:
    - Image signature using Cosign
    - SBOM attestation
    - Vulnerability attestation (if available)
EOF
}

# Function to check if required tools are installed
check_dependencies() {
    local missing_tools=()
    
    if ! command -v cosign >/dev/null 2>&1; then
        missing_tools+=("cosign")
    fi
    
    if ! command -v docker >/dev/null 2>&1 && ! command -v podman >/dev/null 2>&1; then
        missing_tools+=("docker or podman")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${RED}❌ Missing required tools:${NC}"
        for tool in "${missing_tools[@]}"; do
            echo "   - $tool"
        done
        echo ""
        echo "Please install the missing tools and try again."
        exit 1
    fi
}

# Function to verify image signature
verify_signature() {
    local image="$1"
    
    echo -e "${BLUE}🔍 Verifying signature for: ${image}${NC}"
    
    if cosign verify "$image" --output-file signature-verification.json 2>/dev/null; then
        echo -e "${GREEN}✅ Signature verification successful${NC}"
        
        if [ "$VERBOSE" = true ]; then
            echo -e "${YELLOW}Signature details:${NC}"
            jq '.[0] | {subject: .critical.identity.docker-reference, issuer: .optional.Issuer, timestamp: .optional.timestamp}' signature-verification.json 2>/dev/null || echo "Could not parse signature details"
        fi
        
        return 0
    else
        echo -e "${RED}❌ Signature verification failed${NC}"
        return 1
    fi
}

# Function to verify SBOM attestation
verify_sbom() {
    local image="$1"
    
    echo -e "${BLUE}🔍 Verifying SBOM attestation for: ${image}${NC}"
    
    if cosign verify-attestation "$image" --type spdxjson --output-file sbom-attestation.json 2>/dev/null; then
        echo -e "${GREEN}✅ SBOM attestation verification successful${NC}"
        
        if [ "$VERBOSE" = true ]; then
            echo -e "${YELLOW}SBOM summary:${NC}"
            jq -r '.payload | @base64d | fromjson | .predicate | "Packages: \(.packages | length), Creator: \(.creationInfo.creators[0])"' sbom-attestation.json 2>/dev/null || echo "Could not parse SBOM details"
        fi
        
        return 0
    else
        echo -e "${YELLOW}⚠️  SBOM attestation not found or verification failed${NC}"
        return 1
    fi
}

# Function to verify vulnerability attestation
verify_vulnerability_scan() {
    local image="$1"
    
    echo -e "${BLUE}🔍 Checking for vulnerability scan attestation: ${image}${NC}"
    
    if cosign verify-attestation "$image" --type vuln 2>/dev/null; then
        echo -e "${GREEN}✅ Vulnerability scan attestation found${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Vulnerability scan attestation not found${NC}"
        return 1
    fi
}

# Function to inspect image metadata
inspect_image() {
    local image="$1"
    
    echo -e "${BLUE}🔍 Inspecting image metadata: ${image}${NC}"
    
    # Try docker first, then podman
    local docker_cmd="docker"
    if ! command -v docker >/dev/null 2>&1; then
        docker_cmd="podman"
    fi
    
    if $docker_cmd manifest inspect "$image" > image-manifest.json 2>/dev/null; then
        echo -e "${GREEN}✅ Image manifest retrieved${NC}"
        
        if [ "$VERBOSE" = true ]; then
            echo -e "${YELLOW}Image details:${NC}"
            jq '{
                mediaType: .mediaType,
                architecture: .architecture // "multi-arch",
                os: .os // "linux",
                size: (.config.size // 0),
                layers: (.layers | length)
            }' image-manifest.json 2>/dev/null || echo "Could not parse manifest details"
        fi
        
        return 0
    else
        echo -e "${YELLOW}⚠️  Could not retrieve image manifest${NC}"
        return 1
    fi
}

# Function to generate verification report
generate_report() {
    local image="$1"
    local sig_result="$2"
    local sbom_result="$3"
    local vuln_result="$4"
    local manifest_result="$5"
    
    echo ""
    echo -e "${BLUE}📋 Verification Report for: ${image}${NC}"
    echo "=================================="
    
    echo -n "Signature Verification: "
    if [ "$sig_result" -eq 0 ]; then
        echo -e "${GREEN}✅ PASSED${NC}"
    else
        echo -e "${RED}❌ FAILED${NC}"
    fi
    
    echo -n "SBOM Attestation: "
    if [ "$sbom_result" -eq 0 ]; then
        echo -e "${GREEN}✅ VERIFIED${NC}"
    else
        echo -e "${YELLOW}⚠️  NOT FOUND${NC}"
    fi
    
    echo -n "Vulnerability Scan: "
    if [ "$vuln_result" -eq 0 ]; then
        echo -e "${GREEN}✅ VERIFIED${NC}"
    else
        echo -e "${YELLOW}⚠️  NOT FOUND${NC}"
    fi
    
    echo -n "Image Manifest: "
    if [ "$manifest_result" -eq 0 ]; then
        echo -e "${GREEN}✅ ACCESSIBLE${NC}"
    else
        echo -e "${YELLOW}⚠️  INACCESSIBLE${NC}"
    fi
    
    echo ""
    
    # Overall status
    if [ "$sig_result" -eq 0 ]; then
        echo -e "${GREEN}🎉 Overall Status: TRUSTED${NC}"
        echo "The image signature is valid and can be trusted."
    else
        echo -e "${RED}⚠️  Overall Status: UNTRUSTED${NC}"
        echo "The image signature could not be verified. Use with caution."
    fi
}

# Function to cleanup temporary files
cleanup() {
    rm -f signature-verification.json sbom-attestation.json image-manifest.json
}

# Main function
main() {
    local image="${REGISTRY}/${REPOSITORY}:${TAG}"
    
    echo -e "${BLUE}🔐 Container Image Security Verification${NC}"
    echo "========================================"
    echo "Image: $image"
    echo ""
    
    # Verify signature
    verify_signature "$image"
    local sig_result=$?
    
    # Verify SBOM
    verify_sbom "$image"
    local sbom_result=$?
    
    # Verify vulnerability scan
    verify_vulnerability_scan "$image"
    local vuln_result=$?
    
    # Inspect image
    inspect_image "$image"
    local manifest_result=$?
    
    # Generate report
    generate_report "$image" "$sig_result" "$sbom_result" "$vuln_result" "$manifest_result"
    
    # Cleanup
    cleanup
    
    # Exit with appropriate code
    if [ "$sig_result" -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--registry)
            REGISTRY="$2"
            shift 2
            ;;
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "$REPOSITORY" ]; then
                REPOSITORY="$1"
            else
                echo "Multiple repositories specified. Please provide only one."
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate required arguments
if [ -z "$REPOSITORY" ]; then
    echo -e "${RED}Error: Repository name is required${NC}"
    usage
    exit 1
fi

# Check dependencies
check_dependencies

# Run main function
main