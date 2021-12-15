{ pkgs ? import <nixpkgs> { } }:
let
  packer = pkgs.stdenv.mkDerivation {
    name = "packer-1.7.4";
    src = builtins.fetchurl https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip;
    buildInputs = [ pkgs.unzip ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/bin
      mv packer $out/bin/packer
    '';
  };
  virtio = pkgs.stdenv.mkDerivation {
    name = "virtio-latest";
    src = builtins.fetchurl https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.noarch.rpm;
    buildInputs = [ pkgs.rpmextract ];
    unpackPhase = ''
      rpmextract $src
    '';
    installPhase = ''
      mkdir -p $out
      mv ./usr/share $out/
    '';
  };
in
pkgs.stdenv.mkDerivation {
  name = "packer-env";
  buildInputs = with pkgs; [ packer pkgs.qemu_kvm pkgs.xorriso ];
  shellHook = ''
    cd ./windows
  '';
}
