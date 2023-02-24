{
  description = "ESP8266/ESP32 development tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    overlay = import ./overlay.nix;
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system;
                              overlays = [ self.overlay ];
                              config = {
                                allowBroken = true;
                                permittedInsecurePackages = [
                                  "python-2.7.18.6"
                                ]; 
                              };

                            };
      
    in
    {
      packages = {
        inherit (pkgs)
          gcc-riscv32-esp32c3-elf-bin
          gcc-xtensa-esp32-elf-bin
          gcc-xtensa-esp32s2-elf-bin
          gcc-xtensa-esp32s3-elf-bin
          openocd-esp32-bin
          esp-idf

          gcc-xtensa-lx106-elf-bin
          crosstool-ng-xtensa
          gcc-xtensa-lx106-elf

          llvm-xtensa;
      };

      devShells = {
        esp32c3-idf = import ./shells/esp32c3-idf.nix { inherit pkgs; };
        esp32s2-idf = import ./shells/esp32s2-idf.nix { inherit pkgs; };
        esp32s2-idf-rust = import ./shells/esp32s2-idf-rust.nix { inherit pkgs; };
        esp32s3-idf = import ./shells/esp32s3-idf.nix { inherit pkgs; };
        esp32-idf = import ./shells/esp32-idf.nix { inherit pkgs; };
        esp8266 = import ./shells/esp8266.nix { inherit pkgs; };
      };
      # rust-xtensa = (import ./pkgs/xtensa-rust-bin.nix { rust = pkgs.rust; callPackage = pkgs.callPackage; lib = pkgs.lib; stdenv = pkgs.stdenv; fetchurl = pkgs.fetchurl;});

    });
    # xtensa-rust = 

}

