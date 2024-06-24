{
  description = "Test environment for making gazelle_rust work";
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };
  };
  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      bazel-env = pkgs.buildFHSEnv {
        name = "bazel-env";
        targetPkgs = _pkgs:
          [
            pkgs.bazelisk
            pkgs.bazel-buildtools
            pkgs.zlib
          ];
        extraBuildCommands = ''
          ln -s /usr/bin/bazelisk $out/usr/bin/bazel
        '';
      };
    in
      {
        devShells.x86_64-linux.default = pkgs.mkShell {
          nativeBuildInputs = [bazel-env];
        };
      };
}
