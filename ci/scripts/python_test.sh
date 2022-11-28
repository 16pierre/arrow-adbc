#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e

: ${BUILD_ALL:=1}
: ${BUILD_DRIVER_MANAGER:=${BUILD_ALL}}
: ${BUILD_DRIVER_POSTGRES:=${BUILD_ALL}}

test_subproject() {
    local -r source_dir=${1}
    local -r install_dir=${2}
    local -r subproject=${3}

    if [[ "${subproject}" -eq "adbc_driver_manager" ]]; then
        env \
            DYLD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${install_dir}/lib" \
            LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${install_dir}/lib" \
            python -m pytest -vv "${source_dir}/python/${subproject}/tests"
    else
        python -m pytest -vv "${source_dir}/python/${subproject}/tests"
    fi
}

main() {
    local -r source_dir="${1}"
    local -r build_dir="${2}"
    local install_dir="${3}"

    if [[ -z "${install_dir}" ]]; then
        install_dir="${build_dir}/local"
    fi

    if [[ "${BUILD_DRIVER_MANAGER}" -gt 0 ]]; then
        test_subproject "${source_dir}" "${install_dir}" adbc_driver_manager
    fi

    if [[ "${BUILD_DRIVER_POSTGRES}" -gt 0 ]]; then
        test_subproject "${source_dir}" "${install_dir}" adbc_driver_postgres
    fi
}

main "$@"