# shellcheck shell=bats
#
# Copyright © 2020 – 2023 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/helpers.bash'

setup() {
  _setup_environment
}

@test "help: Smoke test" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX"

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: missing command"
  assert_line --index 2 "create    Create a new toolbox container"
  assert_line --index 3 "enter     Enter an existing toolbox container"
  assert_line --index 4 "list      List all existing toolbox containers and images"
  assert_line --index 6 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 7 ]
}

@test "help: Command 'help'" {
  if ! command -v man 2>/dev/null; then
    skip "not found man(1)"
  fi

  run --keep-empty-lines --separate-stderr "$TOOLBOX" help

  assert_success
  assert_line --index 0 --partial "toolbox(1)"
  assert_line --index 0 --partial "General Commands Manual"
  assert_line --index 3 --regexp "^[[:blank:]]+toolbox [‐-] Tool for containerized command line environments on Linux$"
  assert [ ${#lines[@]} -gt 4 ]
  assert [ ${#stderr_lines[@]} -eq 0 ]
}

@test "help: Command 'help' with man(1) absent" {
  if command -v man 2>/dev/null; then
    skip "found man(1)"
  fi

  run --keep-empty-lines --separate-stderr "$TOOLBOX" help

  assert_success
  assert_line --index 0 "toolbox - Tool for containerized command line environments on Linux"
  assert_line --index 2 "Common commands are:"
  assert_line --index 3 "create    Create a new toolbox container"
  assert_line --index 4 "enter     Enter an existing toolbox container"
  assert_line --index 5 "list      List all existing toolbox containers and images"
  assert_line --index 7 "Go to https://github.com/containers/toolbox for further information."
  assert [ ${#lines[@]} -eq 8 ]
  assert [ ${#stderr_lines[@]} -eq 0 ]
}

@test "help: Flag '--help'" {
  if ! command -v man 2>/dev/null; then
    skip "not found man(1)"
  fi

  run --keep-empty-lines --separate-stderr "$TOOLBOX" --help

  assert_success
  assert_line --index 0 --partial "toolbox(1)"
  assert_line --index 0 --partial "General Commands Manual"
  assert_line --index 3 --partial "toolbox - Tool for containerized command line environments on Linux"
  assert [ ${#lines[@]} -gt 4 ]
  assert [ ${#stderr_lines[@]} -eq 0 ]
}

@test "help: Flag '--help' with man(1) absent" {
  if command -v man 2>/dev/null; then
    skip "found man(1)"
  fi

  run --keep-empty-lines --separate-stderr "$TOOLBOX" --help

  assert_success
  assert_line --index 0 "toolbox - Tool for containerized command line environments on Linux"
  assert_line --index 2 "Common commands are:"
  assert_line --index 3 "create    Create a new toolbox container"
  assert_line --index 4 "enter     Enter an existing toolbox container"
  assert_line --index 5 "list      List all existing toolbox containers and images"
  assert_line --index 7 "Go to https://github.com/containers/toolbox for further information."

  if check_bats_version 1.10.0; then
    assert [ ${#lines[@]} -eq 8 ]
  else
    assert [ ${#lines[@]} -eq 9 ]
  fi

  # shellcheck disable=SC2154
  assert [ ${#stderr_lines[@]} -eq 0 ]
}

@test "help: Try unknown command" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown command \"foo\" for \"toolbox\""
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'create' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" create --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'enter' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" enter --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'help' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" help --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'init-container' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" init-container --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'list' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" list --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'rm' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" rm --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'rmi' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" rmi --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}

@test "help: Try 'run' with unknown flag" {
  run --keep-empty-lines --separate-stderr "$TOOLBOX" run --foo

  assert_failure
  assert [ ${#lines[@]} -eq 0 ]
  lines=("${stderr_lines[@]}")
  assert_line --index 0 "Error: unknown flag: --foo"
  assert_line --index 1 "Run 'toolbox --help' for usage."
  assert [ ${#stderr_lines[@]} -eq 2 ]
}
