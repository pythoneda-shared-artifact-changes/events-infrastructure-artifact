# events-infrastructure/flake.nix
#
# This file packages pythoneda-shared-artifact-changes/events-infrastructure as a Nix flake.
#
# Copyright (C) 2023-today rydnr's pythoneda-shared-artifact-changes/events-infrastructure-artifact
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description =
    "Shared kernel for pythoneda-shared-artifact-changes/events-infrastructure";
  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-shared-artifact-changes-events = {
      url =
        "github:pythoneda-shared-artifact-changes/events-artifact/0.0.1a16?dir=events";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-artifact-changes-shared.follows =
        "pythoneda-shared-artifact-changes-shared";
      inputs.pythoneda-shared-code-requests-events.follows =
        "pythoneda-shared-code-requests-events";
      inputs.pythoneda-shared-code-requests-shared.follows =
        "pythoneda-shared-code-requests-shared";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-artifact-changes-shared = {
      url =
        "github:pythoneda-shared-artifact-changes/shared-artifact/0.0.1a10?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-code-requests-events = {
      url =
        "github:pythoneda-shared-code-requests/events-artifact/0.0.1a6?dir=events";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-artifact-changes-shared.follows =
        "pythoneda-shared-artifact-changes-shared";
      inputs.pythoneda-shared-code-requests-shared.follows =
        "pythoneda-shared-code-requests-shared";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-code-requests-shared = {
      url =
        "github:pythoneda-shared-code-requests/shared-artifact/0.0.1a6?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-git-shared = {
      url = "github:pythoneda-shared-git/shared-artifact/0.0.1a14?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-pythoneda-banner = {
      url = "github:pythoneda-shared-pythoneda/banner/0.0.1a16";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-shared-pythoneda-domain = {
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact/0.0.1a37?dir=domain";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
    };
    pythoneda-shared-pythoneda-infrastructure = {
      url =
        "github:pythoneda-shared-pythoneda/infrastructure-artifact/0.0.1a23?dir=infrastructure";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "pythoneda-shared-artifact-changes";
        repo = "events-infrastructure";
        version = "0.0.1a5";
        sha256 = "sha256-OLF7DepdfbGTh3mmKLFBAxv/K7JCc57i9XVeTJtu/QI=";
        pname = "${org}-${repo}";
        pythonpackage =
          "pythoneda.shared.artifact_changes.events.infrastructure";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        description =
          "Shared kernel for pythoneda-shared-artifact-changes/events-infrastructure";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        archRole = "E";
        space = "D";
        layer = "I";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease = "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythoneda-banner}/nix/shared.nix";
        pkgs = import nixos { inherit system; };
        pythoneda-shared-artifact-changes-events-infrastructure-for = { python
          , pythoneda-shared-artifact-changes-events
          , pythoneda-shared-artifact-changes-shared
          , pythoneda-shared-code-requests-events
          , pythoneda-shared-code-requests-shared, pythoneda-shared-git-shared
          , pythoneda-shared-pythoneda-domain
          , pythoneda-shared-pythoneda-infrastructure }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTemplateFile = ./pyprojecttoml.template;
            pyprojectTemplate = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage package pname pythonMajorMinorVersion
                pythonpackage version;
              dbusNextVersion = python.pkgs.dbus-next.version;
              grpcioVersion = python.pkgs.grpcio.version;
              pythonedaSharedArtifactChangesEventsVersion =
                pythoneda-shared-artifact-changes-events.version;
              pythonedaSharedArtifactChangesSharedVersion =
                pythoneda-shared-artifact-changes-shared.version;
              pythonedaSharedCodeRequestsEventsVersion =
                pythoneda-shared-code-requests-events.version;
              pythonedaSharedCodeRequestsSharedVersion =
                pythoneda-shared-code-requests-shared.version;
              pythonedaSharedGitSharedVersion =
                pythoneda-shared-git-shared.version;
              pythonedaSharedPythonedaDomainVersion =
                pythoneda-shared-pythoneda-domain.version;
              pythonedaSharedPythonedaInfrastructureVersion =
                pythoneda-shared-pythoneda-infrastructure.version;
              requestsVersion = python.pkgs.requests.version;
              src = pyprojectTemplateFile;
              unidiffVersion = python.pkgs.unidiff.version;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              grpcio
              pythoneda-shared-artifact-changes-events
              pythoneda-shared-artifact-changes-shared
              pythoneda-shared-code-requests-events
              pythoneda-shared-code-requests-shared
              pythoneda-shared-git-shared
              pythoneda-shared-pythoneda-domain
              pythoneda-shared-pythoneda-infrastructure
              requests
              unidiff
            ];

            pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod +w $sourceRoot
              cp ${pyprojectTemplate} $sourceRoot/pyproject.toml
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default =
            pythoneda-shared-artifact-changes-events-infrastructure-default;
          pythoneda-shared-artifact-changes-events-infrastructure-default =
            pythoneda-shared-artifact-changes-events-infrastructure-python310;
          pythoneda-shared-artifact-changes-events-infrastructure-python38 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-infrastructure-python38;
              python = pkgs.python38;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-infrastructure-python39;
              python = pkgs.python39;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-infrastructure-python310;
              python = pkgs.python310;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
        };
        packages = rec {
          default =
            pythoneda-shared-artifact-changes-events-infrastructure-default;
          pythoneda-shared-artifact-changes-events-infrastructure-default =
            pythoneda-shared-artifact-changes-events-infrastructure-python310;
          pythoneda-shared-artifact-changes-events-infrastructure-python38 =
            pythoneda-shared-artifact-changes-events-infrastructure-for {
              python = pkgs.python38;
              pythoneda-shared-artifact-changes-events =
                pythoneda-shared-artifact-changes-events.packages.${system}.pythoneda-shared-artifact-changes-events-python38;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-python38;
              pythoneda-shared-code-requests-events =
                pythoneda-shared-code-requests-events.packages.${system}.pythoneda-shared-code-requests-events-python38;
              pythoneda-shared-code-requests-shared =
                pythoneda-shared-code-requests-shared.packages.${system}.pythoneda-shared-code-requests-shared-python38;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-python38;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-python39 =
            pythoneda-shared-artifact-changes-events-infrastructure-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-changes-events =
                pythoneda-shared-artifact-changes-events.packages.${system}.pythoneda-shared-artifact-changes-events-python39;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-events-python39;
              pythoneda-shared-code-requests-events =
                pythoneda-shared-code-requests-events.packages.${system}.pythoneda-shared-code-requests-events-python39;
              pythoneda-shared-code-requests-shared =
                pythoneda-shared-code-requests-shared.packages.${system}.pythoneda-shared-code-requests-shared-python39;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-python39;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-python310 =
            pythoneda-shared-artifact-changes-events-infrastructure-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-changes-events =
                pythoneda-shared-artifact-changes-events.packages.${system}.pythoneda-shared-artifact-changes-events-python310;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-python310;
              pythoneda-shared-code-requests-events =
                pythoneda-shared-code-requests-events.packages.${system}.pythoneda-shared-code-requests-events-python310;
              pythoneda-shared-code-requests-shared =
                pythoneda-shared-code-requests-shared.packages.${system}.pythoneda-shared-code-requests-shared-python310;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-python310;
            };
        };
      });
}
