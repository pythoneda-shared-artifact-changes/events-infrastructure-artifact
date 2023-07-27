{
  description =
    "Shared kernel for pythoneda-shared-artifact-changes/events infrastructure";
  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-shared-artifact-changes-events = {
      url =
        "github:pythoneda-shared-artifact-changes/events-artifact/0.0.1a5?dir=events";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      inputs.pythoneda-shared-artifact-changes-shared.follows =
        "pythoneda-shared-artifact-changes-shared";
    };
    pythoneda-shared-artifact-changes-shared = {
      url =
        "github:pythoneda-shared-artifact-changes/shared-artifact/0.0.1a2?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-git-shared = {
      url = "github:pythoneda-shared-git/shared-artifact/0.0.1a7?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-pythoneda-domain = {
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact/0.0.1a26?dir=domain";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-shared-pythoneda-infrastructure = {
      url =
        "github:pythoneda-shared-pythoneda/infrastructure-artifact/0.0.1a14?dir=infrastructure";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        pname = "pythoneda-shared-artifact-changes-events-infrastructure";
        pythonpackage =
          "pythoneda.shared.artifact_changes.events.infrastructure";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        description =
          "Shared kernel for pythoneda-shared-artifact-changes/events infrastructure";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-shared-artifact-changes/events-infrastructure";
        maintainers = [ "rydnr <github@acm-sl.org>" ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/shared.nix;
        pythoneda-shared-artifact-changes-events-infrastructure-for = { python
          , pythoneda-shared-artifact-changes-events
          , pythoneda-shared-artifact-changes-shared
          , pythoneda-shared-git-shared, pythoneda-shared-pythoneda-domain
          , pythoneda-shared-pythoneda-infrastructure, sha256, version }:
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
              owner = "pythoneda-shared-artifact-changes";
              repo = "events-infrastructure";
              rev = version;
              inherit sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              grpcio
              pythoneda-shared-artifact-changes-events
              pythoneda-shared-artifact-changes-shared
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
        pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-for =
          { python, pythoneda-shared-artifact-changes-events
          , pythoneda-shared-artifact-changes-shared
          , pythoneda-shared-git-shared, pythoneda-shared-pythoneda-domain
          , pythoneda-shared-pythoneda-infrastructure }:
          pythoneda-shared-artifact-changes-events-infrastructure-for {
            version = "0.0.1a1";
            sha256 = "sha256-uubxzrow++QhfLnPL3TdbZy1tx1u5H91c+FnqgS6MQY=";
            inherit python pythoneda-shared-artifact-changes-events
              pythoneda-shared-artifact-changes-shared
              pythoneda-shared-git-shared pythoneda-shared-pythoneda-domain
              pythoneda-shared-pythoneda-infrastructure;
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python38 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python38;
              python = pkgs.python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python38;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python39;
              python = pkgs.python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python310;
              python = pkgs.python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-latest-python38 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python38;
          pythoneda-shared-artifact-changes-events-infrastructure-latest-python39 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python39;
          pythoneda-shared-artifact-changes-events-infrastructure-latest-python310 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python310;
          pythoneda-shared-artifact-changes-events-infrastructure-latest =
            pythoneda-shared-artifact-changes-events-infrastructure-latest-python310;
          default =
            pythoneda-shared-artifact-changes-events-infrastructure-latest;
        };
        packages = rec {
          default =
            pythoneda-shared-artifact-changes-events-infrastructure-latest;
          pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python38 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-for {
              python = pkgs.python38;
              pythoneda-shared-artifact-changes-events =
                pythoneda-shared-artifact-changes-events.packages.${system}.pythoneda-shared-artifact-changes-events-latest-python38;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-latest-python38;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-latest-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python38;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-latest-python38;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python39 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-changes-events =
                pythoneda-shared-artifact-changes-events.packages.${system}.pythoneda-shared-artifact-changes-events-latest-python39;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-events-latest-python39;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-latest-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python39;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-latest-python39;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python310 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-changes-events =
                pythoneda-shared-artifact-changes-events.packages.${system}.pythoneda-shared-artifact-changes-events-latest-python310;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-latest-python310;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-latest-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python310;
              pythoneda-shared-pythoneda-infrastructure =
                pythoneda-shared-pythoneda-infrastructure.packages.${system}.pythoneda-shared-pythoneda-infrastructure-latest-python310;
            };
          pythoneda-shared-artifact-changes-events-infrastructure-latest-python38 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python38;
          pythoneda-shared-artifact-changes-events-infrastructure-latest-python39 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python39;
          pythoneda-shared-artifact-changes-events-infrastructure-latest-python310 =
            pythoneda-shared-artifact-changes-events-infrastructure-0_0_1a1-python310;
          pythoneda-shared-artifact-changes-events-infrastructure-latest =
            pythoneda-shared-artifact-changes-events-infrastructure-latest-python310;
        };
      });
}
