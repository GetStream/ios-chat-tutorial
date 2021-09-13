#!/usr/bin/env bash
set -euo pipefail

mint run swiftformat --config .swiftformat ChatDemo --exclude **/Generated
